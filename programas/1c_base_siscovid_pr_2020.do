*-------------------------------------------------------------------------------%

* Programa:				 Limpieza de Datos de Casos COVID-19 por Prueba Rápida 2020 en Cusco
* Primera vez creado:    27 de octubre del 2021
* Ultima actualizaciónb: 27 de octubre del 2021

*-------------------------------------------------------------------------------%

********************************************************************************
* Pruebas Rápidas 2020
********************************************************************************

* Importar la base de datos del  2020
import excel "${datos}\raw\REPORTE_COVID19_2020FI.xlsx", sheet(Hoja1) firstrow clear

* Guardar la base del 2020 con todas sus variables
save "${datos}\output\base_siscovid_pr_2020_total.dta", replace

* Guardar 
*import excel "base\output\base_siscovid_pr_2020_total.xlsx", sheet(Hoja1) firstrow clear
*use "datos\output\base_siscovid_pr_2020_total.dta", clear

* Mantener sólo las variables de interés
keep validos nro_docume fecha_prue resultado resultado1 fecha_inic tiene_sint comun_sexo edad departamen latitud longitud id_ubigeo provincia distrito

* Positivo para identificar los duplicados 
gen positivo_pr = .
replace positivo_pr = 1 if resultado == "IgG POSITIVO" | resultado == "IgG Reactivo" | resultado == "IgM POSITIVO" | resultado == "IgM Reactivo" | resultado == "IgM e IgG POSITIVO" | resultado == "IgM e IgG Reactivo" | resultado == "POSITIVO" | (resultado == "Indeterminado" & (resultado1 == "IgG Reactivo"| resultado1 == "IgM Reactivo" | resultado1 == "IgM e IgG Reactivo"))
replace positivo_pr = 0 if resultado == "NEGATIVO" | resultado == "No Reactivo" | (resultado1 == "Indeterminado" & (resultado1 == "Indeterminado" | resultado1 == "No reactivo"))
tab positivo_pr

gen fecha_pr = fecha_prue  if positivo_pr == 1 | positivo_pr == 0
format fecha_pr %d

* Fecha de inicio de síntoma
split fecha_inic, parse(-) destring
rename (fecha_inic?) (year month day)
gen fecha_inicio_pr = daily(fecha_ini, "YMD") if positivo_pr == 1
format fecha_inicio_pr %td

* Guardar
save "${datos}\output\base_siscovid_pr_2020.dta", replace
