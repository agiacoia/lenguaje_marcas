(: Ejercicio 1 :)
(: Obtener la marca, modelo y precio de los vehiculos comerciales que le cuesten a la empresa menos de 100.000 €, ordenados desde el más caro al más barato.
Estructura: 
<vehiculo>
   <marca>Marca</marca>
   <modelo>Modelo</modelo>
   <precio moneda="EUR">XXX</precio>
</vehiculo>
:)

let $vehiculos := doc("llegaya.xml")//vehiculos/vehiculo[precio < 100000]

for $vehiculo in $vehiculos

order by $vehiculo/precio descending

return
  <vehiculo>
      {$vehiculo/marca}
      {$vehiculo/modelo}
      {$vehiculo/precio}
  </vehiculo>
,


(: Ejercicio 2 :)
(: Obtener el nif, zona de reparto, nombre, teléfono y salario (en ese orden) de los repartidores que han realizado más 5 repartos con un vehículos de la marca "Tesla" en el 2023. (No sabemos su código, sólo la marca del vehiculo).
Resultado: 
<repartidor nif="23234234B" zona="D">
   <nombre>Víctor</nombre>
   <telefono>607624122</telefono>
   <salario unidad="Euros">1100</salario>
</repartidor>
:)

for $vehiculo in doc("llegaya.xml")//vehiculo[marca='Tesla'], 
    $reparto in doc("llegaya.xml")//reparto,
    $repartidor in doc("llegaya.xml")//repartidor

where 

        $reparto/@vehiculo = $vehiculo/@cod
    and $repartidor/@nif = $reparto/@repartidor
    and $reparto > 5  
    and contains($reparto/@fechareparto, "2023")
  
return
   <repartidor nif="{$repartidor/@nif}" zona="{$repartidor/@zona}">
        {$repartidor/nombre}
        {$repartidor/telefono}
        {$repartidor/salario}
   </repartidor>
,


(: Ejercicio 3 :)
(: Obtener (usando let) el número total de vehículos comerciales que tiene llegaya, el coste total de adquisición y el precio del vehículo más caro.
Estructura:
<totales>
   <flota_vehiculos>X</flota_vehiculos>
   <coste_total moneda="EUR">XXX</coste_total>
   <mas_caro moneda="EUR">XXX</mas_caro>
</totales>
:)

let $vehiculos := doc("llegaya.xml")//vehiculos/vehiculo
let $flota_vehiculos := count($vehiculos)
let $coste_total := sum($vehiculos/precio)
let $mas_caro := max($vehiculos/precio)
return
  <totales>
    <flota_vehiculos>{$flota_vehiculos}</flota_vehiculos>
    <coste_total moneda="EUR">{$coste_total}</coste_total>
    <mas_caro moneda="EUR">{$mas_caro}</mas_caro>
  </totales>
,


(: Ejercicio 4 :)
(: Obtener, usando let, la suma de los salarios de los repartidores que cobran menos de 1.000 €, que viven en la provincia de Sevilla (excepto los que viven en la capital) y además no tienen zona A. 
Estructura:
<total_salarios moneda="EUR">XXX</total_salarios>
:) 

let $total_salarios := sum(doc("llegaya.xml")//repartidores/repartidor[@zona!="A" and salario<1000 and provincia="Sevilla" and localidad!="Sevilla"]/salario)

return 
  <total_salarios moneda="EUR">{$total_salarios}</total_salarios>
,


(: Ejercicio 5 :)
(: Obtener el nombre del cliente, los paquetes que incluye esa entrega, el coste de la entrega y el precio con un descuento del 50% para empleados. Ordenar por el nombre del cliente desde el nombre más corto hasta el más largo.
Estructura:
<entrega>
   <nombre>Nombre</nombre>
   <paquetes>XX</paquetes>
   <importe moneda="EUR">XX</importe>
   <importe_empleados moneda="EUR">XX</importe_empleados>
</entrega>
:)

let $entregas := doc("llegaya.xml")//entregas/entrega

for $entrega in $entregas
 
  let $importe_empleados := $entrega/importe div 2

order by string-length($entrega/nombre)

return
  <entrega>
    {$entrega/nombre}
    {$entrega/paquetes}
    {$entrega/importe}
    <importe_empleados moneda="EUR">{$importe_empleados}</importe_empleados>
  </entrega>
