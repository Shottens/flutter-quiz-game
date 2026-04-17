import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quiz_app/data/json_data.dart';
import 'package:quiz_app/models/data.dart';
import 'package:quiz_app/screens/quiz_screen.dart';

class LevelsWidgetModel extends ChangeNotifier {
  List<Level> _levels = [];
  List<Level> get levels => _levels.toList();

  // НОВЕ: Зберігаємо історію пройдених рівнів (id рівня -> список відповідей)
  Map<int, List<int>> levelResults = {};

  LevelsWidgetModel() {
    setup();
  }

  Future<void> setup() async {
    await _loadLevelsFromJson();
  }

  Future<void> _loadLevelsFromJson() async {
    final Map<String, dynamic> decodedJson = jsonDecode(jsonData);
    final List<dynamic> levelsList = decodedJson['levels'];
    
    _levels = levelsList.map((json) => Level.fromJson(json)).toList();
    notifyListeners();
  }

  // НОВЕ: Метод для збереження результату
  void saveLevelResult(int levelId, List<int> answers) {
    levelResults[levelId] = List.from(answers);
    notifyListeners(); // Оновлюємо UI (щоб, наприклад, змінити колір галочки на головному екрані)
  }

  // НОВЕ: Метод для очищення результату (при натисканні Restart)
  void clearLevelResult(int levelId) {
    levelResults.remove(levelId);
    notifyListeners();
  }

  // ОНОВЛЕНО: Тепер передаємо збережені дані та функції у LevelScreen
  void openLevel(BuildContext context, int index) {
    final level = _levels[index];
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          level: level,
          savedAnswers: levelResults[level.id], // Передаємо історію, якщо вона є
          onSave: (answers) => saveLevelResult(level.id, answers), // Передаємо функцію збереження
          onRestart: () => clearLevelResult(level.id), // Передаємо функцію рестарту
        ),
      ),
    );
  }
}


class LevelsWidgetModelProvider extends InheritedNotifier {
  final LevelsWidgetModel model;

  const LevelsWidgetModelProvider({
    super.key,
    required this.model,
    required super.child,
  }) : super(notifier: model);

  static LevelsWidgetModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LevelsWidgetModelProvider>();
  }

  static LevelsWidgetModelProvider? read(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType<LevelsWidgetModelProvider>()?.widget;
    return widget is LevelsWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(LevelsWidgetModelProvider oldWidget) {
    return true; 
  }
}