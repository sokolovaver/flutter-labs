import 'package:flutter/material.dart';

class Task {
  String title;
  String preview;
  String date;
  bool completed;

  Task({
    required this.title,
    required this.preview,
    required this.date,
    this.completed = false,
  });
}

class TaskViewModel extends ChangeNotifier {
  List<Task> _tasks = [
    Task(
      title: 'Сделать лабораторную работу',
      preview: 'Разработка мобильных приложений',
      date: '23.11.2025 14:00',
    ),
    Task(
      title: 'Купить канцелярию',
      preview: 'Ручки, карандаши, тетради',
      date: '24.11.2025 15:00',
      completed: true,
    ),
    Task(
      title: 'Приготовить ужин',
      preview: 'Рис с рыбой',
      date: '24.11.2025 16:00',
    ),
  ];

  String _searchQuery = '';

  List<Task> get filteredTasks {
    if (_searchQuery.isEmpty) {
      return _tasks;
    }
    final query = _searchQuery.toLowerCase();
    return _tasks.where((task) {
      return task.title.toLowerCase().contains(query) ||
             task.preview.toLowerCase().contains(query);
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(int index, Task task) {
    _tasks[index] = task;
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  void toggleTaskCompletion(int index, bool? value) {
    _tasks[index].completed = value ?? false;
    notifyListeners();
  }

  int findTaskIndex(Task task) {
    return _tasks.indexOf(task);
  }
}