
clear

// set your directory here:
*cap cd "D:/Programs/Dropbox/Dropbox/STATA - MEDIUM"





*** maps files
*https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.html


cd "./dofiles/DuBois/challenge9/"


insheet using "https://raw.githubusercontent.com/ajstarks/dubois-data-portraits/master/challenge/challenge09/birthplace.csv", clear
save file1.dta, replace

insheet using "https://raw.githubusercontent.com/ajstarks/dubois-data-portraits/master/challenge/challenge09/present.csv", clear
replace state="MT" in 48
save file2.dta, replace


// convert the files

spshape2dta "cb_2018_us_state_500k.shp", replace saving(usa)


use usa_shp, clear
*scatter _Y _X

	drop rec_header shape_order
	
	drop if ///
		_ID==14 |  /// 		// Puerto Rico
		_ID==28 |  /// 		// Alaska
		_ID==38 |  /// 		// American Samoa
		_ID==39 |  /// 		// United States Virgin Islands
		_ID==43 |  /// 		// Hawaii
		_ID==45 |  /// 		// Guam
		_ID==46 			// North Mariana Islands
	
	
	
	geo2xy _Y _X, proj(albers) replace 
	sort _ID
	
save, replace
*/




/*	

*sort _Y _X
twoway ///	
	(area _Y _X if _ID==2, nodropbase cmissing(n) fi(100) fc(red) lc(black) lw(0.06))  ///
	(area _Y _X if _ID==6, nodropbase cmissing(n) fi(100) fc(red) lc(black) lw(0.06))  ///
	(area _Y _X if _ID==10, nodropbase cmissing(n) fi(100) fc(red) lc(black) lw(0.06)) ///
	(area _Y _X if _ID==19, nodropbase cmissing(n) fi(100) fc(red) lc(black) lw(0.06)) ///
	, legend(off)


twoway ///	
	(scatter _Y _X, msize(0.1))  ///
	, legend(off) xtitle("") ytitle("")
	
*/	




// main map stuff here
use usa, clear
	drop if ///
		_ID==14 |  /// 		// Puerto Rico
		_ID==28 |  /// 		// Alaska
		_ID==38 |  /// 		// American Samoa
		_ID==39 |  /// 		// United States Virgin Islands
		_ID==43 |  /// 		// Hawaii
		_ID==45 |  /// 		// Guam
		_ID==46 			// North Mariana Islands


geo2xy _CY _CX, proj(albers) replace 


// original values
gen _CYo = _CY
gen _CXo = _CX + 50000



*** fix the starting points

replace _CX = _CX + 40000 	if _ID==1

replace _CY = _CY + 60000 	if _ID==2
replace _CX = _CX + 100000 	if _ID==2

replace _CY = _CY + 90000 	if _ID==4
replace _CX = _CX + 120000 	if _ID==4

replace _CY = _CY + 70000 	if _ID==5
replace _CX = _CX + 80000 	if _ID==5

replace _CX = _CX + 100000 	if _ID==7

replace _CY = _CY + 30000 	if _ID==8
replace _CX = _CX + 10000 	if _ID==8	

replace _CY = _CY - 50000 	if _ID==10
replace _CX = _CX + 200000 	if _ID==10

replace _CY = _CY - 20000	if _ID==12
replace _CX = _CX + 70000 	if _ID==12

replace _CY = _CY - 100000 	if _ID==17
replace _CX = _CX + 100000 	if _ID==17

replace _CX = _CX + 80000 	if _ID==18

replace _CY = _CY + 70000 	if _ID==20
replace _CX = _CX + 120000 	if _ID==20

replace _CY = _CY + 30000 	if _ID==24
replace _CX = _CX + 80000 	if _ID==24

replace _CY = _CY + 120000 	if _ID==26
replace _CX = _CX + 120000 	if _ID==26

replace _CY = _CY + 40000 	if _ID==30
replace _CX = _CX + 40000 	if _ID==30

