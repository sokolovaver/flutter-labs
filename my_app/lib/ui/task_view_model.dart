import 'package:flutter/material.dart';
import '../data/task.dart' as data_models;
import '../data/repository.dart';

class TaskViewModel extends ChangeNotifier {
  List<data_models.Task> _tasks = [];
  String _searchQuery = '';
  final TaskRepository _repository = TaskRepository();
  bool _isLoading = false;

  TaskViewModel() {
    _loadTasks();
  }

  List<data_models.Task> get filteredTasks {
    if (_searchQuery.isEmpty) {
      return _tasks;
    }
    final query = _searchQuery.toLowerCase();
    return _tasks.where((task) {
      return task.title.toLowerCase().contains(query) ||
             task.preview.toLowerCase().contains(query);
    }).toList();
  }

  bool get isLoading => _isLoading;

  Future<void> _loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _repository.getAllTasks();
      // Если в базе нет задач, добавляем демо-задачи
      if (_tasks.isEmpty) {
        _tasks = _getDemoTasks();
        // Сохраняем демо-задачи в базу
        for (final task in _tasks) {
          await _repository.addTask(task);
        }
      }
    } catch (e) {
      print('Error loading tasks: $e');
      _tasks = _getDemoTasks();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<data_models.Task> _getDemoTasks() {
    return [
      data_models.Task(
        title: 'Сделать лабораторную работу',
        preview: 'Разработка мобильных приложений',
        date: '23.11.2025 14:00',
      ),
      data_models.Task(
        title: 'Купить канцелярию',
        preview: 'Ручки, карандаши, тетради',
        date: '24.11.2025 15:00',
        completed: true,
      ),
      data_models.Task(
        title: 'Приготовить ужин',
        preview: 'Рис с рыбой',
        date: '24.11.2025 16:00',
      ),
    ];
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> addTask(data_models.Task task) async {
    try {
      final id = await _repository.addTask(task);
      // Обновляем задачу с ID из базы данных
      final taskWithId = task.copyWith(id: id);
      _tasks.add(taskWithId);
      notifyListeners();
    } catch (e) {
      print('Error adding task: $e');
      // Если ошибка, добавляем локально без ID
      _tasks.add(task);
      notifyListeners();
    }
  }

  Future<void> updateTask(int index, data_models.Task task) async {
    try {
      final existingTask = _tasks[index];
      final updatedTask = task.copyWith(id: existingTask.id);
      await _repository.updateTask(updatedTask);
      _tasks[index] = updatedTask;
      notifyListeners();
    } catch (e) {
      print('Error updating task: $e');
      _tasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> removeTask(int index) async {
    final taskToRemove = _tasks[index];
    try {
      if (taskToRemove.id != null) {
        await _repository.deleteTask(taskToRemove.id!);
      }
      _tasks.removeAt(index);
      notifyListeners();
    } catch (e) {
      print('Error deleting task: $e');
      _tasks.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> toggleTaskCompletion(int index) async {
    final task = _tasks[index];
    final updatedTask = task.copyWith(completed: !task.completed);

    try {
      if (task.id != null) {
        await _repository.updateTask(updatedTask);
      }
      _tasks[index] = updatedTask;
      notifyListeners();
    } catch (e) {
      print('Error toggling task completion: $e');
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  int findTaskIndex(data_models.Task task) {
    return _tasks.indexOf(task);
  }
}