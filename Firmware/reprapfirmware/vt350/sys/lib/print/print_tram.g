; /sys/lib/print/print_tram.g  v2.5
; Called by start.g
; Used to tram the bed before a print starts

;echo "print_tram.g start"

;---/
; -/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
; THIS MACRO ONLY WORKS WITH RRF 3.5.0b1 AND LATER!!
;--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
;-/

; ====================---------------------------------------------------------
; Prep phase
; ====================

M561                                                                           ; Clear any bed transform
M290 R0 S0                                                                     ; Reset baby stepping
M84 E0                                                                         ; Disable extruder stepper

; Lower XY currents
if fileexists("/sys/lib/current/xy_current_low.g")
  M98 P"/sys/lib/current/xy_current_low.g"                                     ; Set low XY currents
else
  M913 X40 Y40                                                                 ; Set X Y motors to 40% of their max current
; Lower Z currents
if fileexists("/sys/lib/current/z_current_low.g")
  M98 P"/sys/lib/current/z_current_low.g"                                      ; Set low Z currents
else
  M913 Z60                                                                     ; Set Z motors to 60% of their max current

if move.axes[2].userPosition < {global.Nozzle_CL}                              ; If Z is less than global.Nozzle_CL
  G1 Z{global.Nozzle_CL} F9000                                                 ; Move to Z global.Nozzle_CL

; ====================---------------------------------------------------------
; Check if bed is trammed
; ====================

; If the bed isn't trammed
if !exists(global.bed_trammed)
  set global bed_trammed = false
  
if global.bed_trammed = false
  ; LED status
  if exists(global.sb_leds)
    set global.sb_leds = "tramming"                                            ; StealthBurner LED status

  ; Report whats going on
  M291 R"Bed tramming" P"Please wait..." T10                                   ; Tramming bed message

  ; ====================-------------------------------------------------------
  ; Tramming code
  ; ====================

  ; Lower XY currents
  if fileexists("/sys/lib/current/xy_current_low.g")
    M98 P"/sys/lib/current/xy_current_low.g" C60                               ; Set low XY currents
  else
    M913 X60 Y60                                                               ; Set X Y motors to 60% of their max current
  ; Lower Z currents
  if fileexists("/sys/lib/current/z_current_low.g")
    M98 P"/sys/lib/current/z_current_low.g"                                    ; Set low Z currents
  else
    M913 Z60                                                                   ; Set Z motors to 60% of their max current

  ; Save the default probe settings
  var dH   = sensors.probes[0].diveHeight
  var spd0 = sensors.probes[0].speeds[0]
  var spd1 = sensors.probes[0].speeds[1]
  var maxP = sensors.probes[0].maxProbeCount

  ; Coarse tramming pass  
  M558 K0 H10 F800 A1                                                          ; Increase the depth range & speed, gets the bed mostly trammed immediately
  M98 P"/sys/bed_probe_points.g"                                               ; Probe the bed

  ; Probe the bed
  while true
    ; Probe near lead screws
    M558 K0 H{var.dH} F{var.spd0, var.spd1} A{var.maxP}                        ; Reset default probe settings
    M98 P"/sys/bed_probe_points.g" A                                           ; Probe the bed

    ; Check results - exit loop if results are good
    if move.calibration.initial.deviation < 0.050                              ; If probing result is less than 0.05mm
      set global.bed_trammed = true                                            ; Set global state
      break                                                                    ; Stop probing 

    ; Check pass limit - abort if pass limit reached
    if iterations = 5                                                          ; If probed more than 5 times
      M291 P"Bed tramming aborted" R"Pass Limit Reached"                       ; Abort probing, something wrong
      set global.bed_trammed = false                                           ; Set global state
      abort "Bed tramming aborted - Pass Limit Reached"                        ; Abort probing, something wrong

  ; ====================-------------------------------------------------------
  ; Finish up
  ; ====================

  ; Uncomment the following lines to lower Z(bed) after probing
  G90                                                                          ; Absolute positioning
  G1 Z{global.Nozzle_CL} F2400                                                 ; Move to Z global.Nozzle_CL

  ; Home Z
  ; Move to bed center and home Z
  M98 P"/sys/lib/goto/bed_center.g"                                            ; Move to bed center
  G30 K0 Z-99999                                                               ; Probe the center of the bed
  M400                                                                         ; Wait for moves to finish

  M291 R"Bed tramming" P"Done" T5                                              ; Bed tramming done message

else
  ; ====================
  ; Response if trammed
  ; ====================

  ; Bed already trammed
  M291 S1 R"Bed tramming" P"Bed allready trammed" T4

; Full currents
if fileexists("/sys/lib/current/xy_current_high.g")
  M98 P"/sys/lib/current/xy_current_high.g"                                    ; Set high XY currents
else
  M913 X100 Y100                                                               ; Set X Y motors to var.100% of their max current
if fileexists("/sys/lib/current/z_current_high.g")
  M98 P"/sys/lib/current/z_current_high.g"                                     ; Set high Z currents
else
  M913 Z100                                                                    ; Set Z motors to var.100% of their max current

;   Uncomment the following lines to lower Z(bed) after probing
G90                                                                            ; Absolute positioning
G1 Z{global.Nozzle_CL} F2400                                                   ; Move to Z global.Nozzle_CL

; If using Voron TAP, report that probing is completed
if exists(global.TAPPING)
  set global.TAPPING = false
  M402 P0                                                                      ; Return the hotend to the temperature it had before probing
  
;echo "print_tram.g end"