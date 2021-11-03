

* Código de establecimiento
import excel "datos\raw\codigo_establecimiento.xlsx", firstrow clear

gen codigo_red = CódigoÚnico

gen red = Red

keep codigo_red red 

save "datos\output\codigo_establecimiento", replace

