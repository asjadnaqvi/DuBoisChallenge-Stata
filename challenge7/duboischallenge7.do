




// set your directory here:
*cap cd "D:/Programs/Dropbox/Dropbox/STATA - MEDIUM"



*** challenge 7: more spirals


				
clear	
set obs 300
gen obs = _n


gen line1 = 0.50 + (_n / 100) in 73/169     // 0.5 = scaling factor 100 = space between the spirals 73 = inside point, 169 = top of spiral
gen line2 = 0.61 + (_n / 100) in 88/169
gen line3 = 0.73 + (_n / 100) in 105/169
gen line4 = 0.84 + (_n / 100) in 138/169
gen line5 = 0.95 + (_n / 100) in 147/169
gen line6 = 1.06 + (_n / 100) in 167/169

gen angle = _n * 2 * _pi / 52   // adding +/- changes the direction of the spiral

gen x1 = (line1 * cos(angle)) 
gen y1 = (line1 * sin(angle))

gen x2 = (line2 * cos(angle)) 
gen y2 = (line2 * sin(angle))

gen x3 = (line3 * cos(angle)) 
gen y3 = (line3 * sin(angle))

gen x4 = (line4 * cos(angle)) 
gen y4 = (line4 * sin(angle))

gen x5 = (line5 * cos(angle)) 
gen y5 = (line5 * sin(angle))

gen x6 = (line6 * cos(angle)) 
gen y6 = (line6 * sin(angle))




gen textx = .
gen texty = .
gen textt = ""

replace textx = 0 in 1
replace texty = 2.735 in 1
replace textt = "1875 -------- $ 21,186" in 1

replace textx = 0 in 2
replace texty = 2.62 in 2
replace textt = "1880 ----- $ 498,532" in 2

replace textx = 0 in 3
replace texty = 2.51 in 3
replace textt = "1885 ------ $ 736,170" in 3

replace textx = 0 in 4
replace texty = 2.4 in 4
replace textt = "1890 ---- $ 1,173,624" in 4

replace textx = 0 in 5
replace texty = 2.29 in 5
replace textt = "1895 --- $ 1,322,694" in 5

replace textx = 0 in 6
replace texty = 2.18 in 6
replace textt = "1899 --- $ 1,434,975" in 6

graph set window fontface "Rajdhani"
cap cd "D:/Programs/Dropbox/Dropbox/STATA - MEDIUM"


    twoway	///
			(line y1 x1, lc(black) 	lp(solid) lw(1.8)) ///
			(line y1 x1, lc("202 55 78") 	lp(solid) lw(1.77)) /// // red
			(line y2 x2, lc(black) 	lp(solid) lw(1.8)) ///
			(line y2 x2, lc("210 198 176") 	lp(solid) lw(1.77)) ///  // grey
			(line y3 x3, lc(black) lp(solid) lw(1.8)) ///
			(line y3 x3, lc("237 181 67") lp(solid) lw(1.77)) ///
			(line y4 x4, lc(black) 	lp(solid) lw(1.8)) ///
			(line y4 x4, lc("179 157 134") 	lp(solid) lw(1.77)) ///
			(line y5 x5, lc(black) 	lp(solid) lw(1.8)) ///
			(line y5 x5, lc("160 160 170") 	lp(solid) lw(1.77)) ///
			(line y6 x6, lc(black) 	lp(solid) lw(1.8)) ///
			(line y6 x6, lc("230 180 173") 	lp(solid) lw(1.77)) ///
			(scatter texty textx, mc(none) ms(point) mlab(textt) mlabpos(9) mlabc(gs6) mlabsize(2)) ///
					,    ///
					aspect(1) legend(off) 	///
					xlabel(-2.5(0.5)3, nogrid)	ylabel(-2.5(0.5)3, nogrid)	///
					xsize(3) ysize(3.5)		///
					xscale(off) yscale(off) 	///
		title("{fontface Rajdhani SemiBold: ASSESSED VALUE OF HOUSEHOLD AND KITCHEN FURNITURE}" "{fontface Rajdhani SemiBold: OWNED BY GEORGIA BLACKS .}", size(3.4)) ///
			note("#DuBoisChallenge Nr. 7 made with Stata. Source: https://github.com/ajstarks/dubois-data-portraits Plate 25." "By Asjad Naqvi (asjadnaqvi@gmail.com).", size(1.2) span) ///
			graphregion(fcolor("223 209 189")) 
			
	*	graph export "./graphs/DuBois/dubois7_stata_plate25.png", replace wid(4000)	
					