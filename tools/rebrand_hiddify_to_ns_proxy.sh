#!/usr/bin/env bash
# Rebrand Hiddify fork to NS Proxy (display names, IDs, theme, CI labels).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../ns_proxy" && pwd)"
APP_ID="com.nsproxy.app"
IOS_BUNDLE="com.nsproxy.app"
IOS_EXT="${IOS_BUNDLE}.PacketTunnel"

echo "Rebranding in $ROOT"

# Bulk text replacements (display / user-facing)
find "$ROOT" -type f \( \
  -name '*.dart' -o -name '*.xml' -o -name '*.yaml' -o -name '*.yml' -o -name '*.json' -o -name '*.md' \
  -o -name '*.plist' -o -name '*.xcconfig' -o -name '*.cc' -o -name '*.cpp' -o -name '*.rc' \
  -o -name '*.gradle' -o -name '*.properties' -o -name '*.i18n.json' -o -name 'CMakeLists.txt' \
  -o -name 'Makefile' -o -name '*.swift' -o -name '*.kt' -o -name '*.appdata.xml' \
\) ! -path '*/.git/*' ! -path '*/hiddify-core/*' ! -path '*/generated/*' \
  -exec sed -i \
    -e 's/"Hiddify"/"NS Proxy"/g' \
    -e 's/>Hiddify</>NS Proxy</g' \
    -e 's/Hiddify Packet Tunnel/NS Proxy Packet Tunnel/g' \
    -e 's/HiddifyPacketTunnel/NSProxyPacketTunnel/g' \
    -e 's/display_name: Hiddify/display_name: NS Proxy/g' \
    -e 's/publisher_display_name: Hiddify/publisher_display_name: NS Proxy/g' \
    -e 's/publisher: Hiddify/publisher: NS Proxy/g' \
    -e 's/TARGET_NAME_apk: "Hiddify-Android"/TARGET_NAME_apk: "NS-Proxy-Android"/g' \
    -e 's/TARGET_NAME_aab: "Hiddify-Android"/TARGET_NAME_aab: "NS-Proxy-Android"/g' \
    -e 's/TARGET_NAME_exe: "Hiddify-Windows-Setup-x64"/TARGET_NAME_exe: "NS-Proxy-Windows-Setup-x64"/g' \
    -e 's/TARGET_NAME_msix: "Hiddify-Windows-x64"/TARGET_NAME_msix: "NS-Proxy-Windows-x64"/g' \
    -e 's/TARGET_NAME_zip: "Hiddify-Windows-Portable-x64"/TARGET_NAME_zip: "NS-Proxy-Windows-Portable-x64"/g' \
    -e 's/TARGET_NAME_ipa: "Hiddify-iOS"/TARGET_NAME_ipa: "NS-Proxy-iOS"/g' \
    -e 's/app\.hiddify\.com/'"$APP_ID"'/g' \
    -e 's/apple\.hiddify\.com/'"$IOS_BUNDLE"'/g' \
    -e 's/identity_name: Hiddify\.HiddifyNext/identity_name: NSProxy.NSProxy/g' \
    -e 's/install_dir_name: "{autopf64}\\\\Hiddify"/install_dir_name: "{autopf64}\\\\NS Proxy"/g' \
    -e 's/L"Hiddify"/L"NS Proxy"/g' \
    -e 's/"Hiddify"/"NS Proxy"/g' \
    -e 's/ProductName", "hiddify"/ProductName", "NS Proxy"/g' \
    -e 's/OriginalFilename", "Hiddify\.exe"/OriginalFilename", "ns_proxy.exe"/g' \
    -e 's/BINARY_NAME "Hiddify"/BINARY_NAME "ns_proxy"/g' \
    -e 's/BINARY_NAME "hiddify"/BINARY_NAME "ns_proxy"/g' \
    -e 's/gtk_window_set_title(window, "Hiddify")/gtk_window_set_title(window, "NS Proxy")/g' \
    -e 's/gtk_header_bar_set_title(header_bar, "Hiddify")/gtk_header_bar_set_title(header_bar, "NS Proxy")/g' \
    {} +

# Android applicationId (keep internal kotlin package for compatibility)
sed -i 's/applicationId "app.hiddify.com"/applicationId "'"$APP_ID"'"/' "$ROOT/android/app/build.gradle" 2>/dev/null || \
sed -i 's/applicationId "'"$APP_ID"'"/applicationId "'"$APP_ID"'"/' "$ROOT/android/app/build.gradle"

# Constants
sed -i 's/static const appName = "NS Proxy";/static const appName = "NS Proxy";/' "$ROOT/lib/core/model/constants.dart"
sed -i 's|static const githubUrl = "https://github.com/hiddify/hiddify-next"|static const githubUrl = "https://github.com/inik01/-"|' "$ROOT/lib/core/model/constants.dart"
sed -i 's|static const githubLatestReleaseUrl = "https://github.com/hiddify/hiddify-app/releases/latest"|static const githubLatestReleaseUrl = "https://github.com/inik01/-/releases/latest"|' "$ROOT/lib/core/model/constants.dart"

# Theme — emerald green
sed -i 's/Color(0xFF293CA0)/Color(0xFF22C55E)/g' "$ROOT/lib/core/theme/app_theme.dart"
sed -i 's/idleColor: Color(0xFF4a4d8b)/idleColor: Color(0xFF1F2937)/' "$ROOT/lib/core/theme/theme_extensions.dart" 2>/dev/null || true
sed -i 's/connectedColor: Color(0xFF44a334)/connectedColor: Color(0xFF22C55E)/' "$ROOT/lib/core/theme/theme_extensions.dart" 2>/dev/null || true

# pubspec version reset + splash dark
sed -i 's/^version: .*/version: 1.0.0+100/' "$ROOT/pubspec.yaml"
sed -i 's/description: .*/description: NS Proxy — VLESS VPN client based on Hiddify (Sing-box)./' "$ROOT/pubspec.yaml"

# iOS bundle identifiers
if [ -f "$ROOT/ios/Base.xcconfig" ]; then
  sed -i "s/BASE_BUNDLE_IDENTIFIER = .*/BASE_BUNDLE_IDENTIFIER = $IOS_BUNDLE/" "$ROOT/ios/Base.xcconfig"
  sed -i "s/SERVICE_IDENTIFIER = .*/SERVICE_IDENTIFIER = $APP_ID/" "$ROOT/ios/Base.xcconfig"
fi

# macOS bundle
if [ -f "$ROOT/macos/Runner/Configs/AppInfo.xcconfig" ]; then
  sed -i "s/PRODUCT_BUNDLE_IDENTIFIER = .*/PRODUCT_BUNDLE_IDENTIFIER = $APP_ID/" "$ROOT/macos/Runner/Configs/AppInfo.xcconfig"
  sed -i 's/PRODUCT_NAME = .*/PRODUCT_NAME = NS Proxy/' "$ROOT/macos/Runner/Configs/AppInfo.xcconfig"
fi

# Linux app id
sed -i "s/set(APPLICATION_ID \".*\")/set(APPLICATION_ID \"$APP_ID\")/" "$ROOT/linux/CMakeLists.txt" 2>/dev/null || true

# Web manifest
sed -i 's/"#0175C2"/"#22C55E"/' "$ROOT/web/manifest.json" 2>/dev/null || true

# Persian title in translations
find "$ROOT/assets/translations" -name '*.i18n.json' -exec sed -i 's/"appTitle": "هیدیفای"/"appTitle": "NS Proxy"/g' {} + 2>/dev/null || true

echo "Rebrand complete."
