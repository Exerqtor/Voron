; /sys/mesh.g  v2.6
; Called as response to G29 or a_mesh.g
; Used to probe a new bed mesh

;---/
; -/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
; THIS MACRO ONLY WORKS WITH RRF 3.5.0b1 AND LATER!!
;--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
;-/

; ====================---------------------------------------------------------
; Prep phase
; ====================

if !exists(param.A)                                                            ; If this isn't part of a print job with adaptive mesh, tram the bed
  G28                                                                          ; Home all axis

  ; Level the bed
  set global.bed_trammed = false                                               ; Set trammed state to false to make it re-level before mesh probing
  if fileexists("/sys/lib/print/print_tram.g")
    M98 P"/sys/lib/print/print_tram.g"                                         ; Level the bed
  else
    echo "print_tram.g missing, aborting!"
    abort

; LED status
if exists(global.sb_leds)
  set global.sb_leds = "meshing"                                               ; StealthBurner LED status

; Lower currents
if fileexists("/sys/lib/current/xy_current_low.g")
  M98 P"/sys/lib/current/xy_current_low.g" C60                                 ; Set low XY currents
else
  M913 X60 Y60                                                                 ; Set X Y motors to 60% of their max current
if fileexists("/sys/lib/current/z_current_low.g")
  M98 P"/sys/lib/current/z_current_low.g"                                      ; Set low Z currents
else
  M913 Z60                                                                     ; Set Z motors to 60% of their max current
  
M561                                                                           ; Clear any bed transform
M290 R0 S0                                                                     ; Reset baby stepping
M84 E0                                                                         ; Disable extruder stepper
  
; Grab default probing grid
var m557MinX = move.compensation.probeGrid.mins[0]                             ; Grabs your default x min
var m557MaxX = move.compensation.probeGrid.maxs[0]                             ; Grabs your default x max
var m557MinY = move.compensation.probeGrid.mins[1]                             ; Grabs your default y min
var m557MaxY = move.compensation.probeGrid.maxs[1]                             ; Grabs your default y max
; Calculate the default number of probe points
var m577meshX = floor((var.m557MaxX - var.m557MinX) / move.compensation.probeGrid.spacings[0]) + 1))
var m577meshY = floor((var.m557MaxY - var.m557MinY) / move.compensation.probeGrid.spacings[1]) + 1))
var m577points = var.m577meshX * var.m577meshY

; Variable placeholders
var pamMinX = "PLACEHOLDER"                                                    ; min X position of the print area mesh
var pamMaxX = "PLACEHOLDER"                                                    ; max X position of the print area mesh
var pamMinY = "PLACEHOLDER"                                                    ; min Y position of the print area mesh
var pamMaxY = "PLACEHOLDER"                                                    ; max Y position of the print area mesh
var meshX = "PLACEHOLDER"                                                      ; Number of points to probe in the X axis
var meshY = "PLACEHOLDER"                                                      ; Number of points to probe in the Y axis
var points = "PLACEHOLDER"                                                     ; Total number of probe points

if exists(param.A)                                                             ; This is part of a print job with adaptive mesh, bed has allready been trammed
  ; Parse the print area probing grid
  set var.pamMinX = param.A                                                    ; min X position of the print area mesh
  set var.pamMaxX = param.B                                                    ; max X position of the print area mesh
  set var.pamMinY = param.C                                                    ; min Y position of the print area mesh
  set var.pamMaxY = param.D                                                    ; max Y position of the print area mesh  
  ; Parse the print area mesh spacing
  set var.meshX = param.E                                                      ; Number of points to probe in the X axis
  set var.meshY = param.F                                                      ; Number of points to probe in the Y axis
  set var.points= param.E * param.F                                            ; Total number of probe points
    
  ; Grid info
  var msg1 = "PLACHOLDER"
  set var.msg1 = "Default grid: X" ^ var.m557MinX ^ ":" ^ var.m557MaxX ^ ", Y" ^ var.m557MinY ^ ":" ^ var.m557MaxY ^ ", Number of points: X" ^ var.m577meshX ^ " Y" ^ var.m577meshY ^ ", " ^ var.m577points ^ " points" 
  echo {var.msg1}  
  
  var msg2 = "PLACHOLDER"
  set var.msg2 = "Adaptive grid: X" ^ var.pamMinX ^ ":" ^ var.pamMaxX ^ ", Y" ^ var.pamMinY ^ ":" ^ var.pamMaxY ^ ", Number of points: X" ^ var.meshX^ " Y" ^ var.meshY ^ ", " ^ var.points ^ " points" 
  echo {var.msg2}

  ; Set the probing mesh
  M557 X{var.pamMinX, var.pamMaxX} Y{var.pamMinY, var.pamMaxY} P{var.meshX, var.meshY}

  ; Move to the center of the print area
  G0 X{var.pamMinX + ((var.pamMaxX - var.pamMinX)/2) - sensors.probes[0].offsets[0]} Y{var.pamMinY + ((var.pamMaxY - var.pamMinY)/2) - sensors.probes[0].offsets[1]}
