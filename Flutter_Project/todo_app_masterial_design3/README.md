# ✨ Todo App - Material Design 3

Một ứng dụng quản lý danh sách công việc hiện đại được xây dựng bằng Flutter với Material Design 3. App hỗ trợ multi-platform (Android, iOS, Web, Windows, macOS, Linux).

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 📱 Tính năng chính

- ✅ **Thêm/Sửa/Xóa công việc** - Quản lý công việc dễ dàng
- 📅 **Hạn chót công việc** - Đặt ngày giờ cho từng công việc
- 🔔 **Cảnh báo quá hạn** - Hiển thị badge khi công việc quá hạn
- 🔍 **Tìm kiếm công việc** - Tìm kiếm theo từ khóa nhanh chóng
- 🎯 **Lọc theo trạng thái** - Xem tất cả, chưa xong, hoặc đã xong
- ✨ **Giao diện Material Design 3** - Thiết kế hiện đại với gradient & animations
- 💫 **Checkbox trạng thái** - Đánh dấu công việc hoàn thành
- 🌈 **Màu sắc đẹp** - Indigo theme với shadow effects

## 🚀 Cài đặt & Chạy

### Yêu cầu

- Flutter 3.0+
- Dart 3.0+

### Bước 1: Clone project

```bash
git clone <repository-url>
cd todo_app_masterial_design3
```

### Bước 2: Cài đặt dependencies

```bash
flutter pub get
```

### Bước 3: Chạy trên thiết bị/emulator

```bash
# Android/iOS
flutter run

# Web
flutter run -d chrome

# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

## 📁 Cấu trúc project

```
lib/
├── main.dart           # Entry point & main UI
├── todo_model.dart     # Model định nghĩa Todo
└── todo_item.dart      # Widget hiển thị item Todo
```

## 📖 Hướng dẫn sử dụng

### Thêm công việc

1. Nhấn nút **➕ Thêm** hoặc FAB
2. Nhập nội dung công việc
3. (Tùy chọn) Chọn hạn chót ngày/giờ
4. Nhấn **Lưu**

### Sửa công việc

1. Nhấn icon ✏️ trên công việc cần sửa
2. Chỉnh sửa nội dung hoặc hạn chót
3. Nhấn **Lưu**

### Xóa công việc

1. Nhấn icon 🗑️ trên công việc
2. Xác nhận xóa

### Tìm kiếm & Lọc

- Sử dụng search bar để tìm kiếm theo từ khóa
- Sử dụng Chips để lọc: **📋 Tất cả**, **⏳ Chưa xong**, **✅ Đã xong**

### Đánh dấu hoàn thành

- Nhấn checkbox bên trái công việc để đánh dấu hoàn thành

## 🎨 Material Design 3 Features

- **Color Scheme**: Indigo primary color (#6366F1)
- **Typography**: Dynamic font scaling theo hệ thống
- **Elevation**: Cards với shadow effects
- **Gradients**: Background gradient subtle
- **Animations**: Smooth transitions & interactions
- **Responsive**: Hoạt động tốt trên tất cả kích thước màn hình

## 💾 Data Storage

Dữ liệu công việc hiện được lưu trữ **tạm thời trên RAM**. Khi tắt app, dữ liệu sẽ mất.

_Trong tương lai có thể mở rộng để lưu vào local database (SQLite, Hive, etc.)_

## 🛠️ Technologies Used

- **Flutter** - UI framework
- **Dart** - Programming language
- **Material Design 3** - Design system
- **Null Safety** - Dart null safety

## 📝 License

MIT License - xem file LICENSE để biết thêm chi tiết.

## 👨‍💻 Author

Phát triển bởi [Your Name/Team]

## 🤝 Đóng góp

Chúng tôi hoan nghênh các pull request và bug reports!

## 📧 Liên hệ

- Email: your.email@example.com
- Website: your-website.com

---

**Hạnh phúc lập trình! 🎉**
