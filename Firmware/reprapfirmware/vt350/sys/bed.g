; bed.g  v3.2
; Called as response to G32, as part of a full mesh probing (M98 P"bed.g" A) or at the start of a print (M98 P"bed.g" A)
; Used to tram the bed

;---/
; -/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
; THIS MACRO ONLY WORKS WITH RRF 3.5.0-rc1 AND LATER!!
;--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
;-/

; ====================---------------------------------------------------------
; Question code
; ====================

if !exists(global.bed_trammed)
  set global bed_trammed = false

var tram = "PLACEHOLDER"

if exists(param.A)
  if global.bed_trammed = false
    set var.tram = true
  else
    set var.tram = false
    
; Ask to make sure you want to tram the bed or not    
if !exists(param.A)
  if global.bed_trammed
    M291 S4 R"Bed tramming" P"The bed is allready trammed, want to tram it again?" K{"YES","CANCEL",}
  else
    M291 S4 R"Bed tramming" P"Are you sure you want to tram the bed?" K{"YES","CANCEL",}
    
  if input = 0
    set var.tram = true
  elif input = 1 
    set var.tram = false
    
if var.tram = true
  ; ====================---------------------------------------------------------
  ; Prep phase
  ; ====================

  ; Report whats going on
  M291 R"Bed tramming" P"Please wait..." T10                                   ; Tramming bed message

  ; ====================---------------------------------------------------------
  ; Lower Z axis
  ; ====================

  ; Lower Z relative to current position if needed
  if !move.axes[2].homed                                                       ; If Z ain't homed
    G91                                                                        ; Relative positioning
    G1 Z{global.Nozzle_CL} F9000 H1                                            ; Lower Z(bed) relative to current position	
    G90                                                                        ; Absolute positioning

  elif move.axes[2].userPosition < {global.Nozzle_CL}                          ; If Z is homed and less than global.Nozzle_CL
    G1 Z{global.Nozzle_CL} F9000                                               ; Move to Z global.Nozzle_CL

  ; ====================---------------------------------------------------------
  ; Homing check
  ; ====================

  ; Make sure all axes are homed, and home Z again anyways
  if !move.axes[0].homed || !move.axes[1].homed                                ; If X & Y axes aren't homed
    ; Home X & Y axis
    M98 P"/sys/homex.g" Z{true} A{true}                                        ; Home X axis, pass param.Z since we allready lowered Z & A to indicate this is part of a homing sequence
    M98 P"/sys/homey.g" Z{true} C{true}                                                    ; Home Y axis, pass param.Z since we allready lowered Z & C since XY currents/speeds are also ok

  ; ====================
  ; Home Z axis
  ; ====================
  if !exists(param.A)
    M98 P"/sys/homez.g" Z{true} A{true}                                                    ; Home Z axis, pass param.Z since we allready lowered Z & A to indicate this is part of a homing sequence

  ; ====================---------------------------------------------------------
  ; Tramming code
  ; ====================

  M561                                                                         ; Clear any bed transform
  M290 R0 S0                                                                   ; Reset baby stepping
  M84 E0                                                                       ; Disable extruder stepper

  ; Lower XY currents
  if fileexists("/sys/lib/current/xy_current_low.g")
    M98 P"/sys/lib/current/xy_current_low.g" C60                               ; Set low XY currents
  else
    M913 X40 Y40                                                               ; Set X Y motors to 40% of their max current
  ; Lower Z currents
  if fileexists("/sys/lib/current/z_current_low.g")
    M98 P"/sys/lib/current/z_current_low.g" C80                                ; Set low Z currents
  else
    M913 Z80                                                                   ; Set Z motors to 80% of their max current
    
  ; LED status
  if exists(global.sb_leds)
    set global.sb_leds = "tramming"

  ; Save the default probe settings
  var dH   = sensors.probes[0].diveHeights[0]
  var spd0 = sensors.probes[0].speeds[0]
  var spd1 = sensors.probes[0].speeds[1]
  var maxP = sensors.probes[0].maxProbeCount

  ; Coarse tramming pass
  M558 K0 H10 F800 A1                                                          ; Increase the depth range & speed, gets the bed mostly trammed immediately
  M98 P"/sys/bed_probe_points.g"                                               ; Probe the bed

  ; Fine tramming pass
  while true
    ; Probe near lead screws -
    M558 K0 H{var.dH} F{var.spd0, var.spd1} A{var.maxP}                        ; Reset default probe settings
    M98 P"/sys/bed_probe_points.g"                                             ; Probe the bed

    ; Check results - exit loop if results are good
    if move.calibration.initial.deviation < 0.005                              ; If probing result is less than 0.005mm
      set global.bed_trammed = true                                            ; Set global state
      break                                                                    ; Stop probing

    ; Check pass limit - abort if pass limit reached
    if iterations = 5                                                          ; If probed more than 5 times
      M291 P"Bed tramming aborted!" R"Pass Limit Reached!"                     ; Abort probing, something wrong
      set global.bed_trammed = false                                           ; Set global state
      abort "Bed tramming aborted! - Pass Limit Reached!"                      ; Abort probing, something wrong

  ; ====================---------------------------------------------------------
  ; Finish up
  ; ====================

  ; Uncomment the following lines to lower Z(bed) after probing
  G90                                                                          ; Absolute positioning
  G1 Z{global.Nozzle_CL} F2400                                                 ; Move to Z global.Nozzle_CL


  ; Home Z one last time now that the bed is trammed
  ; LED status
  if exists(global.sb_leds)
  set global.sb_leds = "homing"
  
  M98 P"/sys/lib/goto/bed_center.g"                                            ; Move to bed center
  G30 K0 Z-99999                                                               ; Probe the center of the bed
  M400                                                                         ; Wait for moves to finish


  ; Full currents
  if fileexists("/sys/lib/current/xy_current_high.g")
    M98 P"/sys/lib/current/xy_current_high.g"                                  ; Set high XY currents
  else
    M913 X100 Y100                                                             ; Set X Y motors to var.100% of their max current
  if fileexists("/sys/lib/current/z_current_high.g")
    M98 P"/sys/lib/current/z_current_high.g"                                   ; Set high Z currents
  else
    M913 Z100                                                                  ; Set Z motors to var.100% of their max current

  ; Uncomment the following lines to lower Z(bed) after probing
  G90                                                                          ; Absolute positioning
  G1 Z5 F2400                                                                  ; Move to Z 10

  M291 R"Bed tramming" P"Done" T5                                              ; Bed tramming done message

  ; If using Voron TAP, report that probing is completed
  if exists(global.TAPPING)
    set global.TAPPING = false
    M402 P0                                                                    ; Return the hotend to the temperature it had before probing

  ; LED status
  if exists(global.sb_leds)
    set global.sb_leds = "ready"