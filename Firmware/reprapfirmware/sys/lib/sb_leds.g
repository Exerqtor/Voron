; /sys/lib/sb_leds.g  (v2)
; Called by daemon.g
; Used for setting the status leds on the Voron StealthBurner toolhead (or for any neopixel-type leds).

; NOTE THAT THIS IS A WORK IN PROGRESS AND I AM STILL NOT DONE "CONVERTING" IT TO RRF IN THIS VERSION!

; You will need to configure a neopixel (or other addressable led, such as dotstar).
; See "https://docs.duet3d.com/User_manual/Reference/Gcodes#m150-set-led-colours" for configuration details.

; ====================---------------------------------------------------------
; Instructions
; ====================
; How to use all this stuff:

;  1.  Make a new folder inside /sys/ with the name "lib", then copy this .g file into the "lib" directory.
;      While inside /sys/lib/ copy "init.g" into the directory as well.

;  2.  Define and setup your LEDs by editing the settings below

;        Note: RGB and RGBW are different and must be defined explicitly.  RGB and RGBW are also not able to 
;              be mix-and-matched in the same chain. A separate data line would be needed for proper functioning.

;              RGBW LEDs will have a visible yellow-ish phosphor section to the chip.  If your LEDs do not have
;              this yellow portion, you have RGB LEDs.

;  3.  Save your the changes you've done to this file.

;        Note: We set RED and BLUE to 255 to make it easier for users and supporters to detect 
;              misconfigurations or miswiring. The default color format is for Neopixels with a dedicated 
;              white LED. On startup, all three SB LEDs should light up a bright pink color.

;              If you get random colors across your LEDs, change the "X" parameter bellow according to 
;              the duet docs and save the changes you've made. Once you've found the correct X parameneter 
;              all LED's to be a steady bright pink. If your NEOPIXEL's aren't RGBW omit the W for each 
;              status farther down.

;              If you get MAGENTA, your  color order is correct. If you get CYAN, you need to use RGBW. If
;              you get YELLOW, you need to use BRGW (note that BRG is only supported in the latest Klipper
;              version).

;  4.  Now go to /sys/ and open "daemon.g" and copy "M98 P"/sys/lib/sb_leds.g" ; Run Stealthburner Neopixel macro"
;      to the end of the file and save it.

;        Note: To edit "daemon.g" while running on the machine you have to first rename the file, open it, add the
;              and save the changes needed, close the file and rename it back to "daemon.g".

;              The attached "daemon.g" is intended to be used If you haven't got "deamon.g" setup already.
;              The "daemon.g" attached here is setup to loop once second. If you're unsure what "daemon.g" is 
;              read up in here: https://docs.duet3d.com/en/User_manual/Tuning/Macros#daemong

;  4.  Once you have confirmed that the LEDs are set up correctly, you must now decide where you want these
;      macros called up...which means adding them to your existing gcode macros.  NOTHING will happen unless
;      you add: set global.sb_leds_l = "?????" and/or; set global.sb_leds_n = "?????" to your existing gcode macros

;#       Example: add; set global.sb_leds_l = "leveling" to the beginning of your QGL gcode macro, and then
;#                add; set global.sb_leds_l = "ready"to the end of it to set the logo LED and nozzle LEDs back to the `ready` state.

;#           Example: add STATUS_CLEANING to the beginning of your nozzle-cleaning macro, and then STATUS_READY
;#                    to the end of it to return the LEDs back to `ready` state.

;#     5.  Feel free to change colors of each macro, create new ones if you have a need to.  The macros provided below
;#         are just an example of what is possible.  If you want to try some more complex animations, you will most
;#         likely have to use WLED with Moonraker and a small micro-controller (please see the LED thread for help inside
;#         of the stealthburner_beta channel on Discord).
; ====================
; End of Instructions
; ====================---------------------------------------------------------


; ====================---------------------------------------------------------
; Neopixel configuration
; ====================
; Define your LED type
if !exists(global.sb_leds)
  M150 X3                            ; set LED type to RGBW NeoPixel

; Placeholders, don't touch
if !exists(global.sb_leds)
  global sb_leds        = "none"

if !exists(global.sb_leds_l)
  global sb_leds_l      = "none"

