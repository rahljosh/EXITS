<cftry>

	<cfif NOT IsDefined("URL.fileID")>
		<cfinclude template="error_message.cfm">
		<cfabort>
	</cfif>
    
    <cfquery name="qGetFile" datasource="MySql">
    	SELECT *
        FROM smg_internal_virtual_folder
        WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.fileID#">
    </cfquery>
    
    <cfoutput>
    	<cffile action="delete" file="#qGetFile.fullPath#">
  	</cfoutput>
    
    <cfquery datasource="MySql">
    	DELETE FROM smg_internal_virtual_folder
        WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.fileID#">
    </cfquery>
    
    <script type="text/javascript">
		window.location.href = document.referrer;
	</script>

    <cfcatch type="any">
        <cfinclude template="error_message.cfm">
    </cfcatch>

</cftry>
