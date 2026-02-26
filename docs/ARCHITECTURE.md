# Kiến trúc Kappa Framework

Kappa Framework được xây dựng dựa trên nguyên lý **Clean Architecture** kết hợp với tư duy **Modular Design**. Mục tiêu là tách biệt hoàn toàn logic nghiệp vụ (Business Logic) khỏi nền tảng (Platform) và giao diện (UI).

## 1. Cấu trúc Module

Mỗi module trong hệ thống là một đơn vị độc lập, tự quản lý các thành phần của mình. Cấu trúc chuẩn của một module:

```text
lib/src/modules/tên_module/
├── data/               # Tầng dữ liệu
│   ├── models/         # Data Models (DTOs), JSON mapping
│   ├── repositories/   # Implementation của Repository
│   └── datasources/    # Remote (API) hoặc Local (DB) sources
├── domain/             # Tầng nghiệp vụ (Logic cốt lõi)
│   ├── entities/       # Business Objects
│   ├── repositories/   # Interface định nghĩa các phương thức
│   └── usecases/       # Các nghiệp vụ cụ thể
├── presentation/       # Tầng hiển thị
│   ├── bloc/           # Quản lý trạng thái (KappaBloc)
│   ├── pages/          # Các màn hình chính
│   └── widgets/        # Các widget dùng riêng cho module
└── tên_module_module.dart # File đăng ký module với Engine
```

## 2. Luồng dữ liệu (Data Flow)

1. **UI (Page/Widget)** gọi một hàm trong **BLoC**.
2. **BLoC** thực thi một **UseCase**.
3. **UseCase** lấy dữ liệu từ **Repository** (Interface).
4. **Repository Implementation** quyết định lấy dữ liệu từ **Remote Data Source** (API) hay **Local Data Source** (DB).
5. Dữ liệu trả về dưới dạng `Result<T>` đi ngược lại từ Data -> Domain -> Presentation.

## 3. Dependency Injection (DI)

Kappa sử dụng `GetIt` thông qua `KappaEngine` để quản lý DI. 
- Việc đăng ký (Registration) thực hiện trong hàm `onInit()` của mỗi module.
- Việc truy xuất (Retrieval) thực hiện qua `KappaEngine.get<T>()`.

## 4. Ưu điểm của kiến trúc này
- **Dễ kiểm thử (Testability)**: Các tầng tách biệt giúp dễ dàng viết Unit Test cho Domain logic.
- **Tính đóng gói (Encapsulation)**: Thay đổi ở một module không ảnh hưởng đến các module khác.
- **Khả năng mở rộng (Scalability)**: Dễ dàng thêm tính năng mới bằng cách tạo module mới.
