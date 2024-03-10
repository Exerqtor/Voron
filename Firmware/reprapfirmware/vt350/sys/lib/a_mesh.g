; /sys/print/a_mesh.g  v2.6
; Called by print_probe.g before a print starts
; Used to probe a new bed mesh at the start of a print

; ====================---------------------------------------------------------
; Settings section
; ====================

; Minimum deviation from default mesh
var minDev              = 20                                                   ; The minimum deviation between the default mesh points before an adaptive mesh is generated.

; Probing points for adaptive mesh
var minMeshPoints       = 3                                                    ; The minimum amount of probing points for both X & Y.
var maxMeshPoints       = 10                                                   ; The maximum amount of probing points for both X & Y

; Don't touch anyting beyond this point(unless you know what you're doing)!!
; ====================---------------------------------------------------------
; Prep phase
; ====================

; Grab default probing grid
var m557MinX = move.compensation.probeGrid.mins[0]                             ; Grabs your default x min
var m557MaxX = move.compensation.probeGrid.maxs[0]                             ; Grabs your default x max
var m557MinY = move.compensation.probeGrid.mins[1]                             ; Grabs your default y min
var m557MaxY = move.compensation.probeGrid.maxs[1]                             ; Grabs your default y max
; Grab the default mesh spacing
var meshSpacing_X = move.compensation.probeGrid.spacings[0]                    ; Grabs the X spacing of the current M557 settings
var meshSpacing_Y = move.compensation.probeGrid.spacings[1]                    ; Grabs the Y spacing of the current M557 settings

; ====================---------------------------------------------------------
; Setup print area
; ====================

; Define a variable to represent the min/max mesh coordinates
var pamMinX = global.paMinX                                                    ; The min X position of the print job
var pamMaxX = global.paMaxX                                                    ; The max X position of the print job
var pamMinY = global.paMinY                                                    ; The min Y position of the print job
var pamMaxY = global.paMaxY                                                    ; The max Y position of the print job

; ====================---------------------------------------------------------
; Check if adaptive mesh is needed
; ====================

var enabled = "PLACEHOLDER"
var meshX = "PLACEHOLDER"
var meshY = "PLACEHOLDER"
var msg = "PLACEHOLDER"

if (var.m557MinX + var.minDev) >= var.pamMinX                                  ; Check if the difference between default min X and the print area min X is smaller than the set deviation
  set var.pamMinX = var.m557MinX                                               ; The difference is smaller than min deviation so set pamMinX to m557MinX

if (var.m557MaxX - var.minDev) <= var.pamMaxX                                  ; Check if the difference between default max X and the print area max X is smaller than the set deviation
  set var.pamMaxX = var.m557MaxX                                               ; The difference is smaller than min deviation so set pamMaxX to m557MaxX

if (var.m557MinY + var.minDev) >= var.pamMinY                                  ; Check if the difference between default min Y and the print area min Y is smaller than the set deviation
  set var.pamMinY = var.m557MinY                                               ; The difference is smaller than min deviation so set pamMinY to m557MinY

if (var.m557MaxY - var.minDev) <= var.pamMaxY                                  ; Check if the difference between default max X and the print area max Y is smaller than the set deviation
  set var.pamMaxY = var.m557MaxY                                               ; The difference is smaller than min deviation so set pamMaxY to m557MaxY

if var.m557MinX = var.pamMinX && var.m557MaxX = var.pamMaxX && var.m557MinY = var.pamMinY  && var.m557MaxY = var.pamMaxY
  set var.enabled = false
  set var.msg = "Print area bellow min deviation, using default mesh!"         ; Set the message
  ; Info message
  M291 P{var.msg} T6                                                           ; Display message about what's going to happen
else
  set var.enabled = true
  ; Get the number of probes for X taking minMeshPoints and maxMeshPoints into account
  set var.meshX = floor(min(var.maxMeshPoints - 1, (max(var.minMeshPoints - 1, (var.pamMaxX - var.pamMinX) / var.meshSpacing_X) + 1)))
  ; Get the number of probes for Y taking minMeshPoints and maxMeshPoints into account
  set var.meshY = floor(min(var.maxMeshPoints - 1, (max(var.minMeshPoints - 1, (var.pamMaxY - var.pamMinY) / var.meshSpacing_Y) + 1)))

; If a adaptive grid is to be used
if var.enabled
  ; ====================---------------------------------------------------------
  ; Transfere grid
  ; ====================

  ; Transfere print area probing grid to mesh.g
  M98 P"mesh.g" A{var.pamMinX} B{var.pamMaxX} C{var.pamMinY} D{var.pamMaxY} E{var.meshX} F{var.meshY}
  ;M98 P"mesh.g" A{var.pamMinX} B{var.pamMaxX} C{var.pamMinY} D{var.pamMaxY} E3 F3