<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>SMG Online Application - Welcome</title>
</head>
<body>
<cftry>

<cfif isDefined('url.unqid')>
	<!----Get student id  for office folks linking into the student app---->
	<cfquery name="get_student_id" datasource="caseusa">
		select studentid from smg_students
		where uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
	</cfquery>
	<cfset client.studentid = #get_student_id.studentid#>
</cfif>

<cfquery name="last_change" datasource="caseusa">
	SELECT lastchanged
	FROM smg_students
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_latest_date" datasource="caseusa">
	SELECT max(date) as date
	FROM smg_student_app_status
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_status" datasource="caseusa">
	SELECT * 
	FROM smg_student_app_status
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
	ORDER BY id DESC
</cfquery>

<cfinclude template="querys/get_student_info.cfm">

<cfquery name="get_intl_rep" datasource="caseusa">
	SELECT businessname, phone, email, userid
	FROM smg_users
	WHERE userid = <cfqueryparam value="#get_student_info.intrep#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_branch" datasource="caseusa">
	SELECT businessname,phone, studentcontactemail as email
	FROM smg_users
	WHERE userid = <cfqueryparam value="#get_student_info.branchid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfoutput>

<!--- APPLICATION EXPIRED --->
<cfif get_status.status LTE 2 AND student_name.application_expires lt #now()#>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="../pics/header_background.gif"><img src="../pics/news.gif"></td>
			<td background="../pics/header_background.gif"><h2>APPLICATION EXPIRED</td><td background="../pics/header_background.gif" width=16></td>
			<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<table width=100% class="section">
	<tr>
		<td>
		<cfif client.usertype NEQ 10 AND (get_student_info.intrep EQ client.userid OR get_student_info.branchid EQ client.userid)>
			<cfform method="post" action="querys/extend_deadline.cfm">
				<!---
				<cfset deadline = '04/15/07 23:59:59'>
				<cfset maxdeadline = #DateDiff('d', now(), deadline)#>
				--->
				<cfset maxdeadline = 15>
				<cfset expdate = #DateAdd('d', maxdeadline, now())#>
				
				This application has expired. You can re-activate it by extending the application deadline below in 30 days.  
				At this time you can extend the deadline up to #DateFormat(expdate, 'mm/dd/yyyy')#.<br><br>

				Extend Deadline by: 
				<cfif maxdeadline GT 1>
					<select name="extdeadline">
						<cfloop index=i from=0 to="#maxdeadline#" step="1">
							<option value=#i#>#i#</option>
						</cfloop>
					</select>
					days from today. <input type="submit" value="Extend Deadline"><br>
				<cfelse>
					<b>You can not extend the deadline</b>.
					<cfinput type="hidden" name="extdeadline" value="0">
				</cfif> 
		</cfform>
		<cfelse>
			Your Application has expired. Please contact <cfif get_branch.recordcount eq 0>#get_intl_rep.businessname#<cfelse>#get_branch.businessname#</cfif> to 
			reactivate your account.<br><br>
			<cfif get_branch.recordcount eq 0>#get_intl_rep.businessname#<br>#get_intl_rep.phone#<br><a href="mailto:#get_intl_rep.email#">#get_intl_rep.email#</a><cfelse>#get_branch.businessname#<br>#get_branch.phone#<br><a href="mailto:#get_branch.email#">#get_branch.email#</a></cfif>
		</cfif>
		</td>
	</tr>
	</table>
	
	<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
	</tr>
	</table>
