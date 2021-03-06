<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-EQuiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="smg.css">
	<title>SMG - EXITS Online Application List</title>
</head>
<body bgcolor="#dcdcdc">

<style type="text/css">
body {font:Arial, Helvetica, sans-serif;}
.thin-border{ border: 1px solid #000000;
			  font:Arial, Helvetica, sans-serif;}
.dashed-border {border: 1px solid #FF9933;}
</style>

<cfoutput>

<cfinclude template="get_student_info.cfm">

<cfquery name="get_intl_rep" datasource="caseusa">
	SELECT businessname
	FROM smg_users
	WHERE userid = <cfqueryparam value="#get_student_info.intrep#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_branch" datasource="caseusa">
	SELECT businessname
	FROM smg_users
	WHERE userid = <cfqueryparam value="#get_student_info.branchid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfset newstatus = get_student_info.app_current_status>

<!--- NOT A BRANCH STUDENT --->
<cfif get_student_info.branchid EQ '0'>
	<cfif get_student_info.app_current_status EQ '1' OR get_student_info.app_current_status EQ '2' OR get_student_info.app_current_status EQ '6'>
		<cfset newstatus = 5> <!--- SUBMITTED TO INTL. REP ---> 
	<cfelseif get_student_info.app_current_status EQ '5' OR get_student_info.app_current_status EQ '9'>		
		<cfset newstatus = 7> <!--- APPROVED BY INTL. REP --->
	</cfif>
<!--- BRANCH STUDENT --->
<cfelse>
	<cfif get_student_info.app_current_status EQ '1' OR get_student_info.app_current_status EQ '2' OR get_student_info.app_current_status EQ '4'>
		<cfset newstatus = 3> <!--- SUBMITTED TO BRANCH ---> 
	<cfelseif get_student_info.app_current_status EQ '3' OR get_student_info.app_current_status EQ '6'>		
		<cfset newstatus = 5> <!--- APPROVED BY BRANCH --->
	<cfelseif get_student_info.app_current_status EQ '5' OR get_student_info.app_current_status EQ '9'>		
		<cfset newstatus = 7> <!--- APPROVED BY INTL. REP --->
	</cfif>
</cfif>

<cfif newstatus GT '11'>
	<cfset newstatus = '11'>
</cfif>

<br>
<table class=dashed-border align="center" width="550" bgcolor="white">
	<tr>
		<td><img src="../pics/top-email.gif" width="550" height="75"></td>
	</tr>
		<cfif client.missingitems EQ 0>
			<cfif NOT IsDefined('form.app_intl_comments')>
				<cfform name="approve" action="check_app_results.cfm" method="post">
				<tr>
					<td align="center">
						<h2>Congratulations!!!</h2>
						There are no missing items on this application.<br>
						Student: #get_student_info.firstname# #get_student_info.familylastname# <br>
						You are ready to submit this application to <cfif newstatus eq 3>#get_branch.businessname#	<cfelseif newstatus EQ 5>#get_intl_rep.businessname#<cfelse>
						CASE
						</cfif>.<br><br>
						Please use the box below to enter any comments regarding this student (optional).
					</td>
				</tr>
				<tr><td align="center"><textarea name="app_intl_comments" cols="60" rows="10">#get_student_info.app_intl_comments#</textarea></td></tr>
				<tr><td align="center">By clicking on the approve button below this application will be approved and submitted to <cfif newstatus eq 3>#get_branch.businessname#	<cfelseif newstatus EQ 5>#get_intl_rep.businessname#<cfelse>
				CASE
				</cfif>.</td></tr>
				<tr><td align="center"><input name="Submit" type="image" src="../pics/approve.gif" border=0 alt="Approve Application and Submit to SMG"></td></tr>
				<tr><td>&nbsp;</td></tr>
				</cfform>
			<cfelse>
			<tr>
				<Td>
					<cfquery name="update_app_status" datasource="caseusa">
						INSERT INTO smg_student_app_status (studentid, status, date, approvedby)
						VALUES (#client.studentid#, #newstatus#, #now()#, '#client.userid#')
					</cfquery>
					<cfquery name="update_app_status" datasource="caseusa">
						UPDATE smg_students 
						SET app_intl_comments = <cfqueryparam value="#form.app_intl_comments#" cfsqltype="cf_sql_longvarchar">,
							active = '1',
							canceldate = NULL,
							cancelreason = '', 
							dateapplication = #CreateODBCDate(now())#,
							app_current_status = #newstatus#,
							app_sent_student = #now()#
						WHERE studentid = '#get_student_info.studentid#' 
						LIMIT 1		
					</cfquery>
					<h2>Congratulations!</h2><br> 
					Your application has been approved and submitted to 
						<cfif newstatus eq 3> 
							#get_branch.businessname# 
						<cfelseif newstatus EQ 5>
							#get_intl_rep.businessname# 
						<cfelse>
						CASE
						</cfif>.<br>
					You will receive an email shortly confirming that your application has been submitted. 
					<br><br>You can check on your application by logging into <a href="http://www.case-usa.org">www.case-usa.org</a>.<br>
					<div align="center"><a href="../index.cfm">Return to Application Status</a></div>
				</td>
			</tr>
			</cfif>
		<cfelse>
		<tr>
			<td>
			<br>Unfortunatly there <cfif client.missingitems GT 1>are<cfelse>is</cfif> #client.missingitems# missing item(s) on your application that need to be filled out before you can 
			submit your application.<br><br>
			Once you have filled out these items, please submit your application for processing again. 
			<br><br>
			<div align="center">
			<a href="../index.cfm?curdoc=check_list&id=cl"><img src="../pics/view-missing.gif" alt="View Missing Items" border=0></a>
			</div>
			</td>
		</tr>
		</cfif>
</table>
</cfoutput>

</body>
</html>