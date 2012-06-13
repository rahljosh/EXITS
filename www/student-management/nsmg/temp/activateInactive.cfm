<Cfquery name="notVerified" datasource="#application.dsn#">
select userid, firstname, lastname, datecreated, accountCreationVerified, dateAccountVerified
from smg_users 
where active = 1 
and accountCreationVerified < 1
and dateCreated < '2011-11-17'
</cfquery>
<cfoutput>
    <cfloop query="notVerified">
        <cfquery datasource="#application.dsn#">
        update smg_users
            set accountCreationVerified = 1,
                dateAccountVerified = '2011-11-17'
            where userid = #userid# 
         </cfquery>
    </cfloop>
</cfoutput>