else
  ; Move to the center of the bed
  G0 X{var.m557MinX + ((var.m557MaxX - var.m557MinX)/2) - sensors.probes[0].offsets[0]} Y{var.m557MinY + ((var.m557MaxY - var.m557MinY)/2) - sensors.probes[0].offsets[1]}
  
; Get the reference Z offset
G30 K0 S-3                                                                     ; Probe the bed and set the Z probe trigger height to the height it stopped at
G91                                                                            ; Relative positioning
G1 Z2 F1500                                                                    ; Lower bed 2mm relative to when the probe just triggered
G90                                                                            ; Absolute positioning
M400                                                                           ; Wait for moves to finish

; ====================---------------------------------------------------------
; Probing code
; ====================

; Probe a new bed mesh!
M291 R"Mesh Probing" P"Probing now! Please wait..." T10                        ; Probing new mesh bed message

if exists(param.A)
  ; Probe the new adaptive mesh
  G29 S0                                                                       ; Probe the bed, save height map to heightmap.csv and enable compensation
  G29 S3 P"adaptive_heightmap.csv"                                             ; Save the current height map to file "adaptive_heightmap.csv"
  G29 S1 P"adaptive_heightmap.csv"                                             ; Load height map file "adaptive_heightmap.csv" and enable mesh bed compensation
  M400                                                                         ; Wait for moves to finish
else
  ; Probe the new default mesh
  G29 S0                                                                       ; Probe the bed, save height map to heightmap.csv and enable compensation
  G29 S3 P"default_heightmap.csv"                                              ; Save the current height map to file "default_heightmap.csv"
  G29 S1 P"default_heightmap.csv"                                              ; Load height map file "default_heightmap.csv" and enable mesh bed compensation
  M400                                                                         ; Wait for moves to finish

; ====================---------------------------------------------------------
; Finish up
; ====================

if exists(param.A) 
  ;Restore the default probing mesh
  M557 X{var.m557MinX, var.m557MaxX} Y{var.m557MinY, var.m557MaxY} P{var.m577meshX, var.m577meshY}
  
; Full currents
if fileexists("/sys/lib/current/xy_current_high.g")
  M98 P"/sys/lib/current/xy_current_high.g"                                    ; Set high XY currents
else
  M913 X100 Y100                                                               ; Set X Y motors to 100% of their max current
if fileexists("/sys/lib/current/z_current_high.g")
  M98 P"/sys/lib/current/z_current_high.g"                                     ; Set high Z currents
else
  M913 Z100                                                                    ; Set Z motors to 100% of their max current

; Uncomment the following lines to lower Z(bed) after probing
G90                                                                            ; Absolute positioning
G1 Z{global.Nozzle_CL} F2400                                                   ; Move to Z global.Nozzle_CL

; Move back to the first probe point
if exists(param.A)
  G0 X{var.pamMinX} Y{var.pamMinY}
else
  G0 X{var.m557MinX} Y{var.m557MinY}
M400                                                                           ; Wait for moves to finish
  
M291 R"Mesh Probing" P"Done" T4                                                ; Mesh probing done

; If using Voron TAP, report that probing is completed
if exists(global.TAPPING)
  set global.TAPPING = false
  M402 P0                                                                      ; Return the hotend to the temperature it had before probing

; LED status
if exists(global.sb_leds)
  set global.sb_leds = "ready"                                                 ; StealthBurner LED status