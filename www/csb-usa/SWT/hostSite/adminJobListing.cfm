<style type="text/css">
.hsText {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
	color: #000;
}
.JLtext {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	color: #000;
}
.white {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
	color: #FFF;
}
</style>
<cfparam name="url.section" default="adminJobListing">
<cfquery name="available_posistions" datasource="MySQL">
select *
from extra_web_jobs
where spring > 0
</cfquery>
<cfoutput>
<a href="http://www.csb-usa.com/SWT/participants.cfm?section=logout.cfm" class="black">Logout</a>
<table cellpadding=4 cellspacing=0>
	<Tr>
   	  <td></td><td colspan=6 align="center" bgcolor="##999999" class="white">No. of Positions Available</td>
	<tr>
    	<Td class="hsText">Position</Td>
        <Td class="hsText">Spring</Td>
        <Td class="hsText">Summer</Td>
        <td class="hsText">Winter</td>
    	<td class="hsText">Edit</td>
    	<td class="hsText">Delete</td>
    </tr>
<cfloop query="available_posistions">
	<Tr <cfif available_posistions.currentrow mod 2>bgcolor="cccccc"</cfif>>
    	<Td><cfif file is not ''>
        <a href="http://www.student-management.com/nsmg/uploadedfiles/extra_jobs/#file#">
		</cfif>
		  <span class="JLtext">#title#</span></Td><Td class="JLtext">#spring#</Td><Td class="JLtext">#summer#</Td><td class="JLtext">#winter#</td><td><a href="../international/edit_jpb.cfm?id=#jobid#"><img src="http://www.student-management.com/nsmg/pics/edit.png" border="0"></a></td><td><a href="../international/delete_job.cfm?id=#jobid#"><img src="http://www.student-management.com/nsmg/pics/delete.png" border="0"></a>
    </Tr>	
</cfloop>
</table>

<br />
<h3>Add a job:</h3>
<br />
<cfform method="post" action="http://www.csb-usa.com/SWT/participants.cfm?section=insert_job.cfm" enctype="multipart/form-data">
<table>
	<tr>

    	<td class="hsText">Position:</td><Td><cfinput type="text" name="title" size = 20 /></Td>
    </tr>    

    <tr>
        
        <Td class="hsText">Spring</Td><Td><cfinput type="text" name="spring" size = 20 /></Td>
    </tr>
    <tr><Td class="hsText">Summer</Td><Td><cfinput type="text" name="summer" size = 20 /></Td>
    </tr>
    <tr><td class="hsText">Winter</td><Td><cfinput type="text" name="winter" size = 20 /></Td>
    </tr>
 	<tr valign="middle">
    <td class="hsText">Additional File (PDF ONLY):</td><td><cfinput type="file" name="additional_file" class="hsText" size= "35"> </td>
    </tr>
 </table>
 <input type="submit" class="hsText" value="Post Job" />
</cfform>    

</cfoutput>