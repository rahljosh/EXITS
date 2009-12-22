<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Programs List</title>
</head>

<body>

<cftry> 

<cfquery name="program" datasource="mysql">
	SELECT 
    	programid, 
        programname, 
        companyid, 
        extra_sponsor
	FROM 
    	smg_programs
	WHERE 
    	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
	ORDER BY 
    	programname
</cfquery>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>
