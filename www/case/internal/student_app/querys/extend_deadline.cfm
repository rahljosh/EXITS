<cftry>

	<cfset expiration_date = '#DateFormat(DateAdd('d','#extdeadline#','#now()#'), 'yyyy-mm-dd')# #TimeFormat(DateAdd('d','#extdeadline#','#now()#'), 'HH:mm:ss')#'>
	
	<cfquery name="extend_deadline" datasource="caseusa">
		UPDATE smg_students
		SET application_expires = '#expiration_date#'
		WHERE studentid = '#client.studentid#'
	</cfquery>
	
	<cflocation url="../index.cfm?curdoc=initial_welcome">
	
<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>