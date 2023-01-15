; /sys/retractprobe.g  v3.0
; Used to controll nozzle temps while probing with Voron TAP

if global.TAPPING = false
  M98 P"/sys/lib/he_temp.g"                                                    ; Restore hotend temp from before probing started