


	<cfloop list=#url.id# index=i>

	<cfquery name="messages" datasource="caseusa">
	delete
	from smg_news_messages
	where messageid = #i#
	</cfquery>
		

	</cfloop>
	
<Cflocation url="../index.cfm?curdoc=forms/update_alerts">