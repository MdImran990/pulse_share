class ReceivedRepository {
  final List<Map<String, dynamic>> _receivedData = [];

  /// সকল received data return করবে
  List<Map<String, dynamic>> getAllReceivedData() {
    return List.from(_receivedData);
  }

  /// নতুন data save করবে
  void saveReceivedData(Map<String, dynamic> data) {
    _receivedData.add(data);
  }

  /// একটি data remove করবে
  void removeReceivedData(int index) {
    if (index >= 0 && index < _receivedData.length) {
      _receivedData.removeAt(index);
    }
  }

  /// সব data delete করবে
  void clearAll() {
    _receivedData.clear();
  }

  /// মোট কতগুলো data আছে
  int get totalReceived => _receivedData.length;
}