import 'package:flutter/material.dart';
import 'package:quiz_app/models/data.dart';
// TODO: Імпортуй свої класи Level та Data

class QuizWidgetModel extends ChangeNotifier {
  final Level level;
  final Function(List<int>) onSave; // Callback для збереження
  final VoidCallback onRestart;     // Callback для рестарту
  
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  bool isAnswered = false;
  
  List<int> userAnswers = [];

  QuizWidgetModel({
    required this.level,
    List<int>? initialAnswers, 
    required this.onSave,
    required this.onRestart,
  }) {
    if (initialAnswers != null && initialAnswers.isNotEmpty) {
      userAnswers = List.from(initialAnswers);
    }
  }

  Data get currentQuestion => level.questions[currentQuestionIndex];
  
  // Якщо кількість відповідей дорівнює кількості питань = рівень пройдено
  bool get isFinished => userAnswers.length == level.questions.length;

  int get score {
    int count = 0;
    for (int i = 0; i < userAnswers.length; i++) {
      if (userAnswers[i] == level.questions[i].correctIndex) count++;
    }
    return count;
  }

  void selectAnswer(int index) {
    if (isAnswered) return;
    selectedAnswerIndex = index;
    isAnswered = true;
    notifyListeners();
  }

  void nextQuestion(BuildContext context) {
    userAnswers.add(selectedAnswerIndex ?? -1);

    if (currentQuestionIndex < level.questions.length - 1) {
      currentQuestionIndex++;
      selectedAnswerIndex = null;
      isAnswered = false;
      notifyListeners();
    } else {
      // Коли відповіли на останнє питання — ЗБЕРІГАЄМО результат
      onSave(userAnswers);
      notifyListeners(); // Викличе оновлення UI і покаже ResultWidget
    }
  }

  void restart() {
    currentQuestionIndex = 0;
    selectedAnswerIndex = null;
    isAnswered = false;
    userAnswers.clear();
    
    // ОЧИЩАЄМО результат на головному екрані
    onRestart(); 
    
    notifyListeners(); // Вікно результатів зникне, і почнеться 1 питання
  }
}

// Провайдер для нашої моделі вікторини
class QuizWidgetModelProvider extends InheritedNotifier {
  final QuizWidgetModel model;

  const QuizWidgetModelProvider({
    super.key,
    required this.model,
    required super.child,
  }) : super(notifier: model);

  static QuizWidgetModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<QuizWidgetModelProvider>();
  }

  static QuizWidgetModelProvider? read(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType<QuizWidgetModelProvider>()?.widget;
    return widget is QuizWidgetModelProvider ? widget : null;
  }
}