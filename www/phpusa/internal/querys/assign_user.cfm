<Cfif url.action is 'a'>
	<cfquery name="assign_School" datasource="mysql">
		INSERT INTO php_school_contacts 
			(schoolid, userid)
		VALUES 
			('#url.sc#', '#url.userid#')
	</cfquery>
<cfelseif url.action is 'r'>
	<cfquery name="assign_School" datasource="mysql">
		DELETE FROM php_school_contacts
		WHERE userid = '#url.userid#' 
			AND schoolid = '#url.sc#'
	</cfquery>
</cfif>
<!----
<cflocation url="../index.cfm?curdoc=forms/assign_user&sc=#url.sc#">
---->
<cfoutput>
<cflocation url="../index.cfm?#cgi.QUERY_STRING#" addtoken="no">
</cfoutput>



