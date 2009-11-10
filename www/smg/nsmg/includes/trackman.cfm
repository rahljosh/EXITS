<!--- this is included by application.cfm --->

<!--- structure key is client.userid, value is Members array. --->
<cfparam name="application.Online" default="#StructNew()#">

<!--- delete users older than 30 minutes. --->
<cfloop collection="#application.Online#" item="ThisUser">
	<cfif DateDiff("n", application.Online[ThisUser][2], now()) GTE 30>
	    <cfset Temp = StructDelete(Application.Online, ThisUser)>
	</cfif>
</cfloop>

<!---Build "This" Members "Info" Array--->
<cfscript>
	Members = ArrayNew(1);
	Members[1] = client.name;
	Members[2] = now();
	Members[3] = CGI.query_string;
</cfscript>
 
<!---add Members "Info" to "Online" Structure--->
<cfset temp = StructInsert(Application.Online, client.userid, Members, TRUE)>
 
<cfquery datasource="#application.dsn#">
    INSERT INTO smg_user_tracking (userid, page_viewed, time_viewed, fullurl, ip, browser, type)
    VALUES (
    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.QUERY_STRING#">,
    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_REFERER#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_host#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_user_agent#">,
    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.usertype#">
    )
</cfquery>
