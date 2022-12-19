; bed.g
; Called as response to G32
; Used to level the bed

; ====================---------------------------------------------------------
; Question code
; ====================

; Ask to make sure you want to level the bed or not
if global.bed_leveled 
  M291 S3 R"Bed leveling" P"The bed is allready leveled, want to re-level it?"
else
  M291 S3 R"Bed leveling" P"Are you sure you want to level the bed?"

; LED status
set global.sb_leds = "leveling"

; ====================---------------------------------------------------------
; Prepare to probe
; ====================

; Report whats going on
M291 R"Bed leveling" P"Please wait..." T0                                      ; Leveling bed message

M561                                                                           ; Clear any bed transform
M290 R0 S0                                                                     ; Reset baby stepping
M84 E0                                                                         ; Disable extruder stepper

; Lower currents, speed & accel
M98 P"/sys/lib/current/xy_current_low.g"                                       ; Set low XY currents
M98 P"/sys/lib/current/z_current_low.g"                                        ; Set low Z currents
M98 P"/sys/lib/speed/speed_probing.g"                                          ; Set low speed & accel

; Lower Z relative to current position if needed
if !move.axes[2].homed                                                         ; If Z ain't homed
  G1 Z{global.TAP_clearance} F9000 H1                                          ; Lower Z(bed) relative to current position	
elif move.axes[2].userPosition < {global.TAP_clearance}                        ; If Z is homed and less than global.TAP_clearance
  G1 Z{global.TAP_clearance} F9000                                             ; Move to Z global.TAP_clearance

; ====================---------------------------------------------------------
; Home all axes
; ====================

; Make sure all axes are homed, and home Z again anyways
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
; Move to bed center and home Z
M98 P"/sys/lib/goto/bed_center.g"                                              ; Move to bed center
G30 K0 Z-99999                                                                 ; Probe the center of the bed
M400                                                                           ; Wait for moves to finish

; ====================---------------------------------------------------------
; Leveling code
; ====================

; Coarse leveling pass
M558 K0 H10 F300 A1                                                            ; Increase the depth range, gets the bed mostly level immediately
M98 P"/sys/bed_probe_points.g"                                                 ; Probe the bed

; Fine leveling pass
while true
  ; Probe near lead screws -
  M558 K0 H2 F300:180 A3                                                      ; Reduce depth range, probe slower for better repeatability 
  M98 P"/sys/bed_probe_points.g"                                               ; Probe the bed

  ; Check results - exit loop if results are good
  if move.calibration.initial.deviation < 0.02                                 ; If probing result is less than 0.02mm
    break                                                                      ; Stop probing

  ; Check pass limit - abort if pass limit reached
  if iterations = 5                                                            ; If probed more than 5 times
    M291 P"Bed Leveling Aborted!" R"Pass Limit Reached!"                       ; Abort probing, something wrong
    set global.bed_leveled = false                                             ; Set global state
    abort "Bed Leveling Aborted! - Pass Limit Reached!"                        ; Abort probing, something wrong

; ====================---------------------------------------------------------
; Finish up
; ====================

; Uncomment the following lines to lower Z(bed) after probing
G90                                                                            ; Absolute positioning
G1 Z{global.TAP_clearance} F2400                                               ; Move to Z global.TAP_clearance


; Home Z one last time now that the bed is leveled
M98 P"/sys/lib/goto/bed_center.g"                                              ; Move to bed center
M98 P"/sys/lib/speed/speed_probing.g"                                          ; Set low speed & accel
G30 K0 Z-99999                                                                 ; Probe the center of the bed
M400                                                                           ; Wait for moves to finish

set global.bed_leveled = true                                                  ; Set global state

; Full currents, speed & accel
M98 P"/sys/lib/current/z_current_high.g"                                       ; Restore normal Z currents
M98 P"/sys/lib/current/xy_current_high.g"                                      ; Set high XY currents
M98 P"/sys/lib/speed/speed_printing.g"                                         ; Restore normal speed & accels

; Uncomment the following lines to lower Z(bed) after probing
G90                                                                            ; Absolute positioning
G1 Z5 F2400                                                                    ; Move to Z 10

;echo "global.bed_leveled. Value : " , global.bed_leveled
M291 R"Bed leveling" P"Done" T5                                                ; Bed leveling done message

set global.probing = false
M402 P0                                                                        ; Return the hotend to the temperature it had before probing

; LED status
set global.sb_leds = "ready"