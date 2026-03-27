import 'package:flutter/material.dart';

/// Экран с инструкциями (How to Play)
/// Объясняет правила игры и управление
class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB), // Светло-голубой
              Color(0xFFFFB6C1), // Светло-розовый
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
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    
                    const Expanded(
                      child: Text(
                        'How to Play',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              
              // Контент с инструкциями
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Цель игры
                      _buildSection(
                        title: '🎯 Goal',
                        content: 'Catch French desserts and avoid bones! Get the highest score in 30 seconds.',
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Управление
                      _buildSection(
                        title: '🎮 Controls',
                        content: 'Drag your finger (or mouse) left and right to move the chef.',
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Хорошие предметы
                      _buildSection(
                        title: '✅ Good Items',
                        content: '',
                      ),
                      _buildItem('🥖 Baguette', '+10 points'),
                      _buildItem('🍰 Macaron', '+20 points'),
                      _buildItem('🧁 Puff', '+30 points + 30 seconds'),
                      
                      const SizedBox(height: 24),
                      
                      // Плохие предметы
                      _buildSection(
                        title: '❌ Bad Items',
                        content: '',
                      ),
                      _buildItem('🦴 Bone', '-10 points'),
                      _buildItem('🐟 Fishbone', '-20 points - 1 HP'),
                      
                      const SizedBox(height: 24),
                      
                      // Правила
                      _buildSection(
                        title: '📋 Rules',
                        content: '• You have 3 HP (lives)\n'
                                '• Missing a dessert = -1 HP\n'
                                '• Catching fishbone = -1 HP\n'
                                '• Every 50 points = +1 HP bonus\n'
                                '• Game ends when time runs out or HP = 0\n'
                                '• Speed increases every 100 points',
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Советы
                      _buildSection(
                        title: '💡 Tips',
                        content: '• Focus on catching puffs for time bonus\n'
                                '• Avoid bones to keep your score high\n'
                                '• Don\'t miss desserts or you\'ll lose HP\n'
                                '• The game gets faster as you score more',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Создает секцию с заголовком и контентом
  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 4,
                color: Colors.black26,
              ),
            ],
          ),
        ),
        if (content.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Создает строку с предметом и описанием
  Widget _buildItem(String emoji, String description) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
