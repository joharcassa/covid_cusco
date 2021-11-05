*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
*Program: 		Data Visualization (Positividad Diaria)
*first created: 02/06/2021
*last updated:  04/05/2021
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%	

* Cargamos la data, previamente se hizo la limpieza en Excel (es un atarea hacerlo aquí).
	
use "${datos}\output\data_series_region.dta", clear

*use "D:\covid_cusco\datos\output\data_series_region.dta", clear

* Para dias a inicios de semana
drop if fecha < d(01jan2021)

*rename fecha_resultado fecha 

gen numero = _n
*replace semana = 11 if fecha == 21987 | fecha == 21988
*replace semana = 12 if fecha > 21988 & fecha <= 21995

gen semana =.
replace semana = 1 if numero >= 1 & numero <= 7
 
replace semana = semana[_n-7] + 1 if numero > 7

*collapse (mean) positivo positivo_pcr positivo_pr positivo_ag prueba prueba_pcr prueba_pr prueba_ag, by(semana)

*recode positivo* (0=.)

collapse (mean) positivo_pcr positivo_ag  prueba_pcr prueba_ag, by(semana)

*drop if positivo == 0

*save "${datos}\output\data_diaria_acumulado.dta", replace

*use "datos\output\data_diaria_acumulado.dta", clear

label var semana "Semana Epidemiológica"

*drop if semana < 53

*replace semana = _n 

drop if semana > $semana

* Generamos las variables pertinentes.

*gen positividad = positivo/prueba*100
gen positividad_pcr = positivo_pcr/prueba_pcr*100
*gen positividad_pr = positivo_pr/prueba_pr*100
gen positividad_ag = positivo_ag/prueba_ag*100

format positividad_pcr positividad_pcr %12.0fc
format positividad_pcr positividad_ag %12.0fc


* Graficamos
twoway (line positividad_pcr semana, lcolor("$mycolor6") lwidth(medthick)) ///
(line positividad_ag semana, lcolor("$mycolor7") lwidth(medthick)) ///
(scatter positividad_pcr semana, msymbol(none) mlabel(positividad_pcr) mlabcolor("$mycolor6") mlabsize(*0.9) mlabposition(12)) ///
(scatter positividad_ag semana, msymbol(i) mlabel(positividad_ag) mlabcolor("$mycolor7") mlabsize(*0.9) mlabposition(12)) ///
  ,  ysize(5) xsize(6.1) ///
  xtitle("Semanas Epidemiológicas", size(*0.6)) ///
  ytitle("Tasa de Positividad (%)", size(*0.6)) ///
  ylabel(0(10)60, labsize(*0.60)) ///
  xlabel(1(2)$semana, labsize(*0.60)) ///
  plotregion(fcolor(white) lcolor(white)) ///
  graphregion(fcolor(white) lcolor(white)) ///
  bgcolor(white) ///
  ylabel(, nogrid) xlabel(, nogrid) ///
  legend(cols(2) label(1 "Positividad PCR (%)") label(2 "Positividad AG (%)") label(3 " ") label (4 " ") size(*0.6) order(1 2 3 4) region(fcolor(white) lcolor(white))) ///
  text(5 $semana "{it:Acualizado al}" "{it:$fecha}", place(sw) box just(left) margin(l+4 t+1 b+1) width(21) size(small) color(white) bcolor("$mycolor4") fcolor("$mycolor4")) name(tasa_pos, replace)
  
graph export "figuras\positividad_diaria.png", as(png) replace  
