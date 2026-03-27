import 'package:flutter/material.dart';
import 'game_main.dart';

/// Overlay для паузы (PauseOverlay)
/// Показывается поверх игры когда игрок нажимает паузу
/// Содержит кнопки: Continue, Restart, Quit
class PauseOverlay extends StatelessWidget {
  /// Ссылка на игру (нужна для управления паузой)
  final GameMain game;
  
  const PauseOverlay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Полупрозрачный черный фон
      color: Colors.black87,
      
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Заголовок "PAUSED"
              const Text(
                'PAUSED',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Кнопка "Continue"
              // Возобновляет игру и скрывает overlay
              _buildButton(
                context,
                label: 'Continue',
                icon: Icons.play_arrow,
                color: Colors.green,
                onPressed: () {
                  // Возобновляем игру
                  game.resume();
                  
                  // Скрываем overlay паузы
                  game.overlays.remove('pause');
                },
              ),
              
              const SizedBox(height: 16),
              
              // Кнопка "Restart"
              // Перезапускает игру с начала
              _buildButton(
                context,
                label: 'Restart',
                icon: Icons.refresh,
                color: Colors.orange,
                onPressed: () {
                  // Перезапускаем игру
                  game.restart();
                  
                  // Скрываем overlay паузы
                  game.overlays.remove('pause');
                },
              ),
              
              const SizedBox(height: 16),
              
              // Кнопка "Quit"
              // Выходит из игры и возвращается на главный экран
              _buildButton(
                context,
                label: 'Quit',
                icon: Icons.exit_to_app,
                color: Colors.red,
                onPressed: () {
                  // Возвращаемся на главный экран (удаляем все экраны до первого)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Вспомогательный метод для создания кнопок
  /// Все кнопки имеют одинаковый стиль, отличаются только цветом и текстом
  Widget _buildButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 200,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}
