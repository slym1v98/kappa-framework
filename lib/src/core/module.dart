import 'package:go_router/go_router.dart';

abstract class KappaModule {
  // Mỗi module phải khai báo danh sách Route của nó
  List<GoRoute> get routes;

  // Lifecycle hooks
  void onInit(); // Đăng ký các dependency (Repo, UseCase, Bloc)
  void onReady(); // Chạy sau khi toàn bộ app đã khởi tạo xong
  void onDispose(); // Dọn dẹp tài nguyên
}
