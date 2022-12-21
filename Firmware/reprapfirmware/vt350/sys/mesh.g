; /sys/mesh.g  v1.3
; Called as response to G29
; Used to probe a new bed mesh

; ====================
; Prepare to probe
; ====================

; Level the bed
set global.bed_leveled = false                                                 ; Set leveled state to false to make it re-level before mesh probing.
M98 P"/sys/lib/print/print_level_bed.g"                                        ; Level the bed if it's not allready done

;LED status
set global.sb_leds = "meshing"

; Lower currents, speed & accel
M98 P"/sys/lib/current/xy_current_low.g"                                       ; Set low XY currents
M98 P"/sys/lib/current/z_current_low.g"                                        ; Set low Z currents
M98 P"/sys/lib/speed/speed_probing.g"                                          ; Set low speed & accel

; Get the reference Z offset
M98 P"/sys/lib/goto/bed_center.g"                                              ; Move to bed center
G30 K0 S-3                                                                     ; Probe the bed and set the Z probe trigger height to the height it stopped at
G91                                                                            ; Relative positioning
G1 Z2 F1500                                                                    ; Lower bed 2mm relative to when the probe just triggered
G90                                                                            ; Absolute positioning
M400                                                                           ; Wait for moves to finish

; ====================
; Probing code
; ====================

; Probe a new bed mesh!
M291 R"Mesh Probing" P"Probing now! Please wait..." T10                        ; Probing new mesh bed message

; Probe the new default mesh
G29 S0                                                                         ; Probe the bed, save height map to heightmap.csv and enable compensation
G29 S3 P"default_heightmap.csv"                                                ; Save the current height map to file "full_heightmap.csv"
G29 S1 P"default_heightmap.csv"                                                ; Load height map file "full_heightmap.csv" and enable mesh bed compensation
M400                                                                           ; Wait for moves to finish

; ====================
; Finish up
; ====================

; Full currents, speed & accel
M98 P"/sys/lib/current/z_current_high.g"                                       ; Restore normal Z currents
M98 P"/sys/lib/current/xy_current_high.g"                                      ; Set high XY currents
M98 P"/sys/lib/speed/speed_printing.g"                                         ; Restore normal speed & accels

; Uncomment the following lines to lower Z(bed) after probing
G90                                                                            ; Absolute positioning
G1 Z{global.TAP_clearance} F2400                                               ; Move to Z global.TAP_clearance

M291 R"Mesh Probing" P"Done" T5                                                ; Mesh probing done

; If using Voron TAP, report that probing is completed
if exists global.TAPPING
  set global.TAPPING = false
  M402 P0                                                                      ; Return the hotend to the temperature it had before probing

;LED status
set global.sb_leds = "ready"