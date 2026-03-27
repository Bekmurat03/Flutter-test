import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'game_ui.dart';
import 'player.dart';
import 'ground_line.dart';
import 'item_spawner.dart';
import 'falling_item.dart';
import '../models/game_constants.dart';

/// Главный игровой класс (GameMain)
/// Наследуется от FlameGame - это основа для создания игры на Flame
/// Здесь будет вся игровая логика: игрок, предметы, коллизии, счет
/// DragCallbacks - для обработки drag событий (перетаскивание)
class GameMain extends FlameGame with DragCallbacks {
  /// Имя игрока (получаем при создании игры)
  final String playerName;
  
  /// Callback для окончания игры
  /// Вызывается когда игра заканчивается (время вышло или HP = 0)
  final Function(int finalScore, String reason) onGameOver;
  
  // === ИГРОВЫЕ ПЕРЕМЕННЫЕ ===
  
  /// Текущий счет игрока
  int score = 0;
  
  /// Текущее количество жизней (HP)
  int hp = 3;
  
  /// Оставшееся время в секундах
  double timeLeft = 30.0;
  
  /// Флаг паузы
  bool isPaused = false;
  
  /// Ссылка на игрока (для управления)
  late Player player;
  
  /// Ссылка на спавнер предметов
  late ItemSpawner itemSpawner;
  
  GameMain({
    required this.playerName,
    required this.onGameOver,
  });

  /// Метод onLoad вызывается один раз при загрузке игры
  /// Здесь инициализируем все компоненты: игрока, фон, UI и т.д.
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Добавляем фон (с низким приоритетом, рисуется под всем)
    await add(Background());
    
    // Добавляем линию земли (визуальная подсказка)
    await add(GroundLine());
    
    // Создаем и добавляем игрока
    player = Player();
    await add(player);
    
    // Создаем и добавляем спавнер предметов
    itemSpawner = ItemSpawner();
    await add(itemSpawner);
    
    // Добавляем UI компонент (счет, HP, таймер)
    await add(GameUI());
    
