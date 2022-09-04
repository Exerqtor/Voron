; /sys/deployprobe.g
; Used to attach the klicky probe

M98 P"/sys/lib/klicky/klicky_status.g"                                         ; refresh klicky status
if global.klicky_status = "docked"

  ; Lower Z relative to current position if needed
  if move.axes[2].userPosition < 20                                            ; if Z is at less than 20
    G1 Z20 F9000                                                               ; move to Z 20

  M400                                                                         ; wait for moves to finish
  M98 P"/sys/lib/klicky/klicky_stage.g"                                        ; move up in front of the dock
  M400                                                                         ; wait for moves to finish
  G91                                                                          ; relative positioning
  G1 Y60 F6000                                                                 ;-move in to the dock
  G1 Y-60                                                                      ; move out of the dock
  G90                                                                          ; absolute positioning
  M400                                                                         ; wait for moves to finish
  M98 P"/sys/lib/klicky/klicky_status.g"                                       ; refresh klicky status
M400                                                                           ; wait for moves to finish
M98 P"/sys/lib/klicky/klicky_status.g"                                         ; refresh klicky status
echo ""