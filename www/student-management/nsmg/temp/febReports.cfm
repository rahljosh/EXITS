<cfquery name="febReports" datasource="#application.dsn#">
select progress_reports.pr_sr_approved_Date, progress_reports.pr_id, progress_reports.fk_program, progress_reports.fk_student, smg_students.companyid
from progress_reports
left join smg_students on smg_students.studentid = progress_reports.fk_student
where pr_month_of_report = 2 and companyid != 10 and
(fk_program = 316 or fk_program = 314 or fk_program = 312 or fk_program = 311 or fk_program = 291 or fk_program = 309)
order by  companyid, pr_sr_approved_date, fk_program
</cfquery>

<Cfdump var="#febReports#">  <cfoutput>
<cfloop query="febReports">
	<!----
    <cfquery datasource="#application.dsn#">
    update progress_reports
    set pr_sr_approved_date = null, 
    pr_ssr_approved_date = null,
    pr_ra_approved_date = null,
    pr_rd_approved_date = null,
    pr_ny_approved_date =null
    where pr_id = #pr_id#
    </cfquery>
#febReports.currentrow#<Br>
	
	<cfif companyid eq 1>	
  	<Cfquery datasource="#application.dsn#">
    insert into x_pr_questions 
     (fk_progress_report, fk_prquestion)
     values(#pr_id#, 222)
     </cfquery>
     <Cfquery datasource="#application.dsn#">
      insert into x_pr_questions 
     (fk_progress_report, fk_prquestion)
     values(#pr_id#, 223)
     </cfquery>
    </cfif>

 	<cfif companyid eq 2>	
  	<Cfquery datasource="#application.dsn#">
    insert into x_pr_questions 
     (fk_progress_report, fk_prquestion)
     values(#pr_id#, 226)
     </cfquery>
     <Cfquery datasource="#application.dsn#">
      insert into x_pr_questions 
     (fk_progress_report, fk_prquestion)
     values(#pr_id#, 227)
     </cfquery>
	</cfif>
   	<cfif companyid eq 3>	
  	<Cfquery datasource="#application.dsn#">
    insert into x_pr_questions 
     (fk_progress_report, fk_prquestion)
     values(#pr_id#, 220)
     </cfquery>
     <Cfquery datasource="#application.dsn#">
      insert into x_pr_questions 
     (fk_progress_report, fk_prquestion)
     values(#pr_id#, 221)
     </cfquery>
    </cfif>
   	<cfif companyid eq 4>	
  	<Cfquery datasource="#application.dsn#">
    insert into x_pr_questions 
     (fk_progress_report, fk_prquestion)
     values(#pr_id#, 224)
     </cfquery>
     <Cfquery datasource="#application.dsn#">
      insert into x_pr_questions 
     (fk_progress_report, fk_prquestion)
     values(#pr_id#, 225)
     </cfquery>
    </cfif>
       	<cfif companyid eq 12>	
  	<Cfquery datasource="#application.dsn#">
    insert into x_pr_questions 
     (fk_progress_report, fk_prquestion)
     values(#pr_id#, 228)
     </cfquery>
     <Cfquery datasource="#application.dsn#">
      insert into x_pr_questions 
     (fk_progress_report, fk_prquestion)
     values(#pr_id#, 229)
     </cfquery>
    </cfif>
	---->
</cfloop>   </cfoutput>