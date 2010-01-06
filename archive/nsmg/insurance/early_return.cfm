<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- get student info --->
<cfquery name="get_students" datasource="MySQL">
	SELECT s.firstname, s.familylastname, s.sex, s.dob, s.studentid,
		 u.businessname, u.insurance_typeid,
		 p.insurance_startdate, p.insurance_enddate,
		 c.countrycode,
		 co.orgcode,
		 insu.insuranceid, insu.new_date
	FROM 	smg_students s
	INNER JOIN smg_users u 			ON u.userid = s.intrep  
	INNER JOIN smg_programs p 		ON s.programid = p.programid
	LEFT JOIN smg_countrylist c 	ON s.countryresident = c.countryid
	INNER JOIN smg_companies co 	ON s.companyid = co.companyid
	INNER JOIN smg_insurance insu ON s.studentid = insu.studentid	
	WHERE s.companyid = #client.companyid# 
		AND insu.sent_to_caremed is null
		AND insu.transtype = 'early return'
		<cfif form.programid NEQ 0>AND s.programid = '#form.programid#'</cfif>
	ORDER BY u.businessname, s.firstname
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
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
		<td>Departure Date</td>
		<td>End Date</td>
		<td>Country of Origin</td>
		<td>Country of Destination</td>
		<td>Program Type</td>
	</tr>
<cfloop query="get_students">
	<cfquery name="get_previous" datasource="MySql">
		SELECT max(insuranceid) as insuranceid
		FROM smg_insurance
		WHERE studentid = '#get_students.studentid#' AND smg_insurance.sent_to_caremed IS NOT NULL
	</cfquery>
	<cfquery name="insurance" datasource="MySql">
		SELECT insuranceid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code
		FROM smg_insurance
		WHERE smg_insurance.insuranceid = '#get_previous.insuranceid#'
	</cfquery>
	<tr>
		<td>#orgcode#</td>
		<td>#insurance.policy_code#</td>
		<td>Early Return</td>
		<td>#familylastname#</td>
		<td>#FirstName#</td>
		<td>#DateFormat(dob, 'dd/mmm/yyyy')#</td>
		<td>#sex#</td>
		<td>#DateFormat(new_date, 'dd/mmm/yyyy')#</td>
		<td>#DateFormat(insurance.end_date, 'dd/mmm/yyyy')#</td>
		<td>#countrycode#</td>
		<td>US</td>
		<td>AYP</td>
	</tr>
	<!--- UPDATE INSURANCE HISTORY --->
	<cfquery name="update_students" datasource="MySQL">  
	  UPDATE smg_insurance
	  SET  firstname = '#firstname#',
	  	   lastname = '#familylastname#',
		   sex = '#sex#',
		   dob = #CreateODBCDate(dob)#,
		   country_code = '#countrycode#',
		   end_date = #CreateODBCDate(insurance.end_date)#,
	  	   org_code = '#orgcode#',
		   policy_code = '#insurance.policy_code#',
		   excel_spreadsheet = '1'
 	  WHERE insuranceid = #insuranceid#
	  LIMIT 1 
	</cfquery>	
</cfloop>
	</table>
</cfoutput> 
