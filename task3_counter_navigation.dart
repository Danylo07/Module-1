// Завдання 3 — State Management та навігація (два екрани).
// Запуск: flutter run -t lib/task3_counter_navigation.dart

import 'package:flutter/material.dart';

void main() => runApp(const CounterApp());

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Лічильник',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

/// Головний екран: стан лічильника живе тут (setState).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  void _increment() {
    setState(() => _counter++);
  }

  void _openDetails() {
    // Значення передається лише через конструктор DetailScreen.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(counter: _counter),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Головний екран')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Лічильник: $_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _increment,
              child: const Text('+1'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _openDetails,
              child: const Text('Детальніше'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Екран деталей: отримує значення через конструктор.
class DetailScreen extends StatelessWidget {
  final int counter;

  const DetailScreen({super.key, required this.counter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Деталі')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Значення лічильника: $counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}
