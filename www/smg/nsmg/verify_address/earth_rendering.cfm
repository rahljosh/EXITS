<cfquery name="homes" datasource="bricks">
select *
from homes
</cfquery>
<cfoutput>
<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://earth.google.com/kml/2.1">
<cfloop query="homes">
  <Placemark>    
  	<name>#street#</name>    
  	<description>Beautiful home on corner lot</description>   
	   <Point>      <coordinates>#latitude#,#longitude#,0</coordinates>    
	   </Point>
  </Placemark>
 </cfloop>
</kml>
</cfoutput>