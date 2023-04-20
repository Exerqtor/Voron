; /sys/lib/led/sb_leds-state.g  v1.0
; Created by sb_leds.g to store the current/active LED colors 
; Called by daemon.g to check if global.sb_leds status has changed since last run

var sb_leds = "ready"

if var.sb_leds = global.sb_leds
  ; Same status, do nothing
else
  ; New status, change colors
  M98 P"/sys/lib/led/sb_leds.g"
