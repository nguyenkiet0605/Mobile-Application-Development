import 'package:flutter/material.dart';
import '../models/todo.dart';

typedef ToggleCallback = void Function(int index);

class TodoItem extends StatelessWidget {
  final Todo todo;
  final int index;
  final ToggleCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.index,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              activeColor: Colors.indigoAccent,
              shape: const CircleBorder(),
              value: todo.isDone,
              onChanged: (_) => onToggle(index),
            ),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: todo.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: todo.isDone ? Colors.grey : Colors.black87,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.grey),
            onPressed: onEdit,
          ),
        ),
      ),
    );
  }
}
