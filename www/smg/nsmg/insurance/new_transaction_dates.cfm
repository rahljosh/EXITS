<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- get student info --->
<cfquery name="get_students" datasource="MySQL">
  SELECT s.firstname, s.familylastname, s.sex, s.dob, s.studentid, s.companyid,
		 u.businessname, u.insurance_typeid,
		 p.insurance_startdate, p.insurance_enddate,
		 c.countrycode,
		 co.orgcode,
		 insu_codes.policycode
  FROM 	smg_students s
  INNER JOIN smg_users u 		ON u.userid = s.intrep  
  INNER JOIN smg_programs p 	ON s.programid = p.programid
  LEFT JOIN smg_countrylist c 	ON s.countryresident = c.countryid
  INNER JOIN smg_companies co 	ON s.companyid = co.companyid
  LEFT JOIN smg_insurance_codes insu_codes ON (u.insurance_typeid = insu_codes.insutypeid AND s.companyid = insu_codes.companyid AND insu_codes.seasonid = p.seasonid)
  WHERE s.active = '1' 
		AND (s.dateapplication between #CreateODBCDateTime(form.date1)# and #CreateODBCDateTime(DateAdd('d', 1, form.date2))#) 
		AND s.companyid = #client.companyid# 
		AND s.insurance IS null
		AND u.insurance_typeid between '2' AND '6'
		<!--- AND u.insurance_typeid != '1' --->
		AND s.verification_received IS NOT null
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
</cfoutput>
<cfoutput query="get_students">
	<tr>
		<td>#orgcode#</td>
		<td><cfif insurance_typeid NEQ '0'>
				#policycode#
			<cfelse>
				Missing Policy Type - #businessname#
			</cfif>
		</td>
		<td>New App</td>
		<td>#familylastname#</td>
		<td>#FirstName#</td>
		<td>#DateFormat(dob, 'dd/mmm/yyyy')#</td>
		<td>#sex#</td>
		<td>#DateFormat(insurance_startdate, 'dd/mmm/yyyy')#</td>
		<td>#DateFormat(insurance_enddate, 'dd/mmm/yyyy')#</td>
		<td>#countrycode#</td>
		<td>US</td>
		<td>AYP</td>
	</tr>
 	<cfif insurance_typeid EQ '0' or insurance_startdate is '' or insurance_enddate is ''>
	<cfelse> 
			<cfquery name="check_history" datasource="MySql">
				SELECT insuranceid, studentid
				FROM smg_insurance
				WHERE studentid = '#studentid#' AND transtype = 'new' AND sent_to_caremed IS NULL
			</cfquery>
			<cfif check_history.recordcount EQ '0'>
				<!--- CREATE HISTORY FILE --->
				<cfquery name="insert_history" datasource="MySql">
					INSERT INTO smg_insurance
						(companyid, studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code, transtype, excel_spreadsheet)
					VALUES
						('#get_students.companyid#', '#studentid#', '#firstname#', '#familylastname#', '#sex#', #CreateODBCDate(dob)#, '#countrycode#',
						#CreateODBCDate(insurance_startdate)#, #CreateODBCDate(insurance_enddate)#, '#orgcode#', '#policycode#', 'new', '1');	
				</cfquery>
			<cfelse>
				<!--- UPDATE HISTORY FILE --->
				<cfquery name="insert_history" datasource="MySql">
					UPDATE smg_insurance
					SET firstname = '#firstname#',
						lastname = '#familylastname#',
						sex = '#sex#',
						dob = #CreateODBCDate(dob)#,
						country_code = '#countrycode#',
						new_date = #CreateODBCDate(insurance_startdate)#,
						end_date = #CreateODBCDate(insurance_enddate)#,
						org_code = '#orgcode#',
						policy_code = '#policycode#'
					WHERE insuranceid = '#check_history.insuranceid#'
					LIMIT 1
				</cfquery>			
			</cfif>
	</cfif>	
</cfoutput>
<cfoutput>
	</table>
</cfoutput> 