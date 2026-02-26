# Hướng dẫn sử dụng Kappa CLI

Kappa Framework cung cấp một công cụ CLI cơ bản để tự động hóa việc tạo cấu trúc thư mục, giúp lập trình viên tập trung vào viết code thay vì tạo folder thủ công.

## 1. Cách chạy công cụ

Từ thư mục gốc của dự án, bạn có thể chạy các lệnh bằng cách sử dụng `dart`:

```bash
dart bin/kappa.dart <lệnh> [đối số]
```

## 2. Các lệnh khả dụng

### Tạo Module mới
Lệnh này sẽ tạo ra toàn bộ cấu trúc thư mục Clean Architecture cho một module mới và file đăng ký module.

```bash
dart bin/kappa.dart module <tên_module>
```

**Ví dụ:**
```bash
dart bin/kappa.dart module auth
```
Lệnh này sẽ tạo thư mục `lib/src/modules/auth` với các thư mục con `data`, `domain`, `presentation` và file `auth_module.dart`.

### Khởi tạo dự án (Init)
Dùng để thiết lập các cấu hình ban đầu cho dự án.

```bash
dart bin/kappa.dart init
```

### Tạo các thành phần (Generate)
Lệnh này giúp tạo nhanh các file thành phần bên trong một module.

```bash
dart bin/kappa.dart generate <loại> <tên_module> <tên_thành_phần>
```

**Các loại thành phần hỗ trợ:**
- `page`: Tạo một UI Page trong `presentation/pages`
- `bloc`: Tạo một Bloc trong `presentation/bloc`
- `repository`: Tạo Interface Repo trong `domain/repositories` và bản thực thi trong `data/repositories`
- `model`: Tạo Data Model trong `data/models`
- `entity`: Tạo Domain Entity trong `domain/entities`
- `usecase`: Tạo Use Case trong `domain/usecases`

**Ví dụ:**
```bash
dart bin/kappa.dart generate page auth login
dart bin/kappa.dart generate bloc auth auth
dart bin/kappa.dart generate repository auth user
```

## 3. Đăng ký Module sau khi tạo

Sau khi tạo module bằng CLI, bạn cần thực hiện 2 bước để module hoạt động:
1. Mở file `lib/src/modules/<tên_module>/<tên_module>_module.dart` để định nghĩa các route và đăng ký DI.
2. Thêm module vào danh sách khởi tạo trong `main.dart`:

```dart
await KappaEngine.init(
  modules: [
    MyNewModule(), // Module vừa tạo
  ],
);
```
