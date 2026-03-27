/// Константы игры
/// Здесь хранятся все настройки игры: очки, скорости, время и т.д.
/// Изменяя значения здесь, можно легко балансировать игру

class GameConstants {
  // === ИГРОВЫЕ ПАРАМЕТРЫ ===
  
  /// Начальное количество жизней (HP)
  static const int initialHP = 3;
  
  /// Длительность игры в секундах
  static const int gameDuration = 30;
  
  // === ОЧКИ ЗА ПРЕДМЕТЫ ===
  
  /// Багет - базовый десерт
  static const int baguetteScore = 10;
  
  /// Макарон - средний десерт
  static const int macaronScore = 20;
  
  /// Пирожное - лучший десерт (дает бонус времени)
  static const int puffScore = 30;
  
  /// Кость - плохой предмет
  static const int boneScore = -10;
  
  /// Рыбная кость - очень плохой предмет (отнимает HP)
  static const int fishboneScore = -20;
  
  // === БОНУСЫ ===
  
  /// Сколько секунд добавляет пирожное
  static const int puffTimeBonus = 30;
  
  /// Через сколько очков добавляется 1 HP
  static const int hpBonusInterval = 50;
  
  // === СКОРОСТЬ ИГРЫ ===
  
  /// Начальная скорость падения предметов
  static const double initialFallSpeed = 200.0;
  
  /// Через сколько очков увеличивается скорость
  static const int speedIncreaseInterval = 100;
  
  /// На сколько увеличивается скорость при достижении интервала
  static const double speedIncreaseAmount = 50.0;
  
  /// Максимальная скорость падения
  static const double maxFallSpeed = 500.0;
  
  // === РАЗМЕРЫ ===
  
  /// Размер игрока (ширина и высота)
  static const double playerSize = 60.0;
  
  /// Размер падающих предметов
  static const double itemSize = 50.0;
  
  // === СПАВН ПРЕДМЕТОВ ===
  
  /// Интервал появления новых предметов (в секундах)
  static const double itemSpawnInterval = 1.5;
}
