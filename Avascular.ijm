//batch processing for running on all images in file path
path=getDirectory("image"); 
list=getFileList(path); 


//***************************************************************
// INPUT FILES
modelfile = "C:/Users/Alex/Downloads/final.model";
datafile = "C:/Users/Alex/Downloads/final.arff";
// OUTPUT FILES
wheretosave = "C:/Users/Alex/Downloads/avascular/";
//***************************************************************


//loop through all images in file path
for(a=0;a<list.length;a++){ 
	
	//check if image is actually there
	if (a != 0) {
		open(path+list[a]);
	}

	//set variables
	name = getTitle();
	run("Clear Results");
	avascular = 0;

	//Preprocessing, getting rid of noise/background
	run("Enhance Local Contrast (CLAHE)", "blocksize=12 histogram=256 maximum=2 mask=*None* fast_(less_accurate)");
	run("8-bit");
	run("Enhance Local Contrast (CLAHE)", "blocksize=12 histogram=256 maximum=2 mask=*None* fast_(less_accurate)");
	//run("Enhance Contrast...", "saturated=0.35 normalize equalize");
	for(i=0;i<3;i++){
		run("Minimum...", "radius=2");
		run("Maximum...", "radius=3");
		run("Minimum...", "radius=1");
		run("Enhance Contrast...", "saturated=0.1 normalize equalize");
	}

//***************************************************************
// Image Segmentation
//***************************************************************

	//load data files
	run("Trainable Weka Segmentation");
	wait(3000);
	selectWindow("Trainable Weka Segmentation v2.3.0");
	call("trainableSegmentation.Weka_Segmentation.loadClassifier", modelfile);
	call("trainableSegmentation.Weka_Segmentation.loadData", datafile);

	//Segment the image
	call("trainableSegmentation.Weka_Segmentation.trainClassifier");
	call("trainableSegmentation.Weka_Segmentation.getResult");
	
	//saveAs("tiff", wheretosave + name + "Classified");
	rename("test");
	selectWindow("test");
	run("8-bit");

/**
	//get rid of hole in middle of flat mount
	radius = getWidth()/2;
	makeOval(getWidth()/2-radius/2, getHeight()/2-radius/2, radius, radius);
	setForegroundColor(85, 85, 85);
	run("Fill");
	run("Select All");
*/

//***************************************************************
// Post Processing
//***************************************************************

	//reduce dark speckle noise 
	selectWindow("test");
	for (i = 0; i < 2; i++){
	run("Duplicate...", "title=test1");
	setThreshold(85,85);
	run("Minimum...", "radius=0.5");
	run("Convert to Mask");
	run("Invert");
	run("Shape Filter", "area=0-90000 area_convex_hull=0-Infinity perimeter=0-Infinity perimeter_convex_hull=0-Infinity feret_diameter=0-Infinity min._feret_diameter=0-Infinity max._inscr._circle_diameter=0-Infinity long_side_min._bounding_rect.=0-Infinity short_side_min._bounding_rect.=0-Infinity aspect_ratio=1-Infinity area_to_perimeter_ratio=0-Infinity circularity=0-Infinity elongation=0-1 convexity=0-1 solidity=0-1 num._of_holes=0-Infinity thinnes_ratio=0-1 contour_temperatur=0-1 orientation=0-180 fractal_box_dimension=0-2 option->box-sizes=2,3,4,6,8,12,16,32,64 add_to_manager draw_holes fill_results_table");
	run("Color Picker...");
	setForegroundColor(155, 155, 155);
	selectWindow("test");
	count1=roiManager("count"); 
	if (count1 != 0) {
		Urray=newArray(count1); 
		for(ua=0; ua<count1;ua++) { 
			Urray[ua] = ua; 
		}  
		roiManager("Select", Urray);
		roiManager("Fill");
		roiManager("Delete");
	}
	close("CP");
	close("ROI Manager");
	run("Clear Results");
	close("test1");
	}

	//reduce light speckle noise 
	for (i = 0; i < 2; i++){
	selectWindow("test");
	run("Duplicate...", "title=test2");
	setThreshold(190,190);
	run("Convert to Mask");
	run("Maximum...", "radius=" + i);
	run("Invert");
	run("Shape Filter", "area=0-90000 area_convex_hull=0-Infinity perimeter=0-Infinity perimeter_convex_hull=0-Infinity feret_diameter=0-Infinity min._feret_diameter=0-Infinity max._inscr._circle_diameter=0-Infinity long_side_min._bounding_rect.=0-Infinity short_side_min._bounding_rect.=0-Infinity aspect_ratio=1-Infinity area_to_perimeter_ratio=0-Infinity circularity=0-Infinity elongation=0-1 convexity=0-1 solidity=0-1 num._of_holes=0-Infinity thinnes_ratio=0-1 contour_temperatur=0-1 orientation=0-180 fractal_box_dimension=0-2 option->box-sizes=2,3,4,6,8,12,16,32,64 add_to_manager draw_holes fill_results_table");
	run("Color Picker...");
	setForegroundColor(155, 155, 155);
	selectWindow("test");
	count1=roiManager("count"); 
	if (count1 != 0) {
		Urray=newArray(count1); 
		for(ua=0; ua<count1;ua++) { 
			Urray[ua] = ua; 
		}  
		roiManager("Select", Urray);
		roiManager("Fill");
		roiManager("Delete");
	}
	close("CP");
	close("ROI Manager");
	run("Clear Results");
	close("test2");
	run("Minimum...", "radius=1");
	}
	
	//fill incorrect segmentations
	for (i = 0; i < 2; i++){
	run("Duplicate...", "title=test3");
	width = getWidth();
	height = getHeight();
	area = width*height;
	setThreshold(155,155);
	run("Maximum...", "radius=" + i);
	run("Convert to Mask");
	run("Invert");
	run("Shape Filter", "area=0-" + area/600 + " area_convex_hull=0-Infinity perimeter=0-Infinity perimeter_convex_hull=0-Infinity feret_diameter=0-Infinity min._feret_diameter=0-Infinity max._inscr._circle_diameter=0-Infinity long_side_min._bounding_rect.=0-Infinity short_side_min._bounding_rect.=0-Infinity aspect_ratio=1-Infinity area_to_perimeter_ratio=0-Infinity circularity=0-Infinity elongation=0-1 convexity=0-1 solidity=0-1 num._of_holes=0-Infinity thinnes_ratio=0-1 contour_temperatur=0-1 orientation=0-180 fractal_box_dimension=0-2 option->box-sizes=2,3,4,6,8,12,16,32,64 add_to_manager draw_holes fill_results_table");

	saveAs("jpeg", wheretosave + name + "peripheral");

	//save area measurements of peripheral area
	selectWindow("Results");
	saveAs("text", wheretosave +"/Peripheral" + name);
/**
	run("Color Picker...");
	setForegroundColor(85, 85, 85);
	selectWindow("test");
	count1=roiManager("count"); 
	if (count1 != 0) {
		Urray=newArray(count1); 
		for(ua=0; ua<count1;ua++) { 
			Urray[ua] = ua; 
		}  
		roiManager("Select", Urray);
		roiManager("Fill");
		roiManager("Delete");
	}
	close("CP");
	close("ROI Manager");
	run("Clear Results");
	close("test3");
	}

	//find avascular area
	selectWindow("test");
	run("8-bit");
	setThreshold(155, 155);
	run("Convert to Mask");
	run("Invert");
	run("Shape Filter", "area=" + area/600 + "-Infinity area_convex_hull=0-Infinity perimeter=0-Infinity perimeter_convex_hull=0-Infinity feret_diameter=0-Infinity min._feret_diameter=0-Infinity max._inscr._circle_diameter=0-Infinity long_side_min._bounding_rect.=0-Infinity short_side_min._bounding_rect.=0-Infinity aspect_ratio=1-Infinity area_to_perimeter_ratio=0-Infinity circularity=0-Infinity elongation=0-1 convexity=0-1 solidity=0-1 num._of_holes=0-Infinity thinnes_ratio=0-1 contour_temperatur=0-1 orientation=0-180 fractal_box_dimension=0-2 option->box-sizes=2,3,4,6,8,12,16,32,64 add_to_manager draw_holes fill_results_table");
	
 
	//save binary image of avascular area
	saveAs("jpeg", wheretosave + name + "BW");

	//save area measurements of avascular area
	selectWindow("Results");
	saveAs("text", wheretosave +"/AvascularFor" + name);
*/

	wait(1000);

	//clear all results for next image
	nROIs = roiManager("count");
	for (u = 0; u < nROIs; u++) {
	avascular = getResult("Area", u) + avascular;
	}
	run("Clear Results");
	count1=roiManager("count"); 
	if (count1 != 0) {
	Irray=newArray(count1); 
	for(ia=0; ia<count1;ia++) { 
		Irray[ia] = ia; 
	}  
	roiManager("Select", Irray);
	roiManager("Delete");
	}
	close("ROI Manager");
	run("Clear Results");

	//save avascular area measurements in pixels
	print(avascular);
	File.saveString(avascular, wheretosave + "/AvascularAreaFor" + name + ".txt");

	//finished one image, close all windows and loop to next image
	close("Trainable Weka Segmentation v2.3.0");
	wait(3000);
	run("Close All");
}