replace _CY = _CY + 50000 	if _ID==31
replace _CX = _CX + 80000 	if _ID==31

replace _CY = _CY + 80000 	if _ID==33
replace _CX = _CX + 80000 	if _ID==33

replace _CY = _CY + 40000 	if _ID==34
replace _CX = _CX + 100000 	if _ID==34

replace _CY = _CY + 30000 	if _ID==35
replace _CX = _CX + 80000 	if _ID==35

replace _CY = _CY - 30000 	if _ID==37
replace _CX = _CX + 450000 	if _ID==37

replace _CY = _CY + 70000 	if _ID==40
replace _CX = _CX + 60000 	if _ID==40

replace _CY = _CY + 40000 	if _ID==41
replace _CX = _CX + 50000 	if _ID==41		

replace _CY = _CY + 80000 	if _ID==42
replace _CX = _CX + 100000 	if _ID==42

replace _CY = _CY + 60000 	if _ID==44
replace _CX = _CX + 200000 	if _ID==44

replace _CY = _CY - 100000 	if _ID==47
replace _CX = _CX + 180000 	if _ID==47

replace _CY = _CY + 80000 	if _ID==48
replace _CX = _CX + 150000 	if _ID==48

replace _CY = _CY + 80000 	if _ID==49

replace _CY = _CY + 100000 	if _ID==50
replace _CX = _CX + 80000 	if _ID==50

replace _CX = _CX + 70000 	if _ID==51

replace _CY = _CY + 80000 	if _ID==52
replace _CX = _CX + 100000 	if _ID==52

replace _CY = _CY + 100000 	if _ID==54
replace _CX = _CX + 100000 	if _ID==54

replace _CY = _CY + 40000 	if _ID==56
replace _CX = _CX + 90000 	if _ID==56


// connect 47 and 37


	
*** georgia is the center point (19)


// generate lines


summ _CX if _ID==19
gen _CX0 = `r(mean)'

summ _CY if _ID==19
gen _CY0 = `r(mean)'			

/*
twoway ///	
	(scatter _CY _CX, msize(0.1))  ///
	(pcarrow _CY0 _CX0 _CY _CX )   ///	
		, legend(off)
*/

// y = mx + b	
	
gen slope = (_CY - _CY0) / (_CX - _CX0)  // m = (y1 - y0) / (x1 - x0)

gen inter = _CY -  (slope * _CX)  						 // b = y - mx 

gen _CX1 = .


replace _CX1 = _CX + 150000 if  _CX  < _CX0
replace _CX1 = _CX - 150000 if  _CX >= _CX0

// fix the offsets of some states
replace _CX1 = _CX - 80000  if  _ID==2
replace _CX1 = _CX - 50000  if  _ID==4
replace _CX1 = _CX - 40000  if  _ID==5
replace _CX1 = _CX + 80000  if  _ID==6
replace _CX1 = _CX + 30000  if  _ID==7
replace _CX1 = _CX - 30000  if  _ID==8
replace _CX1 = _CX + 80000  if  _ID==15
replace _CX1 = _CX + 400000 if  _ID==16
replace _CX  = _CX + 80000  if  _ID==19
replace _CY  = _CY + 40000  if  _ID==19
replace _CX1 = _CX - 40000  if  _ID==20
replace _CX1 = _CX + 40000  if  _ID==24
replace _CX1 = _CX - 60000  if  _ID==26
replace _CX1 = _CX + 40000  if  _ID==30
replace _CX1 = _CX + 60000  if  _ID==33
replace _CX1 = _CX - 30000  if  _ID==31
replace _CX1 = _CX - 80000  if  _ID==34
replace _CX1 = _CX - 30000  if  _ID==35
replace _CX1 = _CX - 90000  if  _ID==37
replace _CX1 = _CX - 70000  if  _ID==40
replace _CX1 = _CX - 50000  if  _ID==41
replace _CX1 = _CX - 100000 if  _ID==42
replace _CX1 = _CX - 70000  if  _ID==44
*replace _CX1 = _CX + 8000   if  _ID==47
replace _CX1 = _CX + 10000  if  _ID==48
replace _CX1 = _CX + 8000   if  _ID==49
replace _CX1 = _CX + 70000  if  _ID==50
replace _CX1 = _CX + 70000  if  _ID==52
replace _CX1 = _CX + 20000  if  _ID==54
replace _CX1 = _CX + 50000  if  _ID==55
replace _CX1 = _CX - 40000  if  _ID==56



