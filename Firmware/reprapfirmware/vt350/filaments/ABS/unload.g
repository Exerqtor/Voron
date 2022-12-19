; filaments/ABS/unload.g
; called when M702 S"ABS" is sent

; ====================---------------------------------------------------------
; Settings section
; ====================

; Filament settings

var FilamentType        = "ABS"       ; Input the filament type (only for the message)

; Message placeholders
var Message1 = "Pressure Advance disabled"
var Message2 = "N/A"

; ====================---------------------------------------------------------
; Message section
; ====================

; Generate message
set var.Message2 = "" ^ var.FilamentType ^ " filament unloaded"

M98 P"/sys/lib/fw_retraction.g"                                       
M572 D0 S0.0 ; Disable Pressure Advance

; PA disabled message
M118 P0 S{var.Message1}                                                        ; Send message to DWC
M118 P2 S{var.Message1}                                                        ; Send message to PanelDue


; Filament unloaded message
M118 P0 S{var.Message2}                                                        ; Send message to DWC
M118 P2 S{var.Message2}                                                        ; Send message to PanelDue