; /sys/daemon.g
; Used to execute regular tasks, the firmware executes it and once the end of file is reached it waits. If the file is not found it waits and then looks for it again.

; Loop, to be able to turn on/off daemon.g
while global.RunDaemon
  ; stuff goes here         
  M98 P"/sys/lib/sb_leds.g"                                                    ; Run Stealthburner Neopixel macro
  G4 S1                                                                        ; delay running again or next command for at least 1 second