<cfelse>					
		<Table width=100% border=0 align="center">
		<tr>
			<td width=49% valign="top">
				<!--- Application News --->
				<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
					<tr valign=middle height=24>
						<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
						<td width=26 background="../pics/header_background.gif"><img src="../pics/news.gif"></td>
						<td background="../pics/header_background.gif"><h2>Application News </td><td background="../pics/header_background.gif" width=16></td>
						<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
					</tr>
				</table>
				<table width=100% class="section">
					<tr>
						<td>
						<cfif get_status.status LTE 2>
							Welcome to the Cultural Academic Student Exchange EXITS Online Application.<br>
							<br>
							There are 5 main sections of the application with multiple pages under each main section. The menu
							across the top of the screen shows each section of the application along with a check list, print options, and a support link.<br><br>
							
							To begin your application, click on the student application section above. You can fill out the application in any order
							and come back to each section at any time to add, edit or finish the application. To save your progress simply push the save button
							at the bottom of the page you have most recently worked on.<br><br>
											
							Keep in mind that if you don't access your account at least once in 30 days your application will be deleted and you 
							will have to start the entire process over. <br><br>
							<div align="center"><form action="index.cfm?curdoc=section1&id=1" method="post"><input type="image" alt="Start Application" src="pics/start-application.gif"></form></div>
						
						<cfelseif get_status.status EQ 3>
							Your application is currently being reviewed by #get_branch.businessname#.
							Your applicaiton may be denied by #get_branch.businessname# for information they feel is incomplete or missing,
							in which case you will need to provide the requestd information and resubmit the application.
						
						<cfelseif get_status.status EQ 4>
							Your application has been rejected by #get_branch.businessname#.  You may need to provide more information, please see notes on the right.
						
						<cfelseif get_status.status EQ 5>
							Your application is currently being reviewed by #get_intl_rep.businessname#.
							Your applicaiton may be denied by #get_intl_rep.businessname# for information they feel is incomplete or missing,
							in which case you will need to provide the requestd information and resubmit the application.
						
						<cfelseif get_status.status EQ 6>
							Your application has been rejected by #get_intl_rep.businessname#.  You may need to provide more information, please see notes on the right.
		
						<cfelseif get_status.status EQ 7>
							Your application has been approved by #get_intl_rep.businessname# and submitted to CASE headquarters in New York.  
							If CASE denies your application due to missing or incomplete information, it will be first sent back to #get_intl_rep.businessname# who may be able
							to provide the additional information.  If #get_intl_rep.businessname# is not able to provide it, it will be rejected back to you so you can provide
							the information and then resubmit it for processing.  
							<br><br>
							If CASE approves your application it will immediately be available for placement.
						
						    <cfelseif get_status.status EQ 8>
							Your application is under review by CASE in New York.  
							If CASE denies your application due to missing or incomplete information, it will be first sent back to #get_intl_rep.businessname# who may be able
							to provide the additional information.  If #get_intl_rep.businessname# is not able to provide it, it will be rejected back to you so you can provide
							the information and then resubmit it for processing.  
							<br><br>
							If CASE approves your application it will immediately be available for placement.
						
						    <cfelseif get_status.status EQ 9>
							CASE has denied your application.  You or #get_intl_rep.businessname# needs to provide more information. Please see details on the right.

						<cfelseif get_status.status EQ 10>
							On Hold. Your application is currently on hold. CASE will be contacting #get_intl_rep.businessname#.

						<cfelseif get_status.status EQ 11>
							<h3>Congratulations!</h3>
							Your application has been approved. Your profile and information are showing as available for placement in the region/state you requested or where assigned
							to upon acceptance of your application.  Once you are placed with a family, your host family information will be available below.
						</cfif>
						<br>
						<font size=-2>Status Last Changed: #DateFormat(get_latest_date.date, 'mm/dd/yyyy')#</font>
						</td>
					</tr>
				</table>
				<table width=100% cellpadding=0 cellspacing=0 border=0>
					<tr valign=bottom >
						<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
						<td width=100% background="../pics/header_background_footer.gif"></td>
						<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
					</tr>
				</table>
			</td>
			<td width="2%">&nbsp;</td>
			<td width="49%" valign="top">
				<!----App Status Reports---->
				<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
					<tr valign=middle height=24>
						<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
						<td width=26 background="../pics/header_background.gif"><img src="pics/sticky-active.gif"></td>
						<td background="../pics/header_background.gif"><h2>Status &nbsp; Last App Change: #DateFormat(last_change.lastchanged, 'mm/dd/yyyy')#</h2></td>
						<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
					</tr>
				</table>
				<table width=100% cellpadding=3 cellspacing=0 border=0 class="section">
					<tr>
						<td style="line-height:20px;" valign="top">
							<table width=100%>
								<tr>
									<!----Reports---->
									<td valign="top">
									<!--- 2 - Application Incomplete --->
									<cfif get_status.status EQ 2>
										<img src="pics/incomplete.gif" align="left"> In Progress - Your application has not been submitted for review.  If your application is ready to submit, click 'Submit Application to Representative' below.  To view missing items, click on <a href="?curdoc=check_list&id=cl">Check List</a> in the menu.
									<!--- 3 - Application submitted to Branch --->
									<cfelseif get_status.status EQ 3>
										<img src="pics/under_review.gif"  align="left"> Under Review - Application has been submitted to #get_branch.businessname#.  
									<!--- 4 - Application Rejected by Branch --->
									<cfelseif get_status.status EQ 4>
										<img src="pics/incomplete.gif"  align="left"> Rejected - Your application has been rejected by #get_branch.businessname#. 
									<!--- 5 - Application submitted to Intl. Rep. --->
									<cfelseif get_status.status EQ 5>
										<img src="pics/under_review.gif"  align="left"> Under Review - Application has been submitted to #get_intl_rep.businessname#.  
									<!--- 6 - Application Rejected by Intl. Rep. --->
									<cfelseif get_status.status EQ 6>
										<img src="pics/incomplete.gif"  align="left"> Rejected - Your application has been rejected by #get_intl_rep.businessname#. You may need to provide more information, please see notes on below. 
									<!--- 7 - Application submitted to SMG --->
									<cfelseif get_status.status EQ 7>
										<img src="pics/under_review.gif"  align="left"> Approved - Your application has been approved by #get_intl_rep.businessname#! 
									<!--- 8 - Application under review --->
									<cfelseif get_status.status EQ 8>
										<img src="pics/under_review.gif"  align="left"> Reviewing - Your application has been received and it's under review by SMG. 
									<!--- 9 - Application rejected by SMG --->
									<cfelseif get_status.status EQ 9>
										<img src="pics/incomplete.gif"  align="left"> Rejected - Your application has been rejected by SMG. 
									<!--- 10 - Application approved by SMG --->
									<cfelseif get_status.status EQ 10>
										<img src="pics/incomplete.gif"  align="left"> On Hold - Your application has been put on hold.
									<!--- 11 - Application approved by SMG --->
									<cfelseif get_status.status EQ 11>
										<img src="pics/approved.gif"  align="left"> Approved - Your application has been approved by SMG! SMG is in the processing of locating a host family.
									</cfif>
									<cfif get_status.reason NEQ ''><br><br>
									<table align="center" width="100%" cellpadding=0 cellspacing=0 border=0>
										<tr>
											<td valign="top"><img src="pics/error_exclamation_clear.gif"></td>
											<td width="2%">&nbsp;</td>
											<td align="left" width="100%">
												<table width=100% cellpadding=0 cellspacing=0 border=0 bgcolor=##ffffff>
													<tr valign="top">
														<td width=6 style="border-left: 1px solid ##FAF7F1;"><img src="../pics/address_topleft.gif" height=6 width=6></td>
														<td width=100% style="line-height:1px; font-size:2px; border-top: 1px solid ##557aa7;">&nbsp;</td>
														<td width=6 style="border-right: 1px solid ##557aa7;"><img src="../pics/address_topright.gif" height=6 width=6></td>
													</tr>
													<tr>
														<td width=6 style="border-left: 1px solid ##557aa7;">&nbsp;</td>
														<td width=100% style="padding:5px;">#get_status.reason#</td>
														<td width=6 style="border-right: 1px solid ##557aa7;">&nbsp;</td>
													</tr>
													<tr valign="bottom">
														<td width=6 style="border-left: 1px solid ##FAF7F1;"><img src="../pics/address_bottomleft.gif" height=6 width=6></td>
														<td width=100% style="line-height:1px; font-size:2px; border-bottom: 1px solid ##557aa7;">&nbsp;</td>
														<td width=6 style="border-right: 1px solid ##557aa7;"><img src="../pics/address_bottomright.gif" height=6 width=6></td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
									</cfif>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td><br>
							<cfif get_status.status LTE 2 OR get_status.status EQ 4 OR (get_student_info.branchid EQ '0' AND get_status.status EQ 6)>
								<div align="center"><a href="querys/check_app_before_submit.cfm"><img src="pics/submit-app.gif" border=0></a></div><br>
								<font size=-1>*<em>An initial check for required information is performed before the application is submited. This does not
								guarantee that the application will not be denied by #get_intl_rep.businessname# and more information will be requested.</em></font>
							</cfif>		
						</td>
					</tr>
				</table>
				<!----footer of table---->
				<table width=100% cellpadding=0 cellspacing=0 border=0>
					<tr valign=bottom >
						<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
						<td width=100% background="../pics/header_background_footer.gif"></td>
						<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
					</tr>
				</table><br>
				
				<cfif get_student_info.app_intl_comments NEQ ''>
					<!--- INTL. Rep. Comments --->
					<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="../pics/header_background.gif"><img src="../pics/news.gif"></td>
							<td background="../pics/header_background.gif"><h2>#get_intl_rep.businessname# Comments</td>
							<td background="../pics/header_background.gif" width=16></td>
							<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>
					<table width=100% class="section">
						<tr><td><div align="justify">#get_student_info.app_intl_comments#</div></td></tr>
					</table>
					<table width=100% cellpadding=0 cellspacing=0 border=0>
						<tr valign=bottom >
							<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
							<td width=100% background="../pics/header_background_footer.gif"></td>
							<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
						</tr>
					</table>
				</cfif>				
				</td>
			</tr>
		</table><br>
		<br>
