# NS Proxy

Кроссплатформенный VPN-клиент для **VLESS** ключей (Android и Windows). Тёмная тема с изумрудно-зелёными акцентами в стиле бренда NS Proxy.

## Возможности

- Импорт VLESS ключей (`vless://...`)
- Импорт подписок (base64, несколько ключей)
- VPN-туннель и режим «только прокси»
- Список серверов с выбором активного
- Пинг серверов
- Поддержка Reality, XTLS, WebSocket, gRPC, TCP и других транспортов Xray

## Платформы

| Платформа | Статус |
|-----------|--------|
| Android   | Полная поддержка VPN |
| Windows   | VPN и прокси (требуется Xray) |
| Linux     | Сборка UI (VPN через flutter_vless) |

## Сборка

### Требования

- Flutter SDK 3.7+
- Android SDK (для Android)
- Visual Studio / MSVC (для Windows)

### Установка зависимостей

```bash
cd ns_proxy
flutter pub get
```

### Android

```bash
flutter build apk --release
# или
flutter run -d android
```

### Windows

Для VPN-режима на Windows поместите `xray.exe` в `windows/xray/` (см. документацию [flutter_vless](https://pub.dev/packages/flutter_vless)).

```bash
flutter build windows --release
# или
flutter run -d windows
```

## Использование

1. Откройте вкладку **Серверы** → **Добавить**
2. Вставьте VLESS ключ или подписку
3. Выберите сервер из списка
4. На главной вкладке нажмите **ПОДКЛЮЧИТЬ**

## Формат VLESS ключа

```
vless://UUID@ADDRESS:PORT?security=reality&type=tcp&flow=xtls-rprx-vision&sni=...&fp=...&pbk=...&sid=...#ИмяСервера
```

## Технологии

- **Flutter** — UI для Android и Windows
- **flutter_vless** — парсинг VLESS и Xray VPN ядро
- **Provider** — управление состоянием

## Лицензия

MIT
