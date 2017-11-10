# GIWAXS Analysis
## This workflow proceeds through two scripts:
* `Data_Reduction.py` converts raw .tiff data from GIWAXS run into real colored .tiffs and .csv line cuts and cake segs
* `analyze_giwaxs_dir.m` is a MATLAB script that reads these .csvs and puts out a csv with d-spacings, grain sizes, and Herman's Orientation

### 1. Data Reduction
#### Change the following lines of Data_Reduction.py in your text editor:


1. In this line, inside the quotes, put the folder where your raw data files are (*.tif will find all files ending with .tif). Double backslashes are necessary here for some reason.

`marfilelist = glob.glob("C:\\Users\\npersson3\\Google Drive\\GIWAXS\\Data\\script test\\*.tif")`


2. In this line, in the quotes, put the path to your .calib file.

`LaB6_calibfile = "C:\\Users\\npersson3\\Google Drive\\GIWAXS\\Data\\LaB6_d250_1s_12091458_0001.tif.calib"`


3. In this line, in the quotes, put the folder (ending in a \\) where you want your data to save. This folder will also be the input to the Matlab function later on.

`picfilefolder = "C:\\Users\\npersson3\\Google Drive\\GIWAXS\\Data\\script test\\pics\\"`

IMPORTANT: this should end in "pics", which is necessary for the MATLAB script. This would be easy to fix.

#### In wxdiff, go to `File > Run Simple Script...` and run your edited version of `Data_Reduction.py`

### 2. Analysis

#### Open MATLAB and call:

`[csv_file,D]=analyze_giwaxs_dir(dirPath,Imin,Imax)`

Where `dirPath` is the path to the folder in line 1 above, ending in a slash, but without the double slashes - for example:

`C:\Users\npersson3\Google Drive\GIWAXS\Data\script test\`

This function automatically adds the word "pics" to the end of this path, so make sure your "picfilefolder" from line 3 above ends with a folder called "pics".

`Imin` and `Imax` are the minimum and maximum intensities that you'd like to use to scale your image colors.

This will output a csv file with all of the relevant structural measurements, as well as actual image files of the GIWAXS spectra.

Putting Qxy / Qz axes on your image may be challenging. Best to add them in power point and estimate their locations.
