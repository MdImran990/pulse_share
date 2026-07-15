# 🧠 Architectural & Technical Decisions

This document outlines the architectural patterns, library integrations, and low-level technical decisions made while designing the **Pulse Share** application.

---

## 🏗️ 1. Architecture: Clean Architecture (Feature-First)

**Decision:** Organize folders using a Feature-First Clean Architecture structure (e.g. `features/dashboard/`, `features/share/`, `features/received/`).

**Rationale:**
- **Encapsulation:** Grouping code by feature places the related UI, business states, and helpers together, making features extremely self-contained and modular.
- **Maintainability:** Adding a new screen or modifying business logic is isolated within that feature directory, dramatically reducing the surface area of potential bugs.
- **Scale:** Multiple developers can work on separate features concurrently with zero code collisions in the presentation layer.

---

## 🎛️ 2. State Management & DI: GetX

**Decision:** Leverage **GetX** for Reactive state updates, Dependency Injection, and routing.

**Rationale:**
- **Zero-Boilerplate Reactivity:** The use of `.obs` and `Obx` widgets allows instantaneous UI updates on telemetry updates without the heavy boilerplate associated with BLoC or standard `setState` structures.
- **Clean Bindings:** GetX's dependency bindings (`InitialBinding`, `ShareBinding`) cleanly declare dependencies before screens are initiated, ensuring a solid lifecycle pattern.
- **Permanent Globals:** By setting `ReceivedController` as `permanent: true`, we keep the background TCP server active in memory globally across all screens, allowing peer packets to be received immediately from anywhere.

---

## 🔌 3. Native Integration: Hybrid Approach (Custom Kotlin Channels)

**Decision:** We combined standard Flutter plugins (`battery_plus`, `device_info_plus`, `network_info_plus`) with bespoke Kotlin platform integrations via Method Channels.

**Rationale:**
- **SIM dBm Accuracy:** Standard Flutter packages cannot fetch raw SIM signal strength or complex cell info without triggering platform-level crashes or missing data. We bypassed this by registering a direct cellular info collector in Kotlin.
- **Battery Health/Temp:** Traditional plugins often hide hardware metrics like Battery Temperature (Celsius) and Battery Health. We resolved this by querying the system's sticky `ACTION_BATTERY_CHANGED` intent directly in native code.
- **Dynamic Activity State Fallback:** The Android `ActivityRecognitionClient` requires Google Play Services, which is absent in many emulators and custom ROMs. To guarantee reliability, we wrote a native accelerometer filter in Kotlin that monitors **magnitude variance** over a moving window to accurately classify movement patterns—completely independent of Google services.

---

## 📡 4. P2P Networking: mDNS (NsdManager) & TCP Sockets

**Decision:** Implement peer discovery via Android's `NsdManager` over Method Channels, and transmit payloads via `dart:io` TCP Sockets on Port 4040.

**Rationale:**
- **Zero Manual IP Configuration:** Users can instantly share data point-to-point without typing complex IP addresses. mDNS automatically registers `Pulse_DeviceName` as service `_pulseshare._tcp.` and resolves the host details.
- **Robustness:** Native `NsdManager` avoids third-party package compile failures and works at the system level.
- **Simplicity of Sockets:** Raw TCP Sockets (`ServerSocket` / `Socket`) are fast, built-in, require zero external dependencies, and are highly secure as data stays strictly within the local router boundary.

---

## 📦 5. Storage: Hive Database

**Decision:** Persist received snapshots as structured raw Maps in a local Hive NoSQL database.

**Rationale:**
- **Performance:** Hive is written in pure Dart and is orders of magnitude faster than SQFlite, ensuring zero UI lags when saving telemetry data.
- **Dynamic Schema:** Received snapshots are easily mapped to and from standard JSON-like Dart structures without generating multiple complex DB adapters, keeping the codebase extremely lean.

---

## ⚠️ 6. Platform Limitations & Explanations

1. **Location Dependency for Wi-Fi SSID / RSSI:**
   - *Android API Restriction:* Since Android 9 (Pie) and Android 10, retrieving the current Wi-Fi name (SSID) or Signal Strength (RSSI) is classified as a location-revealing action. The app must have `ACCESS_FINE_LOCATION` granted at runtime; otherwise, Android returns `<unknown ssid>` and RSSI `-127`.
2. **CellInfo dBm Permission Requirements:**
   - *Android API Restriction:* Calling `TelephonyManager.getAllCellInfo()` on Android 10+ requires both `READ_PHONE_STATE` and `ACCESS_FINE_LOCATION`. If any of these are missing, it throws a SecurityException. We have gracefully handled this by returning `"Permission Required"` on the UI rather than crashing the thread.
3. **Emulator Step Counter Limitation:**
   - *Hardware Restriction:* Android Emulators do not always support or emulate physical hardware step counters (`Sensor.TYPE_STEP_COUNTER`). On devices lacking this sensor, the step count will gracefully remain at `"0"`.
