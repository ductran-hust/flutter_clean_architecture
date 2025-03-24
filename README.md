# 📱 Flutter Clean Architecture

## 📝 Giới thiệu

## 🛠 Cài đặt
### 1. Cài đặt Flutter
Nếu chưa có Flutter, hãy tải về tại [Flutter.dev](https://flutter.dev/docs/get-started/install).

### 2. Clone dự án
```sh
git clone https://git.vti.com.vn
cd flutter_clean_architecture
```

### 3. Cài đặt dependencies
```sh
flutter pub get
```

### 4. Chạy Build runner
```sh
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Chạy ứng dụng
```sh
flutter run
```

# 🛠 VTI Tool – Flutter Code Generator

Một công cụ CLI được viết bằng Dart, giúp tự động sinh các thành phần thường dùng trong kiến trúc Flutter Clean Architecture như:

- ✅ BLoC / Event / State
- ✅ Page (UI)
- ✅ UseCase
- ✅ Repository (interface + implementation)
- ✅ DataSource
- ✅ Tự động chèn route vào `router.dart`
- ✅ Hỗ trợ chạy `build_runner`

Cách chạy: `dart run myvti_tool/bin/myvti_tool.dart`

## 📦 Build APK
```sh
sh tools/apk_sign.sh development
sh tools/apk_sign.sh staging
sh tools/apk_sign.sh production
```

## 🍎 Build IPA
```sh
sh tools/ios_sign.sh development
sh tools/ios_sign.sh staging
sh tools/ios_sign.sh production
```

## 🏗 Kiến trúc
Dự án sử dụng **Clean Architecture**, chia thành các layer rõ ràng:
- **Data Layer**: Xử lý dữ liệu từ API, cơ sở dữ liệu cục bộ.
- **Domain Layer**: Chứa business logic chính, use cases, và entities.
- **Presentation Layer**: Xử lý UI, tương tác với người dùng.
- **Shared Layer**: Các thư viện và tiện ích dùng chung.

## 🛠 Công nghệ sử dụng
| Category | Packages |
|---|---|
| **UI** | `flutter`, `flutter_svg`, `dropdown_button2`, `card_loading`, `focus_detector` |
| **State Management** | `flutter_bloc`, `equatable`, `freezed` |
| **Navigation** | `auto_route`, `auto_route_generator` |
| **Network** | `dio`, `retrofit`, `dio_smart_retry`, `json_annotation`, `retrofit_generator`, `cookie_jar`, `dio_cookie_manager`, `path_provider` |
| **Async Handling** | `Future`, `Stream` |
| **Local Storage** | `shared_preferences`, `flutter_secure_storage` |
| **Dependency Injection (DI)** | `get_it`, `injectable`, `injectable_generator` |
| **Localization** | `easy_localization` |
| **Resource Management** | `flutter_gen_runner` |
| **Logger** | `logger`, `pretty_dio_logger` |
| **Alerts & Dialogs** | `cool_alert` |
| **Testing** | `mockito`, `flutter_test` |
| **Linting** | `flutter_lints` |
| **Code Generation** | `build_runner`, `json_serializable`, `freezed`, `injectable_generator`, `auto_route_generator`, `retrofit_generator` |
| **Context Access** | `one_context` |

## 📂 Cấu trúc thư mục
```
├── data                        # Lớp dữ liệu, bao gồm Repository và data sources
│   ├── cache                   # Quản lý cache dữ liệu
│   ├── local                   # Cơ sở dữ liệu cục bộ
│   │   ├── datasources         # Nguồn dữ liệu cục bộ
│   ├── remote                  # Gọi API, xử lý dữ liệu từ server
│   │   ├── datasources         # API endpoints
│   │   ├── interceptors        # Xử lý request/response
│   │   ├── models              # Mô hình dữ liệu
│   │   └── services            # Service API
│   ├── repositories            # Repository pattern
│   └── translator              # Xử lý chuyển đổi models sang entities
├── dependencies                # Quản lý các thư viện phụ thuộc
├── di                          # Dependency Injection
├── domain                      # Chứa business logic chính (use cases) và entities
│   ├── entities                # Định nghĩa thực thể dữ liệu
│   ├── enums                   # Định nghĩa enums
│   ├── repositories            # Interface của Repository
│   └── usecases                # Business logic (Use Cases)
├── presentation                # UI và logic UI
│   ├── base                    # Lớp cơ bản
│   ├── resource                # Tài nguyên giao diện
│   ├── router                  # Điều hướng ứng dụng
│   ├── view                    # Các màn hình UI
│   │   ├── pages               # Trang chính của ứng dụng
│   │   ├── popups              # Popup dialogs
│   │   └── widgets             # Widget tái sử dụng
├── shared                      # Thư viện dùng chung
│   ├── common                  # Xử lý chung
│   ├── extension               # Extensions hỗ trợ
│   ├── utils                   # Hàm tiện ích
│   └── constants.dart          # Các hằng số
├── app.dart                    # Khởi tạo ứng dụng
├── firebase_options.dart       # Cấu hình Firebase
├── flavor_settings.dart        # Cấu hình môi trường
└── main.dart                   # Khởi tạo Flutter
```
****
