; nozzle_scrub.g  (v2.2)
; Called when "M98 P"/sys/lib/nozzle_scrub.g"" is sent
; Used to clean and purge (alternatively) the nozzle

;--------------------------------------------------------------------------------------------------------------------------------------

; Sample macro config to be used in conjunction with a Purge Bucket & Nozzle Scrubber combo and RepRapFirmware 3.4.x

; The goal of this macro is to provide a nozzle scrubbing and purging routine that is easily copied/referenced into your  printer.
; Users can simply change parameters and enable/disable options in the first half. Descriptions are plentiful, making this macro
; look huge but informative and are laid out in sequence to be read first describing the line below; PLEASE READ CAREFULLY.

; This sample config assumes the following: The user has implemented a purge bucket & nozzle scrubber to their printer
; It can be tweaked for customized purge bucket geometries and brushes.

; Features in this macro: purge routine that can be enabled/disabled.
; By default, bucket is located at rear right of bed and purge routine is enabled. The purge and scrubbing routine is randomized
; in either left or right bucket to ensure as even as possible distribution of filament gunk.

; Default parameters are set for safe speeds and movements. Where necessary, tweak the parameters for the nozzle scrub procedure
; to fit your printer.

;--------------------------------------------------------------------------------------------------------------------------------------

; If you want the purging routine in your bucket enabled, set to true (and false vice versa).
var enable_purge        = true

; These parameters define your filament purging. The retract variable is used to retract right after purging to prevent unnecessary
; oozing. Some filament are particularly oozy and may continue to ooze out of the nozzle for a second or two after retracting. The
; ooze dwell variable makes allowance for this. Update as necessary. If you decided to not enable purge, you can ignore this section.

var purge_len           = 55         ; Amount of filament, in mm, to purge.
var purge_spd           = 200        ; Speed, in mm/min, of the purge.
var purge_temp_min      = 240        ; Minimum nozzle temperature to permit a purge. Otherwise, purge will not occur.
var purge_ret           = 2          ; Retract length, in mm, after purging to prevent slight oozing. Adjust as necessary.
var ooze_dwell          = 2          ; Dwell/wait time, in seconds, after purging and retracting.

; Adjust this so that your nozzle scrubs within the brush. Currently defaulted to be a lot higher for safety. Be careful not to go too low!
var brush_top           = 5.4

; These parameters define your scrubbing, travel speeds, safe z clearance and how many times you want to wipe. Update as necessary. Wipe
; direction is randomized based off whether the left or right bucket is randomly selected in the purge & scrubbing routine.

var clearance_z         = 5          ; When traveling, but not cleaning, the clearance along the z-axis between nozzle and brush.
var wipe_qty            = 3          ; Number of complete (A complete wipe: left, right, left OR right, left, right) wipes.
var prep_spd_xy         = 3000       ; Travel (not cleaning) speed along x and y-axis in mm/min.
var prep_spd_z          = 1500       ; Travel (not cleaning) speed along z axis in mm/min.
var wipe_spd_xy         = 5000       ; Nozzle wipe speed in mm/min.

; These parameters define the size of the brush. Update as necessary. A visual reference is provided below. Note that orientation of
; parameters remain the same whether bucket is at rear or front.

;                  ←   brush_width   →
;                   _________________
;                  |                 |  ↑
;  brush_start (x) |                 | brush_depth
;                  |_________________|  ↓
;                          (y)
;                      brush_front
;__________________________________________________________
;                     PRINTER FRONT

; Input where your brush assembly start is on the x axis
var brush_start         = 219.5

; This value is for the brush width (with brush holder), change it if your brush setup width is different.
var brush_width         = 50

; Specify the location in y axis for your brush - see diagram above.
var brush_front         = 354
var brush_depth         = 5

; These parameters define the size of your purge bucket. Update as necessary. If you decided to not enable purge, you can ignore
; this section. A visual reference is provided below. Note that orientation of parameters remain the same whether bucket is at rear
; or front.

;                                     bucket_gap
;                                      ← ---- →
;                     __________________________________________
;                    |                 |      |                 |
;                    |                 |      |                 |
;  bucket_start (x)  |                 |______|                 |
;                    |                 |      |                 |
;                    |                 |      |                 |
;                    |_________________|. . . |_________________|
;                     ← ------------- →        ← ------------- →
;                     bucket_left_width        bucket_right_width
;_______________________________________________________________________________________
;                                    PRINTER FRONT

