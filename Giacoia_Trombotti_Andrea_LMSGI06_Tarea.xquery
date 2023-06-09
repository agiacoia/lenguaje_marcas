(: Ejercicio 1 :)
(: Obtener el nombre y salario de los empleados que cobren entre 500 y 1450 € (ambos incluidos).
Resultado: 
<empleado>
   <nombre>Pepe</nombre>
   <salario unidad="Euros">1100</salario>
</empleado>
<empleado>
   <nombre>Víctor</nombre>
   <salario unidad="Euros">500</salario>
</empleado>
<empleado>
   <nombre>Luisa</nombre>
   <salario unidad="Euros">1450</salario>
</empleado>
<empleado>
   <nombre>Pedro</nombre>
   <salario unidad="Euros">1050</salario>
</empleado>
<empleado>
   <nombre>Andrés</nombre>
   <salario unidad="Euros">700</salario>
</empleado>
:)

for $empleado in doc("LMSGI06.xml")//empleado
let $salario := $empleado/salario
where 
  $salario>=500 and $salario<=1450 
return 
  <empleado>{$empleado/nombre} {$empleado/salario}</empleado>
,


(: Ejercicio 2 :)
(: Obtener el nombre y el teléfono de todos los clientes que han comprado, uno o dos productos de "Teclado" (No sabemos su código, sólo el nombre del producto)
Resultado: 
<cliente>
   <nombre>Pedro Rojas</nombre>
   <telefono>607234125</telefono>
</cliente>
<cliente>
   <nombre>Pedro Rodríguez</nombre>
   <telefono>608822173</telefono>
</cliente>
:)

for $producto in doc("LMSGI06.xml")//producto[nombre='Teclado'], 
    $compras in doc("LMSGI06.xml")//cantidad,
    $cliente in doc("LMSGI06.xml")//cliente
    
let $pcodigo := $producto/@cod
where 
      $compras/@producto = $pcodigo 
  and $compras < 3 
  and $cliente/@cod = $compras/@cliente
  
return <cliente>{$cliente/nombre} {$cliente/telefono}</cliente>
,


(: Ejercicio 3 :)
(: Obtener los nombres de todos los productos, ordenados primero por precio (de menor a mayor) y luego por orden alfabético ascendente.
Resultado:
<nombre>Ratón</nombre>
<nombre>Kit soldadura</nombre>
<nombre>Teclado</nombre>
<nombre>Disco duro SSD</nombre>
<nombre>NAS</nombre>
<nombre>Apple mini</nombre>
:)

for $producto in doc("LMSGI06.xml")//producto 
        
let $precio := $producto/precio
let $nombre := $producto/nombre

order by $precio ascending , $nombre ascending

return  $nombre 
,


(: Ejercicio 4 :)
(: Obtener (usando let) el número total de empleados y el salario total que tiene que pagarles la empresa en 5 años.
Resultado:
<totales>
   <empleados>7</empleados>
   <salario_5annos moneda="EUR">41000</salario_5annos>
</totales>
:)

for $emp in doc("LMSGI06.xml")//empleados
        
let $total :=  count($emp/empleado)
let $salarios := ((sum($emp/empleado/salario))*12*5)

return  <totales>
          <empleados> {$total} </empleados> 
          <salario_5annos moneda="EUR"> {$salarios} </salario_5annos>
        </totales>
,


(: Ejercicio 5 :)
(: Obtener el nombre de los productos que han sido comprados en total más de 5 veces, su precio unitario, el número de productos vendidos, así como el valor total de esas ventas en €. 
Resultado:
<producto>
   <nombre>Disco duro SSD</nombre>
   <precio moneda="EUR">320</precio>
   <ventas>14</ventas>
   <total moneda="EUR">4480</total>
</producto>
<producto>
   <nombre>Teclado</nombre>
   <precio moneda="EUR">30</precio>
   <ventas>6</ventas>
   <total moneda="EUR">180</total>
</producto>
:)

for  $compra in doc("LMSGI06.xml")//cantidad,
     $producto in doc("LMSGI06.xml")//producto
 
 
where $producto/@cod = $compra/@producto

group by $codigo := $compra/@producto 

where sum($compra) > 5
    
return 
<producto>
           {$producto/nombre}
           {$producto/precio}
           <ventas>{sum($compra)}</ventas>
           <total moneda="EUR" >{$producto/precio * sum($compra) }</total> 
</producto>
,


