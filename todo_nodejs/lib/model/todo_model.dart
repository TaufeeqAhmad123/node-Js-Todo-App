class Todo {
  final String id;
  final String title;
  final String desc;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.desc,
    required this.createdAt,
    required this.updatedAt,
    required this.isCompleted,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'] ?? '', // ✅ Fix MongoDB `_id`
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'desc': desc,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}
