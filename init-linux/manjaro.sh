# Changing default shell
chsh "$USER" -s /bin/bash
/bin/bash

# Updating all Pamac packages
sudo pamac update && sudo pamac upgrade --no-confirm
reboot

## Shortcuts
## To enable traces: dconf watch /
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ copy '<Primary>c'
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ paste '<Primary>v'

terminal_profile_id=$(gsettings get org.gnome.Terminal.ProfilesList list | tr -d "[]'")
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/"$terminal_profile_id"/ default-size-columns 511
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/"$terminal_profile_id"/ default-size-rows 511

gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Shift>Alt_L']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Alt>Shift_L']"

gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ru')]"

gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Super>i']"

gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"

gsettings set org.gnome.system.location enabled true
gsettings set org.gnome.desktop.datetime automatic-timezone true
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.interface clock-format "24h"
# gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

gsettings set org.gnome.desktop.peripherals.touchpad tap-and-drag-lock true

echo "export HISTCONTROL=ignoreboth:erasedups" >>~/.bashrc

sudo systemctl enable --now systemd-resolved.service
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# Installing good browser
sudo pamac remove firefox --no-confirm
sudo pamac install google-chrome --no-confirm
sudo sed -i 's@Exec=/usr/bin/google-chrome-stable %U@Exec=/usr/bin/google-chrome-stable %U --enable-features=TouchpadOverscrollHistoryNavigation@g' /usr/share/applications/google-chrome.desktop

# Installing slack
sudo pamac install patch --no-confirm
sudo pamac install slack-desktop --no-confirm
sudo sed -i'.backup' -e 's/,"WebRTCPipeWireCapturer"/,"LebRTCPipeWireCapturer"/' /usr/lib/slack/resources/app.asar

# Useful stuff
gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.manjaro.pamac.manager.desktop']"

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

python -m venv venv
source venv/bin/activate
pip install gnome-extensions-cli

gext disable dash-to-dock@micxgx.gmail.com
gext install clipboard-indicator@tudmotu.com

export GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/clipboard-indicator\@tudmotu.com/schemas/
gsettings set org.gnome.shell.extensions.clipboard-indicator move-item-first true
gsettings set org.gnome.shell.extensions.clipboard-indicator toggle-menu "['<Super>v']"

wget -O "$HOME/Downloads/gestures.zip" "https://github.com/sidevesh/gnome-gesture-improvements--transpiled/releases/download/30/gestureImprovements@gestures.zip"
gnome-extensions install -f ~/Downloads/gestures.zip
rm -f "$HOME/Downloads/gestures.zip"
