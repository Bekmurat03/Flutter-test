import 'package:flutter/material.dart';
import 'name_screen.dart';
import 'ranking_screen.dart';
import 'instructions_screen.dart';

/// Главный экран приложения (Home Screen)
/// Показывает название игры и кнопку "Game Start"
/// Это первый экран, который видит пользователь
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Градиентный фон для красоты
      body: Container(
        // Декорация с градиентом от светло-голубого к розовому (французские цвета)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB), // Светло-голубой
              Color(0xFFFFB6C1), // Светло-розовый
            ],
          ),
        ),
        
        // Центрируем весь контент
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Иконка десерта (эмодзи)
              const Text(
                '🥐',
                style: TextStyle(fontSize: 80),
              ),
              
              const SizedBox(height: 20),
              
              // Название игры
              const Text(
                'French Dessert\nCollector',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    // Тень для текста чтобы лучше читался
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Кнопка "Game Start"
              // При нажатии переходим на экран ввода имени
              ElevatedButton(
                onPressed: () {
                  // Переходим на экран ввода имени (NameScreen)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NameScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Game Start',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Кнопка "Ranking" для просмотра таблицы лидеров
              OutlinedButton(
                onPressed: () {
                  // Переходим на экран рейтинга
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RankingScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Ranking',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Кнопка "How to Play" для просмотра инструкций
              TextButton.icon(
                onPressed: () {
                  // Переходим на экран инструкций
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InstructionsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.help_outline, color: Colors.white),
                label: const Text(
                  'How to Play',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
