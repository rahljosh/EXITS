<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Insurance History</title>
</head>

<body>

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- get student info --->
<cfquery name="get_history" datasource="MySQL">
	SELECT h.candidateid, h.firstname, h.lastname, h.sex, h.dob, h.country_code, h.start_date, h.end_date, h.org_code, h.policy_code, 
		h.filed_date, h.transtype
	FROM extra_insurance_history h
	INNER JOIN extra_candidates c ON c.candidateid = h.candidateid
	INNER JOIN smg_users u ON u.userid = c.intrep
	WHERE h.transtype = <cfqueryparam value="#url.type#" cfsqltype="cf_sql_char">
		AND h.filed_date = <cfqueryparam value="#url.date#" cfsqltype="cf_sql_date">
	ORDER BY u.businessname, h.firstname		
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
		<td>Organization Code</td>
		<td>Policy Number</td>
		<td>Transaction Type</td>
		<td>Last Name</td>
		<td>First Name</td>
		<td>Birth Date</td>
		<td>Gender</td>
		<td>Start Date</td>
		<td>End Date</td>
		<td>Country of Origin</td>
		<td>Country of Destination</td>
		<td>Program Type</td>
	</tr>
	<cfloop query="get_history">
		<cfif url.type EQ 'new' OR url.type EQ 'early return' OR url.type EQ 'cancellation' OR url.type EQ 'extension'>
			<tr>
				<td>#org_code#</td>
				<td>#policy_code#</td>
				<td>#transtype#</td>
				<td>#lastname#</td>
				<td>#firstname#</td>
				<td>#DateFormat(dob, 'dd/mmm/yyyy')#</td>
				<td>#sex#</td>
				<td>#DateFormat(start_date, 'dd/mmm/yyyy')#</td>
				<td>#DateFormat(end_date, 'dd/mmm/yyyy')#</td>
				<td>#country_code#</td>
				<td>US</td>
				<td>INT</td>
			</tr>
		<cfelseif url.type EQ 'correction'>
			<cfquery name="get_previous" datasource="MySql">
				SELECT max(insuranceid) as insuranceid
				FROM extra_insurance_history
				WHERE candidateid = '#candidateid#' 
					AND transtype != <cfqueryparam value="#url.type#" cfsqltype="cf_sql_char">
			</cfquery>
			
			<cfquery name="insurance" datasource="MySql">
				SELECT insuranceid, candidateid, firstname, lastname, sex, dob, country_code, start_date, end_date, org_code, policy_code
				FROM extra_insurance_history
				WHERE insuranceid = '#get_previous.insuranceid#'
			</cfquery>				
			<tr>
				<td>#insurance.org_code#</td>
				<td>#insurance.policy_code#</td>
				<td>Cancellation</td>
				<td>#insurance.lastname#</td>
				<td>#insurance.firstname#</td>
				<td>#DateFormat(insurance.dob, 'dd/mmm/yyyy')#</td>
				<td>#insurance.sex#</td>
				<td>#DateFormat(insurance.start_date, 'dd/mmm/yyyy')#</td>
				<td>#DateFormat(insurance.end_date, 'dd/mmm/yyyy')#</td>
				<td>#insurance.country_code#</td>
				<td>US</td>
				<td>INT</td>
			</tr>
			<tr>
				<td>#insurance.org_code#</td>
				<td>#policy_code#</td>
				<td>#transtype#</td>
				<td><cfif insurance.lastname EQ lastname>#lastname#<cfelse><b>#lastname#</b></cfif></td>
				<td><cfif insurance.firstname EQ firstname>#firstname#<cfelse><b>#firstname#</b></cfif></td>
				<td><cfif insurance.dob EQ dob>#DateFormat(dob, 'dd/mmm/yyyy')#<cfelse><b>#DateFormat(dob, 'dd/mmm/yyyy')#</b></cfif></td>
				<td><cfif insurance.sex EQ sex>#sex#<cfelse><b>#sex#</b></cfif></td>
				<td><cfif insurance.start_date EQ start_date>#DateFormat(start_date, 'dd/mmm/yyyy')#<cfelse><b>#DateFormat(start_date, 'dd/mmm/yyyy')#</b></cfif></td>
				<td><cfif insurance.end_date EQ end_date>#DateFormat(end_date, 'dd/mmm/yyyy')#<cfelse><b>#DateFormat(end_date, 'dd/mmm/yyyy')#</b></cfif></td>
				<td><cfif insurance.country_code EQ country_code>#country_code#<cfelse><b>#country_code#</b></cfif></td>
				<td>US</td>
				<td>INT</td>
			</tr>		
		</cfif>
	</cfloop>
</table>
</cfoutput> 

</body>
</html>
