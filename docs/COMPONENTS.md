# Các thành phần Core của Kappa Framework

Tài liệu này chi tiết về các lớp và công cụ cốt lõi được xây dựng sẵn trong Framework.

## 1. KappaEngine
Lớp quản lý trung tâm của ứng dụng.

- `init()`: Khởi tạo ứng dụng, đăng ký modules, cấu hình GoRouter.
- `get<T>()`: Truy xuất một dependency đã đăng ký.
- `registerLazySingleton()`, `registerFactory()`: Các phương thức đăng ký DI.
- `router`: Trả về cấu hình `GoRouter` để dùng trong `MaterialApp.router`.

## 2. KappaModule (Abstract Class)
Lớp cơ sở cho mọi module.

- `onInit()`: Nơi đăng ký các Repository, Bloc vào DI container.
- `onReady()`: Nơi thực hiện các logic sau khi module đã khởi tạo (ví dụ: fetch dữ liệu ban đầu).
- `routes`: Danh sách các đường dẫn (GoRoute) mà module này quản lý.

## 3. Quản lý trạng thái (BLoC)

### KappaBloc<T>
Một phiên bản mở rộng của `Bloc`, chuyên dùng để xử lý dữ liệu đơn lẻ kiểu `T`.
- Trạng thái mặc định là `KappaState<T>`.

### KappaState<T>
Lớp chứa trạng thái đồng nhất:
- `isLoading`: Đang tải dữ liệu.
- `data`: Dữ liệu khi thành công (kiểu `T`).
- `failure`: Đối tượng lỗi khi thất bại.

### KappaUIListener
Widget dùng để bọc ngoài các Page, tự động hiển thị Loading Overlay hoặc Thông báo lỗi (Snackbar/Dialog) dựa trên trạng thái của `KappaBloc`.

## 4. Network (KappaHttpClient)
Bọc ngoài thư viện `Dio` với các tính năng:
- **Tự động Log**: Hiển thị request/response trong console với prefix `🚀 [KAPPA LOG]`.
- **Auth Interceptor**: Tự động đính kèm Token và xử lý lỗi 401.
- **Result Pattern**: Mọi yêu cầu trả về `Result<T>` (Success hoặc Error).

## 5. UI Layout (Responsive Grid)
Kappa cung cấp hệ thống Grid tương tự Bootstrap để làm việc tốt trên Web:
- `KappaRow`: Container cho các cột.
- `KappaCol`: Cột với các tham số `xs`, `md`, `lg` (tổng 12 cột).

**Ví dụ:**
```dart
KappaRow(
  children: [
    KappaCol(xs: 12, md: 6, child: WidgetA()),
    KappaCol(xs: 12, md: 6, child: WidgetB()),
  ],
)
```
- Trên Mobile (`xs`): Mỗi widget chiếm 12 cột (full width).
- Trên Desktop (`md`): Mỗi widget chiếm 6 cột (nửa màn hình).
