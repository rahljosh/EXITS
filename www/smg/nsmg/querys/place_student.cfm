
<cfquery name="double_check_placement" datasource="MySQL">
	select hostid, dateplaced
	from smg_students
	where studentid = #client.studentid#
</cfquery>
<cfif #double_check_placement.hostid# is not 0>
Student was placed on #double_check_placement.dateplaced#.
<cfelse>
<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="school_info" datasource="MySQL">
select schoolid 
from smg_hosts 
where smg_hosts.hostid = #form.available_families#
</cfquery>
<Cfquery name="place_Student" datasource="MySQL">
update smg_students
	set hostid = #form.available_families#,
		dateplaced = #now()#,
		schoolid = #school_info.schoolid#

where studentid= #client.studentid#
</cfquery>
</cftransaction>
</cfif>
<cflocation url="../host_info.cfm?studentid=#client.studentid#&hostid=#form.available_families#&region=#url.region#&studentname=#url.studentname#&regionname=#url.regionname#&reload=parent" addtoken="no">