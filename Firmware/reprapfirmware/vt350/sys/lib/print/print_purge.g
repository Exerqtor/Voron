; /sys/lib/print/print_purge.g  v2.2
; Called when "M98 P"/sys/lib/print/print_purge.g" is sent
; Used to purge the nozzle before a print

; ====================---------------------------------------------------------
; Settings section
; ====================

var prime_dist            = 10                                                 ; Distance from filament to nozzle before purging, this will require some tuning!
;This will be overwritten if you have global.unload_length defined!

var z_height              = 0.4                                                ; Height above the bed to purge
var purge_amount          = 20                                                 ; Amount of filament to purge
var flow_rate             = 10                                                 ; Desired flow rate in mm3/s
var x_default             = 5                                                  ; X location to purge, overwritten if adaptive is True
var y_default             = 5                                                  ; Y location to purge, overwritten if adaptive is True
var size                  = 10                                                 ; Size of the logo in mm
var distance_to_object_x  = 15                                                 ; Distance in x to the print area
var distance_to_object_y  = 0                                                  ; Distance in y to the print area
var travel_speed          = 300                                                ; Travel speed
var purge_temp_min        = {global.hotend_temp - 5}                           ; Minimum nozzle temperature to permit a purge. Otherwise, print will abort


; Don't touch anyting beyond this point(unless you know what you're doing)!!
; ====================---------------------------------------------------------
; Prep phase
; ====================

; Placeholders
var x_origin = var.x_default
var y_origin = var.y_default
var msg = "N/A"

if exists(global.unload_length)
  set var.prime_dist = {global.unload_length + 1}
if global.paMinX = 0
  set var.x_origin = var.x_default
  set var.y_origin = var.y_default
elif global.paMinX >= 1
  set var.x_origin = {global.paMinX - var.distance_to_object_x - var.size}
  set var.y_origin = {global.paMinY - var.distance_to_object_y - var.size}
  
var prepurge_speed = (var.flow_rate / 2.405)
var purge_move_speed = {2.31 * var.size * var.flow_rate / (var.purge_amount * 2.405)}

if exists(global.hotend_temp)
  set var.purge_temp_min        = {global.hotend_temp - 5}                     ; Minimum nozzle temperature to permit a purge. Otherwise, print will abort

; Generate message
set var.msg = "Purge location, X min: " ^ var.x_origin ^ "; Y min: " ^ var.y_origin ^ "; Purge move speed: " ^ var.purge_move_speed ^ "; Prepurge speed: " ^ var.prepurge_speed

; Info message
M291 P{var.msg} T6

; ====================---------------------------------------------------------
; Purging code
; ====================

; Purge if the temp is up to min temp. If not, it will wait, or if active temp is 0 it will abort
if heat.heaters[1].current < var.purge_temp_min
  ;To cold to purge, wait for temp to raise
  M116 H1                                                                    ; Wait hotend to reach it's temperature
elif heat.heaters[1].current > var.purge_temp_min
  ; Hot enough to purge, proceed to purge

if heat.heaters[1].active = 0
  ; Something wrong, abort print
  echo "Tool 0 active temp set to 0, aborting print!"
  abort

; LED status
if exists(global.sb_leds)
  set global.sb_leds = "cleaning"                                              ; StealthBurner LED status

G92 E0
G0 F{var.travel_speed * 60}                                                    ; Set travel speed
G90                                                                            ; Absolute positioning
G0 X{var.x_origin} Y{var.y_origin + var.size / 2}                              ; Move to purge position
G0 Z{var.z_height}                                                             ; Move to purge Z height
M83                                                                            ; Relative extrusion mode
G1 E{var.prime_dist} F{var.prepurge_speed * 60}                                ; Move tip of filament to nozzle

; Purge first line of logo
G1 X{var.x_origin + var.size * 0.289} Y{var.y_origin + var.size} E{var.purge_amount / 4} F{var.purge_move_speed * 60}
G1 E-.5 F2100                                                                  ; Retract
G0 Z{var.z_height * 2}                                                         ; Z hop
G0 X{var.x_origin + var.size * 0.789} Y{var.y_origin + var.size}               ; Move to second purge line origin
G0 Z{var.z_height}                                                             ; Move to purge Z height
G1 E.5 F2100                                                                   ; Recover

; Purge second line of logo
G1 X{var.x_origin + var.size * 0.211} Y{var.y_origin} E{var.purge_amount / 2} F{var.purge_move_speed * 60}
G1 E-.5 F2100                                                                  ; Retract
G0 Z{var.z_height * 2}                                                         ; Z hop
G0 X{var.x_origin + var.size * 0.711} Y{var.y_origin}                          ; Move to third purge line origin
G0 Z{var.z_height}                                                             ; Move to purge Z height
G1 E.5 F2100                                                                   ; Recover

; Purge third line of logo
G1 X{var.x_origin + var.size} Y{var.y_origin + var.size / 2}  E{var.purge_amount / 4} F{var.purge_move_speed * 60}
;G1 E-.5 F2100                                                                  ; Retract
G92 E0                                                                         ; Reset extruder distance
G0 Z{var.z_height * 2}                                                         ; Z hop
M400                                                                           ; Wait for moves to finish