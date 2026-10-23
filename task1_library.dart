// Завдання 1 — Основи Dart: класи та колекції (модель бібліотеки).
// Запуск: dart run lib/task1_library.dart

/// Абстрактний базовий клас елемента бібліотеки.
abstract class LibraryItem {
  final String title;
  final int year;

  const LibraryItem({required this.title, required this.year});

  /// Текстовий опис елемента (реалізують нащадки).
  String describe();

  @override
  String toString() => describe();
}

/// Книга: "Назва (рік) — автор".
class Book extends LibraryItem {
  final String author;

  const Book({
    required super.title,
    required super.year,
    required this.author,
  });

  @override
  String describe() => '$title ($year) — $author';
}

/// Журнал: "Назва (рік), випуск N".
class Magazine extends LibraryItem {
  final int issueNumber;

  const Magazine({
    required super.title,
    required super.year,
    required this.issueNumber,
  });

  @override
  String describe() => '$title ($year), випуск $issueNumber';
}

/// Бібліотека зберігає колекцію елементів і вміє їх шукати.
class Library {
  final List<LibraryItem> _items = [];

  /// Лише для читання: зовнішній код не може змінити внутрішній список.
  List<LibraryItem> get items => List.unmodifiable(_items);

  /// Додає елемент до бібліотеки.
  void addItem(LibraryItem item) => _items.add(item);

  /// Усі елементи за вказаний рік (порожній список, якщо нічого немає).
  List<LibraryItem> findByYear(int year) =>
      _items.where((item) => item.year == year).toList();

  /// Описи всіх елементів.
  List<String> get allDescriptions =>
      _items.map((item) => item.describe()).toList();

  /// Найстаріший елемент або null, якщо бібліотека порожня.
  LibraryItem? findOldest() {
    if (_items.isEmpty) return null;
    return _items.reduce((a, b) => a.year <= b.year ? a : b);
  }
}

void main() {
  final library = Library();

  // Крайній випадок: порожня бібліотека.
  print('Найстаріший (порожня бібліотека): ${library.findOldest()}');

  library.addItem(
    Book(title: 'Dart у дії', year: 2022, author: 'І. Петренко'),
  );
  library.addItem(
    Magazine(title: 'Mobile Dev', year: 2023, issueNumber: 5),
  );
  library.addItem(
    Book(title: 'Flutter на практиці', year: 2020, author: 'О. Коваль'),
  );
  library.addItem(
    Magazine(title: 'Tech Weekly', year: 2022, issueNumber: 12),
  );

  print('\nУсі описи:');
  for (final description in library.allDescriptions) {
    print('  $description');
  }

  print('\nЗа 2022 рік:');
  for (final item in library.findByYear(2022)) {
    print('  ${item.describe()}');
  }

  print('\nЗа 1999 рік: ${library.findByYear(1999)}'); // []
  print('Найстаріший: ${library.findOldest()}');
}
