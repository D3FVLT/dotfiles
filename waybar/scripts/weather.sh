#!/bin/sh

# Получаем город через IP-адрес
CITY="$(curl -s ipinfo.io/city)"

# Если не удалось получить город, используем auto
if [[ -z "$CITY" ]]; then
    CITY="auto"
fi

# Запрашиваем погоду
text="$(curl -s "https://wttr.in/$CITY?format=1" | sed 's/ //g')"
tooltip="$(curl -s "https://wttr.in/$CITY?0QT" |
    sed 's/\\/\\\\/g' |
    sed ':a;N;$!ba;s/\n/\\n/g' |
    sed 's/"/\\"/g')"

# Вывод в JSON формате для Waybar
if ! grep -q "Unknown location" <<< "$text"; then
    echo "{\"text\": \"$text\", \"tooltip\": \"<tt>$tooltip</tt>\", \"class\": \"weather\"}"
fi
