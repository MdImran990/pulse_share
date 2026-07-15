import '../../data/models/peer_model.dart';

class DiscoveryService {
  Future<List<PeerModel>> discoverPeers() async {
    // TODO:
    // এখানে পরে UDP Broadcast বা mDNS Discovery implement হবে।
    // আপাতত Demo Device return করছি।

    await Future.delayed(const Duration(seconds: 1));

    return [
      PeerModel(
        name: "Android Device",
        ip: "192.168.0.105",
        port: 4040,
      ),
    ];
  }
}