<cfquery name="summerQuestion" datasource="#application.dsn#">
    select *
    from x_pr_questions
    where fk_prquestion = 52 
    or fk_prquestion = 218
    order by fk_progress_report
</cfquery>

<cfquery name="getID" dbtype="query">
select distinct fk_progress_report
        from summerQuestion
</cfquery>
<cfloop query="getID">
	
    <Cfquery name="q218" dbtype="query">
    select x_pr_question_response
    from summerQuestion
    where fk_progress_report = #getID.fk_progress_report#
    AND fk_prquestion = 218
    </Cfquery>
    
    <Cfquery name="q52" dbtype="query">
    select x_pr_question_response, x_pr_question_id
    from summerQuestion
    where fk_progress_report = #getID.fk_progress_report#
    AND fk_prquestion = 52
    </Cfquery>
  
    <cfoutput>
    <strong>Report #getID.fk_progress_report#<br></strong>
    
    <cfif q218.recordcount gt 0><Cfset nq218 = #q218.x_pr_question_response#><cfelse><Cfset nq218 = ''> </cfif>
    <cfif q52.recordcount gt 0><Cfset nq52 = #q52.x_pr_question_response#><cfelse><Cfset nq52 = ''> </cfif>
    Q218: #nq218#<br>
    Q52: #nq52#<br>
    <cfset combinedAnswer = #nq52# & ' ' & #nq218# >
   Combined: #q52.x_pr_question_id#: #combinedAnswer#<br><br><br>
    </cfoutput>
    <cfquery name="updateQuestion" datasource="#application.dsn#">
    update x_pr_questions
    set x_pr_question_response = '#combinedAnswer#'
    where x_pr_question_id = #q52.x_pr_question_id#
    </cfquery>
    
</cfloop>
