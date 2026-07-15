import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../data/models/network_info_model.dart';
import '../platform/wifi_platform.dart';

class WifiService {
  final NetworkInfo _networkInfo = NetworkInfo();
  final WifiPlatform _wifiPlatform = WifiPlatform();

  Future<NetworkInfoModel> getWifiInfo() async {
    final connectivity = await Connectivity().checkConnectivity();

    if (!connectivity.contains(ConnectivityResult.wifi)) {
      return NetworkInfoModel(
        wifiName: "Not Connected",
        ipAddress: "--",
        wifiSignal: "--",
      );
    }

    final wifiName = await _networkInfo.getWifiName();
    final ip = await _networkInfo.getWifiIP();
    final rssi = await _wifiPlatform.getWifiRssi();

    return NetworkInfoModel(
      wifiName: wifiName ?? "Unknown",
      ipAddress: ip ?? "--",
      wifiSignal: rssi,
    );
  }
}
