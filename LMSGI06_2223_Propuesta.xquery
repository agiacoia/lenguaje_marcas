(: Ejercicio 1 :)
(: Obtener la marca, modelo y precio de los vehiculos comerciales que le cuesten a la empresa menos de 100.000 €, ordenados desde el más caro al más barato.
Estructura: 
<vehiculo>
   <marca>Marca</marca>
   <modelo>Modelo</modelo>
   <precio moneda="EUR">XXX</precio>
</vehiculo>
:)
"EJERCICIO 1",
for $p in doc("llegaya.xml")//vehiculo
where $p/precio < 100000
order by $p/precio descending
return
<vehiculo>{$p/*}</vehiculo> 

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
"EJERCICIO 2",
for $v in doc("llegaya.xml")//vehiculo, 
    $r in doc("llegaya.xml")//repartidor,
    $e in doc("llegaya.xml")//reparto
where 
	  $v/marca = "Tesla" and
    $r/@nif = $e/@repartidor and
    $e/@vehiculo = $v/@cod and
    $e > 5 and
	  ends-with($e/@fechareparto,'2023')
return 
<repartidor>{$r/@nif, $r/@zona, $r/nombre, $r/telefono, $r/salario}</repartidor>

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
"EJERCICIO 3",
let $vehiculo := doc("llegaya.xml")//vehiculo,
    $max := max(//precio)
return 
  <totales>
    <flota_vehiculos>{count(distinct-values($vehiculo/modelo))}</flota_vehiculos>
    <coste_total moneda="EUR">{sum($vehiculo/precio)}</coste_total>
    <mas_caro moneda="EUR">{$max}</mas_caro>
  </totales>

,

(: Ejercicio 4 :)
(: Obtener, usando let, la suma de los salarios de los repartidores que cobran menos de 1.000 €, que viven en la provincia de Sevilla (excepto los que viven en la capital) y además no tienen zona A. 
Estructura:
<total_salarios moneda="EUR">XXX</total_salarios>
:) 
"EJERCICIO 4",
let $s := doc("llegaya.xml")//repartidor[provincia='Sevilla' and @zona!='A' and localidad!='Sevilla' and salario<1000 ]
return 
<total_salarios moneda="EUR">
    {sum($s/salario)}
</total_salarios>

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
"EJERCICIO 5",
for $e in //entrega
order by string-length(data($e/nombre)) ascending
return 
   <entrega>
      {$e/nombre}
      {$e/paquetes}
      <importe moneda="EUR">{$e/importe/text()}</importe>
      <importe_empleados moneda="EUR">{$e/importe * 0.50}</importe_empleados>
   </entrega>