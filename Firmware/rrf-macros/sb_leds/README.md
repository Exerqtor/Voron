# CHANGELOG
- 20.01.2024: v5.1 (`sb_leds.g`) Added the "U" parameter for `M950` introduced in RRF 3.5.0-b4 that defines the numbers of LEDs, added in check to only run `M950`   at startup (check out the 
install procedure to make sure you're up to date), renamed the colors to be more logical and added instructions + cleanup to readme.md.
- 07.06.2023: v5.0 Changed the macro set to accomidate changes made in RRF 3.5.0-b3 onward. This involves that you have to do changes according to your specific printer/setup inside `sb_leds.g` for it to work.
- 04.01.2023: v4.0 
- 04.01.2023: Initial release.

## StealthBurner LED's for RRF 3.5 and newer

###### Description:
- This macro is made to controll the Neopixel LEDs on a stealthburner toolhed for those who run RRF.

###### Instalation and dependencies:
- Connect to your printer with DWC.
- Create a new folder in /sys/ on your SD-card called `lib` (if you don't have it allready).
- Create a new file in /sys/lib/ called `inits.g` (if you don't have it allready).
- Open `init.g` and add the follwing lines then save/close the file:
```
M98 P"/sys/lib/globals.g"                                                      ; setup global variables
```
- Create another new file in /sys/lib/ called `globals.g` (if you don't have it allready).
- Open `globals.g` and add the follwing lines then save/close the file:
```
if !exists(global.sb_leds)
  global sb_leds = "booting"
```
- Within /sys/lib/ create yet another folder called `led` (if you don't have it allready).
- Inside /sys/lib/led/ you upload `sb_leds.g`, `sb_leds-state.g` & `sb_leds-restore.g`.
- Now open/edit `sb_leds.g` and follow the instructions inside to configure the macro according to your board and how you want the different states, colors etc. to interact, then sace/close.
- Go back to /sys/ and open `config.g` and the following code at the end of the file:
```
M98 P"/sys/lib/init.g"                                                         ; Iniate external configs
```
Once that's been added save/close & choose "Restart Mainboard" when asked by DWC.
- When the machine reboots go to /sys/ and open `daemon.g` and add the following lines (within the loop if you run a loop), save & close:
```
;Check sb_leds status
var SB_LEDS = true                                                             ; Turn on(true) / off(false) the Stealthburner led "system"
  if var.SB_LEDS
    if fileexists("/sys/lib/led/sb_leds-state.g")
      M98 P"/sys/lib/led/sb_leds-state.g"                                      ; Check if global.sb_leds has changed since last run/loop
```
- Once that's done send `M999` in console to restart the printer once again.
When the printer reboots this time you can do a last check to see that all the needed components are in place by going to the "Object Model"(Browser) Plugin in DWC (might have to be enabled through
Settings->Plugins->Object Model Browser->Start). When you're in "Object Model"(Browser) expand "globals" and look for `sb_leds="booted"`, `sb_logo="n/a"` & `sb_nozzle="n/a"`. 

- If all three globals are there you should be good to go and check that the it's actually working, go to console and type `set global.sb_leds = "ready"`, this should now switch on the leds to what you defined them to be in `sb_leds.g` earlier.

- Assuming you now have both the logo and nozzle LEDs set to the color you choose you can start to adding the "triggers" to your other macros. For instance at the start of your homing macro's put:
```
; LED status
if exists(global.sb_leds)
  set global.sb_leds = "homing"
```
And at the end of the macro put:
```
; LED status
if exists(global.sb_leds)
  set global.sb_leds = "ready"
```
By this point i guess you get the drift on how this is setup to work, so no need to explain anything more.

**If you have issues, please create a thread on the duet forum, tag me and i will get on it as soon as i can!**

###### To-do List
- Improve readme.md, by adding troubleshooting steps.