# execfile("c:\\myfiles\\PCBM_SVA_1.py")

# there are a few objects which are automatically visible in WxDiff Python scripts:
# wx: module WxPython - so you can create Messages with wx.MessageBox('Hello there.'. 'Greeting')
# wxdiff_api: this is the api exposed by the WxDiff program - all the good stuff happens here.
# MDIRoot: the root MDI Frame object of the program
# MDIParent: the same
# wxdiffwd_list: list of open diffraction image windows - in case a script needs to manipulate an already opened one

import os
import glob
import wxdiff_api

marfilelist = glob.glob("C:\\Users\\npersson3\\Google Drive\\GIWAXS\\Data\\script test\\*.tif") # here goes the folder over which you want to "loop"
LaB6_calibfile = "C:\\Users\\npersson3\\Google Drive\\GIWAXS\\Data\\LaB6_d250_1s_12091458_0001.tif.calib" # this is the calibration file which you want to use for all mar files
picfilefolder = "C:\\Users\\npersson3\\Google Drive\\GIWAXS\\Data\\script test\\pics\\"

print 'script running'
print marfilelist

# open all mar files in current folder
for filename in marfilelist:

	print filename
	dim = wxdiff_api.wxdiff_diffimage(MDIRoot) # generate diffraction image object		
	
	if dim.fromfile(filename, filetypestr='MARCCD', calibfname=LaB6_calibfile, maskfname=None, wdtitle=None, interactive=False): # open image from file
		
		print 'file loaded'
		
		dim0 = dim.convert_region_to_qxyqz(wholeimage = True) # this converts and returns a new wxdiff_api.wxdiff_diffimage object with which you can continue to work			
		dim.close() # close uncorrected image to save space
		
		if dim0 is not None:
			picfilename = picfilefolder + os.path.basename(filename)  

			dim0.set_image_options(colormap = 'jet', log = False, inverse = False, vmin = 40, vmax = 1072)
			f=open(picfilename+'whole image.bin','wb')
			dim0.diffimage.data.tofile(f)
			f.close()
			
			# Cake seg from 80 to 83 degrees to get average (100) linecut
			X1, Y1 = dim0.get_XY_from_QChi(Q = 0.15, Chi = 80) 
			X2, Y2 = dim0.get_XY_from_QChi(Q = 1.3, Chi = 83)
			cake_100 = dim0.add_cakeseg(X1,Y1,X2,Y2)
			cake_100_chi = cake_100.convert_to_qchi()
			cake_100_cols = cake_100_chi.column_sum()
			cake_100_cols.save_to_csv(picfilename + ' line100.csv')
			
			X1, Y1 = dim0.get_XY_from_QChi(Q = 0.15, Chi = 7) 
			X2, Y2 = dim0.get_XY_from_QChi(Q = 2.2, Chi = 10) 
			cake_010 = dim0.add_cakeseg(X1,Y1,X2,Y2)
			cake_010_chi = cake_010.convert_to_qchi()
			cake_010_cols = cake_010_chi.column_sum()
			cake_010_cols.save_to_csv(picfilename + ' line010.csv')
			
			X1, Y1 = dim0.get_XY_from_QxyQz(Qxy = 0, Qz = 0) 
			X2, Y2 = dim0.get_XY_from_QxyQz(Qxy = 1.5768, Qz = 1.5768)
			line_amorph = dim0.add_linecut(X1,Y1,X2,Y2)
			line_amorph.save_to_csv(picfilename + ' line_amorph.csv')
			
			X1, Y1 = dim0.get_XY_from_QxyQz(Qxy = 0, Qz = 0.4722) 
			X2, Y2 = dim0.get_XY_from_QxyQz(Qxy = -0.3255, Qz = 0)
			cake = dim0.add_cakeseg(X1,Y1,X2,Y2)
			cake_chi = cake.convert_to_qchi()
			cake_rows = cake_chi.row_sum()
			cake_rows.save_to_csv(picfilename + ' cake_rows.csv')
			
			dim0.close()

		else:
			print "Error: diffraction file " #+ dim0.diffimage.fname +" is not calibrated!"
	else:
		print "Error: cannot open " + filename + " in script mode!" 
