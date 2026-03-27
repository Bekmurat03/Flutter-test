import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_score.dart';

/// Сервис для работы с рейтингом игроков
/// Сохраняет и загружает результаты из локального хранилища (shared_preferences)
/// Хранит топ-10 лучших результатов
class RankingService {
  /// Ключ для хранения данных в shared_preferences
  static const String _rankingsKey = 'game_rankings';
  
  /// Максимальное количество результатов в рейтинге
  static const int _maxRankings = 10;

  /// Сохраняет новый результат игрока
  /// Добавляет результат в рейтинг, сортирует и оставляет только топ-10
  Future<void> saveScore(String playerName, int score) async {
    // Получаем доступ к shared_preferences
    final prefs = await SharedPreferences.getInstance();
    
    // Загружаем текущий рейтинг
    final rankings = await getRankings();
    
    // Добавляем новый результат
    rankings.add(PlayerScore(
      playerName: playerName,
      score: score,
    ));
    
    // Сортируем по убыванию очков (лучшие результаты первыми)
    rankings.sort((a, b) {
      // Сначала сравниваем по очкам
      final scoreComparison = b.score.compareTo(a.score);
      if (scoreComparison != 0) return scoreComparison;
      
      // Если очки равны, сортируем по времени (более новые первыми)
      return b.timestamp.compareTo(a.timestamp);
    });
    
    // Оставляем только топ-10
    final topRankings = rankings.take(_maxRankings).toList();
    
    // Преобразуем в JSON и сохраняем
    final jsonList = topRankings.map((ps) => ps.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString(_rankingsKey, jsonString);
  }

  /// Загружает рейтинг из локального хранилища
  /// Возвращает список результатов, отсортированный по убыванию очков
  Future<List<PlayerScore>> getRankings() async {
    // Получаем доступ к shared_preferences
    final prefs = await SharedPreferences.getInstance();
    
    // Получаем сохраненную строку JSON
    final jsonString = prefs.getString(_rankingsKey);
    
    // Если данных нет, возвращаем пустой список
    if (jsonString == null) {
      return [];
    }
    
    try {
      // Парсим JSON
      final jsonList = jsonDecode(jsonString) as List;
      
      // Преобразуем в список PlayerScore
      return jsonList
          .map((json) => PlayerScore.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Если произошла ошибка при парсинге, возвращаем пустой список
      print('Error loading rankings: $e');
      return [];
    }
  }

  /// Очищает весь рейтинг (для тестирования)
  /// Удаляет все сохраненные результаты
  Future<void> clearRankings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rankingsKey);
  }
}
