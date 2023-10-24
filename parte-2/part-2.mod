/*mod*/

set LOCALIZACIONES;
set NUEVAS_LOCALIZACIONES;
set DISTRITOS;
var llamadas {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, j in DISTRITOS} integer >=0;
param tiempo_llamada {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, j in DISTRITOS};
param llamadas_distrito {j in DISTRITOS};
/*param llamadas_maximas {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES};*/
var asignadas{i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES} binary;
var asignada_distrito{i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, j in DISTRITOS} binary;
param coste_construir;
param coste_minuto;
param max_llamadas;
param tiempo_maximo;

/*Funcion objetivo a minimizar*/
minimize COSTE: sum{i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, j in DISTRITOS} tiempo_llamada[i, j] * llamadas[i,j]*coste_minuto + sum{i in NUEVAS_LOCALIZACIONES} coste_construir*asignadas[i];

/* Todas las llemadas de los distritos tienen que ser atendidas*/
s.t. LLAMADAS_EXACTAS {j in DISTRITOS}: sum{i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES} llamadas[i,j] = llamadas_distrito[j];

/* Cada locaclización no puede atender más de 10000 llamadas*/
s.t. LLAMADAS_MAXIMO {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES}: sum{j in DISTRITOS} llamadas[i,j] <= max_llamadas;

s.t. TIEMPO_MAXIMO {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, j in DISTRITOS}: llamadas[i,j]*tiempo_llamada[i,j] <= llamadas[i,j]*tiempo_maximo;

/*s.t. BALANCE_ESFUERZO1 {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, a in LOCALIZACIONES union NUEVAS_LOCALIZACIONES: a!=i}: sum{j in DISTRITOS} llamadas[i,j] - 1.5 * sum{j in DISTRITOS} llamadas[a, j] <= (1 - asignadas[i])*llamadas_maximas[i];
s.t. BALANCE_ESFUERZO2 {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, a in LOCALIZACIONES union NUEVAS_LOCALIZACIONES: a!=i}: sum{j in DISTRITOS} llamadas[i,j] - 1.5 * sum{j in DISTRITOS} llamadas[a, j] <= (1 - asignadas[a])*llamadas_maximas[i];*/

s.t. BALANCE_ESFUERZO {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, a in LOCALIZACIONES union NUEVAS_LOCALIZACIONES: a!=i}: sum{j in DISTRITOS} llamadas[i,j] <= sum{j in DISTRITOS}1.5*llamadas[a, j];


/*s.t. BALANCE_ESFUERZO2 {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, a in LOCALIZACIONES union NUEVAS_LOCALIZACIONES: a!=i}: 
    asignadas[a] * (sum{j in DISTRITOS} llamadas[i,j]) <= 1.5 * asignadas[a] * (sum{j in DISTRITOS} llamadas[a, j]);*/


/*s.t. ASIGNADA_SI_LLAMADAS1 {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, j in DISTRITOS}: asignada_distrito[i,j] >= (llamadas[i,j]/(0.1*llamadas_distrito[j]));
s.t. ASIGNADA_SI_LLAMADAS2 {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, j in DISTRITOS}: asignada_distrito[i,j] <= (llamadas[i,j]/llamadas_distrito[j]);*/

s.t. DISTRIBUCION_LLAMADAS {j in DISTRITOS: llamadas_distrito[j] >= 0.75*max_llamadas}: sum{i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES} asignada_distrito[i,j] >= 2;
s.t. LLAMADAS_10A {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, j in DISTRITOS}: llamadas[i,j] >= 0.1*llamadas_distrito[j]*asignada_distrito[i,j];
s.t. LLAMADAS_10B {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, j in DISTRITOS}: llamadas[i,j] <= llamadas_distrito[j]*asignada_distrito[i,j];

s.t. CONSTRUCCION1 {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES}: sum{j in DISTRITOS} llamadas[i,j] <= max_llamadas*asignadas[i];
s.t. CONSTRUCCION2 {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES}: sum{j in DISTRITOS} llamadas[i,j] >=asignadas[i];
/*s.t. CONSTRUCCION2 {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES, j in DISTRITOS}: llamadas[i,j] <= llamadas_maximas[i]*asignada_distrito[i,j];*/
/*s.t. CONSTRUCCION2 {i in LOCALIZACIONES union NUEVAS_LOCALIZACIONES}: asignadas[i] <= sum{j in DISTRITOS} (llamadas[i,j]/llamadas_maximas[i]);*/
