<cfoutput>

<cfif IsDefined('url.order')>
	<cfset form.lastname = #url.lastname#>
	<cfset form.userid = #url.userid#>
<cfelse>
	<!--- none information was entered --->
	<cfif form.lastname is '' AND form.userid is ''>
		<cflocation url="?curdoc=forms/supervising_placement_payments&searchstu=0" addtoken="no">
	<!--- both informations were entered --->
	<cfelseif form.lastname is not '' AND form.userid is not ''>
		<cflocation url="?curdoc=forms/supervising_placement_payments&searchstu=2&stulname=#form.lastname#&stuid=#form.userid#" addtoken="no">
	</cfif>
</cfif>

<!--- set forms to '0' if they were left blank --->
<cfif form.lastname is ''><cfset form.lastname='0'></cfif>
<cfif form.userid is ''><cfset form.userid='0'></cfif>

<cfquery name="search_student" datasource="caseusa">
	SELECT studentid, firstname, familylastname
	FROM smg_students 
	WHERE companyid = '#client.companyid#'
	<cfif form.lastname is not '' and form.lastname is not '0'>AND familylastname LIKE '%#form.lastname#%'</cfif>
	<cfif form.userid is not '' and form.userid is not '0'>AND studentid = '#form.userid#'</cfif>
	ORDER BY <cfif IsDefined('url.order')>#url.order#
			 <cfelse>familylastname, firstname</cfif>
</cfquery>

<HEAD>
<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
function countChoices(obj) {
max = 1; // max. number allowed at a time

<cfloop from="1" to="#search_student.recordcount#" index='i'>
student#i# = obj.form.student#i#.checked; </cfloop>

count = <cfloop from="1" to="#search_student.recordcount#" index='i'> (student#i# ? 1 : 0) <cfif search_student.recordcount is #i#>; <cfelse> + </cfif> </cfloop>
// If you have more checkboxes on your form
// add more  (box_ ? 1 : 0)  's separated by '+'
if (count > max) {
alert("Oops!  You can only choose up to " + max + " choice! \nUncheck an option if you want to pick another.");
obj.checked = false;
   }
}
//  End -->
</script>

</HEAD>

<div class="application_section_header">Student Finder</div>

<Br>Specify ONLY ONE Student from the list below:<br><br>
<form method="post" action="?curdoc=forms/supervising_place_student" name="myform">
<input type="hidden" name="student" value="0"><input type="hidden" name="supervising" value="0">
<table width=90% cellpadding="4" cellspacing="0">
	<tr>
		<td colspan="4" bgcolor="010066"><font color="white"><strong>Student</strong></font></td>
	    <td>&nbsp;</td>
	</tr>
	<tr bgcolor="CCCCCC">
		<td>&nbsp;</td>
		<Td><a href="?curdoc=forms/supervising_search_student&order=studentid&lastname=#form.lastname#&userid=#form.userid#">ID</a></Td>
		<td><a href="?curdoc=forms/supervising_search_student&order=familylastname&lastname=#form.lastname#&userid=#form.userid#">Last Name</a>, 
			<a href="?curdoc=forms/supervising_search_student&order=firstname&lastname=#form.lastname#&userid=#form.userid#">First Name</a></td>
		<td>&nbsp;</td>
	</tr>
	<cfif search_student.recordcount is '0'>
	<tr>
		<td colspan="3">Sorry, none students have matched your criteria. <br>Please change your criteria and try again.</td>
	</tr>
	<Tr>
		<td align="center" colspan="3"><div class="button"><img border="0" src="pics/back.gif" onClick="javascript:history.back()"></td>
	</Tr>
	<cfelse>
	<cfloop query="search_student">	
	<tr>
		<td><input type="checkbox" value="#studentid#" name="studentid" id="student#currentrow#" onClick="countChoices(this)"></td>
		<Td><a href="" class="nav_bar" onClick="javascript: win=window.open('forms/supervising_student_history.cfm?studentid=#studentid#', 'Settings', 'height=300, width=650, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#studentid#</a></Td>
		<td><a href="" class="nav_bar" onClick="javascript: win=window.open('forms/supervising_student_history.cfm?studentid=#studentid#', 'Settings', 'height=300, width=650, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#firstname# #familylastname#</a></td>
		<td>&nbsp;</td>
	</tr>
	</cfloop>
	<Tr>
		<td align="center" colspan="3"><div class="button"><input name="submit" type="image" src="pics/next.gif" align="right" border=0 alt="Next"></td>
	</Tr>
	</cfif>
</table>
</form><br>
</cfoutput>