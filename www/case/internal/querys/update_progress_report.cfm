<cfset rightnow = #now()#>
<cfif form.host_date_inperson is ''><cfset hipdate1 = 'null'><cfelse><cfset hipdate1 = #CreateODBCdate(form.host_date_inperson)#> </cfif>
<cfif form.host_date_inperson2 is ''><cfset hipdate2 = 'null'><cfelse><cfset hipdate2 = #CreateODBCdate(form.host_date_inperson2)#> </cfif>
<cfif form.host_date_inperson3 is ''><cfset hipdate3 = 'null'><cfelse><cfset hipdate3 = #CreateODBCdate(form.host_date_inperson3)#> </cfif>
<cfif form.stu_date_inperson is ''><cfset sipdate1 = 'null'><cfelse><cfset sipdate1 = #CreateODBCdate(form.stu_date_inperson)#> </cfif>
<cfif form.stu_date_inperson2 is ''><cfset sipdate2 = 'null'><cfelse><cfset sipdate2 = #CreateODBCdate(form.stu_date_inperson2)#> </cfif>
<cfif form.stu_date_inperson3 is ''><cfset sipdate3 = 'null'><cfelse><cfset sipdate3 = #CreateODBCdate(form.stu_date_inperson3)#> </cfif>
<cfif form.host_date_phone is ''><cfset hbtdate1 = 'null'><cfelse><cfset hbtdate1 = #CreateODBCdate(form.host_date_phone)#> </cfif>
<cfif form.host_date_phone2 is ''><cfset hbtdate2 = 'null'><cfelse><cfset hbtdate2 = #CreateODBCdate(form.host_date_phone2)#> </cfif>
<cfif form.host_date_phone3 is ''><cfset hbtdate3 = 'null'><cfelse><cfset hbtdate3 = #CreateODBCdate(form.host_date_phone3)#> </cfif>
<cfif form.stu_date_phone is ''><cfset sbtdate1 = 'null'><cfelse><cfset sbtdate1 = #CreateODBCdate(form.stu_date_phone)#> </cfif>
<cfif form.stu_date_phone2 is ''><cfset sbtdate2 = 'null'><cfelse><cfset sbtdate2 = #CreateODBCdate(form.stu_date_phone2)#> </cfif>
<cfif form.stu_date_phone3 is ''><cfset sbtdate3 = 'null'><cfelse><cfset sbtdate3 = #CreateODBCdate(form.stu_date_phone3)#> </cfif>

<cfoutput>

<cfquery name="get_answerids" datasource="caseusa">
	SELECT id
	FROM smg_prquestion_details
	WHERE report_number = <cfqueryparam value="#url.number#" cfsqltype="cf_sql_integer">
</cfquery>

<cfloop query="get_answerids">
	<cfset response = #Evaluate("FORM." & id & "_answer")#>
	<cfset response2 = #PreserveSingleQuotes(response)#>
	
	<Cfquery name="update_question_Details" datasource="caseusa">
		Update smg_prquestion_details
			set  response = '#response2#', 
			yn = '#Evaluate("FORM." & id & "_yn")#'
		 where id = '#id#'
	 </Cfquery>
</cfloop>

<cfquery name="insert_contact_dates" datasource="caseusa">
	update smg_prdates 
	set hipdate1= #hipdate1#, 
	 hipdate2=#hipdate2#, 
	 hipdate3=#hipdate3#, 
	 sipdate1=#sipdate1#,
	 sipdate2=#sipdate2#, 
	 sipdate3=#sipdate3#,
	 hbtdate1=#hbtdate1#, 
	 hbtdate2=#hbtdate2#, 
	 hbtdate3=#hbtdate3#, 
	 sbtdate1=#sbtdate1#, 
	 sbtdate2=#sbtdate2#, 
	 sbtdate3= #sbtdate3#
	where report_number = <cfqueryparam value="#url.number#" cfsqltype="cf_sql_integer">
</cfquery>
	
<cfif isDefined('form.unreject')>
	<cfquery name="remove_rejection" datasource="caseusa">
	update smg_document_tracking
		set date_rejected = null,
		note = ''
	where report_number = <cfqueryparam value="#url.number#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>

<cfif isDefined('form.save')>
	<cfquery name="remove_rejection" datasource="caseusa">
	update smg_document_tracking
		set saveonly = 1
	where report_number = <cfqueryparam value="#url.number#" cfsqltype="cf_sql_integer">
	</cfquery>
<cfelse>
	<cfquery name="remove_rejection" datasource="caseusa">
	update smg_document_tracking
		set saveonly = 0
	where report_number = <cfqueryparam value="#url.number#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>
	
<cfif IsDefined('url.regionid')>
	<cflocation url = "../index.cfm?curdoc=forms/view_progress_report&number=#url.number#&regionid=#url.regionid#" addtoken="no">
<cfelse>
	<cflocation url = "../index.cfm?curdoc=forms/view_progress_report&number=#url.number#" addtoken="no">
</cfif>
	
</cfoutput>