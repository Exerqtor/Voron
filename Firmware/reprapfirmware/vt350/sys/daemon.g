; /sys/daemon.g  v2.8
; Used to execute regular tasks, the firmware executes it and once the end of file is reached it waits. If the file is not found it waits and then looks for it again.

;---/
; -/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
; THIS MACRO ONLY WORKS WITH RRF 3.5.0b1 AND LATER!!
;--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
;-/


; Loop, to be able to turn on/off daemon.g
while global.RunDaemon
  ; Stuff goes below this line
  ; ---------------------------------------------------------------------------         

  ; Resume after filament change
  if exists(global.FilamentCHG)
    if global.FilamentCHG = true && state.status = "paused"
      M24                                                                      ; Resume the pause automatically now that the manual filament change is done
      set global.FilamentCHG = false

  ; --------------------
  
  ; Nevermore Micro V6 (under bed) automation  
  if heat.heaters[0].active >= 80 && fans[6].actualValue = 0
    if heat.heaters[0].current > 45
      M106 P6 S102                                                             ; Activate the Micro V6's mounted under the bed to help heating up the chamber
      
  if  heat.heaters[0].current > 100 && heat.heaters[0].active >= 110    
    M106 P6 S153                                                               ; Ramp up the Micro V6's mounted under the bed to help keep the chamber warm

  if heat.heaters[0].active <= 79 && fans[6].actualValue >= 1 && state.status = "processing"
    M106 P6 S0                                                                 ; Deactivate the Micro V6's mounted under the bed not to overheat the chamber

  ; --------------------

  ; Refresh chamber lights status
  if exists(global.chamber_leds)
    if global.chamber_leds != {state.gpOut[0].pwm * 100}
      set global.chamber_leds = state.gpOut[0].pwm * 100

  ; --------------------

  ;Check sb_leds status
  var SB_LEDS = true                                                           ; Turn on(true) / off(false) the Stealthburner led "system"
  if var.SB_LEDS
    if fileexists("/sys/lib/led/sb_leds-state.g")
      M98 P"/sys/lib/led/sb_leds-state.g"                                      ; Check if global.sb_leds has changed since last run/loop

  ; ---------------------------------------------------------------------------
  ; Daemon loop delay
  G4 P250                                                                      ; Delay running again or next command for at least 0,25 seconds