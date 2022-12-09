; /sys/lib/globals.g
; Called by init.g
; Used to initialize global variables

; global declarations and defaults values

; ====================---------------------------------------------------------
; print area
; ====================

; setup the variables for min/max print area
if !exists(global.paMinX)
  global paMinX = "N/A"
  
if !exists(global.paMaxX)
  global paMaxX = "N/A"

if !exists(global.paMinY)
  global paMinY = "N/A"

if !exists(global.paMaxY)
  global paMaxY = "N/A"

; ====================---------------------------------------------------------
; misc
; ====================

  
if !exists(global.Adaptive_Purge)
  global Adaptive_Purge = true