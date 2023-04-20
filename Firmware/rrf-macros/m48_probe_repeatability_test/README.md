# CHANGELOG
- 08.01.2023: v3.0 - Adapted the macro for RRF 3.5, this brings to option to choose the number of samples to be taken after you execute M48. The macro now also outputs the sample result after
 the "Samper number"" in console for easier readout and last sample is displayed in `G32 bed probe heights` before `mean n.nnn, deviation from mean n.nnn`. For example:
 ```
8.1.2023, 01:29:16	G32 bed probe heights: -0.005 0.001 0.002 0.006 0.006 0.006 0.006 0.001 0.006 0.005, mean 0.004, deviation from mean 0.004
8.1.2023, 01:29:15	Sample number 9: 0.006mm
8.1.2023, 01:29:14	Sample number 8: 0.001mm
8.1.2023, 01:29:12	Sample number 7: 0.006mm
8.1.2023, 01:29:11	Sample number 6: 0.006mm
8.1.2023, 01:29:09	Sample number 5: 0.006mm
8.1.2023, 01:29:08	Sample number 4: 0.006mm
8.1.2023, 01:29:07	Sample number 3: 0.002mm
8.1.2023, 01:29:06	Sample number 2: 0.001mm
8.1.2023, 01:29:05	M48
Sample number 1: -0.005mm
 ```
 - 21.12.2022: v2.0 - Changed the code so that you souldn't need to delete any of the code. Fill in everything as specified and you should be good to go!
- 19.12.2022: Initial release.

## M48 Probe Repeatability Test RRF 3.5 and newer

###### Description:
- This macro is made to test how accurate your Z probe is, it does "x" amount of probes in the bed center and reports the results in the DWC/PanelDue console.

###### Instalation and dependencies:
- This assumes that your probe Z probe is defined to be K0 / Probe0! If for some reason it's defined to be some other number swap out the "0" at the end of the files according to the probe number you have it configered to be!
- Place the `M48.g` file in the /sys/ folder on your printer.
- Open up `M48.g` with the text editor of your choice, input your bed size, desired nozzle clearance and save the changes.
- Now you should be all sett to run the macro by sending `M48` on either DWC or PanelDue and follow the instructions on the screen.

###### To-do List
- Iron out bugs (if any).