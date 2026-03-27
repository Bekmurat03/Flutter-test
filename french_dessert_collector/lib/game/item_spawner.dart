import 'dart:math';
import 'package:flame/components.dart';
import 'game_main.dart';
import 'falling_item.dart';
import '../models/item_type.dart';
import '../models/game_constants.dart';

/// Система спавна предметов (ItemSpawner)
/// Создает падающие предметы через определенные интервалы
/// Управляет частотой появления и типами предметов
class ItemSpawner extends Component with HasGameReference<GameMain> {
  /// Таймер для отслеживания времени до следующего спавна
  double _spawnTimer = 0;
  
  /// Интервал спавна (в секундах)
  final double _spawnInterval = GameConstants.itemSpawnInterval;
  
  /// Генератор случайных чисел
  final Random _random = Random();

  /// Обновление спавнера каждый кадр
  /// dt - время с предыдущего кадра в секундах
  @override
  void update(double dt) {
    super.update(dt);
    
    // Если игра на паузе, не спавним предметы
    if (game.isPaused) return;
    
    // Увеличиваем таймер
    _spawnTimer += dt;
    
    // Если прошло достаточно времени - спавним новый предмет
    if (_spawnTimer >= _spawnInterval) {
      _spawnItem();
      _spawnTimer = 0; // Сбрасываем таймер
    }
  }

  /// Создает и добавляет новый падающий предмет
  void _spawnItem() {
    // Выбираем случайный тип предмета
    final itemType = _getRandomItemType();
    
    // Вычисляем текущую скорость падения (зависит от счета)
    final fallSpeed = _calculateFallSpeed();
    
    // Создаем предмет
    final item = FallingItem(
      itemType: itemType,
      fallSpeed: fallSpeed,
    );
    
    // Добавляем предмет в игру
    game.add(item);
  }

  /// Выбирает случайный тип предмета
  /// Вероятности:
  /// - 40% багет (базовый десерт)
  /// - 25% макарон (средний десерт)
  /// - 15% пирожное (лучший десерт с бонусом времени)
  /// - 15% кость (плохой предмет)
  /// - 5% рыбная кость (очень плохой предмет)
  ItemType _getRandomItemType() {
    final rand = _random.nextInt(100); // 0-99
    
    if (rand < 40) {
      // 0-39: Багет (40%)
      return ItemType.baguette;
    } else if (rand < 65) {
      // 40-64: Макарон (25%)
      return ItemType.macaron;
    } else if (rand < 80) {
      // 65-79: Пирожное (15%)
      return ItemType.puff;
    } else if (rand < 95) {
      // 80-94: Кость (15%)
      return ItemType.bone;
    } else {
      // 95-99: Рыбная кость (5%)
      return ItemType.fishbone;
    }
  }

  /// Вычисляет текущую скорость падения
  /// Скорость увеличивается каждые 100 очков
  double _calculateFallSpeed() {
    // Базовая скорость
    double speed = GameConstants.initialFallSpeed;
    
    // Количество увеличений скорости (каждые 100 очков)
    final speedUps = game.score ~/ GameConstants.speedIncreaseInterval;
    
    // Увеличиваем скорость
    speed += speedUps * GameConstants.speedIncreaseAmount;
    
    // Ограничиваем максимальной скоростью
    if (speed > GameConstants.maxFallSpeed) {
      speed = GameConstants.maxFallSpeed;
    }
    
    return speed;
  }

  /// Очищает все падающие предметы с экрана
  /// Вызывается при перезапуске игры
  void clearAllItems() {
    // Получаем все компоненты FallingItem
    final items = game.children.whereType<FallingItem>().toList();
    
    // Удаляем каждый предмет
    for (final item in items) {
      item.removeFromParent();
    }
  }
}
