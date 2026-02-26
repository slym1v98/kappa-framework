import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'module.dart';

class KappaEngine {
  static final GetIt _di = GetIt.instance;
  static late final GoRouter _router;
  static final List<KappaModule> _modules = [];

  static Future<void> init({
    required List<KappaModule> modules,
    List<GoRoute> globalRoutes = const [],
    String initialLocation = '/',
    // Có thể thêm config khác ở đây
  }) async {
    _modules.clear();
    _modules.addAll(modules);

    // 1. Chạy onInit cho tất cả module (Đăng ký DI)
    for (var module in _modules) {
      module.onInit();
    }

    // 2. Thu thập route từ tất cả module
    final allRoutes = [...globalRoutes, ..._modules.expand((m) => m.routes)];

    // 3. Khởi tạo GoRouter
    _router = GoRouter(initialLocation: initialLocation, routes: allRoutes);

    // 4. Chạy onReady
    for (var module in _modules) {
      module.onReady();
    }
  }

  // Hidden Service Locator
  static T get<T extends Object>() => _di.get<T>();

  static void registerLazySingleton<T extends Object>(T Function() factory) {
    _di.registerLazySingleton<T>(factory);
  }

  static void registerFactory<T extends Object>(T Function() factory) {
    _di.registerFactory<T>(factory);
  }

  static void registerSingleton<T extends Object>(T instance) {
    _di.registerSingleton<T>(instance);
  }

  static GoRouter get router => _router;
}
