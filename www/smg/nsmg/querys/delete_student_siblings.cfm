<!--- revised by Marcus Melo on 08/22/2005 --->

<cfif not IsDefined('url.childid')>
	<cfinclude template="../forms/error_message.cfm">
</cfif>

<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="delete_children" datasource="MySQL">
	DELETE 
	FROM smg_student_siblings
	WHERE childid = <cfqueryparam value="#url.childid#" cfsqltype="cf_sql_integer">
	LIMIT 1
</cfquery>
</cftransaction>
<cflocation url="?curdoc=forms/student_app_3" addtoken="no">