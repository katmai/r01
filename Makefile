# Makefile for the DevTerm R01 - katmai's cleanup
# Variables
TIMEZONE=Europe/Prague
# This is for the fan control.
# leaving the default on in the repo, but playing with it locally.
TEMP_HIGH=70000 # 42000
TEMP_LOW=70000 # 37000

# ANSI color codes
GREEN=$(shell tput -Txterm setaf 2)
YELLOW=$(shell tput -Txterm setaf 3)
RED=$(shell tput -Txterm setaf 1)
BLUE=$(shell tput -Txterm setaf 6)
RESET=$(shell tput -Txterm sgr0)

# Just do it all
all: console fixes updates tweaks binaries expand

# First things first. Give us the console, without autologin.
console:
	@echo "$(GREEN)Turning off graphical interface. Default to console & no autologin...$(RESET)"
	@mkdir ~/bak
	@sudo mv -v /etc/systemd/system/getty@tty1.service.d ~/bak/
	@mv -v ~/.bash_profile ~/bak/

fixes:
	@echo "$(GREEN)Fixing the legacy keyring warning...$(RESET)"
	@sudo cp -v /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d

updates:
	@echo "$(GREEN)Running the update...$(RESET)"
	@sudo apt update && sudo  apt -y --force-yes upgrade && sudo apt -y autoremove
	@echo "$(GREEN)Installing a few necessary things...$(RESET)"
	@sudo apt -y install \
	tree devterm-fan-daemon-r01 cloud-guest-utils

tweaks:
	@echo "$(GREEN)Enabling SSH...$(RESET)"
	@sudo systemctl enable ssh
	@echo "$(GREEN)Setting Timezone...$(RESET)"
	@sudo timedatectl set-timezone ${TIMEZONE}
	@echo "$(GREEN)Increasing the font size. Just magical...$(RESET)"
	@sudo sed -i 's@FONTSIZE="8x16"@FONTSIZE="12x24"@' /etc/default/console-setup
	@echo "$(GREEN)No reporting...$(RESET)"
	@sudo systemctl disable whoopsie.service
	@echo "$(GREEN)No unattended upgrades...$(RESET)"
	@sudo systemctl disable unattended-upgrades.service
	@echo "$(GREEN)Turn off printing...$(RESET)"
	@sudo systemctl disable cups.service
	@sudo systemctl disable cups-browsed
	@sudo systemctl disable devterm-printer
	@sudo systemctl disable devterm-socat.service
	@echo "$(GREEN)Turn off audio...$(RESET)"
	@sudo systemctl disable devterm-audio-patch.service
	@echo "$(GREEN)Turn off firewall...$(RESET)"
	@sudo systemctl disable ufw
	@echo "$(GREEN)No snapd...$(RESET)"
	@sudo systemctl disable snapd
	@echo "$(GREEN)No jails...$(RESET)"
	@sudo systemctl disable apparmor
	@echo "$(GREEN)No commercial...$(RESET)"
	@sudo systemctl disable ubuntu-advantage
	@echo "$(GREEN)Disable systemctl user services...$(RESET)"
	@sudo systemctl --global disable pulseaudio.socket
	@sudo systemctl --global disable pulseaudio.service
	@sudo systemctl --global disable pipewire.service
	@sudo systemctl --global disable pipewire-media-session.service
	@echo "$(GREEN)Setting fan control...$(RESET)"
	@sudo sed -i 's@THRESHOLD_HIGH=70000@THRESHOLD_HIGH=${TEMP_HIGH}@' /usr/local/bin/monitor_temp.sh
	@sudo sed -i 's@THRESHOLD_LOW=70000@THRESHOLD_LOW=${TEMP_LOW}@' /usr/local/bin/monitor_temp.sh

## More systemctl
# systemctl --user --reverse list-dependencies pulseaudio
# systemctl --user list-dependencies default.target

