<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>
<cfoutput>
	
	<cfset EncryptSSN = ''>
	<cfif IsDefined('form.ssn') AND form.ssn NEQ ''>
		<cfset EncryptSSN = encrypt("#form.ssn#", 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
	<cfelse>
		<cfset EncryptSSN = ''>
	</cfif>
	
	<cftransaction action="BEGIN" isolation="SERIALIZABLE">
	<cfquery name="update_user" datasource="mysql">
		UPDATE smg_users
		SET firstname = '#form.firstname#',
			middlename = '#form.middlename#',
			lastname = '#form.lastname#',
			<cfif IsDefined('form.ssn')>ssn = '#EncryptSSN#',</cfif>
			dob = <cfif form.dob EQ ''>null<cfelse>#CreateODBCDate(form.dob)#</cfif>
		WHERE userid = '#form.userid#'
		LIMIT 1							
	</cfquery>
	</cftransaction>

<head>
<script language="JavaScript">
<!-- 
alert("You have successfully updated this page. Thank You.");
	location.replace("user_info.cfm?userid=#form.userid#");
-->
</script>
</head>
</cfoutput>
</body>
</html>
