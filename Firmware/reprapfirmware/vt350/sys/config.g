; Configuration file for Duet 3 Mini 5+ with Duet 3 Expansion Mini 2+ and 1LC (firmware version 3.5)
; executed by the firmware on start-up

; For E3D Revo Micro, Bondtech LGX Lite & Voron TAP  --------------------------

; ====================---------------------------------------------------------
; Basic setup
; ====================

; General preferences
M575 P1 S1 B57600                                                              ; Enable support for PanelDue
M80 C"pson"                                                                    ; Allocates the pin and sets the pin in the power on state
M80                                                                            ; Sets pin in the power on state
;M81                                                                            ; Turn power off immediately

; Debugging
M111 S0                                                                        ; Debugging off (S0) or on (S1)

G21                                                                            ; Work in millimetres
G90                                                                            ; Send absolute coordinates...
M83                                                                            ; Set extruder to relative mode
M550 P"Voron Trident"                                                          ; Set printer name
G4 S2                                                                          ; Wait a moment for the CAN expansion boards to start

; Kinematics
M669 K1 X-1:-1:0 Y1:-1:0 Z0:0:1                                                ; Select CoreXY mode and set kinematics matrix

; Network
M552 S1                                                                        ; Enable network
G4 S1                                                                          ; Wait a second
M586 P0 S1                                                                     ; Enable HTTP (for DWC)
M586 P1 S1                                                                     ; Enable FTP (for remote backups etc.) S0 / S1 = disabled / enabled
M586 P2 S0                                                                     ; Disable Telnet

; ====================---------------------------------------------------------
; Driver config
; ====================

;          --- Drive map ---
; (While looking at the printer top down)

;             0.0-----0.1
;              |  0.2  |
;              |-------|
;              |0.3|0.4|
;               ---+---
;                Front

; Drives for XY
M569 P0.0 S0                                                                   ; X (B) (physical drive 0.0) goes backwards
M569 P0.1 S0                                                                   ; Y (A) (physical drive 0.1) goes backwards

; Drives for Z
M569 P0.2 S0                                                                   ; Z1 (physical drive 0.2) goes backwards
M569 P0.3 S0                                                                   ; Z2 (physical drive 0.3) goes backwards
M569 P0.4 S0                                                                   ; Z3 (physical drive 0.4) goes backwards

; Drive for extruder
M569 P121.0 S0                                                                 ; E (physical drive 121.0) goes backwards

; Motor mapping and steps per mm
M584 X0.0 Y0.1 Z0.2:0.3:0.4 E121.0                                             ; Set drive mapping
M350 X16 Y16 Z16:16 E16 I1                                                     ; Configure microstepping with interpolation
M92 X80.00 Y80.00 Z800.00                                                      ; Set XYZ steps per mm (1.8deg motors)
M92 E568.83                                                                    ; Set Extruder steps per mm (Bondtech LGX Lite 562 stock)

; Drive currents
M906 X1750 Y1750 I40                                                           ; Set XY motor currents (mA) and ide current percentage
M906 Z850 I40                                                                  ; Set Z motor currents (mA) and ide current percentage
M906 E650 I40                                                                  ; Set E motor currents (mA) and ide current percentage
M84 X Y Z E0 S30                                                               ; Set idle timeout

; ====================---------------------------------------------------------
; Motion config
; ====================

; Axis max jerk & speed limits in mm/s
var Xjrk = 12           ; X axis jerk
var Yjrk = 12           ; Y axis jerk
var Zjrk = 0.5          ; Z axis jerk
var Xspd = 500          ; X axis max speed
var Yspd = 500          ; Y axis max speed
var Zspd = 15           ; Z axis max speed

; Axis accelerations and speeds
M566 X{var.Xjrk * 60} Y{var.Yjrk * 60} Z{var.Zjrk * 60} P1                     ; Set maximum instantaneous speed changes (mm/min) and jerk policy
M203 X{var.Xspd * 60} Y{var.Yspd * 60} Z{var.Zspd * 60}                        ; Set maximum speeds (mm/min)
M201 X7000.00 Y7000.00 Z500.00                                                 ; Set accelerations (mm/s²) Z var 150

; Extruder max jerk & speed limits in mm/s
var Ejrk = 134          ; Extruder jerk
var Espd = 250          ; Extruder max speed

; Extruder accelerations and speeds
M566 E{var.Ejrk * 60} P1                                                       ; Set maximum instantaneous speed changes (mm/min) and jerk policy
M203 E{var.Espd * 60}                                                          ; Set maximum speeds (mm/min)
M201 E3000.0                                                                   ; Set accelerations (mm/s²) var 1800

; Reduced accelerations
M201.1 X500 Y500 Z80 E500                                                      ; Set reduced acceleration for special move types (mm/s²)

; Printing and travel accelerations
M204 P5000 T7000                                                               ; Set printing acceleration and travel accelerations (mm/s²)

; ====================---------------------------------------------------------
; Movement
; ====================

; Axis Limits
M208 X-1 Y-10 Z0 S1                                                            ; Set axis minimal
M208 X352 Y350 Z330 S0                                                         ; Set axis maximal

; Endstops
M574 Z0 P"nil"                                                                 ; No endstop

; Z-probe (Voron TAP)
M558 K0 P8 C"^121.io2.in" H2 R0.2 F300:180 T18000 A1 S0.03                     ; Set Z probe number ,type, input pin, dive height,recovery time, feed rate, travel speed, max probes & tolerance when probing multiple times
G31 K0 P500 X0 Y0 Z-1.170                                                      ; Set Z probe trigger value, offset and trigger height (higher Z value = nozzle closer to bed)

; Bed leveling

