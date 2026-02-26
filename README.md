# Kappa Framework 🚀

**Kappa Framework** là một nền tảng phát triển ứng dụng Flutter (tối ưu cho Web) dựa trên nguyên tắc Clean Architecture và thiết kế hướng Module.

## ✨ Tính năng nổi bật

- 🏗️ **Clean Architecture**: Tách biệt rõ ràng Data, Domain và Presentation.
- 📦 **Modular Design**: Quản lý ứng dụng theo các module độc lập.
- 💉 **Dependency Injection**: Tích hợp sẵn Service Locator (GetIt).
- 🛣️ **Smart Routing**: Quản lý điều hướng tập trung với GoRouter.
- ⚡ **BLoC State Management**: Tối ưu hóa việc quản lý trạng thái Loading/Success/Error.
- 🌐 **Responsive Grid**: Hệ thống Row/Col chuẩn 12 cột cho Web.
- 🛠️ **Kappa CLI**: Công cụ sinh code nhanh chóng.

## 📚 Tài liệu chi tiết

- [Kiến trúc hệ thống (Architecture)](docs/ARCHITECTURE.md)
- [Hướng dẫn sử dụng CLI](docs/CLI.md)
- [Các thành phần Core (Engine, Bloc, Network)](docs/COMPONENTS.md)

## 🚀 Bắt đầu nhanh

### 1. Khởi tạo Engine
Trong `lib/main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await KappaEngine.init(
    modules: [
      HomeModule(),
      AuthModule(),
    ],
  );

  runApp(const MyApp());
}
```

### 2. Cấu hình App
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kappa App',
      theme: KappaTheme.light(),
      routerConfig: KappaEngine.router,
    );
  }
}
```

### 3. Tạo module mới bằng CLI
```bash
dart bin/kappa.dart module profile
```

## 🛠️ Yêu cầu hệ thống

- Flutter SDK: `>=3.3.0`
- Dart SDK: `^3.11.0`

## 📄 Giấy phép

Dự án này được phát hành dưới giấy phép [LICENSE](LICENSE).
