
clear

// set your directory here
cap cd "D:/Programs/Dropbox/Dropbox/STATA - MEDIUM"





*** font here:
*https://fonts.google.com/specimen/Rajdhani?preview.text_type=custom


*** challenge 3: half pie

import delimited using "https://raw.githubusercontent.com/ajstarks/dubois-data-portraits/master/challenge/challenge03/data.csv", clear


encode group, gen(grp)
encode occupation, gen(occ)

set obs 12

gen order = .

replace order = 5 in 1   // agri 
replace order = 4 in 3   // manufacturing
replace order = 3 in 2   // domestic and personal
replace order = 2 in 5   // trade and transportation
replace order = 1 in 4   // professions

replace order = 6 in 11

replace order = 11  in 6  // agri 
replace order = 10  in 8  // manufacturing
replace order = 9   in 7  // domestic and personal
replace order = 8   in 10 // trade and transportation
replace order = 7   in 9  // professions

replace order = 12 in 12

sort order

*gen pct2 = percentage / 4

*replace pct2 = 25.0875 if pct2 == .
replace percentage = 64.8 in 6
replace percentage = 65   in 12

replace grp = 1 in 6
replace grp = 2 in 12

replace occ = 0 if occ==.



*egen check1 = sum(percentage)
*egen check2 = sum(pct2)




/*
graph pie percentage, ///
	over(percentage) sort(order) angle(152) /// 
		pie(1,  color("220  19  59")) ///
		pie(2,  color("255 214   0")) ///
		pie(3,  color("128 128 255")) ///
		pie(4,  color("210 180 139")) ///	
		pie(5,  color("130 104  76")) ///	
		pie(6,  color(white)) ///
		pie(7,  color("220  19  59")) ///
		pie(8,  color("255 214   0")) ///
		pie(9,  color("128 128 255")) ///
		pie(10, color("210 180 139")) ///	
		pie(11, color("130 104  76")) ///
		pie(12, color(white)) ///
			legend(off) 
*/
	

**** things to remember

***if starting from the origin

** xB = r cos theta
** yB = r sin theta

**** if starting from a coordinate Ax, Ay

** xB = xA + r sin theta
** yB = yA - r(1 - cos theta)


summ percentage
gen theta = (percentage / `r(sum)') * 2 * _pi 

gen theta2 = .

sum order

forval i = 1/`r(max)' {
replace theta2 = sum(theta) if order <= `i'
}



global r = 5  // radius


gen arclength = (theta / 360) * 2 * _pi * $r


// generate the starting and end points of the arc
sort order

gen x = .
gen y = .

replace x =  $r * cos(theta2) 
replace y =  $r * sin(theta2) 


/*
    twoway	///
			(scatter y x, mlabel(order))  ///
			(function   sqrt($r^2 - (x)^2), lc(gs8) range(-$r $r)) ||  ///
			(function  -sqrt($r^2 - (x)^2), lc(gs8) range(-$r $r)),    ///
				aspect(1) legend(off)
					graph export "./graphs/DuBois/plate27/rotate0.png", replace wid(1000)	
*/					
					

					
				
// let's rotate the matrix by 90 degrees 
// 2-D rotation matrix:
//  x' = x cos theta - y sin theta
// 	y' = x sin theta + y cos theta

cap drop xhat yhat

local ro = 35 * _pi / 180

gen xhat =  x * cos(`ro') - y * sin(`ro')
gen yhat =  x * sin(`ro') + y * cos(`ro')

/*
    twoway	///
			(scatter yhat xhat, mlabel(order))  ///
			(function   sqrt($r^2 - (x)^2), lc(gs8) range(-$r $r)) ||  ///
			(function  -sqrt($r^2 - (x)^2), lc(gs8) range(-$r $r)),    ///
				aspect(1) legend(off)			
				graph export "./graphs/DuBois/plate27/rotate1.png", replace wid(1000)	
*/
				
drop x y
ren xhat x
ren yhat y
	
cap drop xhat yhat	// fix at last step when the graph is finalized
	
				
expand 2 if order==1	
replace order = 13 in 13	// repeat the first value		

drop group occupation theta theta2 arclength
gen id = 1

reshape wide percentage x y grp occ, i(id) j(order)

expand 3

forval i = 1/12 {
	
	// add the intercept dummy
	replace x`i' = 0 in 1
	replace y`i' = 0 in 1
	
	// pick the ending point from the next arc
	local j = `i' + 1
	replace x`i' = x`j' in 3
	replace y`i' = y`j' in 3
}



			

******	get the arc right		
				
gen marker0 = 0 in 1				
				
set obs 200		

local half = _N / 2
display `half'  


**** test arclength

forval i = 1/12 {

cap drop x`i'_temp
cap drop y`i'_temp

gen x`i'_temp = .
gen y`i'_temp = .
	

// positive top	
	summ y`i' if y`i' != 0

	
	if `r(min)' >= 0 & `r(max)' >= 0 {		
		sum x`i' if x`i' != 0
		replace x`i'_temp = runiform(`r(min)' , `r(max)')
		replace y`i'_temp =  sqrt(25 - (x`i'_temp)^2)	
		
		replace x`i' = x`i'_temp if x`i'==.
		replace y`i' = y`i'_temp if y`i'==.
	}

