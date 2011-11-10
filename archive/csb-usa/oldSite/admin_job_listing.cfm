<cfquery name="available_posistions" datasource="MySQL">
select *
from extra_web_jobs
where spring > 0
</cfquery>
<cfoutput>
<a href="logout.cfm">Logout</a>
<table cellpadding=4 cellspacing=0>
	<Tr>
    	<td></td><td colspan=3 bgcolor="##999999" align="center">No. of Posistions Avail</td>
	<tr>
    	<Td><u>Posistion</Td><Td><u>Spring</Td><Td><u>Summer</Td><td><u>Winter</td>
    </tr>
<cfloop query="available_posistions">
	<Tr <cfif available_posistions.currentrow mod 2>bgcolor="cccccc"</cfif>>
    	<Td><cfif file is not ''>
        <a href="http://www.student-management.com/nsmg/uploadedfiles/extra_jobs/#file#">
		</cfif>
		#title#</Td><Td>#spring#</Td><Td>#summer#</Td><td>#winter#</td><td><a href="edit_jpb.cfm?id=#jobid#">E<img src="http://www.student-management.com/nsmg/pics/edit.png"></a></td><td><a href="delete_job.cfm?id=#jobid#"><img src="http://www.student-management.com/nsmg/pics/delete.png"></a>
    </Tr>	
</cfloop>
</table>

<br />
Add a job:
<br />
<cfform method="post" action="insert_job.cfm" enctype="multipart/form-data">
<table>
	<tr>

    	<td>Posistion:</td><Td><cfinput type="text" name="title" size = 20 /></Td>
    </tr>    

    <tr>
        
        <Td>Spring</Td><Td><cfinput type="text" name="spring" size = 20 /></Td>
    </tr>
    <tr><Td>Summer</Td><Td><cfinput type="text" name="summer" size = 20 /></Td>
    </tr>
    <tr><td>Winter</td><Td><cfinput type="text" name="winter" size = 20 /></Td>
    </tr>
 	<tr>
    <td valign="top">Additional File (PDF ONLY):</td><td><cfinput type="file" name="additional_file" size= "35"> </td>
    </tr>
 </table>
 <input type="submit" value="Post Job" />
</cfform>    

</cfoutput>