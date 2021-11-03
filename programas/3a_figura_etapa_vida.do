*-------------------------------------------------------------------------------%

* Programa: Figura de las Etapas de Vida

* Primera vez creado:     02 de junio del 2021
* Ultima actualizaciónb:  02 de junio del 2021

*-------------------------------------------------------------------------------%

* Importar la base de datos
use "${datos}\output\base_covid.dta", clear

* Mantener sólo los datos del 2021
drop if fecha_resultado < d(01jan2021)

* Generar las categorías de las etapas de vida
gen grupo_edad = .
replace grupo_edad = 1 if edad >= 0 & edad <=9
replace grupo_edad = 2 if edad >= 10 & edad <= 19
replace grupo_edad = 3 if edad >= 20 & edad <= 29
replace grupo_edad = 4 if edad >= 30 & edad <= 39
replace grupo_edad = 5 if edad >= 40 & edad <= 49
replace grupo_edad = 6 if edad >= 50 & edad <= 59
replace grupo_edad = 7 if edad >= 60 & edad <= 69
replace grupo_edad = 8 if edad >= 70 & edad <= 79
replace grupo_edad = 9 if edad >= 80 & edad <= 89
replace grupo_edad = 10 if edad >= 90 & edad <= 99
replace grupo_edad = 11 if edad >= 100 
label variable grupo_edad "Grupo de Edad"
label define grupo_edad 1 "0-9 años" 2 "10-19 años" 3 "20-29 años" 4 "30-39 años" 5 "40-49 años" 6 "50-59 años" 7 "60-69 años" 8 "70-79 años" 9 "80-89 años" 10 "90-99 años" 11 "100 a más años"
label values grupo_edad grupo_edad

gen genero = .
replace genero = 1 if sexo == "FEMENINO"
replace genero = 2 if sexo == "MASCULINO"
label var genero "Género"
label define genero 1 "Femenino" 2 "Masculino"
label values genero genero

* Defunciones
graph hbar (count) if defuncion == 1, ysize(5) xsize(6.1) ///
over(genero) ascategory asyvar bar(1, color("$mycolor3")) bar(2, color("$mycolor7")) ///
over(grupo_edad) blabel(total) ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor2") ///
blabel(bar, position(outside) color(black) format(%4.1f)) ///
blabel(total) ///
blabel(bar, size(vsmall) format(%11.0gc)) ///
ytitle("Defunciones por COVID") ///
ylabel(, nogrid) ///
legend(label(1 "Femenino") label(2 "Masculino") size(*0.8) region(col(white))) name(def, replace) 

graph export "figuras\defunciones_etapavida.png", as(png) replace

* Casos
graph hbar (count) if positivo == 1, ysize(5) xsize(6.1)  ///
over(genero) ascategory asyvar bar(1, color("$mycolor2")) bar(2, color("$mycolor6")) ///
over(grupo_edad) blabel(total) ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor2") ///
blabel(bar, position(outside) color(black)) ///
blabel(total) ///
blabel(bar, size(vsmall) format(%11.0gc)) ///
ytitle("Casos COVID") ///
ylabel(, nogrid) ///
legend(label(1 "Femenino") label(2 "Masculino") size(*0.8) region(col(white))) name(cas, replace) 

graph export "figuras\casos_etapavida.png", as(png) replace