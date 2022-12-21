# CHANGELOG
- 21.12.2022: v.2.0 - Changed the code so that you souldn't need to delete any of the code. Fill in everything as specified and you should be good to go!
- 19.12.2022: Initial release.

## M48 Probe Repeatability Test RRF 3.4 and newer

###### Description:
- This macro is made to test how accurate your Z probe is, it does "x" amount of probes in the bed center and reports the results in the DWC/PanelDue console.

###### Instalation and dependencies:
- This assumes that your probe Z probe is defined to be K0 / Probe0! If for some reason it's defined to be some other number swap out the "0" at the end of the files according to the probe number you have it configered to be!
- Place the `M48.g` file in the /sys/ folder on your printer.
- Open up `M48.g` with the text editor of your choice and input the number of times you want the test to probe the bed and save the changes.
- Now you should be all sett to run the macro by sending `M48` on either DWC or PanelDue if your using my RRF setup..

###### To-do List
- Iron out bugs (if any).