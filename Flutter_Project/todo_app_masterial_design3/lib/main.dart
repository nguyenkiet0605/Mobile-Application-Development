import 'package:flutter/material.dart';
import 'todo_model.dart';
import 'todo_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6366F1),
          foregroundColor: Colors.white,
          elevation: 8,
        ),
      ),
      home: const TodoApp(),
    );
  }
}

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  // Dữ liệu chỉ lưu trên RAM (tắt app là mất)
  List<Todo> _todos = [];
  List<Todo> _foundTodos = [];

  int _filterIndex = 0; // 0: Tất cả, 1: Chưa xong, 2: Đã xong
  final TextEditingController _searchController = TextEditingController();

  // --- LOGIC TÌM KIẾM & LỌC ---
  void _runFilterAndSearch(String keyword) {
    List<Todo> results = [];

    // 1. Lọc theo Tab
    if (_filterIndex == 0) {
      results = _todos;
    } else if (_filterIndex == 1) {
      results = _todos.where((item) => !item.isCompleted).toList();
    } else {
      results = _todos.where((item) => item.isCompleted).toList();
    }

    // 2. Lọc theo từ khóa tìm kiếm
    if (keyword.isNotEmpty) {
      results = results
          .where(
            (item) => item.title.toLowerCase().contains(keyword.toLowerCase()),
          )
          .toList();
    }

    setState(() {
      _foundTodos = results;
    });
  }

  // --- CÁC HÀM XỬ LÝ (Không còn Save/Load) ---

  // Hàm xóa
  void _deleteTodo(Todo todo) {
    setState(() {
      _todos.remove(todo);
      _runFilterAndSearch(_searchController.text); // Cập nhật lại list hiển thị
    });
  }

  // Hàm đổi trạng thái (Xong/Chưa xong)
  void _toggleStatus(Todo todo, bool value) {
    setState(() {
      todo.isCompleted = value;
      _runFilterAndSearch(_searchController.text);
    });
  }

  // Hàm hiển thị Dialog Thêm/Sửa
  void _showAddEditDialog({Todo? todoToEdit}) {
    final TextEditingController _controller = TextEditingController();
    DateTime? _selectedDeadline;

    // Nếu là sửa, điền dữ liệu cũ vào
    if (todoToEdit != null) {
      _controller.text = todoToEdit.title;
      _selectedDeadline = todoToEdit.deadline;
    }

    showDialog(
      context: context,
      builder: (context) {
        // StatefulBuilder để cập nhật giao diện TRONG Dialog (khi chọn ngày giờ)
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(
                todoToEdit == null ? '✨ Thêm công việc' : '✏️ Sửa công việc',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF6366F1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Nhập nội dung...",
                      labelText: "Nội dung công việc",
                      prefixIcon: const Icon(
                        Icons.task_alt,
                        color: Color(0xFF6366F1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE0E7FF),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE0E7FF),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF6366F1),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Nút chọn ngày giờ
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          icon: const Icon(Icons.calendar_today, size: 18),
                          label: Text(
                            _selectedDeadline == null
                                ? "📅 Chọn hạn chót"
                                : "📅 ${_selectedDeadline!.day}/${_selectedDeadline!.month} ${_selectedDeadline!.hour}:${_selectedDeadline!.minute}",
                          ),
                          onPressed: () async {
                            // 1. Chọn ngày
                            final DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: _selectedDeadline ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (date == null) return;

                            // 2. Chọn giờ
                            final TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                _selectedDeadline ?? DateTime.now(),
                              ),
                            );
                            if (time == null) return;

                            // 3. Cập nhật biến tạm trong Dialog
                            setStateDialog(() {
                              _selectedDeadline = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          },
                        ),
                      ),
                      // Nút xóa ngày đã chọn
                      if (_selectedDeadline != null)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setStateDialog(() => _selectedDeadline = null);
                          },
                        ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy', style: TextStyle(fontSize: 14)),
                ),
                FilledButton.icon(
                  onPressed: () {
                    if (_controller.text.trim().isEmpty) return;

                    // Cập nhật dữ liệu chính
                    setState(() {
                      if (todoToEdit == null) {
                        // Thêm mới
                        _todos.add(
                          Todo(
                            id: DateTime.now().toString(),
                            title: _controller.text.trim(),
                            deadline: _selectedDeadline,
                          ),
                        );
                      } else {
                        // Sửa
                        todoToEdit.title = _controller.text.trim();
                        todoToEdit.deadline = _selectedDeadline;
                      }
                      // Refresh lại danh sách tìm kiếm
                      _runFilterAndSearch(_searchController.text);
                    });
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Lưu'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Dialog xác nhận xóa
  void _confirmDelete(Todo todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "🗑️ Xóa công việc",
          style: TextStyle(
            color: Color(0xFF6366F1),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text("Bạn có chắc muốn xóa công việc này không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy", style: TextStyle(fontSize: 14)),
          ),
          FilledButton.tonalIcon(
            onPressed: () {
              _deleteTodo(todo);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
            label: const Text("Xóa"),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade200,
              foregroundColor: Colors.red.shade900,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách công việc'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Ô Tìm kiếm
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _runFilterAndSearch,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm công việc...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Bộ lọc Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('📋 Tất cả', 0),
                  const SizedBox(width: 12),
                  _buildFilterChip('⏳ Chưa xong', 1),
                  const SizedBox(width: 12),
                  _buildFilterChip('✅ Đã xong', 2),
                ],
              ),
            ),
          ),

          // Danh sách hiển thị
          Expanded(
            child: _foundTodos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _todos.isEmpty ? Icons.task_alt : Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _todos.isEmpty ? "Danh sách trống" : "Không tìm thấy",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80, top: 10),
                    itemCount: _foundTodos.length,
                    itemBuilder: (context, index) {
                      // Lấy item từ danh sách đã lọc
                      final todo = _foundTodos[index];
                      return TodoItemWidget(
                        todo: todo,
                        onStatusChanged: (v) => _toggleStatus(todo, v!),
                        onEdit: () => _showAddEditDialog(todoToEdit: todo),
                        onDelete: () => _confirmDelete(todo),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        tooltip: 'Thêm công việc',
        backgroundColor: const Color(0xFF6366F1),
        elevation: 8,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _filterIndex == index;
    return Container(
      decoration: BoxDecoration(
        gradient: isSelected
            ? const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(50),
      ),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF6366F1),
            fontWeight: FontWeight.bold,
          ),
        ),
        selected: isSelected,
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: isSelected ? Colors.transparent : const Color(0xFFE0E7FF),
          width: 2,
        ),
        onSelected: (bool selected) {
          setState(() {
            _filterIndex = index;
            _runFilterAndSearch(_searchController.text);
          });
        },
      ),
    );
  }
}
