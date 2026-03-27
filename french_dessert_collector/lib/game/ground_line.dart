import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'game_main.dart';

/// Компонент линии земли (GroundLine)
/// Визуальная подсказка - показывает где находится игрок
/// Рисует линию внизу экрана
class GroundLine extends PositionComponent with HasGameReference<GameMain> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Устанавливаем размер на всю ширину экрана
    size = Vector2(game.size.x, 5);
    
    // Позиционируем внизу экрана (чуть выше игрока)
    position = Vector2(0, game.size.y - 120);
    
    // Низкий приоритет (рисуется под игроком)
    priority = -1;
  }

  /// Рисует линию каждый кадр
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Рисуем зеленую линию (как трава)
    final paint = Paint()
      ..color = Colors.green.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      paint,
    );
  }
}
