import 'package:flutter/services.dart';

import '../../data/models/peer_model.dart';
import '../utils/app_logger.dart';

class DiscoveryService {
  static const MethodChannel _nsdChannel = MethodChannel("pulse_share/nsd");

  /// Starts NSD peer discovery.
  Future<void> startDiscovery() async {
    try {
      await _nsdChannel.invokeMethod("startDiscovery");
      AppLogger.info("NSD peer discovery started successfully.");
    } catch (e) {
      AppLogger.error("Failed to start NSD discovery: $e");
    }
  }

  /// Stops NSD peer discovery.
  Future<void> stopDiscovery() async {
    try {
      await _nsdChannel.invokeMethod("stopDiscovery");
      AppLogger.info("NSD peer discovery stopped.");
    } catch (e) {
      AppLogger.error("Failed to stop NSD discovery: $e");
    }
  }

  /// Registers the local device on the network.
  Future<void> registerLocalService(String deviceName, int port) async {
    try {
      await _nsdChannel.invokeMethod("registerService", {
        "name": deviceName,
        "port": port,
      });
      AppLogger.info("NSD Service Registered: $deviceName on port $port");
    } catch (e) {
      AppLogger.error("Failed to register NSD Service: $e");
    }
  }

  /// Unregisters the local device.
  Future<void> unregisterLocalService() async {
    try {
      await _nsdChannel.invokeMethod("unregisterService");
      AppLogger.info("NSD Service Unregistered.");
    } catch (e) {
      AppLogger.error("Failed to unregister NSD Service: $e");
    }
  }

  /// Retrieves the list of discovered peers.
  Future<List<PeerModel>> discoverPeers() async {
    try {
      final List<dynamic>? peersList = await _nsdChannel.invokeMethod("getDiscoveredPeers");
      if (peersList == null) return [];

      return peersList.map((peer) {
        final Map<dynamic, dynamic> map = peer;
        return PeerModel(
          name: map["name"]?.toString() ?? "Unknown Device",
          ip: map["ip"]?.toString() ?? "",
          port: int.tryParse(map["port"]?.toString() ?? "4040") ?? 4040,
        );
      }).toList();
    } catch (e) {
      AppLogger.error("Failed to get discovered peers: $e");
      return [];
    }
  }
}
