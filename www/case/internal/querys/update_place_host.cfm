<cfquery name="double_check_placement" datasource="caseusa">
	select hostid, dateplaced, arearepid, placerepid, schoolid, studentid
	from smg_students
	where studentid = #client.studentid#
</cfquery>

<cfquery name="check_history" datasource="caseusa">
	SELECT historyid, schoolid, studentid, hostid
	FROM smg_hosthistory
	WHERE studentid = '#client.studentid#'
</cfquery>

<cfif not IsDefined('form.welcome_family')>
	<cfinclude template="../forms/placement_status_header.cfm">
	<table width="480" align="center"><tr><td align="center"><h3>In order to continue you must answer the welcome family question.</h3></td></tr></table><br>
	<table width="480" align="center">
		<tr><td align="center"><input type="image" value="close window" src="../pics/back.gif" onClick="javascript:history.back()"></td></tr>
	</table>
	<cfabort>
</cfif>

<cfif double_check_placement.hostid NEQ 0> <!--- THERE'S A HOST FAMILY --->
	Student was placed on #double_check_placement.dateplaced#.
<cfelse>

	<!--- <cftransaction action="BEGIN" isolation="SERIALIZABLE"> --->
	
	<Cfquery name="place_Student" datasource="caseusa">
		UPDATE smg_students
			SET hostid = #form.available_families#,
				dateplaced = #CreateODBCDateTime(now())#,
				date_pis_received = #CreateODBCDateTime(now())#,
				welcome_family = '#form.welcome_family#'
		WHERE studentid = '#client.studentid#'
		LIMIT 1
	</cfquery>
	
	<cfif double_check_placement.arearepid NEQ '0' and double_check_placement.placerepid NEQ '0' and double_check_placement.schoolid NEQ '0' and check_history.recordcount is '0'>		
		<cfquery name="create_original_placement" datasource="caseusa">
			INSERT INTO smg_hosthistory	(hostid, studentid, schoolid, original_place, welcome_family, dateofchange, arearepid, placerepid, changedby, reason)
			VALUES('#form.available_families#', '#double_check_placement.studentid#', '#double_check_placement.schoolid#', 'yes', '#form.welcome_family#',
			 #CreateODBCDateTime(now())#, '#double_check_placement.arearepid#', '#double_check_placement.placerepid#', '#client.userid#', 'Original Placement')
		</cfquery>
	</cfif>
		
	<!--- </cftransaction> --->
</cfif>
<cflocation url="../forms/place_menu.cfm?studentid=#client.studentid#" addtoken="no">
<!--- <cflocation url="../forms/place_host.cfm?studentid=#client.studentid#" addtoken="no"> --->