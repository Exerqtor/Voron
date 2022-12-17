# CHANGELOG
- 17.12.2022; v1.1 Made a fix for the echo spaming in the initial release.
- 17.12.2022: Initial release.

## RRF 3.4.x TAP Temp control

###### Description:
- This macro is designed to keep the nozzle at or bellow 150°C when probing the bed when using Voron TAP.

###### Instalation and dependencies:
- This assumes that your TAP probe is defined to be K0 / Probe0! If for some reason it's defined to be some other number swap out the "0" at the end of the files according to the probe number you have it configered to be!
- Place the two files in the /sys/ folder on your printer.
- Add `set global.nospam = false` to the end of all your macro's that in some shape way or form probes with K0 (homeall.g, homez.g, bed,g, mesh,g etc...)


###### To-do List
- Find a workaround for the echo spamming if the nozzle is warm
- Iron out bugs (if any).