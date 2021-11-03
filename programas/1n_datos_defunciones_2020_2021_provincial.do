
import excel "${datos}\raw\base_sinadef_2020_2021_total.xlsx", firstrow clear

* Provincia
rename PROVINCIADOMICILIO provincia

* Generamos la fecha adecuando al formato conveniente y la ordenamos
gen fecha = mdy(MES, DIA, AÑO)
format fecha %td

append using "${datos}\temporal\defunciones_totales_region_2019_2020.dta", force
sort fecha

* Identificador 

gen var_id = _n

* Para identificar los migrantes
rename provincia provincia_vivienda

gen provincia_reside = .
replace provincia_reside = 1 if provincia_vivienda == "ACOMAYO"
replace provincia_reside = 2 if provincia_vivienda == "ANTA"
replace provincia_reside = 3 if provincia_vivienda == "CALCA"
replace provincia_reside = 4 if provincia_vivienda == "CANAS"
replace provincia_reside = 5 if provincia_vivienda == "CANCHIS"
replace provincia_reside = 6 if provincia_vivienda == "CHUMBIVILCAS"
replace provincia_reside = 7 if provincia_vivienda == "CUSCO"
replace provincia_reside = 8 if provincia_vivienda == "ESPINAR"
replace provincia_reside = 9 if provincia_vivienda == "LA CONVENCION"
replace provincia_reside = 10 if provincia_vivienda == "PARURO"
replace provincia_reside = 11 if provincia_vivienda == "PAUCARTAMBO"
replace provincia_reside = 12 if provincia_vivienda == "QUISPICANCHI"
replace provincia_reside = 13 if provincia_vivienda == "URUBAMBA"
replace provincia_reside = 14 if provincia_reside == . 
*tab provincia_reside

label define provincia_reside 1 "ACOMAYO" 2 "ANTA" 3 "CALCA" 4 "CANAS" 5 "CANCHIS" 6 "CHUMBIVILCAS" 7 "CUSCO" 8 "ESPINAR" 9 "LA CONVENCION" 10 "PARURO" 11 "PAUCARTAMBO" 12 "QUISPICANCHI" 13 "URUBAMBA" 14 "OTROS"
label values provincia_reside provincia_reside
*tab provincia_reside

* Indicador de defunciones por COVID
gen defuncion =.
replace defuncion = 1
replace defuncion = 0 if defuncion == .

*tab provincia_reside if defuncion == 1 | defuncion == 0 

keep if defuncion == 1 

*save "D:\covid_cusco\datos\output\exceso_provincias_2020.dta", replace

forvalues t = 1/13 {

********************************************************************************
* Defunciones 

preserve 

keep if provincia_reside == `t'

collapse (count) var_id, by(fecha)

rename var_id d20_`t'

tsset fecha, daily
tsfill

save "${datos}\temporal\defuncion_provincias_2020_`t'.dta", replace

restore
}

use "${datos}\temporal\defuncion_provincias_2020_1.dta", clear

forvalues i=2/13 {
merge 1:1 fecha using "${datos}\temporal\defuncion_provincias_2020_`i'.dta"
drop _merge 
}

recode * (.=0)

*save "datos\output\exceso_provincias_2020.dta", replace

*use "${data}/exceso_provincias_2020.dta", clear

*display date("2020-01-11", "YMD")

* Generamos datos semanales
gen semana = .
replace semana = 1 if fecha >= d(29dec2019) & fecha <= d(04jan2020)
replace semana = semana[_n-7] + 1 if fecha > d(04jan2020)

* Generar las semanas epidemiológicas del 2021
gen semana_2 = .
replace semana_2 = semana - 53
replace semana_2 = . if semana_2 < 0

* Máximo número de semanas del 2020, 53
replace semana = . if semana >53

* Datos del 2020
preserve
collapse (sum) d20_*, by(semana)
save "${datos}\temporal\defuncion_semanal_provincias_2020", replace
restore 

* Datos del 2021
preserve
collapse (sum) d20_*, by(semana_2)
rename semana_2 semana

forvalues i=1/13 {
rename d20_`i' d21_`i'
}
save "${datos}\temporal\defuncion_semanal_provincias_2021", replace
restore 

use "${datos}\temporal\defuncion_semanal_provincias_2020", clear
merge 1:1 semana using "${datos}\temporal\defuncion_semanal_provincias_2021", nogen
drop if semana > 53 | semana == 0

* Guardar la base de datos
save "${datos}\output\defunciones_totales_provincias_2020_2021.dta", replace
