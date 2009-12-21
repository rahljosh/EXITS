<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Resend Student Welcome Email</title>
</head>

<body>

<cftry>

	<cfoutput>
	
	<cfif NOT IsDefined('url.unqid') OR NOT IsDefined('url.status')>
		<cfinclude template="../error_message.cfm">
		<cfabort>
	</cfif>

	<cfquery name="get_student" datasource="mysql">
		SELECT firstname, familylastname, email, randid, uniqueid, intrep, branchid
		FROM smg_students
		WHERE uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
	</cfquery>

	<!--- send a copy to MAIN OFFICE OR BRANCH - IT DEPENDS WHO CREATED THE STUDENT --->
	<cfquery name="agent_info" datasource="MySQL">
		SELECT businessname, phone, email, studentcontactemail
		FROM smg_users 
		WHERE userid = <cfif get_student.branchid EQ 0>'#get_student.intrep#'<cfelse>'#get_student.branchid#'</cfif>
	</cfquery>
	<!--- MAIN OFFICE --->
	<cfif get_student.branchid EQ 0>
		<cfset int_email = '#agent_info.email#'>
	<!--- BRANCH --->
	<cfelse>
		<cfset int_email = '#agent_info.studentcontactemail#'>
	</cfif>
	
    <!----Email To be Send. nsmg cfc emal cfc---->
    
    		<cfsavecontent variable="email_message">
           			
			#get_student.firstname#-
			<br><br>
			An account has been created for you on the #client.companyname# EXITS system.  
			Using EXITS you will be able to apply for your exchange program and view the status of your application as it is processed. 
			<br><br>
			You can start your application at any time and do not need to complete it all at once.
			You can save your work at any time and return to the application when convenient.  
			The first time you access EXITS you will create a username and password that will allow you to work 
			on your application at any time. 
			<br><br>
			Please provide the information requested by the application and press the submit button when it is complete.
			Once submitted, the application can no longer be edited.  
			The completed application will be reviewed by your international representative and if accepted, sent on to there partner organization.
			The status of your application can be viewed by logging into the Exits Login Portal. 
			After your placement has been made, you will also be able to access your host family profile.
			<br><br>
			You are taking the first step in what will become one of the greatest experiences in your life!
			<br><br>
			Click the link below to start your application process.  
			<br><br>
			<a href="http://#exits_url#/nsmg/student_app/verify.cfm?s=#get_student.uniqueid#">http://#exits_url#/nsmg/student_app/verify.cfm?s=#get_student.uniqueid#</a>
			<br><br>
			You will need the following information to verify your account:<br>
			*email address<br>
			*this ID: #get_student.randid#
			<br><br>
			If you have any questions about the application or the information you need to submit, please contact:
			<br><br>
			#agent_info.businessname#<br>
			#agent_info.phone#<br>
			#agent_info.email#<br><br>
			
			For technical issues with EXITS, submit questions to the support staff via the EXITS system.
				
                <!----
				<p>To login please visit: <cfoutput><a href="#application.site_url#">#application.site_url#</a></cfoutput></p>
				---->
			</cfsavecontent>
			
			<!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#get_student.email#">
                <cfinvokeargument name="email_subject" value="Student App. Login Information">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_from" value="#client.support_email#">
            </cfinvoke>
    <!----End of Email---->
   
	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("EXITS - You have successfully resent the login information for #get_student.firstname# #get_student.familylastname#. Thank You.");
		location.replace("http://wep.exitsapplication.com/nsmg/student_app/login_information.cfm?unqid=#url.unqid#");
	-->
	</script>
	</head>
	</html> 		

	</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>	