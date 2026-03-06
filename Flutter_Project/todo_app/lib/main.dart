import 'package:flutter/material.dart';

void main() => runApp(const TodoApp());

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const TodoHome(),
    );
  }
}

class Task {
  String title;
  bool done;
  DateTime createdAt;
  Task({required this.title, this.done = false}) : createdAt = DateTime.now();
}

class TodoHome extends StatefulWidget {
  const TodoHome({super.key});

  @override
  State<TodoHome> createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  final List<Task> _tasks = [];
  final TextEditingController _controller = TextEditingController();
  bool _completedLast = true; // completed items go to bottom

  void _addTask(String text) {
    final t = text.trim();
    if (t.isEmpty) return;
    setState(() {
      _tasks.add(Task(title: t));
      _applySort();
    });
    _controller.clear();
    Navigator.of(context).pop(); // close bottom sheet
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã thêm công việc')));
  }

  void _deleteTask(int index) {
    final removed = _tasks[index];
    setState(() => _tasks.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa "${removed.title}"'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () {
            setState(() => _tasks.insert(index, removed));
          },
        ),
      ),
    );
  }

  void _toggleDone(int index, bool? value) {
    if (value == null) return;
    setState(() {
      _tasks[index].done = value;
      _applySort();
    });
  }

  void _applySort() {
    _tasks.sort((a, b) {
      if (a.done == b.done) return b.createdAt.compareTo(a.createdAt);
      return a.done ? 1 : -1;
    });
    if (!_completedLast) {
      _tasks.sort((a, b) {
        if (a.done == b.done) return b.createdAt.compareTo(a.createdAt);
        return a.done ? -1 : 1;
      });
    }
  }

  void _toggleSortMode() {
    setState(() {
      _completedLast = !_completedLast;
      _applySort();
    });
  }

  Future<void> _showAddTaskSheet() async {
    _controller.clear();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Gõ công việc và nhấn Thêm',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: _addTask,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _addTask(_controller.text),
                    child: const Text('Thêm'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.workspace_premium, size: 96, color: Colors.white70),
          SizedBox(height: 12),
          Text(
            'Chưa có công việc',
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
          SizedBox(height: 6),
          Text(
            'Nhấn nút + để thêm công việc mới',
            style: TextStyle(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(int index) {
    final editController = TextEditingController(text: _tasks[index].title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa công việc'),
        content: TextField(controller: editController, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final v = editController.text.trim();
              if (v.isNotEmpty) setState(() => _tasks[index].title = v);
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final count = _tasks.length;
    final remaining = _tasks.where((t) => !t.done).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo — Flutter'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(
                'Còn lại: $remaining',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          IconButton(
            tooltip: _completedLast
                ? 'Hoàn thành xuống dưới'
                : 'Hoàn thành lên trên',
            icon: Icon(
              _completedLast ? Icons.filter_alt_off : Icons.filter_alt,
            ),
            onPressed: _toggleSortMode,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 88, 12, 12),
          child: Column(
            children: [
              Card(
                elevation: 6,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Thêm công việc...',
                          ),
                          onSubmitted: (v) => _showAddTaskSheet(),
                          readOnly: true,
                          onTap: _showAddTaskSheet,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _showAddTaskSheet,
                        icon: const Icon(Icons.add),
                        label: const Text('Thêm'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: count == 0
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          final task = _tasks[index];
                          final hue = (index * 35) % 360;
                          final base = HSLColor.fromAHSL(
                            1.0,
                            hue.toDouble(),
                            0.62,
                            task.done ? 0.88 : 0.75,
                          ).toColor();
                          final start = base.withOpacity(0.18);
                          final end = base.withOpacity(0.06);

                          return Dismissible(
                            key: ValueKey(
                              task.createdAt.toIso8601String() + task.title,
                            ),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.only(right: 20),
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (_) => _deleteTask(index),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(colors: [start, end]),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: base,
                                  child: Icon(
                                    task.done ? Icons.check : Icons.task,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    decoration: task.done
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: task.done
                                        ? Colors.black45
                                        : Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  '${task.createdAt.hour.toString().padLeft(2, '0')}:${task.createdAt.minute.toString().padLeft(2, '0')} • ${task.createdAt.day}/${task.createdAt.month}/${task.createdAt.year}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: task.done,
                                      onChanged: (v) => _toggleDone(index, v),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (_) => SafeArea(
                                            child: Wrap(
                                              children: [
                                                ListTile(
                                                  leading: const Icon(
                                                    Icons.edit,
                                                  ),
                                                  title: const Text('Sửa'),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    _showEditDialog(index);
                                                  },
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                    Icons.delete_outline,
                                                  ),
                                                  title: const Text('Xóa'),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    _deleteTask(index);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng: $count',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Hoàn thành: ${count - remaining}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF00C9A7), Color(0xFF92FE9D)],
          ),
        ),
        child: FloatingActionButton(
          onPressed: _showAddTaskSheet,
          backgroundColor: Colors.transparent,
          elevation: 4,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
