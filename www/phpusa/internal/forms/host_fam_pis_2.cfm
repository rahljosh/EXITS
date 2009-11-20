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

<cfquery name="children" datasource="mysql">
	select *
	from smg_host_children
	where hostid = #client.hostid#
	order by childid
</cfquery>

<cfoutput>

<h2>&nbsp;&nbsp;&nbsp;&nbsp;O t h e r &nbsp;&nbsp; M e m b e r s &nbsp;&nbsp; a t &nbsp;&nbsp; h o m e <font size=-2>[ <a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a> ] </font></h2>

<cfform action="querys/insert_host_kids.cfm" method="post">
<cfinput type="hidden" name="hostid" value="#family_info.hostid#">
<table width="92%"  border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C7CFDC" bgcolor="##FFFFFF">
	<tr>
		<td class="box">
			<cfif children.recordcount EQ 0>
				<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
					<tr>
						<td width="80%">
							<table border=0 cellpadding=3 cellspacing=0 align="left" width="100%">
								<cfloop from="1" to="5" index="i">
									<tr bgcolor="#iif(i MOD 2 ,DE("ffffff") ,DE("C2D1EF") )#">
										<td class="label">Name: </td>
										<td class="form_text"> <cfinput type="text" name="name#i#" size="20"> <cfinput type="radio" name="sex#i#" value="male">Male <cfinput type="radio" name="sex#i#" value="female">Female</td>
									</tr>
									<tr bgcolor="#iif(i MOD 2 ,DE("ffffff") ,DE("C2D1EF") )#">
										<td class="label">Date of Birth: </td>
										<td class="form_text"> <cfinput type="text" name="dob#i#" size="20" maxlength="10" validate="date"> mm/dd/yyyy</td>
									</tr>
									<tr bgcolor="#iif(i MOD 2 ,DE("ffffff") ,DE("C2D1EF") )#">
										<td class="label">Relation: </td>
										<td class="form_text"> <cfinput type="text" name="membertype#i#" size="20"></td>
									</tr>
									<tr bgcolor="#iif(i MOD 2 ,DE("ffffff") ,DE("C2D1EF") )#">
										<td class="label">Living at Home: </td>
										<td class="form_text"><cfinput type="radio" name="athome#i#" value="yes">Yes <cfinput type="radio" name="athome#i#" value="no">No </td>
									</tr>	
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
			<!--- with kids --->
			<cfelse> 
				<cfinput type="hidden" name="update" value="update">
				<cfinput type="hidden" name="count" value='#children.recordcount#'>
				<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
					<tr>
						<td width="80%" valign="top">
							<table border=0 cellpadding=3 cellspacing=0 align="left" width="100%">
								<cfloop query="children">	
									<tr bgcolor="#iif(children.currentrow MOD 2 ,DE("ffffff") ,DE("C2D1EF") )#">
										<cfinput type="hidden" name="childid#children.currentrow#" value="#childid#">
										<td class="label">Name:</td>
										<td class="form_text">
											<cfinput type="text" name="name#children.currentrow#" size="20" value="#name#"> 
											<Cfif sex is 'male'>
												<cfinput type="radio" name="sex#children.currentrow#" value="male" checked>Male <cfinput type="radio" name="sex#children.currentrow#" value="female">Female
											<cfelseif sex is 'female'>
												<cfinput type="radio" name="sex#children.currentrow#" value="male">Male <cfinput type="radio" name="sex#children.currentrow#" value="female" checked>Female
											<cfelse>
												<cfinput type="radio" name="sex#children.currentrow#" value="male">Male <cfinput type="radio" name="sex#children.currentrow#" value="female">Female
											</cfif>
										</td>
									</tr>
									<tr bgcolor="#iif(children.currentrow MOD 2 ,DE("ffffff") ,DE("C2D1EF") )#">
										<td class="label">Date of Birth: </td>
										<td class="form_text"> <cfinput type="text" name="dob#children.currentrow#" size="20" value="#DateFormat(birthdate,'mm-dd-yyyy')#" maxlength="10" validate="date"> mm-dd-yyyy</td>
									</tr>
									<tr bgcolor="#iif(children.currentrow MOD 2 ,DE("ffffff") ,DE("C2D1EF") )#">
										<td class="label">Relation: </td>
										<td class="form_text"><cfinput type="text" name="membertype#children.currentrow#" size="20" value="#membertype#"></td>
									</tr>
									<tr bgcolor="#iif(children.currentrow MOD 2 ,DE("ffffff") ,DE("C2D1EF") )#">
										<td class="label">Living at Home: </td>
										<td class="form_text">
											<cfif liveathome is 'yes'>
												<cfinput type="radio" name="athome#children.currentrow#" value="yes" checked>Yes <cfinput type="radio" name="athome#children.currentrow#" value="no">No
											 <cfelseif liveathome is 'no'>
											 	<cfinput type="radio" name="athome#children.currentrow#" value="yes">Yes <cfinput type="radio" name="athome#children.currentrow#" value="no" checked>No
											 <cfelse>
											 	<cfinput type="radio" name="athome#children.currentrow#" value="yes">Yes <cfinput type="radio" name="athome#children.currentrow#" value="no">No
											</cfif>
										</td>
									</tr>
									<tr bgcolor="#iif(children.currentrow MOD 2 ,DE("ffffff") ,DE("C2D1EF") )#">
										<td class="label">Delete? </td>
										<td><a href="?curdoc=querys/delete_host_child&childid=#childid#&hostid=#family_info.hostid#" onClick="return areYouSure(this);"><img src="pics/deletex.gif" border="0"></img></a></td>
									</tr>
								</cfloop>
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
		</td>
	</tr>
</table>

<table width=50% border=0 align="center" cellpadding=4 cellspacing=0 class="section">
	<tr>
		<td align="center" valign="top"><input name="Submit" type="image" src="pics/next.gif" align="left" border=0 alt="next"></td>
		</cfform>
		<td align="center" valign="top">
		<cfif children.recordcount NEQ 0>
			<cfform action="?curdoc=forms/host_fam_pis_2_new" method="post">
				<cfinput type="hidden" name="hostid" value="#family_info.hostid#">
				<cfinput type="image" name="submit" src="pics/add-siblings.gif">
			</cfform>
		</cfif>	
		</td>
	</tr>
</table>
</cfoutput>