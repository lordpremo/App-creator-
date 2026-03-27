#!/bin/bash

echo "=============================="
echo " BROKEN WEBVIEW APK BUILDER"
echo "=============================="
echo ""

# Check termux-api
if ! command -v termux-file-picker &> /dev/null
then
    echo "termux-api haipo. Run: pkg install termux-api"
    exit 1
fi

read -p "Ingiza Website URL: " URL
read -p "Ingiza App Name: " APP_NAME

echo ""
echo "Chagua ICON kutoka kwenye gallery..."
ICON=$(termux-file-picker)

if [ -z "$ICON" ]; then
    echo "Hakuna icon umechagua. Exiting..."
    exit 1
fi

echo "Icon imechaguliwa: $ICON"
echo ""

# Reset template (optional)
cp app/src/main/java/com/broken/MainActivity.java.bak app/src/main/java/com/broken/MainActivity.java
cp app/src/main/AndroidManifest.xml.bak app/src/main/AndroidManifest.xml

# Replace URL in MainActivity
sed -i "s|APP_URL|$URL|g" app/src/main/java/com/broken/MainActivity.java

# Replace App Name in Manifest
sed -i "s|APP_NAME|$APP_NAME|g" app/src/main/AndroidManifest.xml

# Replace icon
cp "$ICON" app/src/main/res/mipmap-xxxhdpi/ic_launcher.png

echo "Inajenga APK, subiri..."
./gradlew assembleRelease

if [ ! -f app/build/outputs/apk/release/app-release.apk ]; then
    echo "Build imeshindikana. Angalia errors za Gradle."
    exit 1
fi

OUT="${APP_NAME}.apk"
cp app/build/outputs/apk/release/app-release.apk "$OUT"

APK_PATH=$(realpath "$OUT")

echo ""
echo "=============================="
echo " APK IMEKAMILIKA!"
echo " File: $OUT"
echo "=============================="
echo ""
echo "LINK YA APK YAKO:"
echo "$APK_PATH"
echo ""
echo "Copy link hii na utume kwa mtu moja kwa moja."