gen _CY1 = (slope * _CX1) + inter       // x = (y - b) / m

/*
twoway ///	
	(scatter _CY _CX, msize(0.1))  ///
	(pcarrow _CY1 _CX1 _CY _CX )   ///	
		, legend(off)
*/

ren STUSPS state
replace state="AK" if state=="AR"

merge 1:1 state using file2
drop _m

merge 1:1 state using file1
drop _m

sort presentlocation

		
merge 1:m _ID using usa_shp
drop _m


	

egen tag = tag(_ID)


/*
twoway ///	
	(scatter _Y _X	, msize(0.03))  ///
	(scatter _CYo _CXo if tag==1, mc(none) msize(0.4) lw(vvthin) lc(black) mlabel(_ID) mlabs(1) mlabc(black) mlabpos(0) ) ///
		, ///
			legend(off) xtitle("") ytitle("") 	
graph export ID.png, replace wid(5000)
*/


global linew = 0.02

// yellow states: 
foreach i in 3 10 17 25 30 41 42 56 {
	local areayellow `areayellow'  (area _Y _X if _ID==`i', nodropbase cmissing(n) fi(100) fc("227 179 77") lc(black) lw($linew)) || 
}

// red states: 
foreach i in 20 22 44 47 51 53 {
	local areared `areared'  (area _Y _X if _ID==`i', nodropbase cmissing(n) fi(100) fc("193 52 86") lc(black) lw($linew)) || 
}

// pink states: 
foreach i in 2 6 11 29 31 54 55 {
	local areapink `areapink'  (area _Y _X if _ID==`i', nodropbase cmissing(n) fi(100) fc("208 153 146") lc(black) lw($linew)) || 
}

// grey states: 
foreach i in 12 16 33 35 40 44 48 {
	local areagrey `areagrey'  (area _Y _X if _ID==`i', nodropbase cmissing(n) fi(100) fc("214 203 185") lc(black) lw($linew)) || 
}

// green states: 
foreach i in 4 18 27 32 {
	local areagreen `areagreen'  (area _Y _X if _ID==`i', nodropbase cmissing(n) fi(100) fc("90 101 87") lc(black) lw($linew)) || 
}

//  blue states: 
foreach i in 9 21 26 34 36 37 50 {
	local areablue `areablue'  (area _Y _X if _ID==`i', nodropbase cmissing(n) fi(100) fc("126 133 175") lc(black) lw($linew)) || 
}

//  brown states: 
foreach i in 5 7 15 23 24  {
	local areabrown `areabrown'  (area _Y _X if _ID==`i', nodropbase cmissing(n) fi(100) fc("123 92 71") lc(black) lw($linew)) || 
}

//  sand states: 
foreach i in 1 8 13 49 52 {
	local areasand `areasand'  (area _Y _X if _ID==`i', nodropbase cmissing(n) fi(100) fc("189 168 147") lc(black) lw($linew)) || 
}




gen mylab = NAME + "(" + string(_ID, "%9.0f") + ")" if tag==1
gen mylab2 = string(_ID, "%9.0f") + "(" + string(presentlocation, "%9.0f") + ")" if tag==1
gen mylab3 = string(presentlocation, "%9.0fc") if tag==1

// 16, 6, 18 10 have markers below

