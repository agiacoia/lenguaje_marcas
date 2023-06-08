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
            ol.listaA{
              counter-reset: item;
              list-style: none;
              margin-left: 0;
              padding-left: 0;
            }
              ol.listaA> li:before {
              content: counter(item) ") ";
              counter-increment: item;
            }   
            </style>
        </head>
        
        <body>
            <header>
                <h2>Lenguaje de Marcas y Sistemas de Gestión de Información</h2>
                <h2>Tarea 5: XPath y XSLT</h2>
                <h2>Autor/a: Andrea Giacoia Trombotti</h2>
            </header>
            <h3>A. Lista ordenada por precio y apellido de los envíos a Sevilla. Indicar el número de orden (con número), 
            el precio, la moneda, el apellido y el nombre. El orden será de mayor a menor precio y si tienen el mismo precio por orden alfabético de apellido.</h3>
            <h5>Formato:<br/> 1) 33 euros - Sánchez, Carlos.</h5>
            <br/><br/>
                       
            <ol class="listaA">
                <xsl:for-each select="//envio[provincia='Sevilla']">
                    <xsl:sort select="precio" order="descending" data-type="number"/>
                    <xsl:sort select="apellido" order="ascending"/>
                    <li>
                        <xsl:value-of select="concat( precio, ' euros - ', apellido, ', ', nombre,'.' )" />
                    </li>
                </xsl:for-each>
            </ol>
            <br/>

            <h3>B. Número de envíos urgentes a Cádiz y su porcentaje respecto al 
              total de envíos a Cádiz</h3>
            <h5>Formato:<br/> Hay 4 envíos urgentes a Cádiz, que suponen el 28.57% de los 14 envíos totales registrados a Cádiz.</h5>
            <br/><br/>
            
            <xsl:variable name="total_cadiz" select="count(//envio[provincia='Cádiz'])"/>
            <xsl:variable name="urgentes_cadiz" select="count(//envio[provincia='Cádiz' and prioridad='Urgente'])"/>
            <xsl:value-of select="concat('Hay ', $urgentes_cadiz, ' envíos urgentes a Cádiz, que suponen el ', format-number(($urgentes_cadiz div $total_cadiz) * 100, '0.00'), 
            '% de los ', $total_cadiz, ' envíos totales registrados a Cádiz.')" />
            <br/>
                
            <h3>C. Lista ordenada (por código de envío) con el tipo de prioridad, la provincia, el nombre y el apellido de todos los envío cuyo nombre
              comience por 'A' y tengan una prioridad 'Normal', o su apellido contenga una 'a' y la provincia sea 'Almería' o 'Granada'.
            </h3>
            <h5>Formato:<br/> 1.- (DBD72R - 24_horas - Granada). Carlos Cano.</h5>
            <br/><br/>
            
            <ol>
                <xsl:for-each select="//envio[starts-with(nombre,'A') and prioridad='Normal'] | //envio[contains(apellido,'a') and (provincia='Almería' or provincia='Granada')]">
                    <xsl:sort select="@codigo"/>
                    <li>
                    <xsl:value-of select="concat('- (', @codigo, ' - ', prioridad, ' - ', provincia, '). ', nombre, ' ', apellido, '.')"/>
                    </li>
                </xsl:for-each> 
            </ol>                 
            <br/>
            
            <h3>D. Lista de todas las provincias (ordenadas alfabeticamente) con su número de envíos, ingresos totales (suma de todos sus precios) e ingreso medio</h3>
            <h5>Formato:<br/> Almería: 11 envíos. Ingresos totales: 229 euros. Ingreso medio: 20.82 euros.</h5>
            <br/><br/>   
            
            <xsl:for-each select="//envio">
                <xsl:sort select="provincia"/>
                    <xsl:if test="not(preceding-sibling::envio[provincia=current()/provincia])">
                        <xsl:variable name="prov" select="provincia"/>
                        <xsl:variable name="envios" select="count(//envio[provincia=$prov])"/>
                        <xsl:variable name="ingresos" select="sum(//envio[provincia=$prov]/precio)"/>
                        <xsl:variable name="ingreso_medio" select="format-number($ingresos div $envios, '0.00')"/>
                        <xsl:value-of select="concat($prov, ': ', $envios, ' envíos. Ingresos totales: ', $ingresos, ' euros. Ingreso medio: ', $ingreso_medio, ' euros.')"/><br/>
                    </xsl:if>
            </xsl:for-each>
            <br/>
            
            <h3>E. Crear una tabla, ordenada por fecha de entrega, de los envíos a Almería. La tabla incluirá las columnas: fecha de entrega, provincia, 
              código de envío y prioridad. Estilos: La tabla deberá usar los estilos definidos en la plantilla que se proporciona en el ejercicio. Los 
              elementos tabla y las celdas usarán los estilos de los selectores 'table','th' y 'td'. La cabecera usará el estilo del selector 'th'. 
              Si la prioridad de un envío es 'Urgente' esa celda usará el estilo del selector '.urgente'. Si la prioridad de un envío es 'Nocturno' esa 
              celda usará el estilo del selector '.nocturno'.</h3>
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

            <table>
                <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Provincia</th>
                        <th>Código de envío</th>
                        <th>Prioridad</th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="envios/envio[provincia='Almería']">
                    <xsl:sort select="fecha_entrega" data-type="text" order="ascending"/>
                    <tr>
                        <td><xsl:value-of select="fecha_entrega"/></td>
                        <td><xsl:value-of select="provincia"/></td>
                        <td><xsl:value-of select="@codigo"/></td>
                    <td>
                        <xsl:choose>
                        <xsl:when test="prioridad='Urgente'">
                          <span class="urgente"><xsl:value-of select="prioridad"/></span>
                        </xsl:when>
                        <xsl:when test="prioridad='Nocturno'">
                          <span class="nocturno"><xsl:value-of select="prioridad"/></span>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="prioridad"/>
                        </xsl:otherwise>
                        </xsl:choose>
                    </td>
                    </tr>
                    </xsl:for-each>
                </tbody>
            </table>
        </body>
    </html>
  </xsl:template>
</xsl:stylesheet>