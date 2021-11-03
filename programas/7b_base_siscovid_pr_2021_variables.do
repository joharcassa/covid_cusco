
import excel "${datos}\raw\base_siscovid_pr_2021.xlsx", sheet(Hoja1) firstrow clear

* Renombrar las variables para que coincidan con las variables de la misma base pero del 2020

keep if Departamento == "Cusco"

rename NroDocumento nro_docume
rename Resultado1 resultado1
rename Resultado resultado

split FechaPrueba, parse(-) destring
rename (FechaPrueba?) (year month day)
gen fecha_pr = daily(FechaPrueba, "YMD")
format fecha_pr %td

* Positivo para identificar los duplicados 
gen positivo_pr_sis = .
replace positivo_pr_sis = 1 if resultado == "IgG POSITIVO" | resultado == "IgG Reactivo" | resultado == "IgM POSITIVO" | resultado == "IgM Reactivo" | resultado == "IgM e IgG POSITIVO" | resultado == "IgM e IgG Reactivo" | resultado == "POSITIVO" | (resultado == "Indeterminado" & (resultado1 == "IgG Reactivo"| resultado1 == "IgM Reactivo" | resultado1 == "IgM e IgG Reactivo"))
replace positivo_pr_sis = 0 if resultado == "NEGATIVO" | resultado == "No Reactivo" | (resultado1 == "Indeterminado" & (resultado1 == "Indeterminado" | resultado1 == "No reactivo"))
*tab positivo_pr_sis

keep if positivo_pr == 0 | positivo_pr == 1

* Duplicados
gen dni = nro_docume
sort dni
duplicates report dni
duplicates tag dni, gen(repe_sis)
quietly by dni: gen repeti_sis = cond(_N==1,0,_n)

* 2.4 Eliminar 
* Eliminar si no tiene resultado o no tiene fecha de resultado
drop if positivo_pr == .
drop if fecha_pr == .


********************************************************************************
* Sintomas 

gen sin_fiebre_2 = .
replace sin_fiebre_2 = 1 if FiebreEscalofrio == "1"

gen sin_malestar = .
replace sin_malestar = 1 if MalestarGeneral == "1"

gen sin_tos = .
replace sin_tos = 1 if Tos == "1"


gen sin_garganta = .
replace sin_garganta = 1 if DolorGarganta == "1"

gen sin_congestion = .
replace sin_congestion = 1 if CongestionNasal == "1"

gen sin_respiratoria = .
replace sin_respiratoria = 1 if DificultadRespiratoria == "1"

gen sin_diarrea = .
replace sin_diarrea = 1 if Diarrea == "1"

gen sin_nauseas = .
replace sin_nauseas = 1 if NauseasVomito == "1"

gen sin_cefalea = .
replace sin_cefalea = 1 if PresentaCefalea == "1"

gen sin_irritabilidad = .
replace sin_irritabilidad = 1 if IrritabilidadConfusion == "1"

gen sin_muscular = .
replace sin_muscular = 1 if DolorPresentaMuscular == "1"

gen sin_abdominal = .
replace sin_abdominal = 1 if DolorPresentaAbdominal == "1"

gen sin_pecho = .
replace sin_pecho = 1 if DolorPresentaPecho == "1"

gen sin_articulaciones = .
replace sin_articulaciones = 1 if DolorPresentaArticulaciones == "1"

gen sin_otro = .
replace sin_otro = 1 if PresentaOtros == "1"

gen sin_ninguno = .
replace sin_ninguno = 1 if (sin_fiebre_2 != 1 & sin_malestar!= 1 &  sin_tos != 1 &  sin_garganta != 1 &  sin_congestion != 1 &   sin_respiratoria != 1 &   sin_diarrea != 1 &  sin_nauseas != 1 &   sin_cefalea != 1 & sin_irritabilidad != 1 &   sin_muscular != 1 &  sin_abdominal != 1 &   sin_pecho != 1 &  sin_articulaciones != 1 &  sin_otro != 1)

* 

gen com_obesidad = .
replace com_obesidad = 1 if RiesgoObesidad == "1"

gen com_pulmonar = .
replace com_pulmonar = 1 if RiesgoEnfPulmonarCronica == "1"

gen com_diabetes = .
replace com_diabetes = 1 if RiesgoDiabetes == "1"

gen com_cardiovasular = .
replace com_cardiovasular =1 if Riesgo_EnfCardiovascular == "1"

gen com_inmunodeficiencia = .
replace com_inmunodeficiencia = 1 if RiesgoEnfTratinmuno == "1"

gen com_cancer = .
replace com_cancer = 1 if RiesgoCancer == "1"

gen com_embarazo = .
replace com_embarazo = 1 if RiesgoEmbarazo == "1"

gen com_asma = .
replace com_asma = 1 if RiesgoAsma == "1"

gen com_renal = .
replace com_renal = 1 if RiesgoRenalCronica == "1"

gen com_ninguno = .
replace com_ninguno = 1 if (com_obesidad!= 1 & com_pulmonar!=1 & com_diabetes!=1 & com_cardiovasular !=1 & com_inmunodeficiencia !=1 & com_cancer !=1 & com_embarazo!=1 & com_asma !=1 & com_renal !=1)

keep if fecha_pr >= d(01jan2021) & fecha_pr <= d($fecha)

keep dni sin_* com_*  

save "${datos}\output\data_sis_pr_boletin.dta", replace
