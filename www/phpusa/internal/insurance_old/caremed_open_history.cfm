<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Insurance History</title>
</head>

<body>

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<cfset url.transtype = URLDecode(url.transtype)>

<!--- get student info --->
<cfquery name="get_history" datasource="MySQL">
	SELECT i.insuranceid, i.companyid, i.studentid, i.firstname, i.lastname, i.sex, i.dob, i.country_code, i.new_date, i.end_date,
		i.org_code, i.policy_code, vsc_group, sent_to_caremed,
		c.companyshort
	FROM smg_insurance i
	INNER JOIN smg_students s ON s.studentid = i.studentid
	INNER JOIN smg_companies c ON c.companyid = s.companyid
	INNER JOIN smg_users u ON u.userid = s.intrep
	INNER JOIN smg_insurance_type type ON u.php_insurance_typeid = type.insutypeid
	WHERE type.provider = 'caremed'
		AND i.transtype = <cfqueryparam value="#url.transtype#" cfsqltype="cf_sql_char" maxlength="15">
		AND i.sent_to_caremed = <cfqueryparam value="#url.date#" cfsqltype="cf_sql_date">
		AND i.companyid = '6'
	ORDER BY s.sevis_batchid, u.businessname, s.firstname		
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
		<cfif url.transtype EQ 'new' OR url.transtype EQ 'early return' OR url.transtype EQ 'cancellation' OR url.transtype EQ 'extension'>
			<tr>
				<td>#org_code#</td>
				<td>#policy_code#</td>
				<td>#transtype#</td>
				<td>#lastname#</td>
				<td>#firstname#</td>
				<td>#DateFormat(dob, 'dd/mmm/yyyy')#</td>
				<td>#sex#</td>
				<td>#DateFormat(new_date, 'dd/mmm/yyyy')#</td>
				<td>#DateFormat(end_date, 'dd/mmm/yyyy')#</td>
				<td>#country_code#</td>
				<td>US</td>
				<td>INT</td>
			</tr>
		<cfelseif url.transtype EQ 'correction'>
			<cfquery name="get_previous" datasource="MySql">
				SELECT max(insuranceid) as insuranceid
				FROM smg_insurance
				WHERE studentid = '#studentid#' 
					AND transtype != <cfqueryparam value="#url.transtype#" cfsqltype="cf_sql_char">
			</cfquery>
			<cfquery name="insurance" datasource="MySql">
				SELECT insuranceid, studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, vsc_group, policy_code
				FROM smg_insurance
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
				<td>#DateFormat(insurance.new_date, 'dd/mmm/yyyy')#</td>
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
				<td><cfif insurance.new_date EQ new_date>#DateFormat(new_date, 'dd/mmm/yyyy')#<cfelse><b>#DateFormat(new_date, 'dd/mmm/yyyy')#</b></cfif></td>
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
