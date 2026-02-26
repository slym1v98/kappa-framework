import 'package:flutter_test/flutter_test.dart';
import 'package:kappa_framework/kappa_framework.dart';

void main() {
  group('Result Pattern Tests', () {
    test('nên thực thi onSuccess khi Success', () {
      const result = Success<int>(100);
      expect(result.fold((f) => 0, (data) => data), 100);
      expect(result.isSuccess, true);
    });

    test('nên thực thi onError khi Error', () {
      const result = Error<int>(ServerFailure('Lỗi'));
      expect(result.fold((f) => f.message, (data) => data.toString()), 'Lỗi');
      expect(result.isError, true);
    });
  });

  group('KappaEngine Tests', () {
    test('nên khởi tạo engine và router', () async {
      await KappaEngine.init(modules: [], globalRoutes: []);

      expect(KappaEngine.router, isNotNull);
    });
  });
}
