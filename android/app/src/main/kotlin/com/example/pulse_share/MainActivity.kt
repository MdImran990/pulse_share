package com.example.pulse_share

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val BATTERY_CHANNEL = "pulse_share/native"
        private const val NSD_CHANNEL = "pulse_share/nsd"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Battery Channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            BATTERY_CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                "getBatteryInfo" -> {
                    result.notImplemented()
                }

                else -> result.notImplemented()
            }
        }

        // NSD Channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            NSD_CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "startDiscovery" -> {
                    result.success(true)
                }

                "stopDiscovery" -> {
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }
    }
}