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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: todo.isCompleted ? Colors.grey[100] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!todo.isCompleted)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
        ],
        // Viền đỏ nếu quá hạn
        border: isOverdue
            ? Border.all(color: Colors.red.withOpacity(0.5))
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Transform.scale(
          scale: 1.2,
          child: Checkbox(
            activeColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            value: todo.isCompleted,
            onChanged: onStatusChanged,
          ),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
        // HIỂN THỊ THỜI GIAN Ở ĐÂY
        subtitle: todo.deadline != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: isOverdue ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(width: 4),
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
                      const Text(
                        " (Quá hạn)",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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
              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