; Input your left bucket width
var bucket_left_width   = 23.5

; Input your gap width
var bucket_gap          = 25

; Input your left bucket width
var bucket_right_width  = 35.5

; Input where your bucket start is on the x axis
var bucket_start        = 208.5

;--------------------------------------------------------------------------------------------------------------------------------------

; From here on, unless you know what you're doing, it's recommended not to change anything. Feel free to peruse the code if you stumble apon it
; and reach out to me on Discord (Exerqtor#3178) or the duet forum (Exerqtor) if you spot any problems, or have any sugestions for improvements!

; Shout-out to "fcwilt" on the duet forum for helping me with ironing out bugs and streamlining the macro! <3

;--------------------------------------------------------------------------------------------------------------------------------------

; Placeholder. The variable wil later be set to contain the overhang for the brush assembly in the buckets
var brush_oh            = 0

; Brush overhang calculation:
set var.brush_oh = {(var.brush_width - var.bucket_gap) / 2} 

; Placeholder. The variable will later be set to contain, at random, a number representing the left(0) or right(1) side
var pos                 = 1

; Randomly select left or right side
set var.pos = random(2)

; Check if the axes are homed - if not homed just abort - it exits this routine and none of the rest of the code is executed
if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed
  M291 R"Axes not homed" P"Please home all axes first!" T0
  abort "nozzle_scrub.g aborted - axes were not homed"

; Report what's going on
M291 S1 R"Cleaning nozzle" P"Please wait..." T5

; Set to absolute positioning.
G90

; ====================---------------------------------------------------------
; purging code
; ====================

; Check if user enabled purge option or not.
if var.enable_purge

  ; Purge if the temp is up to min temp. If not, it will skip and continue executing rest of macro.
  if heat.heaters[1].current > var.purge_temp_min
      echo "Purging"

    ; Raise Z for travel.
    G1 Z{var.brush_top + var.clearance_z} F{var.prep_spd_z}

    ; Move towards brush.
    G1 Y{var.brush_front + (var.brush_depth / 2)} F{var.prep_spd_xy}

    ; Position for purge. Randomly selects middle of left or right bucket. It references from the middle of the left bucket (while compensating for any brush overhang).
    if var.pos = 0 
      ; Left bucket selected

      G1 X{var.bucket_start + ((var.bucket_left_width - var.brush_oh) / 2)}
    else
      ; Right bucket selected
      G1 X{(var.bucket_start + var.bucket_left_width) + (var.bucket_gap + var.brush_oh) + ((var.bucket_right_width - var.brush_oh) / 2)}

    ; Perform purge with a small retract after purging to minimize any persistent oozing at (retract 5x purge_spd). 
    M83                                                                        ; relative mode
    G1 E{var.purge_len} F{var.purge_spd}
    G1 E{(0 - var.purge_ret)} F{var.purge_spd * 5}
    G4 S{var.ooze_dwell}
    G92 E0                                                                     ; reset extruder

  else
    echo "To cold to purge"

; ====================---------------------------------------------------------
; wiping code
; ====================

; Placeholders
var pos1                = 0
var pos2                = 0

; Position for wipe. Either left or right of brush based on var.pos to avoid unnecessary travel after purging
if var.pos = 0
  set var.pos1 = var.brush_start
  set var.pos2 = var.brush_start + var.brush_width
else
  set var.pos1 = var.brush_start + var.brush_width
  set var.pos2 = var.brush_start

G1 Z{var.brush_top + var.clearance_z} F{var.prep_spd_z}

G1 X{var.pos1} F{var.prep_spd_xy}

; Move in to the brush.
G1 Y{var.brush_front + (var.brush_depth / 2)}

; Move nozzle down into brush.
G1 Z{var.brush_top} F{var.prep_spd_z}

; Perform wipe. Wipe direction based off pos for cool random scrubby routine.
while true
  G1 X{var.pos2} F{var.wipe_spd_xy}
  G1 X{var.pos1}

  if iterations = var.wipe_qty + 1
    break

; ====================---------------------------------------------------------
; finish up
; ====================

; Clear from area.
G1 Z{var.brush_top + var.clearance_z} F{var.prep_spd_z}

G1 X{var.bucket_start + ((var.bucket_left_width - var.brush_oh) / 2)} F{var.prep_spd_xy}

M400                                                                           ; Wait for moves to finish

M118 S"Nozzle cleaned!"