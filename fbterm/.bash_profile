if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty[1-6] ]] && [[ -z $FBTERM ]]; then
    FBTERM=1 exec fbterm
fi
