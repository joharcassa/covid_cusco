*-------------------------------------------------------------------------------%

* Programa: Limpieza de datos COVID-19 en la Región Cusco a nivel provincial

* Primera vez creado:     29 de marzo del 2021
* Ultima actualizaciónb:  29 de marzo del 2021

*-------------------------------------------------------------------------------%

use "${datos}\output\base_covid.dta", clear

* MODIFICAR
drop if dni == "75751020"
drop if provincia_ubigeo == "9999"

recode positivo* (0=.)
recode sintomatico* (0=.)
recode defuncion (0=.)

destring provincia_ubigeo, replace

* Fecha de resultado
preserve
collapse (first) provincia (count) positivo positivo_pcr positivo_ag positivo_pr prueba prueba_ag prueba_pcr prueba_pr sintomatico sintomatico_pcr sintomatico_ag sintomatico_pr defuncion, by(fecha_resultado provincia_ubigeo)

xtset provincia_ubigeo fecha_resultado, daily
tsfill

sort provincia_ubigeo fecha_resultado
rename fecha_resultado fecha

replace fecha = . if fecha < d(01jan2020)

tempfile prov_fecha_resultado
save "`prov_fecha_resultado'"
restore 

* Fecha de recuperado
preserve
collapse (count) positivo, by(fecha_recuperado provincia_ubigeo)

xtset provincia_ubigeo fecha_recuperado, daily
tsfill

sort  fecha_recuperado
rename fecha_recuperado fecha
rename positivo recuperado

replace fecha = . if fecha < d(01jan2020)

tempfile prov_fecha_recuperado
save "`prov_fecha_recuperado'"
restore 

* Fecha_inicio de síntomas
preserve
collapse (count) positivo positivo_pcr positivo_ag positivo_pr, by(fecha_inicio provincia_ubigeo)

xtset provincia_ubigeo fecha_inicio, daily
tsfill

sort fecha_inicio
rename fecha_inicio fecha
rename positivo inicio
rename positivo_pcr inicio_pcr
rename positivo_ag inicio_ag
rename positivo_pr inicio_pr

replace fecha = . if fecha < d(01jan2020)

tempfile prov_fecha_inicio
save "`prov_fecha_inicio'"
restore 

* Merge
use "`prov_fecha_resultado'", clear
merge 1:1 fecha provincia_ubigeo using "`prov_fecha_inicio'", nogenerate  
merge 1:1 fecha provincia_ubigeo using "`prov_fecha_recuperado'", nogenerate 
sort provincia_ubigeo fecha

* Exportar la data
save "${datos}\output\data_panel_provincial.dta", replace