; /sys/lib/fw_retraction.g  v2
; Called when "M98 P"/sys/lib/fwretracton.g"" is sent
; Used to set default firmware retraction length, extra un-retract lenght, retract speed, unretract speed & zlift

; ====================---------------------------------------------------------
; Settings section
; ====================

var RLen                = 0.450        ; Retraction length (mm)
var X_URLen             = 0.000        ; Extra unretract length (mm)
var RSpd                = 35           ; Retraction speed (mm/sec)
var URSpd               = 25           ; Unretract speed (mm/sec)
var Z_Lift              = 0.200        ; Zlift amount (mm)

; ====================---------------------------------------------------------
; ; Convert mm/sec too mm/min
; ====================

set var.RSpd = (var.RSpd * 60)
set var.URSpd = (var.URSpd * 60)

; ====================---------------------------------------------------------
; Config section
; ====================

M207 S{var.RLen} R{var.X_URLen} F{var.RSpd} T{var.URSpd} Z{var.Z_Lift}       ; Set firmware retraction length, extra un-retract lenght, retract speed, unretract speed & zlift