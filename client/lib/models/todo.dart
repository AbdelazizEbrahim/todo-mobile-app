// client/lib/models/todo.dart
class ToDo {
  final String id;
  final String userId;
  final String title;
  final String description;

  ToDo({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['_id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
    );
  }
}