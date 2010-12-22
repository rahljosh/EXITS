<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="reports.css" type="text/css">
<title>Student ID Card</title>
</head>

<body>
<cfparam name="form.emailToSelf" default="0">
<cfparam name="form.emailToIntrep" default="0">
<cfif Isdefined('url.studentid')>
	<cfset form.studentid = '#url.studentid#'>
<cfelseif NOT IsDefined('form.studentid')>
	<table width="650" align="center" class="nav_bar" bordercolor="C0C0C0" cellpadding="3" cellspacing="1">
		<tr>
		  <td bgcolor="ACB9CD">An error has occurred. Please try again.</td></tr>
		<tr><td align="center" bgcolor="ACB9CD"><input type="image" value="back" src="../pics/back.gif" onClick="javascript:history.back()"></td></tr>
	</table>
	<cfabort>
</cfif>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_student_info" datasource="mysql">
	SELECT s.studentid, s.familylastname, s.address, s.address2, s.city, s.zip, s.hostid, s.doubleplace, s.familylastname, s.firstname, s.ds2019_no,
			s.arearepid, s.regionassigned, s.programid, s.intrep,
			c.countryname,
			p.startdate
	FROM smg_students s
	INNER JOIN smg_countrylist c ON c.countryid = s.countryresident
	INNER JOIN smg_programs p ON p.programid = s.programid
	WHERE s.studentid = '#form.studentid#'
</cfquery>

<!--- Double Placement Student --->
<cfquery name="double_placement" datasource="MySQL">
	SELECT s.firstname, s.familylastname, s.ds2019_no,
			c.countryname,
			p.startdate
	FROM smg_students s
	INNER JOIN smg_countrylist c ON c.countryid = s.countryresident
	INNER JOIN smg_programs p ON p.programid = s.programid
	WHERE s.studentid = #get_student_info.doubleplace#
</cfquery>

<!-----Intl. Agent----->
<cfquery name="GetIntlReps" datasource="MySQL">
	SELECT companyid, businessname, fax, email, firstname, lastname, businessphone
	FROM smg_users 
	WHERE userid = '#get_Student_info.intrep#'
</cfquery>

<cfquery name="get_current_user" datasource="MySql">
	SELECT email, firstname, lastname
	FROM smg_users
	WHERE userid = '#client.userid#'
</cfquery>

<!-----Regions----->
<cfquery name="get_facilitator" datasource="MySQL">
	SELECT regionname, regionfacilitator,
		u.firstname, u.lastname, u.email
	FROM smg_regions
	INNER JOIN smg_users u ON u.userid = regionfacilitator
	WHERE regionid = '#get_Student_info.regionassigned#'
</cfquery>

<cfoutput>

<!--- FORM EMAIL --->
<cfif NOT IsDefined('form.send')>

<cfform name="email" action="emailStudentIDCard.cfm?studentid=#url.studentid#" method="post" onsubmit="return confirm ('Are you sure?')">
<cfinput type="hidden" name="studentid" value="#form.studentid#">
<cfinput type="hidden" name="send">
<table width="650" align="center" class="nav_bar" bordercolor="C0C0C0" cellpadding="3" cellspacing="1">
	<tr><td align="center"><span class="application_section_header">EMAIL STUDENT ID CARD</span></td></tr>
	<tr><td align="center">Student ID Card for #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)</td></tr>
	<tr>
		<td>Please select at least one recipient you would like to email the ID card to: <br>
			<cfinput type="checkbox" name="emailToSelf" value=1>#get_current_user.firstname# #get_current_user.lastname# <br>
			<cfinput type="checkbox" name="emailTointrep" value=1>#GetIntlReps.businessname# <br>
		</td>
	</tr>
	<tr><td align="center" bgcolor="ACB9CD"><cfinput type="image" name="image" src="../pics/sendemail.gif" value="send email"></td></tr>
</table>
</cfform>

<!--- SEND E-MAIL --->
<cfelse>
<cfdocument filename="#AppPath.temp#idcard_#client.studentid#.pdf" format="PDF" backgroundvisible="yes" overwrite="yes" fontembed="yes" localurl="no">
			<style type="text/css">
            <!--
        	<cfinclude template="../smg.css">            
            -->
            </style>
			<!--- form.pr_id and form.report_mode are required for the progress report in print mode.
			form.pdf is used to not display the logo which isn't working on the PDF. --->
            <cfset form.report_mode = 'print'>
            <cfset form.pdf = 1>
            <cfinclude template="../reports/labels_student_idcards.cfm">
        </cfdocument>
     <cfsavecontent variable="email_message">
        <cfoutput>				
            <p>An ID card for #get_student_info.firstname# #get_student_info.familylastname# (#get_student_info.studentid#) is attached.  #get_student_info.firstname#  will need this ID card when he comes to the United States. Please make sure he has a hard copy of this ID with him along with his passport and visa when he departs.   </p>
            <p>See the attached file for the ID card/</p>
            <p>
            Regards-<br />
            #get_facilitator.firstname# #get_facilitator.lastname#
            </p>
            <p>
        	
            </p>
        </cfoutput>
        </cfsavecontent>
     
<cfif form.emailToSelf eq 1  AND form.emailTointrep eq 0 >
	<cfset emails = '#get_current_user.email#'>
<cfelseif form.emailTointrep eq 1 AND form.emailToSelf eq 0 >
	<cfset emails = '#GetIntlReps.email#'>
<cfelseif form.emailToSelf eq 1  AND form.emailTointrep eq 1>
	<cfset emails = '#GetIntlReps.email#'&'; '&'#get_current_user.email#'>
<cfelse>
	<table width="650" align="center" class="nav_bar" bordercolor="C0C0C0" cellpadding="3" cellspacing="1">
		<tr><td bgcolor="ACB9CD">You must select at least one recipient. Please go back and try again.</td></tr>
		<tr><td align="center" bgcolor="ACB9CD"><input type="image" value="back" src="../pics/back.gif" onClick="javascript:history.back()"></td></tr>
	</table>
	<cfabort>
</cfif>


  <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#emails#">
             
            <cfinvokeargument name="email_replyto" value="""#companyshort.companyname#"" <#get_facilitator.email#>">
            <cfinvokeargument name="email_subject" value="ID Card for #get_student_info.firstname# #get_student_info.familylastname# ( #get_student_info.studentid# )">
            <cfinvokeargument name="email_message" value="#email_message#">
            <cfinvokeargument name="email_file" value="#AppPath.temp#idcard_#client.studentid#.pdf">
        </cfinvoke>	

<table width="650" align="center" class="nav_bar" bordercolor="C0C0C0" cellpadding="3" cellspacing="1">
	<tr><td><span class="application_section_header">EMAIL STUDENT ID CARD</span></td></tr>
	<tr><td align="center"><h2><u>Student : &nbsp; #get_student_info.firstname# #get_student_info.familylastname# ( #get_student_info.studentid# )</u></h2></td></tr>
	
	<tr align="center" bgcolor="ACB9CD"><td><span class="get_Attention">The student ID card has been sent to #emails#</span></td></tr>

	<tr><td align="center" bgcolor="ACB9CD">
			<input type="image" value="back" src="../pics/back.gif" onClick="javascript:history.back()">  &nbsp;  &nbsp;  &nbsp;  &nbsp;
			<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
	</td></tr>
</table>
</cfif>

</cfoutput>
</body>
</html>