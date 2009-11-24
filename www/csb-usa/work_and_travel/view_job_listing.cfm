<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler2(form){
var URL = document.formmonth.month.options[document.formmonth.month.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>

<cfparam name="url.season" default="spring">
<table border=0>
	<tr>
    	<td valign="top">Viewing jobs available in:</td><td valign="top"> <form name="formmonth">
		<select name="month" onChange="javascript:formHandler2()">
		<option value="job-list.cfm?season=spring" <cfif url.season is 'spring'>selected</cfif>>Spring</option>
		<option value="job-list.cfm?season=summer" <cfif url.season is 'summer'>selected</cfif>>Summer</option>
        <option value="job-list.cfm?season=winter" <cfif url.season is 'winter'>selected</cfif>>Winter</option>
		</select>
	</form>
    </td>
    <td align="right"> &nbsp;<a href="logout.cfm">Logout</a></td>
   </tr>
 </table>

<cfquery name="available_posistions" datasource="MySQL">
select title, file,  (#url.season#) as spots
from extra_web_jobs

where #url.season# > 0
order by title
</cfquery>
<cfoutput>


<table width=100% cellpadding=4 cellspacing=0>
	
	<tr>
    	<Td><u>Host Site</Td><Td><u>Spots Available</td>
    </tr>
<cfloop query="available_posistions">
	<Tr <cfif available_posistions.currentrow mod 2>bgcolor="cccccc"</cfif>>
    	<Td><cfif file is not ''>
        <a href="http://www.student-management.com/nsmg/uploadedfiles/extra_jobs/#file#">
		</cfif>
		#title#</Td><Td>#spots#</td>
    </Tr>	
</cfloop>
</table>

</cfoutput>