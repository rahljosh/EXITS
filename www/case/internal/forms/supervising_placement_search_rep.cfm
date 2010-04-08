<cfoutput>

<cfif IsDefined('url.order')>
	<cfset form.lastname = #url.lastname#>
	<cfset form.userid = #url.userid#>
<cfelse>
	<!--- none information was entered --->
	<cfif form.lastname is '' AND form.userid is ''>
		<cflocation url="?curdoc=forms/supervising_placement_payments&search=0" addtoken="no">
	<!--- both informations were entered --->
	<cfelseif form.lastname is not '' AND form.userid is not ''>
		<cflocation url="?curdoc=forms/supervising_placement_payments&search=2&lname=#form.lastname#&uid=#form.userid#" addtoken="no">
	</cfif>
</cfif>

<!--- set forms to '0' if they were left blank --->
<cfif form.lastname is ''><cfset form.lastname='0'></cfif>
<cfif form.userid is ''><cfset form.userid='0'></cfif>
<!--- <cfif form.lastname is not ''>&lastname=#form.lastname#</cfif><cfif form.userid is not ''>&userid=#form.userid#</cfif> --->

<cfquery name="search_rep" datasource="caseusa">
	SELECT DISTINCT u.firstname, u.lastname, u.userid
	FROM smg_users u
	INNER JOIN user_access_rights uar ON uar.userid = u.userid
	WHERE uar.usertype between '5' AND '7' AND u.active = '1' AND uar.companyid = '#client.companyid#'
	<cfif form.lastname is not '' and form.lastname is not '0'>AND u.lastname LIKE '%#form.lastname#%'</cfif>
	<cfif form.userid is not '' and form.userid is not '0'>AND u.userid = '#form.userid#'</cfif>
	ORDER BY <cfif IsDefined('url.order')>#url.order#
			 <cfelse>u.lastname, u.firstname</cfif>
</cfquery>

<HEAD>
<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
function countChoices(obj) {
max = 1; // max. number allowed at a time

<cfloop from="1" to="#search_rep.recordcount#" index='i'>
placeing#i# = obj.form.placeing#i#.checked; </cfloop>

count = <cfloop from="1" to="#search_rep.recordcount#" index='i'> (placeing#i# ? 1 : 0) <cfif search_rep.recordcount is #i#>; <cfelse> + </cfif> </cfloop>
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

<div class="application_section_header">Supervising & Placement Payments</div>

<Br>Specify ONLY ONE Representative that you want to work with from the list below:<br><br>
<form method="post" action="?curdoc=forms/supervising_placement_payment_details" name="myform">
<input type="hidden" name="student" value="0"><input type="hidden" name="supervising" value="0">
<table width=90% cellpadding="4" cellspacing="0">
	<tr>
		<td colspan="4" bgcolor="010066"><font color="white"><strong>Placing and Supervising Representatives</strong></font></td>
	    <td>&nbsp;</td>
	</tr>
	<tr bgcolor="CCCCCC">
		<td>&nbsp;</td>
		<Td><a href="?curdoc=forms/supervising_placement_search_rep&order=userid&lastname=#form.lastname#&userid=#form.userid#">ID</a></Td>
		<td><a href="?curdoc=forms/supervising_placement_search_rep&order=lastname&lastname=#form.lastname#&userid=#form.userid#">Last Name</a>, 
			<a href="?curdoc=forms/supervising_placement_search_rep&order=firstname&lastname=#form.lastname#&userid=#form.userid#">First Name</a></td>
		<td>&nbsp;</td>
	</tr>
	<cfif search_rep.recordcount is '0'>
	<tr>
		<td colspan="3">Sorry, none representatives have matched your criteria. <br>Please change your criteria and try again.</td>
	</tr>
	<Tr>
		<td align="center" colspan="3"><div class="button"><img border="0" src="pics/back.gif" onClick="javascript:history.back()"></td>
	</Tr>
	<cfelse>
	<cfloop query="search_rep">	
	<tr>
		<td><input type="checkbox" value="#userid#" name="placeing" id="placeing#currentrow#" onClick="countChoices(this)"></td>
		<Td>#userid#</Td>
		<td>#lastname#, #firstname#</td>
		<td>&nbsp;</td>
	</tr>
	</cfloop>
	<Tr>
		<td align="center" colspan="3"><div class="button"> <input name="submit" type="image" src="pics/next.gif" align="right" border=0 alt="search"></td>
	</Tr>
	</cfif>
</table>
</form><br>
</cfoutput>