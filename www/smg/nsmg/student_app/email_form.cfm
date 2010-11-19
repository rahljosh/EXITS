<!--- ------------------------------------------------------------------------- ----
	
	File:		email_form.cfm
	Author:		Marcus Melo
	Date:		October 07, 2009
	Desc:		Sends App Online Email

	Updated: 	10/13/2009 - Removing SMG from email subject.

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <!--- Param Variables --->
    <cfparam name="URL.userID" default="0">
    
    <cfparam name="URL.email" default="">
	<cfparam name="URL.unqid" default="">
       
    <cfparam name="CLIENT.exits_url" default="https://ise.exitsapplication.com">
    <cfparam name="CLIENT.companyID" default="5">
    <cfparam name="CLIENT.companyName" default="International Student Exchange">
    <cfparam name="CLIENT.companyShort" default="ise">
    <cfparam name="CLIENT.support_email" default="support@student-management.com">
    <cfparam name="CLIENT.email" default="support@student-management.com">
    
    <cfparam name="FORM.submitted" default="0">
	<cfparam name="FORM.studentID" default="0">
    <cfparam name="FORM.email_address" default="">

    <cfscript>
		// Opening from PHP - AXIS
		if ( VAL(URL.userID) ) {
			// Set PHP Variables
			CLIENT.userID = userID;
			CLIENT.companyName = "Private High School Program";
			CLIENT.companyShort = "php";
			CLIENT.exits_url = "http://php.exitsapplication.com";
			CLIENT.companyID = 6;
		}
		
		// PHP Users - client variables are not defined. Use URL
		if ( LEN(URL.email) ) {
			emailFrom = URL.email;	
		} else if ( LEN(CLIENT.support_email) ) {
			emailFrom = CLIENT.support_email;	
		} else if ( LEN(CLIENT.email) ) {
			emailFrom = CLIENT.email;	
		}	
	</cfscript>


    <cfparam name="url.test" default="0">
    
    <cfif val(url.test)>
        <cfdump var="#client#">
        <cfabort>
    </cfif>


    <cfquery name="get_student_info" datasource="MySql">
        SELECT 
            s.firstname, 
            s.familylastname, 
            s.studentid, 
            s.uniqueid,
            u.businessname
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_users u ON u.userID = s.intrep
        WHERE 
        <cfif LEN(URL.unqID)>	
            s.uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.unqid#">
        <cfelse>
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentid#">
        </cfif>
    </cfquery>

	<!--- Used in the email --->
    <cfquery name="get_current_user" datasource="MySql">
        SELECT 
            userid, 
            firstname, 
            lastname, 
            email
        FROM 
            smg_users
        WHERE 
            userid = <cfqueryparam value="#userID#" cfsqltype="cf_sql_integer">
    </cfquery>

	<!--- FORM submitted --->
    <cfif VAL(FORM.submitted) AND LEN(FORM.email_address)>
            
        <cfoutput>
           
            <cfsavecontent variable="email_message">
                Dear Friend,<br><br>
                
                A new EXITS online student has been sent to you from #get_current_user.firstname# #get_current_user.lastname#.<br><br>	
                <b>Student: #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)</b><br><br>
                
                Additional Comments:<br>
                <cfif FORM.comments EQ ''>n/a<cfelse>#FORM.comments#</cfif><br><br>
                Please click <a href="#client.exits_url#/exits_app.cfm?unqid=#get_student_info.uniqueid#">here</a>
                to see the student's online application.<br><br>
                
                Please keep in mind that this application might take a few minutes to load completely. The loading time will depend on your internet connection.<br><br>             
                 Sincerely,<br>
                #CLIENT.companyname#<br><br>
            </cfsavecontent>
        
        </cfoutput>
                
        <!--- send email --->
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#FORM.email_address#">
            <cfinvokeargument name="email_subject" value="EXITS Online Application for #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)">
            <cfinvokeargument name="email_message" value="#email_message#">
            <cfinvokeargument name="email_from" value="#LCase(CLIENT.companyShort)#-support@exitsapplication.com">
        </cfinvoke>
       
    </cfif>

</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" type="text/css" href="../smg.css">
<title>Email Feature</title>
</head>

<script language="JavaScript"> 
	<!--// 
	 function CheckEmail() {
	 if (document.send_email.email_address.value == '') {
	   alert("You must enter at least one e-mail address");
	   document.send_email.email_address.focus(); 
	   return false; } 
	  }
	//-->
</script> 

<!--- FORM submitted - Close window ---->
<cfif VAL(FORM.submitted)>

	<script language="JavaScript">
    <!-- 
        alert("You have successfully sent this application. This window will be closed automatically. Thank You.");
        setTimeout(window.close(), 5)
        //window.close();
    -->
    </script>
	
    <cfabort>
</cfif>

<body>

<cfif NOT LEN(URL.unqid)>
	<cfinclude template="error_message.cfm">
</cfif>

<cfoutput>

<table width=430 cellpadding=0 cellspacing=0 border=0>
<tr><td>

	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
			<td background="pics/header_background.gif"><h2>Emailing EXITS Online Application</h2></td>
			<td background="pics/header_background.gif" align="right">
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>	

	<cfform action="#cgi.SCRIPT_NAME#" name="send_email" method="post" onSubmit="return CheckEmail();">
	<cfinput type="hidden" name="submitted" value="1">
    <cfinput type="hidden" name="studentID" value="#get_student_info.studentID#">
	<cfinput type="hidden" name="userID" value="#CLIENT.userID#">
	
	<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
		<tr>	
			<td colspan="2"><div align="justify"><br>
				This screen allows you to send automated emails that contain a link to the complete EXITS application to potential host families, 
				schools, reps or anyone interested in this student.
				In order to send e-mails just complete the boxes below and click on the send button.
				</div><br>
			</td>
		</tr>
		<tr>	
			<td colspan="2"><b>Student: #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentID#)</b></td>
		</tr>
		<tr>	
			<td colspan="2">Please enter e-mails on the box below.<br></td>
		</tr>
		<tr>	
			<td colspan="2">
				<cfinput type="text" name="email_address" message="Please enter one valid email address." validateat="onSubmit" validate="email" size="55">
			</td>
		</tr>
		<tr>	
			<td colspan="2">Comments: (optional)</td>
		</tr>	
		<tr>	
			<td colspan="2"><textarea name="comments" rows="3" cols="45"></textarea></td>
		</tr>
		<tr>	
			<td align="right" width="50%"><input name="Submit" type="image" src="../pics/submit.gif" border=0 alt=" Send Email ">&nbsp </cfform></td>
			<td align="left" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif" alt=" Close this Screen " onClick="javascript:window.close()"></td>
		</tr>	
	</table>
	
	<cfinclude template="../table_footer.cfm">

</td></tr>
</table>

</cfoutput>

</body>
</html>