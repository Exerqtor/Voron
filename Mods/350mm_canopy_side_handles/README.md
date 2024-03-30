# 2.4 & Trident  350mmCanopy side handles
### **CHANGELOG:**
- 30.03.2024: Initial release.

![](./pics/photo1.jpg)

### **Description:**
- Wanted I didn't want to remove the handles on my Trident when I started to print ,["JSmith17's Canopy"](https://www.printables.com/model/568090-voron-24-canopy) but didn't like the avalible options.
- I've been using the original “Sturdy Handles” before and they've done their job, so i saw JSB's "X-Handle”["JSB's X-Handle"](https://www.printables.com/model/350891-voron-24-x-handle)  and started working on a way to add compatibility for those on the Canopy.

**Canopy:**
- Moved the mounting holes inward one “octagon”.
- Made the needed cutouts for the handles to sit within.

**X-Handle:**
- Removed the top mounting bolts in favour of a “lip” that goes into the 2020 extrusion like the original “sturdy handles”
- Added M3x20mm BHCS to mitigate a weak spot in the design where the handle meets the top part, where it "allways" cracked.
- Made modifier blocks to add denser/stronger types of infill around the problem area mentioned above.
- I've also made a second modifier block that makes it possible to add "fuzzy skin" to the handle without compromising the structual integrety while still giving that nice grippy texture (for those who wants it).

*I've also made a version of the handle that's stripped of the “X” since I just don't understand why it's there at all other than nonsensical “branding” (?) , to each their own i guess!*

### **Pictures:**
![](./pics/1.png)
![](./pics/2.png)
![](./pics/3.png)

### **Printing:**
**Canopy sides:**
- Default voron settings, correct orientation.
- You **MUST** add supports, I went for organic/three supports like this: 

Front side

![](./pics/4.png)
Back side

![](./pics/5.png)
Result:

![](./pics/6.png)

**Handles:**
- Default voron settings, correct orientation, no supprts needed!
- First load the handle itself to your slicer.
- Add "Infill.stl" as a modifier to the handle and adjust the infill properties of the modifier.(if you want to add other infill properties to the stress sones).
- Add "Fuzz.stl" as a modifier to the handle and enable fuzzy skin (contour) to the modifier (if you want to add texture to the handle).
If you've gone with both infill and fuzz you will end up with something like this:

![](./pics/7.png)
This is the sliced view of mine when I use 40% Support Cubic infill on the handle, 40% 3D Honeycomb on the infill modifier & Countor fuzzy skin on the fuzz modifier:

![](./pics/8.png)
![](./pics/9.png)

### **Bom (per side):**
**Canopy sides:**
- 2x M3x8 SHCS (I choose to use low profile ones)
- 2x M3 Roll-in T-nuts
**Handles:**
- 4x M3x20mm SHCS (for the handle reinforcement)
- 2x M5x16mm  BHCS
- 2x M5 Roll-in T-nuts

###### **To-do List:**
- Nothing that i can think of.