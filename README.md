# Base Clean Architecture

## 📁 Cấu trúc thư mục

```
lib/
├── main.dart
├── core/
│   ├── base/
│   │   ├── base_controller.dart     # Abstract Notifier base
│   │   ├── base_page.dart           # Abstract ConsumerWidget base
│   │   ├── base_state.dart          # Generic state wrapper
│   │   ├── ui_state.dart            # Sealed UIState (initial/loading/success/error)
│   │   └── use_case.dart            # UseCase / NoParamsUseCase abstract classes
│   ├── di/
│   │   ├── injection_container.dart # GetIt + Injectable setup
│   │   └── hive_module.dart         # Hive initialization module
│   ├── error/
│   │   ├── exceptions.dart          # Data layer exceptions
│   │   └── failures.dart            # Domain layer failures (Freezed)
│   ├── localization/
│   └── network/
│       └── network_client.dart      # Dio singleton with interceptors
├── features/
│   └── todo/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── todo_local_datasource.dart   # Hive implementation
│       │   │   └── todo_remote_datasource.dart  # Dio implementation
│       │   ├── models/
│       │   │   └── todo_model.dart              # Freezed + Hive + JSON
│       │   └── repositories/
│       │       └── todo_repository_impl.dart    # Offline-first strategy
│       ├── domain/
│       │   ├── entities/
│       │   │   └── todo_entity.dart             # Pure Dart entity (Freezed)
│       │   ├── repositories/
│       │   │   └── todo_repository.dart         # Abstract interface
│       │   └── usecases/
│       │       ├── get_todos_use_case.dart
│       │       ├── create_todo_use_case.dart
│       │       ├── update_todo_use_case.dart
│       │       ├── delete_todo_use_case.dart
│       │       └── todo_action_use_cases.dart   # toggle + deleteCompleted
│       └── presentation/
│           ├── controllers/
│           │   ├── todo_list_controller.dart    # Notifier + use cases injection
│           │   └── todo_form_controller.dart    # FamilyNotifier (fixes rebuild bug)
│           ├── pages/
│           │   ├── todo_list_page.dart          # BasePage implementation
│           │   └── todo_form_page.dart          # ConsumerStatefulWidget
│           ├── states/
│           │   ├── todo_list_state.dart         # Freezed + computed props
│           │   └── todo_form_state.dart         # Freezed form state
│           └── widgets/
│               ├── todo_item_tile.dart
│               └── todo_filter_tabs.dart
├── routes/
│   └── app_router.dart              # Auto Route config
└── assets/translations/
    ├── en.json
    └── ja.json
```

## 🏗️ Nguyên tắc kiến trúc

| Layer        | Phụ thuộc vào  | Không được phụ thuộc vào |
|-------------|---------------|--------------------------|
| Domain       | Không ai cả   | Data, Presentation        |
| Data         | Domain        | Presentation              |
| Presentation | Domain        | Data (trực tiếp)          |

## 🔄 Luồng dữ liệu

```
UI (Page)
  → Controller (Notifier)
    → UseCase
      → Repository (interface - Domain)
        → RepositoryImpl (Data)
          → RemoteDataSource (Dio)
          → LocalDataSource (Hive)
```

## 📦 Dependencies chính

- **Riverpod** — State management
- **GetIt + Injectable** — Dependency Injection
- **Auto Route** — Navigation + code gen
- **Dio** — HTTP client
- **Hive CE** — Local storage
- **Freezed** — Immutable models + sealed classes
- **Easy Localization** — i18n

## ⚡ Code Generation

```bash
# Chạy một lần
dart run build_runner build --delete-conflicting-outputs

# Watch mode khi develop
dart run build_runner watch --delete-conflicting-outputs
```

## 🌐 Offline-first Strategy

Repository theo chiến lược **offline-first**:
1. Fetch từ remote → cache vào Hive → return
2. Nếu lỗi mạng → return từ Hive cache
3. Nếu cả hai lỗi → return `Left(Failure)`

## 🔑 Điểm chú ý

- **TodoFormController** extend `FamilyNotifier` thay vì `BaseController` để tránh
  `build()` bị gọi lại mỗi khi widget rebuild (bug đã phát hiện ở conversation trước).
- **TodoRepository** trả về `Either<Failure, T>` thay vì throw exception —
  error handling rõ ràng và type-safe.
- **UseCase** nhận `Params` dạng Freezed class để dễ mở rộng.


## 🌐 Tạo file đa ngôn ngữ
flutter pub run easy_localization:generate -S assets/translations -O lib/core/localization -o locale_keys.dart -f keys