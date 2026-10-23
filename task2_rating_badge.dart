// Завдання 2 — Власний Stateless-віджет RatingBadge.
// Запуск: flutter run -t lib/task2_rating_badge.dart

import 'package:flutter/material.dart';

/// Бейдж рейтингу: зірка, значення з одним знаком після коми
/// та необов'язковий підпис під ним.
class RatingBadge extends StatelessWidget {
  /// Рейтинг у межах 0.0–5.0 (значення поза межами обмежуються).
  final double rating;

  /// Необов'язковий підпис під значенням.
  final String? label;

  const RatingBadge({super.key, required this.rating, this.label});

  // Крайній випадок: значення поза діапазоном приводимо до 0.0–5.0.
  double get _safeRating => rating.clamp(0.0, 5.0).toDouble();

  // Єдине місце, де визначається правило кольору зірки.
  Color get _starColor {
    if (_safeRating >= 4.0) return Colors.green;
    if (_safeRating >= 2.5) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final text = label; // локальна копія для перевірки на null

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: _starColor),
            const SizedBox(width: 4),
            Text(_safeRating.toStringAsFixed(1), style: textTheme.titleMedium),
          ],
        ),
        if (text != null && text.isNotEmpty)
          Text(text, style: textTheme.bodySmall),
      ],
    );
  }
}

void main() => runApp(const RatingBadgeDemo());

/// Демонстраційний застосунок.
class RatingBadgeDemo extends StatelessWidget {
  const RatingBadgeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('RatingBadge')),
        body: const Center(
          child: Wrap(
            spacing: 32,
            runSpacing: 24,
            children: [
              RatingBadge(rating: 4.7, label: 'Відмінно'),
              RatingBadge(rating: 3.2, label: 'Нормально'),
              RatingBadge(rating: 1.2),
            ],
          ),
        ),
      ),
    );
  }
}
