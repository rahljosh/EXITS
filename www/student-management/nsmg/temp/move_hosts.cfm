<cfquery name="hosts" datasource="#APPLICATION.DSN#">
select hostid, regionid, companyid
from smg_hosts
where regionid = 26
</cfquery>
<cfoutput>
<cfloop query="hosts">
<cfquery name="update_hosts" datasource="#APPLICATION.DSN#">
	UPDATE smg_hosts
	SET companyid = 3,
		dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
        updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
	WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(hosts.hostID)#">
</cfquery>
updated #hostid# <br>
</cfloop>
</cfoutput>