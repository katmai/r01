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
	@cp /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d

updates:
	@echo "$(GREEN)Running the update...$(RESET)"
	@apt update && apt -y upgrade && apt -y autoremove

tweaks:
	@echo "$(GREEN)Enabling SSH...$(RESET)"
	@systemctl enable --now sshd
	@echo "$(GREEN)Setting Timezone...$(RESET)"
	@timedatectl set-timezone ${TIMEZONE}
	@echo "$(GREEN)Increasing the font size. Just magical...$(RESET)"
	@sed -i 's@FONTSIZE="8x16"@FONTSIZE="12x24"@' /etc/default/console-setup
	@echo "$(GREEN)No reporting...$(RESET)"
	@systemctl disable whoopsie.service
	@echo "$(GREEN)No unattended upgrades...$(RESET)"
	@systemctl disable unattended-upgrades.service
	@echo "$(GREEN)Turn off printing...$(RESET)"
	@systemctl disable cups.service
	@systemctl disable cups-browsed
	@systemctl disable devterm-printer
	@systemctl disable devterm-socat.service
	@echo "$(GREEN)Turn off audio...$(RESET)"
	@systemctl disable devterm-audio-patch.service
	@echo "$(GREEN)Turn off firewall...$(RESET)"
	@systemctl disable ufw
	@echo "$(GREEN)No snapd...$(RESET)"
	@systemctl disable snapd
	@echo "$(GREEN)No jails...$(RESET)"
	@systemctl disable apparmor
	@echo "$(GREEN)No commercial...$(RESET)"
	@systemctl disable ubuntu-advantage

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