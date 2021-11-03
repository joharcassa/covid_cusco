
* 
use "${datos}\output\serie_semanal_provincias.dta", clear

* Mantener sólo las semanas del 2021
keep if semana_2 != .

* Sumar por semanas en términos de defunciones de cada provincia
collapse (sum) defuncion*, by(semana_2)

* Mantener las últimas 9 semanas
drop if semana > $semana
drop if semana < $semana - 8 

* Transponer para hacer una la tabla en MS Excel
xpose, varname clear 