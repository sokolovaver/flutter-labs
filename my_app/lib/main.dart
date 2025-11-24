import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/home_screen.dart';
import 'ui/task_view_model.dart';
import 'ui/quote_screen.dart'; // Добавляем импорт

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskTrack',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Используем const для неизменяемых виджетов
  final List<Widget> _pages = const [
    HomeScreen(),
    QuoteScreen(), // Заменяем на отдельный виджет
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Задачи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote),
            label: 'Цитата',
          ),
        ],
      ),
    );
  }
}
