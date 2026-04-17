import 'package:flutter/material.dart';
import 'package:quiz_app/models/data.dart';


class LevelButtonWidget extends StatelessWidget {

  final Level level;
  final VoidCallback onTap;

  const LevelButtonWidget({
    super.key,
    required this.level,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50.0,bottom: 20),
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: onTap, // 2. Передаємо функцію кліку сюди
              borderRadius: BorderRadius.circular(20),
              child: Ink(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffef729e),
                      Color(0xffec7c86),
                      Color(0xffed896d),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white54),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.done, color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Level ${level.id}", // 3. Динамічний номер рівня
                      style: const TextStyle(
                        color: Color.fromARGB(224, 255, 255, 255),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      level.title, // 4. Динамічна назва (наприклад "Guess Capital")
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                level.image, // 5. Динамічний шлях до картинки
                width: 120,
                height: 120,
              ),
            ],
          ),
        ),
      ],
    );
  }
}