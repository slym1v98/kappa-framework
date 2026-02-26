import 'dart:io';
import 'package:test/test.dart';

void main() {
  group('Kappa CLI Tests', () {
    const testModuleName = 'test_cli_module';
    const testModulePath = 'lib/src/modules/$testModuleName';

    tearDown(() {
      final dir = Directory(testModulePath);
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
    });

    Future<ProcessResult> runCli(List<String> args) {
      return Process.run('dart', ['bin/kappa.dart', ...args]);
    }

    test('nên tạo đúng cấu trúc thư mục cho module mới', () async {
      final result = await runCli(['module', testModuleName]);
      
      expect(result.exitCode, 0);
      expect(result.stdout, contains('Đã tạo module $testModuleName'));

      final expectedDirs = [
        '$testModulePath/data/models',
        '$testModulePath/data/repositories',
        '$testModulePath/domain/entities',
        '$testModulePath/domain/repositories',
        '$testModulePath/domain/usecases',
        '$testModulePath/presentation/bloc',
        '$testModulePath/presentation/pages',
        '$testModulePath/presentation/widgets',
      ];

      for (var dir in expectedDirs) {
        expect(Directory(dir).existsSync(), true, reason: 'Directory $dir should exist');
      }
      
      expect(File('$testModulePath/${testModuleName}_module.dart').existsSync(), true);
    });

    test('nên tạo các thành phần nhỏ (generate) trong module', () async {
      // B1: Tạo module trước
      await runCli(['module', testModuleName]);

      // B2: Test generate page
      final pageResult = await runCli(['generate', 'page', testModuleName, 'login']);
      expect(pageResult.stdout, contains('Đã tạo: $testModulePath/presentation/pages/login_page.dart'));
      expect(File('$testModulePath/presentation/pages/login_page.dart').existsSync(), true);

      // B3: Test generate bloc
      final blocResult = await runCli(['generate', 'bloc', testModuleName, 'auth']);
      expect(blocResult.stdout, contains('Đã tạo: $testModulePath/presentation/bloc/auth_bloc.dart'));
      expect(File('$testModulePath/presentation/bloc/auth_bloc.dart').existsSync(), true);

      // B4: Test generate repository
      final repoResult = await runCli(['generate', 'repository', testModuleName, 'user']);
      expect(repoResult.stdout, contains('Đã tạo: $testModulePath/domain/repositories/user_repository.dart'));
      expect(repoResult.stdout, contains('Đã tạo: $testModulePath/data/repositories/user_repository_impl.dart'));
      expect(File('$testModulePath/domain/repositories/user_repository.dart').existsSync(), true);
      expect(File('$testModulePath/data/repositories/user_repository_impl.dart').existsSync(), true);
    });

    test('nên in ra thông báo lỗi khi không nhập tên module', () async {
      final result = await runCli(['module']);
      expect(result.stdout, contains('Vui lòng nhập tên module'));
    });

    test('nên in ra thông báo lỗi khi module không tồn tại khi generate', () async {
      final result = await runCli(['generate', 'page', 'non_existent_module', 'home']);
      expect(result.stdout, contains('Lỗi: Module "non_existent_module" không tồn tại'));
    });
  });
}
