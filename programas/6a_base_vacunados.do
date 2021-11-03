import delimited "${datos}\raw\vacunacovid.csv", varnames(1) encoding(UTF-8)  clear

* DNI
rename numero dni

* Fecha de nacimiento
gen fecha_2 = fnac
split fecha_2, parse(-) destring
rename (fecha_2?) (año2 mes2  dia2)
gen fecha_nacimiento = daily(fecha_2, "YMD")
format fecha_nacimiento %td

* Edad
gen edad = 2020 - año2


* Fecha de vacunación
gen fecha_1 = fvac
split fecha_1, parse(-) destring
rename (fecha_1?) (año1 mes1 dia1)
gen fecha_vacuna = daily(fecha_1, "YMD")
format fecha_vacuna %td

* Ordenar por fecha de vacunación y DNI para indicar primera y segunda dosis
sort dni fecha_vacuna
duplicates report dni 
duplicates tag dni, gen(dupli)
quietly by dni: gen num_dupli = cond(_N==1,0,_n)

* Número de dosis del paciente
rename dosis dosis_old

gen dosis = .
replace dosis = 1 if dupli == 0
replace dosis = 2 if dupli == 1 & num_dupli == 2
replace dosis = 3 if num_dupli >2

* Mantener una copia de los que tienen una dosis, dos dosis, y tres dosis
keep if dosis == 1 | dosis == 2 | dosis == 3

* Mantener las variables de interés
rename fecha_vacuna fecha_ultima_vacuna

* Aumentar provincias

* Poner los ubigeos correctos

* Convertir a numerico para borrar ubigeos de otros departamentos
destring ubigeo, replace force 
* Mantener solo de Cusco
keep if ubigeo>=70000 & ubigeo <80000

replace ubigeo = ubigeo + 10000

* Convertir a string 
tostring ubigeo, replace force
* Incluir un cero 
replace ubigeo = "0"+ubigeo
* Normalizar los ubigeo como sale en el nacional
*replace ubigeo = subinstr(ubigeo,"07","08",.)

keep dni fecha_ultima_vacuna dosis edad ubigeo

destring edad, replace force

save "${datos}\output\base_vacunados", replace
