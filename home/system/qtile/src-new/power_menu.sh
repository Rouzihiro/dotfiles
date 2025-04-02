#!/bin/sh

choice=$(echo -e "Sair do Qtile\nReiniciar\nDesligar" | rofi -dmenu -p "Escolha uma opção:")
case "$choice" in
"Sair do Qtile") qtile cmd-obj -o cmd -f shutdown ;;
"Reiniciar") systemctl reboot ;;
"Desligar") systemctl poweroff ;;
*) exit 1 ;;
esac
