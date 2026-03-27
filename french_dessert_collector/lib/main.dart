import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';

/// Главная точка входа в приложение
/// Здесь настраиваем ориентацию экрана и запускаем приложение
void main() {
  // Гарантируем инициализацию Flutter перед настройками
  WidgetsFlutterBinding.ensureInitialized();
  
  // Блокируем поворот экрана - игра работает только в портретном режиме
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  // Запускаем приложение
  runApp(const MyApp());
}

/// Корневой виджет приложения
/// Настраивает тему и определяет начальный экран
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Название приложения
      title: 'French Dessert Collector',
      
      // Убираем баннер DEBUG в правом верхнем углу
      debugShowCheckedModeBanner: false,
      
      // Настройка темы приложения
      theme: ThemeData(
        // Основной цвет - французский синий
        primarySwatch: Colors.blue,
        
        // Используем Material 3 дизайн
        useMaterial3: true,
      ),
      
      // Начальный экран - HomeScreen (главное меню)
      home: const HomeScreen(),
    );
  }
}
