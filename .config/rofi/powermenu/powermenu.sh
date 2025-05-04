#!/usr/bin/env bash
``
dir="$HOME/.config/rofi/powermenu"
theme='powermenu'

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"
host=$HOSTNAME

# Options
shutdown=' Shutdown'
reboot=' Reboot'
lock=' Lock'
sleep=' Sleep'

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -p "$host" \
        -mesg "Uptime: $uptime" \
        -theme "${dir}/${theme}.rasi"
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$lock\n$sleep\n$shutdown\n$reboot" | rofi_cmd
}

# Execute Command
run_cmd() {
    if [[ $1 == '--shutdown' ]]; then
        systemctl poweroff
    elif [[ $1 == '--reboot' ]]; then
        systemctl reboot
    elif [[ $1 == '--sleep' ]]; then
        systemctl suspend
    elif [[ $1 == '--lock' ]]; then
        hyprlock
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
        run_cmd --shutdown
        ;;
    $reboot)
        run_cmd --reboot
        ;;
    $lock)
        run_cmd --lock
        ;;
    $sleep)
        run_cmd --sleep
        ;;
esac