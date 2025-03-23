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
- **UI**: Flutter
- **State Management**: flutter_bloc
- **Navigation**: auto_route
- **Network**: dio, retrofit, dio_smart_retry
- **Asynchronous Handling**: Future, Stream, rxdart
- **Local Database**: shared_preferences, hive
- **DI (Dependency Injection)**: get_it, injectable
- **Notification**: Firebase, flutter_local_notifications
- **Localization**: easy_localization
- **Resource Management**: flutter_gen_runner
- **Load Image**: cached_network_image
- **Logger**: Logger, pretty_dio_logger
- **Debug & Crash Reports**: Firebase Crashlytics
- **Environment Variables**: flutter_dotenv
- **Lint**: flutter_lints
- **Code Generator**: freezed, json_serializable, retrofit_generator, build_runner, injectable_generator
- **UI Enhancements**: flutter_svg, dropdown_button2, expandable, flutter_slidable, modal_bottom_sheet, table_calendar, carousel_slider
- **File Handling**: file_picker, open_file, external_path, permission_handler
- **Security**: local_auth, flutter_secure_storage
- **Date Handling**: intl, omni_datetime_picker, month_picker_dialog
- **Alerts & Notifications**: cool_alert, flutter_local_notifications, flutter_native_timezone
- **Testing**: mockito, faker
- **Other Utilities**: ntp, tuple, readmore, url_launcher, simple_html_css, rich_readmore, cloud_firestore, firebase_core, focus_detector, video_player, fl_chart

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