; /sys/filament-change.g  v2.2
; Called when M600 is sent
; Used to do a filament change while printing

;---/
; -/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
; THIS MACRO ONLY WORKS WITH RRF 3.5.0b1 AND LATER!!
;--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
;-/

; ====================---------------------------------------------------------
; Settings section
; ====================

; Will not be used if you're using a "goto" macro
var x = 40                                                                     ; The X axis location where you want the hotend to "park" while changing filament
var y = 0                                                                      ; The Y axis location where you want the hotend to "park" while changing filament

var spd = 15000                                                                ; The speed of which you want the hotend to move to the "park" location

var lift = 20                                                                  ; The Z clearance you want your nozzle to have from the print while changing filament

var lights = true                                                              ; true / false depending if you have chamber lights or not that you want to turn on
; If you don't have lights you want to turn on don't mess with these
var io = 0                                                                     ; The GPIO port number (set by M950) for the lights you want to turn on
var pwm = 1                                                                    ; The PWM to be set on the GPIO port above, 0=off 1=full power
  
var purge = 60                                                                 ; The amount of filament your hotend need to purge for a clean filament/color change

; Will be swaped out with global.unload_length if you have that defined!
var unload = 12                                                                ; The length of which filament have to be retracted to clear the meltzone
 
; Don't touch anyting beyond this point(unless you know what you're doing)!!
; ====================---------------------------------------------------------


if exists(global.unload_length)
  set var.unload = global.unload_length

var pwm_res = state.gpOut[{var.io}].pwm                                        ; Store the PWM from the PPIO port so that it can be returned after changing filament
if var.lights
  M42 P{var.io} S{var.pwm}                                                     ; Turn on the lights

if fileexists("/sys/lib/beep/l.g")
  M98 P"/sys/lib/beep/l.g"                                                     ; Long beep

M400                                                                           ; Wait for moves to finish
G91                                                                            ; Relative positioning
M83                                                                            ; Extruder relative positioning
G10                                                                            ; Retraction
G1 Z1.00 X20.0 Y20.0 F20000                                                    ; Short quick move to disengage from print
  
G1 Z{var.lift - 1} F800                                                        ; Go to spesified Z clearance

if !fileexists("/sys/lib/goto/front_right.g")
  G90                                                                          ; Absolute positioning
  G1 X{var.x} Y{var.y} F{var.spd}                                              ; Move the nozzle to the location defined in the settings section
if fileexists("/sys/lib/goto/front_right.g")
  M98 P"/sys/lib/goto/front_right.g" {var.spd}                                 ; Move to front right for filament change
  
  
G1 E2 F800                                                                     ; Extrude slightly to help form a nice tip on the filament
G1 E{-(var.unload)} F800                                                       ; Retract filament from the meltzone
M400                                                                           ; Wait for moves to finish

if fileexists("/sys/lib/beep/xl.g")
  M98 P"/sys/lib/beep/xl.g"                                                    ; Extra long beep

M291 S4 R"Manual Filament Change" P"Change & prime filament, then press OK." K{"OK","SKIP",}
; "OK"
if input = 0
  G1 E{var.purge} F200                                                         ; Purge filament
; "SKIP"
if input = 1
  G1 E{var.unload} F800                                                        ; Extrude filament back to the meltzone  

M400                                                                           ; Wait for moves to finish
if var.lights
  M42 P{var.io} S{var.pwm_res}                                                 ; Return lights to previous state

if !exists(global.FilamentCHG)
  global FilamentCHG = true
else
  set global.FilamentCHG = true