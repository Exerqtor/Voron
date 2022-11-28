# UPDATE
- 28.11.2022: Initial release.

## RRF 3.4.x Adaptive Purge macro
##### Credits:
- kyleisah here on gitub for the ["Klipper Adaptive Meshing and Purging,"](https://github.com/kyleisah/Klipper-Adaptive-Meshing-Purging) that i've based this on.

###### Description:
- Rather than having a static purge line (or what ever), this macro makes a littel Voron logo right beside the actual print. 
- Enabling / disabling of the macro is done with global.Adaptive_Purge. true = enabled, false = disabled. When disabled the logo get's purged the same place each time (X/Y by default).

###### Instalation and dependencies:
- Create a folder structure like shown here ( sys/lib/print).
- Place the different files in the coresponding folders.
- Setup the creation of the globals we need to run the macro.
- Setup your slicer to define the coordinate globals as needed.
- Add `M98 P"/sys/lib/print/print_probe.g"` at the point of your startup routine where you want the machine to perform the purge (last thing before laying the first actual print line). 

At the bottom of your config.g add `M98 P"/sys/lib/init.g"` . 
When that's done make sure you add init.g and globals.g in your /sys/lib/ folder (if you allready have these files make sure to add the lines from this macro setup).
Then move place print_purge.g inside the /sys/lib/print/.

When thats done, restart your printer and make sure the globals have been created.
With the globals created, you have to make your slicer (only going to explain for SuperSlicer/PrusaSlicer as of now) and add the following to the very start of your start g-code section:
; Define print area
set global.pamMinX = {first_layer_print_min[0]}
set global.pamMaxX = {first_layer_print_max[0]}
set global.pamMinY = {first_layer_print_min[1]}
set global.pamMaxY = {first_layer_print_max[1]}

###### Pictures:
![](./pics/1.png)

###### To-do List
- Update the Readme with some better instructions and take some pictures.
- Iron out bugs (if any).

