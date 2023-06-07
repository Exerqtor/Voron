# CHANGELOG
- 07.06.2023: v5.0 Changed the macro set to accomidate changes made in RRF 3.5b3 onward. This involves that you have to do changes according to your specific printer/setup inside `sb_leds.g` for it to work.
- 04.01.2023: v4.0 
- 04.01.2023: Initial release.

## StealthBurner LED's for RRF 3.5 and newer

###### Description:
- This macro is made to controll the Nanoleds on a stealthburner toolhed for those who run RRF.

###### Instalation and dependencies:
- A better installl guide will come when i got time, if you can't figure it out you just have to wait =P

#### For RRF 3.4.5 and older users:
- Add these lines to `your daemon.g`:
```
;Check sb_leds status
M98 P"/sys/lib/led/sb_leds-state.g"                                            ; Check if global.sb_leds has changed since last run/loop
```
#### For RRF 3.5.0b1+ and newer users:
- Add these lines to `your daemon.g`:
```
;Check sb_leds status
if fileexists("/sys/lib/led/sb_leds-state.g")
  M98 P"/sys/lib/led/sb_leds-state.g"                                          ; Check if global.sb_leds has changed since last run/loop
```

###### To-do List
- Improve readme.md
- Rework the macro so that it only sends a M150 command if thae colors have changed.