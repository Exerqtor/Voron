; /sys/lib/led/sb_leds.g  v5.1
; Called at boot up and by daemon.g (via /sys/lib/led/sb_leds-state)
; Used for setting the leds on the Voron StealthBurner toolhead.

; You will need to configure this macro according to your board(s) and leds.
; See "https://docs.duet3d.com/en/User_manual/Reference/Gcodes#m950-create-heater-fan-spindle-or-gpioservo-pin" for configuration details.

; ====================---------------------------------------------------------
; Neopixel configuration
; ====================
; Define your LED type

var strip_number  = 0
var pin_name      = "led"
var led_type      = 2
var led_count     = 3

;------------------------------------------------------------------------------
; This section is required.  Do Not Delete or mess with it.
;------------------------------------------------------------------------------

if global.sb_leds = "booting"
  M950 E{var.strip_number} C{var.pin_name} T{var.led_type} U{var.led_count}

; ====================---------------------------------------------------------
; Placeholders
; ====================
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

;------------------------------------------------------------------------------
; This section can be played with "as you please"
; ====================
; Avalible statuses to use in macros etc.
; ====================

; The following statuses are available (these go inside of your macros):

; Statuses (sb_leds)
;    pink                                                                      ; This one is only for initial setup
;    off
;    ready
;    busy
;    heating
;    tramming
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

; ====================---------------------------------------------------------
; Status dependant configuration
; ====================

if global.sb_leds = "break-in"
  set global.sb_logo    = "orange"
  set global.sb_nozzle  = "green"

if global.sb_leds = "pink"
  set global.sb_logo    = "pink"
  set global.sb_nozzle  = "pink"

if global.sb_leds = "off"
  set global.sb_logo    = "off"
  set global.sb_nozzle  = "off"

if global.sb_leds = "ready"
  set global.sb_logo    = "dim_gray"
  set global.sb_nozzle  = "dim_red"

if global.sb_leds = "busy"
  set global.sb_logo    = "light_red"
  set global.sb_nozzle  = "bright_white"

if global.sb_leds = "heating"
  set global.sb_logo    = "yellow"
  set global.sb_nozzle  = "yellow"

if global.sb_leds = "tramming"
  set global.sb_logo    = "light_pink"
  set global.sb_nozzle  = "bright_white"

if global.sb_leds = "homing"
  set global.sb_logo    = "teal"
  set global.sb_nozzle  = "bright_white"

if global.sb_leds = "cleaning"
  set global.sb_logo    = "light_blue"
  set global.sb_nozzle  = "bright_white"

if global.sb_leds = "meshing"
  set global.sb_logo    = "green"
  set global.sb_nozzle  = "bright_white"

if global.sb_leds = "calibrating_z"
  set global.sb_logo    = "bright_pink"
  set global.sb_nozzle  = "bright_white"

if global.sb_leds = "printing"
  set global.sb_logo    = "red"
  set global.sb_nozzle  = "bright_white"

if global.sb_leds = "hot"
  set global.sb_logo    = "red"
  set global.sb_nozzle  = "red"

if global.sb_leds = "cold"
  set global.sb_logo    = "light_blue"
  set global.sb_nozzle  = "light_blue"

if global.sb_leds = "l-off"
  set global.sb_logo    = "off" 

if global.sb_leds = "n-on"
  set global.sb_nozzle  = "bright_white"

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

if global.sb_logo = "dim_gray"                                                 ; R3 U3 B3 W3 / Dim gray
  set var.l_r           = 3
  set var.l_u           = 3
  set var.l_b           = 3
  set var.l_w           = 3

if global.sb_logo = "light_red"                                                ; R102 U0 B0 W0 / Light red
  set var.l_r           = 102
  set var.l_u           = 0
  set var.l_b           = 0
  set var.l_w           = 0

if global.sb_logo = "light_blue"                                               ; R0 U51 B128 W0 / Light blue
  set var.l_r           = 0
  set var.l_u           = 51
  set var.l_b           = 128
  set var.l_w           = 0

if global.sb_logo = "bright_pink"                                              ; R204 U0 B89 W0 / Bright pink
  set var.l_r           = 204
  set var.l_u           = 0
  set var.l_b           = 89
  set var.l_w           = 0

if global.sb_logo = "yellow"                                                   ; R77 U46 B0 W0 / Yellow
  set var.l_r           = 77
  set var.l_u           = 46
  set var.l_b           = 0
  set var.l_w           = 0

