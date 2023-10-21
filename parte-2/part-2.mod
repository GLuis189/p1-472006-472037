/*mod*/

set LOCALIZACIONES;
set DISTRITOS;

var llamadas {i in LOCALIZACIONES, j in DISTRITOS} integer >=0;

param tiempo_llamada {i in LOCALIZACIONES, j in DISTRITOS};
param llamadas_distrito {j in DISTRITOS};
param llamadas_maximas {i in LOCALIZACIONES};
param coste_construir:= 50000;
param coste_minuto:= 2;

/*Funcion objetivo a minimizar*/
minimize TIEMPO: sum{i in LOCALIZACIONES, j in DISTRITOS} tiempo_llamada[i, j] * llamadas[i,j];

/* Todas las llemadas de los distritos tienen que ser atendidas*/
s.t. LLAMADAS_EXACTAS {j in DISTRITOS}: sum{i in LOCALIZACIONES} llamadas[i,j] = llamadas_distrito[j];

/* Cada locaclización no puede atender más de 10000 llamadas*/
s.t. LLAMADAS_MAXIMO {i in LOCALIZACIONES}: sum{j in DISTRITOS} llamadas[i,j] <= llamadas_maximas[i];

s.t. BALANCE_ESFUERZO {i in LOCALIZACIONES, a in LOCALIZACIONES: a!=i}: sum{j in DISTRITOS} llamadas[i,j] <= sum{j in DISTRITOS}1.5*llamadas[i, j];

s.t. TIEMPO_MAXIMO {i in LOCALIZACIONES, j in DISTRITOS}: llamadas[i,j]*tiempo_llamada[i,j] <= llamadas[i,j]*tiempo_maximo;