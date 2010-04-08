<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>
<cfoutput>
	
	<cfset fatherEncryptSSN = ''>
	<cfif IsDefined('form.fatherssn') AND form.fatherssn NEQ ''>
		<cfset fatherEncryptSSN = encrypt("#form.fatherssn#", 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
	<cfelse>
		<cfset fatherEncryptSSN = ''>
	</cfif>
	
	<cfset motherEncryptSSN = ''>
	<cfif IsDefined('form.motherssn') AND form.motherssn NEQ ''>
		<cfset motherEncryptSSN = encrypt("#form.motherssn#", 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
	<cfelse>
		<cfset motherEncryptSSN = ''>
	</cfif>
	
	<cftransaction action="BEGIN" isolation="SERIALIZABLE">
	<cfquery name="update_host_family" datasource="mysql">
		UPDATE smg_hosts
		SET fatherfirstname = '#form.fatherfirstname#',
			fathermiddlename = '#form.fathermiddlename#',
			fatherlastname = '#form.fatherlastname#',
			<cfif IsDefined('form.fatherssn')>fatherssn = '#fatherEncryptSSN#',</cfif>
			fatherdob = <cfif form.fatherdob EQ ''>null<cfelse>#CreateODBCDate(form.fatherdob)#</cfif>,
			motherfirstname = '#form.motherfirstname#',
			mothermiddlename = '#form.mothermiddlename#',
			motherlastname = '#form.motherlastname#',
			<cfif IsDefined('form.motherssn')>motherssn = '#motherEncryptSSN#',</cfif>
			motherdob = <cfif form.motherdob EQ ''>null<cfelse>#CreateODBCDate(form.motherdob)#</cfif>
		WHERE hostid = '#form.hostid#'
		LIMIT 1							
	</cfquery>
	</cftransaction>

<head>
<script language="JavaScript">
<!-- 
alert("You have successfully updated this page. Thank You.");
	location.replace("host_parents_info.cfm?hostid=#form.hostid#");
-->
</script>
</head>
</cfoutput>
</body>
</html>
