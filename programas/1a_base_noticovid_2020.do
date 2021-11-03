
import excel "${datos}\raw\base_noticovid_2020.xlsx", sheet(BASE) firstrow clear

* Mantener sólo pruebas de Cusco y por prueba molecular
keep if diresa == "CUSCO"
keep if prueba == "PRUEBA MOLECULAR"
keep if departamento == "CUSCO"

tostring ubigeo, force replace
replace ubigeo = "0"+ubigeo

* Identificar los duplicados
sort id
duplicates report id
duplicates tag id, gen(dupli_noti)
quietly by id: gen dup_noti = cond(_N==1,0,_n)

* Borrar duplicados por fecha id resultado y fecha de resultado
duplicates drop id resultado fecha_con if dup_noti != 0, force

rename fecha_con fecha_res
*duplicates drop id, force

rename numdoc dni
rename tipo_caso asintomatico
rename nombre_via direccion

* Generar si es positivo o negativo
gen positivo_pcr=.
replace positivo_pcr = 1 if resultado == "POSITIVO" & (muestra == "ASPIRADO TRAQUEAL O NASAL FARINGEO" | muestra == "HISOPADO NASAL Y FARINGEO" | muestra == "LAVADO BRONCOALVEOLAR") & (prueba != "PRUEBA ANTIGÉNICA" & prueba != "PRUEBA SEROLÓGICA")
replace positivo_pcr = 0 if resultado == "NEGATIVO" & (muestra == "ASPIRADO TRAQUEAL O NASAL FARINGEO" | muestra == "HISOPADO NASAL Y FARINGEO" | muestra == "LAVADO BRONCOALVEOLAR") & (prueba != "PRUEBA ANTIGÉNICA" & prueba != "PRUEBA SEROLÓGICA")
tab positivo_pcr

* Fecha de la prueba molecular
gen fecha_molecular1 = fecha_res
split fecha_molecular1, parse(-) destring
rename (fecha_molecular1?) (dayl monthl yearl)
gen fecha_pcr = daily(fecha_molecular1, "YMD") if positivo_pcr == 1 | positivo_pcr == 0
format fecha_pcr %td

* Fecha de inicio de la prueba molecular (sólo si salió positivo)
gen fecha_inici = fecha_ini
split fecha_inici, parse(-) destring
rename (fecha_inici?) (day7 month7 year7)
gen fecha_inicio_noti = daily(fecha_inici, "YMD") if positivo_pcr == 1
format fecha_inicio_noti %td

* Indentificador de fecha de inicio por PCR (para comparar con las PR, y AG)
gen fecha_inicio = fecha_inicio_noti
format fecha_inicio %td

* Generar los sintomáticos y asintomáticos si y solo si son positivos
gen sintomatico =.
replace sintomatico = 1 if (asintomatico == "SINTOMÁTICO" & positivo_pcr == 1) 
replace sintomatico = 0 if (asintomatico == "ASINTOMÁTICO" & positivo_pcr==1)
label variable sintomatico "Tiene sintoma"
label define sintomatico 0 "No" 1 "Si"
label values sintomatico sintomatico
tab sintomatico

* Identificar a los sintomáticos por PCR
gen sintomatico_pcr = sintomatico

keep dni positivo_pcr fecha_pcr fecha_inicio_noti fecha_inicio edad sexo departamento  distrito direccion sintomatico sintomatico_pcr distrito provincia ubigeo red  departamento direccion id

* Mantener sólo positivos o negativos por PCR
keep if positivo_pcr == 1 | positivo_pcr == 0

tostring ubigeo, replace 
tostring dni, replace force

* Fechas mas del 2020
drop if fecha_pcr > d(31dec2020)

********************************************************************************
save "${datos}\output\base_noticovid_2020.dta", replace