gen markerbelow = _ID==6 | _ID==10 | _ID==16 |_ID==18

*** test map

graph set window fontface "Arial Narrow"

/*

twoway ///	
	`areayellow' 	///
	`areared'  		///
	`areapink' 		///
	`areagrey' 		///
	`areagreen' 	///
	`areablue' 		///
	`areabrown' 	///
	`areasand'		///
	(pcarrow _CY1 _CX1 _CY _CX if tag==1 & _ID!=19 & markerbelow==0, mc(black) msize(0.4) lw(vthin) lc(black) mlabel(_ID) mlabs(1.3) mlabc(black) mlabpos(12) headlabel) ///
	(pcarrow _CY1 _CX1 _CY _CX if tag==1 & _ID!=19 & markerbelow==1, mc(black) msize(0.4) lw(vthin) lc(black) mlabel(_ID) mlabs(1.3) mlabc(black)  mlabpos(6) headlabel) ///
		, ///
			legend(off) xtitle("") ytitle("") ///
			aspect(0.9) 

*/			
			
/*
graph set window fontface "Rajdhani"

twoway ///	
	(scatter _Y _X, msize(0.1))  ///
	`areayellow' 	///
	`areared'  		///
	`areapink' 		///
	`areagrey' 		///
	`areagreen' 	///
	`areablue' 		///
	`areabrown' 	///
	`areasand'		///
	(pcarrow _CY1 _CX1 _CY _CX if tag==1 & _ID!=19 & markerbelow==0, mc(black) msize(0.4) lw(vthin) lc(black) mlabel(mylab2) mlabs(1.3) mlabc(black) mlabpos(12) headlabel) ///
	(pcarrow _CY1 _CX1 _CY _CX if tag==1 & _ID!=19 & markerbelow==1, mc(black) msize(0.4) lw(vthin) lc(black) mlabel(mylab2) mlabs(1.3) mlabc(black)  mlabpos(6) headlabel) ///
		, ///
			legend(off) xtitle("") ytitle("") ///
			aspect(0.9) 
*/		

	
/***** FINAL MAP TOP


	
twoway ///	
	`areayellow' 	///
	`areared'  		///
	`areapink' 		///
	`areagrey' 		///
	`areagreen' 	///
	`areablue' 		///
	`areabrown' 	///
	`areasand'		///
	(area     _Y  _X if _ID==19, nodropbase cmissing(n) fi(100) fc(black) lc(black) lw(0.06)) ///
	(scatter _CY _CX if tag==1 & _ID==19, mc(black) msize(none) mlabel(mylab3) mlabs(1.2) mlabc(white) mlabpos(0)) ///
	(pcarrow _CY1 _CX1 _CY _CX if tag==1 & _ID!=19 & markerbelow==0, mc(black) msize(0.4) lw(vvthin) lc(black) mlabel(mylab3) mlabs(1.3) mlabc(black) mlabpos(12) headlabel) ///
	(pcarrow _CY1 _CX1 _CY _CX if tag==1 & _ID!=19 & markerbelow==1, mc(black) msize(0.4) lw(vvthin) lc(black) mlabel(mylab3) mlabs(1.3) mlabc(black)  mlabpos(6) headlabel) ///
		, ///
			legend(off) xtitle("") ytitle("") ///
			aspect(0.9) ///
			xlabel(, nogrid) ylabel(, nogrid)	///
			xscale(off) yscale(off) ///
			graphregion(fcolor("219 207 191")) 

*/
				
****** bottom part

gen _Yb = _Y - 4000000
gen _CYb = _CY - 4000000


/*	
twoway ///	
	(scatter _Y _X	, msize(0.1))  ///
	(scatter _Yb _X , msize(0.1) ) ///
		, ///
			legend(off) xtitle("") ytitle("") 	///
			aspect(1.6)  xsize(4) ysize(5)		///
			xlabel(, nogrid) ylabel(, nogrid)	///
			xscale(off) yscale(off) 			
*/

				
			
			
*** bot colors

