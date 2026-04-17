import 'package:flutter/material.dart';
import 'package:quiz_app/models/level_widgets_model.dart';
import 'package:quiz_app/screen/widgets/level_button_widget.dart';
// TODO: Не забудь імпортувати файли з LevelsWidgetModel та LevelsWidgetModelProvider!

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. Створюємо екземпляр нашої моделі
  late final LevelsWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = LevelsWidgetModel(); // Ініціалізуємо при запуску
  }

  @override
  void dispose() {
    _model.dispose(); // Очищаємо пам'ять
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 2. Обгортаємо Scaffold у наш Провайдер
    return LevelsWidgetModelProvider(
      model: _model,
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              const Text(
                "Let's Play",
                style: TextStyle(
                  color: Color(0xfff35e7a),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Quiz Game",
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              
              // 3. Замінюємо хардкодні кнопки на динамічний список
              // Використовуємо Expanded, щоб список зайняв весь доступний простір
              const Expanded(
                child: _LevelsList(), 
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. Окремий віджет для списку, який буде слухати зміни в Провайдері
class _LevelsList extends StatelessWidget {
  const _LevelsList();

  @override
  Widget build(BuildContext context) {
    final model = LevelsWidgetModelProvider.watch(context)?.model;

    // Якщо даних ще немає (йде завантаження), показуємо крутилку
    if (model == null || model.levels.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Color(0xfff35e7a)));
    }

    return ListView.builder(
      padding: EdgeInsets.zero, // Щоб не було зайвого відступу зверху
      itemCount: model.levels.length,
      itemBuilder: (context, index) {
        final level = model.levels[index];
        
        return LevelButtonWidget(
          level: level,
          onTap: () => model.openLevel(context, index),
        );
      },
    );
  }
}