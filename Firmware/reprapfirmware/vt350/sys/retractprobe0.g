; /sys/retractprobe.g  v2.1
; Used to controll nozzle temps while probing with Voron TAP

if global.TAPPING = false
  G10 S{global.hotend_temp} P0                                               ; Set hotend temperature to global.hotend_temp