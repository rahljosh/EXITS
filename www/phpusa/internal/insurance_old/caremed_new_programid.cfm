<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!---
ACTIVE AREAREPID ASSIGNEDID CANCELDATE CANCELEDBY CANCELREASON COMPANYID DATECREATED DATEPLACED DOUBLEPLACE HF_APPLICATION HF_PLACEMENT HOSTID I20NO I20RECEIVED I20SENT INPUTBY PLACEREPID PROGRAMID SCHOOLID SCHOOL_ACCEPTANCE SEVIS_FEE_PAID STUDENTID TRANSFER_TYPE 
--->

<!--- get student info --->
<cfquery name="get_students" datasource="MySQL">
  SELECT s.firstname, s.familylastname, s.sex, s.dob, s.studentid,
  		 stu_prog.assignedid, stu_prog.programid, stu_prog.schoolid,
		 u.businessname, u.php_insurance_typeid,
		 p.startdate, p.enddate, p.seasonid,
		 c.countrycode,
		 co.orgcode,
		 insu_codes.policycode
  FROM 	smg_students s
  INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
  INNER JOIN smg_users u 		ON s.intrep = u.userid 
  INNER JOIN smg_programs p 	ON p.programid = stu_prog.programid
  LEFT JOIN smg_countrylist c 	ON c.countryid = s.countryresident
  INNER JOIN smg_companies co 	ON co.companyid = stu_prog.companyid
  LEFT JOIN smg_insurance_codes insu_codes ON (u.php_insurance_typeid = insu_codes.insutypeid AND stu_prog.companyid = insu_codes.companyid AND insu_codes.seasonid = p.seasonid)
  WHERE stu_prog.active = '1' 
		AND stu_prog.insurancedate IS NULL
		AND u.php_insurance_typeid between '2' AND '6'
		AND ( <cfloop list="#form.programid#" index="program">
				 stu_prog.programid = #program# 
				<cfif program is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
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

<cfset start_date = ''>
<cfset end_date = ''>

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

		<cfquery name="get_arrival" datasource="MySql">
			SELECT dep_date
			FROM smg_flight_info
			WHERE studentid =  '#studentid#'
				AND flight_type = 'arrival'
				AND companyid = '#client.companyid#'	
			ORDER BY dep_date			
		</cfquery>
		
		<cfquery name="get_departure" datasource="MySql">
			SELECT dep_date
			FROM smg_flight_info
			WHERE studentid =  '#studentid#'
				AND flight_type = 'departure'
				AND companyid = '#client.companyid#'	
			ORDER BY dep_date			
		</cfquery>
		
		<cfquery name="get_school_dates" datasource="MySql">
			SELECT schoolid, seasonid, semester_begins, semester_ends, year_begins, year_ends
			FROM php_school_dates
			WHERE schoolid = '#schoolid#'
				AND seasonid = '#seasonid#'
		</cfquery>
	
		<!--- START DATE --->
		<cfif get_arrival.dep_date NEQ ''>
			<cfset start_date = '#DateFormat(get_arrival.dep_date, 'dd/mmm/yyyy')#'>	
		<cfelseif DateFormat(startdate,'mm') EQ 7 AND get_school_dates.year_begins NEQ ''>	
			<cfset start_date = '#DateFormat(DateAdd('d', -7, get_school_dates.year_begins), 'dd/mmm/yyyy')#'>
		<cfelseif DateFormat(startdate,'mm') EQ 1 AND get_school_dates.semester_begins NEQ ''>
			<cfset start_date = '#DateFormat(DateAdd('d', -7, get_school_dates.semester_begins), 'dd/mmm/yyyy')#'>
		<cfelse>
			<cfset start_date = '#DateFormat(start_date, 'dd/mmm/yyyy')#'>
		</cfif>
		<cfif start_date LT now()>
			<cfset start_date = '#DateFormat(now(), 'dd/mmm/yyyy')#'>
		</cfif>
		<!--- END DATE --->	
		<cfif DateFormat(enddate,'mm') EQ 1 AND get_school_dates.semester_ends NEQ ''>	
			<cfset end_date = '#DateFormat(DateAdd('d', 7, get_school_dates.semester_ends), 'dd/mmm/yyyy')#'>
		<cfelseif DateFormat(enddate,'mm') EQ 6 AND get_school_dates.year_ends NEQ ''>
			<cfset end_date = '#DateFormat(DateAdd('d', 7, get_school_dates.year_ends), 'dd/mmm/yyyy')#'>
		<cfelseif DateFormat(enddate,'mm') EQ 1>
			<cfset end_date = '01-15-#DateFormat(enddate,'yyyy')#'>
		<cfelseif DateFormat(enddate,'mm') EQ 6> 	
			<cfset end_date = '06-01-#DateFormat(enddate,'yyyy')#'>
		</cfif>	
		
		<!--- <cfif get_arrival.dep_date NEQ ''> --->
			<tr>
				<td>#orgcode#</td>
				<td><cfif php_insurance_typeid NEQ '0'>07709020-401<!--- #policycode# ---><cfelse>Missing Policy Type - #businessname#</cfif></td>
				<td>New App</td>
				<td>#familylastname#</td>
				<td>#FirstName#</td>
				<td>#DateFormat(dob, 'dd/mmm/yyyy')#</td>
				<td>#sex#</td>
				<td>#start_date#</td>
				<td>#end_date#</td>
				<td>#countrycode#</td>
				<td>US</td>
				<td>AYP</td>
			</tr>
			<!--- update only if there is insurance information --->
			<cfif start_date NEQ '' AND end_date NEQ '' AND dob NEQ '' AND php_insurance_typeid NEQ 0>
				<cfquery name="update_students" datasource="MySql">
					UPDATE php_students_in_program 
					SET insurancedate = #CreateODBCDate(now())# 
					WHERE assignedid = '#get_students.assignedid#'
					LIMIT 1
				</cfquery>
				<!--- CREATE HISTORY FILE --->
				<cfquery name="insert_history" datasource="MySql">
					INSERT INTO smg_insurance
						(companyid, studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code, sent_to_caremed, 
						transtype, excel_spreadsheet)
					VALUES
						('6', '#studentid#', '#firstname#', '#familylastname#', '#sex#', #CreateODBCDate(dob)#, '#countrycode#',
						#CreateODBCDate(start_date)#, #CreateODBCDate(end_date)#, #orgcode#, '07709020-401',
						#CreateODBCDate(now())#, 'new', '1');	
				</cfquery>
			</cfif>
		<!--- </cfif> --->
	</cfloop>
</table>
</cfoutput> 