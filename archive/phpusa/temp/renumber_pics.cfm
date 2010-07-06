<cfquery name="old_School_id" datasource="php">
select school_name, school_id
from school
</cfquery>

<cfloop query="old_school_id">
	<cfquery name="new_school_id" datasource="mysql">
	select schoolid
	from schools
	where name = '#school_name#'
	</cfquery>
<cfoutput>
old: #old_School_id.school_id#<br>
new: #new_school_id.schoolid#
<br><br>
</cfoutput>	

</cfloop>