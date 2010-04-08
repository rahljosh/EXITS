
	<cfquery name="get_link" datasource="caseusa">
		select link
		from smg_links 
		where id = #cookie.smglink#
	</cfquery>
	<cfcookie name="smglink" value="" expires="now">
	<cfif get_link.recordcount eq 0>
	The link you followed is invalid.<br>
	You wil be redirected to the internal site shortly, if you are not redirected, click <a href="index.cfm?curdoc=initial_welcome">here.</a>
	<meta http-equiv="Refresh" content="1;url=index.cfm?curdoc=initial_welcome">
	<cfelse>
	<cfoutput>
		<meta http-equiv="Refresh" content="1;url=#get_link.link#">
	</cfoutput>
	</cfif>