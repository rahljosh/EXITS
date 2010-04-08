<cfsetting requesttimeout="200">

<style type="text/css">
<!--
div.scroll {
	height: 225px;
	width: 100%;
	overflow: auto;
}
div.int_scroll {
	height: 100px;
	width: 100%;
	overflow: auto;
}
-->
</style>

<cfif not isDefined ('client.parentcompany')>
	<cfset client.parentcompany = 0>
</cfif>

<script>
<!-- Begin
var popUpWin=0;
function popUpWindow(URLStr, left, top, width, height)
{
  if(popUpWin)
  {
    if(!popUpWin.closed) popUpWin.close();
  }
  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}

function formHandler2(form){
var URL = document.formmonth.month.options[document.formmonth.month.selectedIndex].value;
window.location.href = URL;
}
// End -->
</script>

<Cfquery name="placed_students" datasource="caseusa">
	SELECT smg_students.placerepid
	FROM smg_students 
	INNER JOIN smg_programs ON smg_programs.programid = smg_students.programid
	INNER JOIN smg_incentive_trip ON smg_programs.tripid = smg_incentive_trip.tripid
	WHERE smg_students.placerepid = '#client.userid#' 
		AND smg_students.host_fam_approved < 5 
		AND smg_students.active = 1
		AND smg_incentive_trip.active = '1'
</Cfquery>

<cfquery name="incentive_trip" datasource="caseusa">
	SELECT tripid, seasonid, trip_place
	FROM smg_incentive_trip 
	WHERE active = '1'  
</cfquery>

<cfoutput>

<!--- OFFICE USERS - INTL. REPS AND BRANCHES --->
<cfif client.usertype LTE 4 OR client.usertype EQ 8 OR client.usertype EQ 11>
<table width=100%>
	<tr>
		<td>Your last visit was on #DateFormat(client.lastlogin, 'mmm d, yyyy')# at #TimeFormat(client.lastlogin, 'h:mm:ss tt')# MST</td>
		<td align="right">#DateFormat(now(), 'MMMM D, YYYY')#</td>
	</tr>
</table>

<table width=100%>
	<tr>
		<td width=40% valign="top">
			<!----News & Announcements---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
					<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
					<td background="pics/header_background.gif"><h2>News & Announcements </td><td background="pics/header_background.gif" width=16></td>
					<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
				
			<table width=100% cellpadding=4 cellspacing=0 border=0 class="section" >
				<tr>
					<td style="line-height:20px;" valign="top" width="100%"><br>
						<cfif #now()# gt '2008-03-18 01:01:01'>
						<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="https://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=6,0,29,0" height=70 width=60 align="left">
						<param name="movie" value="antena.swf">
						<param name="quality" value="high">
						<embed src="antena.swf" quality="high" pluginspage="https://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="50" height="80"></embed>
						</object>
						<cfelse>
						<img src="http://www.student-management.com/nsmg/pics/clover.gif" width="75" align="left" >
						</cfif>
						<cfif news_messages.recordcount is 0><br>
							There are currently no announcements or news items.
						</cfif>
						<cfloop query="news_messages">
						<Cfif companyid is 0 or companyid is #client.companyid#>
							<cfif #news_messages.details# is not ''><b>#message#</b><br>
								<div align="justify">#DateFormat(startdate, 'MMMM D, YYYY')# - #ParagraphFormat(details)#
								<cfif additional_file is not ''> 
								
									&nbsp;<img src="pics/info.gif" height="15" border="0" />&nbsp;<a href="uploadedfiles/news/#additional_file#" target="_blank">Additional Information (pdf)</font></a>
								</cfif></div>
							</cfif>
						</cfif>
						</cfloop>
						<cfif #now()# lt '2005-09-25 21:13:22'> &nbsp;<img src="pics/info.gif" height="15" border="0">&nbsp; <a href="uploadedfiles/site_revisons_<cfif client.usertype gte 5>7<cfelse>1</cfif>.pdf">Additional Information</a></font></cfif>
					<cfif client.usertype gte 8><br><br>Please see below for announcements from your organization. </cfif>
					</td>
					<td align="right" valign="top" rowspan=2></td>
				</tr>
			</table>
			<!----footer of table---->
			<cfinclude template="table_footer.cfm">
		</td>
		<td valign="top" width="1%">&nbsp;</td>
		<td valign="top" width="59%">
			<cfif client.userid EQ 10115>
				<cfinclude template="welcome_includes/ef_centraloffice.cfm">
			<cfelseif client.usertype EQ 8>
				<cfinclude template="welcome_includes/int_agent_apps.cfm"> 
			<cfelseif client.usertype EQ 11>
				<cfinclude template="welcome_includes/branch_apps.cfm">
			<cfelseif client.usertype LTE 4>
				<cfinclude template="welcome_includes/office_apps.cfm">
			<cfelse>
			</cfif>
		</td>
		<td align="right" valign="top" rowspan="2"></td>
	</tr>
</table>

<!---- FIELD --->
<cfelse>
<table width=100%>
	<tr>
		<td>Your last visit was on #DateFormat(client.lastlogin, 'mmm d, yyyy')# at #TimeFormat(client.lastlogin, 'h:mm:ss tt')# MST</td>
		<td align="right">
			<cfset tripcount = 7 - #placed_students.recordcount#>
			<cfif placed_students.recordcount lt 7>
				You're only #tripcount# placements away from a trip to <A href="javascript:popUpWindow('http://www.student-management.com/images/incentive-trip-2008.jpg',10, 10, 770, 590)">#incentive_trip.trip_place#!</A>
			<cfelse>
				You've earned a trip to <A href="javascript:popUpWindow('http://www.student-management.com/images/incentive-trip-2008.jpg',10, 10, 770, 590)">#incentive_trip.trip_place#!!!</A> 
			</cfif>
		</td>
	</tr>
</table>

