class Task {
  final int? id;
  final String title;
  final String preview;
  final String date;
  bool completed;

  Task({
    this.id,
    required this.title,
    required this.preview,
    required this.date,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': preview,
      'date': date,
      'completed': completed ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'] ?? '',
      preview: map['content'] ?? '',
      date: map['date'] ?? '',
      completed: (map['completed'] ?? 0) == 1,
    );
  }

  // Метод для копирования с обновлением
  Task copyWith({
    int? id,
    String? title,
    String? preview,
    String? date,
    bool? completed,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      preview: preview ?? this.preview,
      date: date ?? this.date,
      completed: completed ?? this.completed,
    );
  }
}