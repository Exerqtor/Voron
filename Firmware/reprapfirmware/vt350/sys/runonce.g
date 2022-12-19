; /sys/runonce.g
; Called after config.g. When it has been executed, it is automatically deleted!

M552 S0                                                                        ; Disable network
G4 S1                                                                          ; Wait a second
M587 ; Configure according to https://docs.duet3d.com/en/User_manual/Reference/Gcodes/M587
G4 S1                                                                          ; Wait a second
M552 S1                                                                        ; Enable network