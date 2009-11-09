<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>New Transaction Insurance</title>
</head>

<body>

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- get student info --->
<cfquery name="get_students" datasource="MySQL">
	SELECT i.studentid, i.firstname, i.lastname, i.sex, i.dob, i.country_code, i.new_date, i.end_date, i.policy_code
	FROM 	smg_insurance i
	INNER JOIN smg_students s ON s.studentid = i.studentid 
	INNER JOIN smg_users u ON u.userid = s.intrep  
	WHERE s.companyid = '6'
		AND transtype = 'new'
		AND sent_to_caremed > '2007-06-01'
		AND policy_code = '9'	
		AND (
		i.studentid = '8984' OR 
		i.studentid = '10153' OR 
		i.studentid = '10242' OR 
		i.studentid = '9745' OR 		
		i.studentid = '9180' OR 
		i.studentid = '9087' OR 
		i.studentid = '8392' OR 
		i.studentid = '9796' OR 
		i.studentid = '10381' OR 
		i.studentid = '10417' OR 
		i.studentid = '10340' OR 
		i.studentid = '10752' OR 
		i.studentid = '9511' OR 
		i.studentid = '10210' OR 
		i.studentid = '9198' OR 
		i.studentid = '8631' OR 
		i.studentid = '9253' OR 
		i.studentid = '7613' OR 
		i.studentid = '7967' OR 
		i.studentid = '8231' OR 
		i.studentid = '9774' OR 
		i.studentid = '9439' OR 
		i.studentid = '9797' OR 
		i.studentid = '8933' OR 
		i.studentid = '9297' OR 
		i.studentid = '10761' OR 
		i.studentid = '8977' OR 
		i.studentid = '10452' OR 
		i.studentid = '8134' OR 
		i.studentid = '9524' OR 
		i.studentid = '8214' OR 
		i.studentid = '9492' OR 
		i.studentid = '7927' OR 
		i.studentid = '10336' OR 
		i.studentid = '7671' OR
		i.studentid = '10977' OR
		i.studentid = '7202' OR
		i.studentid = '10377' OR
		i.studentid = '8736' OR
		i.studentid = '10270' OR
		i.studentid = '7772' OR
		i.studentid = '8450' OR
		i.studentid = '8056' OR
		i.studentid = '9891' OR
		i.studentid = '10378' OR
		i.studentid = '8693')
	ORDER BY u.businessname, s.firstname
</cfquery>

<cfquery name="get_insu_policy" datasource="MySql">
	SELECT insutypeid, type 
	FROM smg_insurance_type
	WHERE insutypeid = '9'
</cfquery>

<!---
#7 - STANDARD COMPREHENSIVE PLAN 
Group "4014" if filed in August-07
Group "4015" if filed in September-07

#8 - STANDARD COMPREHENSIVE w/ DEDUCTIBLE 
Group "4026" if filed in August-07
Group "4027" if filed in September-07

#9 - PREMIER PLAN 
Group "4002" if filed in August-07
Group "4003" if filed in September-07
--->

<cfset group = ''>

<cfif get_students.policy_code EQ 7 AND DateFormat(now(), 'mm') EQ 8>
	<cfset group = 4014>
<cfelseif get_students.policy_code EQ 7 AND DateFormat(now(), 'mm') EQ 9>
	<cfset group = 4015>
<cfelseif get_students.policy_code EQ 8 AND DateFormat(now(), 'mm') EQ 8>
	<cfset group = 4026>
<cfelseif get_students.policy_code EQ 8 AND DateFormat(now(), 'mm') EQ 9>
	<cfset group = 4027>
<cfelseif get_students.policy_code EQ 9 AND DateFormat(now(), 'mm') EQ 8>
	<cfset group = 4002>
<cfelseif get_students.policy_code EQ 9 AND DateFormat(now(), 'mm') EQ 9>
	<cfset group = 4003>
</cfif>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=site_template.xls"> 

<!--- <cfheader name="Content-Disposition"filename=caremed_template.xls">  Open in the Browser --->

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
<cfoutput>
	<table border="0" cellpadding="3" cellspacing="0">
		<tr><td colspan="8"><b>Student Management Group #get_insu_policy.type#</b></td></tr>
	</table><br>
	<table border="1" cellpadding="3" cellspacing="0">
		<tr>
			<td>(N/X)</td>
			<td>Group</td>
			<td>Student ID</td>			
			<td>Last Name</td>
			<td>First Name</td>
			<td>Gender</td>
			<td>Date of Birth</td>
			<td>Country of Origin</td>
			<td>Country of Destination</td>
			<td>Effective Date (mm/dd/yy)</td>
			<td>Termination Date (mm/dd/yy)</td>
		</tr>
		<cfloop query="get_students">
			<tr>
				<td>N</td>
				<td>#group#</td>
				<td>#studentid#</td>
				<td>#lastname#</td>
				<td>#firstName#</td>
				<td>#sex#</td>
				<td>#DateFormat(dob, 'mm/dd/yy')#</td>
				<td>#country_code#</td>
				<td>United States</td>
				<td>#DateFormat(new_date, 'mm/dd/yy')#</td>
				<td>#DateFormat(end_date, 'mm/dd/yy')#</td>
			</tr>
		</cfloop>
		</table>
</cfoutput> 

</body>
</html>
