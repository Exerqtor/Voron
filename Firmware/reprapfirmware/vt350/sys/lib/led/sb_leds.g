; /sys/lib/led/sb_leds.g  v3.1
; Called by daemon.g
; Used for setting the status leds on the Voron StealthBurner toolhead (or for any neopixel-type leds).

; NOTE THAT THIS IS A WORK IN PROGRESS AND I AM STILL NOT DONE "CONVERTING" IT TO RRF IN THIS VERSION!

; You will need to configure a neopixel (or other addressable led, such as dotstar).
; See "https://docs.duet3d.com/User_manual/Reference/Gcodes#m150-set-led-colours" for configuration details.

; ====================---------------------------------------------------------
; Instructions
; ====================
; How to use all this stuff:

;  1.  Navigate to the /sys/lib/led/ folder on your printer and add this file (sb_leds.g) to the directory.

;        Note: If you haven't got /sys/lib/led/ yet simply make a new folder inside /sys/ with the name
;              "lib" open the newly created "lib" folder and creat yet another folder inside it called 
;              "led" before you do the step above. Why i choose to use /sys/lib/ is explained in my
;              github page: https://github.com/Exerqtor/Voron/tree/main/Firmware/reprapfirmware/sys/lib

;  2.  Define and setup your LEDs by editing the settings below

;        Note: RGB and RGBW are different and must be defined explicitly.  RGB and RGBW are also not able to
;              be mix-and-matched in the same chain. A separate data line would be needed for proper functioning.

;              RGBW LEDs will have a visible yellow-ish phosphor section to the chip.  If your LEDs do not have
;              this yellow portion, you have RGB LEDs.

;  3.  Save your the changes you've done to this file.

;        Note: The RED and BLUE are set to 255 to make it easier for users and supporters to detect
;              misconfigurations or miswiring. The default color format is for Neopixels with a dedicated
;              white LED. On startup, all three SB LEDs should light up a bright pink color.

;              If you get random colors across your LEDs, change the "X" parameter bellow according to
;              the duet docs and save the changes you've made. Once you've found the correct X parameneter
;              all LED's to be a steady bright pink. If your NEOPIXEL's aren't RGBW omit the W for each
;              status farther down.

;              If you get MAGENTA, your  color order is correct. If you get CYAN, you need to use RGBW. If
;              you get YELLOW, you need to use BRGW (note that BRG is only supported in the latest Klipper
;              version).

;  4.  Now go to /sys/ and open "daemon.g" and copy "M98 P"/sys/lib/led/sb_leds.g" ; Run Stealthburner Neopixel macro"
;      to the end of the file and save it.

;        Note: To edit "daemon.g" while running on the machine you have to first rename the file, open it, add the
;              and save the changes needed, close the file and rename it back to "daemon.g".

;              The "daemon.g" that's part of my RRF setup can be used If you haven't got "deamon.g" running 
;              on your printer already. Mine depends on a loop triggered by the variable global.RunDeamon
;              so that you don't have to rename it two times each time you want to stop or edit the file.
;              This on the other hand also means you have to add; global RunDeamon = True to the end of  your config.g.
;              And then add the macro: "Toggle deamon" , or make your own variant if you want to.

;              The "daemon.g" attached here is setup to loop once second. If you're unsure what "daemon.g" is 
;              read up in here: https://docs.duet3d.com/en/User_manual/Tuning/Macros#daemong

;  5.  Now if all the LEDs light up a bright pink color you should be done for the next step which is to add "ready"
;      status to the end of your config.g so that it goes to "ready" on next reboot: global sb_leds = "ready" .

;        Note: If you still haven't got all of the LED's to light up pink by now you have to fix that before you add the 
;              variable declaration mentioned over!

;        Note: If you use the init.g AND globals.g from my RRF setup the variable is already defined there, so you don't 
;              need to put it in your config.g

;  6.  Once you have confirmed that the LEDs are set up correctly, you must now decide where you want these
;      macros called up...which means adding them to your existing gcode macros.  NOTHING will happen unless
;      you add: set global.sb_leds = "?????" to your existing gcode macros

;        Example: Add: set global.sb_leds = "leveling" to the beginning of your QGL gcode macro, and then
;                 add: set global.sb_leds = "ready" to the end of it to set the logo LED and nozzle LEDs back to the `ready` state.

;        Example: add: set global.sb_leds = "cleaning" to the beginning of your nozzle-cleaning macro, and then; set global.sb_leds = "ready"
;                 to the end of it to return the LEDs back to `ready` state.

;        Note: If you use my RRF config these status changes have been added already, you can of course add more if you feel like it.

;  7.  Feel free to change colors of each macro, create new ones if you have a need to.  The macros provided below
;      are just an example of what is possible.

