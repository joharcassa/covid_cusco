*-------------------------------------------------------------------------------%

* Programa: Limpieza de Datos de Casos COVID-19 por Prueba Molecular en Cusco

* Primera vez creado:     29 de marzo del 2021
* Ultima actualizaciónb:  30 de mayo del 2021

*-------------------------------------------------------------------------------%

********************************************************************************
* 4. Datos de Defunciones
********************************************************************************
* 2020

* Importar la base de datos
import excel "${datos}\raw\base_sinadef_2021.xlsx", sheet("DATA") firstrow clear

keep if DEPARTAMENTO == "CUSCO"

drop if Nº == .

drop if ESTADO == "ANULACIÓN SOLICITADA" | ESTADO == "ANULADO"

gen distrito = DISTRITORESDIDENCIAHABITUAL
gen departamento = DEPARTAMENTO
gen direccion = DIRECCIONDEDOMICILIO
*gen provincia = PROVINCIADERESIDENCIAHABITUAL

append using "${datos}\output/base_sinadef_2020.dta", force

* Generar la variable de identificación
rename DOCUMENTO dni

destring MES, replace force
destring AÑO, replace force 
gen fecha_sinadef = mdy(MES,DIA,AÑO)
format fecha_sinadef %td

* Indicador de defunciones por COVID
gen defuncion =.
replace defuncion = 1
replace defuncion = 0 if defuncion == .

* Juntar 
merge m:1 distrito using "${datos}\output\ubigeos.dta"

* Otras variables relevantes para que sean similares a la base NOTICOVID y SISCOVID
rename SEXO sexo
*rename EDAD edad
*destring edad, replace

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

keep dni fecha_sinadef defuncion sexo edad distrito departamento provincia ubigeo direccion

* Guardar temporalmente
*tempfile data_sinadef
*save "`data_sinadef'", replace

save "${datos}\output\base_sinadef.dta", replace