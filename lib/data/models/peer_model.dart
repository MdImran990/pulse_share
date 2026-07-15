class PeerModel {
  final String name;
  final String ip;
  final int port;

  PeerModel({
    required this.name,
    required this.ip,
    required this.port,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "ip": ip,
      "port": port,
    };
  }

  factory PeerModel.fromJson(Map<String, dynamic> json) {
    return PeerModel(
      name: json["name"],
      ip: json["ip"],
      port: json["port"],
    );
  }
}