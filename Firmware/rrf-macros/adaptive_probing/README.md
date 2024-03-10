# CHANGELOG
- 10.03.2024: Added readme.md & description.

## RRF 3.4.x Adaptive Probing macro

###### Description:
- Macro to probe the print area rather than the whole bed

###### Instalation and dependencies:
- I will add to this as soon as i get time!

- Create a folder structure like shown here ( sys/lib/print).
- Place the different files in the coresponding folders.
- Setup the creation of the globals we need to run the macro.
- Setup your slicer to define the coordinate globals as needed.
- Add `M98 P"/sys/lib/print/print_probe.g"` at the point of your startup routine where you want the machine to perform the probing (I do it after the bed has reached it's set temp). 

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

###### To-do List
- Update the readme.md

##### Credits:
- Add credits where due
