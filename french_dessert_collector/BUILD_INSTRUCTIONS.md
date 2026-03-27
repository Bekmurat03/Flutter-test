# 📦 Инструкции по сборке и публикации

## 🔧 Подготовка проекта

### 1. Проверка окружения
```bash
flutter doctor
```

Убедитесь что все галочки зеленые для нужной платформы.

### 2. Очистка проекта
```bash
cd french_dessert_collector
flutter clean
flutter pub get
```

### 3. Проверка кода
```bash
flutter analyze
flutter test
```

## 📱 Сборка для Android

### Debug версия (для тестирования)
```bash
flutter build apk --debug
```

Файл: `build/app/outputs/flutter-apk/app-debug.apk`

### Release версия (для публикации)
```bash
flutter build apk --release
```

Файл: `build/app/outputs/flutter-apk/app-release.apk`

### Split APK (по архитектурам)
```bash
flutter build apk --split-per-abi --release
```

Создаст 3 файла (меньший размер):
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit x86)

### App Bundle (для Google Play)
```bash
flutter build appbundle --release
```

Файл: `build/app/outputs/bundle/release/app-release.aab`

## 🍎 Сборка для iOS

### Требования:
- Mac с macOS
- Xcode установлен
- Apple Developer аккаунт (для публикации)

### Debug версия
```bash
flutter build ios --debug
```

### Release версия
```bash
flutter build ios --release
```

### Открыть в Xcode
```bash
open ios/Runner.xcworkspace
```

## 🔐 Подписание приложения (Android)

### 1. Создание keystore
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

### 2. Создание key.properties
Создайте файл `android/key.properties`:
```properties
storePassword=<пароль>
keyPassword=<пароль>
keyAlias=upload
storeFile=<путь к keystore>
```

### 3. Обновление build.gradle
В `android/app/build.gradle` добавьте перед `android {`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

В секции `buildTypes`:
```gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}
buildTypes {
    release {
        signingConfig signingConfigs.release
    }
}
```

## 📝 Настройка метаданных

### Android (android/app/src/main/AndroidManifest.xml)
```xml
<application
    android:label="French Dessert Collector"
    android:icon="@mipmap/ic_launcher">
```

### Иконка приложения
Используйте [App Icon Generator](https://appicon.co/) для создания иконок.

Поместите иконки в:
- Android: `android/app/src/main/res/mipmap-*/`
- iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Версия приложения (pubspec.yaml)
```yaml
version: 1.0.0+1
# 1.0.0 - версия для пользователей
# +1 - build number (увеличивайте при каждой сборке)
```

## 🚀 Публикация в Google Play

### 1. Создание аккаунта
- Зарегистрируйтесь на [Google Play Console](https://play.google.com/console)
- Оплатите регистрацию ($25 один раз)

### 2. Создание приложения
- Нажмите "Create app"
- Заполните информацию о приложении
- Выберите категорию "Games"

### 3. Подготовка материалов
Нужны:
- Иконка приложения (512x512 PNG)
- Feature graphic (1024x500 PNG)
- Скриншоты (минимум 2)
- Описание приложения
- Политика конфиденциальности (если собираете данные)

### 4. Загрузка APK/AAB
- Перейдите в "Release" → "Production"
- Загрузите app-release.aab
- Заполните release notes
- Отправьте на проверку

### 5. Проверка
Google проверит приложение (1-7 дней).

## 🍎 Публикация в App Store

### 1. Создание аккаунта
- Зарегистрируйтесь в [Apple Developer Program](https://developer.apple.com/)
- Оплатите подписку ($99/год)

### 2. Настройка в Xcode
- Откройте `ios/Runner.xcworkspace`
- Выберите свою команду в Signing & Capabilities
- Настройте Bundle Identifier

### 3. Создание приложения в App Store Connect
- Перейдите на [App Store Connect](https://appstoreconnect.apple.com/)
- Создайте новое приложение
- Заполните метаданные

### 4. Загрузка через Xcode
```bash
flutter build ios --release
open ios/Runner.xcworkspace
```

В Xcode:
- Product → Archive
- Distribute App → App Store Connect
- Upload

### 5. Отправка на проверку
- Заполните все поля в App Store Connect
- Добавьте скриншоты
- Отправьте на проверку

## 🧪 Тестирование перед публикацией

### Чек-лист:
- [ ] Игра запускается без ошибок
- [ ] Все экраны работают
- [ ] Управление отзывчивое
- [ ] Коллизии работают правильно
- [ ] Счет сохраняется в рейтинг
- [ ] Пауза работает
- [ ] Game Over показывается корректно
- [ ] Нет вылетов при длительной игре
- [ ] Работает на разных разрешениях
- [ ] Портретная ориентация заблокирована

### Тестовые устройства:
- Минимум 2 разных устройства
- Разные версии Android/iOS
- Разные размеры экранов

## 📊 Оптимизация размера

### Уменьшение APK
```bash
# Включить ProGuard (android/app/build.gradle)
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
    }
}

# Split по архитектурам
flutter build apk --split-per-abi --release
```

### Проверка размера
```bash
# Размер APK
ls -lh build/app/outputs/flutter-apk/

# Анализ содержимого
unzip -l app-release.apk
```

## 🐛 Решение проблем

### Ошибка "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

### Ошибка "CocoaPods not installed"
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
```

### Ошибка подписи (Android)
- Проверьте пути в key.properties
- Убедитесь что keystore существует
- Проверьте пароли

### Ошибка "Minimum SDK version"
В `android/app/build.gradle`:
```gradle
defaultConfig {
    minSdkVersion 21  // Минимум Android 5.0
}
```

## 📈 После публикации

### Мониторинг:
- Проверяйте отзывы пользователей
- Следите за crash reports
- Анализируйте метрики (установки, удержание)

### Обновления:
- Исправляйте баги
- Добавляйте новые фичи
- Увеличивайте version в pubspec.yaml
- Собирайте и загружайте новую версию

### Маркетинг:
- Делитесь в соцсетях
- Просите друзей оставить отзывы
- Создайте landing page
- Снимите gameplay видео

## 🎉 Готово!

Ваша игра готова к публикации!

**Удачи! 🚀**
