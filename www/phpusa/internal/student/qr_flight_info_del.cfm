<cfif NOT IsDefined('url.flightid') AND NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfquery name="delete_flightid" datasource="MySql">
	DELETE 
	FROM smg_flight_info
	WHERE flightid = <cfqueryparam value="#url.flightid#" cfsqltype="cf_sql_integer">
	LIMIT 1
</cfquery>

<cfoutput>

<script language="JavaScript">
<!-- 
alert("You have deleted this flight leg. Thank You.");
	location.replace("flight_info.cfm?unqid=#url.unqid#");
-->
</script>

</cfoutput>