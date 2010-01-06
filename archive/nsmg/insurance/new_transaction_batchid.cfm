<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- get student info --->
<cfquery name="get_students" datasource="MySQL">
  SELECT s.firstname, s.familylastname, s.sex, s.dob, s.studentid,
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
		AND s.insurance is null
		AND u.insurance_typeid between '2' AND '6'
		<!--- AND u.insurance_typeid != '1' --->
		<cfif form.programid is 0><cfelse>AND s.programid = '#form.programid#'</cfif>
		AND ( <cfloop list=#form.batchid# index='batch'>
				 s.sevis_batchid = #batch# 
				<cfif batch is #ListLast(form.batchid)#><Cfelse>or</cfif>
			</cfloop> )
  ORDER BY s.sevis_batchid, u.businessname, s.firstname
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

<cfset start_date = ''>
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

		<cfquery name="get_flight_info" datasource="MySql">
			SELECT dep_date
			FROM smg_flight_info
			WHERE studentid =  '#studentid#'
				AND flight_type = 'arrival'	
			ORDER BY dep_date			
		</cfquery>
	
		<cfif IsDefined('form.flight')>	
			<cfif get_flight_info.dep_date NEQ ''>
				<tr>
					<td>#orgcode#</td>
					<td><cfif insurance_typeid NEQ '0'>#policycode#<cfelse>Missing Policy Type - #businessname#</cfif></td>
					<td>New App</td>
					<td>#familylastname#</td>
					<td>#FirstName#</td>
					<td>#DateFormat(dob, 'dd/mmm/yyyy')#</td>
					<td>#sex#</td>
					<td>#DateFormat(get_flight_info.dep_date, 'dd/mmm/yyyy')#</td>
					<td>#DateFormat(insurance_enddate, 'dd/mmm/yyyy')#</td>
					<td>#countrycode#</td>
					<td>US</td>
					<td>AYP</td>
				</tr>
				<!--- update only if there is insurance information --->
				<cfif insurance_typeid NEQ '0' AND insurance_enddate NEQ ''>
					<cfquery name="update_students" datasource="MySql">
						UPDATE smg_students 
						SET insurance = #CreateODBCDate(now())# 
						WHERE studentid = #get_students.studentid#
					</cfquery>
					<!--- CREATE HISTORY FILE --->
					<cfquery name="insert_history" datasource="MySql">
						INSERT INTO smg_insurance
							(companyid, studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code, sent_to_caremed, 
							transtype, excel_spreadsheet)
						VALUES
							('#client.companyid#', '#studentid#', '#firstname#', '#familylastname#', '#sex#', #CreateODBCDate(dob)#, '#countrycode#',
							#CreateODBCDate(get_flight_info.dep_date)#, #CreateODBCDate(insurance_enddate)#, '#orgcode#', '#policycode#',
							#CreateODBCDate(now())#, 'new', '1');	
					</cfquery>
				</cfif>
			</cfif>
		<cfelse>
			<tr>
				<td>#orgcode#</td>
				<td><cfif insurance_typeid NEQ '0'>#policycode#<cfelse>Missing Policy Type - #businessname#</cfif></td>
				<td>New App</td>
				<td>#familylastname#</td>
				<td>#FirstName#</td>
				<td>#DateFormat(dob, 'dd/mmm/yyyy')#</td>
				<td>#sex#</td>
				<td><cfif insurance_startdate LT now()>
						<cfset start_date = '#DateFormat(now(), 'dd/mmm/yyyy')#'>
					<cfelse>
						<cfset start_date = '#DateFormat(insurance_startdate, 'dd/mmm/yyyy')#'> 
					</cfif>
					#start_date#
				</td>
				<td>#DateFormat(insurance_enddate, 'dd/mmm/yyyy')#</td>
				<td>#countrycode#</td>
				<td>US</td>
				<td>AYP</td>
			</tr>
			<!--- update only if there is insurance information --->
			<cfif insurance_typeid NEQ '0' AND start_date NEQ '' AND insurance_enddate NEQ ''>
				<cfquery name="update_students" datasource="MySql">
					UPDATE smg_students 
					SET insurance = #CreateODBCDate(now())# 
					WHERE studentid = #get_students.studentid#
				</cfquery>
				<!--- CREATE HISTORY FILE --->
				<cfquery name="insert_history" datasource="MySql">
					INSERT INTO smg_insurance
						(companyid, studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code, sent_to_caremed, 
						transtype, excel_spreadsheet)
					VALUES
						('#get_students.companyid#', '#studentid#', '#firstname#', '#familylastname#', '#sex#', #CreateODBCDate(dob)#, '#countrycode#',
						#CreateODBCDate(start_date)#, #CreateODBCDate(insurance_enddate)#, '#orgcode#', '#policycode#',
						#CreateODBCDate(now())#, 'new', '1');	
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
</table>
</cfoutput> 