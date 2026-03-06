# Hướng Dẫn Sử Dụng Phần Login - Smart Note App

## 📱 Tính Năng Chính

### 1. **Đăng Ký (Register)**

- Người dùng cần cung cấp:
  - **Email**: Phải là email hợp lệ (định dạng: user@example.com)
  - **Mật khẩu**: Tối thiểu 6 ký tự
  - **Xác nhận mật khẩu**: Phải khớp với mật khẩu đã nhập
- Dữ liệu được lưu trữ cục bộ bằng SharedPreferences
- Mỗi email chỉ có thể đăng ký một lần

### 2. **Đăng Nhập (Login)**

- Nhập email và mật khẩu đã đăng ký
- Ứng dụng sẽ kiểm tra thông tin
- Nếu chính xác, người dùng sẽ được chuyển đến HomeScreen
- Trạng thái đăng nhập sẽ được lưu

### 3. **Đăng Xuất (Logout)**

- Click vào menu (3 dấu chấm) ở góc trên phải của HomeScreen
- Chọn "Đăng xuất"
- Xác nhận lại
- Sẽ được chuyển về LoginScreen

## 🔧 Cấu Trúc Files

```
lib/
├── main.dart                    # File chính (cập nhật để sử dụng LoginScreen)
├── services/
│   └── auth_service.dart       # Dịch vụ xác thực
├── screens/
│   ├── login_screen.dart       # Màn hình đăng nhập/đăng ký
│   ├── home_screen.dart        # Màn hình chính (thêm nút đăng xuất)
│   └── edit_note_screen.dart   # Màn hình chỉnh sửa ghi chú (không thay đổi)
├── models/
│   └── note.dart
└── storage/
    └── note_storage.dart
```

## 🚀 Các Bước Sử Dụng

### Lần Đầu Sử Dụng:

1. Ứng dụng sẽ hiển thị **LoginScreen**
2. Nhấp vào "Đăng ký" để tạo tài khoản
3. Điền email, mật khẩu, và xác nhận mật khẩu
4. Nhấp "Đăng Ký"
5. Sau khi đăng ký thành công, hãy đăng nhập với tài khoản vừa tạo

### Các Lần Tiếp Theo:

1. Nhập email và mật khẩu đã đăng ký
2. Nhấp "Đăng Nhập"
3. Sẽ được chuyển đến HomeScreen

### Để Đăng Xuất:

1. Ở HomeScreen, nhấp vào icon menu (≡) ở góc trên phải
2. Chọn "Đăng xuất"
3. Xác nhận khi được hỏi

## 🔐 Bảo Mật

- **Lưu trữ cục bộ**: Dữ liệu được lưu trên thiết bị bằng SharedPreferences
- **Mật khẩu**: Tối thiểu 6 ký tự
- **Email**: Phải hợp lệ (có @ và domain)
- **Trạng thái đăng nhập**: Được lưu và kiểm tra khi khởi động ứng dụng

## 🛠️ Chi Tiết Kỹ Thuật

### AuthService (services/auth_service.dart)

Cung cấp các phương thức:

- `register(email, password)`: Đăng ký tài khoản mới
- `login(email, password)`: Đăng nhập
- `logout()`: Đăng xuất
- `isLoggedIn()`: Kiểm tra trạng thái đăng nhập
- `getCurrentEmail()`: Lấy email người dùng hiện tại
- `clearUserData()`: Xóa dữ liệu người dùng

### LoginScreen (screens/login_screen.dart)

- Giao diện gradient đẹp mắt
- Chế độ đăng nhập/đăng ký có thể chuyển đổi
- Hiển thị/ẩn mật khẩu
- Xử lý lỗi chi tiết
- Hiệu ứng loading khi xử lý

### HomeScreen (screens/home_screen.dart)

- Thêm nút "Đăng xuất" trong AppBar
- Xác nhận trước khi đăng xuất
- Chuyển trở lại LoginScreen sau khi đăng xuất

## 📝 Ghi Chú

1. Dữ liệu người dùng được lưu trữ cục bộ chỉ - không có server
2. Mỗi thiết bị chỉ có thể lưu một tài khoản
3. Nếu muốn đăng ký tài khoản khác, cần đăng xuất trước hoặc xóa dữ liệu ứng dụng
4. SharedPreferences lưu trữ dữ liệu an toàn ở cấp độ hệ thống Android/iOS

## ⚠️ Hạn Chế Hiện Tại

- Không có khôi phục mật khẩu
- Không có xác thực hai bước
- Chỉ hỗ trợ một tài khoản trên một thiết bị
- Mật khẩu được lưu dưới dạng text (trong môi trường thực, nên mã hóa)

## 🔄 Cải Tiến Tương Lai

Nếu muốn nâng cao bảo mật, bạn có thể:

1. Thêm mã hóa cho mật khẩu (crypto package)
2. Thêm xác thực hai bước (2FA)
3. Kết nối với Firebase hoặc backend server
4. Thêm khôi phục mật khẩu qua email
5. Cho phép nhiều tài khoản trên một thiết bị

---

**Tác giả**: Hệ thống Smart Note
**Phiên bản**: 1.0.0
**Cập nhật lần cuối**: 2026-03-05