if global.sb_logo = "teal"                                                     ; R0 U153 B51 W0 / Teal
  set var.l_r           = 0
  set var.l_u           = 153
  set var.l_b           = 51
  set var.l_w           = 0

if global.sb_logo = "light_pink"                                               ; R128 U26 B102 W0 / Light Pink
  set var.l_r           = 128
  set var.l_u           = 26
  set var.l_b           = 102
  set var.l_w           = 0

if global.sb_logo = "green"                                                    ; R51 U255 B0 W0 / Green
  set var.l_r           = 51
  set var.l_u           = 255
  set var.l_b           = 0
  set var.l_w           = 0

if global.sb_logo = "red"                                                      ; R255 U0 B0 W0 / Red
  set var.l_r           = 255
  set var.l_u           = 0
  set var.l_b           = 0
  set var.l_w           = 0

if global.sb_logo = "orange"                                                   ; R255 U165 B0 W0 / Orange
  set var.l_r           = 255
  set var.l_u           = 165
  set var.l_b           = 0
  set var.l_w           = 0

if global.sb_logo = "light_blue"                                               ; R77 U0 B77 W0 / Light blue
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

if global.sb_nozzle = "bright_white"                                           ; R204 U204 B204 W255 / Bright white
  set var.n_r           = 204
  set var.n_u           = 204
  set var.n_b           = 204
  set var.n_w           = 255

if global.sb_nozzle = "dim_red"                                                ; R153 U0 B0 W0 / Red
  set var.n_r           = 153
  set var.n_u           = 0
  set var.n_b           = 0
  set var.n_w           = 0

if global.sb_nozzle = "yellow"                                                 ; R204 U89 B0 W0 / Yellow
  set var.n_r           = 204
  set var.n_u           = 89
  set var.n_b           = 0
  set var.n_w           = 0

if global.sb_nozzle = "red"                                                    ; R255 U0 B0 W0 / Red
  set var.n_r           = 255
  set var.n_u           = 0
  set var.n_b           = 0
  set var.n_w           = 0
  
if global.sb_nozzle = "green"                                                  ; R51 U255 B0 W0 / Green
  set var.n_r           = 51
  set var.n_u           = 255
  set var.n_b           = 0
  set var.n_w           = 0

if global.sb_nozzle = "light_blue"                                             ; R0 U0 B77 W0 / Light blue
  set var.n_r           = 0
  set var.n_u           = 0
  set var.n_b           = 255
  set var.n_w           = 77

;------------------------------------------------------------------------------
; This section is required.  Do Not Delete or mess with it.
; ====================---------------------------------------------------------
; Activate leds according to selected status / mode
; ====================

; Logo LED
M150 E0 R{var.l_r} U{var.l_u} B{var.l_b} W{var.l_w} S1 F1

; Nozzle LEDs
M150 E0 R{var.n_r} U{var.n_u} B{var.n_b} W{var.n_w} S2 F0

; Create/ovewrite sb_leds-state.g with the new status
echo >"/sys/lib/led/sb_leds-state.g" "; /sys/lib/led/sb_leds-state.g  v2.0"                                                ; Create/overwrite file and save line to sb_leds-state
echo >>"/sys/lib/led/sb_leds-state.g" "; Created by sb_leds.g to store the current/active LED colors "                     ; Save line to sb_leds-state
echo >>"/sys/lib/led/sb_leds-state.g" "; Called by daemon.g to check if global.sb_leds status has changed since last run"  ; Save line to sb_leds-state
echo >>"/sys/lib/led/sb_leds-state.g"                                                                                      ; Save line to sb_leds-state
echo >>"/sys/lib/led/sb_leds-state.g" "var sb_leds = "^ """"^{global.sb_leds}^""""                                         ; Save line to sb_leds-state
echo >>"/sys/lib/led/sb_leds-state.g"                                                                                      ; Save line to sb_leds-state
echo >>"/sys/lib/led/sb_leds-state.g" "if var.sb_leds = global.sb_leds"                                                    ; Save line to sb_leds-state
echo >>"/sys/lib/led/sb_leds-state.g" "  ; Same status, do nothing"                                                        ; Save line to sb_leds-state
echo >>"/sys/lib/led/sb_leds-state.g" "else"                                                                               ; Save line to sb_leds-state
echo >>"/sys/lib/led/sb_leds-state.g" "  ; New status, change colors"                                                      ; Save line to sb_leds-state
echo >>"/sys/lib/led/sb_leds-state.g" "  M98 P""/sys/lib/led/sb_leds.g"""                                                  ; Save line to sb_leds-state

if global.sb_leds = "booting"
  set global.sb_leds = "booted"