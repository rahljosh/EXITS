<cfinclude template="../querys/family_info.cfm">

<cfform action="querys/insert_host_kids.cfm" method="post">
<cfoutput>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
		<td background="pics/header_background.gif"><h2>Other family members at home</h2></td>
		<td align="right" background="pics/header_background.gif"><span class="edit_link">[ <a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a> ]</span></td>		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

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
		<table border=0 cellpadding=4 cellspacing=0 align="right">
			<tr><td align="right"><cfinclude template="../family_pis_menu.cfm"></td></tr>
		</table> 		
	</td>		
	</tr>
</table>

<table border=0 cellpadding=3 cellspacing=0 width=100% class="section">
	<tr><td align="center"><input name="Submit" type="image" src="pics/next.gif" align="absmiddle" border=0></td>
	</tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfoutput>
</cfform>