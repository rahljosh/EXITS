<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- get student info --->
<cfquery name="get_students" datasource="MySQL">
	SELECT DISTINCT s.firstname, s.familylastname, s.sex, s.dob, s.studentid,
		 u.businessname, u.insurance_typeid,
		 p.insurance_startdate, p.insurance_enddate,
		 c.countrycode,
		 co.orgcode,
		 insu_codes.policycode,
		 insu.insuranceid, insu.new_date
	FROM 	smg_students s
	INNER JOIN smg_users u 		ON u.userid = s.intrep  
	INNER JOIN smg_programs p 	ON s.programid = p.programid
	LEFT JOIN smg_countrylist c 	ON s.countryresident = c.countryid
	INNER JOIN smg_companies co 	ON s.companyid = co.companyid
	LEFT JOIN smg_insurance_codes insu_codes ON (u.insurance_typeid = insu_codes.insutypeid AND s.companyid = insu_codes.companyid AND p.seasonid = insu_codes.seasonid)
	INNER JOIN smg_insurance insu ON s.studentid = insu.studentid	
	WHERE s.active = '1' 
		AND s.companyid = #client.companyid# 
		AND insu.sent_to_caremed is null
		AND insu.transtype = 'correction'
		<cfif form.programid is 0><cfelse>AND s.programid = '#form.programid#'</cfif>
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
		<td>Start Date</td>
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
		<td>AYP</td>
	</tr>
	<tr>
		<td><cfif insurance.org_code EQ orgcode>#orgcode#<cfelse><b>#orgcode#</b></cfif></td>
		<td>#insurance.policy_code#</td>
		<td>Correction</td>
		<td><cfif insurance.lastname EQ familylastname>#familylastname#<cfelse><b>#familylastname#</b></cfif></td>
		<td><cfif insurance.firstname EQ firstname>#firstname#<cfelse><b>#FirstName#</b></cfif></td>
		<td><cfif insurance.dob EQ dob>#DateFormat(dob, 'dd/mmm/yyyy')#<cfelse><b>#DateFormat(dob, 'dd/mmm/yyyy')#</b></cfif></td>
		<td><cfif insurance.sex EQ sex>#sex#<cfelse><b>#sex#</b></cfif></td>
		<td><cfif insurance.new_date EQ new_date>#DateFormat(new_date, 'dd/mmm/yyyy')#<cfelse><b>#DateFormat(new_date, 'dd/mmm/yyyy')#</b></cfif></td>
		<td><cfif insurance.end_date EQ insurance_enddate>#DateFormat(insurance_enddate, 'dd/mmm/yyyy')#<cfelse><b>#DateFormat(insurance_enddate, 'dd/mmm/yyyy')#</b></cfif></td>
		<td><cfif insurance.country_code EQ countrycode>#countrycode#<cfelse><b>#countrycode#</b></cfif></td>
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
		   end_date = #CreateODBCDate(insurance_enddate)#,
	  	   org_code = '#orgcode#',
		   <!--- policy_code = '#policycode#', --->
		  excel_spreadsheet = '1'
 	  WHERE insuranceid = #get_students.insuranceid#
	  LIMIT 1 
	</cfquery>	
	
</cfloop>
	</table>
</cfoutput> 