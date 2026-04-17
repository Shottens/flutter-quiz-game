import 'package:flutter/material.dart';
import 'package:quiz_app/providers/quiz_widget_model.dart';
// Не забудь про імпорти ResultWidget, QuestionButtonWidget та провайдера

class QuestionButtonWidgets extends StatelessWidget {
  const QuestionButtonWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final model = QuizWidgetModelProvider.watch(context)?.model;
    if (model == null) return const SizedBox.shrink();

    // Якщо рівень пройдено — показуємо вікно результатів
    if (model.isFinished) {
      return const ResultWidget();
    }

    final question = model.currentQuestion;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. ДОДАНО: Верхній рядок з кнопкою "Закрити" та Hero-картинкою
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, color: Colors.white, size: 40),
            ),
            // Hero-картинка прилітає з головного екрану
            Hero(
              tag: 'level_image_${model.level.id}',
              child: Image.asset(
                model.level.image, 
                height: 60,
                // Заглушка на випадок, якщо картинки ще немає в assets
                errorBuilder: (context, error, stackTrace) => const SizedBox(height: 60),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // 2. ДОДАНО: Анімація плавної зміни питань (Fade)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          key: ValueKey<int>(model.currentQuestionIndex), // Ключ каже Flutter, коли запускати анімацію
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Question ${model.currentQuestionIndex + 1}/${model.level.questions.length}",
                style: const TextStyle(
                  color: Color.fromARGB(224, 255, 255, 255), 
                  fontSize: 21, 
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                question.question,
                style: const TextStyle(
                  color: Color.fromARGB(224, 255, 255, 255), 
                  fontSize: 26, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              // Генерація кнопок з відповідями
              ...List.generate(question.answers.length, (index) {
                return QuestionButtonWidget(
                  answerText: question.answers[index],
                  index: index,
                );
              }),
            ],
          ),
        ),

        const Spacer(),

        // 3. Кнопка "Continue"
        if (model.isAnswered)
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0), // Зробив відступ трохи більшим для краси
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => model.nextQuestion(context),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    color: Color(0xff5177ee), 
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}


class QuestionButtonWidget extends StatelessWidget {
  final String answerText;
  final int index;

  const QuestionButtonWidget({
    super.key,
    required this.answerText,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // Зчитуємо модель (використовуємо watch, щоб кнопка оновлювалась)
    final model = QuizWidgetModelProvider.watch(context)?.model;
    if (model == null) return const SizedBox.shrink();

    final isAnswered = model.isAnswered;
    final isSelected = model.selectedAnswerIndex == index;
    final isCorrectAnswer = model.currentQuestion.correctIndex == index;

    // Логіка визначення кольору фону
    Color getBackgroundColor() {
      if (!isAnswered) return Colors.white; // Поки не відповіли - білі

      if (isCorrectAnswer) {
        return Colors.green; // Правильна відповідь ЗАВЖДИ зелена в кінці
      }
      if (isSelected && !isCorrectAnswer) {
        return Colors.redAccent; // Якщо вибрали неправильну - вона червона
      }
      return Colors.white; // Всі інші залишаються білими
    }

    // Логіка визначення кольору тексту
    Color getTextColor() {
      if (!isAnswered) return const Color(0xff5177ee);
      
      // Якщо кнопка стала зеленою або червоною, текст робимо білим для контрасту
      if (isCorrectAnswer || (isSelected && !isCorrectAnswer)) {
        return Colors.white;
      }
      return const Color(0xff5177ee);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => model.selectAnswer(index),
          borderRadius: BorderRadius.circular(20),
          // ЗАМІНА: Замість Ink тепер AnimatedContainer
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300), // Плавна зміна кольору
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 15), // Трохи збільшений відступ
            width: double.infinity,
            decoration: BoxDecoration(
              color: getBackgroundColor(),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              answerText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: getTextColor(),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResultWidget extends StatelessWidget {
  const ResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = QuizWidgetModelProvider.watch(context)!.model;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Your Score", style: TextStyle(fontSize: 20, color: Colors.grey)),
            Text("${model.score} / ${model.level.questions.length}", 
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xff5177ee))),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Кнопка історії
                IconButton(
                  icon: const Icon(Icons.history, size: 40, color: Color(0xff5177ee)),
                  onPressed: () => _showHistory(context, model),
                ),
                const SizedBox(width: 20),
                // Кнопка рестарту
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xfff35e7a)),
                  onPressed: () => model.restart(),
                  child: const Text("Restart", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back to Home", style: TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }

  // Вікно історії відповідей
  void _showHistory(BuildContext context, QuizWidgetModel model) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) {
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: model.level.questions.length,
          itemBuilder: (context, index) {
            final q = model.level.questions[index];
            final userAns = model.userAnswers[index];
            final isCorrect = userAns == q.correctIndex;

            return ListTile(
              title: Text(q.question, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Correct: ${q.answers[q.correctIndex]}"),
              trailing: Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
              ),
            );
          },
        );
      },
    );
  }
}