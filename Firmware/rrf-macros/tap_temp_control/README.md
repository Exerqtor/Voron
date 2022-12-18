# CHANGELOG
- 19.12.2022: v2.0 Streamlined the code to make the hotend temperature stable while probing. This calls for redoing all macros related to probing, so read thru the instructions again!
- 17.12.2022: v1.1 Made a fix for the echo spaming in the initial release.
- 17.12.2022: Initial release.

## TAP Temp control for RRF 3.4 and newer

###### Description:
- This macro is designed to keep the nozzle at or bellow 150°C when probing the bed when using Voron TAP.

###### Instalation and dependencies:
- This assumes that your TAP probe is defined to be K0 / Probe0! If for some reason it's defined to be some other number swap out the "0" at the end of the files according to the probe number you have it configered to be!
- Place the two files in the /sys/ folder on your printer.
- Add the following two lines at  the end of all your macro's that in some shape way or form probes with K0 (homeall.g, homez.g, bed,g, mesh,g etc...)
```
set global.probing = false
M402 P0                                 ; Return the hotend to the temperature it had before probing
```

###### To-do List
- Iron out bugs (if any).