import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'task_view_model.dart';
import 'task_add_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TaskViewModel>(context);
    final tasks = viewModel.filteredTasks;

    return Scaffold(
      appBar: AppBar(
        title: Text('TaskTrack'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) => viewModel.setSearchQuery(value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final originalIndex = viewModel.findTaskIndex(task);
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.completed,
                      onChanged: (value) =>
                          viewModel.toggleTaskCompletion(originalIndex, value),
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
                        SizedBox(height: 4),
                        Text(task.preview),
                        SizedBox(height: 4),
                        Text(
                          task.date,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteDialog(context, viewModel, originalIndex),
                    ),
                    onTap: () => _openTaskEditor(context, viewModel, task, originalIndex),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTaskEditor(context, viewModel),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  void _showDeleteDialog(BuildContext context, TaskViewModel viewModel, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Удалить задачу?'),
        content: Text('Вы уверены, что хотите удалить эту задачу?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Отменить'),
          ),
          TextButton(
            onPressed: () {
              viewModel.removeTask(index);
              Navigator.of(context).pop();
            },
            child: Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openTaskEditor(BuildContext context, TaskViewModel viewModel, [Task? task, int? index]) {
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
        final newTask = Task(
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
