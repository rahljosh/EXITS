<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Insurance New Registration</title>
</head>

<body>
<cfif NOT IsDefined('form.programid')>
	Please select at least one program.
	<cfabort>
</cfif>

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- get student info --->
<cfquery name="get_candidates" datasource="MySQL">
  SELECT ec.firstname, ec.lastname, ec.sex, ec.dob, ec.candidateid,
		 u.businessname, u.insurance_typeid,
		 p.insurance_startdate, p.insurance_enddate,
		 c.countrycode
  FROM 	extra_candidates ec
  INNER JOIN smg_users u 		ON ec.intrep = u.userid
  INNER JOIN smg_programs p 	ON ec.programid = p.programid
  LEFT JOIN smg_countrylist c 	ON ec.residence_country = c.countryid
  WHERE ec.active = '1' 
		AND ec.insurance_date IS NULL
		AND u.insurance_typeid != '1'
		<cfif form.intrep NEQ 0>AND ec.intrep = '#form.intrep#'</cfif>
		AND ( <cfloop list="#form.programid#" index='prog'>
			 ec.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
  ORDER BY u.businessname, ec.firstname
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=insurance_new_registration.xls"> 

<!--- <cfheader name="Content-Disposition"filename=caremed_template.xls">  Open in the Browser --->

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
<cfoutput>
	<table border="0" cellpadding="3" cellspacing="0">
		<tr><td colspan="8"><b>SITE - Services for International Travel & Education</b></td></tr><br />
		<tr><td colspan="8">Please email to: reports@site-insurance.com</td></tr><br />
	</table><br>
	<table border="0" cellpadding="3" cellspacing="0">
		<tr><td colspan="8"><b>Student Management Group Policy ## 01200 00064 Basic</b></td></tr>
	</table><br>
	<table border="1" cellpadding="3" cellspacing="0">
		<tr>
			<td>Last Name</td>
			<td>First Name</td>
			<td>Gender</td>
			<td>Date of Birth</td>
			<td>Country of Origin</td>
			<td>Country of Destination</td>
			<td>Effective Date</td>
			<td>Termination Date</td>
		</tr>
		<cfloop query="get_candidates">
			<tr>
				<td>#lastname#</td>
				<td>#FirstName#</td>
				<td>#sex#</td>
				<td>#DateFormat(dob, 'dd/mmm/yyyy')#</td>
				<td>#countrycode#</td>
				<td>US</td>
				<td>#DateFormat(insurance_startdate, 'dd/mmm/yyyy')#</td>
				<td>#DateFormat(insurance_enddate, 'dd/mmm/yyyy')#</td>
			</tr>
	</cfloop>
	</table>
</cfoutput> 

</body>
</html>
