; M48.g  v2.0
; Called as response to M48 (MUST have RFF version 3.4 or newer!)
; Used to run probe repeatability test

; ====================---------------------------------------------------------
; Settings & variable declarations
; ====================

; Change these to fit your printer
var Samples             = 10  ; (Max 32)                                       ; The number of times to probe the bed during the test (max 32 samples as of RRF 3.4.5!)

var bedX                = 350                                                  ; Input your beds X axis size here (used to calculate bed center)
var bedY                = 350                                                  ; Input your beds Y axis size here (used to calculate bed center)

; Nozzle clearance (gets overridden if you have global.Nozzle_CL)
var Clearance           = 5                                                    ; The "safe" clearance you want to have between the noszzle and bed before moving the printhead

var SPD_CURRENT_CTRL    = true                                                 ; If you use my(or a similar) RRF config you can leave this "true", if not set it to "false"

; Don't touch anyting bellow this point!
; -----------------------------------------------------------------------------

;Calculate bed center
set var.bedX = var.bedX / 2
set var.bedY = var.bedY / 2

if exists(global.Nozzle_CL)
  set var.Clearance = {global.Nozzle_CL}

var Message = "Do you want to run a test with " ^ var.Samples ^ " samples?"

; Ask to make sure you want to level the bed or not
M291 S3 R"Probe repeatability test" P{var.Message}

; ====================---------------------------------------------------------
; Prepare to probe
; ====================

;M118 P2 S"Please wait..."  ; send message to paneldue
;M118 P3 S"Please wait..."  ; send message to DWC console
set var.Message = "Executing " ^ var.Samples ^ " probes. Please wait..."

M291 S1 R"Probe repeatability test" P{var.Message} T0

M561                                                                           ; Clear any bed transform
M290 R0 S0                                                                     ; Reset baby stepping
M84 E0                                                                         ; Disable extruder stepper

if exists(global.sb_leds)
  set global.sb_leds = "homing"

if var.SPD_CURRENT_CTRL
  ; Lower currents, speed & accel
  M98 P"/sys/lib/current/xy_current_low.g"                                       ; Set low XY currents
  M98 P"/sys/lib/current/z_current_low.g"                                        ; Set low Z currents
  M98 P"/sys/lib/speed/speed_probing.g"                                          ; Set low speed & accel

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

; Home X & Y axis if one of them isn't homed allready
if !move.axes[0].homed || !move.axes[1].homed                                  ; If X & Y axes aren't homed

  ; Home X & Y axis
  ; Coarse home X & Y
  G1 X600 Y600 F2400 H1                                                        ; Move quickly to X or Y endstop(first pass)

  ; Coarse home X
  G1 X600 H1                                                                   ; Move quickly to X endstop(first pass)

  ; Coarse home Y
  G1 Y600 H1                                                                   ; Move quickly to Y endstop(first pass)

  ; Move away from the endstops
  G91                                                                          ; Relative positioning
  G1 X-5 Y-5 F9000                                                             ; Go back a few mm
  G90                                                                          ; Absolute positioning

  ; Fine home X
  G1 X600 F360 H1                                                              ; Move slowly to X axis endstop(second pass)

  ; Fine home Y
  G1 Y600 H1                                                                   ; Move slowly to Y axis endstop(second pass)

; Home Z axis
G1 X{var.bedX} Y{var.bedY} F6000                                               ; Move to the center of the bed
G30 K0 Z-99999                                                                 ; Probe the center of the bed
M400                                                                           ; Wait for moves to finish

; ====================---------------------------------------------------------
; Probing code
; ====================

; LED status
if exists(global.sb_leds)
  set global.sb_leds = "leveling"

M558 K0 F180 A1

var loopCounter = 0
while true
  echo "Sample number: " ^ {iterations + 1}
  G30 P{var.loopCounter} K0 Z-9999
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

if var.SPD_CURRENT_CTRL
  ; Full currents, speed & accel
  M98 P"/sys/lib/current/z_current_high.g"                                       ; Restore normal Z currents
  M98 P"/sys/lib/current/xy_current_high.g"                                      ; Set high XY currents
  M98 P"/sys/lib/speed/speed_printing.g"                                         ; Restore normal speed & accels

set var.Message = "" ^ var.Samples ^ " samples complete, see console"

M291 S1 R"Probe repeatability test" P{var.Message} T5                          ; Test done message

; If using Voron TAP, report that probing is completed
if exists(global.TAPPING)
  set global.TAPPING = false
  M402 P0                                                                      ; Return the hotend to the temperature it had before probing

; LED status
if exists(global.sb_leds)
  set global.sb_leds = "ready"