// yellow states: 
foreach i in 9 16 26 47 48 55  {
	local areayellow2 `areayellow2'  (area _Yb _X if _ID==`i', nodropbase cmissing(n) fi(100) fc("227 179 77") lc(black) lw($linew)) || 
}

// red states: 
foreach i in 3 8 30 32 34 37 44 {
	local areared2 `areared2'  (area _Yb _X if _ID==`i', nodropbase cmissing(n) fi(100) fc("193 52 86") lc(black) lw($linew)) || 
}

// pink states: 
foreach i in 4 13 17 18 21 49  {
	local areapink2 `areapink2'  (area _Yb _X if _ID==`i', nodropbase cmissing(n) fi(100) fc("208 153 146") lc(black) lw($linew)) || 
}

// grey states: 
foreach i in 7 10 22 31 42 51 52 53 {
	local areagrey2 `areagrey2'  (area _Yb _X if _ID==`i', nodropbase cmissing(n) fi(100) fc("214 203 185") lc(black) lw($linew)) || 
}

// green states: 
foreach i in 24 27 29 33 56  {
	local areagreen2 `areagreen2'  (area _Yb _X if _ID==`i', nodropbase cmissing(n) fi(100) fc("90 101 87") lc(black) lw($linew)) || 
}

//  blue states: 
foreach i in 1 15 20 23 35 41 50  {
	local areablue2 `areablue2'  (area _Yb _X if _ID==`i', nodropbase cmissing(n) fi(100) fc("126 133 175") lc(black) lw($linew)) || 
}

//  brown states: 
foreach i in 2 12 25 54  {
	local areabrown2 `areabrown2'  (area _Yb _X if _ID==`i', nodropbase cmissing(n) fi(100) fc("123 92 71") lc(black) lw($linew)) || 
}

//  sand states: 
foreach i in 5 6 11 36 40  {
	local areasand2 `areasand2'  (area _Yb _X if _ID==`i', nodropbase cmissing(n) fi(100) fc("189 168 147") lc(black) lw($linew)) || 
}
			
			
			
			
	
***** FINAL MAP TOP + BOT



gen _CY1b = _CY1 - 4000000
gen _CYob = _CYo - 4000000
gen mylab4 = string(birthplace, "%9.0fc") if tag==1 & birthplace!=.


*drop arrows of 41 40
gen keeparrow = _ID!=40 & _ID!=41

replace _CXo = _CXo + 20000 if _ID==47  // polygon point
replace _CYo = _CYo + 30000 if _ID==47

gen  _CXm = _CX - 10000 if _ID==47   //  numbe point
gen  _CYm = _CY + 60000 if _ID==47


replace _CXo = _CXo + 30000 if _ID==37
replace _CYo = _CYo + 40000 if _ID==37

replace  _CXm = _CX - 60000 if _ID==37
replace  _CYm = _CY + 30000 if _ID==37

gen textx = .
gen texty = .
gen textt = ""

replace textx = 0 in 1
replace texty =  2500000 in 1
replace textt = "PRESENT DWELLING PLACE OF BLACKS BORN IN GEORGIA." in 1

replace textx = 0 in 2
replace texty = -1500000 in 2
replace textt = "BIRTHPLACE OF BLACKS NOW RESIDENT IN GEORGIA." in 2

graph set window fontface "Rajdhani"
cap cd "D:/Programs/Dropbox/Dropbox/STATA - MEDIUM"
	
