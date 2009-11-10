<cfquery name="double_check_placement" datasource="MySQL">
	select hostid, dateplaced, arearepid, placerepid, schoolid, studentid
	from smg_students
	where studentid = #client.studentid#
</cfquery>

<cfquery name="check_history" datasource="MySql">
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
	
	<Cfquery name="place_Student" datasource="MySQL">
		UPDATE smg_students
			SET hostid = #form.available_families#,
				dateplaced = #CreateODBCDateTime(now())#,
				date_pis_received = #CreateODBCDateTime(now())#,
				welcome_family = '#form.welcome_family#'
		WHERE studentid = '#client.studentid#'
		LIMIT 1
	</cfquery>
	
	<cfif double_check_placement.arearepid NEQ '0' and double_check_placement.placerepid NEQ '0' and double_check_placement.schoolid NEQ '0' and check_history.recordcount is '0'>		
		<cfquery name="create_original_placement" datasource="MySql">
			INSERT INTO smg_hosthistory	(hostid, studentid, schoolid, original_place, welcome_family, dateofchange, arearepid, placerepid, changedby, reason)
			VALUES('#form.available_families#', '#double_check_placement.studentid#', '#double_check_placement.schoolid#', 'yes', '#form.welcome_family#',
			 #CreateODBCDateTime(now())#, '#double_check_placement.arearepid#', '#double_check_placement.placerepid#', '#client.userid#', 'Original Placement')
		</cfquery>
	</cfif>
	<cfquery name="get_info" datasource="mysql">
	select intrep, firstname, familylastname
	from smg_students
	where studentid = #client.studentid#
	</cfquery>
	<cfif (get_info.intrep eq 9028 or get_info.intrep eq 9029 or get_info.intrep eq 9030 or get_info.intrep eq 9031 or get_info.intrep eq 9032 or get_info.intrep eq 9506 or get_info.intrep eq 9549 or get_info.intrep eq 9806 or get_info.intrep eq 10111 or get_info.intrep eq 10112 or get_info.intrep eq 10113 or get_info.intrep eq 10114 or get_info.intrep eq 10115 or get_info.intrep eq 9028 or get_info.intrep eq 10142 or  get_info.intrep eq 10324 or get_info.intrep eq 10477)>
		<cfmail to="maria.ma@ef.com" from="support@student-management.com" subject="Updated Placement">
		Maria-
		The follwing students placement information has been updated. 
		#client.studentid# #get_info.firstname# #get_info.lastname#
		
		Full family information is available at http://www.student-management.com/
		</cfmail>
	</cfif>
	<!--- </cftransaction> --->
</cfif>
<cflocation url="../forms/place_menu.cfm?studentid=#client.studentid#" addtoken="no">
<!--- <cflocation url="../forms/place_host.cfm?studentid=#client.studentid#" addtoken="no"> --->