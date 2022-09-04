; /sys/lib/globals.g
; Called by init.g
; Used to initialize global variables

; global declarations and defaults values

; ====================---------------------------------------------------------
; temperature
; ====================

if !exists(global.bed_temp)
  global bed_temp = 0

if !exists(global.hotend_temp)
  global hotend_temp = 0

if !exists(global.chamber_temp)
  global chamber_temp = 0

; ====================---------------------------------------------------------
; stepper currents
; ====================

if !exists(global.xy_current)
  global xy_current = move.axes[0].current

if !exists(global.z_current)
  global z_current = move.axes[2].current

if !exists(global.e_current)
  global e_current = move.extruders[0].current

; ====================---------------------------------------------------------
; mechanical Z pin
; ====================

if !exists(global.z_pin_x)
  global z_pin_x = 194

if !exists(global.z_pin_y)
  global z_pin_y = 355.5

; ====================---------------------------------------------------------
; klicky probe
; ====================

; setup the klicky status
if !exists(global.klicky_status)
  global klicky_status = "none"

; the distance from the body of the klicky probe to it's own trigger point
if !exists(global.klicky_offset)
  global klicky_offset = 0.23  ; a larger values makes the nozzle closer to the bed after running Z calibration

; the Z distance from nozzle to bed surface
if !exists(global.klicky_clearance)
  global klicky_clearance = 20 ; going lower than 8 will make the probe scary-close to the bed in most setups!


; dock settings:

; the absolute X location of the klicky while docked
if !exists(global.klicky_dock_x)
  global klicky_dock_x = 19.4

; the absolute Y location of the klickywhile docked
if !exists(global.klicky_dock_y)
  global klicky_dock_y = 356.4

; the relative disance and direction of the klicky docking move	
if !exists(global.klicky_wipe)
  global klicky_wipe = 30  ; -30 for a left wipe 30 for a right wipe

; ====================---------------------------------------------------------
; bed
; ====================

; define the bed size on x-axis(print area from 0 to max)
if !exists(global.bed_x)
  global bed_x = 350
  
; define the bed size on y-axis(print area from 0 to max)
if !exists(global.bed_y)
  global bed_y = 350

; if the bed has been leveled or not
if !exists(global.bed_leveled)
  global bed_leveled = false

; ====================---------------------------------------------------------
; misc
; ====================

if !exists(global.RunDaemon)
  global RunDaemon = true

if !exists(global.initial_extruder)
  global initial_extruder = 0

if !exists(global.first_layer_height)
  global first_layer_height = "none"

; the length needed to clear the meltzone of the extruder (as speced by E3D for the Revo)
if !exists(global.unload_length)
  global unload_length = 18

if !exists(global.job_completion)
  global job_completion = 0

if !exists(global.debug_mode)
  global debug_mode = true

if !exists(global.chamber_leds)
  global chamber_leds   = "off"

if !exists(global.sb_leds)
  global sb_leds        = "boot"

if !exists(global.Z_cal)
  global Z_cal          = false

; ====================---------------------------------------------------------
; output current values
; ====================

;echo "global.bed_temp defined. Value : " , global.bed_temp
;echo "global.hotend_temp defined. Value : " , global.hotend_temp
;echo "global.chamber_temp defined. Value : " , global.chamber_temp
echo "global.klicky_status defined. Value : " , global.klicky_status
;echo "global.bed_leveled. Value : " , global.bed_leveled
;echo "global.job_completion defined. Value : " , global.job_completion
echo "global.debug_mode defined. Value : " , global.debug_mode