twoway ///	
	`areayellow' 	///
	`areared'  		///
	`areapink' 		///
	`areagrey' 		///
	`areagreen' 	///
	`areablue' 		///
	`areabrown' 	///
	`areasand'		///
	(area     _Y  _X if _ID==19, nodropbase cmissing(n) fi(100) fc(black) lc(black) lw(0.06)) ///
	(scatter _CY _CX if tag==1 & _ID==19, mc(black) msize(zero) mlabel(mylab3) mlabs(1) mlabc(white) mlabpos(0)) ///
	(pcspike _CYm _CXm _CYo _CXo if tag==1 & (_ID==37 | _ID==47), lw(0.04) lc(gs10) lp(solid)) ///
	(scatter _CY _CX  if tag==1 & keeparrow==0, mc(black) msize(zero) mlabel(mylab3) mlabs(0.6) mlabc(black) mlabpos(12)  mlabgap(zero)) ///
	(pcarrow _CY1 _CX1 _CY _CX if tag==1 & _ID!=19 & keeparrow==1 & markerbelow==0, mc(black) msize(0.4) lw(0.06) lc(black) mlabel(mylab3) mlabs(1.1) mlwidth(0.06) mlabc(black) mlabpos(12) headlabel mlabgap(zero)) ///
	(pcarrow _CY1 _CX1 _CY _CX if tag==1 & _ID!=19 & keeparrow==1 &  markerbelow==1, mc(black) msize(0.4) lw(0.06) lc(black) mlabel(mylab3) mlabs(1.1) mlwidth(0.06) mlabc(black)  mlabpos(6) headlabel mlabgap(zero)) ///
		`areayellow2' 	///
		`areared2'  	///
		`areapink2' 	///
		`areagrey2' 	///
		`areagreen2' 	///
		`areablue2' 	///
		`areabrown2' 	///
		`areasand2'		///
		(area     _Yb  _X if _ID==19, nodropbase cmissing(n) fi(100) fc(black) lc(black) lw(0.06)) ///
		(scatter _CYb _CX if tag==1 & _ID==19, mc(black) msize(none) mlabel(mylab3) mlabs(1.2) mlabc(white) mlabpos(0)) ///
		(pcspike _CYb _CX _CYob _CXo if tag==1 & (_ID==37 | _ID==47), lw(0.04) lc(gs10) lp(solid)) ///
		(scatter _CYb _CX  if tag==1 & keeparrow==0, mc(black) msize(zero) mlabel(mylab3) mlabs(0.6) mlabc(black) mlabpos(12)  mlabgap(zero)) ///
		(pcarrow _CYb _CX _CY1b _CX1  if tag==1 & _ID!=19 & keeparrow==1 &  markerbelow==0 & birthplace!=., mc(black) msize(0.4) lw(0.06) lc(black) mlabel(mylab4) mlabs(1.1) mlwidth(0.06) mlabc(black) mlabpos(12) mlabgap(zero)) ///
		(pcarrow _CYb _CX _CY1b _CX1  if tag==1 & _ID!=19 & keeparrow==1 &  markerbelow==1 & birthplace!=., mc(black) msize(0.4) lw(0.06) lc(black) mlabel(mylab4) mlabs(1.1) mlwidth(0.06) mlabc(black)  mlabpos(6) mlabgap(zero)) ///
			(scatter texty textx, mc(none) ms(point) mlab(textt) mlabpos(0) mlabc(gs6) mlabsize(2)) ///
		, ///
			legend(off) xtitle("") ytitle("") 	///
			aspect(1.7)  xsize(4) ysize(5)		///
			xlabel(, nogrid) ylabel(, nogrid)	///
			xscale(off) yscale(off) 	///
			title("{fontface Rajdhani SemiBold: MIGRATION OF BLACKS .}" "{fontface Rajdhani SemiBold: 1890 .}", size(4)) ///
			note("#DuBoisChallenge Nr. 9 made with Stata. Source: https://github.com/ajstarks/dubois-data-portraits Plate 8." "By Asjad Naqvi (asjadnaqvi@gmail.com).", size(1.2) span) ///
			graphregion(fcolor("223 209 189")) 
			



		*	graph export "./graphs/DuBois/dubois9_stata_plate8.png", replace wid(4000)	
			

			
			
			
			
			
			
			
