<cfquery name="available_posistions" datasource="MySQL">
select *
from extra_web_jobs
where jobid = #url.jobid#
</cfquery>
<cfoutput>


<br />
Edit this listing:
<br />

<cfform method="post" action="qr_update_job.cfm?jobid=#url.jobid#" enctype="multipart/form-data">
<table>
	<tr>

    	<td>Host Site:</td><Td><cfinput type="text" name="title" size = 20  value="#available_posistions.title#" /></Td>
    </tr>    

    <tr>
        
        <Td>Spring</Td><Td><cfinput type="text" name="spring" size = 5  value="#available_posistions.spring#"></Td>
    </tr>
    <tr><Td>Summer</Td><Td><cfinput type="text" name="summer" size = 5  value="#available_posistions.summer#"></Td>
    </tr>
    <tr><td>Winter</td><Td><cfinput type="text" name="winter" size = 5  value="#available_posistions.winter#"></Td>
    </tr>
 	<tr>
    <td valign="top">Additional File (PDF ONLY):</td><td><cfinput type="file" name="additional_file" size= "35"> </td>
    </tr>
 </table>
 <input type="submit" value="Update Job" />
</cfform>    

</cfoutput>