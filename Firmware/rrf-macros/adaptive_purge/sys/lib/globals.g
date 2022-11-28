; /sys/lib/globals.g
; Called by init.g
; Used to initialize global variables

; global declarations and defaults values

; ====================---------------------------------------------------------
; print area
; ====================

; setup the variables for min/max print area
if !exists(global.pamMinX)
  global pamMinX = "N/A"
  
if !exists(global.pamMaxX)
  global pamMaxX = "N/A"

if !exists(global.pamMinY)
  global pamMinY = "N/A"

if !exists(global.pamMaxY)
  global pamMaxY = "N/A"

; ====================---------------------------------------------------------
; misc
; ====================

  
if !exists(global.Adaptive_Purge)
  global Adaptive_Purge = true