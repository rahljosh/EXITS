<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Export Searches</title>
</head>

<body>

<cfif client.usertype NEQ '1'>
	Sorry but you do not have privileges to see this file.
	<cfabort>
</cfif>

<cfquery name="get_searches" datasource="MySql">
	SELECT DISTINCT cbc.cbcfamid, cbc.hostid, cbc.cbc_type, cbc.date_authorized, cbc.date_sent, cbc.date_received,
		h.familylastname, h.fatherlastname, h.fatherfirstname, h.fathermiddlename, fatherdob, fatherssn,
		h.motherlastname, h.motherfirstname, h.mothermiddlename, motherdob, motherssn, h.state
	FROM smg_hosts_cbc cbc
	INNER JOIN smg_hosts h ON h.hostid = cbc.hostid
	WHERE cbc.companyid = '1'
		AND cbc.date_sent IS NOT NULL
		AND cbc.cbc_type != 'member'
	ORDER BY cbcfamid DESC
	LIMIT 1030
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=batch.xls"> 

<table border="1" cellpadding="3" cellspacing="0">
<tr>
	<td>Host ID</td>
	<td>Type</td>
	<td>First Name</td>
	<td>Middle Name</td>
	<td>Last Name</td>
	<td>DOB</td>
	<td>SSN</td>
	<td>State</td>
</tr>

<cfoutput query="get_searches">

	<cfif Evaluate(cbc_type & "ssn") NEQ ''> 
	
	<cfset newssn = ''>
	<!--- <cfset newssn = decrypt(Evaluate(cbc_type & "ssn"), 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")> --->	
	
	<!--- <cfset newssn = #Replace("#decrypt(Evaluate(cbc_type & "ssn"), 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', 'desede', 'hex')#","-","","All")#> --->
	<!--- <cfset newssn = #Replace("#newssn#", " ", "","All")#> --->

	<tr>
		<td>#hostid#</td>
		<td>#cbc_type#</td>
		<td>#Evaluate(cbc_type & "firstname")#</td>
		<td>#Evaluate(cbc_type & "middlename")#</td>
		<td>#Evaluate(cbc_type & "lastname")#</td>
		<td>#DateFormat(Evaluate(cbc_type & "dob"), 'mm/dd/yyyy')#</td>
		<td>#newssn#</td>
		<td>#state#</td>
	</tr>
	</cfif>
</cfoutput>

</table>

</body>
</html>