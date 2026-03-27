import 'package:flutter/material.dart';
import 'ranking_screen.dart';
import '../services/ranking_service.dart';

/// Экран Game Over (GameOverScreen)
/// Показывается когда игра заканчивается (закончилось время или HP = 0)
/// Отображает результаты игры: имя, очки, причину окончания
class GameOverScreen extends StatefulWidget {
  /// Имя игрока
  final String playerName;
  
  /// Финальный счет (очки)
  final int finalScore;
  
  /// Причина окончания игры (например: "Time's up!" или "No HP left!")
  final String reason;
  
  const GameOverScreen({
    super.key,
    required this.playerName,
    required this.finalScore,
    required this.reason,
  });

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  /// Сервис для работы с рейтингом
  final RankingService _rankingService = RankingService();

  @override
  void initState() {
    super.initState();
    // Сохраняем результат в рейтинг при открытии экрана
    _saveScore();
  }

  /// Сохраняет результат игрока в рейтинг
  Future<void> _saveScore() async {
    await _rankingService.saveScore(widget.playerName, widget.finalScore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Темный фон для драматичности
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1a2e), // Темно-синий
              Color(0xFF16213e), // Темно-серый
            ],
          ),
        ),
        
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Заголовок "GAME OVER"
                  const Text(
                    'GAME OVER',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      shadows: [
                        Shadow(
                          offset: Offset(3, 3),
                          blurRadius: 8,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Причина окончания игры
                  Text(
                    widget.reason,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white70,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Карточка с результатами
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Имя игрока
                        Text(
                          widget.playerName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Надпись "Score"
                        const Text(
                          'Score',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white60,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Финальный счет (большими цифрами)
                        Text(
                          '${widget.finalScore}',
                          style: const TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // Кнопка "View Ranking"
                  // Переход к таблице лидеров
                  ElevatedButton(
                    onPressed: () {
                      // Переходим на экран рейтинга
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RankingScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'View Ranking',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Кнопка "Play Again"
                  // Возвращаемся на главный экран для новой игры
                  OutlinedButton(
                    onPressed: () {
                      // Возвращаемся на главный экран (удаляем все промежуточные экраны)
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Play Again',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
