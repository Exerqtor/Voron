; /sys/lib/klicky/klicky_status.g
; Used to check if the klicky probe is attached or not

; global.klicky_status
; = docked 
; = attached 

if sensors.probes[0].value[0] = 0
  set global.klicky_status = "attached"
elif sensors.probes[0].value[0] = 1000
  set global.klicky_status = "docked"
else
  set global.klicky_status = "invalid"
  echo "Klicky status invalid - aborting"
  abort
echo ""