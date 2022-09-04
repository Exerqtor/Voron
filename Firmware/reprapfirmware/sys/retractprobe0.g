; /sys/retractprobe.g
; Used to dock the klicky probe

M98 P"/sys/lib/klicky/klicky_status.g"                                         ; refresh klicky status
if global.klicky_status = "attached"
  echo "DOCKING"
  if move.axes[2].userPosition < 20                                            ; if Z is at less than 20
    G1 Z20 F9000                                                               ; move to Z 20
  G90                                                                          ; absolute positioning
  M98 P"/sys/lib/klicky/klicky_stage.g"
  M400                                                                         ; wait for moves to finish
  G91                                                                          ; relative positioning
  G1 Y60 F6000                                                                 ; move in
  G1 X{global.klicky_wipe}                                                      ; wipe off
  M400                                                                         ; wait for moves to finish
  G90                                                                          ; absolute positioning
  M98 P"/sys/lib/klicky/klicky_stage.g"
  M400                                                                         ; wait for moves to finish
  M98 P"/sys/lib/klicky/klicky_status.g"                                       ; refresh klicky status
  M400                                                                         ; wait for moves to finish
elif global.klicky_status = "docked"
  echo "Probe is DOCKED"
  M98 P"/sys/lib/klicky/klicky_status.g"                                       ; refresh klicky status
else
  echo "Error probe not docked - aborting"
  abort
echo ""