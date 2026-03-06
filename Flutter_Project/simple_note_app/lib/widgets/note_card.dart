import 'package:flutter/material.dart';
import '../models/note_model.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const NoteCard({
    Key? key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          '🗑️ Xóa ghi chú',
          style: TextStyle(
            color: Color(0xFF6366F1),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text('Bạn có chắc muốn xóa ghi chú này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton.tonalIcon(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete();
            },
            icon: const Icon(Icons.delete),
            label: const Text('Xóa'),
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
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          elevation: 2,
          shadowColor: const Color(0xFF6366F1).withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE0E7FF), width: 1),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFFFBFCFE), Colors.white],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề
                  Text(
                    widget.note.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Preview nội dung
                  Text(
                    widget.note.getPreview(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Footer: ngày & buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.note.getFormattedDate(),
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            iconSize: 18,
                            color: const Color(0xFF6366F1),
                            onPressed: widget.onEdit,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            iconSize: 18,
                            color: Colors.red.shade400,
                            onPressed: _showDeleteDialog,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
