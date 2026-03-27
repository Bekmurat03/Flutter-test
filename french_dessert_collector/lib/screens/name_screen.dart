import 'package:flutter/material.dart';
import 'game_screen.dart';

/// Экран ввода имени игрока (NameScreen)
/// Появляется после нажатия "Game Start" на главном экране
/// Игрок вводит свое имя, которое будет использоваться в рейтинге
class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  /// Контроллер для текстового поля (управляет вводом имени)
  final TextEditingController _nameController = TextEditingController();
  
  /// Ключ формы для валидации (проверки правильности ввода)
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Освобождаем ресурсы контроллера когда экран закрывается
    _nameController.dispose();
    super.dispose();
  }

  /// Обработчик нажатия кнопки "Start Game"
  /// Проверяет имя и переходит к игре
  void _startGame() {
    // Проверяем валидацию формы
    if (_formKey.currentState!.validate()) {
      // Получаем введенное имя
      final playerName = _nameController.text.trim();
      
      // Переходим на экран игры, передавая имя игрока
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(playerName: playerName),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Градиентный фон (такой же как на главном экране)
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Заголовок
                  const Text(
                    'Enter Your Name',
                    style: TextStyle(
                      fontSize: 32,
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
                  
                  const SizedBox(height: 40),
                  
                  // Поле ввода имени
                  TextFormField(
                    controller: _nameController,
                    
                    // Стиль текста
                    style: const TextStyle(fontSize: 20),
                    
                    // Настройки клавиатуры
                    textAlign: TextAlign.center,
                    maxLength: 15, // Максимум 15 символов
                    
                    // Оформление поля
                    decoration: InputDecoration(
                      hintText: 'Your name',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    
                    /// Валидация имени
                    /// Проверяет что имя не пустое и содержит минимум 2 символа
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null; // null = валидация прошла успешно
                    },
                    
                    // Нажатие Enter на клавиатуре = начать игру
                    onFieldSubmitted: (_) => _startGame(),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Кнопка "Start Game"
                  // При нажатии проверяет имя и переходит к игре
                  ElevatedButton(
                    onPressed: _startGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Start Game',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Кнопка "Back" для возврата на главный экран
                  TextButton(
                    onPressed: () {
                      // Возвращаемся на предыдущий экран (HomeScreen)
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