;  8  To wrap it all up you can add the Toggle Nozzle Lights macro if you want to be able to toggle on/off the nozzle lights independant
;     of what the status set them them to be.
; ====================
; End of Instructions
; ====================---------------------------------------------------------


; ====================---------------------------------------------------------
; Neopixel configuration
; ====================
; Define your LED type
if !exists(global.sb_leds)
  M150 X3                            ; set LED type to RGBW NeoPixel

;--------------------------------------------------------------------------------------------------------------------------------------
; This section is required.  Do Not Delete or mess with it.
;--------------------------------------------------------------------------------------------------------------------------------------
; ====================---------------------------------------------------------
; Placeholders
; ====================
if global.sb_leds = "boot"
  M150 X3                            ; set LED type to RGBW NeoPixel

if !exists(global.sb_leds)
  global sb_leds        = "pink"

if !exists(global.sb_logo)
  global sb_logo        = "n/a"

if !exists(global.sb_nozzle)
  global sb_nozzle      = "n/a"

var l_r                 = 0
var l_u                 = 0
var l_b                 = 0
var l_w                 = 0

var n_r                 = 0
var n_u                 = 0
var n_b                 = 0
var n_w                 = 0

;--------------------------------------------------------------------------------------------------------------------------------------
; This section can be played with "as you please"
;--------------------------------------------------------------------------------------------------------------------------------------
; ====================---------------------------------------------------------
; Avalible tatuses to use in macros etc.
; ====================

; The following statuses are available (these go inside of your macros):

; Statuses (sb_leds)
;    pink                                                                      ; This one is only for initial setup
;    off
;    ready
;    busy
;    heating
;    leveling
;    homing
;    cleaning
;    meshing
;    calibrating_z
;    printing
;    hot
;    cold

;Additional macros for basic control:
;   Note: These will "reset" at the next "full" status change!

;   l-off              ; Turns off the logo LED, but keeps the current status of the nozzle LEDs.
;   n-on               ; Turns off the nozzle LEDs, but keeps the current status of the logo LED.
;   n-off              ; Turns on the nozzle LEDs, but keeps the current status of the logo LED.

; User settings for the StealthBurner status leds. You can change the status colors and led
; configurations for the logo and nozzle here.
;variable_colors: 

; ====================---------------------------------------------------------
; Status dependant configuration
; ====================

if global.sb_leds = "pink"
  set global.sb_logo    = "pink"
  set global.sb_nozzle  = "pink"

if global.sb_leds = "off"
  set global.sb_logo    = "off"
  set global.sb_nozzle  = "off"

if global.sb_leds = "ready"
  set global.sb_logo    = "standby"
  set global.sb_nozzle  = "standby"

if global.sb_leds = "busy"
  set global.sb_logo    = "busy"
  set global.sb_nozzle  = "on"

if global.sb_leds = "heating"
  set global.sb_logo    = "heating"
  set global.sb_nozzle  = "heating"

if global.sb_leds = "leveling"
  set global.sb_logo    = "leveling"
  set global.sb_nozzle  = "on"

if global.sb_leds = "homing"
  set global.sb_logo    = "homing"
  set global.sb_nozzle  = "on"

if global.sb_leds = "cleaning"
  set global.sb_logo    = "cleaning"
  set global.sb_nozzle  = "on"

if global.sb_leds = "meshing"
  set global.sb_logo    = "meshing"
  set global.sb_nozzle  = "on"

if global.sb_leds = "calibrating_z"
  set global.sb_logo    = "calibrating_z"
  set global.sb_nozzle  = "on"

if global.sb_leds = "printing"
  set global.sb_logo    = "printing"
  set global.sb_nozzle  = "on"

if global.sb_leds = "hot"
  set global.sb_logo    = "hot"
  set global.sb_nozzle  = "hot"

if global.sb_leds = "cold"
  set global.sb_logo    = "cold"
  set global.sb_nozzle  = "cold"

if global.sb_leds = "l-off"
  set global.sb_logo    = "off" 

if global.sb_leds = "n-on"
  set global.sb_nozzle  = "on"

if global.sb_leds = "n-off"
  set global.sb_nozzle  = "off"

; ====================---------------------------------------------------------
; Color control
; ====================

; User settings for the StealthBurner status leds. You can change the status colors
; for the logo and nozzle here.

; The initial color of all the Neopixels is set to be a bright pink for troubleshooting purposes.
; Otherwise the colors can be changed by adusting the "R,U,B & W" values 
; Each value should be between 0 and 255. R=red, U=Green, B=Blue, W=white
;    Note: The WHITE option is only available on RGBW LEDs.

; R=Red
; U=Green
; B=Blue
; W=White
; P=Brightness

; Colors for the logo LEDs
if global.sb_logo = "pink"                                                     ; R255 U0 B255 W0 / Pink with full brightness
  set var.l_r           = 255                                                  ; Red
  set var.l_u           = 0                                                    ; Green
  set var.l_b           = 255                                                  ; Blue
  set var.l_w           = 0                                                    ; White

