import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Counter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0; // Khởi tạo số đếm bằng 0 [cite: 7]

  // Hàm tăng số
  void _incrementCounter() {
    setState(() {
      _counter++; // Cập nhật realtime [cite: 10, 18]
    });
  }

  // Hàm giảm số
  void _decrementCounter() {
    if (_counter > 0) {
      // Điều kiện để không giảm xuống dưới 0 [cite: 25]
      setState(() {
        _counter--;
      });
    }
  }

  // Hàm Reset (Bonus) [cite: 27, 28]
  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  // Hàm xác định màu nền động (Bonus) [cite: 29]
  Color _getBackgroundColor() {
    if (_counter > 0)
      return Colors.green.shade100; // Số dương -> nền xanh [cite: 30]
    if (_counter < 0) return Colors.red.shade100; // Số âm -> nền đỏ [cite: 31]
    return Colors.grey.shade300; // Số 0 -> nền xám [cite: 32]
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sử dụng Scaffold làm khung chính [cite: 21]
      backgroundColor: _getBackgroundColor(),
      appBar: AppBar(title: const Text("Counter App")),
      body: Center(
        // Căn giữa màn hình [cite: 14, 22]
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_counter',
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ), // Font size 72 [cite: 22, 56]
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút Giảm (-)
                ElevatedButton(
                  onPressed: _counter == 0
                      ? null
                      : _decrementCounter, // Disable khi số = 0 [cite: 25, 54]
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ), // Nút màu đỏ [cite: 24, 58]
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
                const SizedBox(width: 20),
                // Nút Tăng (+)
                ElevatedButton(
                  onPressed: _incrementCounter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ), // Nút màu xanh lá [cite: 23, 58]
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Nút Reset (Bonus)
            TextButton(
              onPressed: _resetCounter,
              child: const Text(
                "Reset",
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
