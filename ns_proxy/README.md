<div dir="ltr" align=center>
    
[**![Lang_farsi](https://user-images.githubusercontent.com/125398461/234186932-52f1fa82-52c6-417f-8b37-08fe9250a55f.png) فارسی**](README_fa.md) / [**Русский 🇷🇺**](README_ru.md) / [**简体中文 🇨🇳**](README_cn.md) / [**日本語 🇯🇵**](README_ja.md) / [**Portugês-BR 🇧🇷**](README_br.md)

</div>
<br>

<p align="center"><img src="assets/images/logo.svg" width=120 /></p>

<h1 align="center">NS Proxy</h1>

<p align="center">
  <strong>Форк <a href="https://github.com/hiddify/hiddify-app">Hiddify</a> — мультиплатформенный прокси-клиент на Sing-box</strong>
</p>

<div align="center">

[![Downloads](https://img.shields.io/github/downloads/inik01/-/total?style=flat-square&logo=github)](https://github.com/inik01/-/releases)
[![Last Release](https://img.shields.io/github/v/release/inik01/-?style=flat-square)](https://github.com/inik01/-/releases/latest)

</div>

## Что такое NS Proxy?

<p dir="ltr" style="font-size: 16px">NS Proxy — это ребрендинг открытого клиента Hiddify. Поддерживаются те же протоколы и функции: автовыбор узла, TUN, удалённые профили, подписки. Приложение бесплатное и с открытым исходным кодом.</p>

## Скачать

**[Releases →](https://github.com/inik01/-/releases/latest)**

| Платформа | Файлы |
|-----------|-------|
| Android | `NS-Proxy-Android-universal.apk` |
| Windows | `NS-Proxy-Windows-Portable-x64.zip`, `NS-Proxy-Windows-Setup-x64.exe` |
| iOS | `NS-Proxy-iOS.ipa` |

## Основные возможности

✈️ Android, iOS, Windows, macOS, Linux

⭐ Удобный интерфейс

🔍 Выбор узла по задержке

🟡 Vless, Vmess, Reality, TUIC, Hysteria, Wireguard, SSH и др.

🔄 Автообновление подписок

🛡 Открытый исходный код (форк Hiddify)

🌙 Тёмная и светлая темы

## Сборка

```bash
make android-apk-prepare && make android-apk-release
make windows-prepare && make windows-release
make ios-prepare && make ios-release   # macOS + Apple Developer
```

Flutter **3.38.5** — см. `pubspec.yaml`.

## Лицензия

Hiddify Extended GPL v3. Атрибуция оригинальному проекту Hiddify обязательна. См. [LICENSE.md](LICENSE.md).
