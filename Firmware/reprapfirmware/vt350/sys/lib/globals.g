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
; Bed
; ====================

if !exists(global.bed_x)
  global bed_x = 350                                                           ; Defines the bed size on x-axis(print area from 0 to max) change this to your KNOWN max print size

if !exists(global.bed_y)
  global bed_y = 350                                                           ; Define the bed size on y-axis(print area from 0 to max) change this to your KNOWN max print size

if !exists(global.bed_trammed)
  global bed_trammed = false                                                   ; Used to tell if the bed has been trammed or not

; ====================---------------------------------------------------------
; Motion
; ====================

if !exists(global.def_Xjrk)
  global def_Xjrk = move.axes[0].jerk                                          ; Store the default X axis jerk set in config.g
  
if !exists(global.def_Yjrk)
  global def_Yjrk = move.axes[1].jerk                                          ; Store the default Y axis jerk set in config.g

if !exists(global.def_PACC)
  global def_PACC = move.printingAcceleration                                  ; Store the default printing Acceleration set in config.g

if !exists(global.def_TACC)
  global def_TACC = move.travelAcceleration                                    ; Store the default travel Acceleration set in config.g

if !exists(global.def_PA)
  global def_PA = move.extruders[0].pressureAdvance                            ; Store the default Pressure Advance set in config.g

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

if !exists(global.FilamentCHG)
  global FilamentCHG = false

if !exists(global.initial_extruder)
  global initial_extruder = 0

if !exists(global.first_layer_height)
  global first_layer_height = "none"

if !exists(global.layer_number)
  global layer_number = 0

if !exists(global.Nozzle_CL)
  global Nozzle_CL= 5                                                          ; The Z distance from nozzle to bed surface, going lower than 5 will make the probe scary-close to the bed in most setups!

if !exists(global.unload_length)
  global unload_length = 18                                                    ; The length needed to clear the meltzone of the extruder (as speced by E3D for the Revo)

if !exists(global.chamber_leds)
  global chamber_leds = 0

if !exists(global.sb_leds)
  global sb_leds = "booting"

if !exists(global.Print_Probe)
  global Print_Probe = true