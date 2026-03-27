import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'game_main.dart';

/// Компонент UI для отображения игровой информации
/// Показывает: счет, HP, оставшееся время
/// Рисуется поверх игрового поля
class GameUI extends PositionComponent with HasGameReference<GameMain> {
  /// Стиль текста для UI
  final TextPaint _textPaint = TextPaint(
    style: const TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          offset: Offset(2, 2),
          blurRadius: 4,
          color: Colors.black54,
        ),
      ],
    ),
  );

  /// Стиль для больших чисел (счет)
  final TextPaint _scorePaint = TextPaint(
    style: const TextStyle(
      color: Colors.amber,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          offset: Offset(2, 2),
          blurRadius: 4,
          color: Colors.black54,
        ),
      ],
    ),
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Устанавливаем размер UI на весь экран
    size = game.size;
    
    // UI всегда рисуется поверх всего (высокий приоритет)
    priority = 1000;
  }

  /// Рисует UI каждый кадр
  /// canvas - холст для рисования
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Отступы от краев экрана
    const double padding = 20;
    
    // === СЧЕТ (Score) - по центру сверху ===
    final scoreText = 'Score: ${game.score}';
    _scorePaint.render(
      canvas,
      scoreText,
      Vector2(size.x / 2, padding),
      anchor: Anchor.topCenter,
    );
    
    // === HP (жизни) - слева сверху ===
    final hpText = '❤️ ${game.hp}';
    _textPaint.render(
      canvas,
      hpText,
      Vector2(padding, padding + 50),
      anchor: Anchor.topLeft,
    );
    
    // === ТАЙМЕР - справа сверху ===
    final timeText = '⏱️ ${game.timeLeft.toInt()}s';
    _textPaint.render(
      canvas,
      timeText,
      Vector2(size.x - padding, padding + 50),
      anchor: Anchor.topRight,
    );
  }
}
