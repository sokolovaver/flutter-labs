import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_view_model.dart';
import 'task_add_screen.dart';
import '../data/task.dart' as data_models;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TaskViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskTrack'),
        backgroundColor: Colors.green,
      ),
      body: viewModel.isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Загрузка задач...'),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Поиск',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (value) => viewModel.setSearchQuery(value),
                  ),
                ),
                Expanded(
                  child: _buildTaskList(viewModel),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTaskEditor(context, viewModel),
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildTaskList(TaskViewModel viewModel) {
    final tasks = viewModel.filteredTasks;

    if (tasks.isEmpty) {
      return const Center(
        child: Text('Нет задач'),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final originalIndex = viewModel.findTaskIndex(task);
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: ListTile(
            leading: Checkbox(
              value: task.completed,
              onChanged: (value) => viewModel.toggleTaskCompletion(originalIndex),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: task.completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(task.preview),
                const SizedBox(height: 4),
                Text(
                  task.date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(context, viewModel, originalIndex),
            ),
            onTap: () => _openTaskEditor(context, viewModel, task, originalIndex),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, TaskViewModel viewModel, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить задачу?'),
        content: const Text('Вы уверены, что хотите удалить эту задачу?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отменить'),
          ),
          TextButton(
            onPressed: () {
              viewModel.removeTask(index);
              Navigator.of(context).pop();
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openTaskEditor(BuildContext context, TaskViewModel viewModel,
      [data_models.Task? task, int? index]) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => TaskAddScreen(
          initialTitle: task?.title ?? '',
          initialContent: task?.preview ?? '',
        ),
      ),
    )
        .then((result) {
      if (result != null && result is Map<String, String>) {
        final newTask = data_models.Task(
          title: result['title'] ?? '',
          preview: result['content'] ?? '',
          date: result['date'] ?? '',
        );
        if (index != null) {
          viewModel.updateTask(index, newTask);
        } else {
          viewModel.addTask(newTask);
        }
      }
    });
  }
}
