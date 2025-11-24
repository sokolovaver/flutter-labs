import 'package:flutter/material.dart';
import 'task_add_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> tasks = [
    {
      'title': 'Сделать лабораторную работу',
      'preview': 'Разработка мобильных приложений',
      'date': '23.11.2025 14:00',
      'completed': false,
    },
    {
      'title': 'Купить канцелярию',
      'preview': 'Ручки, карандаши, тетради',
      'date': '24.11.2025 15:00',
      'completed': true,
    },
    {
      'title': 'Приготовить ужин',
      'preview': 'Рис с рыбой',
      'date': '24.11.2025 16:00',
      'completed': false,
    },
  ];

  List<Map<String, dynamic>> filteredTasks = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredTasks = List.from(tasks);
  }

  void _filterTasks(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredTasks = tasks.where((task) {
        return task['title'].toLowerCase().contains(searchQuery) ||
            task['preview'].toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  void _openTaskEditor({Map<String, dynamic>? task, int? index}) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => TaskAddScreen(
          initialTitle: task != null ? task['title'] : '',
          initialContent: task != null ? task['preview'] : '',
        ),
      ),
    )
        .then((result) {
      if (result != null && result is Map<String, String>) {
        setState(() {
          final newTask = {
            'title': result['title'],
            'preview': result['content'],
            'date': result['date'],
            'completed': false,
          };
          if (index != null) {
            tasks[index] = newTask;
          } else {
            tasks.add(newTask);
          }
          // Обновляем фильтр после изменения списка задач
          _filterTasks(searchQuery);
        });
      }
    });
  }

  void _showDeleteDialog(int index) {
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
              setState(() {
                tasks.removeAt(index);
                _filterTasks(searchQuery);
              });
              Navigator.of(context).pop();
            },
            child: Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TaskTrack'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Строка поиска
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
              onChanged: _filterTasks,
            ),
          ),
          // Список задач
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                // Находим индекс этой задачи в основном списке, чтобы корректно удалить или редактировать
                final originalIndex = tasks.indexOf(task);
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: ListTile(
                    leading: Checkbox(
                      value: task['completed'],
                      onChanged: (value) {
                        setState(() {
                          tasks[originalIndex]['completed'] = value!;
                          _filterTasks(searchQuery);
                        });
                      },
                    ),
                    title: Text(
                      task['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: task['completed']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(task['preview']),
                        SizedBox(height: 4),
                        Text(
                          task['date'],
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteDialog(originalIndex),
                    ),
                    onTap: () {
                      _openTaskEditor(task: task, index: originalIndex);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTaskEditor(),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
