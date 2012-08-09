<cfquery name="available_posistions">
select *
from extra_web_jobs
</cfquery>
<table>
	<tr>
    	<Td>Posistion</Td><td>Location</td><td>Wage</td><Td>Spring</Td><Td>Summer</Td><td>Winter</td>
    </tr>
<cfloop query="available_posistions">
	<Tr>
    	<Td>#title#</Td><td>#location#</td><td>#salary#</td><Td>#spring#</Td><Td>#summer#</Td><td>#winter#</td>
    </Tr>	
</cfloop>
</table>