if !exists(global.sb_leds_n)
  global sb_leds_n      = "none"

var logo = "none"
var nozzle = "none"

var l_r                 = 0
var l_u                 = 0
var l_b                 = 0
var l_w                 = 0

var n_r                 = 0
var n_u                 = 0
var n_b                 = 0
var n_w                 = 0

; ====================---------------------------------------------------------
; Status dependant configuration
; ====================

if global.sb_leds_n = "Turned On"
  set global.sb_leds = "n/a"

if global.sb_leds       = "off"
  set global.sb_leds_l  = "off"
  set global.sb_leds_n  = "off"

if global.sb_leds       = "ready"
  set global.sb_leds_l  = "standby"
  set global.sb_leds_n  = "standby"

if global.sb_leds       = "busy"
  set global.sb_leds_l  = "busy"
  set global.sb_leds_n  = "on"

if global.sb_leds       = "heating"
  set global.sb_leds_l  = "heating"
  set global.sb_leds_n  = "heating"

if global.sb_leds       = "leveling"
  set global.sb_leds_l  = "leveling"
  set global.sb_leds_n  = "on"

if global.sb_leds       = "homing"
  set global.sb_leds_l  = "homing"
  set global.sb_leds_n  = "on"

if global.sb_leds       = "cleaning"
  set global.sb_leds_l  = "cleaning"
  set global.sb_leds_n  = "on"

if global.sb_leds       = "meshing"
  set global.sb_leds_l  = "meshing"
  set global.sb_leds_n  = "on"

if global.sb_leds       = "calibrating_z"
  set global.sb_leds_l  = "calibrating_z"
  set global.sb_leds_n  = "on"

if global.sb_leds       = "printing"
  set global.sb_leds_l  = "printing"
  set global.sb_leds_n  = "on"

if global.sb_leds       = "hot"
  set global.sb_leds_l  = "hot"
  set global.sb_leds_n  = "hot"

if global.sb_leds       = "cold"
  set global.sb_leds_l  = "cold"
  set global.sb_leds_n  = "cold"

; ====================---------------------------------------------------------
; Avalible states to use in macros etc
; ====================

; The following statuses are available (these go inside of your macros):

; Statuses (sb_leds)
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

; Logo specific (sb_leds_l)
;    none                            ; This one is only for initial setup and will not intended to be used later on!
;    off
;    standby
;    busy
;    cleaning
;    calibrating_z
;    heating
;    homing
;    leveling
;    meshing
;    printing
;    hot
;    cold

; Nozzle LEDs specific (sb_leds_n)
;    none                            ; This one is only for initial setup and will not intended to be used later on!
;    off
;    on
;    standby
;    heating
;    hot
;    cold

; User settings for the StealthBurner status leds. You can change the status colors and led
; configurations for the logo and nozzle here.
;variable_colors: 

; ====================---------------------------------------------------------
; Color control
; ====================

; The initial color of all the Neopixels is set to be a bright pink for troubleshooting purposes.
; Otherwise the colors can be changed by adusting the "R,U,B & W" values 
; Each value should be between 0 and 255. R=red, U=Green, B=Blue, W=white
;    Note: The WHITE option is only available on RGBW LEDs.

; R=Red
; U=Green
; B=Blue
; W=White
; P=Brightness

; Colors for logo states
if global.sb_leds_l     = "none"                                               ; R255 U0 B255 W0 / Pink with full brightness
  set var.l_r           = 255                                                  ; Red
  set var.l_u           = 0                                                    ; Green
  set var.l_b           = 255                                                  ; Blue
  set var.l_w           = 0                                                    ; White

if global.sb_leds_l     = "off"                                                ; R0 U0 B0 W0 / Off
  set var.l_r           = 0
  set var.l_u           = 0
  set var.l_b           = 0
  set var.l_w           = 0

if global.sb_leds_l     = "standby"                                            ; R3 U3 B3 W3 / Dim gray
  set var.l_r           = 3
  set var.l_u           = 3
  set var.l_b           = 3
  set var.l_w           = 3

if global.sb_leds_l     = "busy"                                               ; R102 U0 B0 W0 / Light red
  set var.l_r           = 102
  set var.l_u           = 0
  set var.l_b           = 0
  set var.l_w           = 0

