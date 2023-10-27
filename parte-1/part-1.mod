/*mod*/

set LOCALIZACIONES;
set DISTRITOS;

var llamadas {i in LOCALIZACIONES, j in DISTRITOS} integer >=0;

param tiempo_llamada {i in LOCALIZACIONES, j in DISTRITOS};
param llamadas_distrito {j in DISTRITOS};
param llamadas_maximas {i in LOCALIZACIONES};
param tiempo_maximo;

/*Funcion objetivo a minimizar*/
minimize TIEMPO: sum{i in LOCALIZACIONES, j in DISTRITOS} tiempo_llamada[i, j] * llamadas[i,j];

/* Todas las llemadas de los distritos tienen que ser atendidas*/
s.t. LLAMADAS_EXACTAS {j in DISTRITOS}: sum{i in LOCALIZACIONES} llamadas[i,j] = llamadas_distrito[j];

/* Cada locaclización no puede atender más de 10000 llamadas*/
s.t. LLAMADAS_MAXIMAS {i in LOCALIZACIONES}: sum{j in DISTRITOS} llamadas[i,j] <= llamadas_maximas[i];

/*Una ambulancia no tardará más del tiempo máximo en llegar a un distrito*/
s.t. TIEMPO_MAXIMO {i in LOCALIZACIONES, j in DISTRITOS}: llamadas[i,j]*tiempo_llamada[i,j] <= llamadas[i,j]*tiempo_maximo;

/*El número total de llamadas de un parking no puede ser mayor que el 50% del total de llamadas de otro*/
s.t. BALANCE_ESFUERZO {i in LOCALIZACIONES, a in LOCALIZACIONES: a!=i}: sum{j in DISTRITOS} llamadas[i,j] <= 1.5*sum{j in DISTRITOS}llamadas[a, j];

