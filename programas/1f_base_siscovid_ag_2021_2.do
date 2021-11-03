*-------------------------------------------------------------------------------%

* Programa:				 Limpieza de Datos de Casos COVID-19 por Prueba Antigénica 2021 en Cusco
* Primera vez creado:    27 de octubre del 2021
* Ultima actualizaciónb: 27 de octubre del 2021

*-------------------------------------------------------------------------------%

********************************************************************************
* 3. Pruebas Antigenicas
********************************************************************************

* Importar la base de julio hasta la fecha actual 
import excel "${datos}\raw\base_siscovid_ag_2021_2.xlsx", sheet("Hoja1") firstrow clear

* Mantener las variables de interés
keep NroDocumento  Departamento Resultado ResultadoSegundaPrueba FechaEjecucionPrueba FechaInicioSintomasdelaFich Edad comun_sexo_paciente TieneSintomas Latitud Longitud Direccion id_ubigeo Provincia Distrito cod_establecimiento_ejecuta

* Juntar con la base de enero a junio
append using "${datos}\temporal\base_siscovid_ag_enero_junio"

* 3.1 Variable de Identificación
rename NroDocumento dni
sort dni
duplicates report dni
duplicates tag dni, gen(repe_ag)
quietly by dni: gen repeti_ag = cond(_N==1,0,_n)

* 3.2 Variables Demográficas 
keep if Departamento == "Cusco"
gen departamento = Departamento
gen distrito = Distrito
gen provincia = Provincia

rename id_ubigeo ubigeo

gen latitud = Latitud
gen longitud = Longitud
gen direccion = Direccion

destring Edad, force replace
gen edad = Edad

gen sexo = comun_sexo_paciente

* 3.3  Variables Epidemiológicas

* Generar positivos por AG
gen positivo_ag=.
replace positivo_ag = 1 if Resultado == "Reactivo" | ((Resultado == "Inválido" |Resultado == "Indeterminado") & ResultadoSegundaPrueba == "Reactivo")
replace positivo_ag = 0 if Resultado == "No Reactivo" | ((Resultado == "Inválido" |Resultado == "Indeterminado") & ResultadoSegundaPrueba == "No Reactivo")
*tab positivo_ag

*gen fecha_antigenica = FechaPrueba 
gen fecha_antigena = FechaEjecucionPrueba
split fecha_antigena, parse(-) destring
rename (fecha_antigena?) (year month day)
gen fecha_ag = daily(fecha_antigena, "YMD") if positivo_ag == 1 | positivo_ag == 0
format fecha_ag %td

split FechaInicioSintomasdelaFich, parse(-) destring
rename (FechaInicioSintomasdelaFich?) (year1 month1 day1)
gen fecha_inicio_ag = daily(FechaInicioSintomasdelaFich, "YMD")  if positivo_ag == 1
format fecha_inicio_ag %td
*borrar fecha de inicio menos que el 2020 primero de enero
replace fecha_inicio_ag = . if fecha_inicio_ag < 21915

gen fecha_inicio = fecha_inicio_ag
format fecha_inicio %td

gen sintomatico =.
replace sintomatico = 1 if (TieneSintomas == "SI"  & positivo_ag == 1) 
replace sintomatico = 0 if ( TieneSintomas == "NO" & positivo_ag ==1 )
label variable sintomatico "Tiene sintoma antigenica"
label define sintomatico 0 "No" 1 "Si"
label values sintomatico sintomatico
tab sintomatico

gen sintomatico_ag = sintomatico

* 3.4 Borrar duplicados
duplicates report dni positivo_ag fecha_ag
duplicates drop dni positivo_ag fecha_ag, force

keep if positivo_ag == 1 | positivo_ag == 0

drop if fecha_ag == .
drop if positivo_ag == .

*merge m:1 ubigeo using "datos\output\ubigeos.dta"

* Código de establecimiento
gen codigo_red = cod_establecimiento_ejecuta
sort codigo_red
*merge m:1 codigo_red using "datos\output\codigo_establecimiento"

keep dni positivo_ag fecha_ag fecha_inicio_ag fecha_inicio edad sexo departamento  distrito sintomatico sintomatico_ag provincia ubigeo latitud longitud direccion

drop if dni == ""

* 3.5 Guardar 
save "${datos}\output\base_siscovid_ag.dta", replace
