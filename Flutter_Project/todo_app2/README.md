# Advanced Todo App (todo_app2)

Ứng dụng Todo mẫu viết bằng Flutter — giao diện hiện đại, tính năng quản lý công việc cơ bản và dễ mở rộng.

File chính: [todo_app2/lib/main.dart](todo_app2/lib/main.dart)

## Tổng quan

- Ứng dụng được tổ chức theo cấu trúc module (models / widgets / screens).
- Mỗi công việc (todo) được đại diện bởi `Todo` với các trường `id`, `title`, `isDone`, `createdTime`.

## Cấu trúc dự án (đã tách)

- `lib/main.dart` — Entrypoint, khởi chạy `AdvancedTodoApp`.
- `lib/screens/advanced_todo_app.dart` — Giao diện chính và logic quản lý công việc (Tab: Danh sách / Lịch).
- `lib/screens/calendar_screen.dart` — **MỚI**: Lịch tháng với thống kê công việc theo ngày.
- `lib/models/todo.dart` — Định nghĩa model `Todo`.
- `lib/widgets/todo_item.dart` — Widget cho từng mục todo (Dismissible + ListTile).
- `lib/widgets/header.dart` — Header hiển thị tiến độ và thống kê.

## Tính năng

- **Danh sách công việc**: Thêm / Sửa công việc (qua dialog), xóa bằng vuốt (`Dismissible`) với lựa chọn Hoàn tác.
- **Đánh dấu hoàn thành**: Checkbox tròn, tự động sắp xếp (chưa hoàn thành lên trên).
- **Thanh tiến độ**: Hiển thị phần trăm hoàn thành.
- **Lịch tháng (NEW)**: Xem công việc theo ngày với thống kê:
  - Hiển thị số công việc: `completed/total` trên mỗi ô ngày.
  - Màu sắc: Xanh (all done) / Cam (in progress) / Xám (no tasks).
  - Số công việc chưa làm (red badge) ở góc trên phải.
  - Click ngày để xem chi tiết công việc trong bottom sheet.

## Hướng dẫn chạy

1. Cài đặt Flutter và thiết lập device/emulator.
2. Mở terminal tại thư mục chứa `pubspec.yaml` của `todo_app2`.
3. Chạy các lệnh:

```bash
flutter pub get
flutter analyze
flutter run
```

Gợi ý: nếu dùng Android Studio/VS Code, mở workspace và chạy trực tiếp từ IDE.

## Gợi ý nâng cao

- Lưu dữ liệu: thêm `shared_preferences`, `hive` hoặc `sqflite` để lưu todos.
- Quản lý trạng thái: dùng `Provider` / `Riverpod` / `Bloc` khi app phức tạp hơn.
- Sync/Backup: tích hợp Cloud Firestore hoặc SQLite sync cho nhiều thiết bị.
- ID tốt hơn: thay `DateTime.now().toString()` bằng UUID (`uuid` package) để tránh trùng lặp.

## Lưu ý kỹ thuật

- `Dismissible` sử dụng key từ `todo.id` — cần đảm bảo id là duy nhất.
- Các method chính nằm trong `lib/screens/advanced_todo_app.dart`: `_showTaskDialog`, `_toggleTask`, `_deleteTask`, `_sortTasks`.
- **Calendar**: Tính toán số công việc theo ngày dựa vào `createdTime` của `Todo`. Tự động cập nhật khi thêm/xóa/hoàn thành công việc.
- **Tab navigation**: TabController quản lý 2 tab (Danh sách / Lịch); FAB chỉ hiển thị ở tab Danh sách.

## Muốn mình làm gì tiếp theo?

- Thêm lưu trữ cục bộ (Hive/SharedPreferences).
- Thêm lọc/sắp xếp trong UI.
- Tách logic vào service (ví dụ `lib/services/todo_service.dart`) và viết unit tests.

---

README này đã được cập nhật tự động dựa trên mã nguồn hiện tại.
