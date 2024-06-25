# r01
Modifications for the ClockworkPi DevTerm R01

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
7. For reverting all of the changes, run **make revert** and everything will be back as it was.