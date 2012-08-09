<!--- revised by Marcus Melo on 06/24/2005 --->

<cfif not IsDefined('url.ID')>
	<br><br>
	<table border="0" align="center" width="97%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
	<tr bgcolor="D5DCE5"><td><a href="http://www.student-management.com"><img src="../pics/logos/5.gif" border="0" align="left"></a></td>	
		<td><b>EXTRA</b><br>
			http://www.student-management.com/extra</td>
		</tr>
	<tr bgcolor="D5DCE5"><th>An error has occured and it was not possible to complete the process requested.
		Please go back and try again.</th></tr>
	<tr bgcolor="D5DCE5"><td align="center"><font size=-1><Br>&nbsp;&nbsp;
					<input type="image" value="close window" src="../pics/back.gif" onClick="javascript:history.go(-1)"></td></tr>
	</table>
<cfelse>
	<!--- <cfdump var="#url.ID#"> --->
	<cfquery name="delete_ID" datasource="MySql">
	DELETE 
	FROM extra_flight_information
	WHERE ID = <cfqueryparam value="#url.ID#" cfsqltype="cf_sql_integer">
	LIMIT 1
	</cfquery>
	<cflocation url="../flight_info/flight_info.cfm?candidateid=#url.candidateid#" addtoken="no">
</cfif>