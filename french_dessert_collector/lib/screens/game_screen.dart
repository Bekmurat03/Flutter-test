import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/game_main.dart';
import '../game/pause_overlay.dart';
import 'game_over_screen.dart';

/// Экран игры (GameScreen)
/// Здесь отображается сама игра через Flame GameWidget
/// Содержит игровое поле и кнопку паузы
class GameScreen extends StatefulWidget {
  /// Имя игрока (получаем с предыдущего экрана)
  final String playerName;
  
  const GameScreen({
    super.key,
    required this.playerName,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  /// Экземпляр игры (создается один раз)
  late final GameMain game;

  @override
  void initState() {
    super.initState();
    
    // Создаем игру с callback для окончания
    game = GameMain(
      playerName: widget.playerName,
      onGameOver: _handleGameOver,
    );
  }

  /// Обработчик окончания игры
  /// Вызывается из GameMain когда игра заканчивается
  /// Переходит на экран Game Over с результатами
  void _handleGameOver(int finalScore, String reason) {
    // Небольшая задержка перед переходом (чтобы игрок увидел что произошло)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      
      // Переходим на экран Game Over
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameOverScreen(
            playerName: widget.playerName,
            finalScore: finalScore,
            reason: reason,
          ),
        ),
      );
    });
  }

  /// Показывает overlay паузы
  /// Вызывается при нажатии кнопки паузы
  void _showPauseOverlay() {
    game.togglePause();
    game.overlays.add('pause');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Черный фон для игры
      backgroundColor: Colors.black,
      
      body: SafeArea(
        child: Stack(
          children: [
            // Игровое поле (Flame GameWidget)
            GameWidget(
              game: game,
              
              // Регистрируем overlays (паузу)
              overlayBuilderMap: {
                'pause': (context, game) => PauseOverlay(
                  game: game as GameMain,
                ),
              },
            ),
            
            // Кнопка паузы (в правом верхнем углу)
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.pause_circle,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: _showPauseOverlay,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
