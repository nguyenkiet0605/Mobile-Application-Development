class Todo {
  String id;
  String title;
  bool isDone;
  DateTime createdTime;

  Todo({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.createdTime,
  });
}
