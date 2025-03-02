/**path=getDirectory("image"); 
list=getFileList(path); 

//*********************************
wheretosave = "C:\\Users\\Alex Cheng\\Downloads\\avascular\\area"; 
//*********************************

for(a=0;a<list.length;a++){ 
	if (a != 0) {
		open(path+list[a]);
	}

	*/
	name = getTitle();
	run("8-bit");
	setThreshold(2,253);
	run("Convert to Mask");
	run("Invert");
	run("Shape Filter", "area=1000000-Infinity area_convex_hull=0-Infinity perimeter=0-Infinity perimeter_convex_hull=0-Infinity feret_diameter=0-Infinity min._feret_diameter=0-Infinity max._inscr._circle_diameter=0-Infinity long_side_min._bounding_rect.=0-Infinity short_side_min._bounding_rect.=0-Infinity aspect_ratio=1-Infinity area_to_perimeter_ratio=0-Infinity circularity=0-Infinity elongation=0-1 convexity=0-1 solidity=0-1 num._of_holes=0-Infinity thinnes_ratio=0-1 contour_temperatur=0-1 orientation=0-180 fractal_box_dimension=0-2 option->box-sizes=2,3,4,6,8,12,16,32,64 add_to_manager draw_holes fill_results_table");
	area = 0;
	nROIs = roiManager("count");
	for (u = 0; u < nROIs; u++) {
		area = getResult("Area", u) + area;
	}
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
/**	
	run("Close All");
	File.saveString(area, wheretosave + name + ".txt");
}*/