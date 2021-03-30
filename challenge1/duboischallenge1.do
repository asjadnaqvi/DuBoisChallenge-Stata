

clear

// set your directory here:
*cap cd "D:/Programs/Dropbox/Dropbox/STATA - MEDIUM"



*** font here:
*https://fonts.google.com/specimen/Rajdhani?preview.text_type=custom


*** challenge 3: half pie

import delimited using "https://raw.githubusercontent.com/ajstarks/dubois-data-portraits/master/challenge/challenge01/data.csv", clear


gen colored2 	= 100 - colored
gen white2 		= 100 - white




**** to reverse the axis

lab de xaxis ///
	0 "100" 5 "95" 10 "90" 15 "85" 20 "80" 25 "75" 30 "70" 35 "65" 40 "60" 45 "55" 50 "50" ///
	55 "45" 60 "40" 65 "35" 70 "30" 75 "25" 80 "20" 85 "15" 90 "10" 95 "5" 100 "0", replace

	lab val white2 xaxis
	lab val colored2 xaxis
	
	
twoway ///
	(line year colored2, lcolor(black) lwidth(thin) lpattern(solid)) ///
	(line year white2, lcolor(black) lwidth(thin) lpattern(shortdash)) ///
		, ///
			ytitle("") yscale(noline) ///
			ylabel(1790(10)1890, labsize(2.5) noticks grid glwidth(0.05) glcolor(red) glpattern(solid) nogextend) ///
			xtitle("PERCENTS.", size(2.6) alignment(bottom)) xscale(titlegap(2) outergap(0)) ///
			xscale(noline) xlabel(0(5)100, labsize(2.2) labgap(zero) valuelabel noticks grid glwidth(0.05) glcolor(red) glpattern(solid) nogextend) ///
			title("{fontface Rajdhani SemiBold: COMPARATIVE INCREASE OF WHITE AND COLORED}" "{fontface Rajdhani SemiBold: POPULATION OF GEORGIA.}", size(4.5)) ///
			legend(order(1 "= COLORED" 2 "= WHITE") symplacement(north) rows(1) colgap(half) size(vsmall) region(fcolor(none)) position(6) span) ///
			xsize(2) ysize(3) ///
			graphregion(fcolor("223 209 189")) plotregion(ilcolor(black) ilwidth(vthin))	
			
						*graph export "./graphs/DuBois/plate7/dubois1_stata_plate7.png", replace wid(5000)		