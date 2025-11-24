import 'task.dart';
import 'database.dart';

class TaskRepository {
  final DatabaseService _dbService = DatabaseService();

  Future<int> addTask(Task task) async {
    return await _dbService.insertTask(task);
  }

  Future<List<Task>> getAllTasks() async {
    return await _dbService.getTasks();
  }

  Future<int> updateTask(Task task) async {
    return await _dbService.updateTask(task);
  }

  Future<int> deleteTask(int id) async {
    return await _dbService.deleteTask(id);
  }
}