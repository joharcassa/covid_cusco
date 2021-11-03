
use "${datos}\output\serie_semanal_region.dta", clear

********************************************************************************
* Defunciones
********************************************************************************
* 2020
twoway (line defuncion semana, lcolor("$mycolor2") lwidth(medthick)) ///
(scatter defuncion semana, msize(vsmall) mcolor("$mycolor2") mlabel(defuncion) mlabcolor("$mycolor3") mlabsize(tiny) connect() xline(52, lcolor("$mycolor1") lpattern(longdash) lwidth(thick))) ///
if semana >=11 & semana<=53, ///
	ylabel(0(50)200, labsize(*0.6)) ///
	tlabel(1(4)53) ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("Defunciones") ///
	graphregion(color(white)) ///
	legend(off) ///
	title("2020", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(defunciones20_20, replace)
 
* 2021
twoway (line defuncion semana_2, lcolor("$mycolor2") lwidth(medthick)) ///
(scatter defuncion semana_2, msize(vsmall) mcolor("$mycolor2") mlabel(defuncion) mlabcolor("$mycolor3") mlabsize(tiny) connect() xline(1, lcolor("$mycolor1") lpattern(shortdash) lwidth(thick)) xline(13, lcolor("$mycolor2") lpattern(shortdash) lwidth(thick)) xline(15, lcolor("$mycolor3") lpattern(shortdash) lwidth(thick)) xline(23, lcolor("$mycolor4") lpattern(dash_dot) lwidth(thick))) ///
 if semana_2 >=1 & semana_2<=$semana, ///
	ylabel(0(50)200, labsize(*0.6)) ///
	tlabel(1(4)53) ///
	ytitle("") ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	graphregion(color(white)) ///
	legend(off) ///
	title("2021", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(defunciones20_21, replace)

* 2020 y 2021
graph combine defunciones20_20 defunciones20_21, ///
graphregion(color(white)) ///
name(defunciones_20_21, replace)

gr export "figuras\defunciones_20_21.png", as(png) replace
gr export "figuras\defunciones_20_21.pdf", as(pdf) name("defunciones_20_21") replace


* Tasas de Crecimiento Semanal 2021
twoway (line defuncion_d semana_2, lcolor("$mycolor2") lwidth(medthick) lpattern(longdash)) ///
(scatter defuncion_d semana_2, msize(vsmall) mcolor("$mycolor2") mlabel(defuncion_d) mlabcolor("$mycolor2") mlabsize(tiny) connect() xline(1, lcolor("$mycolor1") lpattern(shortdash) lwidth(thick)) xline(13, lcolor("$mycolor2") lpattern(shortdash) lwidth(thick)) xline(15, lcolor("$mycolor3") lpattern(shortdash) lwidth(thick)) xline(23, lcolor("$mycolor4") lpattern(dash_dot) lwidth(thick))) ///
 if semana_2 >=1 & semana_2<=$semana, ///
	ylabel(-100(20)100, labsize(*0.6)) ///
	tlabel(1(4)53) ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("% Crecimiento de Defunciones") ///
	graphregion(color(white)) ///
	title("2021", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	legend(off) ///
	name(defunciones20_21, replace)

gr export "figuras\defunciones_crecimiento_2021.png", as(png) replace
gr export "figuras\defunciones_crecimiento_2021.pdf", as(pdf) name("defunciones20_21") replace

********************************************************************************
* Casos
********************************************************************************

* 2020
twoway (line positivo semana, lcolor("$mycolor6") lwidth(medthick)) ///
(scatter positivo semana, msize(vsmall) mcolor("$mycolor6") mlabel(positivo) mlabcolor("$mycolor6") mlabsize(tiny) connect() xline(52, lcolor("$mycolor1") lpattern(longdash) lwidth(thick))) ///
if semana >=11 & semana<=53, ///
	ylabel(0(2000)9000, labsize(*0.6)) ///
	tlabel(1(4)53) ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("Casos") ///
	graphregion(color(white)) ///
	legend(off) ///
	title("2020", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(positivos20_20, replace)

* 2021

twoway (line positivo semana_2, lcolor("$mycolor6") lwidth(medthick)) ///
(scatter positivo semana_2, msize(vsmall) mcolor("$mycolor6") mlabel(positivo) mlabcolor("$mycolor6") mlabsize(tiny) connect() xline(1, lcolor("$mycolor1") lpattern(shortdash) lwidth(thick)) xline(13, lcolor("$mycolor2") lpattern(shortdash) lwidth(thick)) xline(15, lcolor("$mycolor3") lpattern(shortdash) lwidth(thick)) xline(23, lcolor("$mycolor4") lpattern(dash_dot) lwidth(thick))) ///
if semana_2 >=1 & semana_2<=$semana, ///
	ylabel(0(2000)9000, labsize(*0.6)) ///
	tlabel(1(4)53) ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("") ///
	graphregion(color(white)) ///
	legend(off)  ///
	title("2021", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(positivos20_21, replace)

* 2020 y 2021
graph combine positivos20_20 positivos20_21, ///
	graphregion(color(white)) ///
name(positivos_20_21, replace)

gr export "figuras\positivos_20_21.png", as(png) replace
gr export "figuras\positivos_20_21.pdf", as(pdf) name("positivos_20_21") replace

********************************************************************************
* Tasas de Crecimiento Semanal 2021
  
twoway (line positivo_d semana_2, lcolor("$mycolor6") lwidth(medthick) lpattern(longdash)) ///
(scatter positivo_d semana_2, msize(vsmall) mcolor("$mycolor6") mlabel(positivo_d) mlabcolor("$mycolor6") mlabsize(tiny) connect() xline(1, lcolor("$mycolor1") lpattern(shortdash) lwidth(thick)) xline(13, lcolor("$mycolor2") lpattern(shortdash) lwidth(thick)) xline(15, lcolor("$mycolor3") lpattern(shortdash) lwidth(thick)) xline(23, lcolor("$mycolor4") lpattern(dash_dot) lwidth(thick))) ///
 if semana_2 >=1 & semana_2<=$semana, ///
	ylabel(-100(20)100, labsize(*0.6)) ///
	tlabel(1(4)53) ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("% Crecimiento de Casos") ///
	graphregion(color(white)) ///
	title("2021", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(off) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(positivos20_21, replace)

gr export "figuras\positivos_crecimiento_2021.png", as(png) replace
gr export "figuras\positivos_crecimiento_2021.pdf", as(pdf) name("positivos20_21") replace

********************************************************************************
* Sintomaticos y asintomaticos
********************************************************************************
* 2020
twoway (line sintomatico semana, lcolor("$mycolor4") lwidth(medthick) lpattern(dot)) ///
(scatter sintomatico semana, msymbol(Th) msize(vsmall) mcolor("$mycolor4") mlabcolor("$mycolor2") mlabsize(tiny) connect()) ///
(line asintomatico semana, lcolor("$mycolor7") lwidth(medthick) lpattern(dot)) ///
(scatter asintomatico semana, msize(vsmall) mcolor("$mycolor7") mlabcolor("$mycolor7") mlabsize(tiny)  msymbol(Sh) connect()) ///
if semana >=11 & semana<=53, ///
	ylabel(0(2000)9000, labsize(*0.6)) ///
	tlabel(1(4)53) ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("Casos") ///
	graphregion(color(white)) ///
	legend(label(1 "Sintomáticos") label(2 "Sintomáticos") label(3 "Asintomáticos") label(4 "Asintomaticos") size(*0.75) region(col(white)))   ///
	title("2020", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(sintomaticos20_20, replace)

* 2021
  
twoway (line sintomatico semana_2, lcolor("$mycolor4") lwidth(medthick) lpattern(dot)) ///
(scatter sintomatico semana_2, msymbol(Th) msize(vsmall) mcolor("$mycolor4") mlabcolor("$mycolor4") mlabsize(tiny) connect()) ///
(line asintomatico semana_2, lcolor("$mycolor7") lwidth(medthick) lpattern(dot)) ///
(scatter asintomatico semana_2, msize(vsmall) mcolor("$mycolor7") mlabcolor("$mycolor7") mlabsize(tiny) msymbol(Sh) connect()) ///
if semana_2 >=1 & semana_2 <=$semana, ///
	ylabel(0(2000)9000, labsize(*0.6)) ///
	tlabel(1(4)53) ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("") ///
	graphregion(color(white)) ///
	legend(label(1 "Sintomáticos") label(2 "Sintomáticos") label(3 "Asintomáticos") label(4 "Asintomaticos") size(*0.75) region(col(white)))   ///
	title("2021", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(sintomaticos20_21, replace)

* 2020 y 2021
graph combine sintomaticos20_20 sintomaticos20_21, ///
graphregion(color(white)) ///
name(sintomaticos_20_21, replace)

gr export "figuras\sintomaticos_20_21.png", as(png) replace
gr export "figuras\sintomaticos_20_21.pdf", as(pdf) name("sintomaticos_20_21") replace

********************************************************************************
* Sintomaticos por tipo de prueba
********************************************************************************
* 2020
twoway (scatter sintomatico_pcr semana, msize(vsmall) mcolor("$mycolor5") msymbol(Th)  connect(dash) lpattern(dash) lcolor("$mycolor5")) ///
(scatter sintomatico_pr_sis semana, msize(vsmall) mcolor("$mycolor6") msymbol(Th)  connect(dash) lpattern(dash) lcolor("$mycolor1")) ///
(scatter sintomatico_ag semana, msize(vsmall) mcolor("$mycolor3") msymbol(Th)  connect(dash) lpattern(dash) lcolor("$mycolor3") ) ///
if semana>=1 & semana<=53, ///
	ylabel(0(200)1000, labsize(*0.6)) ///
	tlabel(1(4)53) ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("Casos sintomáticos", margin(0 4 0 0)) ///
	graphregion(color(white)) ///
	title("2020", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(label(1 "Sintomáticos PCR") label(2 "Sintomáticos PR") label(3 "Sintomaticos AG") size(*0.75) region(col(white))) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(sinto_prueba20_20, replace)

* 2021
  
twoway (scatter sintomatico_pcr semana_2, msize(vsmall) mcolor("$mycolor5") msymbol(Th)  connect(dash) lpattern(dash) lcolor("$mycolor5")) ///
(scatter sintomatico_pr_sis semana_2, msize(vsmall) mcolor("$mycolor6") msymbol(Th)  connect(dash) lpattern(dash) lcolor("$mycolor1")) ///
(scatter sintomatico_ag semana_2, msize(vsmall) mcolor("$mycolor3") msymbol(Th)  connect(dash) lpattern(dash) lcolor("$mycolor3") ) ///
if semana_2>=1 & semana_2<=$semana, ///
	ylabel(0(200)1000, labsize(*0.6)) ///
	tlabel(1(4)53) ///
	xtitle("Semanas Epidemiológicas", size(*0.7)) ///
	ytitle("") ///
	graphregion(color(white)) ///
	title("2021", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(label(1 "Sintomáticos PCR") label(2 "Sintomáticos PR") label(3 "Sintomaticos AG") size(*0.75) region(col(white))) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(sinto_prueba20_21, replace)
	
* 2020 y 2021
graph combine sinto_prueba20_20 sinto_prueba20_21, ///
graphregion(color(white)) ///
name(sinto_prueba_20_21, replace)

gr export "figuras\sinto_prueba_20_21.png", as(png) replace
gr export "figuras\sinto_prueba_20_21.pdf", as(pdf) name("sinto_prueba_20_21") replace

********************************************************************************
* Tasa de Positividad por PCR y AG: 2021
********************************************************************************
* PCR
twoway (bar positivo_pcr semana_2, yaxis(1) ylabel(0(600)600) yscale(range(0(600)600) axis(1) off) bcolor("$mycolor5") /*bfcolor(white) blcolor(black)*/ /*fintensity(inten60)*/  barwidth(0.5 0.8)) ///
(line positividad_pcr semana_2, lcolor("$mycolor6") sort yaxis(2) ylabel(0(10)100, axis(2))) ///
(scatter positivo_pcr semana_2, msymbol(none) mlabel(positivo_pcr) mlabcolor("$mycolor5") mlabsize(*0.65) mlabposition(12))				///
(scatter positividad_pcr semana_2, msymbol(i) mlabel(positividad_pcr) mlabcolor("$mycolor6") mlabsize(*0.65) mlabposition(12)	sort yaxis(2) yscale(range(0) axis(2) off)) ///
if semana_2>=1 & semana_2 <=$semana								///
  ,xtitle("Semanas Epidemiológicas", size(*0.6)) 				///
  xlabel(1(2)$semana, labsize(*0.6)) ///
  graphregion(color(white)) ///
  legend(cols(1) label(1 "Positivos en pruebas moleculares") label(2 " ") label(3 "Tasa de positividad en pruebas moleculares (%)") label (4 " ") size(*0.8) order(1 3) region(lcolor("$mycolor6"))) ///
  title("Pruebas Moleculares", size(*.7) box bcolor("$mycolor6") color(white)) ///
  bgcolor(white) ylabel(, nogrid) ///
  name(pcr, replace)

*graph export "figuras\positividad_pcr.pdf", as(pdf) replace
 
* AG
twoway (bar positivo_ag semana_2, yaxis(1) ylabel(0(600)2200) yscale(range(0(600)2200) axis(1) off) bcolor("$mycolor3") /*bfcolor(white) blcolor(black)*/ /*fintensity(inten60)*/  barwidth(0.5 0.8)) ///
(line positividad_ag semana_2, lcolor("$mycolor4") sort yaxis(2) ylabel(0(10)100, axis(2))) ///
(scatter positivo_ag semana_2, msymbol(none) mlabel(positivo_ag) mlabcolor("$mycolor4") mlabsize(*0.65) mlabposition(12))				///
(scatter positividad_ag semana_2, msymbol(i) mlabel(positividad_ag) mlabcolor(dark) mlabsize(*0.65) mlabposition(12)	sort yaxis(2) yscale(range(0) axis(2) off)) ///
if semana_2>=1 & semana_2 <=$semana									///
  ,xtitle("Semanas Epidemiológicas", size(*0.6)) 				///
  xlabel(1(2)$semana, labsize(*0.6)) ///
  graphregion(color(white)) ///
  legend(cols(1) label(1 "Positivos en pruebas antigénicas") label(2 " ") label(3 "Tasa de positividad en pruebas antigénicas (%)") label (4 " ") size(*0.8) order(1 3) region(lcolor("$mycolor4"))) ///
  title("Pruebas Antigénicas", size(*.7) box bcolor("$mycolor3") color(white)) ///
  bgcolor(white) ylabel(, nogrid) ///
  name(ag, replace)

*graph export "figuras\positividad_ag.pdf", as(pdf) replace

* Combinar figuras y exportar en PDF y PNG
graph combine pcr ag, graphregion(margin(zero)) name(positividad, replace)

gr export "figuras\positividad_ambas.png", as(png) replace
graph export "figuras\positividad_ambas.pdf", as(pdf) replace
 