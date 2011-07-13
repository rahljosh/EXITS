<cfquery name="double_check_placement" datasource="MySQL">
	select hostid, dateplaced, arearepid, placerepid,secondVisitRepID, schoolid, studentid
	from smg_students
	where studentid = #client.studentid#
</cfquery>

<cfquery name="check_history" datasource="MySql">
SELECT historyid, schoolid, studentid, hostid
FROM smg_hosthistory
WHERE studentid = '#client.studentid#'
</cfquery>

<cfif #double_check_placement.secondVisitRepID# is not 0> <!--- THERE'S A Second Vist  REP --->
	A second visit rep. was assigned to this student on #double_check_placement.dateplaced#.
<cfelse>

	<cftransaction action="BEGIN" isolation="SERIALIZABLE">
		<Cfquery name="place_placingrep" datasource="MySQL">
		UPDATE smg_students
			SET secondVisitRepID = #form.secondVisistRepID#

		WHERE studentid= #client.studentid#
		LIMIT 1
		</cfquery>
		
	<cfif double_check_placement.arearepid is not '0' and double_check_placement.hostid is not '0' and double_check_placement.schoolid is not '0' and check_history.recordcount is '0'>		
		<cfquery name="create_original_placement" datasource="MySql">
			INSERT INTO smg_hosthistory	(hostid, studentid, schoolid, original_place, dateofchange, arearepid, secondVisitRepID, changedby, reason)
			values('#double_check_placement.hostid#', '#double_check_placement.studentid#', '#double_check_placement.schoolid#', 
			 'yes', #CreateODBCDateTime(now())#, '#double_check_placement.arearepid#', '#form.placerepid#', '#client.userid#', 'Original Placement')
		</cfquery>
	</cfif>		
	</cftransaction>
	
</cfif>
<cflocation url="../forms/place_menu.cfm?studentid=#client.studentid#" addtoken="no">	
<!--- <cflocation url="../forms/place_placerep.cfm?studentid=#client.studentid#" addtoken="no"> --->