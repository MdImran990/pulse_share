import '../../core/services/discovery_service.dart';
import '../models/peer_model.dart';

class ShareRepository {
  final DiscoveryService _discoveryService =
  DiscoveryService();

  Future<List<PeerModel>> discoverPeers() async {
    return await _discoveryService.discoverPeers();
  }
}