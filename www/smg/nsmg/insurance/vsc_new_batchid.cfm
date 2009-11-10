<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>New Transaction Insurance</title>
</head>

<body>

<cfif NOT IsDefined('form.programid')>
	Please select at least one program.
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
<cfquery name="get_students" datasource="MySQL">
  SELECT s.firstname, s.familylastname, s.sex, s.dob, s.studentid, aypenglish, ayporientation,
		 u.businessname, u.insurance_typeid,
		 p.insurance_startdate, p.insurance_enddate,
		 c.countrycode, c.countryname,
		 comp.companyshort
  FROM 	smg_students s
  INNER JOIN smg_users u 		ON u.userid = s.intrep  
  INNER JOIN smg_programs p 	ON s.programid = p.programid
  INNER JOIN smg_companies comp ON comp.companyid = s.companyid
  LEFT JOIN smg_countrylist c 	ON s.countryresident = c.countryid
  WHERE s.active = '1' 
		AND s.insurance IS NULL 
		AND u.insurance_typeid = '#form.insurance_typeid#'
		<cfif form.programid NEQ 0>AND s.programid = '#form.programid#'</cfif>
		AND ( <cfloop list="#form.batchid#" index="batch">
				 s.sevis_batchid = '#batch#' 
				<cfif batch is #ListLast(form.batchid)#><Cfelse>or</cfif>
			</cfloop> )
  ORDER BY s.sevis_batchid, u.businessname, s.firstname  
</cfquery>

<cfset group = ''>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=vsc_insurance.xls"> 

<!--- <cfheader name="Content-Disposition"filename=caremed_template.xls">  Open in the Browser --->

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
<cfoutput>
	<table border="0" cellpadding="3" cellspacing="0">
		<tr><td colspan="8"><b>Student Management Group #get_insu_policy.type#</b></td></tr>
	</table><br>
	<table border="1" cellpadding="3" cellspacing="0">
		<tr>
			<td>(N/X)</td>
			<td>Group</td>
			<td>SMG Company</td>
			<td>Student ID</td>
			<td>Last Name</td>
			<td>First Name</td>
			<td>Gender</td>
			<td>Date of Birth (mm/dd/yy)</td>
			<td>Country of Origin</td>
			<td>Country of Destination</td>
			<td>Effective Date (mm/dd/yy)</td>
			<td>Termination Date (mm/dd/yy)</td>
		</tr>
		
		<cfloop query="get_students">
			
			<!--- GET START DATE --->
			<cfquery name="get_flight_info" datasource="MySql">
				SELECT dep_date
				FROM smg_flight_info
				WHERE studentid =  '#studentid#'
					AND flight_type = 'arrival'	
				ORDER BY dep_date DESC			
			</cfquery>
			
			<!--- ONLY WITH FLIGH CONFIRMATION --->
			<cfif IsDefined('form.flight')>
				<cfif get_flight_info.recordcount>
					<cfset new_startdate = '#DateFormat(get_flight_info.dep_date, 'mm/dd/yy')#'>
					<!--- GET GROUP --->
					<cfquery name="get_group" datasource="MySql">
						SELECT groupid, insutypeid, vsc_group
						FROM smg_insurance_vsc_group
						WHERE insutypeid = 	'#insurance_typeid#'
							AND MONTH(startdate) = #DateFormat(new_startdate, 'mm')#
							AND YEAR(startdate) = #DateFormat(new_startdate, 'yyyy')#
					</cfquery>
					<tr>
						<td>New</td>
						<td>#get_group.vsc_group#</td>
						<td>#companyshort#</td>
						<td>#studentid#</td>
						<td>#familylastname#</td>
						<td>#FirstName#</td>
						<td>#sex#</td>
						<td>#DateFormat(dob, 'mm/dd/yy')#</td>
						<td>#countryname#</td>
						<td>United States</td>
						<td>#new_startdate#</td>
						<td>#DateFormat(insurance_enddate, 'mm/dd/yy')#</td>
					</tr>
					<cfquery name="update_students" datasource="MySql">
						UPDATE smg_students 
						SET insurance = #CreateODBCDate(now())# 
						WHERE studentid = #get_students.studentid#
					</cfquery>
					<!--- CREATE HISTORY FILE --->
					<cfquery name="insert_history" datasource="MySql">
						INSERT INTO smg_insurance
							(companyid, studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, policy_code, sent_to_caremed, vsc_group,
							transtype, excel_spreadsheet)
						VALUES
							('#companyid#', '#studentid#', '#firstname#', '#familylastname#', '#sex#', #CreateODBCDate(dob)#, '#countryname#',
							#CreateODBCDate(new_startdate)#, #CreateODBCDate(insurance_enddate)#, '#insurance_typeid#',
							#CreateODBCDate(now())#, '#get_group.vsc_group#', 'new', '1');	
					</cfquery>	
				</cfif>
						
			<!--- ALL STUDENTS --->
			<cfelse>
				<cfif get_flight_info.recordcount>
					<cfset new_startdate = DateFormat(get_flight_info.dep_date, 'mm/dd/yy')>
				<cfelse>
					<cfset new_startdate = DateFormat(insurance_startdate, 'mm/dd/yy')>
				</cfif>
				
				<!--- GET GROUP --->
				<cfquery name="get_group" datasource="MySql">
					SELECT groupid, insutypeid, vsc_group
					FROM smg_insurance_vsc_group
					WHERE insutypeid = 	'#insurance_typeid#'
						AND MONTH(startdate) = #DateFormat(new_startdate, 'mm')#
						AND YEAR(startdate) = #DateFormat(new_startdate, 'yyyy')#
				</cfquery>
				<tr>
					<td>New</td>
					<td>#get_group.vsc_group#</td>
					<td>#companyshort#</td>
					<td>#studentid#</td>
					<td>#familylastname#</td>
					<td>#FirstName#</td>
					<td>#sex#</td>
					<td>#DateFormat(dob, 'mm/dd/yy')#</td>
					<td>#countryname#</td>
					<td>United States</td>
					<td>#new_startdate#</td>
					<td>#DateFormat(insurance_enddate, 'mm/dd/yy')#</td>
				</tr>
				<cfquery name="update_students" datasource="MySql">
					UPDATE smg_students 
					SET insurance = #CreateODBCDate(now())# 
					WHERE studentid = #get_students.studentid#
				</cfquery>
				<!--- CREATE HISTORY FILE --->
				<cfquery name="insert_history" datasource="MySql">
					INSERT INTO smg_insurance
						(companyid, studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, policy_code, sent_to_caremed, vsc_group,
						transtype, excel_spreadsheet)
					VALUES
						('#companyid#', '#studentid#', '#firstname#', '#familylastname#', '#sex#', #CreateODBCDate(dob)#, '#countryname#',
						#CreateODBCDate(new_startdate)#, #CreateODBCDate(insurance_enddate)#, '#insurance_typeid#',
						#CreateODBCDate(now())#, '#get_group.vsc_group#', 'new', '1');	
				</cfquery>		
			</cfif>		
		</cfloop>
	</table>
</cfoutput> 

</body>
</html>
