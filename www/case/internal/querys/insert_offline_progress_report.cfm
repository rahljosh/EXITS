<link rel="stylesheet" href="../smg.css" type="text/css">

<cfif #form.month_report# eq 0>
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
				<td width=26 background="../pics/header_background.gif"><img src="../pics/helpdesk.gif"></td>
				<td background="../pics/header_background.gif"><h2>Error </h2></td>
				<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td></tr>
		</table>
		<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td align="center"><br><div align="justify"><img src="../pics/error_exclamation.gif" align="left"><h3>
		<cfoutput>
							<p>You didn't specify the month of this report.</p>
							<p>Please click the back button and select a month. </p></h3>
							<div align="center"><a href="javascript:history.go(-1)"><img src="../pics/back.gif" border=0 align="center"></a></div><br>
							If you feel you have receivd this in error, please contact <a href="mailto:support@case-usa.org">support@case-usa.org</a>. 
							
							</div>
							<br><br>
							<font size=-2>
							
							</font>
							</cfoutput></td></tr>
		<tr><td align="center"></td></tr>
		</table>
		<table width=100% cellpadding=0 cellspacing=0 border=0>
			<tr valign="bottom"><td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
				<td width=100% background="../pics/header_background_footer.gif"></td>
				<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
		</table>
		<cfabort>
</cfif>
<cfset url.stuid = #client.studentid#>
<cfquery name="region" datasource="caseusa">
select smg_students.regionassigned, smg_regions.regionid
 from smg_regions right join smg_students on  smg_regions.regionid = smg_students.regionassigned
 where studentid = #url.stuid#
</cfquery>
<Cfquery name="rd" datasource="caseusa">
select smg_users.firstname, smg_users.lastname, smg_users.userid
from smg_users
where usertype = 5 and regions like #region.regionid#
</Cfquery>
<cfset rightnow = #now()#>
<cfset monthcount = 0>
<cfif form.host_date_inperson is ''><cfset hipdate1 = 'null'><cfelse><cfset hipdate1 = #CreateODBCdate(form.host_date_inperson)#><cfset monthcount = #monthcount# +1> </cfif>
<cfif form.host_date_inperson2 is ''><cfset hipdate2 = 'null'><cfelse><cfset hipdate2 = #CreateODBCdate(form.host_date_inperson2)#><cfset monthcount = #monthcount# +1> </cfif>
<cfif form.host_date_inperson3 is ''><cfset hipdate3 = 'null'><cfelse><cfset hipdate3 = #CreateODBCdate(form.host_date_inperson3)#><cfset monthcount = #monthcount# +1> </cfif>
<cfif form.stu_date_inperson is ''><cfset sipdate1 = 'null'><cfelse><cfset sipdate1 = #CreateODBCdate(form.stu_date_inperson)#><cfset monthcount = #monthcount# +1> </cfif>
<cfif form.stu_date_inperson2 is ''><cfset sipdate2 = 'null'><cfelse><cfset sipdate2 = #CreateODBCdate(form.stu_date_inperson2)#><cfset monthcount = #monthcount# +1> </cfif>
<cfif form.stu_date_inperson3 is ''><cfset sipdate3 = 'null'><cfelse><cfset sipdate3 = #CreateODBCdate(form.stu_date_inperson3)#><cfset monthcount = #monthcount# +1> </cfif>
<cfif form.host_date_phone is ''><cfset hbtdate1 = 'null'><cfelse><cfset hbtdate1 = #CreateODBCdate(form.host_date_phone)#><cfset monthcount = #monthcount# +1> </cfif>
<cfif form.host_date_phone2 is ''><cfset hbtdate2 = 'null'><cfelse><cfset hbtdate2 = #CreateODBCdate(form.host_date_phone2)#><cfset monthcount = #monthcount# +1> </cfif>
<cfif form.host_date_phone3 is ''><cfset hbtdate3 = 'null'><cfelse><cfset hbtdate3 = #CreateODBCdate(form.host_date_phone3)#><cfset monthcount = #monthcount# +1> </cfif>
<cfif form.stu_date_phone is ''><cfset sbtdate1 = 'null'><cfelse><cfset sbtdate1 = #CreateODBCdate(form.stu_date_phone)#><cfset monthcount = #monthcount# +1> </cfif>
<cfif form.stu_date_phone2 is ''><cfset sbtdate2 = 'null'><cfelse><cfset sbtdate2 = #CreateODBCdate(form.stu_date_phone2)#><cfset monthcount = #monthcount# +1> </cfif>
<cfif form.stu_date_phone3 is ''><cfset sbtdate3 = 'null'><cfelse><cfset sbtdate3 = #CreateODBCdate(form.stu_date_phone3)#><cfset monthcount = #monthcount# +1> </cfif>

