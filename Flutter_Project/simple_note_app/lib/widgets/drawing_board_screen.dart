import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'dart:typed_data';

/// Widget cho phép vẽ tay trên ghi chú
class DrawingBoardScreen extends StatefulWidget {
  final String title;

  const DrawingBoardScreen({Key? key, this.title = 'Vẽ Tay'}) : super(key: key);

  @override
  State<DrawingBoardScreen> createState() => _DrawingBoardScreenState();
}

class _DrawingBoardScreenState extends State<DrawingBoardScreen> {
  late DrawingBoardController _drawingBoardController;
  Color _selectedColor = Colors.black;
  double _strokeWidth = 2.0;

  @override
  void initState() {
    super.initState();
    _drawingBoardController = DrawingBoardController(background: Colors.white);
  }

  @override
  void dispose() {
    _drawingBoardController.dispose();
    super.dispose();
  }

  /// Lưu bảng vẽ thành image bytes
  void _saveDrawing() async {
    try {
      final imageBytes = await _drawingBoardController.getImage();
      if (imageBytes != null) {
        Navigator.pop(context, imageBytes);
      }
    } catch (e) {
      _showErrorSnackBar('Lỗi lưu bản vẽ: $e');
    }
  }

  /// Xóa bảng vẽ
  void _clearDrawing() {
    _drawingBoardController.clear();
  }

  /// Hoàn tác lần vẽ cuối
  void _undo() {
    _drawingBoardController.undo();
  }

  /// Hiển thị thông báo lỗi
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 8,
        shadowColor: const Color(0xFF6366F1).withOpacity(0.3),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveDrawing,
            tooltip: 'Lưu bản vẽ',
          ),
        ],
      ),
      body: Column(
        children: [
          // Thanh công cụ
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                // Chọn màu
                IconButton(
                  icon: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                  ),
                  onPressed: () => _showColorPicker(),
                  tooltip: 'Chọn màu',
                ),
                const SizedBox(width: 8),

                // Chọn độ dày nét vẽ
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Độ dày:', style: TextStyle(fontSize: 12)),
                      Slider(
                        value: _strokeWidth,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: _strokeWidth.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() {
                            _strokeWidth = value;
                            _drawingBoardController.setStrokeWidth(value);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Nút hoàn tác
                IconButton(
                  icon: const Icon(Icons.undo),
                  onPressed: _undo,
                  tooltip: 'Hoàn tác',
                ),

                // Nút xóa
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearDrawing,
                  tooltip: 'Xóa toàn bộ',
                ),
              ],
            ),
          ),

          // Bảng vẽ
          Expanded(
            child: DrawingBoard(
              controller: _drawingBoardController,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 200,
              backgroundColor: Colors.white,
              drawingConstraints: const DrawingConstraints(
                strokeCap: StrokeCap.round,
                strokeJoin: StrokeJoin.round,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Hiển thị bảng chọn màu
  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: _colorPalette.length,
            itemBuilder: (context, index) {
              final color = _colorPalette[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                    _drawingBoardController.setColor(color);
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color == _selectedColor
                          ? Colors.black
                          : Colors.grey,
                      width: color == _selectedColor ? 3 : 1,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Bảng màu mẫu
  static const List<Color> _colorPalette = [
    Colors.black,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
    Colors.cyan,
  ];
}