if global.sb_leds_l     = "cleaning"                                           ; R0 U51 B128 W0 / Light blue
  set var.l_r           = 0
  set var.l_u           = 51
  set var.l_b           = 128
  set var.l_w           = 0

if global.sb_leds_l     = "calibrating_z"                                      ; R204 U0 B89 W0 / Strong pink
  set var.l_r           = 204
  set var.l_u           = 0
  set var.l_b           = 89
  set var.l_w           = 0

if global.sb_leds_l     = "heating"                                            ; R77 U46 B0 W0 / Yellow
  set var.l_r           = 77
  set var.l_u           = 46
  set var.l_b           = 0
  set var.l_w           = 0

if global.sb_leds_l     = "homing"                                             ; R0 U153 B51 W0 / Teal
  set var.l_r           = 0
  set var.l_u           = 153
  set var.l_b           = 51
  set var.l_w           = 0

if global.sb_leds_l     = "leveling"                                           ; R128 U26 B102 W0 / Light Pink
  set var.l_r           = 128
  set var.l_u           = 26
  set var.l_b           = 102
  set var.l_w           = 0

if global.sb_leds_l     = "meshing"                                            ; R51 U255 B0 W0 / Green
  set var.l_r           = 51
  set var.l_u           = 255
  set var.l_b           = 0
  set var.l_w           = 0

if global.sb_leds_l     = "printing"                                           ; R255 U0 B0 W0 / Red
  set var.l_r           = 255
  set var.l_u           = 0
  set var.l_b           = 0
  set var.l_w           = 0
  
if global.sb_leds_l     = "hot"                                                ; R255 U0 B0 W0 / Bright Red
  set var.l_r           = 255
  set var.l_u           = 0
  set var.l_b           = 0
  set var.l_w           = 0

if global.sb_leds_l     = "cold"                                               ; R77 U0 B77 W0 / Light Pink
  set var.l_r           = 77
  set var.l_u           = 0
  set var.l_b           = 77
  set var.l_w           = 0

; Colors for nozzle states
if global.sb_leds_n     = "none"                                               ; R255 U0 B255 W0 / Pink with full brightness
  set var.n_r           = 255
  set var.n_u           = 0
  set var.n_b           = 255
  set var.n_w           = 0

if global.sb_leds_n     = "off"                                                ; R0 U0 B0 W0 / Off
  set var.n_r           = 0
  set var.n_u           = 0
  set var.n_b           = 0
  set var.n_w           = 0

if global.sb_leds_n     = "on"                                                 ; R204 U204 B204 W255 / White
  set var.n_r           = 204
  set var.n_u           = 204
  set var.n_b           = 204
  set var.n_w           = 255

if global.sb_leds_n     = "standby"                                            ; R153 U0 B0 W0 / Red
  set var.n_r           = 153
  set var.n_u           = 0
  set var.n_b           = 0
  set var.n_w           = 0

if global.sb_leds_n     = "heating"                                            ; R204 U89 B0 W0 / Yellow
  set var.n_r           = 204
  set var.n_u           = 89
  set var.n_b           = 0
  set var.n_w           = 0

if global.sb_leds_n     = "hot"                                                ; R255 U0 B0 W0 / Bright Red
  set var.n_r           = 255
  set var.n_u           = 0
  set var.n_b           = 0
  set var.n_w           = 0

if global.sb_leds_n     = "cold"                                               ; R77 U0 B77 W0 / Light Pink
  set var.n_r           = 77
  set var.n_u           = 0
  set var.n_b           = 77
  set var.n_w           = 0

;--------------------------------------------------------------------------------------------------------------------------------------
; This section is required.  Do Not Delete or mess with it.
;--------------------------------------------------------------------------------------------------------------------------------------

; ====================---------------------------------------------------------
; Activate leds according to selected status / mode
; ====================

;if !global.sb_leds_l = "none"
  ; Logo LED
  M150 R{var.l_r} U{var.l_u} B{var.l_b} W{var.l_w} S1 F1

 ; Nozzle LEDs
;if !global.sb_leds_n = "none"
  M150 R{var.n_r} U{var.n_u} B{var.n_b} W{var.n_w} S2
