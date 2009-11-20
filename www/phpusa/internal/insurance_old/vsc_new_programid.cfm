<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>VSC New Program Insurance</title>
</head>

<body>

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<cfquery name="get_insu_policy" datasource="MySql">
	SELECT insutypeid, type 
	FROM smg_insurance_type
	WHERE insutypeid = '#form.php_insurance_typeid#'
</cfquery>

<!--- get student info --->
<cfquery name="get_students" datasource="MySQL">
  SELECT s.firstname, s.familylastname, s.sex, s.dob, s.studentid,
  		 stu_prog.assignedid, stu_prog.programid, stu_prog.schoolid,
		 u.businessname, u.php_insurance_typeid,
		 p.startdate, p.enddate, p.seasonid,
		 c.countrycode, c.countryname,
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
	AND u.php_insurance_typeid = '#form.php_insurance_typeid#'
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

<cfset new_startdate = ''>
<cfset new_end_date = ''>

<table border="0" cellpadding="3" cellspacing="0">
	<tr><td colspan="9"><b>Student Management Group Policy #get_insu_policy.type#</b></td></tr>
</table><br>

<table border="1" cellpadding="3" cellspacing="0">
	<tr>
		<td>(N/X)</td>
		<td>Group</td>
		<td>CompanyID</td>
		<td>Student ID</td>
		<td>Last Name</td>
		<td>First Name</td>
		<td>Gender</td>
		<td>Date of Birth</td>
		<td>Country of Origin</td>
		<td>Country of Destination</td>
		<td>Effective Date (mm/dd/yyyy)</td>
		<td>Termination Date (mm/dd/yyyy)</td>
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
	
		<!--- GET START DATE --->
		<cfif get_arrival.dep_date NEQ ''>
			<cfset new_startdate = '#DateFormat(get_arrival.dep_date, 'mm/dd/yyyy')#'>	
		<cfelseif DateFormat(startdate,'mm') EQ 7 AND get_school_dates.year_begins NEQ ''>	
			<cfset new_startdate = '#DateFormat(DateAdd('d', -7, get_school_dates.year_begins), 'mm/dd/yyyy')#'>
		<cfelseif DateFormat(startdate,'mm') EQ 1 AND get_school_dates.semester_begins NEQ ''>
			<cfset new_startdate = '#DateFormat(DateAdd('d', -7, get_school_dates.semester_begins), 'mm/dd/yyyy')#'>
		<cfelse>
			<cfset new_startdate = '#DateFormat(startdate, 'mm/dd/yyyy')#'>
		</cfif>
		<cfif new_startdate LT now()>
			<cfset new_startdate = '#DateFormat(now(), 'mm/dd/yyyy')#'>
		</cfif>	
		<!--- GET GROUP --->
		<cfquery name="get_group" datasource="MySql">
			SELECT groupid, insutypeid, vsc_group
			FROM smg_insurance_vsc_group
			WHERE insutypeid = 	'#php_insurance_typeid#'
				AND MONTH(startdate) = #DateFormat(new_startdate, 'mm')#
				AND YEAR(startdate) = #DateFormat(new_startdate, 'yyyy')#
		</cfquery>
		<!--- GET END DATES --->
		<cfif DateFormat(enddate,'mm') EQ 1 AND get_school_dates.semester_ends NEQ ''>	
			<cfset new_end_date = '#DateFormat(DateAdd('d', 7, get_school_dates.semester_ends), 'mm/dd/yyyy')#'>
		<cfelseif DateFormat(enddate,'mm') EQ 6 AND get_school_dates.year_ends NEQ ''>
			<cfset new_end_date = '#DateFormat(DateAdd('d', 7, get_school_dates.year_ends), 'mm/dd/yyyy')#'>
		<cfelseif DateFormat(enddate,'mm') EQ 1>
			<cfset new_end_date = '01-15-#DateFormat(enddate,'yyyy')#'>
		<cfelseif DateFormat(enddate,'mm') EQ 6> 	
			<cfset new_end_date = '06-01-#DateFormat(enddate,'yyyy')#'>
		</cfif>						
		<tr>
			<td>N</td>
			<td>#get_group.vsc_group#</td>
			<td>PHP</td>
			<td>#studentid#</td>				
			<td>#familylastname#</td>
			<td>#FirstName#</td>
			<td>#sex#</td>
			<td>#DateFormat(dob, 'mm/dd/yyyy')#</td>
			<td>#countryname#</td>
			<td>United States</td>
			<td>#new_startdate#</td>
			<td>#new_end_date#</td>
		</tr>
		<!--- update only if there is insurance information --->
		<cfif new_startdate NEQ '' AND new_end_date NEQ '' AND dob NEQ ''>
			<cfquery name="update_students" datasource="MySql">
				UPDATE php_students_in_program 
				SET insurancedate = #CreateODBCDate(now())# 
				WHERE assignedid = '#get_students.assignedid#'
				LIMIT 1
			</cfquery>
			<!--- CREATE HISTORY FILE --->
			<cfquery name="insert_history" datasource="MySql">
				INSERT INTO smg_insurance
					(studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, policy_code, sent_to_caremed, 
					transtype, excel_spreadsheet)
				VALUES
					('#studentid#', '#firstname#', '#familylastname#', '#sex#', #CreateODBCDate(dob)#, '#countryname#',
					#CreateODBCDate(new_startdate)#, #CreateODBCDate(new_end_date)#, '#php_insurance_typeid#',
					#CreateODBCDate(now())#, 'new', '1');	
			</cfquery>
		</cfif>
	</cfloop>
</table>
</cfoutput> 

</body>
</html>
