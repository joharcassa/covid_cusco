*-------------------------------------------------------------------------------%

* Programa: Limpieza de datos COVID-19 en la Región Cusco

* Primera vez creado:     29 de marzo del 2021
* Ultima actualizaciónb:  06 de julio del 2021

*-------------------------------------------------------------------------------%

********************************************************************************
	
use "${datos}/output/base_covid.dta", clear

tempfile dpto_fecha_resultado dpto_fecha_recuperado dpto_fecha_inicio

* Recodificar
recode positivo* (0=.)
recode sintomatico* (0=.)

* Fecha de resultado
preserve
collapse (count) positivo positivo_pcr positivo_ag positivo_pr prueba prueba_ag prueba_pcr prueba_pr sintomatico sintomatico_pcr sintomatico_ag sintomatico_pr defuncion, by(fecha_resultado)
sort fecha_resultado
rename fecha_resultado fecha

tempfile dpto_fecha_resultado
save "`dpto_fecha_resultado'"
restore 

* Fecha de recuperado
preserve
collapse (count) positivo, by(fecha_recuperado)
sort  fecha_recuperado
rename fecha_recuperado fecha
rename positivo recuperado

tempfile dpto_fecha_recuperado
save "`dpto_fecha_recuperado'"
restore 

* Fecha_inicio de síntomas
preserve
collapse (count) positivo positivo_pcr positivo_ag positivo_pr, by(fecha_inicio)
sort fecha_inicio
rename fecha_inicio fecha
rename positivo inicio
rename positivo_pcr inicio_pcr
rename positivo_ag inicio_ag
rename positivo_pr inicio_pr

tempfile dpto_fecha_inicio
save "`dpto_fecha_inicio'"
restore 

* Merge
use "`dpto_fecha_resultado'", clear
merge 1:1 fecha using "`dpto_fecha_inicio'", nogenerate  
merge 1:1 fecha using "`dpto_fecha_recuperado'", nogenerate 
sort fecha

* Generar cumulativos
gen total_positivo = sum(positivo)
gen total_positivo_pcr = sum(positivo_pcr)
gen total_positivo_pr = sum(positivo_pr) 
gen total_positivo_ag = sum(positivo_ag) 
gen total_prueba = sum(prueba)
gen total_prueba_pcr = sum(prueba_pcr)
gen total_prueba_pr = sum(prueba_pr)
gen total_prueba_ag = sum(prueba_ag)
gen total_recuperado = sum(recuperado)
gen total_sintomatico = sum(sintomatico)
gen total_defuncion = sum(defuncion)
gen total_inicio = sum(inicio)
gen total_inicio_pcr = sum(inicio_pcr)
gen total_inicio_pr = sum(inicio_pr)
gen total_inicio_ag = sum(inicio_ag)

gen total_activos = total_positivo - total_recuperado

drop if fecha < d(13mar2020) 

foreach var of varlist total_positivo total_positivo_pcr total_positivo_pr total_prueba total_prueba_pcr total_prueba_ag total_prueba_pr total_recuperado total_sintomatico total_defuncion total_inicio total_inicio_pcr total_inicio_pr total_inicio_ag total_activos {
replace `var' = `var'[_n-1] if `var' ==.
}

recode * (.= 0)

save "${datos}\output\data_series_region.dta", replace
