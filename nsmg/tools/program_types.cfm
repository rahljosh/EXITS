<span class="application_section_header">Programs</span> <br>
<cfquery name="program_types" datasource="MySQL">
select * from smg_program_type
</cfquery>

<table align="center" cellpadding="2" cellspacing="0">
	<tr bgcolor="#00003C">
		<td></td><td bgcolor><font color="white">Program Type</td><td><font color="white">Default Cost</td><td><font color="white">Active</td>
	</tr>

<cfoutput query="program_types">
<tr bgcolor="#iif(program_types.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
	<td><input type="hidden" name="programtypeid" value=#programtypeid#>#programtypeid#</td><td>#programtype#</td><td><input type="text" name=cost value=#cost#></td><td><input name="active" type="checkbox" value="1" <cfif active is 1>checked</cfif>></td>
</tr>
</cfoutput>
<Tr>
	<Td colspan=3 align="right"><div class="button"><input name="Submit" type="image" src="pics/update.gif" border=0></div></Td>
</Tr>
</table>