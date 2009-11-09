<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Cross Reference</title>
</head>

<body>

<cfoutput>

VSC Cross Reference <br />

<!---
SELECT studentid, firstname, lastname, dob
FROM `temp_virginia_surety` 
WHERE studentid =0
ORDER BY firstname
--->

<cfquery name="smg_insurance" datasource="MySql">
	SELECT studentid, firstname, lastname, dob
	FROM smg_insurance
	WHERE transtype = 'new'
		AND policy_code >= '7' and 
		policy_code <= '9'
		AND input_date > '2007-06-01'
	ORDER BY firstname
</cfquery>

<cfset countok = 0>
<cfset countmissing = 0>

<table width="70%">
	<tr>
		<td>Status</td>
		<td>Student ID</td>
		<td>First Name</td>
		<td>Last Name</td>
		<td>DOB</td>
	</tr>
	<cfloop query="smg_insurance">
	
		<cfquery name="cross_reference" datasource="MySql">
			SELECT vs.tableid, vs.studentid, vs.lastname, vs.firstname
			FROM temp_virginia_surety vs
			WHERE vs.firstname LIKE '%#firstname#%'
				AND vs.lastname LIKE '%#lastname#%'
				AND vs.dob = #CreateODBCDate(dob)#
			<!--- vs.studentid = '#studentid#' --->
		</cfquery>
	
		<cfif cross_reference.recordcount>
			<cfset countok = countok + 1>
			<!---
			<cfquery name="update" datasource="MySql">
				UPDATE temp_virginia_surety
				SET studentid = '#studentid#'
				WHERE tableid = '#cross_reference.tableid#'
				LIMIT 1
			</cfquery>	
			--->	
		<cfelse>
			<cfset countmissing = countmissing + 1>
			<tr>
				<td>Not Found</td>
				<td>###studentid#</td>
				<td>#firstname#</td>
				<td>#lastname#</td>
				<td>#DateFormat(dob, 'mm/dd/yyyy')#</td>
			</tr>
		</cfif>
	</cfloop>
</table>
<br /><br />
Total

Students found: #countok#<br /><br />

Students missing #countmissing#<br /><br />
<br />
<br />


<cfquery name="list_unknown" datasource="MySql">
	SELECT vs.tableid, vs.studentid, vs.lastname, vs.firstname, vs.dob
	FROM temp_virginia_surety vs
	WHERE studentid = '0'
</cfquery>

<table>
	<cfloop query="list_unknown">
		<tr>
			<td>Not Found</td>
			<td>###studentid#</td>
			<td>#firstname#</td>
			<td>#lastname#</td>
			<td>#DateFormat(dob, 'mm/dd/yyyy')#</td>
		</tr>
	</cfloop>
	<tr><td colspan="5">Total of #list_unknown.recordcount#</td></tr>
</table>
<br />
<br />


<cfquery name="cross_reference" datasource="MySql">
	SELECT vs.tableid, vs.lastname, vs.firstname, vs.dob
	FROM temp_virginia_surety vs
	ORDER BY firstname
</cfquery>
<table width="70%">
	<tr>
		<td>Table ID</td>
		<td>First Name</td>
		<td>Last Name</td>
		<td>DOB</td>
	</tr>
</table><br /><br />

<table width="70%">
	<cfloop query="cross_reference">
		<cfquery name="check_double" datasource="MySql">
			SELECT vs.tableid, vs.lastname, vs.firstname, vs.dob
			FROM temp_virginia_surety vs
			WHERE vs.tableid != '#tableid#' 
				AND vs.firstname LIKE '%#firstname#%'
				AND vs.lastname LIKE '%#lastname#%'
				AND vs.dob = #CreateODBCDate(dob)#
		</cfquery>
		<cfif check_double.recordcount>
			<tr>
				<td>#tableid#</td>
				<td>#firstname#</td>
				<td>#lastname#</td>
				<td>#DateFormat(dob, 'mm/dd/yyyy')#</td>
			</tr>		
			<tr>
				<td>#check_double.tableid#</td>
				<td>#check_double.firstname#</td>
				<td>#check_double.lastname#</td>
				<td>#DateFormat(check_double.dob, 'mm/dd/yyyy')#</td>
			</tr>			
		</cfif>
	</cfloop>
	<tr><td>&nbsp;</td></tr>
</table>

</cfoutput>

</body>
</html>
