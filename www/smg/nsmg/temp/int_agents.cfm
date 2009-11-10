<cfquery name="active_int_agents" datasource="mysql">
select userid, usertype
from user_access_rights
where usertype = 8 or usertype = 11
</cfquery>

<cfloop query="active_int_agents">
    <cfquery name="insert_agents" datasource="mysql">
    insert into user_access_rights (userid, usertype, companyid)
    					values (#userid#, #usertype#, 10)
    </cfquery>
</cfloop>
done.