import 'package:get/get.dart';
import '../../data/datasource/local/hive_database.dart';

class StorageService extends GetxService {
  final HiveDatabase _db = HiveDatabase();

  HiveDatabase get db => _db;

  Future<StorageService> init() async {
    await _db.init();
    return this;
  }
}