binaries:
	@echo "$(GREEN)Installing custom binaries...$(RESET)"
	@chmod 755 bin/* && sudo cp -v bin/* /bin/

revert:
	@echo "$(YELLOW)Reverting all changes...$(RESET)"
	@echo "$(YELLOW)Removing custom binaries...$(RESET)"
	@sudo rm -rfv /bin/r01.*
	@echo "$(YELLOW)Undoing tweaks...$(RESET)"
	@echo "$(YELLOW)Disabling SSH...$(RESET)"
	@sudo systemctl disable ssh
	@echo "$(YELLOW)Restore font...$(RESET)"
	@sudo sed -i 's@FONTSIZE="12x24"@FONTSIZE="8x16"@' /etc/default/console-setup
	@echo "$(YELLOW)Yes reporting...$(RESET)"
	@sudo systemctl enable whoopsie.service
	@echo "$(YELLOW)Yes unattended upgrades...$(RESET)"
	@sudo systemctl enable unattended-upgrades.service
	@echo "$(YELLOW)Turn on printing...$(RESET)"
	@sudo systemctl enable cups.service
	@sudo systemctl enable cups-browsed
	@sudo systemctl enable devterm-printer
	@sudo systemctl enable devterm-socat.service
	@echo "$(YELLOW)Turn on audio...$(RESET)"
	@sudo systemctl enable devterm-audio-patch.service
	@echo "$(YELLOW)Turn on firewall...$(RESET)"
	@sudo systemctl enable ufw
	@echo "$(YELLOW)Yes snapd...$(RESET)"
	@sudo systemctl enable snapd
	@echo "$(YELLOW)Yes jails...$(RESET)"
	@sudo systemctl enable apparmor
	@echo "$(YELLOW)Yes commercial...$(RESET)"
	@sudo systemctl enable ubuntu-advantage
	@echo "$(YELLOW)Enable systemctl user services...$(RESET)"
	@sudo systemctl --global enable pulseaudio.socket
	@sudo systemctl --global enable pulseaudio.service
	@sudo systemctl --global enable pipewire.service
	@sudo systemctl --global enable pipewire-media-session.service
	@sudo mv -v ~/bak/getty@tty1.service.d /etc/systemd/system/
	@mv -v ~/bak/.bash_profile ~/
	@sudo systemctl daemon-reload
	@sudo shutdown -h now

expand:
	@echo "$(BLUE)Expanding SD card...$(RESET)"
	@sudo /bin/r01.expand
fbterm:
	@echo "$(BLUE)Adding the blinking pointer...$(RESET)"	
	@cp -fv fbterm/* ~/
	@echo "$(BLUE)Now login via any of tty 1-6 and you will get it...$(RESET)"	

help:
	@echo "$(BLUE)Usage: make [target]$(RESET)"
	@echo "Targets:"
	@echo "  $(GREEN)console$(RESET)             - Brings us to cli by default."
	@echo "  $(GREEN)fixes$(RESET)               - Keyring fixes & others."
	@echo "  $(GREEN)updates$(RESET)             - Run apt updates and cleanups."
	@echo "  $(GREEN)tweaks$(RESET)              - Various comfort tweaks."
	@echo "  $(GREEN)binaries$(RESET)            - A few grouped useful commands:"
	@echo "                                        r01.battery - a few battery options."
	@echo "                                        r01.systemd - a few common systemd options."
	@echo "                                        r01.temp    - check temperature."
	@echo "  $(GREEN)all$(RESET)                 - Just run everything and let it go."
	@echo "  $(YELLOW)revert$(RESET)             - Revert everything to the original."
	@echo "  $(BLUE)fbterm$(RESET)               - Enable the blinking cursor while logged on tty."
	@echo "  $(BLUE)expand$(RESET)               - Expand the "/" partition to the maximum storage available on the sdcard."
	@echo "  $(GREEN)help$(RESET)                - Display this help message, providing information on available targets."

# Phony targets
.PHONY: all console fixes updates tweaks binaries revert expand fbterm help