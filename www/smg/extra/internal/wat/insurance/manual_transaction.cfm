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

<!--- get student info --->
<cfquery name="get_candidates" datasource="MySQL">
	SELECT c.candidateid, c.firstname, c.lastname, c.sex, c.dob,
		u.businessname, u.extra_insurance_typeid,
		country.countrycode,
		comp.orgcode,
		insu_codes.policycode,
		h.insuranceid, h.start_date, h.end_date
	FROM extra_candidates c
	INNER JOIN smg_users u ON u.userid = c.intrep
	INNER JOIN smg_companies comp ON comp.companyid = c.companyid
	LEFT JOIN smg_countrylist country ON country.countryid =  c.residence_country
	LEFT JOIN smg_insurance_codes insu_codes ON (u.extra_insurance_typeid = insu_codes.insutypeid AND c.companyid = insu_codes.companyid)
	INNER JOIN extra_insurance_history h ON c.candidateid = h.candidateid
	WHERE h.filed_date IS NULL
		AND h.transtype = '#form.transtype#'
 	ORDER BY u.businessname, c.firstname
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
		<td colspan="7"><center><b>Student Management Group (Comfort 50)</b></center></td>
	</tr>
	<tr>
		<td>Transaction Type</td>
		<td>IHI Policy Number</td>
		<td>Last Name</td>
		<td>First Name</td>
		<td>Birth Date</td>
		<td>Start Date</td>
		<td>End Date</td>
	  </tr>
	<cfloop query="get_candidates">
		<cfquery name="get_previous" datasource="MySql">
			SELECT max(insuranceid) as insuranceid
			FROM extra_insurance_history
			WHERE candidateid = '#candidateid#' 
				AND filed_date IS NOT NULL
		</cfquery>
		
		<cfquery name="insurance" datasource="MySql">
			SELECT insuranceid, candidateid, firstname, lastname, sex, dob, country_code, start_date, end_date, org_code, policy_code
			FROM extra_insurance_history
			WHERE insuranceid = '#get_previous.insuranceid#'
		</cfquery>		
		
		<!--- NEW --->
		<cfif form.transtype EQ 'new'>
			<tr>
				<td>N</td>
				<td>#policycode#</td>
				<td>#lastname#</td>
				<td>#FirstName#</td>
				<td>#DateFormat(dob, 'dd/mmm/yyyy')#</td>
				<td>#DateFormat(start_date, 'dd/mmm/yyyy')#</td>
				<td>#DateFormat(end_date, 'dd/mmm/yyyy')#</td>
			</tr>
			<cfquery name="update_candidate" datasource="MySql">
				UPDATE extra_candidates 
				SET insurance_date = #CreateODBCDate(now())#,
					insurance_cancel_date = NULL
				WHERE candidateid = '#candidateid#'
				LIMIT 1
			</cfquery>	
		<!--- CORRECTION --->			
		<cfelseif form.transtype EQ 'correction'>
			<tr>
				<td>X</td>
				<td>#insurance.policy_code#</td>
				<td>#insurance.lastname#</td>
				<td>#insurance.firstname#</td>
				<td>#DateFormat(insurance.dob, 'dd/mmm/yyyy')#</td>
				<td>#DateFormat(insurance.start_date, 'dd/mmm/yyyy')#</td>
				<td>#DateFormat(insurance.end_date, 'dd/mmm/yyyy')#</td>
			</tr>

			<tr>
				<td>Correction</td>
				<td>#insurance.policy_code#</td>
				<td><cfif insurance.lastname EQ lastname>#lastname#<cfelse><b>#lastname#</b></cfif></td>
				<td><cfif insurance.firstname EQ firstname>#firstname#<cfelse><b>#firstname#</b></cfif></td>
				<td><cfif insurance.dob EQ dob>#DateFormat(dob, 'dd/mmm/yyyy')#<cfelse><b>#DateFormat(dob, 'dd/mmm/yyyy')#</b></cfif></td>
				<td><cfif insurance.start_date EQ start_date>#DateFormat(start_date, 'dd/mmm/yyyy')#<cfelse><b>#DateFormat(start_date, 'dd/mmm/yyyy')#</b></cfif></td>
				<td><cfif insurance.end_date EQ end_date>#DateFormat(end_date, 'dd/mmm/yyyy')#<cfelse><b>#DateFormat(end_date, 'dd/mmm/yyyy')#</b></cfif></td>
			</tr>
		<!--- EARLY RETURN --->			
		<cfelseif form.transtype EQ 'early return'>
			<tr>
				<td>Early Return</td>
				<td>#insurance.policy_code#</td>
				<td>#lastname#</td>
				<td>#firstname#</td>
				<td>#DateFormat(dob, 'dd/mmm/yyyy')#</td>
				<td>#DateFormat(start_date, 'dd/mmm/yyyy')#</td>
				<td>#DateFormat(end_date, 'dd/mmm/yyyy')#</td>
			</tr>
			<cfquery name="update_candidate" datasource="MySql">
				UPDATE extra_candidates 
				SET insurance_cancel_date = #CreateODBCDate(now())# 
				WHERE candidateid = '#candidateid#'
				LIMIT 1
			</cfquery>				
		<!--- CANCELATION --->	
		<cfelseif form.transtype EQ 'cancellation'>
			<tr>
				<td>X</td>
				<td>#insurance.policy_code#</td>
				<td>#lastname#</td>
				<td>#firstname#</td>
				<td>#DateFormat(dob, 'dd/mmm/yyyy')#</td>
				<td>#DateFormat(start_date, 'dd/mmm/yyyy')#</td>
				<td>#DateFormat(end_date, 'dd/mmm/yyyy')#</td>
			</tr>
			<cfquery name="update_candidate" datasource="MySql">
				UPDATE extra_candidates 
				SET insurance_cancel_date = #CreateODBCDate(now())# 
				WHERE candidateid = '#candidateid#'
				LIMIT 1
			</cfquery>				
		<!--- EXTENSION --->	
		<cfelseif form.transtype EQ 'extension'>
			<tr>
				<td>Extension</td>
				<td>#insurance.policy_code#</td>
				<td>#lastname#</td>
				<td>#firstname#</td>
				<td>#DateFormat(dob, 'dd/mmm/yyyy')#</td>
				<td>#DateFormat(start_date, 'dd/mmm/yyyy')#</td>
				<td>#DateFormat(end_date, 'dd/mmm/yyyy')#</td>
			</tr>
		</cfif>	
		<!--- UPDATE INSURANCE HISTORY --->	
		<cfquery name="update" datasource="MySQL">  
			UPDATE extra_insurance_history
			SET firstname = '#firstname#',
				lastname = '#lastname#',
				sex = '#sex#',
				dob = #CreateODBCDate(dob)#,
				country_code = '#countrycode#',
				org_code = '#orgcode#',
				policy_code = '#insurance.policy_code#',
				filed_date = #CreateODBCDate(now())#,
				excel_sheet = '1'
			WHERE insuranceid = '#insuranceid#'
			LIMIT 1 
		</cfquery>				
	</cfloop>
</table>
</cfoutput> 

</body>
</html>