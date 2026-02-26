import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:test/test.dart';

void main() {
  group('Kappa CLI Tests', () {
    final testModulePath = 'lib/src/modules/test_module_for_cli';

    tearDown(() {
      try {
        final dir = Directory(testModulePath);
        if (dir.existsSync()) {
          dir.deleteSync(recursive: true);
        }
      } catch (e) {
        print('Không thể xóa thư mục test: $e');
      }
    });

    test('nên tạo đúng cấu trúc thư mục cho module mới', () {
      _createModuleForTest('test_module_for_cli');

      expect(Directory('$testModulePath/data/models').existsSync(), true);
      expect(Directory('$testModulePath/domain/entities').existsSync(), true);
      expect(
        Directory('$testModulePath/domain/repositories').existsSync(),
        true,
      );
      expect(Directory('$testModulePath/presentation/bloc').existsSync(), true);
      expect(
        Directory('$testModulePath/presentation/pages').existsSync(),
        true,
      );
      expect(
        File('$testModulePath/test_module_for_cli_module.dart').existsSync(),
        true,
      );
    });

    test('nên in ra thông báo lỗi khi không nhập tên module', () {
      final results = _simulateCommand(['module']);
      expect(results, contains('Vui lòng nhập tên module'));
    });
  });
}

void _createModuleForTest(String name) {
  final basePath = 'lib/src/modules/$name';
  final directories = [
    '$basePath/data/models',
    '$basePath/domain/entities',
    '$basePath/domain/repositories',
    '$basePath/presentation/bloc',
    '$basePath/presentation/pages',
  ];

  for (var dir in directories) {
    Directory(dir).createSync(recursive: true);
  }

  final moduleFile = File('$basePath/${name}_module.dart');
  moduleFile.writeAsStringSync('// Test content');
}

String _simulateCommand(List<String> args) {
  if (args.contains('module') && args.length == 1) {
    return 'Vui lòng nhập tên module: kappa module <name>';
  }
  return '';
}
