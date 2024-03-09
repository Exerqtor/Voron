# CHANGELOG
- 09.03.2024: Updated homing files, config.g, init.g, globals.g, fw_retraction.g
- 06.01.2023: Sensorless XY homing option, and added in more of my other macros. It's also some changes done here and there (mostly code cleaning and some RRF 3.5 adaption)
- 19.12.2022: Initial release.

## "Complete" RRF 3.5 setup for a 350mm VT

###### Description:
- This is the setup i'm running on VT.842, i will try to keep it up to date as good as i can. But as allways read through and try to understand what's going on before you deploy ANYTHING.
- The setup allready contains most of my RRF macros, but again check whats going on before you impliment anything.

## VT.842! has the following specs:
- Duet 3 Mini 5+ with Duet 3 Expansion Mini 2+.
- 5" PanelDue v3.
- Duet3D 1LC v1.2 toolboard.
- E3D Revo Micro.
- Bondtech LGX Lite.
- Voron StealthBurner.
- Voron TAP.

###### Instalation and dependencies:
- Read through and understand every file and make the changes needed for your printer (i can't stress this enough).
- Copy everything to your printers SD-card.
### If the top of a macro contains this text, DON'T use it with anything older than what it's stating!
```
 ;---/
; -/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
; THIS MACRO ONLY WORKS WITH RRF 3.5.0b1 AND LATER!!
;--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
;-/
```

###### To-do List
- Keep everything up-to-date.
- Iron out bugs (if any).