<!----News & Announcements---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
		<td background="pics/header_background.gif"><h2>News & Announcements </td><td background="pics/header_background.gif" width=16></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width=100% cellpadding=4 cellspacing=0 border=0 class="section">
	<tr>
		<td style="line-height:20px;" valign="top" width="72%"><br>
			<cfif #now()# gt '2008-03-18 01:01:01'>
				<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="https://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=6,0,29,0" height=70 width=60 align="left">
				<param name="movie" value="antena.swf">
				<param name="quality" value="high">
				<embed src="antena.swf" quality="high" pluginspage="https://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="50" height="80"></embed>
				</object>
			<cfelse>
				<img src="http://www.student-management.com/nsmg/pics/clover.gif" width="75" align="left" >
			</cfif>
			<cfif news_messages.recordcount is 0><br>
				There are currently no announcements or news items.
			 </cfif>
			<cfloop query="news_messages">
			<Cfif companyid EQ 0 or companyid EQ #client.companyid#>
				<cfif #news_messages.details# is not ''><b>#message#</b><br>
					<div align="left">#DateFormat(startdate, 'MMMM D, YYYY')# - #ParagraphFormat(details)#
					<cfif additional_file is not ''> <br />
						&nbsp;<img src="pics/info.gif" height=15 border="0">&nbsp; <a href="uploadedfiles/news/#additional_file#">Additional Information (pdf)</font></a>
					</cfif>
					</div>
				</cfif>
			</cfif>
			</cfloop>
			<cfif #now()# lt '2005-09-25 21:13:22'> &nbsp;<img src="pics/info.gif" border="0">&nbsp; <a href="uploadedfiles/site_revisons_<cfif client.usertype gte 5>7<cfelse>1</cfif>.pdf"><font size="+1">Additional Information</a></font></cfif>
		</td>
		<td align="right" valign="top" rowspan=2>
			<!--- intl reps pictures --->
			<cfif client.usertype EQ 8>
				<cfset pic_num = #RandRange(1,34)#>
				<img src="pics/intrep/#pic_num#.jpg"><br>
			<cfelse> 	
				<cfquery name="smg_pics" datasource="caseusa">
					SELECT pictureid, title, description
					FROM `smg_pictures`
					WHERE active = '1'
					ORDER BY rand()			
				</cfquery> 
				<cfif smg_pics.description is not ''>
					<a href="?curdoc=picture_details&pic=#smg_pics.pictureid#">
				</cfif>
				<img src="uploadedfiles/welcome_pics/#smg_pics.pictureid#.jpg" border=0><br>
				<em>#smg_pics.title#</em><br>
				<img src="pics/view_details.gif" border=0></a>				
			</cfif>	
		</td>
	</tr>
</table>
<!----footer of table---->
<cfinclude template="table_footer.cfm">
</cfif><br>

<!----CURRENT ITEMS---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/current_items.gif"></td>
		<td background="pics/header_background.gif"><h2>Current Items</td><td background="pics/header_background.gif" width=16></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
	
<!---- OFFICE AND FIELD ---->			
<cfif client.usertype LTE 7 OR client.usertype EQ 9>

<cfquery name="current_programs" datasource="caseusa">
	SELECT programid 
	FROM smg_programs
	WHERE startdate < #now()# and companyid = #client.companyid#
</cfquery>
			
<cfquery name="get_new_users" datasource="caseusa">
	select userid, datecreated, advisor_id, firstname, lastname, city, state, email
	from smg_users
	WHERE datecreated > '#client.lastlogin#'
	<cfif client.usertype gt 4>
		and advisor_id = #client.userid#
	</cfif>
</cfquery>

<Cfquery name="regionname" datasource="caseusa">
	SELECT regionid 
	FROM user_access_rights
	WHERE userid = #client.userid#
</Cfquery>

<cfquery name="get_new_students" datasource="caseusa">
	select studentid, dateapplication, regionassigned, hostid
	from smg_students
	WHERE dateapplication > '#client.lastlogin#'
	and( regionassigned =
	<Cfloop query="regionname">
	 #regionid# <cfif #regionname.currentrow# eq #regionname.recordcount#><cfelse> or regionassigned = </cfif>
	</Cfloop>)
</cfquery>

<cfset placed= 0>
<cfloop query="get_new_students">
	<cfif hostid NEQ 0 >
		<cfset placed = #placed# + 1>
	</cfif>
</cfloop>

<cfquery name="current_students_status" datasource="caseusa">
	SELECT s.firstname, s.familylastname, s.studentid, s.programid, s.uniqueid,
		p.startdate, p.enddate, p.type, ptype.aug_report
	FROM smg_students s
	INNER JOIN smg_programs p ON p.programid = s.programid
	LEFT JOIN smg_program_type ptype ON ptype.programtypeid = p.type
	WHERE s.active = 1  
		AND s.arearepid = '#client.userid#' 
	<cfif current_programs.recordcount neq 0>
		AND (s.programid = 
			<Cfloop query="current_programs">
				#programid# <cfif current_programs.currentrow is #current_programs.recordcount#><cfelse> or s.programid = </cfif>
			</Cfloop>)
	</cfif>
</cfquery>
	
<!--- SET THE CURRENT PROGRESS REPORT --->
<cfif NOT IsDefined('url.rmonth')>
	<cfif DateFormat(now(), 'mm') EQ 9 OR dateFormat(now(), 'mm') EQ 10 OR dateFormat(now(), 'mm') EQ 8 > 
		<cfset url.rmonth = 10> <!--- OCT --->
	<cfelseif DateFormat(now(), 'mm') EQ 11 OR dateFormat(now(), 'mm') EQ 12> 
		<cfset url.rmonth = 12> <!--- DEC --->
	<cfelseif DateFormat(now(), 'mm') EQ 1 OR dateFormat(now(), 'mm') EQ 2 > 
		<cfset url.rmonth = 2> <!--- FEB --->
	<cfelseif DateFormat(now(), 'mm') EQ 3 OR dateFormat(now(), 'mm') EQ 4> 
		<cfset url.rmonth = 4> <!--- APRIL --->
	<cfelseif DateFormat(now(), 'mm') EQ 5 OR dateFormat(now(), 'mm') EQ 6> 
		<cfset url.rmonth = 6> <!--- JUNE --->
	<cfelseif DateFormat(now(), 'mm') EQ 7 OR dateFormat(now(), 'mm') EQ 8> 
		<cfset url.rmonth = 8> <!--- August --->
	</cfif>
</cfif>

<!--- REPORTS PER PROGRAM
	10 MONTH - OCT - DEC - FEB - APRIL - JUNE - TYPE = 1
	12 MONTH - FEB - APRIL - AUG - OCT - DEC - TYPE = 2
	1ST SEMESTER - OCT - DEC - FEB - TYPE = 3
	2ND SEMESTER - FEB - APRIL - JUNE - TYPE = 4
	
	PRIVATE HIGH SCHOOL PROGRAM
	10 MONTH - OCT - DEC - FEB - APRIL - JUNE - TYPE = 5
	12 MONTH - FEB - APRIL - AUG - OCT - DEC - TYPE = 24
	1ST SEMESTER - OCT - DEC - FEB - TYPE = 25
	2ND SEMESTER - FEB - APRIL - JUNE - TYPE = 26
