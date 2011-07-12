<cfquery name="updateDate" datasource="mysql">
select dateCreated, userid
from smg_users
</cfquery>
<cfloop query="updateDate">
	<Cfif dateCreated is not ''>
        <cfquery datasource="mysql">
        update smg_users 
            set trainingDeadlineDate = #dateCreated#
        where userid = #userid#
        </cfquery>
    </Cfif>
</cfloop>