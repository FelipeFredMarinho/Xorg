#!/bin/sh
#
# Installs the packages needed to run the bspwm setup in this repo.
#
# Supports:
#   - apt    (Debian/Ubuntu)
#   - pacman (Arch)
#
# ghostty and yazi are installed via Homebrew/linuxbrew instead of the
# distro package manager, since that's how they're managed on this machine
# (apt/pacman lag behind for these).

set -e

APT_PACKAGES="bspwm sxhkd picom dunst feh xautolock rofi maim slop xclip playerctl brightnessctl wireplumber network-manager-gnome gnome-calculator polybar x11-xserver-utils xdotool libinput-tools imagemagick"
PACMAN_PACKAGES="bspwm sxhkd picom dunst feh xautolock rofi maim slop xclip playerctl brightnessctl wireplumber networkmanager network-manager-applet gnome-calculator polybar xorg-xrandr xorg-xset xdotool libinput imagemagick"

if command -v apt-get >/dev/null 2>&1; then
	echo "==> Detected apt (Debian/Ubuntu) - installing bspwm stack"
	sudo apt-get update
	sudo apt-get install -y $APT_PACKAGES
elif command -v pacman >/dev/null 2>&1; then
	echo "==> Detected pacman (Arch) - installing bspwm stack"
	sudo pacman -S --needed $PACMAN_PACKAGES
else
	echo "!! No supported package manager found (apt-get/pacman). Install manually:" >&2
	echo "   $APT_PACKAGES" >&2
	exit 1
fi

# backlight (video) and libinput-gestures/keyboard-backlight (input) sysfs
# nodes are group-gated -- without this, brightness keys fail with
# "Permission denied" and libinput-gestures can't read /dev/input/event*.
# Requires logging out/in (or a reboot) to take effect.
echo "==> Adding $(whoami) to the video and input groups (takes effect after logout/login)"
sudo usermod -aG video,input "$(whoami)"

cat <<'EOF'

==> Not packaged in apt/pacman/brew - install these manually.
    Clone these somewhere OTHER than this repo (e.g. ~/build/) -- cloning
    into ~/.config/Xorg pollutes `git status` here with unrelated source trees:

  betterlockscreen  (lock screen; used by super+l, the suspend bind, and
                     xautolock's locker in bspwmrc - lock/suspend won't
                     work correctly until this is installed)
                     Needs i3lock-color first (plain i3lock from apt/pacman
                     is NOT enough -- betterlockscreen requires the -color
                     fork specifically). Neither of these use a Makefile --
                     use their own installer scripts, not `make install`:
    git clone https://github.com/Raymo111/i3lock-color.git
    cd i3lock-color && ./install-i3lock-color.sh
    git clone https://github.com/pavanjadhaw/betterlockscreen.git
    cd betterlockscreen && sudo ./install.sh system
    betterlockscreen -u /path/to/your/wallpaper   # pre-caches the lock image, do this once

  bluetui           (bluetooth TUI; super+b)
    cargo install bluetui

  wiremix           (audio mixer TUI; super+w)
    cargo install wiremix

  systemctl-tui     (systemctl TUI; super+ctrl+s - verify the exact crate
                     name on crates.io, it may not match this)
    cargo install systemctl-tui

  libinput-gestures (3-finger swipe between desktops; not in apt/pacman)
    git clone https://github.com/bulletmark/libinput-gestures.git
    cd libinput-gestures && sudo make install

EOF

echo "==> Done. Make sure bspwm/, sxhkd/, and polybar/ are symlinked from this repo into ~/.config,"
echo "    and libinput-gestures/config -> ~/.config/libinput-gestures.conf (that one's a file, not a dir)."
