
shp2dta using "mapas\datos_distritales.shp", database("mapas\distrital_db") coordinates("mapas\distrital_co") genid(id) genc(c)  replace

use "mapas\distrital_db", clear

keep if CCDD == "08"

rename UBIGEO ubigeo

sort ubigeo
save "mapas\mapa_cusco_distrital", replace
*/

use "${datos}\output\datos_variantes", clear

* Mantener sólo a las que tienen variante 
drop if variante == 5

tostring dni, replace force

merge 1:m dni using "${datos}\output\base_noticovid"

keep if _merge == 3

sort ubigeo

collapse (count) edad, by(ubigeo)

rename edad variantes 

save "${datos}\output\datos_variantes_mapa", replace 

merge 1:1 ubigeo using "mapas\mapa_cusco_distrital"

*br NOMBDIST

gen icd_new = ""
replace icd_new = substr(NOMBDIST,1,3) if _merge == 3

* Mapa distrital de cantidad de variantes
spmap variantes using "mapas\distrital_co", id(id) fcolor("$mycolor3" "$mycolor2" "$mycolor4" "$mycolor5") label(xcoord( x_c ) ycoord( y_c ) label(icd_new)) name(mapa_distrital, replace)

gr export "figuras\variantes_distrital.png", as(png) replace
gr export "figuras\variantes_distrital.pdf", as(pdf) replace

***************************************************

shp2dta using "mapas\datos_distritales.shp", database("mapas\distrital_db") coordinates("mapas\distrital_co") genid(id) genc(c)  replace

use "mapas\distrital_db", clear

keep if NOMBPROV == "CUSCO"

rename UBIGEO ubigeo

sort ubigeo
save "mapas\mapa_cusco_cusco", replace
*/
use "${datos}\output\datos_variantes", clear

* Mantener sólo a las que tienen variante 
drop if variante == 5

tostring dni, replace force

merge 1:m dni using "${datos}\output\base_noticovid"

keep if _merge == 3

sort ubigeo

collapse (count) edad, by(ubigeo)

rename edad variantes 

save "${datos}\output\datos_variantes_cusco", replace 

merge 1:1 ubigeo using "mapas\mapa_cusco_cusco"

*br NOMBDIST

*gen icd_new = ""
*replace icd_new = substr(NOMBDIST,1,3) if _merge == 3

* Provincia de Cusco
spmap variantes using "mapas\distrital_co", id(id) fcolor("$mycolor3" "$mycolor2" "$mycolor4" "$mycolor5") label(xcoord( x_c ) ycoord( y_c ) label(NOMBDIST)) name(distri_cusco, replace)

gr export "figuras\variantes_distrital_cusco.png", as(png) replace
gr export "figuras\variantes_distrital_cusco.pdf", as(pdf) replace


********************************************************************************
* Tipos de Variantes a nivel provincial

shp2dta using "mapas\PROVINCIAS.shp", database("mapas\provincial_db") coordinates("mapas\provincial_co") genid(id) genc(c) replace

use "mapas\provincial_db", clear

keep if IDDPTO == "08"

rename PROVINCIA provincia 

sort provincia
save "mapas\mapa_provincial", replace
*/
***
use "${datos}\output\datos_variantes", clear

* Mantener sólo a las que tienen variante 
drop if variante == 5

tostring dni, replace force

merge 1:m dni using "${datos}\output\base_noticovid"

keep if _merge == 3

sort provincia

collapse (count) edad, by(provincia)

rename edad variantes 

save "${datos}\output\datos_variantes_provincias", replace

merge 1:1 provincia using "mapas\mapa_provincial"

* Dibujar el mapa
spmap variantes using "mapas\provincial_co", id(id) fcolor("$mycolor3" "$mycolor2" "$mycolor4" "$mycolor5") label(xcoord( x_c ) ycoord( y_c ) label(provincia)) name(provincial, replace)

gr export "figuras\variantes_provincial.png", as(png) replace
gr export "figuras\variantes_provincial.pdf", as(pdf) replace


********************************************************************************
* Para cada variantes

* Lambda
use "${datos}\output\datos_variantes", clear

* Mantener sólo a las que tienen variante 
drop if variante == 5

tostring dni, replace force

merge 1:m dni using "${datos}\output\base_noticovid"

keep if _merge == 3

keep if variante == 1

sort provincia

collapse (count) edad, by(provincia)

rename edad variantes 

save "${datos}\output\datos_variantes_provincias", replace

merge 1:1 provincia using "mapas\mapa_provincial"

* Dibujar el mapa
spmap variantes using "mapas\provincial_co", id(id) fcolor("$mycolor3" "$mycolor2" "$mycolor4" "$mycolor5") label(xcoord( x_c ) ycoord( y_c ) label(provincia)) name(lambda, replace)

gr export "figuras\variantes_provincial_lambda.png", as(png) replace
gr export "figuras\variantes_provincial_lambda.pdf", as(pdf) replace

* Gamma
use "${datos}\output\datos_variantes", clear

* Mantener sólo a las que tienen variante 
drop if variante == 5

tostring dni, replace force

merge 1:m dni using "${datos}\output\base_noticovid"

keep if _merge == 3

keep if variante == 2

sort provincia

collapse (count) edad, by(provincia)

rename edad variantes 

save "${datos}\output\datos_variantes_provincias", replace

merge 1:1 provincia using "mapas\mapa_provincial"

* Dibujar el mapa
spmap variantes using "mapas\provincial_co", id(id) fcolor("$mycolor3" "$mycolor2" "$mycolor4" "$mycolor5") label(xcoord( x_c ) ycoord( y_c ) label(provincia)) name(gamma, replace)

gr export "figuras\variantes_provincial_gamma.png", as(png) replace
gr export "figuras\variantes_provincial_gamma.pdf", as(pdf) replace


* Delta
use "${datos}\output\datos_variantes", clear

* Mantener sólo a las que tienen variante 
drop if variante == 5

tostring dni, replace force

merge 1:m dni using "${datos}\output\base_noticovid"

keep if _merge == 3

keep if variante == 3

sort provincia

collapse (count) edad, by(provincia)

rename edad variantes 

save "${datos}\output\datos_variantes_provincias", replace

merge 1:1 provincia using "mapas\mapa_provincial"

* Dibujar el mapa
spmap variantes using "mapas\provincial_co", id(id) fcolor("$mycolor3" "$mycolor2" "$mycolor4" "$mycolor5") label(xcoord( x_c ) ycoord( y_c ) label(provincia)) name(delta, replace)

gr export "figuras\variantes_provincial_delta.png", as(png) replace
gr export "figuras\variantes_provincial_delta.pdf", as(pdf) replace
