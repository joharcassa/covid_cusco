*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
* Programa:		  Programa para analizar toda la información sobre COVID-19 en la Región Cusco
* Creado el:	  27 de octubre del 2021
* Actualizado en: 31 de octubre del 2021
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

* Acción requerida --> Seleccionar el número de usuario (1 en mi caso) de acuerdo a la dirección (path) del siguiente comando

clear all
set more off

global user 1 

* Acción requerida --> Cambiar la dirección (path) de su folder de replicación
	global path "C:\Users\HP\Documents\GitHub\covid_cusco"
	
	cd "$path"

* Directorio de los datos: Por ser data confidencial, se guardan los datos en otra carpeta que no este libremente disponible
    global datos  "D:\7. Work\covid_cusco\datos"

* Acción requerida: programas para realizar mapas
*ssc install spmap
*ssc install shp2dta

* Acción requerida: definir la fecha actual y la semana epidemiológica
global fecha 04nov2021
global semana 44

* Tiempo de corrida: alrededor de 7 minutos
timer on 1

* Definir los colores de las gráficas
* Colores
global mycolor1 "236 244 244"
global mycolor2 "252 196 108" 
global mycolor3 "164 92 92"
global mycolor4 "76 60 52"
global mycolor5 "164 248 208"
global mycolor6 "116 112 112"
global mycolor7 "116 116 52"

colorpalette ///
 "$mycolor1" ///
 "$mycolor2" ///
 "$mycolor3" ///
 "$mycolor4" ///
 "$mycolor5" ///
 "$mycolor6" ///
 "$mycolor7" ///
  , n(7)
  
gr export "figuras/paleta_colores.png", as(png) replace
*/

* Se analiza los casos, defunciones, ocupación de camas, vacunas, variantes de COVID-19 en la Región Cusco
* Para ello, se cuenta con distintas fuentes de información 
** 1. NOTICOVID: casos por prueba molecular
** 2. SISCOVID: casos por prueba rápida y prueba antigénica
** 3. SINADEF: defunciones por COVID-19 y por todas las causas
** 4. Referencias y Contrareferencias: ocupación de camas UCI, no-UCI, UCIN, en los hospitales de la Región
** 5. SICOVAC-HIS, MINSA: vacunación COVID-19
** 6. NETLAB, UNSAAC, UPCH: laboratorios que secuencian las variantes de COVID-19

* 1. Construir las base de datos
	**do "programas/0a_codigo_ubigeo"
	**do "programas/0b_codigo_establecimiento"
	
	*do "programas/1a_base_noticovid_2020"
	do "programas/1b_base_noticovid_2021"
	*do "programas/1c_base_siscovid_pr_2020"
	do "programas/1d_base_siscovid_pr_2021"
	*do "programas/1e_base_siscovid_ag_2021_1"
	do "programas/1f_base_siscovid_ag_2021_2"
	*do "programas/1g_base_sinadef_covid_2020"
	do "programas/1h_base_sinadef_covid_2021"
	do "programas/1i_base_unir"
	*do "programas/1j_datos_mapa_calor" // semanal 
	
* 2. Generar datos a nivel regional y provincial
	do "programas/2a_series_diarias_region"
	do "programas/2b_series_diarias_provincias"
	do "programas/2c_panel_diario_provincias"

* 3. Figuras para la "Sala Situacional COVID-19" diaria
	do "programas/3a_figura_etapa_vida"
	do "programas/3b_figura_inci_morta_diario"
	do "programas/3c_figura_positividad"
	do "programas/3d_figura_promedio_casos_def"
	do "programas/3e_sintomaticos"
	x 
	* Para la actualización del Dashboard COVID-19 en la página web
	do "programas/1k_datos_dashboard"
	** Cambiar la dirección si es necesario
	do "C:\Users\HP\Documents\GitHub\covid-cusco\dashboard-covid-geresa\data\MasterDofile"
	
	* Ocupación de camas (semanalmente)
	**do "C:\Users\HP\Documents\GitHub\covid-cusco\dashboard-covid-geresa\data\source1_camas\main"
* 4. Figuras para la "Sala Situacional COVID-19" Semanal
	do "programas/2d_series_semanales_region" // Generar datos semanales region
	do "programas/4a_figura_casos_def_region"
	do "programas/4b_figura_mort_edad_region"
	
	do "programas/2e_series_semanales_provincias" // Generar datos semanales provincias
	do "programas/4c_figura_inci_mort_positi_provincial"
	
	** Datos para los excesos de defunciones
	*do "programas/1l_datos_defunciones_reg_prov_2019" // datos del 2019
	do "programas/1m_datos_defunciones_2020_2021_regional"
	do "programas/1n_datos_defunciones_2020_2021_provincial"
	do "programas/4d_figura_exceso_regional"
	do "programas/4e_figura_exceso_provincial"

	* Hospitalización
	do "programas/4f_figuras_hospitales"
	
	* Tabla cero defunciones
	do "programas\4z_tabla_cero_defunciones.do"

* 5. Secuenciamiento
	do "programas\5a_base_secuenciamiento_netlab"
	do "programas\5b_base_secuenciamiento_upch"
	do "programas\5c_juntar"
	do "programas\5d_figura_secuenciamiento"
	do "programas\5e_mapas_secuenciamiento"

* 6. Vacunados
	do "programas\6a_base_vacunados"
	do "programas\6b_figura_vacunacion"
	do "programas\6c_figura_vacunacion_provincias"
	
* 7. Figuras para el "Boletin COVID-19" Mensual
	do "programas\7a_base_noticovid_2021_variables"
	do "programas\7b_base_siscovid_pr_2021_variables"
	do "programas\7c_base_siscovid_ag_2021_variables"
	do "programas\7d_unir_bases"
	do "programas\7e_figura_sintomas_comorbilidad"
	do "programas\7f_lugar_fallecimiento"
	do "programas\7g_figura_inci_morta_series"

timer off 1
timer list