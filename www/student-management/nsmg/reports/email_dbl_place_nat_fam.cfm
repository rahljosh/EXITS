<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="reports.css" type="text/css">
<title>Double Placement - Natural Family</title>
</head>

<body>

<cfif Isdefined('url.studentid')>
	<cfset form.studentid = '#url.studentid#'>
<cfelseif NOT IsDefined('form.studentid')>
	<table width="650" align="center" class="nav_bar" bordercolor="C0C0C0" cellpadding="3" cellspacing="1">
		<tr><td bgcolor="ACB9CD">An error has ocurred. Please try again.</td></tr>
		<tr><td align="center" bgcolor="ACB9CD"><input type="image" value="back" src="../pics/back.gif" onClick="javascript:history.back()"></td></tr>
	</table>
	<cfabort>
</cfif>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_student_info" datasource="mysql">
	SELECT 
    	s.studentID,
        s.intRep,
    	s.familylastname, 
        s.address,
        s.address2, 
        s.city, 
        s.zip, 
        s.firstname, 
        s.ds2019_no, 
        s.sex,
        s.regionassigned, 
        s.programid, 
        sh.hostID, 
        sh.schoolID,
		sh.arearepID, 
        sh.doublePlacementID, 
		c.countryname,
		p.programname, 
        p.startdate
	FROM 
    	smg_students s
	INNER JOIN
    	smg_hosthistory sh ON sh.studentID = s.studentID
        AND
        	isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">        
	INNER JOIN 
    	smg_countrylist c ON c.countryid = s.countryresident
	INNER JOIN 
    	smg_programs p ON p.programid = s.programid        
	WHERE 
    	s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
</cfquery>

<!--- Double Placement Student --->
<cfquery name="double_placement" datasource="MySQL">
	SELECT 
    	s.firstname, 
        s.familylastname, 
        s.countryresident, 
        c.countryname, 
        s.schoolid, 
        s.hostid, 
        s.ds2019_no, 
        s.sex,
		p.programname, 
        p.startdate
	FROM 
    	smg_students s
    INNER 
    	JOIN smg_countrylist c ON c.countryid = s.countryresident
	INNER 
    	JOIN smg_programs p ON p.programid = s.programid
	WHERE 
    	s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_student_info.doublePlacementID)#">
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

<cfform name="email" action="email_dbl_place_nat_fam.cfm" method="post" onsubmit="return confirm ('Are you sure?')">
<cfinput type="hidden" name="studentid" value="#form.studentid#">
<cfinput type="hidden" name="send">
<table width="650" align="center" class="nav_bar" bordercolor="C0C0C0" cellpadding="3" cellspacing="1">
	<tr><td align="center"><span class="application_section_header">EMAIL DOUBLE PLACEMENT NATURAL FAMILY LETTER</span></td></tr>
	<tr><td align="center">Letter for #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)</td></tr>
	<tr>
		<td>Please select at least one recipient you would like to email the letter to: <br>
			<cfinput type="checkbox" name="self">#get_current_user.firstname# #get_current_user.lastname# <br>
			<cfinput type="checkbox" name="intrep">#GetIntlReps.businessname# <br>
		</td>
	</tr>
	<tr><td align="center" bgcolor="ACB9CD"><cfinput type="image" name="image" src="../pics/sendemail.gif" value="send email"></td></tr>
</table>
</cfform>

<!--- SEND E-MAIL --->
<cfelse>

<cfif IsDefined('form.self') AND NOT IsDefined('form.intrep')>
	<cfset emails = '#get_current_user.email#'>
<cfelseif IsDefined('form.intrep') AND NOT IsDefined('form.self')>
	<cfset emails = '#GetIntlReps.email#'>
<cfelseif IsDefined('form.self') AND IsDefined('form.intrep')>
	<cfset emails = '#GetIntlReps.email#'&'; '&'#get_current_user.email#'>
<cfelse>
	<table width="650" align="center" class="nav_bar" bordercolor="C0C0C0" cellpadding="3" cellspacing="1">
		<tr><td bgcolor="ACB9CD">You must select at least one recipient. Please go back and try again.</td></tr>
		<tr><td align="center" bgcolor="ACB9CD"><input type="image" value="back" src="../pics/back.gif" onClick="javascript:history.back()"></td></tr>
	</table>
	<cfabort>
</cfif>

