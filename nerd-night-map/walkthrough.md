## Walkthrough for Nerd Nite map

Download and install [QGIS](http://qgis.org). 

Download the following GIS shapefiles: 

- [Minneapolis city boundary](https://opendata.arcgis.com/datasets/92f705ededd64abc94964867b38a4c32_0.zip)
- [Minneapolis lakes and rivers](https://opendata.arcgis.com/datasets/0b2bdda8493c47f088100f831885bdce_0.zip)
- [Minneapolis parcels with zoning](https://opendata.arcgis.com/datasets/b8538f2b3fb443f99d2c30af86761971_0.zip)
- [Minneapolis streets](https://opendata.arcgis.com/datasets/9d845322959a4b6193645957a995dac0_0.zip)

Move the unzipped contents into a project directory. 

## Add and style your map

1. Add the `City_Boundary` shapefile to QGIS. (You can do this from the "Layer" menu under "Add Layer" > "Add Vector Layer", or by pressing the ![](https://docs.qgis.org/testing/en/_images/mActionAddOgrLayer.png) icon in the left panel. Right-click the layer and select Properties. From that dialog, pick the Symbology tab. Give your layer a black stroke color with 0.5 width, and a white fill.

2. Save your document.

3. Add the `Water` shapefile. At the bottom of its Symbology options, click the "Symbols in" dropdown, select "Colorful", and then `hashed cblue /`.

4. Redo city boundary symbology to: Inverted polygons. In the layers window, drag it above the city outline.

5. Add the `Future_LandUse` parcels shapefile. In Symbology, remove strokes. 

6. At the top of the Symbology window, click the "Single symbol" dropdown and select "Categorized." Under the Column dropdown pick `zoning`. Click "Classify" at the bottom. Click OK if you want to see what this looks like.

7. At the bottom of the Symbology window, click the Style dropdown and select Load Style. Select `zoning_colors.qml`, which is available on this Github repository. Click OK.

8. Add the `Street_Centerline` shapefile. If you want to look at it, change its color to black and hide zoning. 

9. In the Properties window for the streets layer, click Labels. Choose "Show labels for this map." Under "Label with" pick `STREETALL`.

10. On the label options page, click "Placement"; near the top check the "On line" box and uncheck "Above line." Under "Rendering" check "Scale dependent visibility" and write 4000 next to the ![](https://docs.qgis.org/testing/en/_images/mActionZoomOut.png) symbol. Scroll down and check "Merge connected lines to avoid duplicate labels." Go back to the Symbology window and turn the lines off or set their color to white.

11. Right-click the `Future_LandUse` layer and choose "Duplicate layer." Right-click the new layer and choose "Rename"; rename it to `moto-i` or another name of your choice.

12. Right click your new, duplicate layer and choose "Filter." In the text box on the bottom, paste the follow text: `"STREETNM" = 'LYNDALE AVE S'  AND  "HOUSENUM" = 2940`. Click OK.

13. Click the Processing menu and select "Toolbox." Click "Vector geometry" and double-click on "Centroids." Under the "Input layer" dropdown pick `moto-i` or whatever you named your duplicated layer. (The reason you needed to rename it is so you'd be able to select it here.) You can click "Run in background", or you can click the `...` option next to `[Create temporary layer]` and save the new shapefile you're creating to your project folder. Either way this will create a new layer, possibly called `Centroids`.

14. Open the `Centroids` layer's Symbology. Pick the "Symbols" dropdown, choose "QGIS 2", and pick the red star. Adjust the Size parameter to 8. 

## Prepare for print

1. Click the Project menu, choose "New print layout." Name it what you want (or just click OK). Click the "Add Item" menu, choose "Add Map". Draw a vertically oriented rectangle covering the left half or so of your canvas. On the right, under "Main Properties" in the "Scale" field, type 45000. If it's off-center, click the ![](https://docs.qgis.org/testing/en/_images/mActionMoveItemContent.png) and drag the map around the canvas. 

2. Go to "Add Item" > "Add Label." Drag a box along the top of the map, from the little northern extension of Minneapolis to the right side of the screen. In the text box under "Main properties", type "Nerd Out location in Minneapolis!" Click "Font" and choose whatever font you want for the title — a bold 36-point font should work well.

3. Make sure you've selected the ![](https://docs.qgis.org/testing/en/_images/mActionSelect.png) icon in the left toolbar. Click on your map. On the right, under "Layers", click "Lock layers" and "Lock styles for layers."

4. Switch windows to the mapmaking screen (not the print layout screen). Zoom in to about 28th to 32nd streets, and Colfax to Grand.

5. Go back to the print layout. Click "Add Map", and draw a square to fill the empty upper-right corner of the layout, below the title and to the right of the city-wide map. Make sure the Scale option is set to no more than 4000 (or street names won't show up, because we set the minimum visibility to 4,000). Scroll down in the toolboxes on the right to the "Frame" checkbox; check it and set a thickness of 0.5 to this inset. 

6. Click your citywide map, scroll down to "Overviews." Open the tab. Click the plus sign. Next to "Map frame" choose "Map 2" (your inset map). Click "Frame style" and then click "Simple fill" under "Fill" in beneath "Symbol selector." From there, click the "Fill style" dropdown and choose "No Brush"; click the "Stroke style" dropdown and choose "Dot Line." Adjust "Stroke width" to taste.

7. "Add Item" > "Add legend." Draw a rectangle underneath your inset map. Under "Legend Items" uncheck "Auto update." Click all the layers except `Future_LandUse` and press the ![](https://docs.qgis.org/testing/en/_images/symbologyRemove.png) button to delete them. 

8. Click the triangle next to `Future_LandUse` to open it up. Select the first item (should be a red square) and press the ![](https://docs.qgis.org/testing/en/_images/edit.png) button to edit its name. Type "Downtown." Select one of the purple squares and rename it to "Downtown Commercial." Continue relabeling one item of each color as follows: light blue = "Light Commercial", dark blue = "Dense Commercial", light yellow = "Light Industrial", dark yellow = "Dense Industrial", cyan = "Office", light green = "Light Residential", dark green = "Dense Residential". Then select all the rows you didn't rename and delete them. 

9. Right-click the "Future_LandUse" label and select "Hidden." Above, in the "Main properties" box, write "Minneapolis zoning" in the "Title" bar and align it center.

10. Scroll down. Expand "Columns" and change the field from 1 to 2. Check "Split layers." Resize the legend box on the map as necessary. 

11. "Add Label" below your legend. Type in a caption, like "Map by David H. Montgomery."

12. Adjust all the positions and appearances of your map canvas to suit.

13. Open the "Layout" menu, click "Export as Image." Resize and title as desired.