if global.sb_logo = "off"                                                      ; R0 U0 B0 W0 / Off
  set var.l_r           = 0
  set var.l_u           = 0
  set var.l_b           = 0
  set var.l_w           = 0

if global.sb_logo = "standby"                                                  ; R3 U3 B3 W3 / Dim gray
  set var.l_r           = 3
  set var.l_u           = 3
  set var.l_b           = 3
  set var.l_w           = 3

if global.sb_logo = "busy"                                                     ; R102 U0 B0 W0 / Light red
  set var.l_r           = 102
  set var.l_u           = 0
  set var.l_b           = 0
  set var.l_w           = 0

if global.sb_logo = "cleaning"                                                 ; R0 U51 B128 W0 / Light blue
  set var.l_r           = 0
  set var.l_u           = 51
  set var.l_b           = 128
  set var.l_w           = 0

if global.sb_logo = "calibrating_z"                                            ; R204 U0 B89 W0 / Strong pink
  set var.l_r           = 204
  set var.l_u           = 0
  set var.l_b           = 89
  set var.l_w           = 0

if global.sb_logo = "heating"                                                  ; R77 U46 B0 W0 / Yellow
  set var.l_r           = 77
  set var.l_u           = 46
  set var.l_b           = 0
  set var.l_w           = 0

if global.sb_logo = "homing"                                                   ; R0 U153 B51 W0 / Teal
  set var.l_r           = 0
  set var.l_u           = 153
  set var.l_b           = 51
  set var.l_w           = 0

if global.sb_logo = "leveling"                                                 ; R128 U26 B102 W0 / Light Pink
  set var.l_r           = 128
  set var.l_u           = 26
  set var.l_b           = 102
  set var.l_w           = 0

if global.sb_logo = "meshing"                                                  ; R51 U255 B0 W0 / Green
  set var.l_r           = 51
  set var.l_u           = 255
  set var.l_b           = 0
  set var.l_w           = 0

if global.sb_logo = "printing"                                                 ; R255 U0 B0 W0 / Red
  set var.l_r           = 255
  set var.l_u           = 0
  set var.l_b           = 0
  set var.l_w           = 0

if global.sb_logo = "hot"                                                      ; R255 U0 B0 W0 / Bright Red
  set var.l_r           = 255
  set var.l_u           = 0
  set var.l_b           = 0
  set var.l_w           = 0

if global.sb_logo = "cold"                                                     ; R77 U0 B77 W0 / Light Pink
  set var.l_r           = 0
  set var.l_u           = 0
  set var.l_b           = 255
  set var.l_w           = 77

; Colors for the nozzle LEDs
if global.sb_nozzle = "pink"                                                   ; R255 U0 B255 W0 / Pink with full brightness
  set var.n_r           = 255
  set var.n_u           = 0
  set var.n_b           = 255
  set var.n_w           = 0

if global.sb_nozzle = "off"                                                    ; R0 U0 B0 W0 / Off
  set var.n_r           = 0
  set var.n_u           = 0
  set var.n_b           = 0
  set var.n_w           = 0

if global.sb_nozzle = "on"                                                     ; R204 U204 B204 W255 / White
  set var.n_r           = 204
  set var.n_u           = 204
  set var.n_b           = 204
  set var.n_w           = 255

if global.sb_nozzle = "standby"                                                ; R153 U0 B0 W0 / Red
  set var.n_r           = 153
  set var.n_u           = 0
  set var.n_b           = 0
  set var.n_w           = 0

if global.sb_nozzle = "heating"                                                ; R204 U89 B0 W0 / Yellow
  set var.n_r           = 204
  set var.n_u           = 89
  set var.n_b           = 0
  set var.n_w           = 0

if global.sb_nozzle = "hot"                                                    ; R255 U0 B0 W0 / Bright Red
  set var.n_r           = 255
  set var.n_u           = 0
  set var.n_b           = 0
  set var.n_w           = 0

if global.sb_nozzle = "cold"                                                   ; R77 U0 B77 W0 / Light Pink
  set var.n_r           = 0
  set var.n_u           = 0
  set var.n_b           = 255
  set var.n_w           = 77

;--------------------------------------------------------------------------------------------------------------------------------------
; This section is required.  Do Not Delete or mess with it.
;--------------------------------------------------------------------------------------------------------------------------------------
; ====================---------------------------------------------------------
; Activate leds according to selected status / mode
; ====================
; Logo LED
M150 R{var.l_r} U{var.l_u} B{var.l_b} W{var.l_w} S1 F1

; Nozzle LEDs
M150 R{var.n_r} U{var.n_u} B{var.n_b} W{var.n_w} S2