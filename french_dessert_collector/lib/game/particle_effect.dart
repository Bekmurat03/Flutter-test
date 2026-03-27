import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'game_main.dart';

/// Компонент визуального эффекта при поимке предмета
/// Создает частицы которые разлетаются в стороны
class ParticleEffect extends PositionComponent with HasGameReference<GameMain> {
  /// Цвет частиц
  final Color color;
  
  /// Список частиц
  final List<_Particle> _particles = [];
  
  /// Время жизни эффекта (в секундах)
  double _lifetime = 0.5;

  ParticleEffect({
    required Vector2 position,
    required this.color,
  }) : super(
    position: position,
    size: Vector2.zero(),
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Устанавливаем приоритет выше предметов (чтобы эффект был виден)
    priority = 10;
    
    // Создаем 8 частиц
    final random = Random();
    for (int i = 0; i < 8; i++) {
      // Случайный угол для направления частицы
      final angle = (i / 8) * 2 * pi + random.nextDouble() * 0.5;
      
      // Скорость частицы
      final speed = 100 + random.nextDouble() * 100;
      
      _particles.add(_Particle(
        velocity: Vector2(cos(angle), sin(angle)) * speed,
        size: 4 + random.nextDouble() * 4,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Уменьшаем время жизни
    _lifetime -= dt;
    
    // Если время вышло - удаляем эффект
    if (_lifetime <= 0) {
      removeFromParent();
      return;
    }
    
    // Обновляем каждую частицу
    for (final particle in _particles) {
      particle.position += particle.velocity * dt;
      particle.velocity *= 0.95; // Замедление
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Прозрачность зависит от оставшегося времени жизни
    final alpha = (_lifetime / 0.5).clamp(0.0, 1.0);
    
    final paint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..style = PaintingStyle.fill;
    
    // Рисуем каждую частицу
    for (final particle in _particles) {
      canvas.drawCircle(
        Offset(particle.position.x, particle.position.y),
        particle.size,
        paint,
      );
    }
  }
}

/// Класс одной частицы
class _Particle {
  Vector2 position = Vector2.zero();
  Vector2 velocity;
  double size;
  
  _Particle({
    required this.velocity,
    required this.size,
  });
}
