# r01
Modifications for the ClockworkPi DevTerm R01

# What is this?
You may notice that things here are awfully simple. i've tried to keep everything - if you want to look underneath - 1-2 commands away. For now, they will have to stay simple, until i get the behavior i want.  
Everything today is a wrapper of a wrapper of another wrapper, and when i am trying to figure something out, i have to go through chains of dependencies when most of the times, all that's been abstracted into oblivion is: "cat $file".  

## Instructions:
0. It's preferable that you flash a fresh DevTerm install from: http://dl.clockworkpi.com/DevTerm_R01_v0.2a.img.bz2 . (You can use Balena Etcher to easily write to an SD Card)
1. Once booted, you will first need to get internet connectivity: **Press Ctrl+Alt+n** to to open NetworkManager and connect to your favorite wi-fi.
2. Open up a terminal **Ctrl+Alt+t** and clone the repo: 
```
git clone https://github.com/katmai/r01.git
```
3. **cd r01**
4. Check variables at the top. Edit your timezone.
5. **make help** to see the available options or **make all** if you're comfortable with everything.
6. Once the setup is complete, reboot your DevTerm.
7. **make revert** - Revert the majority to the original. (can't undo apt updates. that would be silly)

## Optional:
- **make expand** - If you have a large sdcard and you'd like to expand the filesystem.
- **make cursor** - Enable cursor visibility (Not 'the one', but it will do the job).
- **make fbterm** - Enable the blinking cursor while logged on tty. (It looks like a duck, quacks like a duck, but it's not a duck)"


## Various utilities
r01.battery - gives a few battery insights.  
r01.temp    - shows the current temperature.  
r01.expand  - expands the "/" partition.  
r01.systemd - a few systemd options i use more frequently to debug.  
r01.undo    - undo fbterm.