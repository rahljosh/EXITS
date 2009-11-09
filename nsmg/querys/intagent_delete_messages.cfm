


	<cfloop list=#url.id# index=i>

	<cfquery name="messages" datasource="MySQL">
	delete
	from smg_intagent_messages
	where messageid = #i#
	</cfquery>
		

	</cfloop>
	
<Cflocation url="../index.cfm?curdoc=intrep/update_alerts">