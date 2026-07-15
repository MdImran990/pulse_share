# 📝 Developer Notes & Testing Guides

These notes contain practical guides for testing the **Pulse Share** peer-to-peer capabilities and resolving common local networking bugs.

---

## 🛠️ How to Test P2P on a Single Computer (Dual Emulators)

If you do not have two physical Android devices, you can easily verify peer discovery and socket transfers by launching **two distinct Emulators** inside Android Studio:

### Step 1: Launch Emulators
Open Android Device Manager and launch:
1. Emulator A (e.g., Pixel 7 - API 33)
2. Emulator B (e.g., Pixel 6 - API 30)

### Step 2: Establish Local Loopback Port Redirections
Android Emulators reside on separate isolated local networks behind an internal router. To allow them to communicate directly over TCP, you must establish port forward redirections using the Android Debug Bridge (ADB):

1. **Find emulator ports:**
   Run:
   ```bash
   adb devices
   ```
   *Example output:*
   ```text
   emulator-5554   device
   emulator-5556   device
   ```
   (Here, 5554 is Emulator A, and 5556 is Emulator B).

2. **Redirect Port 4040:**
   Tell ADB to forward incoming connections on port `4040` of Emulator A to Emulator B, or vice versa.
   ```bash
   # Connect to emulator console and redirect port
   adb -s emulator-5554 forward tcp:4040 tcp:4040
   adb -s emulator-5556 reverse tcp:4040 tcp:4040
   ```

3. **Alternative: Test on Shared Physical Wi-Fi**
   For the most natural test, run the app on **two physical devices** (e.g., your phone and a colleague's phone) connected to the **exact same Wi-Fi router**. No port forwarding is required!

---

## 📡 Troubleshooting Wi-Fi Multicast Issues

mDNS/NSD works by broadcasting UDP multicast packets over the network. Some Wi-Fi routers block multicast traffic by default due to security settings or to preserve battery life. If devices fail to discover each other:

1. **Verify Shared Router:** Make sure both devices are on the **same SSID** and are not separated by a guest network isolation flag.
2. **Disable Guest Mode:** Router guest networks block client-to-client communication. Ensure you are connected to the main private network.
3. **Check Router "AP Isolation":** Disable Access Point (AP) Isolation (sometimes called Client Isolation or WLAN Isolation) inside your Wi-Fi router settings. AP isolation prevents wireless clients from communicating with each other.
4. **Enable Multicast:** Ensure "IGMP Snooping" or "Multicast" is enabled in your router's wireless options.

---

## 🔬 Analyzing Native Telemetry Values

- **Activity Recognition:** Tap/shake the device or emulator to see the motion change from **Still** to **Walking** or **Running**. The custom Kotlin variance calculation translates these motion impulses dynamically.
- **Battery Health:** Verify standard battery properties. On emulators, you can change the battery health states inside the Emulator Extended Controls menu (`...` icon -> Battery) to observe the values change live.
- **SIM Details:** On real physical hardware, SIM Operator and RSSI/dBm values will render live. On standard emulators without a SIM profile, the values gracefully render as `"No SIM Card"` and `"--"` signal.
