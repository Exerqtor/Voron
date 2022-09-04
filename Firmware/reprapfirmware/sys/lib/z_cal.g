; /sys/lib/z_cal.g  (v2.2)
; Called when "M98 P"/sys/lib/z_cal.g"" is sent
; Used to calibrate the Z offsett between the Nozzle and buildplate.

; report whats going on
M291 R"Z Offset Calibration" P"Please wait..." T0                              ; leveling bed message

; ====================
; preparation before probing
; ====================

; the distance from the body of the klicky probe to it's own trigger point
var base_Hot_offset     = global.klicky_offset
var add_Cold_offset     = 0.06

; remember the old offsets
var old_k0_offset       = sensors.probes[0].triggerHeight                      ; old klicky offset
var old_k1_offset       = sensors.probes[1].triggerHeight                      ; old z-pin offset

; reset existing calibration
G31 K0 Z7.50                                                                   ; reset klicky
G31 K1 Z0.00                                                                   ; reset z-pin

; variables for klicky calculation
var temp0               = 0                                                    ; placeholder value
var temp1               = 5                                                    ; placeholder value
var temp2               = 10                                                   ; set value above target value

; variables for z-pin calculation
var temp3               = 0                                                    ; placeholder value
var temp4               = 2.5                                                  ; placeholder value
var temp5               = 5                                                    ; set value above target value

; Make sure all axes are Homed
if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed           ; if axes aren't homed
  G28                                                                          ; home all axes
else
  G28 Z                                                                        ; probe nozzle to make Z is correct anyways

; LED status
set global.sb_leds = "homing"

; Lower currents, speed & accel
M98 P"/sys/lib/current/xy_current_low.g"                                       ; set low XY currents
M98 P"/sys/lib/current/z_current_low.g"                                        ; Set low Z currents
M98 P"/sys/lib/speed/speed_probing.g"                                          ; set low speed & accel

if move.axes[2].userPosition < 20
  G1 Z20 F2400                                                                 ; lower Z

M401 P0                                                                        ; load the klicky probe

; ====================---------------------------------------------------------
; calibrate klicky
; ====================

; position for probing
G1 X{global.z_pin_x - 4} Y{global.z_pin_y - 23.5} F18000                       ; move the klicky body over the Z-pin
G1 Z10 F2400                                                                   ; move probe closer to z-pin

; lower probing speed for accuracy
M558 K1 F100:50                                                                ; lower probing speed

; probe klicky body on Z-pin, minimum 0.004mm accuracy
while var.temp2 >= 0.004
  G30 K1 S-1                                                                   ; probe the klicky body with the Z-pin and report value
  M400                                                                         ; wait for moves to finish

  ; lift from z-pin
  G91                                                                          ; relative pos
  G1 Z2 F500                                                                   ; quickly move up 2mm
  G90                                                                          ; absolute pos
  M400                                                                         ; wait for moves to finish

  ; sace first probe result
  set var.temp0 = sensors.probes[1].lastStopHeight

  ;probe klicky body on Z-pin again
  G30 K1 S-1                                                                   ; probe the klicky body with the Z-pin and report value
  M400                                                                         ; wait for moves to finish

  ; lift from z-pin
  G91                                                                          ; relative pos
  G1 Z2 F500                                                                   ; quickly move up 2mm
  G90                                                                          ; absolute pos
  M400                                                                         ; wait for moves to finish

  ; save second probe result
  set var.temp1 = sensors.probes[1].lastStopHeight

  ;calculate deviation
  set var.temp2 = (var.temp0-var.temp1)

; calculate the new klicky offset
var new_k0_offset       = {((var.temp0 + var.temp1) / 2) + var.base_Hot_offset}

; compensate for cold extruder
if heat.heaters[1].current < 160
  set var.new_k0_offset = {var.new_k0_offset + var.add_Cold_offset}

; enable the new klicky offset
G31 K0 Z{var.new_k0_offset}                                                    ; apply the new Z offsett value

; return standard probing speed
M558 K1 F600:180                                                               ; reset probing speed to normal values

;echo the klicky offset
echo "Old Klicky offset " ^ var.old_k0_offset ^ " New Klicky offset " ^ var.new_k0_offset

; ====================---------------------------------------------------------
; calibrate Z-pin
; ====================

; move bed away from nozzle
G1 Z10 F2400                                                                   ; lower the bed

; position for probing
M98 P"/sys/lib/goto/bed_center.g"                                              ; move to the center of the bed
M400                                                                           ; wait for moves to finish

; lower probing speed for accuracy
M558 K0 F100:50                                                                ; lower probing speed

; probe the bed, minimum 0.004mm accuracy
while var.temp5 >= 0.004
  G30 K0 S-1                                                                   ; probe the klicky body with the Z-pin and report value
  M400                                                                         ; wait for moves to finish

  ; lift from z-pin
  G91                                                                          ; relative pos
  G1 Z2 F500                                                                   ; quickly move up 2mm
  G90                                                                          ; absolute pos
  M400                                                                         ; wait for moves to finish

  ; save first probe result
  set var.temp3 = sensors.probes[0].lastStopHeight

  ;probe klicky body on Z-pin again
  G30 K0 S-1                                                                   ; probe the klicky body with the Z-pin and report value
  M400                                                                         ; wait for moves to finish

  ; lift from z-pin
  G91                                                                          ; relative pos
  G1 Z2 F500                                                                   ; quickly move up 2mm
  G90                                                                          ; absolute pos
  M400                                                                         ; wait for moves to finish

  ; save second probe result
  set var.temp4 = sensors.probes[0].lastStopHeight

  ;calculate deviation
  set var.temp5 = (var.temp3-var.temp4)

; calculate the new z-pin offset
var new_k1_offset       = {var.new_k0_offset - ((var.temp3 + var.temp4) / 2)}

; enable the new z-pin offset
G31 K1 Z{var.new_k1_offset}                                                    ; apply the new Z offsett value

; return standard probing speed
M558 K0 F600:180                                                               ; reset probing speed to normal values

; move bed away from nozzle
G1 Z{global.klicky_clearance} F2400                                            ; lower the bed

;echo the z-pin offset
echo "Old Z-pin offset " ^ var.old_k1_offset ^ " New Z-pin offset " ^ var.new_k1_offset

; ====================---------------------------------------------------------
; finish up
; ====================

; save the new offsets
M500 P10:31                                                                    ; store the new Z offsett values to config-override.g
G4 P250                                                                        ; wait 250 milliseconds

M402 P0                                                                        ; dock the klicky probe

; home z with the new offsets
G28 Z

set global.Z_cal        = true

; report whats going on
M291 R"Z Offset Calibration" P"Done" T5                                        ; bed leveling done message

;LED status
set global.sb_leds = "ready"