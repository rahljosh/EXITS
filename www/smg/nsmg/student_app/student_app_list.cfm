<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-EQuiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="smg.css">
	<title>EXITS Online Application List</title>
</head>
<body>

<script language="JavaScript" type="text/JavaScript">
<!--
var newwindow;
function OpenApp(url)
{
	newwindow=window.open(url, 'Application', 'height=580, width=790, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
function LoginInfo(url)
{
	newwindow=window.open(url, 'logininfo', 'height=310, width=630, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
function AppReceived(url)
{
	newwindow=window.open(url, 'logininfo', 'height=200, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script>

<cfquery name="students" datasource="MySQL">
	SELECT  s.studentid, s.familylastname, s.uniqueid, s.firstname, s.email, s.phone, s.sex, s.lastchanged, s.app_sent_student, 
		s.branchid, s.application_expires, s.password,
		u.businessname, 
		c.companyshort,
		branch.businessname as branchname
	FROM smg_students s 
	LEFT JOIN smg_users u ON u.userid = s.intrep
	LEFT JOIN smg_companies c ON c.companyid = s.companyid
	LEFT JOIN smg_users branch ON branch.userid = s.branchid
	LEFT JOIN smg_users office ON office.userid = s.intrep
	WHERE s.randid != '0'
		<cfif url.status NEQ '4' AND url.status NEQ '6' AND url.status NEQ '9'>AND s.active = '1'</cfif>
		AND (app_current_status = <cfqueryparam value="#url.status#" cfsqltype="cf_sql_integer"> <cfif client.usertype NEQ '11'> <cfif url.status EQ '2'> OR app_current_status = '3' OR app_current_status = '4' </cfif> </cfif> )
 		<cfif IsDefined('url.intrep')>AND s.intrep = '#url.intrep#'</cfif>
		<!--- Intl. Rep  / EF Central Office --->
		<cfif IsDefined('url.ef') AND client.usertype EQ '8'>
			AND office.master_accountid = '#client.userid#'
			AND u.userid != '#client.userid#'
		<cfelseif client.usertype EQ '8'>
			AND s.intrep = '#client.userid#'
		<cfelseif client.usertype EQ '11'>
			AND s.branchid = '#client.userid#'
		</cfif>
        <cfif client.companyid gt 5>AND s.companyid = #client.companyid#</cfif>
	GROUP BY s.app_sent_student, s.studentid
</cfquery>

<h2>
<cfif url.status EQ 1>
	Access has been sent to these students, they have not followed the link to activate their account.
<cfelseif url.status EQ 2>
	These students have activated their accounts and are working on their applications.
<cfelseif url.status EQ 25>
	These students have active applications, but won't be applying to programs until a future date.
<cfelseif url.status EQ 3>
	These applications are waiting for <cfif client.usertype EQ '11'>your<cfelse>the branch</cfif> approval.
<cfelseif url.status EQ 4>
	These applications have been rejected by <cfif client.usertype EQ '11'>you<cfelse>the branch</cfif>.
<cfelseif url.status EQ 5>
	These applications are waiting for <cfif client.usertype EQ 8>your<cfelse>the international rep</cfif> approval.
<cfelseif url.status EQ 6>
	These applications have been rejected by <cfif client.usertype EQ 8>you<cfelse>the international rep</cfif>.
<cfelseif url.status EQ 7>
	These applications have been approved by <cfif client.usertype EQ 8>you<cfelse>the international rep</cfif> and are waiting for SMG.
<cfelseif url.status EQ 8>
	These applications have been approved by <cfif client.usertype EQ 8>you<cfelse>the international rep</cfif> and are waiting for the SMG approval.
<cfelseif url.status EQ 9>
	These applications have been rejected by SMG.
<cfelseif url.status EQ 10>
	These applications have been approved by SMG.	
</cfif>
</h2>

<cfif client.usertype GTE 5 OR (url.status neq 7 and url.status neq 8)>
	<br>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
			<td background="pics/header_background.gif"><h2><cfoutput>Total of #students.recordcount# Student(s)</cfoutput></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	
	<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td><b>ID</b></td>
			<td><b>Last Name</b></td>
			<td><b>First Name</b></td>
			<td><b>Sex</b></td>
			<td><b>Email</b></td>
			<td><b>Login</b></td>
         <!---- <Cfif url.status is 2 or url.status gte 7><td><b>Future</b></td></Cfif> ---->
			<cfif client.usertype GTE 5>
				<td><b>Phone</b></td>
			</cfif>
			<td><b>App Sent</b></td>
			<cfif client.usertype EQ '8'>
			<td><b>Created by</b></td>
			</cfif>
			<cfif client.usertype LTE 4>
			<td><b>Intl. Rep.</b></td>
			</cfif>
			<td><b>Last Edit</b></td>
			<cfif url.status LTE 5 OR url.status EQ 6 OR url.status EQ 9>
				<td><!--- inactivate --->&nbsp;</td>
			</cfif>
			<cfif (url.status EQ 7 OR url.status EQ 10) AND client.usertype LTE 4>
			<td><b>Company</b></td>
			<td><b>Cover Page</b></td>
			</cfif>
		</tr>
	<cfoutput query="students">
	<cfquery name="chck_int_agent_imput" datasource="MySQL">
		select studentid, status
		from smg_student_app_status
		where status = 1 and studentid = '#studentid#'
	</cfquery>
	<cfif students.recordcount NEQ '0' AND chck_int_agent_imput.recordcount EQ '0' AND client.usertype GTE '5'>
		<tr bgcolor="##e2efc7">
	<cfelseif (students.application_expires lt #now()# and url.status lte 2)>
		<tr bgcolor="##EEDFE1">
	<cfelse>
		<tr bgcolor="#iif(students.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
	</cfif>
			<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#studentid#</a></td>
			<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#familylastname#</a></td>
			<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#firstname#</a></td>
			<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#sex#</a></td>
			<td>#email# 
				<cfif email NEQ '' AND url.status EQ 1>
					<font size=-2><a href="index.cfm?curdoc=student_app/querys/resend_welcome_student&unqid=#uniqueid#&status=#url.status#">Resend Welcome email</A></font>
				</cfif>
			</td>
			<td align="center"><a href="javascript:LoginInfo('student_app/login_information.cfm?unqid=#uniqueid#&status=#url.status#');"><img src="student_app/pics/info.gif" border="0" alt="Login Information"></a></td>
        <!----  <Cfif url.status is 2 or url.status gte 7><td><a href="student_app/change_future.cfm?studentid=#studentid#&status=#url.status#" >Change</a></td></cfif>---->
			<cfif client.usertype GTE 5>
				<td>#phone#</td>
			</cfif>
			<td>#DateFormat(app_sent_student, 'mm/dd/yyyy')#</td>
			<cfif client.usertype EQ '8'>
			<td>
				<cfif IsDefined('url.ef')> <!--- EF CENTRAL OFFICE --->
					#businessname#
				<cfelseif branchid EQ '0'>
					Main Office
				<cfelse>
					#branchname#
				</cfif> 
			</td>
			</cfif>		
			<cfif client.usertype LTE 4>
			<td>#businessname#</td>
			</cfif>		
			<cfif url.status lt 10><td>#DateFormat(lastchanged, 'mm/dd/yyyy')# @ #TimeFormat(lastchanged, 'h:mm:ss tt')#</td></cfif>
			<cfif url.status LTE 5 OR url.status EQ 6 OR url.status EQ 9> <!--- inactivate application --->
				<td>
					<cfform name="inactive_#studentid#" action="?curdoc=student_app/querys/qr_inactivate_student" method="post" onsubmit="return confirm ('You are about to inactivate student #firstname# #familylastname# (###studentid#). You will no longer have access to this application. Please click OK to confirm.')">
						<cfinput type="hidden" name="studentid" value="#studentid#">
						<cfinput type="hidden" name="status" value="#url.status#">
						<cfinput type="image" name="submit" src="student_app/pics/delete.gif">
					</cfform>
				</td>
			</cfif>
			<cfif (url.status EQ 7 OR url.status EQ 10 OR url.status EQ 11) AND client.usertype LTE 4>
			<td>#companyshort#</td>
			<td><a href="javascript:OpenApp('student_app/cover_page.cfm?unqid=#uniqueid#');">Cover Page</a></td>
			</cfif> 
		</tr>
	</cfoutput>
	<tr>
		<Td></Td>
	</tr>
	<cfif students.recordcount NEQ '0' AND chck_int_agent_imput.recordcount EQ '0' AND client.usertype GTE '5'>
	<tr bgcolor="#e2efc7">
		<td colspan=11>Students highlighted in green are applications you are filling / filled out on behalf of the student.</td>
	</tr>
	</cfif>
	
	<cfif url.status LTE 2>
	<tr bgcolor="#EEDFE1">
		<td colspan=11>Students highlighted in this color have expired.  Click the name to extend the deadline.</td></td>
	</tr>
	</cfif>
	</table>
	
	<cfinclude template="../table_footer.cfm">
</cfif>

<!--- SMG OFFICE - NEEDS TO BE PRINTED - STATUS = 7 --->
<cfif client.usertype LTE 4 AND url.status EQ 7>
	<cfoutput>

	<SCRIPT>
	<!--
	function areYouSure() { 
	   if(confirm("Please click OK if this application has been printed correctly.")) { 
		 form.submit(); 
			return true; 
	   } else { 
			return false; 
	   } 
	} 
	//-->
	</script>
	<br>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
			<td background="pics/header_background.gif"><h2>Students </td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>

	<cfquery name="students_7" datasource="MySQL">
		SELECT  s.studentid, s.familylastname, s.uniqueid, s.firstname, s.email, s.phone, s.sex, s.lastchanged, s.app_sent_student, 
			s.branchid, s.application_expires, s.password,
			u.businessname, 
			c.companyshort,
			branch.businessname as branchname
		FROM smg_students s 
		LEFT JOIN smg_users u ON u.userid = s.intrep
		LEFT JOIN smg_companies c ON c.companyid = s.companyid
		LEFT JOIN smg_users branch ON branch.userid = s.branchid
		WHERE s.active = '1'
			AND s.randid != '0'
			AND app_current_status = '7'
			<cfif IsDefined('url.intrep')>AND s.intrep = '#url.intrep#'</cfif>
		GROUP BY s.app_sent_student, s.studentid
	</cfquery>	

		<!--- WAITING TO BE PRINTED / RECEIVED - STATUS 7 --->
		<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">	
		<tr><th colspan="11" bgcolor="e2efc7">#students_7.recordcount# &nbsp; APPLICATION(S) TO BE PRINTED / RECEIVED</th></tr>
		<tr>
			<td><b>ID</b></td>
			<td><b>Last Name</b></td>
			<td><b>First Name</b></td>
			<td><b>Sex</b></td>
			<td><b>Email</b></td>
            <td><b>Login</b></td>
            <td><b>Future</b></td>
			<td><b>App Received</b></td>
			<td><b>Intl. Rep.</b></td>
			<td><b>Cover Page</b></td>
			<td><b>Confirm Receipt</b></td>
		</tr>
		<cfloop query="students_7">
			<tr bgcolor="#iif(students_7.currentrow MOD 2 ,DE("FFFFFF") ,DE("e2efc7") )#">
				<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#studentid#</a></td>
				<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#familylastname#</a></td>
				<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#firstname#</a></td>
				<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#sex#</a></td>
				<td>#email#</td>
                
				<td align="center"><a href="javascript:LoginInfo('student_app/login_information.cfm?unqid=#uniqueid#&status=#url.status#');"><img src="student_app/pics/info.gif" border="0" alt="Login Information"></a></td>
                <td><a href="student_app/change_future.cfm?studentid=#studentid#&status=#url.status#" >Change</a></td>
				<td>#DateFormat(app_sent_student, 'mm/dd/yyyy')#</td>
				<td>#businessname#</td>
				<td><a href="javascript:OpenApp('student_app/cover_page.cfm?unqid=#uniqueid#');">Page</a></td>
				<td><a href="javascript:AppReceived('student_app/querys/qr_app_received.cfm?unqid=#uniqueid#&status=#url.status#');" onClick="return areYouSure(this);">Check</a></td>
			</tr>
		</cfloop>
		<tr><td colspan="11">&nbsp;</td></tr>
	</table>
	</cfoutput>

	<cfinclude template="../table_footer.cfm">
</cfif>

<!--- SMG OFFICE - RECEIVED APPLICATIONS - WAITING APPROVAL - STATUS = 8 --->
<cfif client.usertype LTE 4 AND url.status EQ 8>
	<cfoutput>
	<br>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
			<td background="pics/header_background.gif"><h2>Students</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>

	<cfquery name="students_8" datasource="MySQL">
		SELECT  s.studentid, s.familylastname, s.uniqueid, s.firstname, s.email, s.phone, s.sex, s.lastchanged, s.app_sent_student, 
			s.branchid, s.application_expires, s.password,
			u.businessname, 
			c.companyshort,
			branch.businessname as branchname
		FROM smg_students s 
		LEFT JOIN smg_users u ON u.userid = s.intrep
		LEFT JOIN smg_companies c ON c.companyid = s.companyid
		LEFT JOIN smg_users branch ON branch.userid = s.branchid
		WHERE s.active = '1'
			AND s.randid != '0'
			AND app_current_status = '8'
			<cfif IsDefined('url.intrep')>AND s.intrep = '#url.intrep#'</cfif>
		GROUP BY s.app_sent_student, s.studentid
	</cfquery>

	<!--- WAITING TO BE APPROVED - STATUS 8 --->
	<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">	
		<tr><th colspan="11" bgcolor="e2efc7">#students_8.recordcount# &nbsp; ONLINE APPLICATION(S) TO BE APPROVED</th></tr>
		<tr>
			<td><b>ID</b></td>
			<td><b>Last Name</b></td>
			<td><b>First Name</b></td>
			<td><b>Sex</b></td>
			<td><b>Email</b></td>
			<td><b>Login</b></td>
            <td><b>Future</b></td>
			<td><b>App Submitted</b></td>
			<td><b>Intl. Rep.</b></td>
			<td><b>Cover Page</b></td>
		</tr>
		<cfloop query="students_8">
			<tr bgcolor="#iif(students_8.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
				<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#studentid#</a></td>
				<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#familylastname#</a></td>
				<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#firstname#</a></td>
				<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#sex#</a></td>
				<td>#email#</td>
				<td align="center"><a href="javascript:LoginInfo('student_app/login_information.cfm?unqid=#uniqueid#&status=#url.status#');"><img src="student_app/pics/info.gif" border="0" alt="Login Information"></a></td>
                <td><a href="student_app/change_future.cfm?studentid=#studentid#&status=#url.status#" >Change</a></td>
				<td>#DateFormat(app_sent_student, 'mm/dd/yyyy')#</td>
				<td>#businessname#</td>
				<td><a href="javascript:OpenApp('student_app/cover_page.cfm?unqid=#uniqueid#');">Page</a></td>
			</tr>
		</cfloop>
		<tr><td colspan="11">&nbsp;</td></tr>		
	</table>
	</cfoutput>
	
	<cfinclude template="../table_footer.cfm">
</cfif>

</body>
</html>