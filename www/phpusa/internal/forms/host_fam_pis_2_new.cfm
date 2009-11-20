<cfinclude template="../querys/family_info.cfm">

<cfoutput>

<h2>&nbsp;&nbsp;&nbsp;&nbsp;O t h e r &nbsp;&nbsp; M e m b e r s &nbsp;&nbsp; a t &nbsp;&nbsp; h o m e <font size=-2>[ <a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a> ] </font></h2>

<cfform action="querys/insert_host_kids.cfm" method="post">
<cfinput type="hidden" name="hostid" value="#family_info.hostid#">
<table width="92%"  border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C7CFDC" bgcolor="##FFFFFF">
	<tr>
		<td class="box">
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
		</td>
	</tr>
</table>

<table width=90% border=0 align="center" cellpadding=4 cellspacing=0 class="section">
	<tr><td align="center" valign="top"><input name="Submit" type="image" src="pics/next.gif" border=0 alt="next"></td></tr>
</table>
</cfform>

</cfoutput>