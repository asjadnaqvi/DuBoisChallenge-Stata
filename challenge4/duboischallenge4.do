

clear

// set your directory here:
*cap cd "D:/Programs/Dropbox/Dropbox/STATA - MEDIUM"



*** challenge 4: 

import delimited using "https://raw.githubusercontent.com/ajstarks/dubois-data-portraits/master/challenge/challenge04/data.csv", clear

gen free2 = 100  // for the green color

gen slave2 = slave // for the labels
replace slave2 = 89 if slave==0



gen label = string(free) + "%"

gen x = .
gen y = .
gen lab2 = ""


replace x = 1830 in 1
replace y = 56 in 1
replace lab2 = "SLAVES" in 1

replace x = 1830 in 2
replace y = 50 in 2
replace lab2 = "ESCLAVES" in 2

replace x = 1830 in 3
replace y = 96 in 3
replace lab2 = "FREE - LIBRE" in 3


graph set window fontface "Rajdhani SemiBold"

twoway ///
	(area free2 year, fcolor("46 139 87%90") fi(90) lwidth(none)) ///
	(area slave year, fcolor(black) fintensity(100) lwidth(none)) ///
	(scatter slave2 year, mcolor(none) mlabel(label) mlabsize(vsmall) mlabcolor(black) mlabposition(12)) ///
	(scatter free2 year, mcolor(none) mlabel(year) mlabsize(small) mlabposition(12)) ///
	(scatter y x in 1/2, mcolor(none) mlabel(lab2) mlabsize(4.5) mlabcolor(white) mlabposition(0)) ///
	(scatter y x in 3, mcolor(none) mlabel(lab2) mlabsize(medsmall) mlabcolor(black) mlabposition(0)) ///
		, ///
		yscale(off) ylabel(, nogrid) ///
		xscale(off) xscale(noline) ///
		xlabel(1790(10)1870, noticks grid glwidth(vthin) glcolor(black) glpattern(solid) nogextend) ///
		title("PROPORTION OF FREEMEN AND SLAVES AMONG AMERICAN BLACKS ." "  " "PROPORTION DES NÈGRES LIBRES ET DES ESCLAVES EN AMÉRIQUE .", size(2.8)) ///
		subtitle("DONE BY ATLANTA UNIVERSITY .", size(vsmall) position(12) margin(medlarge)) ///
		note("#DuBoisChallenge Nr. 4 made with Stata. Source: https://github.com/ajstarks/dubois-data-portraits Plate 51." "By Asjad Naqvi (asjadnaqvi@gmail.com).", size(1.5)) ///
		legend(off) ///
		graphregion(fcolor("223 209 189")) ///
		xsize(3) ysize(4) aspectratio(1.05)

*graph export "./graphs/DuBois/plate51/dubois4_stata_plate51.png", replace wid(4000)		
















