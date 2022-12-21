; /sys/lib/globals.g
; Called by init.g
; Used to initialize global variables

; Global declarations and defaults values

; ====================---------------------------------------------------------
; Temperature
; ====================

if !exists(global.bed_temp)
  global bed_temp = 0

if !exists(global.hotend_temp)
  global hotend_temp = 0

if !exists(global.chamber_temp)
  global chamber_temp = 0

; ====================---------------------------------------------------------
; Stepper currents
; ====================

if !exists(global.xy_current)
  global xy_current = move.axes[0].current

if !exists(global.z_current)
  global z_current = move.axes[2].current

if !exists(global.e_current)
  global e_current = move.extruders[0].current

; ====================---------------------------------------------------------
; Bed
; ====================

if !exists(global.bed_x)
  global bed_x = 350                                                           ; Defines the bed size on x-axis(print area from 0 to max) change this to your KNOWN max print size

if !exists(global.bed_y)
  global bed_y = 350                                                           ; Define the bed size on y-axis(print area from 0 to max) change this to your KNOWN max print size

if !exists(global.bed_leveled)
  global bed_leveled = false                                                   ; Used to tell if the bed has been leveled or not

; ====================---------------------------------------------------------
; Print area
; ====================

if !exists(global.paMinX)
  global paMinX = 0                                                            ; The X axis print area minimum
  
if !exists(global.paMaxX)
  global paMaxX = {global.bed_x}                                               ; The X axis print area maximum

if !exists(global.paMinY)
  global paMinY = 0                                                            ; The Y axis print area minimum

if !exists(global.paMaxY)
  global paMaxY = {global.bed_y}                                               ; The Y axis print area maximum

; ====================---------------------------------------------------------
; MISC
; ====================

if !exists(global.RunDaemon)
  global RunDaemon = true


if !exists(global.initial_extruder)
  global initial_extruder = 0


if !exists(global.first_layer_height)
  global first_layer_height = "none"


  if !exists(global.Nozzle_CL)
  global Nozzle_CL= 5                                                          ; The Z distance from nozzle to bed surface, going lower than 5 will make the probe scary-close to the bed in most setups!


if !exists(global.unload_length)
  global unload_length = 18                                                    ; The length needed to clear the meltzone of the extruder (as speced by E3D for the Revo)


if !exists(global.job_completion)
  global job_completion = 0


if !exists(global.chamber_leds)
  global chamber_leds   = "off"


if !exists(global.sb_leds)
  global sb_leds        = "boot"


if !exists(global.Print_Probe)
  global Print_Probe = false


if !exists(global.Adaptive_Purge)
  global Adaptive_Purge = true

; ====================---------------------------------------------------------
; Output current values
; ====================

;echo "Debugging is : " , global.debugging