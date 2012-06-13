<cfquery name="changeProgram" datasource="#application.dsn#">
select studentid, programid
from smg_students
where (programid =319 or programid = 318) 
and app_current_status < 9
</cfquery>

<table>
	<tr>
    	<Td>Student</Td><Td>Current Program</Td><td>New Program</td>
    </tr>
    <cfoutput>
<cfloop query="changeProgram">
	
    
    <Tr>
    	<td>#studentid#</td><Td>#programid#</Td><td><cfif programid eq 318>332<cfelse>333</cfif></td>
    </Tr> 
    <tr>
    	<td colspan=3>update smg_students
    set programid = <cfif programid eq 318>332<cfelse>333</cfif>
    where studentid = #studentid#
    <cfquery name="commitChange" datasource="#application.dsn#">
    update smg_students
    set programid = <cfif programid eq 318>332<cfelse>333</cfif>
    where studentid = #studentid#
    </cfquery>
    complete.
    </td>
    </tr>
</cfloop>
</cfoutput>
</table>