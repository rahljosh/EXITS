<!----
<cftry>
---->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Login Information</title>
</head>
<body>

<cfif IsDefined('url.unqid')>
	<cfquery name="get_student_info" datasource="MySql">
		SELECT s.*, u.businessname
		FROM smg_students s
		LEFT JOIN smg_users u ON u.userid = s.intrep
		WHERE s.uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
	</cfquery>
	<cfset client.studentid = '#get_student_info.studentid#'>
<cfelseif IsDefined('form.unqid')>
	<cfquery name="get_student_info" datasource="MySql">
		SELECT s.*, u.businessname
		FROM smg_students s
		LEFT JOIN smg_users u ON u.userid = s.intrep
		WHERE s.uniqueid = <cfqueryparam value="#form.unqid#" cfsqltype="cf_sql_char">
	</cfquery>
	<cfset client.studentid = '#get_student_info.studentid#'>
<cfelse>
	<cfinclude template="error_message.cfm">
</cfif>

<cfoutput>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="pics/students.gif"></td>
		<td class="tablecenter"><h2>Login Information</h2></td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>	

<div class="section"><br>

<cfif NOT IsDefined('form.unqid')>
	<table width="450" border=0 cellpadding=3 cellspacing=0 align="center" bgcolor="##ffffff">
		<cfform name="login_info" action="login_information.cfm">
		<cfinput type="hidden" name="unqid" value="#get_student_info.uniqueid#">
		<tr><th colspan="2">Student : #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)</th></tr>
		<!--- ACCOUNT IS NOT ACTIVE --->
		<cfif get_student_info.email NEQ '' AND get_student_info.app_current_status EQ 1>
		<tr><td colspan="2"><font size=-2>Student is not active - <a href="querys/resend_welcome_student.cfm?unqid=#get_student_info.uniqueid#&status=#get_student_info.app_current_status#">Resend Welcome email</A></font></td>
		<tr><td width="25%">Email (username) :</td><td>#get_student_info.email#</td></tr>	
		<tr><td colspan="2">* Email address can be changed on page 1 of the online application.</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" align="center"><a href="" onClick="javascript:window.close()"><img src="pics/close.gif" border="0"></a></td></tr>
		<!--- INTL. REP IS FILLING IT OUT --->
		<cfelseif get_student_info.app_current_status EQ 5 OR get_student_info.password EQ ''>		
		<tr><td colspan="2">#get_student_info.businessname# is filling out this application. <br> No login was created for this student.</td></td></tr>	
		<tr><td colspan="2">If you would like to create a login for this student please fill out the forms below.</td></td></tr>	
		<tr><td width="25%">Email (username) :</td><td><cfinput type="text" name="email" size="30" value="#get_student_info.email#" required="yes" message="Oops! Email is required and can not be blank, please enter a valid email." maxlength="50" validate="email" validateat="onserver,onsubmit"></td></tr>	
		<tr><td>Password :</td><td><cfinput type="text" name="password" size="20" value="#get_student_info.password#" required="yes" message="Password is required and can not be blank." maxlength="10"></td></tr>
		<tr><td colspan="2"><font size="-2">*Password must be at least 6 characters.</font></td></tr>				
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" align="center"><cfinput name="Submit" type="image" src="pics/save.gif" border=0 alt="Update"> &nbsp; &nbsp; &nbsp; &nbsp; <a href="" onClick="javascript:window.close()"><img src="pics/close.gif" border="0"></a></td></tr>
		<!--- LOGIN INFORMATION --->
		<cfelse>
		<tr><td width="25%">Email (username) :</td><td><cfinput type="text" name="email" size="30" value="#get_student_info.email#" required="yes" message="Oops! Email is required and can not be blank, please enter a valid email." maxlength="50" validate="email" validateat="onserver,onsubmit"></td></tr>	
		<tr><td>Password :</td><td><cfinput type="text" name="password" size="20" value="#get_student_info.password#" required="yes" message="Password is required and can not be blank." maxlength="100"></td></tr>
		<tr><td colspan="2"><font size="-2">*Password must be at least 6 characters.</font></td></tr>				
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" align="center"><cfinput name="Submit" type="image" src="pics/save.gif" border=0 alt="Update"> &nbsp; &nbsp; &nbsp; &nbsp; <a href="" onClick="javascript:window.close()"><img src="pics/close.gif" border="0"></a></td></tr>
		</cfif>
		</cfform>
        
         <cfif url.status neq 1>
	<tr>
		<td colspan=2 align="center"><a href="resend_student_login.cfm?unqid=#get_student_info.uniqueid#">Resend Login Info</a> - (if you changed the info, click save before clicking resend)</td>
	</tr>
    	<cfelse>
        <tr><td colspan="2"><font size=-2>Student is not active - <a href="index.cfm?curdoc=student_app/querys/resend_welcome_student&unqid=#get_student_info.uniqueid#">Resend Welcome email</A></font></td>
        </tr>
    	</cfif>
        

	</table>		
