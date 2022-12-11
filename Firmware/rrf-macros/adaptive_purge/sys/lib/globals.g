; /sys/lib/globals.g
; Called by init.g
; Used to initialize global variables

; Global declarations and defaults values

; ====================---------------------------------------------------------
; Bed
; ====================

if !exists()
  global bed_x = 350                                                           ; Defines the bed size on x-axis(print area from 0 to max) change this to your KNOWN max print size

if !exists(global.bed_y)
  global bed_y = 350                                                           ; Define the bed size on y-axis(print area from 0 to max) change this to your KNOWN max print size

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

if !exists(global.Adaptive_Purge)
  global Adaptive_Purge = true