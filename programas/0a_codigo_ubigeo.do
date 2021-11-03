* Definir los ubigeos
import excel "datos\raw\ubigeos.xlsx", sheet("Hoja1") firstrow clear
save "datos\output\ubigeos.dta", replace
