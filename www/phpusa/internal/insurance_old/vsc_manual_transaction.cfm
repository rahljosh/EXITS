<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Insurance - Manual Transaction</title>
</head>

<body>

<cfif form.transtype EQ 0>
	You must select a transaction type in order to proceed.
	<cfabort>
</cfif>

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<cfquery name="get_insu_policy" datasource="MySql">
	SELECT insutypeid, type 
	FROM smg_insurance_type
	WHERE insutypeid = '#form.insurance_typeid#'
</cfquery>

<!--- get student info --->
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
	WHERE i.sent_to_caremed IS NULL
		AND i.transtype = '#form.transtype#'
		AND i.policy_code = '#form.insurance_typeid#'
		AND i.companyid = '6'
	ORDER BY s.sevis_batchid, u.businessname, s.firstname		 
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<!--- "Content-Disposition" in cfheader also ensures relatively correct Internet Explorer behavior. --->

<cfheader name="Content-Disposition" value="attachment; filename=virginia_surety.xls"> 

<!--- <cfheader name="Content-Disposition"filename=caremed_template.xls">  Open in the Browser --->

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->

<cfoutput>
	<table border="0" cellpadding="3" cellspacing="0">
		<tr><td colspan="8"><b>Student Management Group #get_insu_policy.type#</b></td></tr>
	</table><br>
	<table border="1" cellpadding="3" cellspacing="0">
	<tr>
		<td>Type</td>
		<td>Group</td>
		<td>SMG Company</td>
		<td>Student ID</td>
		<td>Last Name</td>
		<td>First Name</td>
		<td>Gender</td>
		<td>Birth Date</td>
		<td>Country of Origin</td>
		<td>Country of Destination</td>
		<td>
			<cfif form.transtype EQ 'new' OR form.transtype EQ 'correction' OR form.transtype EQ 'extension'>
				Effective Date
			<cfelseif form.transtype EQ 'early return'>
				Return Date
			<cfelseif form.transtype EQ 'cancellation'>	
				Cancelation Date
			</cfif> (mm/dd/yyyy)
		</td>
		<td>Termination Date (mm/dd/yyyy)</td>
	</tr>	
	<cfloop query="get_stu_insurance">
		<!--- NEW --->
		<cfif form.transtype EQ 'new'>
			<tr>
				<td>New App</td>
				<td>#vsc_group#</td>
				<td>#companyshort#</td>
				<td>#studentid#</td>
				<td>#lastname#</td>
				<td>#firstname#</td>
				<td>#sex#</td>
				<td>#DateFormat(dob, 'dd/mm/yyyy')#</td>
				<td>#country_code#</td>
				<td>US</td>			
				<td align="right">#DateFormat(new_date, 'dd/mm/yyyy')#</td>
				<td align="right">#DateFormat(end_date, 'dd/mm/yyyy')#</td>
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
			<cfquery name="get_previous" datasource="MySql">
				SELECT max(insuranceid) as insuranceid
				FROM smg_insurance
				WHERE studentid = '#studentid#' 
					AND sent_to_caremed IS NOT NULL
			</cfquery>
			<cfquery name="insurance" datasource="MySql">
				SELECT insuranceid, studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, vsc_group
				FROM smg_insurance
				WHERE insuranceid = '#get_previous.insuranceid#'
			</cfquery>			
			<tr>
				<td>Cancelation</td>
				<td>#insurance.vsc_group#</td>
				<td>#companyshort#</td>
				<td>#insurance.studentid#</td>
				<td>#insurance.lastname#</td>
				<td>#insurance.firstname#</td>
				<td>#insurance.sex#</td>
				<td>#DateFormat(insurance.dob, 'dd/mm/yyyy')#</td>
				<td>#insurance.country_code#</td>
				<td>US</td>			
				<td align="right">#DateFormat(insurance.new_date, 'dd/mm/yyyy')#</td>
				<td align="right">#DateFormat(insurance.end_date, 'dd/mm/yyyy')#</td>
			</tr>			
			<tr>
				<td>Correction</td>
				<td>#vsc_group#</td>
				<td>#companyshort#</td>
				<td>#studentid#</td>
				<td><cfif insurance.lastname EQ lastname>#lastname#<cfelse><b>#lastname#</b></cfif></td>
				<td><cfif insurance.firstname EQ firstname>#firstname#<cfelse><b>#firstname#</b></cfif></td>
				<td><cfif insurance.sex EQ sex>#sex#<cfelse><b>#sex#</b></cfif></td>
				<td><cfif insurance.dob EQ dob>#DateFormat(dob, 'dd/mm/yyyy')#<cfelse><b>#DateFormat(dob, 'dd/mm/yyyy')#</b></cfif></td>
				<td><cfif insurance.country_code EQ country_code>#country_code#<cfelse><b>#country_code#</b></cfif></td>
				<td>US</td>			
				<td align="right"><cfif insurance.new_date EQ new_date>#DateFormat(new_date, 'dd/mm/yyyy')#<cfelse><b>#DateFormat(new_date, 'dd/mm/yyyy')#</b></cfif></td>
				<td align="right"><cfif insurance.end_date EQ end_date>#DateFormat(end_date, 'dd/mm/yyyy')#<cfelse><b>#DateFormat(end_date, 'dd/mm/yyyy')#</b></cfif></td>
			</tr>
		<!--- EARLY RETURN --->			
		<cfelseif form.transtype EQ 'early return'>
			<tr>
				<td>Early Return</td>
				<td>#vsc_group#</td>
				<td>#companyshort#</td>
				<td>#studentid#</td>
				<td>#lastname#</td>
				<td>#firstname#</td>
				<td>#sex#</td>
				<td>#DateFormat(dob, 'dd/mm/yyyy')#</td>
				<td>#country_code#</td>
				<td>US</td>			
				<td align="right">#DateFormat(new_date, 'dd/mm/yyyy')#</td>
				<td align="right">#DateFormat(end_date, 'dd/mm/yyyy')#</td>
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
				<td>Cancelation</td>
				<td>#vsc_group#</td>
				<td>#companyshort#</td>
				<td>#studentid#</td>
				<td>#lastname#</td>
				<td>#firstname#</td>
				<td>#sex#</td>
				<td>#DateFormat(dob, 'dd/mm/yyyy')#</td>
				<td>#country_code#</td>
				<td>US</td>			
				<td align="right">#DateFormat(new_date, 'dd/mm/yyyy')#</td>
				<td align="right">#DateFormat(end_date, 'dd/mm/yyyy')#</td>
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
				<td>Extension</td>
				<td>#vsc_group#</td>
				<td>#companyshort#</td>
				<td>#studentid#</td>
				<td>#lastname#</td>
				<td>#firstname#</td>
				<td>#sex#</td>
				<td>#DateFormat(dob, 'dd/mm/yyyy')#</td>
				<td>#country_code#</td>
				<td>US</td>			
				<td align="right">#DateFormat(new_date, 'dd/mm/yyyy')#</td>
				<td align="right">#DateFormat(end_date, 'dd/mm/yyyy')#</td>
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