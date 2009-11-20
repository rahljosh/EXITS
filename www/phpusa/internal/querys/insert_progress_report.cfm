

<cfset rightnow = #now()#>
<!----
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
---->
<cftransaction action="begin" isolation="serializable">
<Cfquery name="get_question_number" datasource="MySQL">
select max(report_number) as last_number from 
smg_prquestion_details
</Cfquery>

<Cfset report_number = #get_question_number.last_number# + 1>
<cfset uniqueid = Createuuid()>

<cfloop From = "1" To = "#FORM.number_questions#" Index = "x">
<cfset response = #Evaluate("FORM." & x & "_answer")#>
<cfset repsonse2 = #PreserveSingleQuotes(response)#>
			 <Cfquery name="add_question_Details" datasource="mySQL">
		 insert into smg_prquestion_details (response, stuid, report_number,  userid, companyid, date, question_number, uniqueid, month_of_report)
		 	values( '#repsonse2#', #url.stuid#, #report_number#, #client.userid#, #client.companyid#, #rightnow#, #Evaluate("FORM." & x & "_question_number")#,  '#uniqueid#', #form.month_of_report#)
		 </Cfquery>

</cfloop>

<cfquery name="insert_tracking_info" datasource="MySQL">
	insert into smg_document_tracking (report_number, date_submitted, month_of_report)
					values (#report_number#, #rightnow#, #form.month_of_report#)
</cfquery>

<cfif isDefined('form.save')>
	<cfquery name="approve_rd" datasource="MySQL">
		update smg_document_tracking
			set saveonly = 1
		where report_number = #report_number#
		</cfquery>
<cfelse>
		<cfquery name="get_school" datasource="mysql">
			select schoolid 
			from php_students_in_program
			where studentid = #url.stuid#
		</cfquery>
		<cfquery name="check_supervisor" datasource="mysql">
		select supervising_rep
		from php_schools 
		where schoolid = #get_School.schoolid#
		</cfquery>
		
		
	<cfif check_supervisor.supervising_rep is 0>
		<cfquery name="approve_rd" datasource="MySQL">
		update smg_document_tracking
			set date_rd_Approved = #rightnow#,
			saveonly = 0
		where report_number = #report_number#
		</cfquery>

	</cfif>
	
</cfif>

<!----Insert Contact Dates---->
<!----
	<cfquery name="insert_contact_dates" datasource="MySQL">
		insert into smg_prdates (hipdate1, hipdate2, hipdate3, sipdate1, sipdate2, sipdate3, hbtdate1, hbtdate2, hbtdate3, sbtdate1, sbtdate2, sbtdate3, report_number)
					values (#hipdate1#, #hipdate2#, #hipdate3#, #sipdate1#, #sipdate2#, #sipdate3#, #hbtdate1#, #hbtdate2#, #hbtdate3#, #sbtdate1#, #sbtdate2#, #sbtdate3#, #report_number#) 
	</cfquery>
---->

<!----In Person Contact Dates Host---->




</cftransaction>

<cflocation url="../index.cfm">

