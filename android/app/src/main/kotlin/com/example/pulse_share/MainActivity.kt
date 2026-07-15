package com.example.pulse_share

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import android.net.wifi.WifiManager
import android.os.BatteryManager
import android.os.Build
import android.telephony.CellInfo
import android.telephony.CellInfoLte
import android.telephony.CellInfoWcdma
import android.telephony.CellInfoGsm
import android.telephony.TelephonyManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.InetAddress
import kotlin.math.sqrt

class MainActivity : FlutterActivity(), SensorEventListener {

    companion object {
        private const val NATIVE_CHANNEL = "pulse_share/native"
        private const val NSD_CHANNEL = "pulse_share/nsd"
        private const val SERVICE_TYPE = "_pulseshare._tcp."
    }

    // Sensors
    private lateinit var sensorManager: SensorManager
    private var stepCounterSensor: Sensor? = null
    private var accelerometerSensor: Sensor? = null

    private var totalStepsSinceBoot: Float = 0f
    private var lastActivityState: String = "Still"

    // Motion parameters for simple activity recognition fallback
    private var lastMagnitude = 0f
    private val magnitudeWindow = ArrayList<Float>()
    private val windowSize = 20

    // NSD Managers
    private var nsdManager: NsdManager? = null
    private var registrationListener: NsdManager.RegistrationListener? = null
    private var discoveryListener: NsdManager.DiscoveryListener? = null
    
