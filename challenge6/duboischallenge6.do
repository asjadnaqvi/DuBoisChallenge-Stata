

clear

// set your directory here:
*cap cd "D:/Programs/Dropbox/Dropbox/STATA - MEDIUM"


*** challenge 6: snakes


				
clear	
set obs 240
gen obs = _n
*gen y = runiform(2, 3)
gen snake = 1 + (_n / 90)


gen angle = _n * 2 * -_pi / 52

gen x1 = (snake * cos(angle)) + 0.0
gen y1 = (snake * sin(angle)) + 0.0

drop in 1/2
drop obs
gen obs = _n

/*
    twoway	///
			(line y1 x1, lc(red) lw(1.2)) ///			
					,    ///
					aspect(1) legend(off) 			///
					xlabel(-5(1)5)	ylabel(-5(1)5)	
*/					

gen x2 = .					
gen y2 = .

replace x2 = -2.75	in 1
replace y2 =  2.25	in 1

replace x2 = -3.044	in 2
replace y2 =  2.25	in 2


replace x2 = 3.8  	in 3
replace y2 = 10		in 3

replace x2 = 4.1  	in 4
replace y2 = 10		in 4


gen x3 = .					
gen y3 = .

replace x3 = 3.8  	in 1
replace y3 = 10		in 1

replace x3 = 4.1  	in 2
replace y3 = 10		in 2

replace x3 = 1.1  	in 3
replace y3 = 13		in 3

replace x3 = 0.8  	in 4
replace y3 = 13		in 4

gen x4 = .					
gen y4 = .

replace x4 = 1.1  	in 1
replace y4 = 13		in 1

replace x4 = 0.8  	in 2
replace y4 = 13		in 2

replace x4 = 1.8  	in 3
replace y4 = 14		in 3

replace x4 = 2.1  	in 4
replace y4 = 14		in 4

gen x5 = .					
gen y5 = .

replace x5 = 2.1  	in 1
replace y5 = 14		in 1

replace x5 = 2.1  	in 2
replace y5 = 14.24	in 2

replace x5 = -5  	in 3
replace y5 = 14.24	in 3

replace x5 = -5  	in 4
replace y5 = 14		in 4


*** text stuff here


gen theta = obs * _pi / 60

gen px1 =  abs((4) * cos(theta)) 
gen px2 = -abs((4) * cos(theta)) 

gen py1 = tan(theta)*px1
gen py2 = tan(theta)*px2

replace px1 = px1 - 0.08
replace px2 = px2 - 0.08

gen marker1 = obs in 1/60
gen marker2 = obs in 1/60


cap drop ctextid1 ctextid2

gen ctextid1=""
gen ctextid2=""

replace ctextid2="B" in 10
replace ctextid2="L" in 11
replace ctextid2="A" in 12
replace ctextid2="C" in 13
replace ctextid2="K" in 14
replace ctextid2="S" in 15

replace ctextid2="L" in 17
replace ctextid2="I" in 18
replace ctextid2="V" in 19
replace ctextid2="I" in 20
replace ctextid2="N" in 21
replace ctextid2="G" in 22

replace ctextid2="I" in 24
replace ctextid2="N" in 25

replace ctextid2="T" in 27
replace ctextid2="H" in 28
replace ctextid2="E" in 29

replace ctextid1="C" in 31
replace ctextid1="O" in 32
replace ctextid1="U" in 33
replace ctextid1="N" in 34
replace ctextid1="T" in 35
replace ctextid1="R" in 36
replace ctextid1="Y" in 37

replace ctextid1="A" in 39
replace ctextid1="N" in 40
replace ctextid1="D" in 41

replace ctextid1="V" in 43
replace ctextid1="I" in 44
replace ctextid1="L" in 45
replace ctextid1="L" in 46
replace ctextid1="A" in 47
replace ctextid1="G" in 48
replace ctextid1="E" in 49
replace ctextid1="S" in 50


