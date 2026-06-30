# NS Proxy

Кроссплатформенный VPN-клиент для **VLESS** ключей (Android и Windows). Тёмная тема с изумрудно-зелёными акцентами в стиле бренда NS Proxy.

## Скачать готовое приложение

### Способ 1 — GitHub Releases (рекомендуется)

1. Откройте страницу релизов: **https://github.com/inik01/-/releases**
2. Скачайте нужный файл из последнего релиза:

| Файл | Платформа | Описание |
|------|-----------|----------|
| `app-release.apk` | Android | Установочный APK |
| `ns-proxy-windows.zip` | Windows | Архив с `ns_proxy.exe` и `xray.exe` |

### Способ 2 — Собрать вручную через GitHub Actions

Если релиза ещё нет, можно запустить сборку сами:

1. Перейдите в **Actions** → **Build NS Proxy Release**
2. Нажмите **Run workflow** → **Run workflow**
3. После завершения откройте завершённый workflow
4. Внизу страницы скачайте артефакты:
   - `ns-proxy-android` — APK
   - `ns-proxy-windows` — ZIP для Windows

### Способ 3 — Собрать локально

```bash
cd ns_proxy
flutter pub get
python3 tools/generate_icons.py
dart run flutter_launcher_icons
flutter build apk --release          # Android
flutter build windows --release      # Windows
```

---

## Установка

### Android

1. Скачайте `app-release.apk`
2. На телефоне разрешите установку из неизвестных источников
3. Откройте APK и установите
4. При первом подключении разрешите создание VPN-туннеля

### Windows

1. Скачайте и распакуйте `ns-proxy-windows.zip`
2. Запустите `ns_proxy.exe`
3. Для VPN-режима может потребоваться запуск **от имени администратора**
4. В архиве уже есть `xray/xray.exe` — отдельно ничего скачивать не нужно

---

## Использование

1. Откройте вкладку **Серверы** → **Добавить**
2. Вставьте VLESS ключ или подписку
3. Выберите сервер из списка
4. На главной вкладке нажмите **ПОДКЛЮЧИТЬ**

### Формат VLESS ключа

```
vless://UUID@ADDRESS:PORT?security=reality&type=tcp&flow=xtls-rprx-vision&sni=...&fp=...&pbk=...&sid=...#ИмяСервера
```

---

## Возможности

- Импорт VLESS ключей (`vless://...`)
- Импорт подписок (base64, несколько ключей)
- VPN-туннель и режим «только прокси»
- Список серверов с выбором активного
- Пинг серверов
- Кастомная иконка NS Proxy
- Поддержка Reality, XTLS, WebSocket, gRPC, TCP и других транспортов Xray

## Платформы

| Платформа | Статус |
|-----------|--------|
| Android   | Полная поддержка VPN |
| Windows   | VPN и прокси |

## Иконка приложения

Иконка генерируется из логотипа NS (чёрный фон, зелёный монограммный знак):

```bash
python3 tools/generate_icons.py
dart run flutter_launcher_icons
```

## Технологии

- **Flutter** — UI для Android и Windows
- **flutter_vless** — парсинг VLESS и Xray VPN ядро
- **Provider** — управление состоянием

## Публикация релиза (для разработчиков)

Чтобы опубликовать новую версию на GitHub Releases:

```bash
git tag v1.0.0
git push origin v1.0.0
```

GitHub Actions автоматически соберёт APK и Windows ZIP и опубликует их в Releases.

## Лицензия

MIT
