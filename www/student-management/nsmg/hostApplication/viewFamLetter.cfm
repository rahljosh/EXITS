<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
</head>

<body>




<cfinclude template="approveDenyInclude.cfm">

<cfquery name="letter" datasource="#application.dsn#">
select familyletter
from smg_hosts
where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostID#">
</cfquery>

<h2>Letter of Introduction</h2>
<hr width=80% align="center" height=1px />

<cfoutput>
<Table width=90% align="center">
	<Tr>
    	<Td>
		#letter.familyletter#
        </Td>
    </Tr>
</Table>
      <br />
<hr width=80% align="center" height=1px />
<br />
<cfinclude template="approveDenyButtonsInclude.cfm">
</cfoutput>
</body>
</html>