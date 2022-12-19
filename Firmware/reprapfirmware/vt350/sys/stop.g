; stop.g
; Called when M0 (Stop) is run (e.g. when a print from SD card is cancelled)

M98 P"/sys/lib/Print/print_end.g"                                              ; Call Macro/Subprogram