// negative bottom
	else if `r(min)' < 0 & `r(max)' < 0 {		
		sum x`i' if x`i' != 0
		replace x`i'_temp = runiform(`r(min)' , `r(max)')
		replace y`i'_temp =  -sqrt(25 - (x`i'_temp)^2)	
		
		replace x`i' = x`i'_temp if x`i'==.
		replace y`i' = y`i'_temp if y`i'==.
	}
	

// positive to negative	
	else if `r(min)' < 0 & `r(max)' >= 0 {		
		
		sum x`i' if x`i' != 0 & y`i' >= 0
		
			if `r(min)' < 0 {
				replace x`i'_temp = runiform(-5, `r(min)') 		in 1/`half'
				}
			
			else {
				replace x`i'_temp = runiform(`r(min)', 5) 		in 1/`half'
				} 
			
		replace y`i'_temp =   sqrt(25 - (x`i'_temp)^2)	in 1/`half'
		

		
		sum x`i' if x`i' != 0 & y`i' < 0
		
			if `r(min)' < 0 {
				replace x`i'_temp = runiform(-5, `r(min)') 		in `half'/200 
				}
			
			else {
				replace x`i'_temp = runiform(`r(min)', 5) 		in `half'/200 
				} 
		
		replace y`i'_temp =   -sqrt(25 - (x`i'_temp)^2)	in `half'/200 
		
		
		
		replace x`i' = x`i'_temp if x`i'==.
		replace y`i' = y`i'_temp if y`i'==.
	}
}


drop *temp

keep x* y*

gen id = _n
order id


reshape long x y, i(id) j(arc)

gen marker0 = 1 if x==0


gen sortme = .

levelsof arc, local(lvls)

