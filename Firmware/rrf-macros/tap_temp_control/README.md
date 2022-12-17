# CHANGELOG
- 17.12.2022: Initial release.

## RRF 3.4.x TAP Temp control

###### Description:
- This macro is designed to keep the nozzle at or bellow 150°C when probing the bed when using Voron TAP.

###### Instalation and dependencies:
- This assumes that your TAP probe is defined to be K0 / Probe0! If for some reason it's defined to be some other number swap out the "0" at the end of the files according to the probe number you have it configered to be!
- Place the two files in the /sys/ folder on your printer.

 The current iteration will echo spam with the hotend temp being to high for each probe unless you comment it out. I will make a workaround for this, but at least it works as intedend when it comes to the probing itself in it's current state.

###### To-do List
- Find a workaround for the echo spamming if the nozzle is warm
- Iron out bugs (if any).