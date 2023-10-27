/*mod*/

set LOCALIZACIONES;
set NUEVAS_LOCALIZACIONES;
set DISTRITOS;
var llamadas {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, j in DISTRITOS} integer >=0;
param tiempo_llamada {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, j in DISTRITOS};
param llamadas_distrito {j in DISTRITOS};
var seleccionado{i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES} binary;
var seleccionado_por_distrito{i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, j in DISTRITOS} binary;
param coste_construir;
param coste_minuto;
param max_llamadas;
param tiempo_maximo;
param porcentaje_balance:= 0.5;
param porcentaje_maximo:= 0.75;
param porcentaje_minimo:= 0.1;

/*Funcion objetivo a minimizar*/
minimize COSTE: sum{i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, j in DISTRITOS} tiempo_llamada[i, j] * llamadas[i,j]*coste_minuto + sum{i in NUEVAS_LOCALIZACIONES} coste_construir*seleccionado[i];

/* Todas las llamadas de los distritos tienen que ser atendidas*/
s.t. LLAMADAS_EXACTAS {j in DISTRITOS}: sum{i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES} llamadas[i,j] = llamadas_distrito[j];

/* Cada locaclización no puede atender más de 10000 llamadas*/
s.t. LLAMADAS_MAXIMO {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES}: sum{j in DISTRITOS} llamadas[i,j] <= max_llamadas;

/*Una ambulancia no tardará más del tiempo máximo en llegar a un distrito*/
s.t. TIEMPO_MAXIMO {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, j in DISTRITOS}: llamadas[i,j]*tiempo_llamada[i,j] <= llamadas[i,j]*tiempo_maximo;

/*Si un parking tiene llamadas es seleccionado*/
s.t. SELECCIONAR_PARKING_A {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES}: sum{j in DISTRITOS} llamadas[i,j] <= max_llamadas*seleccionado[i];
s.t. SELECCIONAR_PARKING_B {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES}: sum{j in DISTRITOS} llamadas[i,j] >=seleccionado[i];

/*El número total de llamadas de un parking seleccionado no puede ser mayor que el 50% del total de llamadas de otro parking seleccionado*/
s.t. BALANCE_ESFUERZO {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, a in LOCALIZACIONES union NUEVAS_LOCALIZACIONES: a!=i}: sum{j in DISTRITOS} llamadas[i,j] <= (1 + porcentaje_balance)*sum{j in DISTRITOS}llamadas[a, j] + (1 - seleccionado[a])*max_llamadas;

/*Si las llamadas de un distrito son mayores o iguales al 75% de las llamadas máximas, se tienen que dividir entre más de un parking*/
s.t. DISTRIBUCION_LLAMADAS {j in DISTRITOS, i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES}: llamadas[i,j]<= (porcentaje_maximo * max_llamadas -1)*seleccionado_por_distrito[i,j];

/*Si un parking cubre llamadas de un distrito, tiene que cumplir al menos el 10% de estas*/
s.t. MINIMO_LLAMADAS {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, j in DISTRITOS}: llamadas[i,j] >= porcentaje_minimo*llamadas_distrito[j]*seleccionado_por_distrito[i,j];