<cfif get_intl_rep.userid NEQ 19>
		<!--- Student Profile  --->
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
				<td width=26 background="../pics/header_background.gif"><img src="../pics/news.gif"></td>
				<td background="../pics/header_background.gif"><h2>Student Profile</h2> </td><td background="../pics/header_background.gif" width=16></td>
				<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
			</tr>
		</table>
		
		<table width=100% class="section">
			<tr><td>   
			<cfif get_status.status EQ 11>
				Click here to view your general profile overview: <a href="?curdoc=profile&unqid=#get_student_info.uniqueid#" target="_top">Your Profile</a>
			<cfelse>
				Your student profile will be available here once your application is processed.
			</cfif>
			</td></tr>
		</table>
		
		<table width=100% cellpadding=0 cellspacing=0 border=0>
			<tr valign=bottom >
				<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
				<td width=100% background="../pics/header_background_footer.gif"></td>
				<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
			</tr>
		</table><br>
		
		<!--- Host Family Section --->
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
				<td width=26 background="../pics/header_background.gif"><img src="../pics/news.gif"></td>
				<td background="../pics/header_background.gif"><h2>Host Family Information </h2></td><td background="../pics/header_background.gif" width=16></td>
				<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
			</tr>
		</table>
		
		<table width=100% class="section">
			<tr>
				<td>
					<cfquery name="host_fam" datasource="caseusa">
						select hostid
						from smg_students
						where studentid = '#client.studentid#'
					</cfquery>
				
					<cfif (host_fam.recordcount EQ 0 OR get_student_info.host_fam_approved GT 4)>
						Information on your host family and location will be available here once you are assigned to a host family. <br><br>
					<cfelse>
						<cfset client.hostid = #host_fam.hostid#>
						<cfset hostid = #host_fam.hostid#>
						<img src="pics/external_link.png" border=0> indicates additional information from external site(s). <br>
						<img src="pics/sat_image.png" border=0> satalite images of area. <br>
						CASE is not responsible for information received or available from the external sites linked below.  Some links may not be valid.<br>
						<br>
					
						<!----host family info---->
						<cfinclude template="../querys/family_info.cfm">
						
						<!-----Host Children----->
						<cfquery name="host_children" datasource="caseusa">
							SELECT *
							FROM smg_host_children
							WHERE hostid = '#family_info.hostid#'
							ORDER BY birthdate
						</cfquery>
						
					<!--- REGION --->
					<cfquery name="get_region" datasource="caseusa">
						SELECT regionid, regionname
						FROM smg_regions
						WHERE regionid = '#family_info.regionid#'
					</cfquery>
					
					<!--- SCHOOL ---->
					<cfquery name="get_school" datasource="caseusa">
						SELECT schoolid, schoolname, address, city, state, begins, ends,url
						FROM smg_Schools
						WHERE schoolid = '#family_info.schoolid#'
					</cfquery>
						
					<style type="text/css">
					<!--
					div.scroll {
						height: 155px;
						width:auto;
						overflow:auto;
						border-left: 2px solid c6c6c6;
						border-right: 2px solid c6c6c6;
						background: Ffffe6;
						left:auto;
					}
					div.scroll2 {
						height: 100px;
						width:auto;
						overflow:auto;
						border-left: 2px solid c6c6c6;
						border-right: 2px solid c6c6c6;
						background: Ffffe6;
						left:auto;
					}
					-->
					</style>
						
					<table cellpadding="0" cellspacing="0" border="0" width="100%">
					<tr><td width="60%" align="left" valign="top">
							<!--- HEADER OF TABLE --- Host Family Information --->
							<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 >
								<tr valign=middle height=24>
									<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td><td width=26 background="../pics/header_background.gif"><img src="../pics/family.gif"></td>
									<td background="../pics/header_background.gif"><h2>Host Family Information</h2></td><cfif client.usertype LTE '4'><td background="../pics/header_background.gif"></td></cfif>
									<td background="../pics/header_background.gif" width=16></td><td width=17 background="../pics/header_rightcap.gif">&nbsp;</td></tr>
							</table>
							<!--- BODY OF A TABLE --->
							<table width="100%" border=0 cellpadding=3 cellspacing=0 class="section">
								<tr><td>Family Name:</td><td>#family_info.familylastname#</td><td></td><td></td></tr>
								<tr><td>Address:</td><td>#family_info.address#</td></tr>
								<tr><td>City:</td><td><a href="http://en.wikipedia.org/wiki/#family_info.city#%2C_#family_info.state#">#family_info.city# <img src="pics/external_link.png" border=0></a>  <a href="http://maps.google.com/maps?f=q&hl=en&q=#family_info.city#+#family_info.state#&btnG=Search&t=h"> <img src="pics/sat_image.png" border=0></a></td></tr>
								<tr><td>State:</td><td>
								<cfquery name="get_state_name" datasource="caseusa">
								select statename
								from smg_states
								where state='#family_info.state#'
								</cfquery>
								<a href="http://en.wikipedia.org/wiki/#get_state_name.statename#">#family_info.state# <img src="pics/external_link.png" border=0></a></td><td>ZIP:</td><td>#family_info.zip#</td></tr>
								<tr><td>Phone:</td><td>#family_info.phone#</td></tr>
								<tr><td>Email:</td><td><a href="mailto:#family_info.email#">#family_info.email#</a></td></tr>
								<tr><td>Host Father:</td><td>#family_info.fatherfirstname# #family_info.fatherlastname# &nbsp; <cfif family_info.fatherbirth is '0'><cfelse> <cfset calc_age_father = #CreateDate(family_info.fatherbirth,01,01)#> (#DateDiff('yyyy', calc_age_father, now())#) </cfif></td><td>Occupation:</td><td><cfif family_info.fatherworkposition is ''>n/a<cfelse>#family_info.fatherworkposition#</cfif></td></tr>
								<tr><td>Host Mother:</td><td>#family_info.motherfirstname# #family_info.motherlastname#  &nbsp; <cfif family_info.motherbirth is '0'><cfelse> <cfset calc_age_mom = #CreateDate(family_info.motherbirth,01,01)#> (#DateDiff('yyyy', calc_age_mom, now())#) </cfif></td><td>Occupation:</td><td><cfif family_info.motherworkposition is ''>n/a<cfelse>#family_info.motherworkposition#</cfif></td></tr>
							</table>	
							<!--- BOTTOM OF A TABLE --->
							<table width=100% cellpadding=0 cellspacing=0 border=0>
								<tr valign="bottom"><td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td><td width=100% background="../pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
							</table>		
						</td>
						<td width="2%"></td> <!--- SEPARATE TABLES --->
						<td width="38%" align="right" valign="top">
							<!--- HEADER OF TABLE --- Other Family Members --->
							<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 >
								<tr valign=middle height=24>
									<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td><td width=26 background="../pics/header_background.gif"><img src="../pics/family.gif"></td>
									<td background="../pics/header_background.gif"><h2>Other Family Members</h2></td><td background="../pics/header_background.gif" width=16><a href="?curdoc=forms/host_fam_pis_2"></a></td>
									<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td></tr>
							</table>
							<!--- BODY OF TABLE --->
							<table width="100%" border=0 cellpadding=3 cellspacing=0 class="section">
								<tr><td width="40%"><u>Name</u></td>
									<td width="20%"><u>Sex</u></td>
									<td width="20%"><u>Age</u></td>
									<td width="20%"><u>At Home</u></td></tr>
							</table>
							<div class="scroll">
							<table width=100% align="left" border=0 cellpadding=2 cellspacing=0>
								<cfloop query="host_children">
									<tr><td width="40%">#name#</td>
										<td width="20%">#sex#</td>
										<td width="20%"><cfif birthdate is ''><cfelse>#DateDiff('yyyy', birthdate, now())#</cfif></td>
										<td width="20%">#liveathome#</td></tr>
								</cfloop>
							</table>
							</div>
							<!--- BOTTOM OF A TABLE --->
							<table width=100% cellpadding=0 cellspacing=0 border=0>
								<tr valign="bottom"><td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td><td width=100% background="../pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
							</table>		
						</td></tr>
						</table><br>
						
						<table cellpadding="0" cellspacing="0" border="0" width="100%">
						<tr>
							<td width="32%" align="left" valign="top">
								<!--- HEADER OF TABLE --- COMMUNITY INFO --->
								<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
									<tr valign=middle height=24>
										<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td><td width=26 background="../pics/header_background.gif"><img src="../pics/family.gif"></td>
										<td background="../pics/header_background.gif"><h2>Community Info</h2></td><td background="../pics/header_background.gif" width=16><a href="?curdoc=forms/family_app_7_pis"></a></td>
										<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td></tr>
								</table>
								<!--- BODY OF TABLE --->
								<table width="100%" border=0 cellpadding=3 cellspacing=0 class="section">
									<tr><td></td><td colspan="3"></td></tr>
									<tr><td>Community:</td><td colspan="3"><cfif family_info.community is ''>n/a<cfelse> #family_info.community#</cfif></td></tr>
									<tr><td>Closest City:</td><td><cfif family_info.nearbigcity is ''>n/a<cfelse> <a href="http://en.wikipedia.org/wiki/#family_info.nearbigcity#">#family_info.nearbigcity# <img src="pics/external_link.png" border=0></a></cfif></td><td>Distance:</td><td>#family_info.near_City_dist# miles</td></tr>
									<tr><td>Airport Code:</td><td colspan="3"><cfif family_info.major_air_code is ''>n/a<cfelse> <a href="http://www.airnav.com/airport/K#family_info.major_air_code#" target="_top">#family_info.major_air_code# <img src="pics/external_link.png" border=0></a> <a href="http://maps.google.com/maps?f=q&hl=en&q=#family_info.major_air_code#+airport&btnG=Search&t=k&t=h"><img src=pics/sat_image.png border=0></a></cfif></td></tr>
									<tr><td>Airport City:</td><td colspan="3"><cfif family_info.airport_city is '' and family_info.airport_state is ''>n/a<cfelse><a href="http://en.wikipedia.org/wiki/#family_info.airport_city#%2C_#family_info.airport_state#">#family_info.airport_city# / #family_info.airport_state# <img src="pics/external_link.png" border=0></a> <a href="http://maps.google.com/maps?f=q&hl=en&q=#family_info.airport_city#+#family_info.airport_state#&btnG=Search&t=h"> <img src="pics/sat_image.png" border=0></a></cfif></td></tr>
									<tr><td valign="top">Interests: </td><td colspan="3"><cfif len(#family_info.pert_info#) gt '100'>#Left(family_info.pert_info,92)# <a href="?curdoc=forms/family_app_7_pis">more...</a><cfelse>#family_info.pert_info#</cfif></td></tr>
								</table>				
								<!--- BOTTOM OF A TABLE  --- COMMUNITY INFO --->
								<table width=100% cellpadding=0 cellspacing=0 border=0>
									<tr valign="bottom"><td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td><td width=100% background="../pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
								</table>				
							</td>
							<td width="2%"></td> <!--- SEPARATE TABLES --->
							<td width="28%" align="center" valign="top">
								<!--- HEADER OF TABLE --- SCHOOL --->
								<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
									<tr valign=middle height=24>
										<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td><td width=26 background="../pics/header_background.gif"><img src="../pics/school.gif"></td>
										<td background="../pics/header_background.gif"><h2>School Info</h2></td><td background="../pics/header_background.gif" width=16><a href="?curdoc=forms/host_fam_pis_5"></a></td>
										<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td></tr>
								</table>
								<!--- BODY OF TABLE --->
								<table width="100%" border=0 cellpadding=3 cellspacing=0 class="section">
									<tr><td>School:</td><td><cfif get_school.recordcount is '0'>there is no school assigned<cfelse>#get_school.schoolname#</cfif></td></tr>
									<tr><td>Address:</td><td><cfif get_school.address is ''>n/a<cfelse>#get_school.address#</cfif></td></tr>
									<tr><td>City:</td><td><cfif get_school.city is '' and get_school.state is ''>n/a<cfelse><a href="http://en.wikipedia.org/wiki/#get_school.city#%2C_#get_school.state#">#get_school.city# / #get_school.state# <img src="pics/external_link.png" border=0></a> <a href="http://maps.google.com/maps?f=q&hl=en&q=#get_school.city#+#get_school.state#&btnG=Search&t=h"> <img src=pics/sat_image.png border=0></a></cfif></td></tr>
									<tr><td>Start Date:</td><td><cfif get_school.begins is ''>n/a<cfelse>#DateFormat(get_school.begins, 'mm/dd/yyyy')#</cfif></td></tr>
									<tr><td>End Date:</td><td><cfif get_school.ends is ''>n/a<cfelse>#DateFormat(get_school.ends, 'mm/dd/yyyy')#</cfif></td></tr>			
									<tr><td>Web Site:</td><td><cfif get_school.url is ''>n/a<cfelse><a href="#get_school.url#">#get_school.url#</a></cfif></td></tr>
								</table>				
								<!--- BOTTOM OF A TABLE --- SCHOOL  --->
								<table width=100% cellpadding=0 cellspacing=0 border=0>
									<tr valign="bottom"><td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td><td width=100% background="../pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
								</table>		
							</td>
							<td width="2%"></td> <!--- SEPARATE TABLES --->
							<td width="36%" align="right" valign="top">
										<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
									<tr valign=middle height=24>
										<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td><td width=26 background="../pics/header_background.gif"></td>
										<td background="../pics/header_background.gif"><h2>Host Interests</h2></td><td background="../pics/header_background.gif" width=16><a href="?curdoc=forms/host_fam_pis_5"></a></td>
										<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td></tr>
								</table>
								<!--- BODY OF TABLE --->
								<table width="100%" border=0 cellpadding=3 cellspacing=0 class="section">
									<tr><td>
									<cfloop list="#family_info.interests#" index=i>
									<cfquery name="interest_label" datasource="caseusa">
									select interest
									from smg_interests 
									where interestid = #i#
									</cfquery>
									#interest_label.interest#<cfif #i# eq #listlast(family_info.interests)#><cfelse>,</cfif> 
									</cfloop>
									</td></tr>
								</table>				
								<!--- BOTTOM OF A TABLE --- interests  --->
								<table width=100% cellpadding=0 cellspacing=0 border=0>
									<tr valign="bottom"><td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td><td width=100% background="../pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
								</table>		
							</td>
						</tr>
						</table><br>
					</cfif>
				</td>
			</tr>
		</table>

		<table width=100% cellpadding=0 cellspacing=0 border=0>
			<tr valign=bottom >
				<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
				<td width=100% background="../pics/header_background_footer.gif"></td>
				<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
			</tr>
		</table>
<!----close tag to not show the profiles for STB---->
</cfif>

</cfif>
		</cfoutput>

		<cfcatch type="any">
			<cfinclude template="error_message.cfm">
		</cfcatch>
		</cftry>
		
		</body>
		</html>