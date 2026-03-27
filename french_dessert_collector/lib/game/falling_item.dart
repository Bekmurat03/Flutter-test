import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'game_main.dart';
import 'particle_effect.dart';
import '../models/item_type.dart';
import '../models/game_constants.dart';

/// Компонент падающего предмета (FallingItem)
/// Предметы падают сверху вниз с разной скоростью
/// Могут быть хорошими (десерты) или плохими (кости)
class FallingItem extends PositionComponent with HasGameReference<GameMain> {
  /// Тип предмета (багет, макарон, пирожное, кость и т.д.)
  final ItemType itemType;
  
  /// Скорость падения (пикселей в секунду)
  double fallSpeed;
  
  /// Компонент для отрисовки эмодзи
  late TextComponent _textComponent;
  
  /// Флаг - был ли предмет пойман игроком
  bool isCaught = false;

  FallingItem({
    required this.itemType,
    required this.fallSpeed,
  }) : super(
    // Размер предмета берем из констант
    size: Vector2.all(GameConstants.itemSize),
    
    // Якорь в центре
    anchor: Anchor.center,
  );

  /// Инициализация предмета
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Случайная позиция X (в пределах экрана)
    final random = Random();
    final halfWidth = size.x / 2;
    final minX = halfWidth;
    final maxX = game.size.x - halfWidth;
    
    // Устанавливаем случайную позицию X
    position.x = minX + random.nextDouble() * (maxX - minX);
    
    // Начальная позиция Y - чуть выше экрана (предмет появляется сверху)
    position.y = -size.y;
    
    // Создаем текстовый компонент для отображения эмодзи
    _textComponent = TextComponent(
      text: itemType.emoji, // Эмодзи из ItemType (🥖, 🍰, 🧁, 🦴, 🐟)
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 40, // Размер эмодзи
        ),
      ),
      anchor: Anchor.center,
    );
    
    // Добавляем эмодзи как дочерний компонент
    await add(_textComponent);
  }

  /// Обновление предмета каждый кадр
  /// dt - время с предыдущего кадра в секундах
  @override
  void update(double dt) {
    super.update(dt);
    
    // Если предмет пойман, не обновляем его
    if (isCaught) return;
    
    // Двигаем предмет вниз (увеличиваем Y)
    position.y += fallSpeed * dt;
    
    // Проверяем, упал ли предмет за нижнюю границу экрана
    if (position.y > game.size.y + size.y) {
      // Предмет упал мимо игрока
      _handleMissed();
    }
  }

  /// Обработка случая когда предмет упал мимо игрока
  /// Вызывается когда предмет вышел за нижнюю границу экрана
  void _handleMissed() {
    // Если это был хороший предмет (десерт) - теряем HP
    if (itemType.isGood) {
      game.loseHP();
    }
    
    // Удаляем предмет из игры
    removeFromParent();
  }

  /// Обработка поимки предмета игроком
  /// Вызывается из системы коллизий когда игрок поймал предмет
  void catchItem() {
    // Помечаем что предмет пойман (чтобы не обрабатывать дважды)
    isCaught = true;
    
    // Создаем визуальный эффект
    _createCatchEffect();
    
    // Добавляем/отнимаем очки
    game.addScore(itemType.score);
    
    // Если это рыбная кость - отнимаем HP
    if (itemType.damagesHP) {
      game.loseHP();
    }
    
    // Если это пирожное - добавляем время
    if (itemType.givesTimeBonus) {
      game.addTime(GameConstants.puffTimeBonus);
    }
    
    // Удаляем предмет из игры
    removeFromParent();
  }

  /// Создает визуальный эффект при поимке предмета
  void _createCatchEffect() {
    // Цвет эффекта зависит от типа предмета
    Color effectColor;
    
    if (itemType.isGood) {
      // Хорошие предметы - зеленый/желтый эффект
      effectColor = Colors.amber;
    } else {
      // Плохие предметы - красный эффект
      effectColor = Colors.red;
    }
    
    // Создаем эффект частиц
    final effect = ParticleEffect(
      position: position.clone(),
      color: effectColor,
    );
    
    // Добавляем эффект в игру
    game.add(effect);
  }

  /// Проверяет коллизию с игроком
  /// Возвращает true если предмет касается игрока
  bool checkCollisionWithPlayer() {
    // Получаем позицию игрока
    final playerPos = game.player.position;
    final playerSize = game.player.size;
    
    // Вычисляем расстояние между центрами
    final dx = position.x - playerPos.x;
    final dy = position.y - playerPos.y;
    final distance = sqrt(dx * dx + dy * dy);
    
    // Радиус коллизии (сумма половин размеров)
    final collisionRadius = (size.x + playerSize.x) / 2;
    
    // Если расстояние меньше радиуса - есть коллизия
    return distance < collisionRadius * 0.8; // 0.8 для более точной коллизии
  }
}
