; /sys/homey.g  v2.9
; Called to home the Y axis
; Configured for sensorless homing / stall detection on a Duet 3 Mini 5+ and LDO-42STH48-2504AC steppers on XY

;---/
; -/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
; THIS MACRO ONLY WORKS WITH RRF 3.5.0b1 AND LATER!!
;--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
;-/

; ====================---------------------------------------------------------
; Settings section
; ====================

; Homing type selection
var Sensorless = true                                                          ; If enabled (true) sensorless XY homing will be used
; It's _STRONGLY_ recommended to configure the printer for "standard" endstops and get that working first!
; Once you got it working, enable sensorless and start tuning it(tuning IS expected/needed).
;-

; Nozzle clearance (gets overridden if you have global.Nozzle_CL)
var Clearance = 5                                                              ; The "safe" clearance you want to have between the noszzle and bed before moving the printhead

; ====================
; Endstop settings
; ====================

; Endstop input pins
var Xpin = "io1.in"                                                            ; The input pin your X endstop in connected to
var Ypin = "io2.in"                                                            ; The input pin your Y endstop in connected to

; ====================
; Sensorless settings
; ====================

; XY driver numbers
var X = 0.0                                                                    ; The driver number for your X (B) stepper
var Y = 0.1                                                                    ; The driver number for your Y (A) stepper

; Sensorless homing sensitivity
var Sen = 50                                                                   ; Stall detection sensitivity

; Step Back Distance
var SBD = 2                                                                    ; The distance in mm that the head moves back before homing

; XY Currrent Reduction
var CR = 20                                                                    ; The % of the XY stepper max current you want to be set during homing

; Don't touch anyting beyond this point(unless you know what you're doing)!!
; ====================---------------------------------------------------------
; Prep phase
; ====================

; Nozzle clearance
if exists(global.Nozzle_CL)
  set var.Clearance = {global.Nozzle_CL}

; LED status
if exists(global.sb_leds)
  set global.sb_leds = "homing"

; ====================---------------------------------------------------------
; Lower Z axis
; ====================
if exists(param.Z)                                                             ; param.Z passed means that Z clearance is already dealt with
  ; No need to do anything, the nozzle is already been cleared

elif
  if !move.axes[2].homed                                                       ; If Z isn't homed
    ; Lower Z currents
    if fileexists("/sys/lib/current/z_current_low.g")
      M98 P"/sys/lib/current/z_current_low.g"                                  ; Set low Z currents
    else
      M913 Z60                                                                 ; Set Z motors to n% of their max current

    G91                                                                        ; Relative positioning
    G1 Z{var.Clearance} F9000 H1                                               ; Lower Z(bed) relative to current position
    G90                                                                        ; Absolute positioning

    ; Full Z currents
    if fileexists("/sys/lib/current/z_current_high.g")
      M98 P"/sys/lib/current/z_current_high.g"                                 ; Set high Z currents
    else
      M913 Z100                                                                ; Set Z motors to 100% of their max current

  elif move.axes[2].userPosition < {var.Clearance}                             ; If Z is homed but less than var.Clearance
    ; Lower Z currents
    if fileexists("/sys/lib/current/z_current_low.g")
      M98 P"/sys/lib/current/z_current_low.g"                                  ; Set low Z currents
    else
      M913 Z60                                                                 ; Set Z motors to n% of their max current

    G1 Z{var.Clearance} F9000                                                  ; Move to Z var.Clearance

    ; Full Z currents
    if fileexists("/sys/lib/current/z_current_high.g")
      M98 P"/sys/lib/current/z_current_high.g"                                 ; Set high Z currents
    else
      M913 Z100                                                                ; Set Z motors to 100% of their max current

; ====================---------------------------------------------------------
; Home Y axis
; ====================
if var.Sensorless
  ; Enable stealthChop on XY steppers
  M569 P{var.X} S0 D3 V10                                                      ; Set X axis driver in stealthChop mode
  M569 P{var.Y} S0 D3 V10                                                      ; Set Y axis driver in stealthChop mode

  ; Enable sensorless homing
  M574 X2 Y2 S3                                                                ; Configure sensorless endstop for high end on X & Y with single motor load detection

  if exists(param.C)                                                           ; param.C passed means that the currents are handeled externaly 
    ; No need to do anything, currents have been adjusted already

  elif
    ; Lower XY currents
    if fileexists("/sys/lib/current/xy_current_low.g")
      M98 P"/sys/lib/current/xy_current_low.g" C{var.CR}                       ; Set low XY currents and pass param.C with the values set here
    else
      M913 X{var.CR} Y{var.CR}                                                 ; Set X Y motors to var.CR% of their max current

  ; Stall detection parameters
  M915 X Y S{var.Sen} F0 R0 H200                                               ; Set stall detection sensitivity(-128 to +127), filter mode, action type and minimum motor full steps per second P{var.X}:{var.Y}

  G91                                                                          ; Relative positioning

  ; Unflag stalls
  G1 X-1.0 Y1.0 F300 H2                                                        ; Energise motors and move them 1mm in the -Y direction to ensure they are not stalled

  ; Home Y axis
  G1 Y600 F3000 H1                                                             ; Move Y axis max and stop there
  G1 Y{0 -var.SBD} F2000                                                       ; Move away from axis max
  G1 Y600 F3000 H1                                                             ; Move Y axis max and stop there
  G1 Y{0 -var.SBD} F2000                                                       ; Move away from axis max

  G90                                                                          ; Absolute positioning

  ; Enable spread cycle on XY steppers
  M569 P{var.X} S0 D2                                                          ; Set X axis driver in spread cycle mode
  M569 P{var.Y} S0 D2                                                          ; Set Y axis driver in spread cycle mode
  M400                                                                         ; Wait for moves to finish

elif
  ; Enable endstop homing
  M574 X2 S1 P{var.Xpin}                                                       ; Configure switch-type (e.g. microswitch) endstop for high end on X via pin io1.in
  M574 Y2 S1 P{var.Ypin}                                                       ; Configure switch-type (e.g. microswitch) endstop for high end on Y via pin io2.in

  if exists(param.C)                                                           ; param.C passed means that the currents are handeled externaly 
    ; No need to do anything, currents have been adjusted already
    
  elif
    ; Lower XY currents
    if fileexists("/sys/lib/current/xy_current_low.g")
      M98 P"/sys/lib/current/xy_current_low.g"                                 ; Set low XY currents
    else
      M913 X40 Y40                                                             ; Set X Y motors to 40% of their max current

  ; First pass
  G1 Y600 F2400 H1                                                             ; Move quickly to X axis endstop and stop there (first pass)

  ; Go back a few mm
  G1 Y-5 F9000                                                                 ; Go back a few mm

  ; Second pass
  G1 Y600 F360 H1                                                              ; Move slowly to X axis endstop once more (second pass)

; ====================---------------------------------------------------------
; Finish up
; ====================
if exists(param.A)                                                             ; param.A passed means that this is the first part of a homing sequence, so we don't want to raise the currents
  ; No need to do anything, at this point

elif
  if exists(param.C)                                                           ; param.C passed means that the currents are handeled externaly 
    ; No need to do anything, currents have been adjusted already  

  elif
    ; Full XY currents
    if fileexists("/sys/lib/current/xy_current_high.g")
      M98 P"/sys/lib/current/xy_current_high.g"                                ; Set high XY currents
    else
      M913 X100 Y100                                                           ; Set X Y motors to var.100% of their max current

  ; LED status
  if exists(global.sb_leds)
    set global.sb_leds = "ready"