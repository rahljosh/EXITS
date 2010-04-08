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

<cfif #double_check_placement.schoolid# is not 0> <!--- THERE'S A SCHOOL --->
	A school was assigned to this student on #double_check_placement.dateplaced#.
<cfelse>

	<cftransaction action="BEGIN" isolation="SERIALIZABLE">
		<Cfquery name="place_school" datasource="caseusa">
		UPDATE smg_students
			SET schoolid = #form.schoolid#
<!--- 			<cfif double_check_placement.arearepid is not '0' and double_check_placement.hostid is not '0' and double_check_placement.placerepid is not '0'>
				, host_fam_approved = #client.usertype#
			</cfif> --->
		WHERE studentid= #client.studentid#
		LIMIT 1
		</cfquery>

	<cfif double_check_placement.arearepid is not '0' and double_check_placement.hostid is not '0' and double_check_placement.placerepid is not '0' and check_history.recordcount is '0'>
		<cfquery name="create_original_placement" datasource="caseusa">
			INSERT INTO smg_hosthistory	(hostid, studentid, schoolid, orignal_place, dateofchange, arearepid, placerepid, changedby, reason)
			values('#double_check_placement.hostid#', '#double_check_placement.studentid#', '#form.schoolid#', 'yes',
			 #CreateODBCDateTime(now())#, '#double_check_placement.arearepid#', '#double_check_placement.placerepid#', '#client.userid#','Original Placement')
		</cfquery>
	</cfif>		
		
	</cftransaction>
	
</cfif>
<cflocation url="../forms/place_menu.cfm?studentid=#client.studentid#" addtoken="no">	
<!--- <cflocation url="../forms/place_school.cfm?studentid=#client.studentid#" addtoken="no"> --->