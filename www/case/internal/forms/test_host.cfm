<!----
	<cfquery name="host_families" datasource="caseusa">
	select  case_hosts.familylastname, case_hosts.fatherlastname,case_hosts.fatherfirstname,case_hosts.motherlastname,
	case_hosts.motherfirstname,case_hosts.hostid,case_hosts.city,case_hosts.state
	from case_hosts
	WHERE  case_hosts.hostid in (
	select case_hosts.hostid,case_students.hostid
	from case_hosts, case_students
	where case_hosts.active = 1 and case_hosts.hostid = case_students.hostid
	)
	 
	</cfquery>

<cfquery name="host_families" datasource="caseusa">
		select case_students.hostid
		from case_students
		where case_students.hostid  <> 0
</cfquery>


	---->

	
		<cfquery name="host_families" datasource="caseusa">
	select case_hosts.familylastname, case_hosts.fatherlastname,case_hosts.fatherfirstname,case_hosts.motherlastname,
	case_hosts.motherfirstname,case_hosts.hostid,case_hosts.city,case_hosts.state
	from case_hosts
	where case_hosts.hostid in (
		select case_students.hostid
		from case_students
		where case_students.hostid  <> 0
		)
	
	</cfquery>

		<cfoutput query="host_families">
	#hostid#<br>
	</cfoutput>
	
 