<cfif monthcount lt 2>
<br><br>
	<table align="center" width="90%" frame="box" >
					<tr>
						<td valign="top"><img src="../pics/error.gif"></td>
						<td valign="top"><font color="#CC3300">You have only specified <cfoutput>#monthcount#</cfoutput> date<cfif monthcount is 1><cfelse>s</cfif> of contact.  You must indicate at LEAST 2 dates of contact.<br><br>  Please click <input name="back" type="image" src="pics/back.gif"  alt="here" border=0 onClick="history.back()"> and add the other dates of contact.</td></tr>
				</table>
				
<cfabort>
</cfif>


<Cfquery name="get_question_number" datasource="caseusa">
select max(report_number) as last_number from 
smg_prquestion_details
</Cfquery>

<Cfset report_number = #get_question_number.last_number# + 1>
<cfset uniqueid = Createuuid()>

<!----Set Question Details to default to Submitted Offline, see paper report.---->
<cfquery name="questions" datasource="caseusa">
select * from smg_prquestions
where companyid =#client.companyid# 
and active = 1
</cfquery>

<cfloop query ="questions">
<cfset response = "Report was submitted offline, see hard copy for response.">
<cfset repsonse2 = #PreserveSingleQuotes(response)#>
			 <Cfquery name="add_question_Details" datasource="caseusa">
		 insert into smg_prquestion_details (response, stuid, report_number, userid, companyid, date, question_number, uniqueid, submit_type, month_of_report )
		 	values( '#repsonse2#', #url.stuid#, #report_number#, #client.userid#, #client.companyid#, #rightnow#, #id#, '#uniqueid#', 'offline', #form.month_report# )
		 </Cfquery>

</cfloop>

<cfquery name="insert_tracking_info" datasource="caseusa">
	insert into smg_document_tracking (report_number, date_submitted)
					values (#report_number#, #rightnow#)
</cfquery>
<cfif client.usertype lte 4>
	<cfquery name="approve_r1" datasource="caseusa">
	update smg_document_tracking
		set ny_accepted = #rightnow#,
			date_rd_Approved = #rightnow#,
			date_ra_Approved = #rightnow#	
	where report_number = #report_number#
	</cfquery>
</cfif>
<cfif client.usertype is 5>
	<cfquery name="approve_rd" datasource="caseusa">
	update smg_document_tracking
		set date_rd_Approved = #rightnow#
	where report_number = #report_number#
	</cfquery>
</cfif>
<cfif client.usertype is 6>
	<cfquery name="approve_r1" datasource="caseusa">
	update smg_document_tracking
		set date_ra_Approved = #rightnow#
	where report_number = #report_number#
	</cfquery>
</cfif>


<!----Insert Contact Dates---->
<cfquery name="insert_contact_dates" datasource="caseusa">
	insert into smg_prdates (hipdate1, hipdate2, hipdate3, sipdate1, sipdate2, sipdate3, hbtdate1, hbtdate2, hbtdate3, sbtdate1, sbtdate2, sbtdate3, report_number)
		values (#hipdate1#, #hipdate2#, #hipdate3#, #sipdate1#, #sipdate2#, #sipdate3#, #hbtdate1#, #hbtdate2#, #hbtdate3#, #sbtdate1#, #sbtdate2#, #sbtdate3#, #report_number#) 
</cfquery>

<!----In Person Contact Dates Host---->

<cflocation url="../forms/received_progress_reports.cfm?studentid=#url.stuid#">