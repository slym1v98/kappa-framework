import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addCommand('init')
    ..addCommand('module')
    ..addCommand('generate');

  final results = parser.parse(arguments);

  if (results.command?.name == 'module') {
    final moduleName = results.command?.arguments.firstOrNull;
    if (moduleName == null) {
      print('Vui lòng nhập tên module: kappa module <name>');
      return;
    }
    _createModule(moduleName);
  } else if (results.command?.name == 'generate') {
    final args = results.command?.arguments;
    if (args == null || args.length < 3) {
      print('Sử dụng: kappa generate <type> <module> <name>');
      print('Các loại (type): page, bloc, repository, model, entity, usecase');
      return;
    }
    final type = args[0];
    final module = args[1];
    final name = args[2];
    _generateComponent(type, module, name);
  } else if (results.command?.name == 'init') {
    print('Khởi tạo dự án Kappa Framework...');
    // Thêm logic khởi tạo dự án ở đây
  } else {
    print('Sử dụng: kappa <command> [arguments]');
    print('Các lệnh:');
    print('  init      - Khởi tạo dự án');
    print('  module    - Tạo một module mới');
    print('  generate  - Tạo thành phần trong module (page, bloc, ...)');
  }
}

void _createModule(String name) {
  final basePath = 'lib/src/modules/$name';
  final directories = [
    '$basePath/data/models',
    '$basePath/data/repositories',
    '$basePath/domain/entities',
    '$basePath/domain/repositories',
    '$basePath/domain/usecases',
    '$basePath/presentation/bloc',
    '$basePath/presentation/pages',
    '$basePath/presentation/widgets',
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

void _generateComponent(String type, String module, String name) {
  final modulePath = 'lib/src/modules/$module';
  if (!Directory(modulePath).existsSync()) {
    print('Lỗi: Module "$module" không tồn tại tại $modulePath');
    return;
  }

  final className = _toPascalCase(name);
  final fileName = _toSnakeCase(name);

  switch (type) {
    case 'page':
      _createFile(
        '$modulePath/presentation/pages/${fileName}_page.dart',
        _pageTemplate(className),
      );
      break;
    case 'bloc':
      _createFile(
        '$modulePath/presentation/bloc/${fileName}_bloc.dart',
        _blocTemplate(className),
      );
      break;
    case 'repository':
      _createFile(
        '$modulePath/domain/repositories/${fileName}_repository.dart',
        _repoInterfaceTemplate(className),
      );
      _createFile(
        '$modulePath/data/repositories/${fileName}_repository_impl.dart',
        _repoImplTemplate(className, fileName),
      );
      break;
    case 'model':
      _createFile(
        '$modulePath/data/models/${fileName}_model.dart',
        'class ${className}Model {}\n',
      );
      break;
    case 'entity':
      _createFile(
        '$modulePath/domain/entities/${fileName}.dart',
        'class ${className} {}\n',
      );
      break;
    case 'usecase':
      _createFile(
        '$modulePath/domain/usecases/${fileName}_usecase.dart',
        'class ${className}UseCase {}\n',
      );
      break;
    default:
      print('Loại thành phần không hợp lệ: $type');
  }
}

void _createFile(String path, String content) {
  final file = File(path);
  if (file.existsSync()) {
    print('Cảnh báo: File đã tồn tại: $path');
    return;
  }
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(content);
  print('Đã tạo: $path');
}

String _toPascalCase(String text) {
  return text
      .split('_')
      .map((e) => e[0].toUpperCase() + e.substring(1))
      .join('');
}

String _toSnakeCase(String text) {
  return text
      .replaceAllMapped(RegExp(r'([A-Z])'), (match) => '_${match.group(1)?.toLowerCase()}')
      .toLowerCase()
      .replaceAll(RegExp(r'^_'), '');
}

String _pageTemplate(String className) => '''
import 'package:flutter/material.dart';

class ${className}Page extends StatelessWidget {
  const ${className}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$className'),
      ),
      body: const Center(
        child: Text('$className Page'),
      ),
    );
  }
}
''';

String _blocTemplate(String className) => '''
import 'package:kappa_framework/kappa_framework.dart';

class ${className}Bloc extends KappaBloc<dynamic> {
  ${className}Bloc() : super(const KappaState(status: KappaStatus.initial));
}
''';

String _repoInterfaceTemplate(String className) => '''
abstract class I${className}Repository {
  // Define methods here
}
''';

String _repoImplTemplate(String className, String fileName) => '''
import '../../domain/repositories/${fileName}_repository.dart';

class ${className}RepositoryImpl implements I${className}Repository {
  // Implement methods here
}
''';
