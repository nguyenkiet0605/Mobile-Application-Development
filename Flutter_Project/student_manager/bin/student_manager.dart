import 'dart:io';

class Student {
  String id;
  String name;
  double grade;

  Student({required this.id, required this.name, required this.grade});

  @override
  String toString() => 'ID: $id | Tên: $name | Điểm: $grade';
}

void main() {
  List<Student> students = []; // Danh sách để quản lý sinh viên

  while (true) {
    print('\n--- MENU QUẢN LÝ ---');
    print('1. Thêm sinh viên');
    print('2. Hiển thị & Tính điểm TB');
    print('3. Thoát');
    stdout.write('Chọn: ');
    String? choice = stdin.readLineSync();

    if (choice == '1') {
      // Logic Thêm sinh viên
      stdout.write('Nhập ID: ');
      String id = stdin.readLineSync()!;
      stdout.write('Nhập Tên: ');
      String name = stdin.readLineSync()!;
      stdout.write('Nhập Điểm: ');
      double grade = double.parse(stdin.readLineSync() ?? '0');

      students.add(Student(id: id, name: name, grade: grade));
      print('Đã thêm thành công!');
    } else if (choice == '2') {
      // Logic Hiển thị & Tính điểm trung bình
      if (students.isEmpty) {
        print('Danh sách trống!');
      } else {
        double total = 0;
        for (var s in students) {
          print(s);
          total += s.grade;
        }
        print(
          '=> Điểm trung bình: ${(total / students.length).toStringAsFixed(2)}',
        );
      }
    } else if (choice == '3') {
      print('Tạm biệt!');
      break;
    }
  }
}
