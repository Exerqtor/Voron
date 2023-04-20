; M48.g  v3.0
; Called as response to M48
; Used to run probe repeatability test

 ;---/
; -/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
; THIS MACRO ONLY WORKS WITH RRF 3.5.0b1 AND LATER!!
;--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
;-/

; ====================---------------------------------------------------------
; Settings section
; ====================

; Bed size
var bedX                = 350                                                  ; Input your beds X axis size here (used to calculate bed center)
var bedY                = 350                                                  ; Input your beds Y axis size here (used to calculate bed center)

; Nozzle clearance (gets overridden if you have global.Nozzle_CL)
var Clearance           = 5                                                    ; The "safe" clearance you want to have between the noszzle and bed before moving the printhead

; Don't touch anyting bellow this point!
; ====================---------------------------------------------------------
; Prep phase
; ====================

;Calculate bed center
set var.bedX = var.bedX / 2
set var.bedY = var.bedY / 2

if exists(global.Nozzle_CL)
  set var.Clearance = {global.Nozzle_CL}

var msg = "How many samples do you want to take? (3-32)"

; Ask to make sure you want to level the bed or not
M291 S6 J1 R"Probe repeatability test" P{var.msg} L3 H32 F10

var Samples = {input}

set var.msg = "Doing " ^ var.Samples ^ " samples. Please wait..."

M291 S1 R"Probe repeatability test" P{var.msg} T5

M561                                                                           ; Clear any bed transform
M290 R0 S0                                                                     ; Reset baby stepping
M84 E0                                                                         ; Disable extruder stepper

if exists(global.sb_leds)
  set global.sb_leds = "homing"

; Lower Z currents
if fileexists("/sys/lib/current/z_current_low.g")
  M98 P"/sys/lib/current/z_current_low.g"                                      ; Set low Z currents
else
  M913 Z60                                                                     ; Set Z motors to 60% of their max current
 
; Lower Z relative to current position if needed
if !move.axes[2].homed                                                         ; If Z ain't homed
  G91                                                                          ; Relative positioning
  G1 Z{var.Clearance} F9000 H1                                                 ; Lower Z(bed) relative to current position	
  G90                                                                          ; Absolute positioning
elif move.axes[2].userPosition < {var.Clearance}                               ; If Z is homed and less than var.Clearance
  G1 Z{var.Clearance} F9000                                                    ; Move to Z var.Clearance

; ====================---------------------------------------------------------
; Home all axes
; ====================

; Make sure all axes are homed, and home Z again anyways
if !move.axes[0].homed || !move.axes[1].homed                                  ; If X & Y axes aren't homed
  ; Home X & Y axis
  M98 P"/sys/homex.g" Z A                                                      ; Home X axis, pass param.Z since we allready lowered Z & A to indicate this is part of a homing sequence
  M98 P"/sys/homey.g" Z C                                                      ; Home Y axis, pass param.Z since we allready lowered Z & C since XY currents/speeds are also ok

; Home Z axis
M98 P"/sys/homez.g" Z A                                                        ; Home Z axis, pass param.Z since we allready lowered Z & A to indicate this is part of a homing sequence

; ====================---------------------------------------------------------
; Probing code
; ====================

; LED status
if exists(global.sb_leds)
  set global.sb_leds = "leveling"

M558 K0 F180 A1

var loopCounter = 0
while true
  G30 P{var.loopCounter} K0 Z-9999
  if iterations >= 1
    echo "Sample number " ^ {iterations} ^ ": " ^ {sensors.probes[0].lastStopHeight - sensors.probes[0].triggerHeight} ^ "mm"
  set var.loopCounter = iterations
  if iterations = var.Samples - 1
    G30 P{var.loopCounter} K0 Z-9999 S-1
    break

M558 K0 F300:180 A3

; ====================---------------------------------------------------------
; Finish up
; ====================

; Uncomment the following lines to lower Z(bed) after probing
G90                                                                            ; Absolute positioning
G1 Z{var.Clearance} F2400                                                      ; Move to Z var.Clearance

; Full currents
if fileexists("/sys/lib/current/xy_current_high.g")
  M98 P"/sys/lib/current/xy_current_high.g"                                    ; Set high XY currents
else
  M913 X100 Y100                                                               ; Set X Y motors to var.100% of their max current
if fileexists("/sys/lib/current/z_current_high.g")
  M98 P"/sys/lib/current/z_current_high.g"                                     ; Set high Z currents
else
  M913 Z100                                                                    ; Set Z motors to var.100% of their max current

set var.msg = "" ^ var.Samples ^ " samples complete, see console"

M291 S1 R"Probe repeatability test" P{var.msg} T5                              ; Test done message

; If using Voron TAP, report that probing is completed
if exists(global.TAPPING)
  set global.TAPPING = false
  M402 P0                                                                      ; Return the hotend to the temperature it had before probing

; LED status
if exists(global.sb_leds)
  set global.sb_leds = "ready"