;        --- Pivot point map ---
; (While looking at the printer top down)
;               -------
;              |   1   |
;              |-------|
;              | 3 | 2 |
;               ---+---
;                Front

M671 X175:362:-49 Y390:12:12 S10                                               ; Leadscrew locations (Rear, Right, Left) M671 X175:388:-38 Y416.6:1.5:1.5 S10 
M557 X10:340 Y10:340 P12                                                       ; Define default mesh grid ( positions include the Z offset!)

; Accelerometer & Input shaping
M955 P121.0 I05                                                                ; Configure accelerometer
;M593 P"zvdd" F39.75 S0.0                                                       ; Use ZVDD input shaping to cancel ringing at 39.75Hz with 0.0 damping factor
M593 P"zvd" F41.5 S0.0                                                         ; Use ZVD input shaping to cancel ringing at 41.5Hz with 0.0 damping factor

; ====================---------------------------------------------------------
;  Heaters
; ====================

; Bed heater
M308 S0 P"temp0" Y"thermistor" T100000 B3950 A"Bed"                            ; Configure sensor 0 as thermistor on pin temp0
M950 H0 C"out0" T0 Q5                                                          ; Create bed heater output on out0, map it to sensor 0 and set PWM frequency(Hz)
M307 H0 B0 S1.00                                                               ; Disable bang-bang mode for the bed heater and set PWM limit
M140 H0                                                                        ; Map heated bed to heater 0
M143 H0 S110                                                                   ; Set temperature limit for heater 0 to 110°C
M143 H0 A2 C0 S110                                                             ; Make sure bed heater stays below 110°C
M143 H0 A1 C0 S125                                                             ; Make sure bed heater shuts down at 125°C

; Hotend heater
M308 S1 P"121.temp0" Y"thermistor" T100000 B4725 C7.060000e-8 A"Hotend"        ; Configure sensor 1 as thermistor on pin 121.temp0
M950 H1 C"121.out0" T1                                                         ; Create nozzle heater output on 121.out0 and map it to sensor 1
M307 H1 B0 S1.00                                                               ; Disable bang-bang mode for heater  and set PWM limit
M143 H1 S300                                                                   ; Set temperature limit for heater 1 to 300°C

; Chamber heater
M308 S4 P"121.temp1" Y"thermistor" T98000 B3950 A"Chamber"                     ; Configure sensor 4 as thermistor on pin 121.temp1

M308 S2 Y"mcu-temp" A"MCU"                                                     ; Configure sensor 2 as MCU temperature
M912 P0 S-2.9                                                                  ; MCU temp calibration parameters
M308 S3 Y"drivers" A"DRIVERS"                                                  ; Configure sensor 3 as drivers temperature

; ====================---------------------------------------------------------
;  Fans
; ====================

;Part cooling
M950 F0 C"121.out1" Q250                                                       ; Create fan 0 on pin 121.out1 and set its frequency
M106 P0 S0 B0.5 H-1 C"Part Cooling"                                            ; Set fan 0 value. Thermostatic control is turned off

;Hotend
M950 F1 C"121.out2" Q250                                                       ; Create fan 1 on pin 121.out2 and set its frequency
M106 P1 S1 H1 T45 C"Hotend"                                                    ; Hotend fan @ 100%, turns on if temperature sensor 1 reaches 45°C

;Auxiliary part cooling
M950 F2 C"out2" Q250                                                           ; Create fan 2 on pin none and set its frequency
M106 P2 S0 B0.5 H-1 C"AUX Part Cooling"                                        ; Set fan 2 value. Thermostatic control is turned off

;Air filtration - back panel
M950 F3 C"!out3+out3.tach" Q250                                                ; Create fan 3 uses out3, but we are using a PWM fan so the output needs to be inverted, and using out3.tach as a tacho input
M106 P3 S0 L0.20 B0.5 H-1 C"StealthMax S"                                      ; Exhaust fan 3 value. Thermostatic control is turned off

;Air filtration - under bed
M950 F6 C"out6" Q250                                                           ; Create fan 6 on pin 121.out1 and set its frequency
M106 P6 S0 B0.5 H-1 C"Micro V6´s"                                              ; Set fan 6 value. Thermostatic control is turned off

;Electronics
M950 F5 C"out5" Q250                                                           ; Create fan 5 on pin out3 and set its frequency
M106 P5 L0.15 H2:3 T45:50 C"Electronics fans"                                  ; Electronics fans start @ 20% when temperature sensor 2 reaches 45°C or sensor 3 (drivers report over temp)

; ====================---------------------------------------------------------
;  Tools
; ====================

M563 P0 S"Revo Micro" D0 H1 F0                                                 ; Define tool 0
G10 P0 X0 Y0 Z0                                                                ; Set tool 0 axis offsets
G10 P0 R0 S0                                                                   ; Set initial tool 0 active and standby temperatures to 0°C

; ====================---------------------------------------------------------
; Filament monitoring
; ====================

; Monitor before extruder (runout sensor)
M591 P1 C"121.io0.in" S1 D0                                                    ; Filament monitor connected to 121.io0.in

; ====================---------------------------------------------------------
;  Other
; ====================

; Miscellaneous
M950 P0 C"out1"	                                                               ; Create output Port0 attached to out1 connector for LED lights 
M911 S10 R11 P"M913 X0 Y0 G91 M83 G1 Z3 E-5 F1000"                             ; Set voltage thresholds and actions to run on power loss
M572 D0 S0.045                                                                 ; Set Pressure Advance
M501                                                                           ; Load config-override.g
M98 P"/sys/lib/init.g"                                                         ; Iniate external configs
T0                                                                             ; Select tool 0