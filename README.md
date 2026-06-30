# NS Proxy

**NS Proxy** — мультиплатформенный VPN/прокси-клиент на базе [Hiddify](https://github.com/hiddify/hiddify-app) (Sing-box).

Поддерживает **Android**, **iOS** и **Windows** (также macOS и Linux из исходников Hiddify).

## Возможности

- VLESS, VMess, Reality, TUIC, Hysteria, WireGuard и др.
- Импорт ключей и подписок (Sing-box, V2ray, Clash)
- TUN-режим, автовыбор узла, тёмная тема
- Изумрудная цветовая схема NS Proxy

## Скачать

Готовые сборки: **[Releases](https://github.com/inik01/-/releases/latest)**

| Платформа | Файл |
|-----------|------|
| Android | `NS-Proxy-Android-universal.apk` |
| Windows | `NS-Proxy-Windows-Portable-x64.zip` или `NS-Proxy-Windows-Setup-x64.exe` |
| iOS | `NS-Proxy-iOS.ipa` (нужна подпись для установки) |

## Сборка из исходников

```bash
cd ns_proxy
make android-apk-prepare && make android-apk-release   # Android
make windows-prepare && make windows-release             # Windows
make ios-prepare && make ios-release                     # iOS (macOS + Xcode)
```

Требуется Flutter **3.38.5** (см. `ns_proxy/pubspec.yaml`).

## Лицензия

Проект основан на Hiddify и распространяется под **Hiddify Extended GPL v3**.  
Исходный код Hiddify: https://github.com/hiddify/hiddify-app

Подробности: `ns_proxy/LICENSE.md`
