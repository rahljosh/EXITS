<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>

<cfset client.studentid = form.studentid>

<cfinclude template="../querys/get_student_info.cfm">

<!--- ADD REGION HISTORY --->
<cfif get_student_info.regionassigned NEQ 0>
	<cfquery name="region_history" datasource="MySql">
		INSERT INTO smg_regionhistory
			(studentid, regionid, rguarenteeid,	stateguaranteeid, fee_waived, reason, changedby,  date)
		VALUES
			('#form.studentid#', '#get_student_info.regionassigned#', '#get_student_info.regionalguarantee#', '#get_student_info.state_guarantee#', '#get_student_info.jan_app#',
			'Reactivating student',	'#client.userid#', #CreateODBCDateTime(now())# )
	</cfquery>
</cfif>

<!--- ADD PROGRAM HISTORY --->
<cfif get_student_info.programid NEQ 0>
	<cfquery name="program_history" datasource="MySql">
		INSERT INTO smg_programhistory
			(studentid, programid, reason, changedby,  date)
		VALUES
			('#form.studentid#', '#get_student_info.programid#', 'Reactivating student', '#client.userid#', #CreateODBCDateTime(now())# )
	</cfquery>
</cfif>

<!--- SET APPLICATION TO RECEIVED --->
<cfset newstatus = 8>

<cfquery name="reactivate_application" datasource="MySQL">
	UPDATE smg_students 
	SET app_current_status = '#newstatus#',
		companyid = '#form.companyid#',
		cancelreason = '',
		active = '1',
		canceldate = NULL,
		regionassigned = 0,
		programid = 0
	WHERE studentid = '#form.studentid#'
	LIMIT 1
</cfquery>

<cfquery name="reactivate_application_status" datasource="MySQL">
	INSERT INTO smg_student_app_status (studentid, status, reason, approvedby)
	VALUES ('#form.studentid#', '#newstatus#', '#form.reason#', '#client.userid#')
</cfquery>

<!--- SEND EMAIL TO BRYAN - FINANCE DEPARTMENT --->

<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_current_user" datasource="MySql">
	SELECT userid, firstname, lastname, email
	FROM smg_users
	WHERE userid = '#client.userid#'
</cfquery>

<cfif NOT IsValid("email", get_current_user.email)>
	<cfset get_current_user.email = 'bmccready@iseusa.org'>
</cfif>

<cfquery name="get_denied_reason" datasource="MySql">
	SELECT studentid, status, reason, date, approvedby,
		u.firstname, u.lastname, u.userid
	FROM smg_student_app_status
	LEFT JOIN smg_users u ON u.userid = smg_student_app_status.approvedby
	WHERE studentid = '#form.studentid#'
		AND status = '9' 
	ORDER BY date DESC
</cfquery>

<CFMAIL SUBJECT="Applicatiion Reactivated for #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)"
	TO="jennifer@iseusa.org"
	bcc="#get_current_user.email#"
	FROM="""#get_current_user.firstname# #get_current_user.lastname# - #companyshort.companyshort#"" <#get_current_user.email#>"
	failto="support@student-management.com"
	TYPE="HTML">
		
	<HTML>
	<HEAD>
	<style type="text/css">
	<!--
	.application_section_header{
		border-bottom: 1px dashed Gray;
		text-transform: uppercase;
		letter-spacing: 5px;
		width:100%;
		text-align:center;
		background;
		background: DCDCDC;
		font-size: small;
	}
	.acceptance_letter_header {
		border-bottom: 1px dashed Gray;
		text-transform: capitalize;
		letter-spacing: normal;
		width:100%;
		text-align:left;
	}
	
	-->
	</style>
	</HEAD>
	<BODY>		
	<!--- Page Header --->
	<table width="650" border="0" bgcolor="FFFFFF"> 
		<tr>
			<td align="left"><img src="#CLIENT.exits_url#/nsmg/pics/logos/#companyshort.companyid#.gif"  alt="" border="0" align="left"></td>
			<td align="left" valign="top">
				<b>#companyshort.companyname#</b><br>
				#companyshort.address#<br>
				#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
			</td>
			<td align="right" valign="top">
				<cfif companyshort.phone NEQ ''>Phone: #companyshort.phone#<br></cfif>
				<cfif companyshort.toll_free NEQ ''>Toll Free: #companyshort.toll_free#<br></cfif>
				<cfif companyshort.fax NEQ ''>Fax: #companyshort.fax#<br></cfif>
			</td>
		</tr>
	</table>
	
	<table width="650" border="0" bgcolor="FFFFFF">
		<hr width=100%>
	</table><br>
	
	<table width="650" border="0" bgcolor="FFFFFF" cellpadding="3">
		<tr><td colspan="2"><span class="application_section_header"><font size=+1><b><u>APPLICATION REACTIVATED</u></b></font></span><br><br><br></td></tr>
		<tr>
			<td width="10%">TO:</td><td>SMG Finance Deparment</td>
		</tr>
		<tr> 
			<td>FROM:</td><td>#companyshort.companyname# &nbsp; / &nbsp; #get_current_user.firstname# #get_current_user.lastname# (###get_current_user.userid#)</td>
		</tr>
		<tr>
			<td>DATE:</td><td>#DateFormat(now(), 'dddd, mmmm dd, yyyy')#</td>
		</tr>
		<tr><td>RE: </td><td><b>#get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)</b></td></tr>
	</table><br>
	
	<table width="650" border="0" bgcolor="FFFFFF" cellpadding="3">
		<tr>
			<td colspan="2">
				<div align="justify">
					The above student's application has been reactivated by #get_current_user.firstname# #get_current_user.lastname#.
				
					<br><br>
					<b>PS: #form.reason#</b>
					<br><br>
					
					Application originally denied on <b>#DateFormat(get_denied_reason.date, 'mm/dd/yyyy')#</b> 
					by #get_denied_reason.firstname# #get_denied_reason.lastname# (###get_denied_reason.userid#)<br>
					Reason for denial: <b>#get_denied_reason.reason#</b>
					<br>
				</div>
			</td>
		</tr>
		<tr><td colspan="2"><br>Sincerely,</td></tr>
		<tr><td colspan="2">EXITS</td></tr>
	</table>
	</body>
	</html>
</CFMAIL>

<script language="JavaScript">
<!-- 
alert("This application has been reactivated. The new application status is RECEIVED.");
	location.replace("index.cfm?curdoc=app_process/apps_received&status=received");
-->
</script>


</body>
</html>