import 'package:isar/isar.dart';

class KappaDatabase {
  late final Isar _isar;

  static Future<KappaDatabase> init(List<CollectionSchema> schemas) async {
    final db = KappaDatabase();
    // Trên Web, Isar tự động sử dụng IndexedDB, directory có thể để trống
    db._isar = await Isar.open(schemas, directory: '');
    return db;
  }

  Isar get instance => _isar;

  Future<T> write<T>(Future<T> Function() callback) => _isar.writeTxn(callback);
}
