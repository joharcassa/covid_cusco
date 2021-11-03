*-------------------------------------------------------------------------------%

* Programa: Figura de la Incidencia y Mortalida a nivel Provincial

* Primera vez creado:     03 de junio del 2021
* Ultima actualizaciónb:  03 de junio del 2021

*-------------------------------------------------------------------------------%

* Importar la base de datos
use "${datos}\output\data_panel_provincial.dta", clear

fillin fecha provincia_ubigeo

* Analizar sólo datos del 2021
keep if fecha >= d(01jan2021)

*keep positivo_* defuncion fecha provincia_ubigeo

* Generar cumulativos
bysort provincia_ubigeo (fecha): gen total_positivo = sum(positivo)
bysort provincia_ubigeo (fecha): gen total_positivo_pcr = sum(positivo_pcr)
bysort provincia_ubigeo (fecha): gen total_positivo_pr = sum(positivo_pr) 
bysort provincia_ubigeo (fecha): gen total_positivo_ag = sum(positivo_ag) 
bysort provincia_ubigeo (fecha): gen total_prueba = sum(prueba)
bysort provincia_ubigeo (fecha): gen total_prueba_pcr = sum(prueba_pcr)
bysort provincia_ubigeo (fecha): gen total_prueba_pr = sum(prueba_pr)
bysort provincia_ubigeo (fecha): gen total_prueba_ag = sum(prueba_ag)
bysort provincia_ubigeo (fecha): gen total_recuperado = sum(recuperado)
bysort provincia_ubigeo (fecha): gen total_sintomatico = sum(sintomatico)
bysort provincia_ubigeo (fecha): gen total_defuncion = sum(defuncion)
bysort provincia_ubigeo (fecha): gen total_inicio = sum(inicio)
bysort provincia_ubigeo (fecha): gen total_inicio_pcr = sum(inicio_pcr)
bysort provincia_ubigeo (fecha): gen total_inicio_pr = sum(inicio_pr)
bysort provincia_ubigeo (fecha): gen total_inicio_ag = sum(inicio_ag)

*************
* OBLIGATORIO
* Modificar la fecha de interés
keep if fecha == d($fecha)

********************************************************************************
* Mortalidad
********************************************************************************

gen mortalidad =.
replace mortalidad = total_defuncion/463656*10000 if provincia_ubigeo == 801
replace mortalidad = total_defuncion/28477*10000 if provincia_ubigeo == 802
replace mortalidad = total_defuncion/57731*10000 if provincia_ubigeo == 803
replace mortalidad = total_defuncion/76462*10000 if provincia_ubigeo == 804
replace mortalidad = total_defuncion/40420*10000 if provincia_ubigeo == 805
replace mortalidad = total_defuncion/105049*10000 if provincia_ubigeo == 806
replace mortalidad = total_defuncion/84925*10000 if provincia_ubigeo == 807
replace mortalidad = total_defuncion/71304*10000 if provincia_ubigeo == 808
replace mortalidad = total_defuncion/185793*10000 if provincia_ubigeo == 809
replace mortalidad = total_defuncion/31264*10000 if provincia_ubigeo == 810
replace mortalidad = total_defuncion/52989*10000 if provincia_ubigeo == 811
replace mortalidad = total_defuncion/92989*10000 if provincia_ubigeo == 812
replace mortalidad = total_defuncion/66439*10000 if provincia_ubigeo == 813


label define provincia_ubigeo 801 "Cusco" 802 "Acomayo" 803 "Anta" 804 "Calca" 805 "Canas" 806 "Canchis" 807 "Chumbivilcas" 808 "Espinar" 809 "La Convención" 810 "Paruro" 811 "Paucartambo" 812 "Quispicanchi" 813 "Urubamba"
label values provincia_ubigeo provincia_ubigeo

graph hbar mortalidad, ysize(5) xsize(6.1)  ///
over(provincia_ubigeo, sort(mortalidad) descending) ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bar(1, color("$mycolor7")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Tasa de Mortalidad (defunciones/población*10,000)") ///
ylabel(, nogrid) ///
text(30 6 "{it:Acualizado al}" "{it:$fecha}", place(sw) box just(left) margin(l+4 t+1 b+1) width(21) size(small) color(white) bcolor("$mycolor7") fcolor("$mycolor7")) name(mortalidad, replace)

* Exportar Figura
graph export "figuras\mortalidad_provincial.png", as(png) replace

********************************************************************************
* Incidencia
********************************************************************************

gen incidencia =.
replace incidencia = total_positivo/463656*10000 if provincia_ubigeo == 801
replace incidencia = total_positivo/28477*10000 if provincia_ubigeo == 802
replace incidencia = total_positivo/57731*10000 if provincia_ubigeo == 803
replace incidencia = total_positivo/76462*10000 if provincia_ubigeo == 804
replace incidencia = total_positivo/40420*10000 if provincia_ubigeo == 805
replace incidencia = total_positivo/105049*10000 if provincia_ubigeo == 806
replace incidencia = total_positivo/84925*10000 if provincia_ubigeo == 807
replace incidencia = total_positivo/71304*10000 if provincia_ubigeo == 808
replace incidencia = total_positivo/185793*10000 if provincia_ubigeo == 809
replace incidencia = total_positivo/31264*10000 if provincia_ubigeo == 810
replace incidencia = total_positivo/52989*10000 if provincia_ubigeo == 811
replace incidencia = total_positivo/92989*10000 if provincia_ubigeo == 812
replace incidencia = total_positivo/66439*10000 if provincia_ubigeo == 813


graph hbar incidencia, ysize(5) xsize(6.1)  ///
over(provincia_ubigeo, sort(incidencia) descending) ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bar(1, color("$mycolor4")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Tasa de Incidencia (casos/población*10,000)") ///
ylabel(, nogrid) ///
text(1000 6 "{it:Acualizado al}" "{it:$fecha}", place(sw) box just(left) margin(l+4 t+1 b+1) width(21) size(small) color(white) bcolor("$mycolor4") fcolor("$mycolor4"))

* Exportar figura
graph export "figuras\incidencia_provincial.png", as(png) replace

