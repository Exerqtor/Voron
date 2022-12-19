; /sys/lib/init.g
; Called in the end of config.g
; Used to setup more stuff during the boot process

M98 P"/sys/lib/globals.g"                                                      ; setup global variables
M98 P"/sys/lib/speed/speed_printing.g"                                         ; set normal speed & accel
M98 P"/sys/lib/current/xy_current_high.g"                                      ; set normal xy currents
M98 P"/sys/lib/current/z_current_high.g"                                       ; set normal z currents
M98 P"/sys/lib/fw_retraction.g"                                                ; set firmware retraction settings