; /sys/lib/init.g
; Called in the end of config.g
; Used to setup more stuff during the boot process

;M929 P"eventlog.txt" S1                                                        ; Start logging warnings to file eventlog.txt
;M929 P"infolog.txt" S2                                                         ; Start logging info to file infolog.txt
M929 P"debuglog.txt" S3                                                        ; Start logging debug info to file debuglog.txt

M98 P"/sys/lib/globals.g"                                                      ; setup global variables
M98 P"/sys/lib/current/xy_current_high.g"                                      ; set normal xy currents
M98 P"/sys/lib/current/z_current_high.g"                                       ; set normal z currents
M98 P"/sys/lib/fw_retraction.g"                                                ; set firmware retraction settings

; ====================---------------------------------------------------------
; Output current values
; ====================

echo "Log level is : " , state.logLevel