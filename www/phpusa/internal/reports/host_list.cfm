<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>AXIS - Host Family List</title>
</head>

<body>

<cfif client.usertype NEQ 1>
	You do not have rights to see this page.
	<cfabort>
</cfif>

<cfquery name="get_host" datasource="MySql">
	SELECT hostid, familylastname, fatherfirstname, fatherlastname, fatherssn, fatherdob,
		motherfirstname, motherlastname, motherssn, motherdob,
		address, city, state, zip
	FROM smg_hosts	
	WHERE companyid = '6'
	ORDER BY familylastname
</cfquery>

<cfoutput>

<table width="95%" align="center" cellpadding=2 cellspacing="0" frame="box">
	<tr><th colspan="7">AXIS - ALL HOST FAMILIES</th></tr>
	<tr>
		<td width="20%"><b>Host Family</b></td>
		<td width="17%"><b>Host Father</b></td>
		<th width="10%">SSN Father</th>
		<td width="20%"><b>Host Mother</b></td>
		<th width="10%">SSN Mother</th>
		<td width="17%"><b>City</b></td>
		<th width="6%">State</th>
	</tr>
	<cfloop query="get_host">
		<cfif fatherssn EQ ''>
			<cfset DecryptedFatherSSN = fatherssn>
		<cfelse>
			<cfset DecryptedFatherSSN = decrypt(fatherssn, 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
		</cfif>		
		<cfif motherssn EQ ''>
			<cfset DecryptedMotherSSN = motherssn>
		<cfelse>
			<cfset DecryptedMotherSSN = decrypt(motherssn, 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
		</cfif>									
		<tr bgcolor="#iif(currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td>#familylastname# (###hostid#)</td>
			<td>#fatherfirstname# #fatherlastname#</td>
			<td align="center">#DecryptedFatherSSN#</td>
			<td>#motherfirstname# #motherlastname#</td>
			<td align="center">#DecryptedMotherSSN#</td>
			<td>#city#</td>
			<td align="center">#state#</td>
		</tr>
	</cfloop>
</table>
</cfoutput>

</body>
</html>