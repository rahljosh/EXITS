<cfif form.msgexist gt 0>
	<cfquery name="insert_message" datasource="caseusa">
	update smg_student_app_intagent_message 
		set message = '#form.message#'
		where agentid = #client.parentcompany#
	</cfquery>
<cfelse>
	<cfquery name="insert_message" datasource="caseusa">
	insert into smg_student_app_intagent_message (message, agentid)
		values ('#form.message#', #client.parentcompany#)
	</cfquery>
</cfif>

<cflocation url="../index.cfm?curdoc=intrep/email_welcome&us">