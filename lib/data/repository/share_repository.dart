import '../../core/services/discovery_service.dart';
import '../models/peer_model.dart';

class ShareRepository {
  final DiscoveryService _discoveryService = DiscoveryService();

  Future<void> startDiscovery() async {
    await _discoveryService.startDiscovery();
  }

  Future<void> stopDiscovery() async {
    await _discoveryService.stopDiscovery();
  }

  Future<void> registerMyDevice(String deviceName, int port) async {
    await _discoveryService.registerLocalService(deviceName, port);
  }

  Future<void> unregisterMyDevice() async {
    await _discoveryService.unregisterLocalService();
  }

  Future<List<PeerModel>> discoverPeers() async {
    return await _discoveryService.discoverPeers();
  }
}
