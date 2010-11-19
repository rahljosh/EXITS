<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>New Transaction Insurance</title>
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
	SELECT c.candidateid, c.firstname, c.lastname, c.sex, c.dob, c.startdate, c.enddate,
		u.businessname, u.extra_insurance_typeid,
		country.countrycode,
		comp.orgcode,
		insu_codes.policycode
	FROM extra_candidates c
	INNER JOIN smg_users u ON u.userid = c.intrep
	INNER JOIN smg_companies comp ON comp.companyid = c.companyid
	LEFT JOIN smg_countrylist country ON country.countryid =  c.residence_country
	LEFT JOIN smg_insurance_codes insu_codes ON (u.extra_insurance_typeid = insu_codes.insutypeid AND c.companyid = insu_codes.companyid)
	WHERE c.active = '1'
		AND c.dob IS NOT NULL
		AND cancel_date IS NULL
		AND c.insurance_date IS NULL
		AND c.verification_received = #CreateODBCDate(form.verification_received)#
		AND u.extra_insurance_typeid = '#form.extra_insurance_typeid#'	
		<cfif form.intrep NEQ 0>
			AND c.intrep = '#form.intrep#'
		</cfif>
		AND ( <cfloop list="#form.programid#" index="prog">
			 c.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )  
  ORDER BY u.businessname, c.lastname, c.firstname
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=caremed-trainee.xls"> 

<!--- <cfheader name="Content-Disposition"filename=caremed_template.xls">  Open in the Browser --->

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
<cfoutput>
<table border="1" cellpadding="3" cellspacing="0">
	<tr>
		<td colspan="8"><center><b>Student Management Group (Comfort 50)</b></center></td>
	</tr>
	<tr>
		<td>N/X</td>
		<td>IHI Policy Number</td>
		<td>Last Name</td>
		<td>First Name</td>
		<td>Birth Date</td>
		<td>Start Date</td>
		<td>End Date</td>
	</tr>
	<cfloop query="get_candidates">
		<cfif startdate NEQ '' AND enddate NEQ ''>
			<tr>
				<td>N</td>
				<td>8229702-2090</td>
				<td>#lastname#</td>
				<td>#FirstName#</td>
				<td>#DateFormat(dob, 'dd/mmm/yyyy')#</td>
				<td><cfif startdate NEQ ''>#DateFormat(startdate, 'dd/mmm/yyyy')#<cfelse>Missing</cfif></td>
				<td><cfif enddate NEQ ''>#DateFormat(enddate, 'dd/mmm/yyyy')#<cfelse>Missing</cfif></td>
			</tr>
			<cfif policycode NEQ '' AND startdate NEQ '' AND enddate NEQ ''> 
				<cfquery name="update_candidate" datasource="MySql">
					UPDATE extra_candidates 
					SET insurance_date = #CreateODBCDate(now())# 
					WHERE candidateid = '#candidateid#'
					LIMIT 1
				</cfquery>				
				<!--- CREATE HISTORY FILE --->
				<cfquery name="insert_history" datasource="MySql">
					INSERT INTO extra_insurance_history 
						(candidateid, firstname, lastname, sex, dob, country_code, start_date, end_date, org_code, policy_code, filed_date, 
						transtype, excel_sheet)
					VALUES
						('#candidateid#', '#firstname#', '#lastname#', '#sex#', #CreateODBCDate(dob)#, '#countrycode#',
						#CreateODBCDate(startdate)#, #CreateODBCDate(enddate)#, '#orgcode#', '#policycode#',
						#CreateODBCDate(now())#, 'new', '1');	
				</cfquery>	
			</cfif>
		</cfif>
	</cfloop>
</table>
</cfoutput> 

</body>
</html>
