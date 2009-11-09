<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfif form.programid is 1>
	<span class="application_section_header"><cfoutput>#companyshort.companyshort# Insurance Students List</cfoutput></span>
	<br>
	<table width=90% cellpadding=6 cellspacing="0" align="center" frame="box">	
		<tr><td><font color="FF0000">You need to select a program in order to proceed. Please go back and select it.</font></td></tr>
	</table>
	<cfabort>
</cfif>

<cfquery name="total_students" datasource="MySQL">
	SELECT s.studentid, s.firstname, s.familylastname, s.sex, s.dob, u.businessname, u.insurance_policy_type,
		p.insurance_startdate, p.insurance_enddate, p.programname,
		c.countrycode,
		insu.new_date, insu.sent_to_caremed, insu.insuranceid
	FROM 	smg_students s
	INNER JOIN smg_users u 		ON u.userid = s.intrep  
	INNER JOIN smg_programs p 	ON s.programid = p.programid
	INNER JOIN smg_countrylist c 	ON s.countryresident = c.countryid
	INNER JOIN smg_companies co 	ON s.companyid = co.companyid
	INNER JOIN smg_insurance insu ON s.studentid = insu.studentid	
	WHERE s.companyid = '#client.companyid#' 
		AND insu.sent_to_caremed is null
		AND insu.transtype = 'cancellation'
		AND insu.excel_spreadsheet = '1'
		<cfif form.programid is 0><cfelse>AND s.programid = '#form.programid#'</cfif>
	ORDER BY u.businessname, s.firstname
</cfquery>

<cfoutput>
<span class="application_section_header">#companyshort.companyshort# Insurance Students List</span><br><br>

<table width=90% cellpadding=6 cellspacing="0" align="center" frame="box">	
	<tr><td>You have updated #total_students.recordcount# record(s).</td></tr>
</table><br>

<!--- view students --->
<Table width=80% frame=below cellpadding=6 cellspacing="0" align="center">	
<tr>
	<td>ID</td>
	<td>First Name</td>
	<td>Last Name</td>
	<td>Sex</td>
	<td>Intl. Agent</td>
	<td>Program</td>
</tr>
<cfloop query="total_students">	
	<tr bgcolor="#iif(total_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
		<td>#studentid#</td>
		<td>#FirstName#</td>
		<td>#familylastname#</td>
		<td>#sex#</td>
		<td>#businessname#</td>
		<td>#programname#</td>
	</tr>
	<!--- update student --->
	<cfquery name="update_students" datasource="MySQL">  
	  UPDATE smg_insurance
	  SET    sent_to_caremed = #CreateODBCDate(now())#
	  WHERE insuranceid = #total_students.insuranceid#
	  LIMIT 1 
	</cfquery>
	<!--- update student --->
	<cfquery name="update_students" datasource="MySQL">  
	  UPDATE smg_students s
	  SET s.cancelinsurancedate = #CreateODBCDate(now())#
	  WHERE studentid = #total_students.studentid# 
	  LIMIT 1
	</cfquery>
</cfloop>
	</table>
</cfoutput>