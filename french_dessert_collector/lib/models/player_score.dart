/// Модель для хранения результата игрока
/// Содержит имя игрока и его счет
/// Используется в рейтинге и для сохранения в локальное хранилище
class PlayerScore {
  /// Имя игрока
  final String playerName;
  
  /// Количество очков
  final int score;
  
  /// Дата и время игры (для сортировки при одинаковых очках)
  final DateTime timestamp;

  PlayerScore({
    required this.playerName,
    required this.score,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Создает PlayerScore из JSON
  /// Используется при загрузке данных из shared_preferences
  factory PlayerScore.fromJson(Map<String, dynamic> json) {
    return PlayerScore(
      playerName: json['playerName'] as String,
      score: json['score'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Преобразует PlayerScore в JSON
  /// Используется при сохранении данных в shared_preferences
  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'score': score,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
