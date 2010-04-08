<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>
<cfoutput>

<cfloop From = "1" To = "#form.count#" Index = "x">
	<!--- FORMS --->
	<cfif #form["name" & x]# NEQ ''>
		
		<cfset EncryptSSN = ''>
		<cfif IsDefined('form.ssn#x#') AND #form["ssn" & x]# NEQ ''>
			<cfset EncryptSSN = encrypt("#form["ssn" & x]#", 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
		<cfelse>
			<cfset EncryptSSN = ''>
		</cfif>
		
		<cftransaction action="BEGIN" isolation="SERIALIZABLE">
		<cfquery name="update_children" datasource="caseusa">
			Update smg_host_children
			SET name = '#form["name" & x]#',
				middlename = '#form["middlename" & x]#',
				lastname = '#form["lastname" & x]#',
				<cfif IsDefined('form.sex#x#')>sex = '#form["sex" & x]#',</cfif>
				<cfif IsDefined('form.ssn#x#')>ssn = '#EncryptSSN#',</cfif>
				birthdate = <cfif form["birthdate" & x] is ''>null<cfelse>#CreateODBCDate(form["birthdate" & x])#</cfif>
			WHERE childid = '#form["childid" & x]#'
			LIMIT 1
		</cfquery>
		</cftransaction>
	</cfif>
</cfloop>

<head>
<script language="JavaScript">
<!-- 
alert("You have successfully updated this page. Thank You.");
	location.replace("host_fam_cbc.cfm?hostid=#form.hostid#");
-->
</script>
</head>
</cfoutput>
</body>
</html>