(: Ejercicio 6 :)
(: Obtener el nombre del curso con el menor número de plazas, el precio del curso más caro y el salario el empleado que más cobra. 
Resultado:
<curso>
   <menos_plazas>RPAS</menos_plazas>
   <mas_caro moneda="EUR">749</mas_caro>
   <mayor_salario moneda="EUR">1800</mayor_salario>
</curso>
:)

for $precio in (for $c in doc("LMSGI06.xml")//curso/precio order by xs:integer($c/string()) descending return $c)[1],
$curso in (for $c in doc("LMSGI06.xml")//curso order by  xs:integer($c/plazas/string()) ascending return $c)[1],
$salario in (for $c in doc("LMSGI06.xml")//empleado/salario order by  xs:integer($c/string()) descending return $c)[1]

let $nombre := $curso/nombre
 
return 
<curso>
  <menos_plazas> {$nombre/text()} </menos_plazas>
  <mas_caro moneda="EUR"> {$precio/text()} </mas_caro>
  <mayor_salario moneda="EUR">{$salario/text()}</mayor_salario>
</curso>	
,


(: Ejercicio 7 :)
(: Obtener, usando let, la suma (en €) de los salarios de los empleados que viven en las provincias de Granada o Sevilla o tienen código B o C, excepto los que viven en las capitales. 
Estructura:
<total_salarios moneda="EUR">XXXX</total_salarios>
:) 

let $total := sum( 
  for $emp in doc("LMSGI06.xml")//empleado[@cod='B' or @cod='C'] | //empleado[localidad='Granada' or localidad='Sevilla']
  where $emp/provincia != $emp/localidad 
  return $emp/salario
)
return 
<total_salarios moneda="EUR">{$total} </total_salarios>
,


(: Ejercicio 8 :)
(: Obtener los nombres completos de todos los profesores cuyo apellido acaben en "ez", eliminando los repetidos e indicar todas las aulas en la que da clase. Ordenar por nombre desde el más largo hasta el más corto. 
Resultado:
<profesor>
   <nombre>Manuel Antonio Rodriguez</nombre>
   <aula>1</aula>
</profesor>
<profesor>
   <nombre>Aitor Gómez</nombre>
   <aula>2</aula>
   <aula>1</aula>
</profesor>
:)

 for $prof in doc("LMSGI06.xml")//curso[substring(profesor, string-length(profesor)-1) = 'ez']
 group by $nombre := $prof/profesor
 order by string-length($nombre) descending
 return 
 <profesor> 
   <nombre>{$nombre}</nombre>  
   {$prof/aula}
 </profesor>
,


(: Ejercicio 9 :)
(: Obtener la media de los precios de todos los cursos, la suma de los precios de los cursos de la sala 1, el total de plazas que oferta el profesor "Aitor Gómez" en todos sus cursos.
Estructura:
<cursos>
   <media moneda="EUR">XXX.X</media>
   <total_aula1 moneda="EUR">XXX</total_aula1>
   <plazas_Aitor_Gomez>XX</plazas_Aitor_Gomez>
</cursos>
:)

 for $f in doc("LMSGI06.xml")//formacion
 
 let $media := sum($f/curso/precio) div count($f/curso) 
 
 let $aula := sum($f/curso[aula="1"]/precio) 
 
 let $plazas := sum($f/curso[profesor="Aitor Gómez"]/plazas) 
 
 return 
<cursos>
   <media moneda="EUR">{$media}</media>
   <total_aula1 moneda="EUR">{$aula}</total_aula1>
   <plazas_Aitor_Gomez>{$plazas}</plazas_Aitor_Gomez>
</cursos>
, 


(: Ejercicio 10 :)
(: Obtener el nombre del curso más largo y quién lo imparte, así como su precio sin iva y el precio con un iva del 21% y el total en € que genera el curso si se ocupan todas sus plazas.
Estructura:
<curso>
   <nombre>XXX</nombre>
   <profesor>XXX</profesor>
   <precio cuota="Mensual" moneda="EUR">XXX</precio>
   <precio_conIVA moneda="EUR">XXX.XX</precio_conIVA>
   <total_curso moneda="EUR">XXXX</total_curso>
</curso>
:)

for $curso in (for $c in doc("LMSGI06.xml")//curso order by string-length($c/nombre) descending return $c)[1]

let $precioiva := $curso/precio * 1.21
let $totalcurso := $precioiva * $curso/plazas
  
 return 
 <curso>
 {$curso/nombre}
 {$curso/profesor}
 {$curso/precio}
 <precio_conIVA moneda="EUR">{format-number($precioiva, '#0.00')}</precio_conIVA>
 <total_curso moneda="EUR">{format-number($totalcurso, '#0.00')}</total_curso>
 </curso>