<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfif form.programid is 'zero'>
	<span class="application_section_header"><cfoutput>#companyshort.companyshort# Insurance Students List</cfoutput></span>
	<br>
	<table width=80% cellpadding=6 cellspacing="0" align="center" frame="box">	
		<tr><td><font color="FF0000">You need to select a program in order to proceed. Please go back and select it.</font></td></tr>
	</table>
<cfelse>
	<cfquery name="get_students" datasource="MySQL">
	  SELECT s.firstname, s.familylastname, s.sex, s.dob, s.studentid,
			 u.businessname, u.insurance_typeid,
			 p.insurance_startdate, p.insurance_enddate, p.programname,
			 insu.insuranceid
	  FROM 	smg_students s
	  INNER JOIN smg_users u 		ON u.userid = s.intrep  
	  INNER JOIN smg_programs p 	ON s.programid = p.programid
	  INNER JOIN smg_insurance insu ON s.studentid = insu.studentid	
	  WHERE s.active = '1' 
			AND s.companyid = '#client.companyid#'
			AND insu.sent_to_caremed IS NULL
			AND insu.transtype = 'new'
			AND insu.excel_spreadsheet = '1'
			<cfif form.programid is 0><cfelse>AND s.programid = '#form.programid#'</cfif>
			AND (insu.new_date IS NOT NULL or insu.end_date IS NOT NULL)
	  ORDER BY u.businessname, s.firstname
	</cfquery>
		
	<span class="application_section_header"><cfoutput>#companyshort.companyshort# Insurance Students List</cfoutput></span><br><br>

	<table width=80% cellpadding=6 cellspacing="0" align="center" frame="box">	
		<tr><td><cfoutput>You have updated #get_students.recordcount# record(s).</cfoutput></td></tr>
	</table><br>
	
	<!--- view students --->
	<Table width=80% frame=below cellpadding=6 cellspacing="0" align="center">	
	<tr>
		<td>First Name</td>
		<td>Last Name</td>
		<td>Sex</td>
		<td>Intl. Agent</td>
		<td>Program</td>
	</tr>
	<cfoutput query="get_students">	
	<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
		<td>#FirstName#</td>
		<td>#familylastname#</td>
		<td>#sex#</td>
		<td>#businessname#</td>
		<td>#programname#</td>
	</tr>
 	<cfif insurance_typeid EQ '0' or insurance_startdate is '' or insurance_enddate is ''>
	<cfelse> 
		<cfquery name="update_students" datasource="MySql">
			UPDATE smg_students 
			SET insurance = #CreateODBCDate(now())# 
			WHERE studentid = '#get_students.studentid#'
			LIMIT 1
		</cfquery>
		<!--- UPDATE FIRST HISTORY --->
		<cfquery name="update_history" datasource="MySql">
			UPDATE smg_insurance
			SET sent_to_caremed = #CreateODBCDate(now())#
			WHERE insuranceid = '#get_students.insuranceid#'
			LIMIT 1
		</cfquery>
	</cfif>
	</cfoutput>
	</table>
</cfif><br>