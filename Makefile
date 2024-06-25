# Makefile for the DevTerm R01 - katmai's cleanup
# Variables
TIMEZONE=Europe/Prague

# ANSI color codes
GREEN=$(shell tput -Txterm setaf 2)
YELLOW=$(shell tput -Txterm setaf 3)
RED=$(shell tput -Txterm setaf 1)
BLUE=$(shell tput -Txterm setaf 6)
RESET=$(shell tput -Txterm sgr0)

# First things first. Give us the console, without autologin.
console:
	@echo "$(GREEN)Turning off graphical interface. Default to console & no autologin...$(RESET)"
	@mkdir ~/bak
	@sudo mv /etc/systemd/system/getty@tty1.service.d ~/bak/
	@mv ~/.bash_profile ~/bak/

fixes:
	@echo "$(GREEN)Fixing the legacy keyring warning...$(RESET)"
	@sudo cp /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d

updates:
	@echo "$(GREEN)Running the update...$(RESET)"
	@sudo apt update &&sudo  apt -y upgrade &&sudo apt -y autoremove

tweaks:
	@echo "$(GREEN)Enabling SSH...$(RESET)"
	@sudo systemctl enable --now sshd
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
	@echo "$(GREEN)Disable user services...$(RESET)"
	@systemctl --user disable pulseaudio.service
	@systemctl --user disable pipewire.service
	@systemctl --user disable pipewire-media-session.service

binaries:
	@echo "$(GREEN)Installing custom binaries...$(RESET)"
	@chmod 755 bin/* && sudo cp -v bin/* /bin/

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
	@echo "  $(GREEN)help$(RESET)                - Display this help message, providing information on available targets."