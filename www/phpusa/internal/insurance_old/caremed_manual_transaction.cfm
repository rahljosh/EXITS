<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>

<cfif form.transtype EQ 0>
	You must select a transaction type in order to proceed.
	<cfabort>
</cfif>

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<cfquery name="get_stu_insurance" datasource="MySQL">
	SELECT i.insuranceid, i.companyid, i.vsc_group, i.studentid, i.firstname, i.lastname, i.sex, i.dob, i.country_code, i.new_date, i.end_date, 
		i.org_code, i.policy_code, vsc_group, sent_to_caremed,
		c.companyshort,
		php.assignedid
	FROM smg_insurance i
	INNER JOIN php_students_in_program php ON php.studentid = i.studentid
	INNER JOIN smg_students s ON s.studentid = i.studentid
	INNER JOIN smg_companies c ON c.companyid = s.companyid
	INNER JOIN smg_users u ON u.userid = s.intrep
	INNER JOIN smg_insurance_type type ON u.php_insurance_typeid = type.insutypeid
	WHERE type.provider = 'caremed'
		AND i.sent_to_caremed IS NULL
		AND i.transtype = '#form.transtype#'
		AND i.companyid = '6'
	ORDER BY s.sevis_batchid, u.businessname, s.firstname		 
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<!--- "Content-Disposition" in cfheader also ensures relatively correct Internet Explorer behavior. --->

<cfheader name="Content-Disposition" value="attachment; filename=caremed_template.xls"> 

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
	<cfloop query="get_stu_insurance">
		<cfquery name="get_previous" datasource="MySql">
			SELECT max(insuranceid) as insuranceid
			FROM smg_insurance
			WHERE studentid = '#studentid#' 
				AND sent_to_caremed IS NOT NULL
		</cfquery>
		<cfquery name="insurance" datasource="MySql">
			SELECT insuranceid, studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, vsc_group, org_code, policy_code
			FROM smg_insurance
			WHERE insuranceid = '#get_previous.insuranceid#'
		</cfquery>			
		
		<!--- NEW --->
		<cfif form.transtype EQ 'new'>
			<tr>
				<td>#org_code#</td>
				<td>#policy_code#</td>
				<td>New App</td>
				<td>#lastname#</td>
				<td>#FirstName#</td>
				<td>#DateFormat(dob, 'dd/mmm/yyyy')#</td>
				<td>#sex#</td>
				<td>#DateFormat(new_date, 'dd/mmm/yyyy')#</td>
				<td>#DateFormat(end_date, 'dd/mmm/yyyy')#</td>
				<td>#country_code#</td>
				<td>US</td>
				<td>INT</td>
			</tr>
			<cfquery name="update_student" datasource="MySql">
				UPDATE php_students_in_program 
				SET insurancedate = #CreateODBCDate(now())#,
					insurancecanceldate = NULL
				WHERE assignedid = '#assignedid#'
				LIMIT 1
			</cfquery>
		<!--- CORRECTION --->			
		<cfelseif form.transtype EQ 'correction'>
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
				<td>#insurance.policy_code#</td>
				<td>Correction</td>
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
		<!--- EARLY RETURN --->			
		<cfelseif form.transtype EQ 'early return'>
			<tr>
				<td>#insurance.org_code#</td>
				<td>#insurance.policy_code#</td>
				<td>Early Return</td>
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
			<cfquery name="update_student" datasource="MySql">
				UPDATE php_students_in_program 
				SET insurancecanceldate = #CreateODBCDate(now())# 
				WHERE assignedid = '#assignedid#'
				LIMIT 1
			</cfquery>
		<!--- CANCELATION --->	
		<cfelseif form.transtype EQ 'cancellation'>
			<tr>
				<td>#insurance.org_code#</td>
				<td>#insurance.policy_code#</td>
				<td>Cancellation</td>
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
			<cfquery name="update_student" datasource="MySql">
				UPDATE php_students_in_program 
				SET insurancecanceldate = #CreateODBCDate(now())# 
				WHERE assignedid = '#assignedid#'
				LIMIT 1
			</cfquery>	
		<!--- EXTENSION --->	
		<cfelseif form.transtype EQ 'extension'>
			<tr>
				<td>#insurance.org_code#</td>
				<td>#insurance.policy_code#</td>
				<td>Extension</td>
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
		</cfif>	
		<!--- UPDATE INSURANCE HISTORY --->
		<cfquery name="update" datasource="MySQL">  
			UPDATE smg_insurance
			SET sent_to_caremed = #CreateODBCDate(now())#,
				excel_spreadsheet = '1'
			WHERE insuranceid = '#insuranceid#'
			LIMIT 1 
		</cfquery>
	</cfloop>
</table>
</cfoutput> 

</body>
</html>