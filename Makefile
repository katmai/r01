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

@binaries:
	@echo "$(GREEN)Installing custom binaries...$(RESET)"
	@chmod 755 bin/* && sudo cp bin/* /bin/

# Help
help:
	@echo "$(BLUE)Usage: make [target]$(RESET)"
	@echo "Targets:"
	@echo "  $(GREEN)console$(RESET)             - Brings us to cli by default."
	@echo "  $(GREEN)fixes$(RESET)               - Keyring fixes & others."
	@echo "  $(GREEN)updates$(RESET)             - Run apt updates and cleanups."
	@echo "  $(GREEN)tweaks$(RESET)              - Various comfort tweaks."
	@echo "  $(GREEN)help$(RESET)                - Display this help message, providing information on available targets."





pico:
        @echo "SSH to pico.sh..."
        @ssh pico.sh

tuns:
        @echo "Making tunnel..."
        @ssh -vvv -L 1337:localhost:80 -N pico-ui@pgs.sh

prose:
        @echo "Updating the prose.sh blog..."
        @rsync ~/prose.sh/* prose.sh:/

paste:
        @echo "creating a paste..."
        @rsync $1 pastes.sh:/

update:
        @echo "Updating OpenDevin..."
        @cd ~/${HOMEDIR}/ && git pull &&  make build

reset:
        @echo "Reset the git head"
        @cd ~/${HOMEDIR}/ && git reset --hard HEAD

buildall:
        @echo "Rebuilding all..."
        @ollama create -f Modelfile ${all}

pushall:
        @echo "Pushing all..."
        @ollama push katmai/all

runllama3:
        @echo "Run ollama..."
        @ollama run llama3:latest

runall:
        @echo "Running all..."
        @export OLLAMA_HOST=192.168.0.166 && ollama run ${all}

runclidevin:
        @echo "Running OpenDevin via CLI..."
        @cd ~/${HOMEDIR}/ && poetry run python opendevin/main.py -d ${WORKSPACE} -t ${USER}

runfrontenddevin:
        @echo "Running OpenDevin via Frontend..."
        @cd ~/${HOMEDIR}/ && make run

ssh:
        @echo "ssh-ing into the Devin container..."
        @ssh -v -p 2222 opendevin@localhost

exec:
        @echo "Open bash shell in the OpenDevin container"
        @docker exec -ti opendevin-sandbox-default bash
