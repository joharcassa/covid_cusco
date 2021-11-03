*-------------------------------------------------------------------------------%

* Programa:				 Limpieza de Datos de Casos COVID-19 por Prueba Rápida 2021 en Cusco
* Primera vez creado:    27 de octubre del 2021
* Ultima actualizaciónb: 27 de octubre del 2021

*-------------------------------------------------------------------------------%

********************************************************************************
* 2. Pruebas Rápidas
********************************************************************************

* Importar la base de datos del SISCOVID 2021
import excel "${datos}\raw\base_siscovid_pr_2021.xlsx", sheet(Hoja1) firstrow clear

* Mantener las variables de interés
keep NroDocumento VALIDOS Resultado1 FechaInicioSintomasPaciente Edad comun_sexo_paciente TieneSintomas Departamento Distrito Latitud Longitud Direccion FechaPrueba id_ubigeo Provincia

* Renombrar las variables para que coincidan con las variables de la misma base pero del 2020
rename NroDocumento nro_docume
rename VALIDOS validos
rename Resultado1 resultado1
rename FechaInicioSintomasPaciente fecha_inic
rename Edad edad
rename comun_sexo_paciente comun_sexo
rename TieneSintomas tiene_sint
rename Departamento departamen
rename Provincia provincia
rename Distrito distrito
rename Latitud latitud
rename Longitud longitud
rename Direccion direccion

split FechaPrueba, parse(-) destring
rename (FechaPrueba?) (year month day)
gen fecha_pr = daily(FechaPrueba, "YMD")
format fecha_pr %td

* Positivo para identificar los duplicados 
gen positivo_pr = .
replace positivo_pr = 1 if resultado == "IgG POSITIVO" | resultado == "IgG Reactivo" | resultado == "IgM POSITIVO" | resultado == "IgM Reactivo" | resultado == "IgM e IgG POSITIVO" | resultado == "IgM e IgG Reactivo" | resultado == "POSITIVO" | (resultado == "Indeterminado" & (resultado1 == "IgG Reactivo"| resultado1 == "IgM Reactivo" | resultado1 == "IgM e IgG Reactivo"))
replace positivo_pr = 0 if resultado == "NEGATIVO" | resultado == "No Reactivo" | (resultado1 == "Indeterminado" & (resultado1 == "Indeterminado" | resultado1 == "No reactivo"))
tab positivo_pr

* Convertir la 'fecha de resultado' en el formato que lea la variable
gen fecha_pr_sis = fecha_pr  if positivo_pr == 1 | positivo_pr == 0
format fecha_pr_sis %d

* Fecha de inicio de síntoma
split fecha_inic, parse(-) destring
rename (fecha_inic?) (year1 month1 day1)
gen fecha_inicio_pr = daily(fecha_ini, "YMD") if positivo_pr == 1
format fecha_inicio_pr %td
replace fecha_inicio_pr = . if fecha_inicio_pr < 21915

gen fecha_inicio = fecha_inicio_pr 
format fecha_inicio %td

* Unir con la base de datos (con las mismas variables) del 2020
append using "${datos}/output/base_siscovid_pr_2020.dta", force

********************************
* 2.1 Variable de identificación
gen dni = nro_docume
sort dni
duplicates report dni
duplicates tag dni, gen(repe_sis)
quietly by dni: gen repeti_sis = cond(_N==1,0,_n)

* 2.2 Vairables demográficas
gen departamento = departamen 
destring edad, replace
rename comun_sexo sexo
rename id_ubigeo ubigeo

* 2.3 Variables Epidemiológicas

* IgM IgG y mixto
rename resultado1 tipo_anticuerpo

* Sintomático
gen sintomatico =.
replace sintomatico = 1 if (tiene_sint == "SI" & positivo_pr ==1)
replace sintomatico = 0 if (tiene_sint == "NO" & positivo_pr ==1)
label variable sintomatico "Tiene sintoma rapida"
label define sintomatico 0 "No" 1 "Si"
label values sintomatico sintomatico
tab sintomatico

gen sintomatico_pr_sis = sintomatico

* 2.4 Eliminar 
* Eliminar si no tiene resultado o no tiene fecha de resultado
drop if positivo_pr == .
drop if fecha_pr == .

keep if positivo_pr == 0 | positivo_pr == 1

*merge m:1 ubigeo using "datos\output\ubigeos.dta"

keep dni positivo_pr fecha_pr fecha_inicio edad sexo departamento distrito direccion sintomatico sintomatico_pr tipo_anticuerpo distrito provincia ubigeo latitud longitud 

* 2.5 Guardar
save "${datos}\output\base_siscovid_pr.dta", replace
