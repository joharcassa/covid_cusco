*-------------------------------------------------------------------------------%

* Programa: Limpieza de Datos de Casos COVID-19 por Prueba Molecular en Cusco

* Primera vez creado:     29 de marzo del 2021
* Ultima actualizaciónb:  30 de mayo del 2021

*-------------------------------------------------------------------------------%

********************************************************************************
* 4. Datos de Defunciones
********************************************************************************
* 2020
import excel "${datos}\raw\base_sinadef_2020.xlsx", sheet("Data1") firstrow clear

drop if DIAGNOSTICO == "NO COVID"
drop if AÑO == .

drop if ESTADO == "ANULACIÓN SOLICITADA" | ESTADO == "ANULADO"


*gen provincia = PROVINCIADERESIDENCIAHABITUAL
gen distrito = DISTRITORESDIDENCIAHABITUAL
gen departamento = DEPARTAMENTODOMICILIO
gen direccion = DIRECCIONDEDOMICILIO

keep if DEPARTAMENTO == "CUSCO"
keep if AÑO == 2020

* Distrito
*gen distrito = DISTRITOHABITUALRESIDENCIA

save "${datos}\output\base_sinadef_2020.dta", replace 
