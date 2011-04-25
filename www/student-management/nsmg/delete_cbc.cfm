<!----check to see what type of cbc to delete---->
<cfif url.type is "host">
	<cfif url.id is ''>
		      <cfquery name="delete_host_cbc" datasource="#application.dsn#">
            delete from smg_hosts_cbc
            where requestid = ''
            and hostid = #url.userid#
            limit 1
        </cfquery>
	<cfelse>
        <cfquery name="delete_host_cbc" datasource="#application.dsn#">
            delete from smg_hosts_cbc
            where requestid = '#url.id#'
            limit 1
        </cfquery>
    </cfif>
<cfelseif url.type is "user">
	<cfquery name="delete_user_cbc" datasource="#application.dsn#">
    	delete from smg_users_cbc
        where requestid = '#url.id#'
        limit 1
    </cfquery>
</cfif>
<cfoutput>
<cfif url.type is "host">
<cflocation url="index.cfm?curdoc=host_fam_info&hostid=#url.userid#">
<cfelse>
<cflocation url="index.cfm?curdoc=user_info&userid=#url.userid#">
</cfif>
</cfoutput>