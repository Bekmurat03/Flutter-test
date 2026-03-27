import 'package:flutter/material.dart';
import '../services/ranking_service.dart';
import '../models/player_score.dart';

/// Экран рейтинга (Ranking Screen)
/// Показывает таблицу лидеров - топ игроков с лучшими результатами
/// Данные загружаются из локального хранилища (shared_preferences)
class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  /// Сервис для работы с рейтингом (загрузка/сохранение)
  final RankingService _rankingService = RankingService();
  
  /// Список результатов игроков (загружается асинхронно)
  List<PlayerScore> _rankings = [];
  
  /// Флаг загрузки данных
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Загружаем рейтинг при открытии экрана
    _loadRankings();
  }

  /// Загружает рейтинг из локального хранилища
  /// Вызывается автоматически при открытии экрана
  Future<void> _loadRankings() async {
    // Получаем список результатов через сервис
    final rankings = await _rankingService.getRankings();
    
    // Обновляем состояние виджета
    setState(() {
      _rankings = rankings;
      _isLoading = false; // Загрузка завершена
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Градиентный фон
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2C3E50), // Темно-синий
              Color(0xFF3498DB), // Голубой
            ],
          ),
        ),
        
        child: SafeArea(
          child: Column(
            children: [
              // Заголовок с кнопкой назад
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Кнопка "Назад"
                    // Возвращаемся на предыдущий экран
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    
                    const Expanded(
                      child: Text(
                        'Ranking',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    // Пустой контейнер для симметрии (чтобы заголовок был по центру)
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              
              // Иконка трофея
              const Text('🏆', style: TextStyle(fontSize: 60)),
              
              const SizedBox(height: 20),
              
              // Список результатов или индикатор загрузки
              Expanded(
                child: _isLoading
                    ? const Center(
                        // Показываем индикатор пока данные загружаются
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : _rankings.isEmpty
                        ? const Center(
                            // Если рейтинг пустой (еще никто не играл)
                            child: Text(
                              'No scores yet.\nBe the first to play!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                              ),
                            ),
                          )
                        : ListView.builder(
                            // Строим список результатов
                            padding: const EdgeInsets.all(16),
                            itemCount: _rankings.length,
                            itemBuilder: (context, index) {
                              final playerScore = _rankings[index];
                              final rank = index + 1; // Место в рейтинге (1, 2, 3...)
                              
                              // Медали для топ-3
                              String medal = '';
                              if (rank == 1) medal = '🥇';
                              if (rank == 2) medal = '🥈';
                              if (rank == 3) medal = '🥉';
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  // Золотой фон для первого места
                                  color: rank == 1
                                      ? Colors.amber.withOpacity(0.3)
                                      : Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Место в рейтинге
                                    SizedBox(
                                      width: 50,
                                      child: Text(
                                        medal.isEmpty ? '#$rank' : medal,
                                        style: TextStyle(
                                          fontSize: medal.isEmpty ? 20 : 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    
                                    // Имя игрока
                                    Expanded(
                                      child: Text(
                                        playerScore.playerName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    
                                    // Очки
                                    Text(
                                      '${playerScore.score}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