---->

<!--- UPDATE J1 PRIVATE PROGRAMS TYPE --->
<!---
<cfif client.userid eq 510>
<cfquery name="get_programs" datasource="caseusa">
	SELECT programid, programname, type, startdate, enddate
	FROM smg_programs
	WHERE type = '5' OR programname LIKE '%private%'
</cfquery>
<cfloop query="get_programs">
	<cfset newtype = 100>
	<!--- 10 month --->
	<cfif DateFormat(startdate, 'mm') EQ 07 AND  DateFormat(enddate, 'mm') EQ 6>
		<cfset newtype = 5>
	<!--- 12 month --->
	<cfelseif DateFormat(startdate, 'mm') EQ 01 AND  DateFormat(enddate, 'mm') EQ 12>			
		<cfset newtype = 24>
	<!--- 1st --->
	<cfelseif DateFormat(startdate, 'mm') EQ 07 AND  DateFormat(enddate, 'mm') EQ 01>
		<cfset newtype = 25>
	<!--- 2nd --->
	<cfelseif DateFormat(startdate, 'mm') EQ 01 AND  DateFormat(enddate, 'mm') EQ 06>			
		<cfset newtype = 26>
	</cfif>
	<cfquery name="update" datasource="caseusa">
		UPDATE smg_programs
		SET type = '#newtype#'
		WHERE programid = '#programid#'
		LIMIT 1
	</cfquery>
</cfloop>
</cfif>
--->

