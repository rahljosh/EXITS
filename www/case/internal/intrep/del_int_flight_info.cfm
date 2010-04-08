<!--- revised by Marcus Melo on 06/24/2005 --->

<cfif not IsDefined('url.flightid')>
	<br><br>
	<table border="0" align="center" width="97%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
	<tr bgcolor="D5DCE5"><td><a href="http://www.student-management.com"><img src="../pics/logos/5.gif" border="0" align="left"></a></td>	
		<td><b>STUDENT MANAGEMENT GROUP</b><br>
			http://www.student-management.com</td>
		</tr>
	<tr bgcolor="D5DCE5"><th>An error has occured and it was not possible to complete the process requested.
		Please go back and try again.</th></tr>
	<tr bgcolor="D5DCE5"><td align="center"><font size=-1><Br>&nbsp;&nbsp;
					<input type="image" value="close window" src="../pics/back.gif" onClick="javascript:history.go(-1)"></td></tr>
	</table>
<cfelse>
	<!--- <cfdump var="#url.flightid#"> --->
	<cfquery name="delete_flightid" datasource="caseusa">
	DELETE 
	FROM smg_flight_info
	WHERE flightid = <cfqueryparam value="#url.flightid#" cfsqltype="cf_sql_integer">
	LIMIT 1
	</cfquery>
	<cflocation url="int_flight_info.cfm"> 
</cfif>