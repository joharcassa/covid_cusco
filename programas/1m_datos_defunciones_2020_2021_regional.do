*
* Cargar la base de datos del 2020 y 2021
import excel "${datos}\raw\base_sinadef_2020_2021_total.xlsx", firstrow clear

* Borrar los registros que se anularon
drop if ESTADO == "ANULACIÓN SOLICITADA" | ESTADO == "ANULADO"

* Renombrar la provincia
rename PROVINCIADOMICILIO provincia

* Generamos la fecha adecuando al formato conveniente y la ordenamos
gen fecha = mdy(MES, DIA, AÑO)
format fecha %td
sort fecha

* Borramos duplicados de DNI
rename DOCUMENTO dni
sort dni
duplicates report dni
duplicates tag dni, gen(repe_def)
quietly by dni: gen repeti_def = cond(_N==1,0,_n)

set seed 98034
generate u1 = runiform()

tostring u1, replace force
replace dni = u1 if dni == "SIN REGISTRO"
replace dni = u1 if dni == ""
duplicates drop dni, force

append using "${datos}\temporal\defunciones_totales_region_2019_2020.dta", force

* Colapsamos para tener una serie de tiempo diaria
gen numero = _n
collapse (count) numero, by(fecha)
rename numero de_20
tsset fecha, daily
tsfill

* Generamos datos semanales
gen semana = .
replace semana = 1 if fecha >= d(29dec2019) & fecha <= d(04jan2020)
replace semana = semana[_n-7] + 1 if fecha > d(04jan2020)

* Generar las semanas epidemiológicas del 2021
gen numero = _n
gen semana_2 = .
replace semana_2 = semana - 53
replace semana_2 = . if semana_2 < 0

* Máximo número de semanas del 2020, 53
replace semana = . if semana >53

* Datos del 2020
preserve
collapse (sum) de_20, by(semana)
save "${datos}\temporal\defuncion_semanal_region_2020", replace
restore 

* Datos del 2021
preserve
collapse (sum) de_20, by(semana_2)
rename semana_2 semana
rename de_20 de_21
save "${datos}\temporal\defuncion_semanal_region_2021", replace
restore 

use "${datos}\temporal\defuncion_semanal_region_2020", clear
merge 1:1 semana using "${datos}\temporal\defuncion_semanal_region_2021", nogen
drop if semana > 53 | semana == 0

* Guardar la base de datos
save "${datos}\output\defunciones_totales_2020_2021.dta", replace
