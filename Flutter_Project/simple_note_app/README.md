# 📝 Simple Note App - Flutter

Ứng dụng quản lý ghi chú đơn giản nhưng đầy đủ tính năng, được xây dựng bằng Flutter với Material Design 3.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)

## 🎯 Tính năng chính

✨ **Tính năng cơ bản:**

- ✅ Xem danh sách ghi chú trên home screen
- ➕ Thêm ghi chú mới
- ✏️ Sửa ghi chú
- 🗑️ Xóa ghi chú (có xác nhận trước)
- 📅 Hiển thị thời gian cập nhật (vừa xong, 10 phút trước, v.v.)
- 👁️ Preview nội dung ghi chú (50 ký tự đầu)

🚀 **Tính năng nâng cao:**

- 🎨 Material Design 3 - Indigo theme với gradient & shadow
- ✨ Animation chuyển màn hình (Fade + Scale)
- 🎯 Animation nhấn nút (Scale animation trên card)
- 📱 Responsive design - hoạt động trên mọi kích thước
- 💫 Smooth transitions & interactions

## 🛠️ Kỹ năng được áp dụng

### Navigation

- `Navigator.push()` - Đi tới màn hình thêm/sửa ghi chú
- `Navigator.pop()` - Quay lại màn hình trước
- `PageRouteBuilder` - Tạo animation custom cho transitions
- Fade + Scale animation cho page transition

### Data Passing

- Truyền data từ home → add/edit screen (noteToEdit)
- Return data từ add/edit screen → home (result)
- Cập nhật danh sách dựa trên data trả về

### Material Design 3

- ColorScheme.fromSeed - Dynamic color generation
- Card với elevation & shadow
- Gradient backgrounds
- Typography - Dynamic font scaling
- Chips, Buttons, TextFields styled theo M3
- Animations & transitions

## 📁 Cấu trúc project

```
lib/
├── main.dart                    # Entry point
├── screens/
│   ├── home_screen.dart        # Danh sách ghi chú
│   └── add_note_screen.dart    # Thêm/Sửa ghi chú
├── models/
│   └── note_model.dart         # Model Note
└── widgets/
    └── note_card.dart          # Widget hiển thị note item
```

## 🚀 Chạy ứng dụng

### Yêu cầu

- Flutter 3.0+
- Dart 3.0+

### Cài đặt dependencies

```bash
cd simple_note_app
flutter pub get
```

### Chạy trên các nền tảng

```bash
# Android/iOS
flutter run

# Web
flutter run -d chrome

# Thiết bị thực
flutter run
```

## 📝 Hướng dẫn sử dụng

### Xem ghi chú

1. Mở app - hiển thị danh sách ghi chú
2. Mỗi card hiển thị: tiêu đề, preview, thời gian cập nhật

### Thêm ghi chú mới

1. Nhấn nút ➕ FAB
2. Nhập tiêu đề (tùy chọn) & nội dung
3. Nhấn "Lưu"

### Sửa ghi chú

1. Nhấn vào card HOẶC icon ✏️
2. Chỉnh sửa nội dung
3. Nhấn "Cập nhật"

### Xóa ghi chú

1. Nhấn icon 🗑️
2. Xác nhận xóa

## 🎨 Giao diện & Animation

- **Màu sắc**: Indigo theme (#6366F1)
- **Animation**: Page transition (Fade + Scale), Slide, Scale on tap
- **Background**: Subtle gradient
- **Responsive**: Hoạt động trên mọi screen size

## 💡 Điểm học tập

✅ Navigator.push/pop  
✅ Truyền dữ liệu giữa màn hình  
✅ Material Design 3  
✅ Custom animations  
✅ State management cơ bản  
✅ Dialog & SnackBar

---

**Hạnh phúc lập trình! 🎉**
