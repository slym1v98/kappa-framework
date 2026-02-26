import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addCommand('init')
    ..addCommand('module');

  final results = parser.parse(arguments);

  if (results.command?.name == 'module') {
    final moduleName = results.command?.arguments.first;
    if (moduleName == null) {
      print('Vui lòng nhập tên module: kappa module <name>');
      return;
    }
    _createModule(moduleName);
  } else if (results.command?.name == 'init') {
    print('Khởi tạo dự án Kappa Framework...');
    // Thêm logic khởi tạo dự án ở đây
  } else {
    print('Sử dụng: kappa <command> [arguments]');
    print('Các lệnh:');
    print('  init    - Khởi tạo dự án');
    print('  module  - Tạo một module mới');
  }
}

void _createModule(String name) {
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

  // Tạo file Module cơ bản
  final moduleFile = File('$basePath/${name}_module.dart');
  moduleFile.writeAsStringSync('''
import 'package:go_router/go_router.dart';
import 'package:kappa_framework/kappa_framework.dart';

class ${name[0].toUpperCase()}${name.substring(1)}Module extends KappaModule {
  @override
  void onInit() {
    // Đăng ký DI ở đây
  }

  @override
  void onReady() {}

  @override
  void onDispose() {}

  @override
  List<GoRoute> get routes => [
    // GoRoute(
    //   path: '/$name',
    //   builder: (context, state) => const ${name[0].toUpperCase()}${name.substring(1)}Page(),
    // ),
  ];
}
''');

  print('Đã tạo module $name tại $basePath');
}
