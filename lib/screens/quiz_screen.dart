import 'package:flutter/material.dart';
import 'package:quiz_app/models/data.dart';
import 'package:quiz_app/providers/quiz_widget_model.dart';
import 'package:quiz_app/screens/widgets/question_button_widgets.dart';
// TODO: Імпортуй свої файли

class QuizScreen extends StatefulWidget {
  final Level level;
  final List<int>? savedAnswers; // Додали параметр для історії
  final Function(List<int>) onSave; // Додали параметр для збереження
  final VoidCallback onRestart; // Додали параметр для рестарту

  const QuizScreen({
    super.key, 
    required this.level,
    this.savedAnswers,
    required this.onSave,
    required this.onRestart,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final QuizWidgetModel _model;

  @override
  void initState() {
    super.initState();
    // Передаємо ці параметри далі у нашу модель вікторини
    _model = QuizWidgetModel(
      level: widget.level,
      initialAnswers: widget.savedAnswers,
      onSave: widget.onSave,
      onRestart: widget.onRestart,
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QuizWidgetModelProvider(
      model: _model,
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff348ef2), Color(0xff4183f1), Color(0xff5177ee)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const QuestionButtonWidgets(),
        ),
      ),
    );
  }
}