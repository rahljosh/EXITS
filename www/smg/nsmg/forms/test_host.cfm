<!----
	<cfquery name="host_families" datasource="MySQL">
	select  smg_hosts.familylastname, smg_hosts.fatherlastname,smg_hosts.fatherfirstname,smg_hosts.motherlastname,
	smg_hosts.motherfirstname,smg_hosts.hostid,smg_hosts.city,smg_hosts.state
	from smg_hosts
	WHERE  smg_hosts.hostid in (
	select smg_hosts.hostid,smg_students.hostid
	from smg_hosts, smg_students
	where smg_hosts.active = 1 and smg_hosts.hostid = smg_students.hostid
	)
	 
	</cfquery>

<cfquery name="host_families" datasource="mySQL">
		select smg_students.hostid
		from smg_students
		where smg_students.hostid  <> 0
</cfquery>


	---->

	
		<cfquery name="host_families" datasource="MySQL">
	select smg_hosts.familylastname, smg_hosts.fatherlastname,smg_hosts.fatherfirstname,smg_hosts.motherlastname,
	smg_hosts.motherfirstname,smg_hosts.hostid,smg_hosts.city,smg_hosts.state
	from smg_hosts
	where smg_hosts.hostid in (
		select smg_students.hostid
		from smg_students
		where smg_students.hostid  <> 0
		)
	
	</cfquery>

		<cfoutput query="host_families">
	#hostid#<br>
	</cfoutput>
	
 