# Thông tin lưu trữ dữ liệu cho Simple Note App

## Vị trí lưu trữ trên thiết bị

- **Android**: Thư mục ứng dụng (`getApplicationDocumentsDirectory()`), thường nằm tại:
  `Android/data/<package_name>/files/` hoặc `/data/data/<package_name>/files/`.
  - Ghi chú và các file liên quan sẽ được đặt trong `notes/`.
  - Ảnh: `notes/images/`
  - File đính kèm: `notes/attachments/`
  - Bản vẽ tay: `notes/drawings/`

- **iOS**: `Library/Application Support/` của ứng dụng.
  - Cấu trúc tương tự: `notes/`, `notes/images/`, `notes/attachments/`, `notes/drawings/`.

- **Windows**: `AppData/Local/<package_name>/` (qua `getApplicationDocumentsDirectory`).

## Mã hóa và quyền truy cập

- Các file được lưu trên bộ nhớ trong của ứng dụng; người dùng khác không thể dễ dàng truy cập nếu không có quyền root.
- Ứng dụng không mã hóa dữ liệu; nếu cần bảo mật cao hơn, hãy sử dụng plugin như `flutter_secure_storage` hoặc mã hóa trước khi lưu vào file.
- Trên Android, cần xin quyền `READ_EXTERNAL_STORAGE`/`WRITE_EXTERNAL_STORAGE` nếu lấy ảnh từ thư viện (sử dụng `permission_handler`). Trên iOS, yêu cầu quyền ảnh.

## Cách hoạt động

- Khi người dùng thêm ảnh hoặc file, ứng dụng sẽ sao chép file vào thư mục thích hợp của ứng dụng và lưu đường dẫn.
- Bản vẽ tay lưu dưới dạng PNG vào thư mục `drawings`.
- Khi xóa ghi chú, các file liên quan có thể được xóa thủ công bằng `StorageService.deleteNoteFiles`.

## Tham khảo

- [path_provider package](https://pub.dev/packages/path_provider)
- [permission_handler package](https://pub.dev/packages/permission_handler)

---
