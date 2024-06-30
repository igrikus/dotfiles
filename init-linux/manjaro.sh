## Changing default shell
chsh "$USER" -s /bin/bash
/bin/bash

## Enable AUR and Flatpak support in Pamac
sudo sed -Ei '/EnableAUR/s/^#//' /etc/pamac.conf
sudo sed -Ei '/CheckAURUpdates/s/^#//' /etc/pamac.conf
sudo sed -Ei '/EnableFlatpak/s/^#//' /etc/pamac.conf
sudo sed -Ei '/CheckFlatpakUpdates/s/^#//' /etc/pamac.conf

## Shortcuts
## To enable traces: dconf watch /

## Copy/paste familiar shortcuts for the Terminal
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ copy '<Primary>c'
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ paste '<Primary>v'

## Switch layout Windows-style shortcuts
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Shift>Alt_L']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Alt>Shift_L']"

## Open Files and Settings Windows-style shortcuts
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Super>i']"

## Add Russian layout
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ru')]"

## Alt-tab windows instead of applications
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"

## QoL time improvements
gsettings set org.gnome.system.location enabled true
gsettings set org.gnome.desktop.datetime automatic-timezone true
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.interface clock-format "24h"

## Wayland fractional scaling. Works bad right now, so it's disabled
# gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

## QoL for text selection on touchpad. Disabled cuz it's causing delays in copy text
# gsettings set org.gnome.desktop.peripherals.touchpad tap-and-drag-lock true

## Power button power off instead of suspend
gsettings set org.gnome.settings-daemon.plugins.power power-button-action "interactive"

## Show battery percentage at the top bar
gsettings set org.gnome.desktop.interface show-battery-percentage true

## Do not suspend on idle
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
gsettings set org.gnome.desktop.session idle-delay 0

## Just not for me
gsettings set org.gnome.desktop.interface enable-hot-corners false

## Ignore duplicates in bash history
echo "export HISTCONTROL=ignoreboth:erasedups" >>~/.bashrc
## Useful alias
echo "alias ll='ls -lah'" >>~/.bashrc

## Tailscale VPN requirements. Optional
sudo systemctl enable --now systemd-resolved.service
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

## Installing Chrome browser
sudo pamac remove firefox --no-confirm
sudo pamac install google-chrome --no-confirm
## Enabling Chrome touchpad back/forward gestures
sudo sed -i 's@Exec=/usr/bin/google-chrome-stable %U@Exec=/usr/bin/google-chrome-stable %U --enable-features=TouchpadOverscrollHistoryNavigation@g' /usr/share/applications/google-chrome.desktop

## Installing slack
sudo pamac install patch --no-confirm
sudo pamac install slack-desktop --no-confirm
## Enable Slack Wayland screen sharing
sudo sed -i'.backup' -e 's/,"WebRTCPipeWireCapturer"/,"LebRTCPipeWireCapturer"/' /usr/lib/slack/resources/app.asar

## Dash icon order
gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.manjaro.pamac.manager.desktop']"

## Installing work tools
sudo pamac install \
	bash-completion \
	docker \
	docker-buildx \
	docker-compose \
	manjaro-pipewire \
	terraform \
	packer \
	kubectl \
	helm \
	aws-cli-v2-bin \
	jq \
	fd \
	lazygit \
	ripgrep \
	npm \
	go \
	xclip \
	neovim \
	--no-confirm

git clone git@github.com:igrikus/LazyVim.git ~/.config/nvim

sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service
sudo groupadd docker
sudo usermod -aG docker "$USER"

## Configure extensions
python -m venv venv
source venv/bin/activate
pip install gnome-extensions-cli

## I like dash actually...
gext disable dash-to-dock@micxgx.gmail.com

## Essential multi-clipboard plugin
gext install clipboard-indicator@tudmotu.com

## Windows-style shortcuts
export GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/clipboard-indicator\@tudmotu.com/schemas/
gsettings set org.gnome.shell.extensions.clipboard-indicator move-item-first true
gsettings set org.gnome.shell.keybindings toggle-message-tray "['']"
gsettings set org.gnome.shell.extensions.clipboard-indicator toggle-menu "['<Super>v']"

## Windows-style touchpad gestures plugin
wget -O "$HOME/Downloads/gestures.zip" "https://github.com/sidevesh/gnome-gesture-improvements--transpiled/releases/download/30/gestureImprovements@gestures.zip"
gnome-extensions install -f ~/Downloads/gestures.zip
gext enable gestureImprovements@gestures
rm -f "$HOME/Downloads/gestures.zip"

# Aesthetics matters
gext install blur-my-shell@aunetx
export GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/blur-my-shell\@aunetx/schemas/
gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur false

gext install weatherornot@somepaulo.github.io
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/weatherornot\@somepaulo.github.io/schemas/
gsettings set org.gnome.shell.extensions.weatherornot position 'left'

## Clear venv
deactivate
rm -rf venv
