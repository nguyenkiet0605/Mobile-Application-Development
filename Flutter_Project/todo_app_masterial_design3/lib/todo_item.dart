import 'package:flutter/material.dart';
import 'todo_model.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;
  final Function(bool?) onStatusChanged;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TodoItemWidget({
    Key? key,
    required this.todo,
    required this.onStatusChanged,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem đã quá hạn chưa (chỉ tính khi chưa xong)
    bool isOverdue = false;
    if (todo.deadline != null && !todo.isCompleted) {
      isOverdue = DateTime.now().isAfter(todo.deadline!);
    }

    // Format ngày giờ thủ công cho đơn giản (dd/MM/yyyy HH:mm)
    String deadlineText = "";
    if (todo.deadline != null) {
      final d = todo.deadline!;
      deadlineText =
          "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      elevation: isOverdue ? 4 : 2,
      shadowColor: isOverdue
          ? Colors.red.withOpacity(0.3)
          : const Color(0xFF6366F1).withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isOverdue ? Colors.red.shade200 : const Color(0xFFE0E7FF),
          width: 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              todo.isCompleted ? Colors.grey[50]! : const Color(0xFFFBFCFE),
              Colors.white,
            ],
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: onStatusChanged,
            activeColor: const Color(0xFF6366F1),
            checkColor: Colors.white,
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              color: todo.isCompleted
                  ? Colors.grey[500]
                  : const Color(0xFF1E293B),
              letterSpacing: 0.3,
            ),
          ),
          // HIỂN THỊ THỜI GIAN Ở ĐÂY
          subtitle: todo.deadline != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: isOverdue ? Colors.red : const Color(0xFF6366F1),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        deadlineText,
                        style: TextStyle(
                          fontSize: 12,
                          color: isOverdue ? Colors.red : Colors.grey[600],
                          fontWeight: isOverdue
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      if (isOverdue)
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red.shade300,
                                  Colors.red.shade400,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.warning_rounded,
                                  size: 12,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  "Quá hạn",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                color: const Color(0xFF6366F1),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.red.shade400,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
