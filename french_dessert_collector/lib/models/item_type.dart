import 'game_constants.dart';

/// Типы предметов, которые падают в игре
/// Каждый тип имеет свои свойства: эмодзи, очки, эффекты
enum ItemType {
  baguette,   // Багет - хороший предмет
  macaron,    // Макарон - хороший предмет
  puff,       // Пирожное - лучший предмет (дает время)
  bone,       // Кость - плохой предмет
  fishbone,   // Рыбная кость - очень плохой предмет (отнимает HP)
}

/// Расширение для ItemType
/// Добавляет полезные методы и свойства к каждому типу предмета
extension ItemTypeExtension on ItemType {
  /// Возвращает эмодзи для отображения предмета
  String get emoji {
    switch (this) {
      case ItemType.baguette:
        return '🥖'; // Багет
      case ItemType.macaron:
        return '🍰'; // Макарон (используем тортик)
      case ItemType.puff:
        return '🧁'; // Пирожное
      case ItemType.bone:
        return '🦴'; // Кость
      case ItemType.fishbone:
        return '🐟'; // Рыбная кость
    }
  }
  
  /// Возвращает количество очков за этот предмет
  /// Положительные очки - хорошие предметы
  /// Отрицательные очки - плохие предметы
  int get score {
    switch (this) {
      case ItemType.baguette:
        return GameConstants.baguetteScore;
      case ItemType.macaron:
        return GameConstants.macaronScore;
      case ItemType.puff:
        return GameConstants.puffScore;
      case ItemType.bone:
        return GameConstants.boneScore;
      case ItemType.fishbone:
        return GameConstants.fishboneScore;
    }
  }
  
  /// Проверяет, является ли предмет хорошим (дает очки)
  bool get isGood {
    return score > 0;
  }
  
  /// Проверяет, отнимает ли предмет HP при поимке
  bool get damagesHP {
    return this == ItemType.fishbone;
  }
  
  /// Проверяет, дает ли предмет бонус времени
  bool get givesTimeBonus {
    return this == ItemType.puff;
  }
}
