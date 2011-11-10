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

<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler2(form){
var URL = document.formmonth.month.options[document.formmonth.month.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>
<cfparam name="url.section" default="viewJobListing">
<cfparam name="url.season" default="spring">
<table border=0>
	<tr>
    	<td valign="middle" class="hsText">Viewing jobs available in:</td><td valign="top"> <form name="formmonth">
		<select name="month" onChange="javascript:formHandler2()">
		<option value="http://www.csb-usa.com/SWT/participants.cfm?section=job-list.cfm?season=spring" <cfif url.season is 'spring'>selected</cfif>>Spring</option>
		<option value="http://www.csb-usa.com/SWT/participants.cfm?section=job-list.cfm?season=summer" <cfif url.season is 'summer'>selected</cfif>>Summer</option>
        <option value="http://www.csb-usa.com/SWT/participants.cfm?section=job-list.cfm?season=winter" <cfif url.season is 'winter'>selected</cfif>>Winter</option>
		</select>
	</form>
    </td>
    <td align="right" class="black"> &nbsp;<a href="http://www.csb-usa.com/SWT/participants.cfm?section=logout.cfm">Logout</a></td>
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
	
	<tr bgcolor="##999999">
   	  <Td class="white"><u>Host Site</Td><Td class="white"><u>Spots Available</td>
    </tr>
<cfloop query="available_posistions">
	<Tr <cfif available_posistions.currentrow mod 2>bgcolor="cccccc"</cfif>>
    	<Td class="JLtext"><cfif file is not ''>
        <a href="http://www.student-management.com/nsmg/uploadedfiles/extra_jobs/#file#">
		</cfif>
		#title#</Td><Td class="JLtext">#spots#</td>
    </Tr>	
</cfloop>
</table>

</cfoutput>