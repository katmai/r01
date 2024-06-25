# Makefile for the DevTerm R01 - katmai's cleanup
# Variables
TIMEZONE=Europe/Prague

# First things first. Give us the console, without autologin.
console:
        @echo "Turning off graphical interface. Default to console & no autologin..."
        @mkdir ~/bak
        @sudo mv /etc/systemd/system/getty@tty1.service.d ~/bak/
        @mv ~/.bash_profile ~/bak/

fixes:
        @echo "Fixing the legacy keyring warning..."
        @cp /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d

updates:
        @echo "Running the update..."
        @apt update && apt -y upgrade && apt -y autoremove

tweaks:
        @echo "Enabling SSH..."
        @systemctl enable --now sshd
        @echo "Setting Timezone..."
        @timedatectl set-timezone ${TIMEZONE}




cat /sys/class/power_supply/axp20x-battery/capacity
13
cat /sys/class/power_supply/axp20x-battery/health
Good
cat /sys/class/power_supply/axp20x-battery/status
Charging


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
