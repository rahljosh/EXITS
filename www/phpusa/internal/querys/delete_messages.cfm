<cfquery name="get_files" datasource="#application.dsn#">
    SELECT additional_file
    FROM smg_news_messages
    WHERE messageid IN (#url.id#)
    AND additional_file IS NOT NULL
</cfquery>

<cfset currentDirectory = "/var/www/html/phpusa/internal/uploadedfiles/news/">

<cfloop query="get_files">
	<cfif fileExists("#currentDirectory##additional_file#")>
        <cffile action="delete" file="#currentDirectory##additional_file#">
    </cfif>
</cfloop>

<cfquery name="messages" datasource="#application.dsn#">
    DELETE FROM smg_news_messages
    WHERE messageid IN (#url.id#)
</cfquery>

<cflocation url="../index.cfm?curdoc=forms/update_alerts" addtoken="no">