<cfquery name="available_posistions" datasource="MySQL">
select *
from extra_web_jobs
order by title
</cfquery>
<cfoutput>
<a href="logout.cfm">Logout</a>
<table cellpadding=4 cellspacing=0>
	<Tr>
    	<td></td><td colspan=3 bgcolor="##999999" align="center">Spots Available</td>
	<tr>
    	<Td><u>Host Site</Td><Td><u>Spring</Td><Td><u>Summer</Td><td><u>Winter</td>
    </tr>
<cfloop query="available_posistions">
	<Tr <cfif available_posistions.currentrow mod 2>bgcolor="cccccc"</cfif>>
    	<Td><cfif file is not ''>
        <a href="http://www.student-management.com/nsmg/uploadedfiles/extra_jobs/#file#">
		</cfif>
		#title#</Td><Td>#spring#</Td><Td>#summer#</Td><td>#winter#</td><td><a href="" onClick="javascript: win=window.open('edit_job_listing.cfm?jobid=#available_posistions.jobid#', 'Settings', 'height=450, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img border=0 src="http://www.student-management.com/nsmg/pics/edit.png"></a></td><td><a href="delete_job.cfm?id=#jobid#"><img src="http://www.student-management.com/nsmg/pics/delete.png"></a></td>
    </Tr>	
</cfloop>
</table>

<br />
Add a job:
<br />
<cfform method="post" action="insert_job.cfm" enctype="multipart/form-data">
<table>
	<tr>

    	<td>Host Site:</td><Td><cfinput type="text" name="title" size = 20 /></Td>
    </tr>    

    <tr>
        
        <Td>Spring</Td><Td><cfinput type="text" name="spring" size = 20 value=0></Td>
    </tr>
    <tr><Td>Summer</Td><Td><cfinput type="text" name="summer" size = 20 value=0></Td>
    </tr>
    <tr><td>Winter</td><Td><cfinput type="text" name="winter" size = 20 value=0></Td>
    </tr>
 	<tr>
    <td valign="top">Additional File (PDF ONLY):</td><td><cfinput type="file" name="additional_file" size= "35"> </td>
    </tr>
 </table>
 <input type="submit" value="Post Job" />
</cfform>    

</cfoutput>