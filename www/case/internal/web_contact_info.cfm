The following information was submitted via the website:
<br /><br />
<cfquery name="web_info" datasource="caseusa">
select *, smg_states.statename
from case_web_contacts
LEFT JOIN smg_states on smg_states.id = case_web_contacts.state
where contactid = #url.id#
</cfquery>
<cfoutput query="web_info">
<br>
<table>
	<Tr>
    	<td>

<table>
	<tr>
    	<th colspan=2>Location Information</th>
	<Tr>
    	<Td>Name:</Td><td> #firstname# #lastname#</td>
    </Tr>
	<Tr>
    	<Td>Address:</Td><td> #address#</td>
    </Tr>
	<Tr>
    	<Td>City:</Td><td> #city#</td>
    </Tr>
	<Tr>
    	<Td>State:</Td><td> #statename#</td>
    </Tr>
 	<Tr>
    	<Td>Zip:</Td><td> #zip#</td>
    </Tr>    
</table>
</td>
<td>
<table>
	<tr>
    	<th colspan=2>Contact Information</th>
	<Tr>
    	<Td>Phone:</Td><td> #phone#</td>
    </Tr>
	<Tr>
    	<Td>Email:</Td><td> #email#</td>
    </Tr>
	<Tr>
    	<Td>Cell:</Td><td> #cellphone#</td>
    </Tr>
	<Tr>
    	<Td>Learned:</Td><td> #where_learn_case #</td>
    </Tr>
 	<Tr>
    	<Td>Zip:</Td><td> #zip#</td>
    </Tr>    
</table>
</td>
</tr>
<tr>
<td colspan=2>
<strong>Comments:</strong><br>
#comments#
</td>
</table>
</cfoutput>