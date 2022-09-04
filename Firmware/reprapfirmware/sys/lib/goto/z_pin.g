; /sys/lib/goto/z_pin.g
; Called when homing and probing
; Used to move the nozzle over the mechanical Z pin

G90                                                                            ; absolute positioning

G1 X{global.z_pin_x} Y{global.z_pin_y - 30} F6000                              ; ease over to the z pin
G1 X{global.z_pin_x} Y{global.z_pin_y}                                         ; move to directly above mechanical Z-switch