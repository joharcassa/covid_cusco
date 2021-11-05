*-------------------------------------------------------------------------------%

* Programa: Generar Series de Tiempo de las Provincias

* Primera vez creado:     02 de junio del 2021
* Ultima actualizaciónb:  06 de julio del 2021.

*-------------------------------------------------------------------------------%

* Importar la base de datos
use "${datos}\output\base_covid.dta", clear

forvalues i=1/13 {

preserve
keep if provincia_residencia == `i'

collapse (sum) positivo defuncion positivo_pcr positivo_ag prueba_pcr prueba_ag, by(fecha_resultado)

tsset fecha_resultado, daily
tsfill

rename positivo positivo_`i'
rename defuncion defuncion_`i'
rename positivo_pcr positivo_pcr_`i'
rename positivo_ag positivo_ag_`i'
rename prueba_pcr prueba_pcr_`i'
rename prueba_ag prueba_ag_`i'

save "${datos}\temporal\provincia_`i'", replace
restore 
}

use "${datos}\temporal\provincia_1", clear

forvalues j=2/13 {
merge 1:1 fecha_resultado using "${datos}\temporal\provincia_`j'", nogen
}

drop if fecha_resultado < d(13mar2020)
drop if fecha_resultado == .

drop if fecha_resultado > d($fecha)

recode * (.=0)

* Guardar 2020 y 2021
save "${datos}\output\data_series_provincias_2020_2021", replace

* Eliminar de la memoria temporal
forvalues i=1/13{
	erase "${datos}\temporal\provincia_`i'.dta"
}

* Mantener sólo del 2021
keep if fecha_resultado >= d(01jan2021)

forvalues i=1/13{
gen total_positivo_`i' = sum(positivo_`i')
gen total_defuncion_`i' = sum(defuncion_`i')
}

* Guardar 2021
save "${datos}\output\data_series_provincias_2021", replace