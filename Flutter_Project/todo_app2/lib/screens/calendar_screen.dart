import 'package:flutter/material.dart';
import '../models/todo.dart';

class CalendarScreen extends StatefulWidget {
  final List<Todo> todos;
  final DateTime selectedDate;

  const CalendarScreen({
    super.key,
    required this.todos,
    required this.selectedDate,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime currentMonth;

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
    );
  }

  Map<int, int> _getTaskCountPerDay() {
    final Map<int, int> counts = {};
    for (var todo in widget.todos) {
      final day = todo.createdTime.day;
      counts[day] = (counts[day] ?? 0) + 1;
    }
    return counts;
  }

  Map<int, int> _getCompletedCountPerDay() {
    final Map<int, int> counts = {};
    for (var todo in widget.todos.where((t) => t.isDone)) {
      final day = todo.createdTime.day;
      counts[day] = (counts[day] ?? 0) + 1;
    }
    return counts;
  }

  List<Todo> _getTodosForDay(int day) {
    return widget.todos.where((t) => t.createdTime.day == day).toList();
  }

  void _showDayDetails(int day) {
    final todos = _getTodosForDay(day);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          DayDetailsSheet(day: day, todos: todos, currentMonth: currentMonth),
    );
  }

  void _previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    ).day;
    final firstWeekday =
        DateTime(currentMonth.year, currentMonth.month, 1).weekday % 7;

    final taskCounts = _getTaskCountPerDay();
    final completedCounts = _getCompletedCountPerDay();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigoAccent,
        title: const Text(
          'Lịch công việc',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Month header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.indigoAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: _previousMonth,
                ),
                Text(
                  'Tháng ${currentMonth.month}/${currentMonth.year}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: _nextMonth,
                ),
              ],
            ),
          ),
          // Day headers
          Container(
            color: Colors.indigo[300],
            child: Row(
              children: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7']
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // Calendar grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: firstWeekday + daysInMonth,
              itemBuilder: (context, index) {
                if (index < firstWeekday) {
                  return const SizedBox();
                }
                final day = index - firstWeekday + 1;
                final total = taskCounts[day] ?? 0;
                final completed = completedCounts[day] ?? 0;

                return GestureDetector(
                  onTap: total > 0 ? () => _showDayDetails(day) : null,
                  child: Card(
                    elevation: 2,
                    margin: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: total == 0
                            ? Colors.grey[50]
                            : (completed == total
                                  ? Colors.green[50]
                                  : Colors.amber[50]),
                        border: Border.all(
                          color: completed == total && total > 0
                              ? Colors.green
                              : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  day.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (total > 0)
                                  Text(
                                    '$completed/$total',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: completed == total
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (total > 0 && completed < total)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${total - completed}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DayDetailsSheet extends StatelessWidget {
  final int day;
  final List<Todo> todos;
  final DateTime currentMonth;

  const DayDetailsSheet({
    super.key,
    required this.day,
    required this.todos,
    required this.currentMonth,
  });

  @override
  Widget build(BuildContext context) {
    final completed = todos.where((t) => t.isDone).length;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ngày $day/${currentMonth.month}/${currentMonth.year}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Hoàn thành: $completed/${todos.length}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            if (todos.isEmpty)
              const Center(child: Text('Không có công việc trong ngày này'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    leading: Icon(
                      todo.isDone ? Icons.check_circle : Icons.circle_outlined,
                      color: todo.isDone ? Colors.green : Colors.grey,
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.isDone
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Text(
                      '${todo.createdTime.hour.toString().padLeft(2, '0')}:${todo.createdTime.minute.toString().padLeft(2, '0')}',
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
