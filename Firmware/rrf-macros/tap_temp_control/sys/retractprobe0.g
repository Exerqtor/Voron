; /sys/retractprobe.g  v2.0
; Used to controll nozzle temps while probing with Voron TAP

if global.probing = false
  G10 S{global.hotend_temp} P0                                               ; Set hotend temperature to global.hotend_temp