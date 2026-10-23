// Завдання 4 — Асинхронний код: Future та Stream.
// Запуск: dart run lib/task4_weather_service.dart

import 'dart:async';
import 'dart:math';

/// Сервіс, що імітує отримання даних про погоду.
class WeatherService {
  final Random _random;

  /// Можна передати власний Random (наприклад, для тестів).
  WeatherService({Random? random}) : _random = random ?? Random();

  static const List<String> _conditions = [
    'Сонячно',
    'Хмарно',
    'Дощ',
    'Сніг',
    'Туман',
  ];

  /// Випадкова температура від -15 до +30 °C.
  int _randomTemperature() => _random.nextInt(46) - 15;

  /// Імітує мережевий запит (1–2 с). Для порожнього міста кидає
  /// ArgumentError('Місто не вказано').
  Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    if (city.trim().isEmpty) {
      throw ArgumentError('Місто не вказано');
    }

    await Future.delayed(Duration(milliseconds: 1000 + _random.nextInt(1001)));

    return {
      'city': city,
      'temp': _randomTemperature(),
      'condition': _conditions[_random.nextInt(_conditions.length)],
    };
  }

  /// Видає [times] випадкових значень температури, по одному за секунду,
  /// після чого Stream завершується. Для times <= 0 значень немає.
  Stream<int> temperatureUpdates({int times = 5}) async* {
    for (var i = 0; i < times; i++) {
      await Future.delayed(const Duration(seconds: 1));
      yield _randomTemperature();
    }
  }
}

Future<void> main() async {
  final service = WeatherService();

  // 1. Успішний запит: async/await + try-catch.
  try {
    final weather = await service.fetchCurrentWeather('Київ');
    print(weather);
  } catch (e) {
    print('Помилка: $e');
  }

  // 2. Порожнє місто → ArgumentError.
  try {
    await service.fetchCurrentWeather('');
  } on ArgumentError catch (e) {
    print('Помилка: ${e.message}');
  }

  // 3. Stream через await for.
  await for (final temp in service.temperatureUpdates(times: 3)) {
    print('Температура: $temp°C');
  }

  // 4. Той самий Stream через підписку .listen().
  final subscription = service.temperatureUpdates(times: 2).listen(
        (temp) => print('[listen] Температура: $temp°C'),
      );
  await subscription.asFuture<void>();
  print('Stream завершено');
}
