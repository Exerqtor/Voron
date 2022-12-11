# CHANGELOG
- 11.12.2022: Initial release.

## RRF 3.4.x Nozzle scrub macro

###### Description:
- This macro is designed to clean your nozzle over an nozzle brush and (purge the nozzle if you enable that).
- The startpoint of the brushing is randomized, so if if it starts on the right or left side changes.

###### Instalation and dependencies:
- Create a folder structure like shown here ( sys/lib).
- Place the different files in the coresponding folders.
- Setup the creation of the globals we need to run the macro.
- Setup your slicer to define the coordinate globals as needed.
- Add `M98 P"/sys/lib/nozzle_scrub.g"` at the point of your startup routine where you want the machine to perform the cleaning/purging (last thing before laying the first actual print line). 

At the bottom of your config.g add `M98 P"/sys/lib/init.g"` . 
When that's done make sure you add init.g and globals.g in your /sys/lib/ folder (if you allready have these files make sure to add the lines from this macro setup).
Then move print_purge.g inside the /sys/lib/print/.

When thats done, restart your printer and make sure the globals have been created.
With the globals created, you have to make your macro is configured for your printer. Home your printer and jog the nozzle/printhead around and write down the different coordinates relevant to the script, input them the right places and double check twice/thrise before you run the script first time!

###### Pictures:
![](./pics/.png)

###### To-do List
- Update the Readme with some better instructions and take some pictures.
- Iron out bugs (if any).