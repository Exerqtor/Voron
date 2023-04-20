# CHANGELOG
- 06.01.2023: v2.0 - Cleaned up the code, and removed option to turn on/off the adaptive purge function.
- 15.12.2022: v1.4 - Added a `M400  ; Wait for moves to finish` between the purging lines and SB LED status change so that the status don't change before the purge moves are finished.,
- 09.12.2022: v1.3 - Changed the of the globals that define the print area from `pamMinY` to `paMinY` etc. Also added an extra "layer of security" if for some reason the print area haven't been declared and `paMinX`  is still set to "0" it will purge at the default position. 
- 28.11.2022: Initial release.

## RRF 3.4.x Adaptive Purge macro

###### Description:
- Rather than having a static purge line (or what ever), this macro makes a littel Voron logo right beside the actual print. 

###### Instalation and dependencies:
- Create a folder structure like shown here ( sys/lib/print).
- Place the different files in the coresponding folders.
- Setup the creation of the globals we need to run the macro.
- Setup your slicer to define the coordinate globals as needed.
- Add `M98 P"/sys/lib/print/print_probe.g"` at the point of your startup routine where you want the machine to perform the purge (last thing before laying the first actual print line). 

At the bottom of your config.g add `M98 P"/sys/lib/init.g"` . 
When that's done make sure you add init.g and globals.g in your /sys/lib/ folder (if you allready have these files make sure to add the lines from this macro setup).
Then move print_purge.g inside the /sys/lib/print/.

When thats done, restart your printer and make sure the globals have been created.
With the globals created, you have to make your slicer (only going to explain for SuperSlicer/PrusaSlicer as of now) and add the following to the very start of your start g-code section:
```
; Define print area
set global.paMinX = {first_layer_print_min[0]}
set global.paMaxX = {first_layer_print_max[0]}
set global.paMinY = {first_layer_print_min[1]}
set global.paMaxY = {first_layer_print_max[1]}
```

And in the end gcode or your end macro put the following:
```
; Reset print area
set global.paMinX = 0
set global.paMaxX = {global.bed_x}
set global.paMinY = 0
set global.paMaxY = {global.bed_y}
```

###### Pictures:
![](./pics/1.png)

###### To-do List
- Make a simple purge somewhere if the print is to big to fit a logo.
- Iron out bugs (if any).

##### Credits:
- kyleisah for the ["Klipper Adaptive Meshing and Purging,"](https://github.com/kyleisah/Klipper-Adaptive-Meshing-Purging) that I've based this on.
