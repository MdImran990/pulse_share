# Pulse Share 🫀🔌

Pulse Share is a high-performance, production-grade Flutter application built for Android that aggregates real-time hardware telemetry and health insights directly from real Android APIs. It enables users to securely broadcast and share their device snapshots point-to-point with nearby peers over the local Wi-Fi network using Network Service Discovery (NSD/mDNS) and TCP Sockets—completely without cloud dependencies.

---

## 🏗️ Architecture & Folder Structure

This project follows **Clean Architecture** with a **Feature-first** structural approach. This ensures complete separation of concerns, high testability, and exceptional scale capability.

### System Architecture Flow

```text
               +-------------------------------------------+
               |             Presentation Layer            |
               |  (Material 3 UI, GetX Views & Controllers)|
               +---------------------+---------------------+
                                     |
                                     v
               +---------------------+---------------------+
               |                Domain Layer               |
               |  (Business Rules, Abstract Repositories)  |
               +---------------------+---------------------+
                                     |
                                     v
               +---------------------+---------------------+
               |                 Data Layer                |
               |   (Hive Local DB, Socket Client/Server,   |
               |   Kotlin Native Method Channels, Models)  |
               +-------------------------------------------+
```

### Folder Breakdown

```text
lib/
├── app/                  # Application-wide routing, bindings, and global theme configurations
│   ├── bindings/         # Initial bindings for app start (Services & Controller injection)
│   ├── routes/           # Declarative app routes mapping using GetX
│   └── theme/            # Material 3 light/dark style specifications
│
├── core/                 # Shared system utilities, constants, permissions, and platform-bridges
│   ├── constants/        # Centralized non-magic constants
│   ├── permissions/      # Advanced Android runtime permission services
│   ├── platform/         # Native Method Channel bridges for hardware-level calls
│   ├── services/         # Orchestrators of business rules (Discovery, Socket, Battery, WiFi, Storage)
│   └── utils/            # Shared utilities like logger, date converters, etc.
│
├── data/                 # Concrete implementations of the system’s data contracts
│   ├── datasource/       # Low-level data handlers (Hive Database)
│   ├── models/           # Data Transfer Objects (DTOs) and serialization mapping
│   └── repository/       # Repository implementations coordinating local and remote sources
│
├── features/             # Feature-first modules with encapsulated state & views
│   ├── dashboard/        # Main screen monitoring real-time Android device metrics
│   ├── share/            # Nearby peer discovery interface and broadcast handlers
│   ├── received/         # History viewer of stored telemetry snapshots from other peers
│   └── splash/           # Launch/Intro screen ensuring quick configuration checks
│
└── widgets/              # Reusable, standalone presentation components
```

---

## 🔒 Permissions & Safety

To gather authentic hardware readings (not mocked) and operate peer-to-peer over local network infrastructure, the app utilizes native Android permissions:

1. **`ACCESS_FINE_LOCATION` & `ACCESS_COARSE_LOCATION`**:
   - *Why:* Android restricts retrieval of active Wi-Fi SSIDs, RSSI (signal dBm levels), and cellular network towers without Location Permissions.
2. **`READ_PHONE_STATE`**:
   - *Why:* Essential for extracting cellular carrier details (e.g., operator name, SIM state, and precise cell signal levels in dBm).
3. **`ACTIVITY_RECOGNITION`**:
   - *Why:* Required for capturing real-time user motion (Still, Walking, Running, etc.).
4. **`CHANGE_WIFI_MULTICAST_STATE`**:
   - *Why:* Required to enable mDNS/NSD service discovery packet broadcasting over standard Wi-Fi routers.

---

## 🔌 Platform Channels & Native Android Integration

Where standard Flutter plugins fall short, Pulse Share utilizes custom **Kotlin Method Channels** to access real Android system managers:

- **Battery Health & Temperature**: Registered a BroadcastReceiver watching `Intent.ACTION_BATTERY_CHANGED` to retrieve exact temperature values (in Celsius) and hardware health flags.
- **SIM Cellular Status**: Uses `TelephonyManager` to query active carrier name, SIM states, and parses registering `CellInfo` (LTE, GSM, WCDMA) to extract authentic cellular dBm values.
- **Physical Motion State Classification**: Registers standard accelerometer (`Sensor.TYPE_ACCELEROMETER`) and step counter (`Sensor.TYPE_STEP_COUNTER`) listeners. Computes real-time **acceleration variance over a moving-time window** to classify user motion dynamically (Still, Walking, Running, Vehicle)—a robust fallback that functions flawlessly on both Emulators and real hardware.
- **Wi-Fi Signal Levels (RSSI)**: Accesses `WifiManager.connectionInfo.rssi` to extract true dBm strength, preventing fake or hardcoded ratings.

---

## 📡 Local Network mDNS Discovery & Sockets

All networking occurs purely in the local Wi-Fi layer.

- **Peer Discovery**: Utilizes Android’s `NsdManager` via the custom `pulse_share/nsd` MethodChannel. Each device acts as both an NSD publisher (broadcasting service type `_pulseshare._tcp`) and a resolver.
- **Data Exchange**: When a user clicks "Share", the client connects directly to the discovered peer's IP address on **TCP Port 4040** (managed by a background `ServerSocket` in the `SocketService`). Data is transmitted as JSON payloads.
- **Local Storage**: Once received, snapshots are instantly persisted into a local **Hive NoSQL** box, and the user-facing history view updates reactively.

---

## 🚀 Getting Started

### Prerequisites

Ensure you have:
- Flutter SDK `>=3.8.0`
- Android Studio with SDK API 29+ (Android 10+)
- A physical Android device (recommended to test SIM carrier and signal dBm) or configured emulator with Location services active.

### Build & Run

```bash
# Get dependencies
flutter pub get

# Check for code analysis warnings
flutter analyze

# Run on connected device
flutter run
```
