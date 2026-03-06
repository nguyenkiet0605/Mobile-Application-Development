import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _emailKey = 'user_email';
  static const String _passwordKey = 'user_password';
  static const String _isLoggedInKey = 'is_logged_in';

  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  /// Đăng ký người dùng mới
  Future<bool> register(String email, String password) async {
    try {
      // Kiểm tra email có hợp lệ không
      if (!_isValidEmail(email)) {
        return false;
      }

      // Kiểm tra mật khẩu có đủ mạnh không (ít nhất 6 ký tự)
      if (password.length < 6) {
        return false;
      }

      final prefs = await SharedPreferences.getInstance();

      // Kiểm tra email đã đăng ký hay chưa
      final existingEmail = prefs.getString(_emailKey);
      if (existingEmail == email) {
        return false;
      }

      // Lưu thông tin người dùng
      await prefs.setString(_emailKey, email);
      await prefs.setString(_passwordKey, password);
      await prefs.setBool(_isLoggedInKey, true);

      return true;
    } catch (e) {
      print('Error in register: $e');
      return false;
    }
  }

  /// Đăng nhập
  Future<bool> login(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedEmail = prefs.getString(_emailKey);
      final savedPassword = prefs.getString(_passwordKey);

      // Kiểm tra email và mật khẩu có khớp không
      if (savedEmail == email && savedPassword == password) {
        await prefs.setBool(_isLoggedInKey, true);
        return true;
      }

      return false;
    } catch (e) {
      print('Error in login: $e');
      return false;
    }
  }

  /// Đăng xuất
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, false);
    } catch (e) {
      print('Error in logout: $e');
    }
  }

  /// Kiểm tra người dùng đã đăng nhập hay chưa
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      print('Error in isLoggedIn: $e');
      return false;
    }
  }

  /// Lấy email của người dùng hiện tại
  Future<String?> getCurrentEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_emailKey);
    } catch (e) {
      print('Error in getCurrentEmail: $e');
      return null;
    }
  }

  /// Kiểm tra email có hợp lệ không
  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Xóa toàn bộ dữ liệu người dùng
  Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_emailKey);
      await prefs.remove(_passwordKey);
      await prefs.setBool(_isLoggedInKey, false);
    } catch (e) {
      print('Error in clearUserData: $e');
    }
  }
}
