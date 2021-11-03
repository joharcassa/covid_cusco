*-------------------------------------------------------------------------------%

* Programa:				 Limpieza de Datos de Casos COVID-19 por Prueba Antigénica 2021 en Cusco
* Primera vez creado:    27 de octubre del 2021
* Ultima actualizaciónb: 27 de octubre del 2021

*-------------------------------------------------------------------------------%

********************************************************************************
* 3. Pruebas Antigenicas
********************************************************************************

* Importar la base de datos por prueba antigénica de enero a junio del 2021

import excel "${datos}\raw\base_siscovid_ag_enero_junio.xlsx", sheet("Hoja1") firstrow clear

* Mantener las variables de interés
keep NroDocumento  Departamento Resultado ResultadoSegundaPrueba FechaEjecucionPrueba FechaInicioSintomasdelaFich Edad comun_sexo_paciente TieneSintomas Latitud Longitud Direccion id_ubigeo Provincia Distrito cod_establecimiento_ejecuta

save "${datos}\temporal\base_siscovid_ag_enero_junio", replace
