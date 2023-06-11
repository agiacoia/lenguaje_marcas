<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" />
  <xsl:template match="/">
    <html>
      <head>
        <title>Tarea 5 - LMSGI - Curso 2022-23</title>
        <style>
          table, th, td {
            width:500px;
            margin: 0 auto;
            text-align: center;
            border: 1px solid black;
            border-collapse: collapse;
          }
          th {
            color: white;
            background-color:grey;
          }
          .urgente {
            color: red;
            background-color:yellow;
          }
          .nocturno {
            color: white;
            background-color:black;
          }
        </style>
      </head>
      <body>
        <header>
          <h2>Lenguaje de Marcas y Sistemas de Gestión de Información</h2>
          <h2>Tarea 5: XPath y XSLT</h2>
          <h2>Autor/a: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</h2>
        </header>
        <h3>1. Lista ordenada por precio y apellido de los envíos a Sevilla. 
          Indicar el número de orden (con número), el precio, la moneda, el 
          apellido y el nombre. El orden será de mayor a menor precio y si 
          tienen el mismo precio por orden alfabético de apellido. </h3>
        <h5>Formato:<br/> 1) 33 euros - Sánchez, Carlos.</h5>
        
        <!-- AÑADIR AQUÍ EL CÓDIGO DEL EJERCICIO -->
        
        <xsl:for-each select="//envio[provincia='Sevilla']">
          <xsl:sort order="descending" data-type="number" select="precio"/>
          <xsl:sort order="ascending" data-type="text" select="apellido"/>
          <xsl:number value="position()" format="1) "/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="precio"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="precio/@moneda"/>
          <xsl:text> - </xsl:text>
          <xsl:value-of select="apellido"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="nombre"/>
          <xsl:text>.</xsl:text>
          <br/>
        </xsl:for-each>
                
        <h3>2. Número de envíos urgentes a Cádiz y su porcentaje respecto al 
          total de envíos a Cádiz</h3>
        <h5>Formato:<br/> Hay 4 envíos urgentes a Cádiz, que suponen el 28.57% 
                  de los 14 envíos totales registrados a Cádiz.</h5>
        
        <!-- AÑADIR AQUÍ EL CÓDIGO DEL EJERCICIO -->
        
        <xsl:variable name="cadiz_urgente" select="count(//envio[provincia='Cádiz' and prioridad='Urgente'])" />
        <xsl:variable name="cadiz" select="count(//envio[provincia='Cádiz'])" />
        <xsl:variable name="porcentaje" select="($cadiz_urgente div $cadiz)" />
        <xsl:text>Hay </xsl:text>
        <xsl:value-of select="$cadiz_urgente"/>
        <xsl:text> envíos urgentes a Cádiz, que suponen el </xsl:text>
        <xsl:value-of select='format-number($porcentaje, "0.00%")'/>
        <xsl:text> de  los </xsl:text>   
        <xsl:value-of select="$cadiz"/>   
        <xsl:text> envíos totales registrados a Cádiz.</xsl:text> 

        <h3>3. Lista ordenada (por código de envío) con el tipo de prioridad, 
          la provincia, el nombre y el apellido de todos los envío cuyo nombre 
          comience por 'A' y tengan una prioridad 'Normal', o 
          su apellido contenga una 'a' y la provincia sea 'Almería' o 'Granada'.</h3>
        <h5>Formato:<br/> 1.- (DBD72R - 24_horas - Granada). Carlos Cano.</h5>
        
        <!-- AÑADIR AQUÍ EL CÓDIGO DEL EJERCICIO -->
        
        <xsl:for-each select="//envio[(starts-with(nombre,'A') and prioridad='Normal')
                                   or ( contains(apellido,'a') and (provincia='Granada' or provincia='Almería'))]">
          <xsl:sort select="@codigo"/>
          <xsl:value-of select="position()"/>
          <xsl:text>.- (</xsl:text>
          <xsl:value-of select="@codigo"/>
          <xsl:text> - </xsl:text>
          <xsl:value-of select="prioridad"/>
          <xsl:text> - </xsl:text>
          <xsl:value-of select="provincia"/>
          <xsl:text>). </xsl:text>
          <xsl:value-of select="nombre"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="apellido"/>
          <xsl:text>.</xsl:text>
          <br />
        </xsl:for-each>
        
        <h3>4. Todas las provincias (ordenadas alfabeticamente). Indicar el número de 
          trabajadores que tiene cada una de ellas y su porcentaje respecto al total
          de dicha provincia.</h3>
        <h5>Formato:<br/> Almería: 11 envíos. Ingresos totales: 229 euros. Ingreso medio: 20.82 euros.</h5>
         
        <!-- AÑADIR AQUÍ EL CÓDIGO DEL EJERCICIO -->
        
        <xsl:for-each select="//envio[not(provincia=preceding::provincia)]"> 
          <xsl:sort select="provincia"/>
          <xsl:variable name="prov" select="provincia"/>
          <xsl:value-of select="$prov"/>
          <xsl:text>: </xsl:text>
          <xsl:variable name="envios" select="count(//envio[provincia=$prov])"/>
          <xsl:value-of select='format-number($envios, "0")'/>
          <xsl:text> envíos. Ingresos totales: </xsl:text>
          <xsl:variable name="ingreso" select="sum(//envio[provincia=$prov]/precio)"/>
          <xsl:value-of select='format-number($ingreso, "0")'/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="precio/@moneda"/>
          <xsl:text>. Ingreso medio: </xsl:text>
          <xsl:variable name="medio" select="$ingreso div $envios"/>
          <xsl:value-of select='format-number($medio, "0.00")'/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="precio/@moneda"/>
          <xsl:text>.</xsl:text>
          <br />
        </xsl:for-each>
        
        <h3>5. Crear una tabla, ordenada por fecha de entrega, de los envíos a Almería. 
          La tabla inluirá las columnas: fecha de entrega, provincia, código de envío y prioridad. 
          Estilos: La tabla deberá usar los estilos definidos en la plantilla que se proporciona en el ejercicio. 
          Los elementos tabla y las celdas usarán los estilos del descriptores 'table','th' y 'td'. 
          La cabecera usará el estilo del descriptor 'th'. Si la prioridad de un envío es 'Urgente' 
          esa celda usará el estilo del descriptor '.urgente'. Si la prioridad de un envío es 'Nocturno' 
          esa celda usará el estilo del descriptor '.nocturno'.</h3>
          <h5>Formato:</h5>
          <table>
            <tr>
                <th>Fecha</th><th>Provincia</th><th>Código de envío</th><th>Prioridad</th>
            </tr>
            <tr>
                <td>2023-02-??</td><td>Almería</td><td>??????</td><td>Normal</td>
            </tr>
            <tr>
                <td>2023-02-??</td><td>Almería</td><td>??????</td><td class="urgente">Urgente</td>
            </tr>
            <tr>
                <td>2023-02-??</td><td>Almería</td><td>??????</td><td class="nocturno">Nocturno</td>
            </tr>
          </table>
          <br/><br/>
        
        <!-- AÑADIR AQUÍ EL CÓDIGO DEL EJERCICIO -->
                  
        <table>
          <tr>
            <th>Fecha</th>
            <th>Provincia</th>
            <th>Código de envío</th>
            <th>Prioridad</th>
          </tr>
          <xsl:for-each select="//envio[provincia='Almería']">
            <xsl:sort order="ascending" data-type="text" select="fecha_entrega"/>
            <tr>
              <td>
                <xsl:value-of select="fecha_entrega"/>
              </td>
              <td>
                <xsl:value-of select="provincia"/>
              </td>
              <td>
                <xsl:value-of select="@codigo"/>
              </td>
              <xsl:choose>
                <xsl:when test="prioridad='Urgente'">
                  <td class="urgente">
                    <xsl:value-of select="prioridad"/>
                  </td>
                </xsl:when>
                <xsl:when test="prioridad='Nocturno'">
                  <td class="nocturno">
                    <xsl:value-of select="prioridad"/>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td>
                    <xsl:value-of select="prioridad"/>
                  </td>
                </xsl:otherwise>
              </xsl:choose>             
           </tr> 
          </xsl:for-each>
        </table>        
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
