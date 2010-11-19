<!--- revised by Marcus Melo on 06/30/2005 --->
<cfoutput>
<cfif not IsDefined('url.petid')>
	<table border="0" align="left" width="85%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="0">
	<tr bgcolor="D5DCE5"><td align="center"><a href="#CLIENT.exits_url#"><img src="pics/logos/5.gif" border="0"></a></td>	
		<td><b>STUDENT MANAGEMENT GROUP</b><br>#CLIENT.exits_url#</td></tr>
	<tr bgcolor="D5DCE5"><td colspan="2">An error has occured and it was not possible to complete the process requested.<br>
		Please go back and try again.</td></tr>
	<tr bgcolor="D5DCE5"><td align="center" colspan="2"><font size=-1><Br>&nbsp;&nbsp;
					<input type="image" value="close window" src="pics/back.gif" onClick="javascript:history.go(-1)"></td></tr>
	</table>
<cfelse>
	<cfquery name="delete_school" datasource="MySql">
	DELETE 
	FROM smg_host_animals
	WHERE animalid = <cfqueryparam value="#url.petid#" cfsqltype="cf_sql_integer">
	LIMIT 1
	</cfquery>
	<cflocation url="?curdoc=forms/host_fam_pis_3" addtoken="no">
</cfif>
</cfoutput>