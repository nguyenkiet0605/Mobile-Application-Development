import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../widgets/todo_item.dart';
import '../widgets/header.dart';
import 'calendar_screen.dart';

class AdvancedTodoApp extends StatefulWidget {
  const AdvancedTodoApp({super.key});

  @override
  State<AdvancedTodoApp> createState() => _AdvancedTodoAppState();
}

class _AdvancedTodoAppState extends State<AdvancedTodoApp>
    with SingleTickerProviderStateMixin {
  List<Todo> todos = [];
  late TabController _tabController;

  void _showTaskDialog({Todo? todoToEdit, int? index}) {
    final TextEditingController controller = TextEditingController(
      text: todoToEdit?.title ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          todoToEdit == null ? 'Thêm công việc mới' : 'Sửa công việc',
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Nhập nội dung...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  if (todoToEdit == null) {
                    todos.add(
                      Todo(
                        id: DateTime.now().toString(),
                        title: controller.text,
                        createdTime: DateTime.now(),
                      ),
                    );
                  } else {
                    todos[index!].title = controller.text;
                  }
                });
                Navigator.pop(context);
              }
            },
            child: Text(todoToEdit == null ? 'Thêm' : 'Lưu'),
          ),
        ],
      ),
    );
  }

  void _toggleTask(int index) {
    setState(() {
      todos[index].isDone = !todos[index].isDone;
      _sortTasks();
    });
  }

  void _deleteTask(int index) {
    final deletedTask = todos[index];
    setState(() => todos.removeAt(index));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa "${deletedTask.title}"'),
        action: SnackBarAction(
          label: 'HOÀN TÁC',
          onPressed: () => setState(() => todos.insert(index, deletedTask)),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _sortTasks() {
    todos.sort((a, b) {
      if (a.isDone == b.isDone) return b.createdTime.compareTo(a.createdTime);
      return a.isDone ? 1 : -1;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int total = todos.length;
    final int completed = todos.where((t) => t.isDone).length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigoAccent,
        title: const Text(
          'My Tasks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Danh sách'),
            Tab(text: 'Lịch'),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => _showTaskDialog(),
              backgroundColor: Colors.indigoAccent,
              icon: const Icon(Icons.add),
              label: const Text('Công việc mới'),
            )
          : null,
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Danh sách
          Column(
            children: [
              TasksHeader(total: total, completed: completed),
              const SizedBox(height: 16),
              Expanded(
                child: todos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_alt,
                              size: 80,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Bạn rảnh rỗi quá!',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final task = todos[index];
                          return TodoItem(
                            todo: task,
                            index: index,
                            onToggle: (i) => _toggleTask(i),
                            onEdit: () =>
                                _showTaskDialog(todoToEdit: task, index: index),
                            onDelete: () => _deleteTask(index),
                          );
                        },
                      ),
              ),
            ],
          ),
          // Tab 2: Lịch
          CalendarScreen(todos: todos, selectedDate: DateTime.now()),
        ],
      ),
    );
  }
}