<CFMAIL SUBJECT="Double Placement Letter for #get_student_info.firstname# #get_student_info.familylastname# ( #get_student_info.studentid# )"
TO="#emails#" failto="#get_current_user.email#" REPLYTO="""#companyshort.companyname#"" <#get_facilitator.email#>"  FROM=#client.support_email# TYPE="HTML">
<HTML>
<HEAD>
<style type="text/css">
<!--
.style1 {font-size: 14px}
-->
</style>
</HEAD>
<BODY>

<cfinclude template="email_intl_header.cfm"><br>
<table  width=650 align="center" border=0 bgcolor="FFFFFF" >	
	<tr><td class="style1">
    <div align="justify">		
		<p>Request for a Double Placement</p>
		<p>#companyshort.companyname# is requesting a double placement for the following two students:</p>
	 </div></td></tr>
</table><br>

<table width=650 align="center" cellpadding=12 cellspacing="0" frame="below">
<tr>
	<td width="20" class="style1" valign="top">1.</td>
	<td width="300" class="style1" valign="top">#UCASE(RTRIM(get_student_info.firstname))# #UCASE(RTRIM(get_student_info.familylastname))# <br>
		#CLIENT.DSFormName# no.: &nbsp; #get_student_info.ds2019_no# <br>
		Program Start Date: &nbsp; #DateFormat(get_student_info.startdate, 'mm/dd/yyyy')#</td>
	<td width="80" class="style1" valign="top"><p>FROM</p>
	  <p>GENDER</p>
	  </td>
	<td class="style1" valign="top"><p>#UCASE(RTRIM(get_student_info.countryname))#</p>
	  <p>#UCASE(RTRIM(get_student_info.sex))#</p></td>
	
</tr>
<tr>
	<cfif get_student_info.doublePlacementID is 0>
		<td colspan="4" class="style1"><b><font color="FF0000">There is no double placement assigned for the student above.</font><font color="FF0000"></font></b></td>
	<cfelse>
	<td class="style1" valign="top">2.</td>
	<td width="300" class="style1" valign="top">#UCASE(RTRIM(double_placement.firstname))# #UCASE(RTRIM(double_placement.familylastname))# <br>
		#CLIENT.DSFormName# no.: &nbsp; #double_placement.ds2019_no# <br>
		Program Start Date: &nbsp; #DateFormat(double_placement.startdate, 'mm/dd/yyyy')#</td>
	 <td width="80" class="style1" valign="top"><p>FROM</p>
    <p>GENDER</p></td>
	<td class="style1" valign="top"><p>#UCASE(RTRIM(double_placement.countryname))#</p>
	  <p>#UCASE(RTRIM(double_placement.sex))#</p></td>
	</cfif>
</tr>
</table><BR>

<table width=650 border=0 align="center" bgcolor="FFFFFF">
<tr><td class="style1"><div align="justify">
	<p>As you may know, the Department of State requires that the student, the natural family and the international representative 
	agree in writing to any double placements.</p>
	<p>Please sign on the lines below and return to #companyshort.companyshort_nocolor# so that we may finalize the placement.</p>
	<p>Thank you.</p>
	</div>
</td></tr>
</table>
		
<BR>

<table width=650 border=0 align="center" bgcolor="FFFFFF" cellpadding=3 cellspacing="0">
<tr>
	<td class="style1" width="160" align="right">Student:</td>
	<td class="style1" width="260">___________________________________________<br><font size="-1">signature</font></td>
	<td class="style1" width="190"><cfoutput><u>#dateFormat(now(), 'mmm. dd, yyyy')#</u><br>date </cfoutput></td>
</tr>
<tr>
	<td class="style1" align="right">Print Name:</td>
	<td class="style1" colspan="2">___________________________________________</td>
</tr>
<tr><td class="style1"><br></td></tr>
<tr>
	<td class="style1" align="right">Parent:</td>
	<td class="style1">___________________________________________<br><font size="-1">signature</font> </td>
	<td class="style1"><cfoutput><u>#dateFormat(now(), 'mmm. dd, yyyy')#</u><br>date </cfoutput></td>
</tr>
<tr>
	<td class="style1" align="right">Print Name:</td>
	<td class="style1" colspan="2">___________________________________________</td>
</tr>
<tr><td class="style1"><br></td></tr>
<tr>
	<td class="style1" align="right">Intl. Representative:</td>
	<td class="style1">___________________________________________<br><font size="-1">signature</font> </td>
	<td class="style1"><cfoutput><u>#dateFormat(now(), 'mmm. dd, yyyy')#</u><br>date </cfoutput><br>date (mm/dd/yy) </td>
</tr>
<tr>
	<td class="style1" align="right">Print Name:</td>
	<td class="style1" colspan="2">___________________________________________</td>
</tr>
<tr><td class="style1"><br><br></td></tr>
<tr><td class="style1" colspan="3">By signing this, we agree to the double placement regarding the students above.</td></tr>
</table>

</body>
</html>
</CFMAIL>

<table width="650" align="center" class="nav_bar" bordercolor="C0C0C0" cellpadding="3" cellspacing="1">
	<tr><td><span class="application_section_header">DOUBLE PLACEMENT NATURAL FAMILY LETTER</span></td></tr>
	<tr><td align="center"><h2><u>Student : &nbsp; #get_student_info.firstname# #get_student_info.familylastname# ( #get_student_info.studentid# )</u></h2></td></tr>
	<cfif IsDefined('form.self')>
	<tr align="center" bgcolor="ACB9CD"><td><span class="get_Attention">The Double Placement Natural Family Letter has been sent to #get_current_user.firstname# #get_current_user.lastname#</span></td></tr>
	<cfelse>
	<tr align="center" bgcolor="ACB9CD"><td><span class="get_Attention">The Double Placement Natural Family Letter has been sent to #GetIntlReps.businessname# at #GetIntlReps.email#.</span></td></tr>
	</cfif>
	<tr><td align="center" bgcolor="ACB9CD">
			<input type="image" value="back" src="../pics/back.gif" onClick="javascript:history.back()">  &nbsp;  &nbsp;  &nbsp;  &nbsp;
			<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
	</td></tr>
</table>
</cfif>

</cfoutput>
</body>
</html>