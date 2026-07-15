import 'dart:convert';
import 'dart:io';

class SocketService {
  ServerSocket? _server;

  /// Start Server
  Future<void> startServer({
    required Function(Map<String, dynamic>) onData,
  }) async {
    _server = await ServerSocket.bind(
      InternetAddress.anyIPv4,
      4040,
    );

    _server!.listen((Socket socket) {
      socket.listen((event) {
        final json =
        jsonDecode(utf8.decode(event));

        onData(
          Map<String, dynamic>.from(json),
        );
      });
    });
  }

  /// Send Data
  Future<void> sendData({
    required String ip,
    required int port,
    required Map<String, dynamic> data,
  }) async {
    final socket = await Socket.connect(
      ip,
      port,
    );

    socket.write(jsonEncode(data));

    await socket.flush();

    await socket.close();
  }

  /// Stop Server
  Future<void> stopServer() async {
    await _server?.close();
  }
}