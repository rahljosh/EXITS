<cfquery name="get_select_list" datasource="caseusa">
select smg_id
from smg_students
where smg_id > 0
</cfquery>

<cfoutput>
<cfloop query="get_select_list">
#smg_id# <cfif get_select_list.currentrow neq get_select_list.recordcount> and studentid = </cfif>
</cfloop>
</cfoutput>