    // Discovered Peers
    private val discoveredPeersMap = HashMap<String, NsdServiceInfo>()

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize Sensors
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        stepCounterSensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
        accelerometerSensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)

        stepCounterSensor?.let {
            sensorManager.registerListener(this, it, SensorManager.SENSOR_DELAY_NORMAL)
        }
        accelerometerSensor?.let {
            sensorManager.registerListener(this, it, SensorManager.SENSOR_DELAY_NORMAL)
        }

        // Initialize NSD
        nsdManager = getSystemService(Context.NSD_SERVICE) as NsdManager

        // Native System Channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            NATIVE_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getBatteryInfo" -> {
                    val batteryInfo = getBatteryDetails()
                    result.success(batteryInfo)
                }
                "getSensorInfo" -> {
                    val sensorInfo = mapOf(
                        "stepCount" to totalStepsSinceBoot.toInt().toString(),
                        "activity" to lastActivityState
                    )
                    result.success(sensorInfo)
                }
                "getSimInfo" -> {
                    val simInfo = getSimDetails()
                    result.success(simInfo)
                }
                "getWifiRssi" -> {
                    val rssi = getWifiRssiValue()
                    result.success(rssi)
                }
                else -> result.notImplemented()
            }
        }

        // NSD Control Channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            NSD_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "registerService" -> {
                    val name = call.argument<String>("name") ?: "PulseDevice"
                    val port = call.argument<Int>("port") ?: 4040
                    registerNsdService(name, port)
                    result.success(true)
                }
                "unregisterService" -> {
                    unregisterNsdService()
                    result.success(true)
                }
                "startDiscovery" -> {
                    startNsdDiscovery()
                    result.success(true)
                }
                "stopDiscovery" -> {
                    stopNsdDiscovery()
                    result.success(true)
                }
                "getDiscoveredPeers" -> {
                    val list = getDiscoveredPeersList()
                    result.success(list)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        sensorManager.unregisterListener(this)
        unregisterNsdService()
        stopNsdDiscovery()
    }

    // ================= SENSORS =================

    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null) return

        if (event.sensor.type == Sensor.TYPE_STEP_COUNTER) {
            totalStepsSinceBoot = event.values[0]
        } else if (event.sensor.type == Sensor.TYPE_ACCELEROMETER) {
            val x = event.values[0]
            val y = event.values[1]
            val z = event.values[2]

            val mag = sqrt((x * x + y * y + z * z).toDouble()).toFloat()
            magnitudeWindow.add(mag)
            if (magnitudeWindow.size > windowSize) {
                magnitudeWindow.removeAt(0)
            }

            // Classify movement based on variance of magnitude
            if (magnitudeWindow.size == windowSize) {
                val mean = magnitudeWindow.average().toFloat()
                var sumOfSquares = 0f
                for (m in magnitudeWindow) {
                    sumOfSquares += (m - mean) * (m - mean)
                }
                val variance = sumOfSquares / windowSize

                lastActivityState = when {
                    variance < 0.15 -> "Still"
                    variance < 2.0 -> "Walking"
                    variance < 8.0 -> "Running"
                    else -> "Vehicle"
                }
            }
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    // ================= BATTERY DETAILS =================

    private fun getBatteryDetails(): Map<String, Any> {
        val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        val batteryStatus: Intent? = context.registerReceiver(null, filter)

        val level = batteryStatus?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
        val scale = batteryStatus?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
        val batteryPct = if (level >= 0 && scale > 0) (level * 100 / scale.toFloat()).toInt() else level

        val rawTemp = batteryStatus?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0) ?: 0
        val temp = rawTemp / 10.0

        val healthRaw = batteryStatus?.getIntExtra(BatteryManager.EXTRA_HEALTH, BatteryManager.BATTERY_HEALTH_UNKNOWN)
            ?: BatteryManager.BATTERY_HEALTH_UNKNOWN

        val healthStr = when (healthRaw) {
            BatteryManager.BATTERY_HEALTH_GOOD -> "Good"
            BatteryManager.BATTERY_HEALTH_OVERHEAT -> "Overheated"
            BatteryManager.BATTERY_HEALTH_DEAD -> "Dead"
            BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> "Over Voltage"
            BatteryManager.BATTERY_HEALTH_COLD -> "Cold"
            BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE -> "Failure"
            else -> "Unknown"
        }

        return mapOf(
            "level" to batteryPct,
            "temperature" to temp,
            "health" to healthStr
        )
    }

    // ================= SIM CARD DETAILS =================

    private fun getSimDetails(): Map<String, String> {
        val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        
        val carrierName = telephonyManager.simOperatorName.let { 
            if (it.isNullOrEmpty()) telephonyManager.networkOperatorName else it
        }.let {
            if (it.isNullOrEmpty()) "No SIM Card" else it
        }

        val simStateRaw = telephonyManager.simState
        val simStateStr = when (simStateRaw) {
            TelephonyManager.SIM_STATE_ABSENT -> "Absent"
            TelephonyManager.SIM_STATE_PIN_REQUIRED -> "PIN Required"
            TelephonyManager.SIM_STATE_PUK_REQUIRED -> "PUK Required"
            TelephonyManager.SIM_STATE_NETWORK_LOCKED -> "Network Locked"
            TelephonyManager.SIM_STATE_READY -> "Ready"
            TelephonyManager.SIM_STATE_NOT_READY -> "Not Ready"
            TelephonyManager.SIM_STATE_PERM_DISABLED -> "Permanently Disabled"
            TelephonyManager.SIM_STATE_CARD_IO_ERROR -> "Card IO Error"
            else -> "Unknown"
        }

        var signalStrengthDbm = "--"
        try {
            // Retrieve SIM signal strength
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                // Check cell info
                val cellInfos = telephonyManager.allCellInfo
                if (cellInfos != null) {
                    for (info in cellInfos) {
                        if (info.isRegistered) {
                            if (info is CellInfoLte) {
                                signalStrengthDbm = "${info.cellSignalStrength.dbm} dBm"
                                break
                            } else if (info is CellInfoWcdma) {
                                signalStrengthDbm = "${info.cellSignalStrength.dbm} dBm"
                                break
                            } else if (info is CellInfoGsm) {
                                signalStrengthDbm = "${info.cellSignalStrength.dbm} dBm"
                                break
                            }
                        }
                    }
                }
            }
        } catch (e: SecurityException) {
            signalStrengthDbm = "Permission Required"
        } catch (e: Exception) {
            signalStrengthDbm = "--"
        }

        return mapOf(
            "carrierName" to carrierName,
            "simState" to simStateStr,
            "signalStrength" to signalStrengthDbm
        )
    }

    // ================= WIFI RSSI =================

    private fun getWifiRssiValue(): String {
        return try {
            val wifiManager = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
            val connectionInfo = wifiManager.connectionInfo
            if (connectionInfo != null && connectionInfo.networkId != -1) {
                val rssi = connectionInfo.rssi
                "$rssi dBm"
            } else {
                "Not Connected"
            }
        } catch (e: Exception) {
            "--"
        }
    }

    // ================= NSD / mDNS SERVICES =================

    private fun registerNsdService(deviceName: String, port: Int) {
        unregisterNsdService()

        val serviceInfo = NsdServiceInfo().apply {
            serviceName = "Pulse_${deviceName.replace(" ", "_")}"
            serviceType = SERVICE_TYPE
            setPort(port)
        }

        registrationListener = object : NsdManager.RegistrationListener {
            override fun onServiceRegistered(NsdServiceInfo: NsdServiceInfo) {
                // Service registered successfully
            }

            override fun onRegistrationFailed(serviceInfo: NsdServiceInfo, errorCode: Int) {
                // Registration failed
            }

            override fun onServiceUnregistered(arg0: NsdServiceInfo) {
                // Service unregistered
            }

            override fun onUnregistrationFailed(serviceInfo: NsdServiceInfo, errorCode: Int) {
                // Unregistration failed
            }
        }

        nsdManager?.registerService(serviceInfo, NsdManager.PROTOCOL_DNS_SD, registrationListener)
    }

    private fun unregisterNsdService() {
        registrationListener?.let {
            nsdManager?.unregisterService(it)
            registrationListener = null
        }
    }

    private fun startNsdDiscovery() {
        stopNsdDiscovery()
        discoveredPeersMap.clear()

        discoveryListener = object : NsdManager.DiscoveryListener {
            override fun onStartDiscoveryFailed(serviceType: String, errorCode: Int) {
                stopNsdDiscovery()
            }

            override fun onStopDiscoveryFailed(serviceType: String, errorCode: Int) {
                stopNsdDiscovery()
            }

            override fun onDiscoveryStarted(serviceType: String) {
                // Discovery started
            }

            override fun onDiscoveryStopped(serviceType: String) {
                // Discovery stopped
            }

            override fun onServiceFound(serviceInfo: NsdServiceInfo) {
                if (serviceInfo.serviceType == SERVICE_TYPE) {
                    // Avoid resolving our own registered service to prevent duplicates
                    nsdManager?.resolveService(serviceInfo, object : NsdManager.ResolveListener {
                        override fun onResolveFailed(serviceInfo: NsdServiceInfo, errorCode: Int) {
                            // Resolve failed
                        }

                        override fun onServiceResolved(resolvedServiceInfo: NsdServiceInfo) {
                            val name = resolvedServiceInfo.serviceName
                            val hostAddress = resolvedServiceInfo.host?.hostAddress
                            if (hostAddress != null) {
                                discoveredPeersMap[name] = resolvedServiceInfo
                            }
                        }
                    })
                }
            }

            override fun onServiceLost(serviceInfo: NsdServiceInfo) {
                discoveredPeersMap.remove(serviceInfo.serviceName)
            }
        }

        nsdManager?.discoverServices(SERVICE_TYPE, NsdManager.PROTOCOL_DNS_SD, discoveryListener)
    }

    private fun stopNsdDiscovery() {
        discoveryListener?.let {
            nsdManager?.stopServiceDiscovery(it)
            discoveryListener = null
        }
    }

    private fun getDiscoveredPeersList(): List<Map<String, Any>> {
        val list = ArrayList<Map<String, Any>>()
        for ((name, service) in discoveredPeersMap) {
            val ip = service.host?.hostAddress ?: ""
            val port = service.port
            list.add(mapOf(
                "name" to name,
                "ip" to ip,
                "port" to port
            ))
        }
        return list
    }
}
