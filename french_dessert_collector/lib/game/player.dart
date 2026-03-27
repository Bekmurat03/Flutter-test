import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'game_main.dart';
import '../models/game_constants.dart';

/// Компонент игрока (Player)
/// Персонаж, которым управляет пользователь
/// Двигается по горизонтали внизу экрана
/// Ловит падающие предметы
class Player extends PositionComponent with HasGameReference<GameMain> {
  /// Эмодзи персонажа (французский повар)
  static const String playerEmoji = '👨‍🍳';
  
  /// Компонент для отрисовки текста (эмодзи)
  late TextComponent _textComponent;

  Player() : super(
    // Размер игрока берем из констант
    size: Vector2.all(GameConstants.playerSize),
    
    // Якорь в центре (для удобного позиционирования)
    anchor: Anchor.center,
  );

  /// Инициализация игрока
  /// Вызывается один раз при добавлении в игру
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Позиционируем игрока внизу экрана по центру
    position = Vector2(
      game.size.x / 2, // По центру по горизонтали
      game.size.y - 80, // Внизу экрана (отступ 80 пикселей от низа)
    );
    
    // Создаем текстовый компонент для отображения эмодзи
    _textComponent = TextComponent(
      text: playerEmoji,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 50, // Размер эмодзи
        ),
      ),
      anchor: Anchor.center,
    );
    
    // Добавляем текстовый компонент как дочерний
    await add(_textComponent);
  }

  /// Перемещает игрока на указанную позицию X
  /// Вызывается при drag (перетаскивании пальцем)
  /// x - новая позиция по горизонтали
  void moveTo(double x) {
    // Ограничиваем движение границами экрана
    // Игрок не может выйти за левый или правый край
    
    final halfWidth = size.x / 2; // Половина ширины игрока
    
    // Минимальная позиция (левый край)
    final minX = halfWidth;
    
    // Максимальная позиция (правый край)
    final maxX = game.size.x - halfWidth;
    
    // Ограничиваем x между minX и maxX
    position.x = x.clamp(minX, maxX);
  }

  /// Обновление игрока каждый кадр
  /// dt - время с предыдущего кадра в секундах
  @override
  void update(double dt) {
    super.update(dt);
    
    // TODO: На следующих этапах добавим:
    // - Проверку коллизий с падающими предметами
  }
}
