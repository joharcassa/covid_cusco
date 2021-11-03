
* Base de datos NOTICOVID

* Importar la base de datos de excel
import excel "${datos}\raw\base_noticovid_2021_sin_com.xlsx", sheet(BD_coronavirus) firstrow clear

* Seleccionar solo a los que pertencen al departamento Cusco
keep if diresa == "CUSCO"
keep if departamento == "CUSCO"

* Rename
rename numdoc dni
drop fecha_res
rename fecha_con fecha_res

* Generar si es positivo o negativo
gen positivo_pcr1=.
replace positivo_pcr1 = 1 if resultado == "POSITIVO" & (muestra == "ASPIRADO TRAQUEAL O NASAL FARINGEO" | muestra == "HISOPADO NASAL Y FARINGEO" | muestra == "LAVADO BRONCOALVEOLAR") & (prueba != "PRUEBA ANTIGÉNICA" & prueba != "PRUEBA SEROLÓGICA")
replace positivo_pcr1 = 0 if resultado == "NEGATIVO" & (muestra == "ASPIRADO TRAQUEAL O NASAL FARINGEO" | muestra == "HISOPADO NASAL Y FARINGEO" | muestra == "LAVADO BRONCOALVEOLAR") & (prueba != "PRUEBA ANTIGÉNICA" & prueba != "PRUEBA SEROLÓGICA")
tab positivo_pcr1

* Mantener sólo a los que son positivos o negativos
keep if positivo_pcr1 == 1 | positivo_pcr1 == 0

* Fecha de la prueba molecular
gen fecha_molecular1 = fecha_res
split fecha_molecular1, parse(-) destring
rename (fecha_molecular1?) (dayl monthl yearl)
gen fecha_pcr1 = daily(fecha_molecular1, "YMD") if positivo_pcr == 1 | positivo_pcr == 0
format fecha_pcr1 %td

* Borrar duplicados
sort dni
duplicates report dni
duplicates tag dni, gen(dupli_noti)
quietly by dni: gen dup_noti = cond(_N==1,0,_n)
*br dni dupli_noti dup_noti if dup_noti != 0
* Un DNI y el numero de carnet de una persona coincide, se toma en cuenta 
*replace dni = telefono if tipodoc == "CARNET DE EXTRANJERIA" & dupli_noti == 1 & dni == "19836727"
duplicates drop dni, force

********************************************************************************
* Sintomas
gen sin_fiebre_2 = .
replace sin_fiebre_2 = 1 if fiebre == 1

gen sin_malestar = .
*replace sin_malestar = 1 if malestar == 1
replace sin_malestar = 1 if malestar_general == 1

gen sin_tos = .
replace sin_tos = 1 if tos == 1 

gen sin_garganta = .
*replace sin_garganta = 1 if garganta == 1 
replace sin_garganta = 1 if dolor_garganta == 1 

gen sin_congestion = .
*replace sin_congestion = 1 if congestion == 1
replace sin_congestion = 1 if congestion_nasal == 1

gen sin_respiratoria = .
*replace sin_respiratoria = 1 if respiratoria == 1
replace sin_respiratoria = 1 if dificultad_respiratoria == 1

gen sin_diarrea = .
replace sin_diarrea = 1 if diarrea == 1 

gen sin_nauseas = .
replace sin_nauseas = 1 if nauseas == 1 

gen sin_cefalea = .
replace sin_cefalea = 1 if cefalea == 1 

gen sin_irritabilidad = .
replace sin_irritabilidad = 1 if irritabilidad == 1 

gen sin_muscular = .
*replace sin_muscular = 1 if muscular == 1  
replace sin_muscular = 1 if dolor_muscular == 1  

gen sin_abdominal = .
*replace sin_abdominal = 1 if abdominal == 1 
replace sin_abdominal = 1 if dolor_abdominal == 1 

gen sin_pecho = .
*replace sin_pecho = 1 if pecho == 1 
replace sin_pecho = 1 if dolor_pecho == 1 

gen sin_articulaciones = .
*replace sin_articulaciones = 1 if articulaciones == 1 
replace sin_articulaciones = 1 if dolor_articulaciones == 1 

gen otros_sintom = .
replace otros_sintom = 1 if otros_sintomas != 1 

gen sin_otro = .
replace sin_otro = 1 if otros_sintom == 1

gen sin_ninguno = .
replace sin_ninguno = 1 if (sin_fiebre_2 != 1 & sin_malestar!= 1 &  sin_tos != 1 &  sin_garganta != 1 &  sin_congestion != 1 &   sin_respiratoria != 1 &   sin_diarrea != 1 &  sin_nauseas != 1 &   sin_cefalea != 1 & sin_irritabilidad != 1 &   sin_muscular != 1 &  sin_abdominal != 1 &   sin_pecho != 1 &  sin_articulaciones != 1 &  sin_otro != 1)

* Comorbilidades
gen com_obesidad = .
replace com_obesidad = 1 if  OBESIDAD == 1 

gen com_pulmonar = .
*replace com_pulmonar = 1 if  pulmonar == 1 
replace com_pulmonar = 1 if  enf_pulmonar == 1 

gen com_diabetes = .
replace com_diabetes = 1 if diabetes == 1

gen com_cardiovasular = .
*replace com_cardiovasular =1 if cardiovascular == 1
replace com_cardiovasular =1 if enf_cardiovascular == 1

*gen com_inmunodeficiencia = .
*replace com_inmunodeficiencia = 1 if  inmunodeficiencia == 1

gen com_cancer = .
replace com_cancer = 1 if cancer == 1 

gen com_embarazo = .
*replace com_embarazo = 1 if  embarazo == 1 | postparto == 1 
replace com_embarazo = 1 if  embarazo == 1

gen com_asma = .
replace com_asma = 1 if  ASMA == 1

gen com_renal = .
*replace com_renal = 1 if  renal == 1 
replace com_renal = 1 if  enf_renal == 1 

gen com_ninguno = .
*replace com_ninguno = 1 if (com_obesidad!= 1 & com_pulmonar!=1 & com_diabetes!=1 & com_cardiovasular !=1 & com_inmunodeficiencia !=1 & com_cancer !=1 & com_embarazo!=1 & com_asma !=1 & com_renal !=1)
replace com_ninguno = 1 if (com_obesidad!= 1 & com_pulmonar!=1 & com_diabetes!=1 & com_cardiovasular !=1 & com_cancer !=1 & com_embarazo!=1 & com_asma !=1 & com_renal !=1)

gen sig_exudado = .
*replace sig_exudado = 1 if exudado == 1
replace sig_exudado = 1 if exudado_faringeo == 1

gen sig_conjuntival = .
*replace sig_conjuntival = 1 if conjuntival == 1
replace sig_conjuntival = 1 if inyeccion_conjuntival == 1

gen sig_convulsion = .
replace sig_convulsion = 1 if convulsion == 1

*gen sig_coma = .
*replace sig_coma = 1 if coma == 1 

gen sig_disnea = .
replace sig_disnea = 1 if disnea == 1

gen sig_auscultacion = .
*replace sig_auscultacion =1 if auscultacion == 1
replace sig_auscultacion =1 if auscultacion_pulmonar == 1

*gen sig_rxpulmonar = .
*replace sig_rxpulmonar = 1 if rxpulmonar == 1

keep if fecha_pcr1 >= d(01jan2021) & fecha_pcr1 <= d($fecha) 

keep dni sin_* com_* sig_*

save "${datos}\output\data_noti_boletin.dta", replace
