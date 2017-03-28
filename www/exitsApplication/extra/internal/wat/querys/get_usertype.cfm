<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Usertype List</title>
</head>

<body>

<cftry>

<cfquery name="get_usertype" datasource="MySql">
	SELECT usertypeid, usertype
	FROM smg_usertype
	WHERE usertypeid >= <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(client.usertype)#">
    AND usertypeid <= '3'
    OR usertypeid = '28'
</cfquery>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>
