<script>
function areYouSure() { 
   if(confirm("You are about to delete this record. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
</script>

<cfinclude template="../querys/family_info.cfm">

<cfquery name="children" datasource="caseusa">
select *
from smg_host_children
where hostid = #client.hostid#
order by childid
</cfquery>

<cfform action="querys/insert_host_kids.cfm" method="post">
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
		<td background="pics/header_background.gif"><h2>Other family members at home</h2></td>
		<td align="right" background="pics/header_background.gif"><span class="edit_link">[ <cfoutput><a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a></cfoutput> ]</span></td>	
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfif #children.recordcount# is 0>
	<cfoutput>
	<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td width="80%">
			<table border=0 cellpadding=3 cellspacing=0 align="left" width="100%">
			<cfloop from="1" to="5" index="i">
				<tr bgcolor="#iif(i MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
					<td class="label">Name: </td>
					<td class="form_text"> <cfinput type="text" name="name#i#" size="20"> <cfinput type="radio" name="sex#i#" value="male">Male <cfinput type="radio" name="sex#i#" value="female">Female</td></tr>
				<tr bgcolor="#iif(i MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
					<td class="label">Date of Birth: </td>
					<td class="form_text"> <cfinput type="text" name="dob#i#" size="20"> mm/dd/yyyy</td></tr>
				<tr bgcolor="#iif(i MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
					<td class="label">Relation: </td>
					<td class="form_text"> <cfinput type="text" name="membertype#i#" size="20"></td></tr>
				<tr bgcolor="#iif(i MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
					<td class="label">Living at Home: </td>
					<td class="form_text"><cfinput type="radio" name="athome#i#" value="yes">Yes <cfinput type="radio" name="athome#i#" value="no">No </td></tr>	
				<tr><td>&nbsp;</td></tr>
			</cfloop>
			</table>
		</td>
		<td width="20%" align="right" valign="top">
			<table border=0 cellpadding=3 cellspacing=0 align="left">
				<tr><td align="right"><cfinclude template="../family_pis_menu.cfm"></td></tr>
			</table> 		
		</td>		
		</tr>
	</table>
	</cfoutput>

<cfelse> <!--- with kids --->

	<input type="hidden" name="update" value="update">
	<cfoutput><input type="hidden" name="count" value='#children.recordcount#'></cfoutput>
	<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td width="80%">
			<table border=0 cellpadding=3 cellspacing=0 align="left" width="100%">
			<cfoutput query="children">	
				<tr bgcolor="#iif(children.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
					<td class="label"><input type="hidden" name="childid#children.currentrow#" value="#childid#">Name: </td>
					<td class="form_text"> <cfinput type="text" name="name#children.currentrow#" size="20" value="#name#"> <Cfif sex is 'male'>
											<cfinput type="radio" name="sex#children.currentrow#" value="male" checked>Male <cfinput type="radio" name="sex#children.currentrow#" value="female">Female
										<cfelseif sex is 'female'><cfinput type="radio" name="sex#children.currentrow#" value="male">Male <cfinput type="radio" name="sex#children.currentrow#" value="female" checked>Female
										<cfelse><cfinput type="radio" name="sex#children.currentrow#" value="male">Male <cfinput type="radio" name="sex#children.currentrow#" value="female">Female</cfif></span></td></tr>
				<tr bgcolor="#iif(children.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
					<td class="label">Date of Birth: </td><td class="form_text"> <cfinput type="text" name="dob#children.currentrow#" size="20" value="#DateFormat(birthdate,'mm-dd-yyyy')#"> mm-dd-yyyy</span></td></tr>
				<tr bgcolor="#iif(children.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
					<td class="label">Relation: </td><td class="form_text"><cfinput type="text" name="membertype#children.currentrow#" size="20" value="#membertype#"></td></tr>
				<tr bgcolor="#iif(children.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
					<td class="label">Living at Home: </td><td class="form_text"><cfif liveathome is 'yes'><cfinput type="radio" name="athome#children.currentrow#" value="yes" checked>Yes <cfinput type="radio" name="athome#children.currentrow#" value="no">No
																				 <cfelseif liveathome is 'no'><cfinput type="radio" name="athome#children.currentrow#" value="yes">Yes <cfinput type="radio" name="athome#children.currentrow#" value="no" checked>No
																				 <cfelse><cfinput type="radio" name="athome#children.currentrow#" value="yes">Yes <cfinput type="radio" name="athome#children.currentrow#" value="no">No</cfif></td></tr>
				<tr bgcolor="#iif(children.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
					<td class="label">Delete? </td>
					<td><a href="?curdoc=querys/delete_host_children&childid=#childid#" onClick="return areYouSure(this);"><img src="pics/deletex.gif" border="0"></img></a></td></tr>
				<tr><td>&nbsp;</td></tr>
			</cfoutput>
			</table>		
		</td>
		<td width="20%" align="right" valign="top">
			<table border=0 cellpadding=3 cellspacing=0 align="right">
				<tr><td align="right"><cfinclude template="../family_pis_menu.cfm"></td></tr>
			</table> 		
		</td>		
		</tr>
	</table>			
</cfif>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="left">
			<cfif #children.recordcount# is not 0>
				<a href="?curdoc=forms/host_fam_pis_2_new"><img src="pics/add-siblings.gif" border="0" align="middle"></img></a>
			</cfif>	</td>
		<td align="left"><input name="Submit" type="image" src="pics/next.gif" align="left" border=0></td>
	</tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfform>