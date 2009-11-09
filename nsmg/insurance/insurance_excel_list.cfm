<br>
<cfif not isDefined('url.insudate') or not IsDefined('url.batchid')>
	<table align="center" width="90%" frame="box">
	<tr><th colspan="2">It was not possible to print out your report. One error has ocurred. Please go back and re-submit it.</th></tr>
	</table>
<cfelse>
	<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
	<cfsetting enablecfoutputonly="Yes">
	
	<cfinclude template="../querys/get_company_short.cfm">
	
	<!-- get student list -->
	<cfquery name="get_students" datasource="MySql"> 
		SELECT 	s.studentid, s.firstname, s.familylastname, s.middlename, s.sex, s.dob,
				p.insurance_startdate, p.insurance_enddate,
				u.businessname, u.insurance_policy_type,
				c.countrycode,
				co.orgcode, co.insurance_policy_non_ded, co.insurance_policy_deductible, co.insurance_policy_gold 
		FROM smg_students s
		INNER JOIN smg_users u 		ON u.userid = s.intrep
		INNER JOIN smg_programs p 	ON s.programid = p.programid
		INNER JOIN smg_countrylist c 	ON s.countryresident = c.countryid
		INNER JOIN smg_companies co 	ON s.companyid = co.companyid
		WHERE insurance = #CreateODBCDate(url.insudate)# AND s.companyid = '#client.companyid#' 
			  AND sevis_batchid = '#url.batchid#'	
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
		<td>Transaction Type</td>
		<td>First Name</td>
		<td>Last Name</td>
		<td>Sex</td>
		<td>DOB</td>
		<td>Country Code</td>
		<td>Destination</td>
		<td>Start Date</td>
		<td>Return Date</td>
		<td>Org. Code</td>
		<td>Policy Code</td>
	</tr>
</cfoutput>
<cfoutput query="get_students">
	<tr>
		<td>New App</td>
		<td>#FirstName#</td>
		<td>#familylastname#</td>
		<td>#sex#</td>
		<td>#DateFormat(dob, 'dd/mmm/yyyy')#</td>
		<td>#countrycode#</td>
		<td>US</td>
		<td>#DateFormat(insurance_startdate, 'dd/mmm/yyyy')#</td>
		<td>#DateFormat(insurance_enddate, 'dd/mmm/yyyy')#</td>
		<td>#orgcode#</td>
		<td><cfif insurance_policy_type is 'non-deductible'>
				#insurance_policy_non_ded#
			<cfelseif insurance_policy_type is 'deductible'>
				#insurance_policy_deductible#
			<cfelseif insurance_policy_type is 'gold'>
				#insurance_policy_gold#
			<cfelse>
				Missing Policy Type
			</cfif>
		</td>
	</tr>
</cfoutput>
<cfoutput>
	</table>
</cfoutput> 

</cfif>