<cfelseif form.email EQ '' OR form.password EQ ''>
	<table width="450" border=0 cellpadding=3 cellspacing=0 align="center">
		<cfform name="login_info" action="login_information.cfm?status=#get_student_info.app_current_status#">
		<cfinput type="hidden" name="unqid" value="#get_student_info.uniqueid#">
		<tr><th colspan="2">Student : #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)</th></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2"><font color="##FF0000">Email and Password must not be blank. Please enter the required information.</font></td></tr>
		<!--- ACCOUNT IS NOT ACTIVE --->
		<cfif get_student_info.email NEQ '' AND get_student_info.app_current_status EQ 1>
		<tr><td colspan="2"><font size=-2>Student is not active - <a href="index.cfm?curdoc=student_app/querys/resend_welcome_student&unqid=#get_student_info.uniqueid#">Resend Welcome email</A></font></td>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" align="center"><a href="" onClick="javascript:window.close()"><img src="pics/close.gif" border="0"></a></td></tr>						
		<!--- INTL. REP IS FILLING IT OUT --->
		<cfelseif get_student_info.app_current_status EQ 5 OR get_student_info.password EQ ''>		
		<tr><td colspan="2">#get_student_info.businessname# is filling out this application. <br> No login was created for this student.</td></td></tr>	
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" align="center"><a href="" onClick="javascript:window.close()"><img src="pics/close.gif" border="0"></a></td></tr>				
		<!--- LOGIN INFORMATION --->
		<cfelse>
		<tr><td width="25%">Email (username) :</td><td><cfinput type="text" name="email" size="30" value="#get_student_info.email#" required="yes" message="Oops! Email is required and can not be blank or please enter a valid email." maxlength="50" validate="email"></td></tr>	
		<tr><td>Password :</td><td><cfinput type="text" name="password" size="20" value="#get_student_info.password#" required="yes" message="Password is required and can not be blank." maxlength="10"></td></tr>
		<tr><td colspan="2"><font size="-2">*Password must be at least 6 characters.</font></td></tr>		
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" align="center"><cfinput name="Submit" type="image" src="pics/save.gif" border=0 alt="Update"> &nbsp; &nbsp; &nbsp; &nbsp; <a href="" onClick="javascript:window.close()"><img src="pics/close.gif" border="0"></a></td></tr>				
		</cfif>
		</cfform>
       <cfif url.status neq 1>
	<tr>
		<td colspan=2 align="center"><a href="resend_student_login.cfm?unqid=#get_student_info.uniqueid#">Resend Login Info</a> - (if you changed the info, click save before clicking resend)</td>
	</tr>
    	<cfelse>
        <tr><td colspan="2"><font size=-2>Student is not active - <a href="index.cfm?curdoc=student_app/querys/resend_welcome_student&unqid=#get_student_info.uniqueid#">Resend Welcome email</A></font></td>
        </tr>
    	</cfif>
	</table>
<cfelse>

	<cfquery name="get_student_info" datasource="MySql">
		SELECT *
		FROM smg_students
		WHERE uniqueid = <cfqueryparam value="#form.unqid#" cfsqltype="cf_sql_char">
	</cfquery>
	<cfquery name="check_username" datasource="MySql">
		SELECT email
		FROM smg_students
		WHERE email = '#form.email#'
		AND studentid != '#get_student_info.studentid#'
	</cfquery>
	<cfif check_username.recordcount NEQ '0'>
		<table width="450" border=0 cellpadding=3 cellspacing=0 align="center">
			<tr><th>Student : #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)</th></tr>
			<tr><td align="center">Sorry, the e-mail address <b>#form.email#</b> is being used by another account.<br></td></tr>
			<tr><td align="center">Please go back and enter a new e-mail address.<br><br><br>
					<div align="center"><input name="back" type="image" src="pics/back.gif" align="middle" border=0 onClick="history.back()"></div><br></td></tr>
		</table>		
		</div>
		<!--- FOOTER OF TABLE --->
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr height="8">
				<td width="8"><img src="pics/p_bottonleft.gif" width="8"></td>
				<td width="100%" class="tablebotton"><img src="pics/p_spacer.gif"></td>
				<td width="42"><img src="pics/p_bottonright.gif" width="42"></td>
			</tr>
		</table>		
		<cfabort>
	<cfelseif len(form.password) LTE 5>
		<table width="450" border=0 cellpadding=3 cellspacing=0 align="center">
			<tr><th>Student : #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)</th></tr>
			<tr><td align="center">Sorry, password must be at least 6 characters.<br></td></tr>
			<tr><td align="center">Please go back and enter a new password.<br><br><br>
					<div align="center"><input name="back" type="image" src="pics/back.gif" align="middle" border=0 onClick="history.back()"></div><br></td></tr>
		</table>		
		</div>
		<!--- FOOTER OF TABLE --->
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr height="8">
				<td width="8"><img src="pics/p_bottonleft.gif" width="8"></td>
				<td width="100%" class="tablebotton"><img src="pics/p_spacer.gif"></td>
				<td width="42"><img src="pics/p_bottonright.gif" width="42"></td>
			</tr>
		</table>		
		<cfabort>
	</cfif>

	<cfquery name="update_student" datasource="MySql">
		UPDATE smg_students
		SET	email = <cfqueryparam value="#form.email#" cfsqltype="cf_sql_char">,
			password = <cfqueryparam value="#form.password#" cfsqltype="cf_sql_char">
	 	WHERE studentid = '#get_student_info.studentid#'
		LIMIT 1
	</cfquery>

	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated #get_student_info.familylastname#'s login information. Thank You.");
		location.replace("login_information.cfm?unqid=#get_student_info.uniqueid#");
	-->
	</script>
	</head>
	</html>
</cfif>		
<br>
</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="pics/p_spacer.gif"></td>
		<td width="42"><img src="pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

</cfoutput> 		

</body>
</html>
<!----
<cfcatch type="any">
	<cfinclude template="error_message.cfm">
</cfcatch>
</cftry>
---->