<table width=100% cellspacing=0 border=0 class="section">
	<tr>
		<td align="center">
		<!--- show only one month report ---->
		<cfif current_students_status.recordcount GT 10>
			<table cellpadding=2 cellspacing=4 width=100% bgcolor="##ffffe6">
				<tr><td bgcolor="##D1E0EF" colspan=2><span class="get_attention"><b>:: </b></span>Student Progress Reports</td></tr>
				<tr>
					<td valign="top" colspan=2>
						<cfif current_students_status.recordcount EQ 0>
							<div align="center">You are not supervising any students, no reports to fill out.</div>
						<cfelse>
						<table width=90% align="center" cellspacing="0" cellpadding=2 border=0>
							<tr bgcolor="ABADFC">
								<td width=40%>Student Name (##ID)</td>
								<td width=60%>					
								<form name="formmonth">
									<select name="month" onChange="javascript:formHandler2()">
									<option value="?curdoc=initial_welcome&rmonth=10" <cfif url.rmonth is '10'>selected</cfif>>October</option>
									<option value="?curdoc=initial_welcome&rmonth=12" <cfif url.rmonth is '12'>selected</cfif>>December</option>
									<option value="?curdoc=initial_welcome&rmonth=2" <cfif url.rmonth is '2'>selected</cfif>>February</option>
									<option value="?curdoc=initial_welcome&rmonth=4" <cfif url.rmonth is '4'>selected</cfif>>April</option>
									<option value="?curdoc=initial_welcome&rmonth=6" <cfif url.rmonth is '6'>selected</cfif>>June</option>
									<option value="?curdoc=initial_welcome&rmonth=8" <cfif url.rmonth is '8'>selected</cfif>>August</option>
									</select>
								</form>								
								</td> 	 			
							</tr>
							<cfloop query="current_students_status">
							<tr><td><a href="index.cfm?curdoc=student_info&studentid=#studentid#">#firstname# #familylastname# (###studentid#)</A></td>
								<td>
								<!--- NEEDS TO BE DONE - INCLUDE PRIVATE SCHOOL STUDENTS  - DIFFERENT TYPE --->
								
								<!---- check offline reports---->
								<cfquery name="check_offline" datasource="caseusa">
									SELECT report_number
									FROM smg_prquestion_details
									WHERE submit_type = 'offline' 
										AND month_of_report = '#url.rmonth#'
										AND stuid = '#current_Students_Status.studentid#' 
								</cfquery>
							
								<cfif check_offline.recordcount>
									<a href="?curdoc=forms/view_progress_report&number=#check_offline.report_number#" title="View Report Number #check_offline.report_number#">0</a>		
								<cfelse>
									<!--- get online progress report --->
									<cfquery name="reports" datasource="caseusa">
										SELECT DISTINCT prquestion.stuid, prquestion.report_number, 
											dt.date_submitted, dt.saveonly, dt.date_ra_approved, dt.date_rd_approved,
											dt.ny_accepted, dt.date_rejected, dt.rejected_by, dt.note
										FROM smg_prquestion_details prquestion
										INNER JOIN smg_document_tracking dt ON dt.report_number = prquestion.report_number
										WHERE stuid = '#studentid#'
											AND dt.month_of_report = '#url.rmonth#'											
									</cfquery>
                                    
									<!--- OCT / DEC - 10M, 12M and 1st semester --->
									<cfif reports.recordcount EQ 0 AND (url.rmonth EQ 10 OR url.rmonth EQ 12 OR url.rmonth eq 1)> 
										<cfif type EQ 1 OR type EQ 2 OR type EQ 3 OR type EQ 5 OR type EQ 4 OR type EQ 24 OR type EQ 25>
											<font color="blue"><a href="?curdoc=forms/progress_report&stu=#studentid#&month=#url.rmonth#">D</a></font>
										<cfelse>
											n/a
										</cfif>
									<!--- FEB - ALL PROGRAMS --->	
									<cfelseif reports.recordcount EQ 0 AND (url.rmonth EQ 2 or url.rmonth EQ 1)> 
										<cfif type EQ 1 OR type EQ 2 OR type EQ 3 OR type EQ 4 OR type EQ 5 OR type EQ 24 OR type EQ 25 OR type EQ 26>
											<font color="blue"><a href="?curdoc=forms/progress_report&stu=#studentid#&month=#url.rmonth#">D</a></font>
										<cfelse>
											n/a	
										</cfif>
									<!--- APRIL / JUNE - 10M, 12M and 2nd Semester --->
									<cfelseif reports.recordcount EQ 0 AND (url.rmonth EQ 4 OR url.rmonth EQ 6)> 
										<cfif type EQ 1 OR type EQ 2 OR type EQ 4 OR type EQ 5 OR type EQ 24 OR type EQ 26>
											<font color="blue"><a href="?curdoc=forms/progress_report&stu=#studentid#&month=#url.rmonth#">D</a></font>
										<cfelse>
											n/a											
										</cfif>
									<!--- AUG - 12M --->
									<cfelseif reports.recordcount EQ 0 AND url.rmonth EQ 8>
										<cfif type EQ 2 OR type EQ 24>
											<font color="blue"><a href="?curdoc=forms/progress_report&stu=#studentid#&month=#url.rmonth#">D</a></font>
										<cfelse>
											n/a										
										</cfif>
									<cfelse>
										<cfif reports.date_rejected NEQ ''><a href="?curdoc=forms/view_progress_report&number=#reports.report_number#" title="View Report Number #reports.report_number#"><font color="red">R</font></a>
										<cfelseif reports.saveonly EQ 1><a href="?curdoc=forms/view_progress_report&number=#reports.report_number#" title="View Report Number #reports.report_number#"><font color="orange">S</font></a>
										<cfelseif reports.ny_accepted NEQ ''><a href="?curdoc=forms/view_progress_report&number=#reports.report_number#" title="View Report Number #reports.report_number#"><font color="green">A</font></a>
										<cfelseif reports.date_rd_approved EQ '' AND client.usertype EQ 5><a href="?curdoc=forms/view_progress_report&number=#reports.report_number#" title="View Report Number #reports.report_number#"><font color="orange">W</font></a>
										<cfelseif reports.date_ra_approved EQ '' AND client.usertype EQ 6><a href="?curdoc=forms/view_progress_report&number=#reports.report_number#" title="View Report Number #reports.report_number#"><font color="orange">W</font></a>
										<cfelseif reports.date_rd_approved EQ '' AND client.usertype EQ 6><a href="?curdoc=forms/view_progress_report&number=#reports.report_number#" title="View Report Number #reports.report_number#"><font color="orange">P</font></a>
										<cfelseif reports.date_ra_approved EQ '' AND client.usertype EQ 5><a href="?curdoc=forms/view_progress_report&number=#reports.report_number#" title="View Report Number #reports.report_number#"><font color="orange">P</font></a>
										<cfelseif reports.ny_accepted EQ ''><a href="?curdoc=forms/view_progress_report&number=#reports.report_number#" title="View Report Number #reports.report_number#"><font color="orange">H</font></a>
										<cfelse><a href="?curdoc=forms/view_progress_report&number=#reports.report_number#" title="View Report Number #reports.report_number#"><font color="660000">P</font></a>
										</cfif>
									</cfif>
								</cfif>
							</td></tr>
							</cfloop>
							<tr>
								<td colspan=7 align="center"> 
									<table align="center">
										<tr>
											<td><font size=-2><u>N/A</u> - doesn't apply to student</td><td><font size=-2><u>U</u> - Reports will be due soon</td><td><font size=-2><u><font color="0000FF">D</font></u> - Reports are due; click to submit</td>
										</tr>
										<tr>
											<td><font size=-2><u><font color="660000">P</font></u> - Report is processing</td><td><font size=-2><u><font color="red">R</font></u> - Report has been rejected</td><td><font size=-2><u><font color="green">A</font></u> - Report has been approved</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						</cfif>
				
			<!---- LESS THAN 10 KIDS --->
			<cfelse>
			<table cellpadding=2 cellspacing=4 width=100% bgcolor="##ffffe6">
				<tr><td bgcolor="##D1E0EF" colspan=2><span class="get_attention"><b>:: </b></span>Student Progress Reports</td></tr>
				<tr>
					<td valign="top" colspan=2>
					<cfif current_students_status.recordcount is 0><br>
						<div align="center">You are not supervising any students, no reports to fill out.</div>
					<Cfelse>
						<table width=90% align="center" cellspacing="0" cellpadding=2 border=0>
							<tr bgcolor="ABADFC">
								<td width=35%>Student Name (id)</td><td width=13%>Oct</td><td width=13%>Dec </td><td width=13%>Feb</td><td width=13%>April</td><td width=13%>June</td><td width=13%>July</td> 	 			
							</tr>
							<Cfloop query="current_Students_Status">
							<tr>
								<td><A href="index.cfm?curdoc=student_info&studentid=#studentid#">#firstname# #familylastname# (#studentid#)</A></td>
								<!----Oct---->
								<td>
									<!----Check for Offline Reports---->
									<cfquery name="check_oct_offline" datasource="caseusa">
										select report_number
										from smg_prquestion_details
										where submit_type = 'offline' and month_of_report = 10
										and stuid = #studentid# 
									</cfquery>
									<cfif check_oct_offline.recordcount gt 0>
										<a href="?curdoc=forms/view_progress_report&number=#check_oct_offline.report_number#" title="View Report Number #check_oct_offline.report_number#">0</font>		
									<cfelse>
										<cfquery name="october_reports" datasource="caseusa">
											SELECT DISTINCT prquestion.stuid, prquestion.report_number, 
												dt.date_submitted, dt.saveonly, dt.date_ra_approved, dt.date_rd_approved,
												dt.ny_accepted, dt.date_rejected, dt.rejected_by, dt.note
											FROM smg_prquestion_details prquestion
											INNER JOIN smg_document_tracking dt ON dt.report_number = prquestion.report_number
											WHERE stuid = '#studentid#'
												AND dt.month_of_report = 10											
										</cfquery>
										<!--- OCT - 10M, 12M and 1st semester --->
										
										<cfif october_reports.recordcount EQ 0>																															
											<cfif DateFormat(now(), 'mm') GTE 8 AND dateFormat(now(), 'mm') LTE 12 AND (type EQ 1 OR type EQ 2 OR type EQ 3 OR type EQ 5 OR type EQ 24 OR type EQ 25 OR type eq 4) or (1 eq 1)>
												<font color="blue"><a href="?curdoc=forms/progress_report&stu=#studentid#&month=10">D</a></font></a>
											<cfelse>
												U
											</cfif>
										<cfelse>
											<cfif october_reports.date_rejected is not ''><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#" title="View Report Number #october_reports.report_number#"><font color="red">R</font></a>
											<cfelseif october_reports.saveonly eq 1><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#" title="View Report Number #october_reports.report_number#"><font color="orange">S</font></a>
											<cfelseif october_reports.ny_accepted is not ''><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#" title="View Report Number #october_reports.report_number#"><font color="green">A</font></a>
											<cfelseif october_reports.date_rd_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#" title="View Report Number #october_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif october_reports.date_ra_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#" title="View Report Number #october_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif october_reports.date_rd_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#" title="View Report Number #october_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif october_reports.date_ra_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#" title="View Report Number #october_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif october_reports.ny_accepted is  ''><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#" title="View Report Number #october_reports.report_number#"><font color="orange">H</font></a>
											<cfelse><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#" title="View Report Number #october_reports.report_number#"><font color="660000">P</font></a>
											</cfif>
										</cfif>
									</cfif>
								</td>
																	
								<!----Dec---->							
								<td>
									<cfquery name="december_reports" datasource="caseusa">
										SELECT DISTINCT prquestion.stuid, prquestion.report_number, 
											dt.date_submitted, dt.saveonly, dt.date_ra_approved, dt.date_rd_approved,
											dt.ny_accepted, dt.date_rejected, dt.rejected_by, dt.note
										FROM smg_prquestion_details prquestion
										INNER JOIN smg_document_tracking dt ON dt.report_number = prquestion.report_number
										WHERE stuid = '#studentid#'
											AND dt.month_of_report = '12'											
									</cfquery>
									<!--- DEC - 10M, 12M and 1st semester --->
									<cfif december_reports.recordcount eq 0>
										<cfif (DateFormat(now(), 'mm') GTE 10 AND dateFormat(now(), 'mm') LTE 12) OR DateFormat(now(),'mm') EQ 1 AND (type EQ 1 OR type EQ 2 OR type EQ 3 OR type EQ 5 OR type EQ 4 OR type EQ 24 OR type EQ 25) or (1 eq 1)>
											<A href="?curdoc=forms/progress_report&stu=#studentid#&month=12"><font color="0000ff"><a href="?curdoc=forms/progress_report&stu=#studentid#&month=12">D</a></font></a>
										<cfelse>
											U
										</cfif>
									<cfelse>
										<cfif december_reports.date_rejected is not ''><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#" title="View Report Number #december_reports.report_number#"><font color="red">R</font></a>
										<cfelseif december_reports.saveonly eq 1><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#" title="View Report Number #december_reports.report_number#"><font color="orange">S</font></a>
										<cfelseif december_reports.ny_accepted is not ''><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#" title="View Report Number #december_reports.report_number#"><font color="green">A</font></a>
										<cfelseif december_reports.date_rd_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#" title="View Report Number #december_reports.report_number#"><font color="orange">W</font></a>
										<cfelseif december_reports.date_ra_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#" title="View Report Number #december_reports.report_number#"><font color="orange">W</font></a>
										<cfelseif december_reports.date_rd_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#" title="View Report Number #december_reports.report_number#"><font color="orange">P</font></a>
										<cfelseif december_reports.date_ra_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#" title="View Report Number #december_reports.report_number#"><font color="orange">P</font></a>
										<cfelseif december_reports.ny_accepted is  ''><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#" title="View Report Number #december_reports.report_number#"><font color="orange">H</font></a>
										<cfelse><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#" title="View Report Number #december_reports.report_number#"><font color="660000">P</font></a>
										</cfif>
									</cfif>			
								</td>
									
								<cfif (client.userid NEQ 8246 or client.userid NEQ 8786)>
								<!----Feb---->
								<td>
								</a>
								<!----Check for Offline Reports---->
									<cfquery name="check_feb_offline" datasource="caseusa">
										select report_number
										from smg_prquestion_details
										where submit_type = 'offline' and month_of_report = 2
										and stuid = #studentid# 
									</cfquery>
									<!--- FEB - ALL PROGRAMS --->
									<cfif check_feb_offline.recordcount gt 0>
										<a href="?curdoc=forms/view_progress_report&number=#check_feb_offline.report_number#" title="View Report Number #check_feb_offline.report_number#">0</font>		
									<cfelse>
										 <!----<Cfif  current_students_status.type neq 2 and current_students_status.type neq 4  and current_students_status.type neq 5>---->
										 <cfif 1 neq 1>N/A<cfelse>
											  <cfquery name="february_reports" datasource="caseusa">
													SELECT DISTINCT prquestion.stuid, prquestion.report_number, 
														dt.date_submitted, dt.saveonly, dt.date_ra_approved, dt.date_rd_approved,
														dt.ny_accepted, dt.date_rejected, dt.rejected_by, dt.note
													FROM smg_prquestion_details prquestion
													INNER JOIN smg_document_tracking dt ON dt.report_number = prquestion.report_number
													WHERE stuid = '#studentid#'
														AND dt.month_of_report = 2
											  </cfquery>
											  <cfif february_reports.recordcount eq 0>
													<cfif DateFormat(now(), 'mm') is 1 or  DateFormat(now(), 'mm') is 2 or DateFormat(now(), 'mm') is 3>
														<A href="?curdoc=forms/progress_report&stu=#studentid#&month=2"><font color="0000ff"><a href="?curdoc=forms/progress_report&stu=#studentid#&month=2">D</a></font></a>
													<cfelse>
														U 
													</cfif>
											  <cfelse>
													<cfif february_reports.ny_accepted is not ''><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#" title="View Report Number #february_reports.report_number#"><font color="green">A</font></a>
													<cfelseif february_reports.saveonly eq 1><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#" title="View Report Number #february_reports.report_number#"><font color="orange">S</font></a>
													<cfelseif february_reports.date_rejected is not ''><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#" title="View Report Number #february_reports.report_number#"><font color="red">R</font></a>
													<cfelseif february_reports.date_rd_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#" title="View Report Number #february_reports.report_number#"><font color="orange">W</font></a>
													<cfelseif february_reports.date_ra_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#" title="View Report Number #february_reports.report_number#"><font color="orange">W</font></a>
													<cfelseif february_reports.date_rd_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#" title="View Report Number #february_reports.report_number#"><font color="orange">P</font></a>
													<cfelseif february_reports.date_ra_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#" title="View Report Number #february_reports.report_number#"><font color="orange">P</font></a>
													<cfelseif february_reports.ny_accepted is  ''><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#" title="View Report Number #february_reports.report_number#"><font color="orange">H</font></a>
													<cfelse><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#" title="View Report Number #february_reports.report_number#"><font color="660000">P</font></a>
													</cfif>
											   </cfif>
										</cfif>
									</cfif>
								</td>
								<!----Apr---->
								<td>
									<Cfif DateFormat(current_students_status.startdate, 'mm') gt 7 and current_students_status.type neq 2 and current_students_status.type neq 4 and current_students_status.type neq 5>N/A<cfelse>
										<cfquery name="april_reports" datasource="caseusa">
											select distinct smg_prquestion_details.stuid, smg_prquestion_details.report_number, 
											smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved, smg_document_tracking.date_rd_approved, smg_document_tracking.saveonly,
											smg_document_tracking.ny_accepted, smg_document_tracking.date_rejected, smg_document_tracking.rejected_by, smg_document_tracking.note
											from smg_prquestion_details, smg_document_tracking
											where smg_document_tracking.report_number = smg_prquestion_details.report_number and stuid = #studentid# and smg_document_tracking.month_of_report = 4
										</cfquery>
										<cfif april_reports.recordcount eq 0>
											<cfif DateFormat(now(), 'mm') is 2 or DateFormat(now(), 'mm') is 3 or DateFormat(now(), 'mm') is 4 or  DateFormat(now(), 'mm') is 5><A href="?curdoc=forms/progress_report&stu=#studentid#&month=4"><font color="0000ff"><a href="?curdoc=forms/progress_report&stu=#studentid#&month=4">D</a></font></a><cfelse>U</cfif>
										<cfelse>
											<cfif april_reports.date_rejected is not ''><a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#" title="View Report Number #april_reports.report_number#"><font color="red">R</font></a>
											<cfelseif april_reports.saveonly eq 1><a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#" title="View Report Number #april_reports.report_number#"><font color="orange">S</font></a>
											<cfelseif april_reports.date_rd_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#" title="View Report Number #april_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif april_reports.date_ra_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#" title="View Report Number #april_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif april_reports.date_rd_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#" title="View Report Number #april_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif april_reports.date_ra_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#" title="View Report Number #april_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif april_reports.ny_accepted is  ''><a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#" title="View Report Number #april_reports.report_number#"><font color="orange">H</font></a>
											<cfelseif april_reports.ny_accepted is not ''><a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#" title="View Report Number #april_reports.report_number#"><font color="green">A</font></a>
											<cfelse><a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#" title="View Report Number #april_reports.report_number#"><font color="660000">P</font></a>
											</cfif>
										</cfif>
									</cfif>
								</td>
								<!----June---->
								<td>
									<Cfif DateFormat(current_students_status.startdate, 'mm') lt 7 and current_students_status.type neq 2 and current_students_status.type neq 4 and current_students_status.type neq 5 and current_students_status.type neq 3>N/A<cfelse>
										<cfquery name="june_reports" datasource="caseusa">
											select distinct smg_prquestion_details.stuid, smg_prquestion_details.report_number, 
											smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved, smg_document_tracking.date_rd_approved,
											smg_document_tracking.ny_accepted, smg_document_tracking.date_rejected, smg_document_tracking.rejected_by, smg_document_tracking.note, smg_document_tracking.saveonly
											from smg_prquestion_details, smg_document_tracking
											where smg_document_tracking.report_number = smg_prquestion_details.report_number and stuid = #studentid# and smg_document_tracking.month_of_report = 6
										</cfquery>
										<cfif june_reports.recordcount eq 0>
											<cfif DateFormat(now(), 'mm') is 5 or DateFormat(now(), 'mm') is 6 or DateFormat(now(), 'mm') is 7><A href="?curdoc=forms/progress_report&stu=#studentid#&month=6"><font color="0000ff"><a href="?curdoc=forms/progress_report&stu=#studentid#&month=6">D</a></font></a><cfelse>U</cfif>
										<cfelse>
											<cfif june_reports.date_rejected is not ''>
												<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#" title="View Report Number #june_reports.report_number#"><font color="red">R</font></a>
											<cfelseif june_reports.date_rd_approved is '' and client.usertype eq 5>
												<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#" title="View Report Number #june_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif june_reports.saveonly eq 1>
												<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#" title="View Report Number #june_reports.report_number#"><font color="orange">S</font>
											<cfelseif june_reports.date_ra_approved is '' and client.usertype eq 6>
												<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#" title="View Report Number #june_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif june_reports.date_rd_approved is '' and client.usertype eq 6>
												<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#" title="View Report Number #june_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif june_reports.date_ra_approved is '' and client.usertype eq 5>
												<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#" title="View Report Number #june_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif june_reports.ny_accepted EQ ''>
												<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#" title="View Report Number #june_reports.report_number#"><font color="orange">H</font></a>
											<cfelseif june_reports.ny_accepted is not ''>
												<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#" title="View Report Number #june_reports.report_number#"><font color="green">A</font></a>
											<cfelse>
												<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#" title="View Report Number #june_reports.report_number#"><font color="660000">P</font></a>
											</cfif>
										</cfif>
									</cfif>
								</td>
								<!----August---->
								<td>
									<Cfif current_students_status.aug_report eq 0 >N/A<cfelse>
										<cfquery name="august_reports" datasource="caseusa">
											select distinct smg_prquestion_details.stuid, smg_prquestion_details.report_number, 
											smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved, smg_document_tracking.date_rd_approved,
											smg_document_tracking.ny_accepted, smg_document_tracking.date_rejected, smg_document_tracking.rejected_by, smg_document_tracking.note
											from smg_prquestion_details, smg_document_tracking
											where smg_document_tracking.report_number = smg_prquestion_details.report_number and stuid = #studentid# and smg_document_tracking.month_of_report = 8
										</cfquery>
										<cfif august_reports.recordcount eq 0>
											<cfif DateFormat(now(), 'mm') is 7 or DateFormat(now(), 'mm') is 8><A href="?curdoc=forms/progress_report&stu=#studentid#&month=8"><font color="0000ff"><a href="?curdoc=forms/progress_report&stu=#studentid#&month=8">D</a></font></a><cfelse>U</cfif>
										<cfelse>
											<cfif august_reports.date_rejected is not ''><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#" title="View Report Number #october_reports.report_number#"><font color="red">R</font></a>
											<cfelseif august_reports.date_rd_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#august_reports.report_number#" title="View Report Number #october_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif august_reports.date_ra_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#august_reports.report_number#" title="View Report Number #october_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif august_reports.date_rd_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#august_reports.report_number#" title="View Report Number #october_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif august_reports.date_ra_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#" title="View Report Number #october_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif august_reports.ny_accepted is  ''><a href="?curdoc=forms/view_progress_report&number=#august_reports.report_number#" title="View Report Number #october_reports.report_number#"><font color="orange">H</font></a>
											<cfelseif august_reports.ny_accepted is not ''><a href="?curdoc=forms/view_progress_report&number=#august_reports.report_number#" title="View Report Number #october_reports.report_number#"><font color="green">A</font></a>
											<cfelse><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#" title="View Report Number #october_reports.report_number#"><font color="660000">P</font></a>
											</cfif>
										</cfif>
									</cfif>
								</td>
							</cfif>
							</tr>
							</cfloop>
							<tr>
								<td colspan=7 align="center"> 
									<table align="center">
										<tr>
											<td><font size=-2><u>N/A</u> - doesn't apply to student</td><td><font size=-2><u>U</u> - Reports will be due soon</td><td><font size=-2><u><font color="0000FF">D</font></u> - Reports are due; click to submit</td>
										</tr>
										<tr>
											<td><font size=-2><u><font color="660000">P</font></u> - Report is processing</td><td><font size=-2><u><font color="red">R</font></u> - Report has been rejected</td><td><font size=-2><u><font color="green">A</font></u> - Report has been approved</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</cfif>
				</td>
			</tr>
			
			</cfif> <!--- current_students_status.recordcount --->
			
			<tr>
				<td bgcolor="##D1E0EF" width=50%><span class="get_attention"><b>::</b></span> New Students </u></td><td bgcolor="##D1E0EF"><span class="get_attention"><b>::</b></span> Reports Needing Approval</u></td>
			</tr>
			<tr>
				<td valign="top">
					<cfquery name="new_students" datasource="caseusa">
						select studentid, dateapplication, regionassigned, hostid, regionassigned, firstname, familylastname
						from smg_students
						WHERE dateapplication > '#client.lastlogin#' and active =1 and companyid = #client.companyid# and<cfif client.usertype lte 5>
						<cfquery name="regions" datasource="caseusa">
							select regionid from 
							user_access_rights
							where userid = #client.userid# and companyid = #client.companyid#
						</cfquery>
						(regionassigned = 
						<cfloop query="regions">
							#regionid# <cfif regions.currentrow eq #regions.recordcount#><cfelse> or regionassigned =</cfif>
						</cfloop>)
						<cfelseif client.usertype eq 6>
							<cfquery name="get_reps" datasource="caseusa">
								select DISTINCT userid 
								from user_access_rights
								where advisorid = #client.userid# and companyid = #client.companyid#
									  OR userid = #client.userid#
							</cfquery>
							(arearepid = 
							<cfloop query="get_reps">
							#userid# <cfif get_reps.currentrow eq #get_reps.recordcount#><cfelse> or arearepid =</cfif>
							</cfloop>)
						<cfelseif client.usertype eq 7 or client.usertype eq 9>
							arearepid = #client.userid#
						</cfif>
					</cfquery>
					<cfif new_students.recordcount eq 0>
						No new students have been assigned to any of your regions since your last visit to the site.
					<cfelse>
						<cfloop query="new_students">
							<a href="?curdoc=student_info&studentid=#studentid#">#firstname# #familylastname#</a><br>
						</cfloop>
					</cfif>
				</td>
				<td valign="top">
					<cfquery name="check_highest_user_type" datasource="caseusa">
						select usertype from user_access_rights
						where userid = #client.userid# and usertype < 7
					</cfquery>
					<Cfif check_highest_user_type.recordcount gt 0>
						
						<A href="?curdoc=forms/progress_report_list">Report Status for Field</a><br>
						
					</Cfif>
					<A href="?curdoc=pending_hosts">View Pending Placements</a>
				</td>
			</tr>
			<tr></tr>
			<tr>
				<td bgcolor="##D1E0EF"><span class="get_attention"><b>::</b></span> New Users <font size=-2>since last visit</font></u></td>
				<Td bgcolor="##D1E0EF"><span class="get_attention"><b>::</b></span> <cfif client.usertype lte 4>Your Current Help Desk Tickets <Cfelse>Your Recent Documents</u> <font size=-2>(submitted within 20 days)</font></cfif></Td>
			</tr>
			<tr>
				<td valign="top">
					<cfif get_new_users.recordcount eq 0>
						No new reps have been assigned to you.
					<cfelse>
						<cfloop query="get_new_users"> 
						 <a href="mailto:#email#"><img src="pics/email.gif" border=0></a> <a href="?curdoc=user_info&userid=#userid#">#firstname# #lastname#</a> of #city#, #state#<br>
						</cfloop>
					</cfif>
				 </td>
				 <!----Help Desk List---->
				 <cfif client.usertype lte 4>
				 <td valign="top">
					<cfquery name="help_desk_user" datasource="caseusa">
						SELECT helpdeskid, title, category, section, priority, text, status, date, submitid, assignid,
						submit.firstname as submit_firstname, submit.lastname as submit_lastname,
						assign.firstname as assign_firstname, assign.lastname as assign_lastname
						FROM smg_help_desk
						LEFT JOIN smg_users submit ON smg_help_desk.submitid = submit.userid
						LEFT JOIN smg_users assign ON smg_help_desk.assignid = assign.userid 
						<cfif client.usertype eq 1>
							WHERE assignid = '#client.userid#' and status = 'initial'
						<cfelse>
							WHERE submitid = '#client.userid#' and status != 'closed'
						</cfif>
						ORDER BY status, date
					</cfquery>
					<table cellpadding=4 cellspacing =0 border=0>
						<Tr><td>Submitted</td><td>Title</td><td>Status</td></Tr>
						<cfif help_desk_user.recordcount is not 0>
							<cfloop query="help_desk_user">
								<cfif #DateDiff('d',date, now())# GT 15 and status is not 'complete'>
								<tr>
								<cfelse>
								<tr bgcolor="#iif(help_desk_user.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
								</cfif>
									<td width="10%" valign="top">#DateFormat(date, 'mm-dd-yyyy')#</td>
									<td width="21%"valign="top"><a href="?curdoc=helpdesk/help_desk_view&helpdeskid=#helpdeskid#">#title#</a></td>
									<td width="10%"valign="top">#status#</td>
								</tr>
							</cfloop>
						<cfelse>
							<tr><td colspan="6" bgcolor="ffffe6" valign="top">You have no open or recently complted tickets on the Help Desk</td></tr>
						</cfif>
					</table>
				</td>
			<cfelse>
				<td valign="top">Will be available as documents are online.</td>
			</cfif>
			</tr>
		</table>
		</td>
	</tr>
</table>

<!---- WELCOME SCREEN FOR INTL. AGENTS ---->
<cfelseif client.usertype EQ 8>
	<table cellpadding=2 cellspacing=4 width=100% bgcolor="##ffffe6" class="section">
		<tr>
			<td bgcolor="##D1E0EF" width=50%><span class="get_attention"><b>::</b></span><Cfquery name="companyname" datasource="caseusa">
			select businessname from smg_users
			where userid = #client.parentcompany#
			</Cfquery>News, Alerts, and Updates from #companyname.businessname#</u></td>
			<Td bgcolor="##D1E0EF"><span class="get_attention"><b>::</b></span> Your Current Help Desk Tickets </Td>
		</tr>
		<tr>
			<td valign="top">
			<cfquery name="intagent_alert_messages" datasource="caseusa">
			select *
			from smg_intagent_messages
			where (messagetype = 'alert') and  (expires > #now()# and startdate < #now()# )
			and parentcompany = #client.parentcompany#
			</cfquery>
			<cfquery name="intagent_update_messages" datasource="caseusa">
			select *
			from smg_intagent_messages
			where messagetype = 'update'  and  (expires > #now()# and startdate < #now()#)
			and parentcompany = #client.parentcompany#
			</cfquery>
			<cfquery name="intagent_news_messages" datasource="caseusa">
			select *
			from smg_intagent_messages
			where messagetype = 'news'  and  (expires > #now()# and startdate < #now()#)
			and parentcompany = #client.parentcompany#
			
			</cfquery>
			<div align="center"><h3>News</h3></div>
			<cfif intagent_alert_messages.recordcount neq 0>
			<cfloop query="intagent_news_messages">
						
							<cfif #intagent_news_messages.details# is not ''><b>#message#</b><br>
								<div align="justify">#DateFormat(startdate, 'MMMM D, YYYY')# - #ParagraphFormat(details)#
								</div>
							</cfif>
								
						</cfloop>
			<cfelse>
			There are currently no annoucements or news items from #companyname.businessname#
			</cfif>
						<cfif intagent_alert_messages.recordcount neq 0>
						<div class="alerts"><h3>Alerts</h3><br>
							<cfloop query="intagent_alert_messages">
						
							<cfif #intagent_alert_messages.details# is not ''><b>#message#</b><br>
								<div align="justify">#DateFormat(startdate, 'MMMM D, YYYY')# - #ParagraphFormat(details)#
								</div>
							</cfif>
								
						</cfloop>
						</div>
					</cfif>
						<cfif intagent_update_messages.recordcount neq 0>
							<div class="updates"><h3>Updates</h3><br>
			<cfloop query="intagent_update_messages">
						
							<cfif #intagent_update_messages.details# is not ''><b>#message#</b><br>
								<div align="justify">#DateFormat(startdate, 'MMMM D, YYYY')# - #ParagraphFormat(details)#
								</div>
							</cfif>
								
						</cfloop>
						</div>
					</cfif>
			</td>
			<td valign="top">
				<cfquery name="help_desk_user" datasource="caseusa">
					SELECT helpdeskid, title, category, section, priority, text, status, date, submitid, assignid,
						submit.firstname as submit_firstname, submit.lastname as submit_lastname,
						assign.firstname as assign_firstname, assign.lastname as assign_lastname
					FROM smg_help_desk
					LEFT JOIN smg_users submit ON smg_help_desk.submitid = submit.userid
					LEFT JOIN smg_users assign ON smg_help_desk.assignid = assign.userid 
					WHERE submitid = '#client.userid#' and status != 'closed'
					ORDER BY status, date
				</cfquery>
				<table cellpadding=4 cellspacing =0 border=0>
					<Tr><td>Submitted</td><td>Title</td><td>Status</td></Tr>
						<cfif help_desk_user.recordcount is not 0>
						<cfloop query="help_desk_user">
							<cfif #DateDiff('d',date, now())# GT 15 and status is not 'complete'>
							<tr>
							<cfelse>
							<tr bgcolor="#iif(help_desk_user.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
							</cfif>
							<td width="10%" valign="top">#DateFormat(date, 'mm-dd-yyyy')#</td>
								<td width="21%"valign="top"><a href="?curdoc=helpdesk/help_desk_view&helpdeskid=#helpdeskid#">#title#</a></td>
								<td width="10%"valign="top">#status#</td>

							</tr>
						</cfloop>
						<cfelse>
							<tr><td colspan="6" bgcolor="ffffe6" valign="top">You have no open or recently completed tickets on the Help Desk</td></tr>
						</cfif>
				</table>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	<cfelseif client.usertype EQ 11>
		<table cellpadding=2 cellspacing=4 width=100% bgcolor="##ffffe6" class="section">
		<tr>
			<Td bgcolor="##D1E0EF"><span class="get_attention"><b>::</b></span> Your Current Help Desk Tickets </Td>
		</tr>
		<tr>
			<td valign="top">
				<cfquery name="help_desk_user" datasource="caseusa">
					SELECT helpdeskid, title, category, section, priority, text, status, date, submitid, assignid,
						submit.firstname as submit_firstname, submit.lastname as submit_lastname,
						assign.firstname as assign_firstname, assign.lastname as assign_lastname
					FROM smg_help_desk
					LEFT JOIN smg_users submit ON smg_help_desk.submitid = submit.userid
					LEFT JOIN smg_users assign ON smg_help_desk.assignid = assign.userid 
					WHERE submitid = '#client.userid#' 
						and status != 'closed'
					ORDER BY status, date
				</cfquery>
				<table cellpadding=4 cellspacing =0 border=0>
					<Tr><td>Submitted</td><td>Title</td><td>Status</td></Tr>
						<cfif help_desk_user.recordcount NEQ 0>
						<cfloop query="help_desk_user">
							<cfif #DateDiff('d',date, now())# GT 15 and status is not 'complete'>
							<tr>
							<cfelse>
							<tr bgcolor="#iif(help_desk_user.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
							</cfif>
							<td width="10%" valign="top">#DateFormat(date, 'mm-dd-yyyy')#</td>
								<td width="21%"valign="top"><a href="?curdoc=helpdesk/help_desk_view&helpdeskid=#helpdeskid#">#title#</a></td>
								<td width="10%"valign="top">#status#</td>
							</tr>
						</cfloop>
						<cfelse>
							<tr><td colspan="6" bgcolor="ffffe6" valign="top">You have no open or recently completed tickets on the Help Desk</td></tr>
						</cfif>
				</table>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		</table>
	</cfif>
	<!----footer of table---->
	<cfinclude template="table_footer.cfm">

<!--- 	</td>
</tr>
</table> --->

</body></cfoutput>


</html>