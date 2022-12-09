; /sys/lib/print/print_purge.g  (v1.3)
; Called when "M98 P"/sys/lib/print/print_purge.g" is sent
; Used to purge the nozzle close to the actual print area

;--------------------------------------------------------------------------------------------------------------------------------------

;  Adaptive Purging with VoronDesign Logo for RepRapFirmware 3.4.x

; This macro will parse information from objects in your gcode to define a min and max area, creating a nearby purge with Voron flair!
; For successful purging, you may need to configure:

; Declare global.unload_length, and define what length it's needed to be.
; Declare global.Adpative_Purge,and set it true
; Declared globals for X/Y min/max, and have these to defined in your slicer.

;--------------------------------------------------------------------------------------------------------------------------------------

; ====================---------------------------------------------------------
; Variable declarations & defaults
; ====================

; To enable adaptive purging "global.Adaptive_Purging" must be declared and true.

var z_height              = 0.4                            ; Height above the bed to purge
var prime_dist            = {global.unload_length + 1}     ; Distance between filament tip and nozzle tip before purge (this might require some tuning)
var purge_amount          = 20                             ; Amount of filament to purge
var flow_rate             = 10                             ; Desired flow rate in mm3/s
var x_default             = 10                             ; X location to purge, overwritten if adaptive is True
var y_default             = 10                             ; Y location to purge, overwritten if adaptive is True
var size                  = 10                             ; Size of the logo in mm
var distance_to_object_x  = 15                             ; Distance in x to the print area
var distance_to_object_y  = 0                              ; Distance in y to the print area
var travel_speed          = 300                            ; Travel speed

; Placeholders:
var x_origin = "N/A"
var y_origin = "N/A"
var consoleMessage = "N/A"

; ====================---------------------------------------------------------
; Purge location calculation
; ====================

if global.Adaptive_Purge
  if global.paMinX = "N/A"
    set var.x_origin = var.x_default
    set var.y_origin = var.y_default
  else
    set var.x_origin = {global.paMinX - var.distance_to_object_x - var.size}
    set var.y_origin = {global.paMinY - var.distance_to_object_y - var.size}
else
  set var.x_origin = var.x_default
  set var.y_origin = var.y_default

var prepurge_speed = (var.flow_rate / 2.405)
var purge_move_speed = {2.31 * var.size * var.flow_rate / (var.purge_amount * 2.405)}

; Info messages
set var.consoleMessage = "X: " ^ var.x_origin ^ "; Y: " ^ var.y_origin ^ "; Purge move speed: " ^ var.purge_move_speed ^ "; Prepurge speed: " ^ var.prepurge_speed  ; Set the console message

M118 P2 S{var.consoleMessage}  ; send used probe grid to paneldue
M118 P3 S{var.consoleMessage}  ; send used probe grid to DWC console

; ====================---------------------------------------------------------
; Purging code
; ====================

; LED status
set global.sb_leds = "pink"

G92 E0
G0 F{var.travel_speed * 60}                                                                                            ; Set travel speed
G90                                                                                                                    ; Absolute positioning
G0 X{var.x_origin} Y{var.y_origin + var.size / 2}                                                                      ; Move to purge position
G0 Z{var.z_height}                                                                                                     ; Move to purge Z height
M83                                                                                                                    ; Relative extrusion mode
G1 E{var.prime_dist} F{var.prepurge_speed * 60}                                                                        ; Move tip of filament to nozzle
G1 X{var.x_origin + var.size * 0.289} Y{var.y_origin + var.size} E{var.purge_amount / 4} F{var.purge_move_speed * 60}  ; Purge first line of logo
G1 E-.5 F2100                                                                                                          ; Retract
G0 Z{var.z_height * 2}                                                                                                 ; Z hop
G0 X{var.x_origin + var.size * 0.789} Y{var.y_origin + var.size}                                                       ; Move to second purge line origin
G0 Z{var.z_height}                                                                                                     ; Move to purge Z height
G1 E.5 F2100                                                                                                           ; Recover
G1 X{var.x_origin + var.size * 0.211} Y{var.y_origin} E{var.purge_amount / 2} F{var.purge_move_speed * 60}             ; Purge second line of logo
G1 E-.5 F2100                                                                                                          ; Retract
G0 Z{var.z_height * 2}                                                                                                 ; Z hop
G0 X{var.x_origin + var.size * 0.711} Y{var.y_origin}                                                                  ; Move to third purge line origin
G0 Z{var.z_height}                                                                                                     ; Move to purge Z height
G1 E.5 F2100                                                                                                           ; Recover
G1 X{var.x_origin + var.size} Y{var.y_origin + var.size / 2}  E{var.purge_amount / 4} F{var.purge_move_speed * 60}     ; Purge third line of logo
G1 E-.5 F2100                                                                                                          ; Retract
G92 E0                                                                                                                 ; Reset extruder distance
G0 Z{var.z_height * 2}                                                                                                 ; Z hop

; LED status
set global.sb_leds = "ready"