gen textx = .
gen texty = .
gen textt = ""

replace textx =  0 		in 1
replace texty =  0 		in 1
replace textt = "734,952" in 1

replace textx =  -3 	in 2
replace texty =  13.65 	in 2
replace textt = "78,139 BLACKS IN CITIES" in 2

replace textx =  -3 	in 3
replace texty =  13.35 	in 3
replace textt = "OF OVER 10,000 INHABITANTS" in 3

replace textx =  2.25 	in 4
replace texty =  13.5   in 4
replace textt = "8,025" in 4

replace textx =  3.9 	in 5
replace texty =  13.65  in 5
replace textt = "BLACKS IN CITIES" in 5

replace textx =  4.2 	in 6
replace texty =  13.35  in 6
replace textt = "FROM 5,000 TO 10,000" in 6

replace textx =  1.1 	in 7
replace texty =  12  	in 7
replace textt = "37,699" in 7

replace textx =  1.1 	in 8
replace texty =  11.7  	in 8
replace textt = "BLACKS" in 8

replace textx =  1.1 	in 9
replace texty =  11.4  	in 9
replace textt = "IN CITIES" in 9

replace textx =  1.1 	in 10
replace texty =  11.1  	in 10
replace textt = "FROM" in 10

replace textx =  1.1 	in 11
replace texty =  10.8  	in 11
replace textt = "2,500 TO 5,000" in 11


*** graph here


local curvetext
local curvetext2

forval x = 1/60 {
    
	summ theta if obs==`x'
	local angle = (`r(mean)' * (180 / _pi) ) - 90
	*display `angle'
	
	local curvetext   `curvetext'  (scatter py1 px1 if obs==`x', mc(none) ms(point) mlabangle(`angle') mlab(ctextid1) mlabpos(0) mlabc(gs6) mlabsize(*0.8)) ||
	
	local curvetext2 `curvetext2'  (scatter py2 px2 if obs==`x', mc(none) ms(point) mlabangle(`angle') mlab(ctextid2) mlabpos(0) mlabc(gs6) mlabsize(*0.8)) ||
}


graph set window fontface "Rajdhani"

    twoway	///
		(scatter texty textx in 2/12, mc(none) ms(point) mlab(textt) mlabpos(0) mlabc(gs6) mlabsize(*0.7)) ///
		(scatter texty textx in 1, mc(none) ms(point) mlab(textt) mlabpos(0) mlabc(gs6) mlabsize(*1.2)) ///
		`curvetext' 	///
		`curvetext2' 	///
			(area y5 x5, nodropbase fi(100) fc("46 139 87") 		lc(black) lw(0.06)) ///
			(area y4 x4, nodropbase fi(100) fc("30 144 255") 	lc(black) lw(0.06)) ///
			(area y3 x3, nodropbase fi(100) fc("255 215 0") 	lc(black) lw(0.06)) ///
			(area y2 x2, nodropbase fi(100) fc("220 20 60") 			lc(black) lw(vvthin)) ///		
			(line y1 x1, lc("220 20 60") lw(1.4) lp(solid)) ///
				,    ///
					legend(off) 	///
					xlabel(-7(1)6, nogrid)	ylabel(-5(1)16, nogrid)	///
					xscale(off) yscale(off)	///
					aspect(1.6) ///
					xsize(2) ysize(3) ///
					title("{fontface Rajdhani SemiBold: CITY AND RURAL POPULATION.}" "{fontface Rajdhani SemiBold: 1890.}", size(4.5)) ///
					note("#DuBoisChallenge Nr. 6 made with Stata. Source: https://github.com/ajstarks/dubois-data-portraits Plate 11." "By Asjad Naqvi (asjadnaqvi@gmail.com).", size(1.5)) ///
					graphregion(fcolor("223 209 189")) 

					
	*	graph export "./graphs/DuBois/dubois6_stata_plate11.png", replace wid(5000)		
			
					
	
					
					
					