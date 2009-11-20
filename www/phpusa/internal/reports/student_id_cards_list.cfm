<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Student ID Cards</title>
</head>

<body>

<cfif not IsDefined('form.programid')>
	You must select at least one program. Please go back and try again.
	<cfabort>
</cfif>

<!--- Get names, addresses from our database --->
<cfquery name="get_students" datasource="mysql"> 
	SELECT 	DISTINCT php.studentid, s.familylastname, s.firstname, s.dateapplication, s.dob,
			php.active, php.i20no, 
			u.businessname,
			c.companyname, c.address AS c_address, c.city AS c_city, c.state AS c_state, c.zip AS c_zip, c.toll_free,
			sc.schoolname, sc.address as schooladdress, sc.city as schoolcity,
			sc.zip as schoolzip, sta.statename as schoolstate, sc.phone as schoolphone,
			p.programname
	FROM php_students_in_program php
	INNER JOIN smg_students s ON php.studentid = s.studentid
	INNER JOIN smg_companies c ON php.companyid = c.companyid
	INNER JOIN smg_users u ON s.intrep = u.userid
	LEFT JOIN php_schools sc ON sc.schoolid = php.schoolid
	LEFT JOIN smg_programs p ON p.programid = php.programid
	LEFT JOIN smg_states sta ON sta.id = sc.state
	WHERE php.active = '1'
		AND u.php_insurance_typeid = '#form.insurance_typeid#'
		<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
			AND php.datecreated between #CreateODBCDate(form.date1)# and #CreateODBCDate(DateAdd('d', 1, form.date2))#
		</cfif>
		<cfif form.intrep NEQ '0'>AND s.intrep = '#form.intrep#'</cfif>
		AND ( <cfloop list="#form.programid#" index="prog">php.programid = #prog#
				<cfif prog is #ListLast(form.programid)#><Cfelse>or </cfif></cfloop> )							
	GROUP BY studentid
	ORDER BY u.businessname, s.familylastname, s.firstname
</cfquery>
					
<cfoutput>
			
<table align="center" width="90%" cellspacing="2" cellpadding="2" frame="below">
	<th colspan="4">ID CARDS LIST</th>
	<tr><td><b>Intl. Agent</b></td><td><b>Student</b></td><td><b>Program</b></td><td><b>School</b></td></tr>
	<cfloop query="get_students">
		<tr bgcolor="<cfif currentrow MOD 2 EQ 0>##CCCCCC<cfelse>white</cfif>">
			<td>#businessname#</td>
			<td>#firstname# #familylastname# (###studentid#)</td>
			<td>#programname#</td>
			<td>#schoolname#</td>
		</tr>
	</cfloop>
</table>

</cfoutput>

</body>
</html>