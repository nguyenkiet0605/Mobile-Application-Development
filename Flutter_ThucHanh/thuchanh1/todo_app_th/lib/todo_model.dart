class Todo {
  String id;
  String title;
  bool isCompleted;
  DateTime? deadline;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.deadline,
  });
}