    debugPrint('GameMain загружен для игрока: $playerName');
  }

  /// Метод update вызывается каждый кадр (60 раз в секунду)
  /// Здесь обновляем игровую логику: таймер, движение предметов и т.д.
  /// dt (delta time) - время прошедшее с предыдущего кадра в секундах
  @override
  void update(double dt) {
    super.update(dt);
    
    // Если игра на паузе, не обновляем логику
    if (isPaused) return;
    
    // Уменьшаем таймер
    timeLeft -= dt;
    
    // Проверяем коллизии с падающими предметами
    _checkCollisions();
    
    // Проверяем условия окончания игры
    _checkGameOver();
  }

  /// Проверяет коллизии игрока с падающими предметами
  /// Вызывается каждый кадр из update()
  void _checkCollisions() {
    // Получаем все падающие предметы
    final items = children.whereType<FallingItem>().toList();
    
    // Проверяем каждый предмет
    for (final item in items) {
      // Если предмет уже пойман, пропускаем
      if (item.isCaught) continue;
      
      // Проверяем коллизию с игроком
      if (item.checkCollisionWithPlayer()) {
        // Предмет пойман!
        item.catchItem();
      }
    }
  }

  /// Проверяет условия окончания игры
  /// Игра заканчивается если:
  /// 1. Время вышло (timeLeft <= 0)
  /// 2. Закончились жизни (hp <= 0)
  void _checkGameOver() {
    if (timeLeft <= 0) {
      // Время вышло
      _endGame("Time's up!");
    } else if (hp <= 0) {
      // Закончились жизни
      _endGame("No HP left!");
    }
  }

  /// Завершает игру
  /// Вызывает callback onGameOver с финальным счетом и причиной
  void _endGame(String reason) {
    isPaused = true; // Останавливаем игру
    onGameOver(score, reason); // Вызываем callback
  }

  /// Добавляет очки к счету
  /// Вызывается когда игрок ловит предмет
  void addScore(int points) {
    final oldScore = score;
    score += points;
    
    // Не даем счету уйти в минус
    if (score < 0) {
      score = 0;
    }
    
    // Проверяем бонус HP каждые 50 очков
    _checkHPBonus(oldScore, score);
    
    // Выводим в консоль для отладки
    debugPrint('Score: $score (${points > 0 ? '+' : ''}$points)');
  }

  /// Проверяет и добавляет HP бонус каждые 50 очков
  void _checkHPBonus(int oldScore, int newScore) {
    // Вычисляем сколько раз пересекли порог 50 очков
    final oldMilestone = oldScore ~/ GameConstants.hpBonusInterval;
    final newMilestone = newScore ~/ GameConstants.hpBonusInterval;
    
    // Если пересекли новый порог - добавляем HP
    if (newMilestone > oldMilestone) {
      final hpToAdd = newMilestone - oldMilestone;
      hp += hpToAdd;
      
      debugPrint('HP Bonus! +$hpToAdd HP (reached ${newMilestone * 50} points)');
    }
  }

  /// Добавляет время к таймеру
  /// Вызывается когда игрок ловит пирожное (puff)
  void addTime(int seconds) {
    timeLeft += seconds;
  }

  /// Отнимает HP
  /// Вызывается когда игрок ловит рыбную кость или пропускает хороший предмет
  void loseHP() {
    hp--;
    if (hp < 0) {
      hp = 0;
    }
    
    // Выводим в консоль для отладки
    debugPrint('HP lost! Current HP: $hp');
  }

  /// Переключает паузу
  /// Вызывается при нажатии кнопки паузы
  void togglePause() {
    isPaused = !isPaused;
  }

  /// Возобновляет игру после паузы
  void resume() {
    isPaused = false;
  }

  /// Перезапускает игру
  /// Сбрасывает все значения к начальным
  void restart() {
    score = 0;
    hp = 3;
    timeLeft = 30.0;
    isPaused = false;
    
    // Сбрасываем позицию игрока в центр
    player.position.x = size.x / 2;
    
    // Очищаем все падающие предметы
    itemSpawner.clearAllItems();
  }

  // === ОБРАБОТКА DRAG СОБЫТИЙ ===
  
  /// Вызывается когда пользователь начинает перетаскивание (касается экрана)
  /// event - информация о событии (позиция касания и т.д.)
  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    
    // Если игра на паузе, не обрабатываем управление
    if (isPaused) return;
    
    // Перемещаем игрока на позицию касания
    player.moveTo(event.localPosition.x);
  }

  /// Вызывается когда пользователь перетаскивает палец по экрану
  /// event - информация о событии (текущая позиция)
  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    
    // Если игра на паузе, не обрабатываем управление
    if (isPaused) return;
    
    // Перемещаем игрока следуя за пальцем
    // Используем localEndPosition для получения текущей позиции
    player.moveTo(event.localEndPosition.x);
  }

  /// Вызывается когда пользователь отпускает палец (заканчивает перетаскивание)
  /// event - информация о событии
  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    
    // Можно добавить дополнительную логику при отпускании
    // Например, плавную остановку или эффекты
  }
}


/// Компонент фона
/// Рисует простой градиентный фон для игры
class Background extends Component {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Устанавливаем самый низкий приоритет (рисуется первым, под всем)
    priority = -100;
  }
  
  @override
  void render(Canvas canvas) {
    // Создаем градиент от светло-голубого к белому
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF87CEEB), // Светло-голубой (небо)
          Color(0xFFE0F6FF), // Очень светло-голубой
        ],
      ).createShader(Rect.fromLTWH(0, 0, 1000, 2000));
    
    // Рисуем прямоугольник на весь экран
    canvas.drawRect(
      Rect.fromLTWH(0, 0, 1000, 2000),
      paint,
    );
  }
}
