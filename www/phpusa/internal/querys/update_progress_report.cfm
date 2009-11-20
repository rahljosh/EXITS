<cfset rightnow = #now()#>

<cfoutput>

<cfquery name="get_answerids" datasource="MySQL">
	SELECT id
	FROM smg_prquestion_details
	WHERE report_number = <cfqueryparam value="#url.number#" cfsqltype="cf_sql_integer">
</cfquery>

<cfloop query="get_answerids">
	<cfset response = #Evaluate("FORM." & id & "_answer")#>
	<cfset response2 = #PreserveSingleQuotes(response)#>
	
	<Cfquery name="update_question_Details" datasource="mySQL">
		Update smg_prquestion_details
			set  response = '#response2#'
			
		 where id = '#id#'
	 </Cfquery>
	 
</cfloop>


	
<cfif isDefined('form.unreject')>
	<cfquery name="remove_rejection" datasource="MySQL">
	update smg_document_tracking
		set date_rejected = null,
		note = ''
	where report_number = <cfqueryparam value="#url.number#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>

<cfif isDefined('form.save')>
	<cfquery name="remove_rejection" datasource="MySQL">
	update smg_document_tracking
		set saveonly = 1
	where report_number = <cfqueryparam value="#url.number#" cfsqltype="cf_sql_integer">
	</cfquery>
<cfelse>
	<cfquery name="remove_rejection" datasource="MySQL">
	update smg_document_tracking
		set saveonly = 0
	where report_number = <cfqueryparam value="#url.number#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>
	

	<cflocation url = "../index.cfm?curdoc=forms/view_progress_report&number=#url.number#" addtoken="no">

	
</cfoutput>