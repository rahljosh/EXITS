<cfquery name="inactive_programs" datasource="mysql">
select programid, companyid 
from smg_programs
where active = 0
and companyid = 9
</cfquery>
<cfoutput>
<cfdump var='#inactive_programs#'>

<cfloop query="inactive_programs">
<cfquery name="update_students" datasource="mysql">
update smg_students
	set active = 0
	where programid = #inactive_programs.programid#
</cfquery>

</cfloop>
</cfoutput>