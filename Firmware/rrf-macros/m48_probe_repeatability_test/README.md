# CHANGELOG
- 19.12.2022: Initial release.

## M48 Probe Repeatability Test RRF 3.4 and newer

###### Description:
- This macro is made to test how accurate your Z probe is, it does "x" amount of probes in the bed center and reports the results in the DWC/PanelDue console.

###### Instalation and dependencies:
- This assumes that your probe Z probe is defined to be K0 / Probe0! If for some reason it's defined to be some other number swap out the "0" at the end of the files according to the probe number you have it configered to be!
- Place the `M48.g` file in the /sys/ folder on your printer.
- Open up `M48.g` with the text editor of your choice and input the number of times you want the test to probe the bed and save the changes.
- Now you should be all sett to run the macro by sending `M48` on either DWC or PanelDue if your using my RRF setup..
# If your running my RRF config or something based on it, you should be good to go at this point. But if you're running some other setup you must fix the following:
- Add `global.TAP_clearance = 0.2` (I've made the macro for my Voron TAP equiped machine, hence the specific naming) to where ever you define your globals.
- Uncomment or remove all the lines under "currents, speed & accel" sections.
- Manually input the follwing command bellow the `M98 P"/sys/lib/goto/bed_center.g"  ; Move to bed center` line, and then uncomment or remove `M98 P"/sys/lib/goto/bed_center.g"  ; Move to bed center`.
```
G1 X"bed center in X axis" Y"bed center in Y axis" F6000  ; Move to the center of the bed (input the coordinates relevant to your printer)
```
- In line 94, check out the "A" values and input your Z probes standard probing speeds there.
- If you're not running my StealthBurner LED light or TAP Temp Control macros you need to uncomment or remove all  instances off `set global.sb_leds`  & `set global.Probing`from within the macro.
When the above changes has been done you should be all good to test out the macro. Keep a finger on the "killswitch" the first time you run it just in case!

###### To-do List
- Make the macro more "universal" so that it need less alteration to fit different printers.
- Iron out bugs (if any).