foreach x of local lvls {
	summ x if arc==`x'

		if `r(max)'> 0 & `r(min)' < 0 {
			replace sortme = x if arc==`x'
			}
		else {
			replace sortme = y if arc==`x'
		}
		
	*replace sortme = _n if arc==`x'	
	}		


	

drop id


sort arc marker0 sortme	
drop marker0


by arc: gen id = _n

reshape wide x y sortme, i(id) j(arc)


/*
    twoway	///
		(area y1 x1, nodropbase fc(%20) lc(black) lw(vvthin))  ///
		(area y2 x2, nodropbase fc(%20) lc(black) lw(vvthin))  ///
		(area y3 x3, nodropbase fc(%20) lc(black) lw(vvthin))  ///
		(area y4 x4, nodropbase fc(%20) lc(black) lw(vvthin))  ///
		(area y5 x5, nodropbase fc(%20) lc(black) lw(vvthin))  ///
		(area y6 x6, nodropbase fc(%20) lc(black) lw(vvthin))  ///
		(area y7 x7, nodropbase fc(%20) lc(black) lw(vvthin))  ///
		(area y8 x8, nodropbase fc(%20) lc(black) lw(vvthin))  ///
		(area y9 x9, nodropbase fc(%20) lc(black) lw(vvthin))  ///
		(area y10 x10, nodropbase fc(%20) lc(black) lw(vvthin))  ///
		(area y11 x11, nodropbase fc(%20) lc(black) lw(vvthin))  ///
		(area y12 x12, nodropbase fc(%20) lc(black) lw(vvthin))  ///		
			,		///
				aspect(1) legend(off) ///
				xlabel(-5(1)5) ///
				ylabel(-5(1)5) 
*/

/*
    twoway	///
		(area y12 x12, nodropbase fc("130 104  76") lc(black) lw(vvthin))  ///	
		(area  y1  x1, nodropbase fc("210 180 139") lc(black) lw(vvthin))  ///
		(area  y2  x2, nodropbase fc("128 128 255") lc(black) lw(vvthin))  ///
		(area  y3  x3, nodropbase fc("255 214   0") lc(black) lw(vvthin))  ///
		(area  y4  x4, nodropbase fc("220  19  59") lc(black) lw(vvthin))  ///
		(area  y5  x5, nodropbase fc(white) lc(none) lw(vvthin))  ///
		(area  y6  x6, nodropbase fc("130 104  76") lc(black) lw(vvthin))  ///
		(area  y7  x7, nodropbase fc("210 180 139") lc(black) lw(vvthin))  ///
		(area  y8  x8, nodropbase fc("128 128 255") lc(black) lw(vvthin))  ///
		(area  y9  x9, nodropbase fc("255 214   0") lc(black) lw(vvthin))  ///
		(area y10 x10, nodropbase fc("220  19  59") lc(black) lw(vvthin))  ///
		(area y11 x11, nodropbase fc(white) lc(none) lw(vvthin))  ///
			,		///
				aspect(1) legend(off) ///
				xlabel(-5(1)5) ///
				ylabel(-5(1)5) 				
*/				


****** let's fine tune it

	/*			
    twoway	///
		(area y12 x12, nodropbase fc("130 104  76") lc(black) lw(vvthin))  ///	
		(area  y1  x1, nodropbase fc("210 180 139") lc(black) lw(vvthin))  ///
		(area  y2  x2, nodropbase fc("128 128 255") lc(black) lw(vvthin))  ///
		(area  y3  x3, nodropbase fc("255 214   0") lc(black) lw(vvthin))  ///
		(area  y4  x4, nodropbase fc("220  19  59") lc(black) lw(vvthin))  ///
		(area  y5  x5, nodropbase fc(white) lc(none) lw(vvthin))  ///
		(area  y6  x6, nodropbase fc("130 104  76") lc(black) lw(vvthin))  ///
		(area  y7  x7, nodropbase fc("210 180 139") lc(black) lw(vvthin))  ///
		(area  y8  x8, nodropbase fc("128 128 255") lc(black) lw(vvthin))  ///
		(area  y9  x9, nodropbase fc("255 214   0") lc(black) lw(vvthin))  ///
		(area y10 x10, nodropbase fc("220  19  59") lc(black) lw(vvthin))  ///
		(area y11 x11, nodropbase fc(white) lc(none) lw(vvthin))  ///
			,		///
				aspect(1) legend(off) ///
				xlabel(-5(1)5) 	ylabel(-5(1)5) 	///
				xlabel(, nogrid) ylabel(, nogrid) ///
				xscale(off) yscale(off)	
		*/						

gen markerx = .
gen markery = .				
gen markerl = ""				

	replace markerx = 0 		in 1
	replace markery = 5.2		in 1
	replace markerl = "BLACKS."	in 1

	replace markerx = 0 		in 2
	replace markery = -5.2		in 2
	replace markerl = "WHITES."	in 2

	replace markerx = -1.4 	in 3 
	replace markery =  3.8	in 3
	replace markerl = "62%"	in 3

	replace markerx = 2.1 	in 4
	replace markery = 3.8	in 4
	replace markerl = "28%"	in 4

	replace markerx = 3.4	in 5
	replace markery = 3.2	in 5
	replace markerl = "5%"	in 5

	replace markerx = 3.75	 in 6
	replace markery = 2.9	 in 6
	replace markerl = "4.5%" in 6

	replace markerx =  1.3 	 in 7
	replace markery = -3.8	 in 7
	replace markerl = "64%"  in 7

	replace markerx = -1.54  in 8
	replace markery = -4.55	 in 8
	replace markerl = "5.5%" in 8	
	
	replace markerx = -2.2    in 9
	replace markery = -3.95	  in 9
	replace markerl = "12.5%" in 9		
	
	replace markerx = -3.3    in 10
	replace markery = -3.2	  in 10
	replace markerl = "13%"   in 10	

	replace markerx = -3.8    in 11
	replace markery = -2.9	  in 11
	replace markerl = "4%"   in 11	
	
	
	
gen marker2x = .
gen marker2y = .				
gen marker2l = ""		
	
	replace marker2x = 4		in 1
	replace marker2y = 2.7		in 1
	replace marker2l = "0.8%" 	in 1	
	
	
cap drop *A	
cap drop *B 
cap drop *C 
cap drop *D 
cap drop *E
	
	gen markerxA = -4.1 		in 1
	gen markeryA =  0.7			in 1				
	*gen markerlA = "AGRICULTURE, FISHERIES AND MINING."	in 1

	gen markerxB = -4.1 		in 1
	gen markeryB =  -0.7		in 1				
	*gen markerlB = "MANUFACTURING AND MECHANICAL INDUSTRIES."	in 1

	
	gen markerxC = 4.1			in 1
	gen markeryC = 1.2			in 1				
	*gen markerlC = "DOMESTIC AND PERSONAL SERVICE."	in 1
	
	gen markerxD = 4.1 			in 1
	gen markeryD =  0			in 1				
	*gen markerlD = "PROFESSIONS."	in 1	
	
	gen markerxE = 4.1 			in 1
	gen markeryE =  -1.2			in 1				
	*gen markerlE = "TRADE AND TRANSPORTATION."	in 1	


gen marker3x = .
gen marker3y = .				
gen marker3l = ""		

	replace marker3x = -3.8 	in 1
	replace marker3y =  0.8		in 1	
	replace marker3l = "AGRICULTURE, FISHERIES" in 1
	
	replace marker3x = -3.4 	in 2
	replace marker3y =  0.6		in 2	
	replace marker3l = "AND MINING." in 2

	replace marker3x = -3.8 	in 3
	replace marker3y = -0.6		in 3	
	replace marker3l = "MANUFACTURING AND" in 3	

	replace marker3x = -3.8 	in 4
	replace marker3y = -0.8		in 4	
	replace marker3l = "MECHANICAL INDUSTRIES." in 4	
	

gen marker4x = .
gen marker4y = .				
gen marker4l = ""		

	replace marker4x =  3.6 				in 1
	replace marker4y =  1.3					in 1	
	replace marker4l = "DOMESTIC AND" 		in 1

	replace marker4x =  3.95 				in 2
	replace marker4y =  1.1					in 2	
	replace marker4l = "PERSONAL SERVICE." 	in 2
	
	replace marker4x =  3.95 				in 3
	replace marker4y =  0					in 3	
	replace marker4l = "PROFESSIONS." 		in 3
	
	replace marker4x =  3.6 				in 4
	replace marker4y = -1.1					in 4	
	replace marker4l = "TRADE AND" 			in 4	

	replace marker4x = 3.95 				in 5
	replace marker4y = -1.3					in 5	
	replace marker4l = "TRANSPORTATION." 	in 5
	

	

graph set window fontface "Rajdhani"
	
    twoway	///
		(area y12 x12, nodropbase fc("130 104  76") fi(100) lc(black) lw(0.02))  ///	
		(area  y1  x1, nodropbase fc("219 206 186") fi(100) lc(black) lw(0.02))  ///
		(area  y2  x2, nodropbase fc("128 128 255") fi(100) lc(black) lw(0.02))  ///
		(area  y3  x3, nodropbase fc("255 214   0") fi(100) lc(black) lw(0.02))  ///
		(area  y4  x4, nodropbase fc("220  19  59") fi(95) lc(black) lw(0.02))  ///
		(area  y5  x5, nodropbase fc(white) lc(none) lw(vvthin))  ///
		(area  y6  x6, nodropbase fc("130 104  76") fi(100) lc(black) lw(0.02))  ///
		(area  y7  x7, nodropbase fc("219 206 186") fi(100) lc(black) lw(0.02))  ///
		(area  y8  x8, nodropbase fc("128 128 255") fi(100) lc(black) lw(0.02))  ///
		(area  y9  x9, nodropbase fc("255 214   0") fi(100) lc(black) lw(0.02))  ///
		(area y10 x10, nodropbase fc("220  19  59") fi(95) lc(black) lw(0.02))  ///
		(area y11 x11, nodropbase fc(white) lc(none) lw(vvthin))  ///
			(scatter markery    markerx, mc(none) ms(point) mlab(markerl)  mlabpos(0) mlabc(black) mlabsize(1.8)) ///
			(scatter marker3y  marker3x, mc(none) ms(point) mlab(marker3l) mlabpos(3) mlabc(black) mlabsize(1.8) ) ///
			(scatter marker4y  marker4x, mc(none) ms(point) mlab(marker4l) mlabpos(9) mlabc(black) mlabsize(1.8) ) ///
				(scatter markeryA markerxA, mc("220  19  59") msize(4) ms(circle) mlc(black) mlwidth(0.05)) ///
				(scatter markeryB markerxB, mc("128 128 255") msize(4) ms(circle) mlc(black) mlwidth(0.05)) ///
				(scatter markeryC markerxC, mc("255 214   0") msize(4) ms(circle) mlc(black) mlwidth(0.05)) ///
				(scatter markeryD markerxD, mc("210 180 139") msize(4) ms(circle) mlc(black) mlwidth(0.05)) ///
				(scatter markeryE markerxE, mc("219 206 186") msize(4) ms(circle) mlc(black) mlwidth(0.05)) ///			
					,		///
					aspect(1) legend(off) ///
					xlabel(-5(1)5) 	ylabel(-5(1)5) 	///
					xlabel(, nogrid) ylabel(, nogrid) ///
					xscale(off) yscale(off)	///
					xsize(1) ysize(1.1) ///
					graphregion(fcolor("227 217 205")) ///
					title("{fontface Rajdhani SemiBold: OCCUPATION OF BLACKS AND WHITES IN GEORGIA.}") ///
					note("#DuBoisChallenge Nr. 3 made with #Stata. Source: https://github.com/ajstarks/dubois-data-portraits Plate 27." "By Asjad Naqvi (asjadnaqvi@gmail.com).", size(1.5))
					
					*graph export "./graphs/DuBois/plate27/dubois_stata_plate27.png", replace wid(5000)		
	

								