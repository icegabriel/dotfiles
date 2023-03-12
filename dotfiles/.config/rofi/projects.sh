#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

dir="$HOME/.config/rofi/configs"
rofi_command="rofi -theme $dir/projects.rasi"

# Error msg
msg() {
	rofi -theme "$HOME/.config/rofi/applets/styles/message.rasi" -e "$1"
}

# Browser
app="flatpak run io.gitlab.librewolf-community"
app_text="librewolf"

# Links
compliance="COMPLIANCE"
auth2="AUTH 2.0"
mip3="MIP 3.0"
dw2="DW 2.0"

# Variable passed to rofi
options="$compliance\n$auth2\n$mip3\n$dw2"

chosen="$(echo -e "$options" | $rofi_command -p "Open In  :  $app_text" -dmenu -selected-row 0)"

case $chosen in
    $compliance)
        $app https://dev.azure.com/iaudit/Compliance/_git/ &
        ;;
    $auth2)
        $app https://dev.azure.com/iaudit/Auth%202.0/_git/ &
        ;;
    $mip3)
        $app https://dev.azure.com/iaudit/MIP%203.0/_git/ &
        ;;
    $dw2)
        $app https://dev.azure.com/iaudit/DW%202.0/_git/ &
        ;;
esac

