<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
</head>

<body>

<cfif isDefined('form.process')>
			<cfscript>
			// Get update ToDoList
			updateToDoList = APPLICATION.CFC.UDF.updateToDoList(hostID=client.hostid,studentID=client.studentid,itemid=url.itemid,usertype=url.usertype);
			</cfscript>
              <div align="center">
            
            <h1>Succesfully Submited.</h1>
            <em>this window should close shortly</em>
            </div>
         
             <body onload="parent.$.fn.colorbox.close();">
                <cfabort>
</cfif>

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
<form method="post" action="viewFamLetter.cfm?itemID=#url.itemID#&usertype=#url.usertype#">
<table cellpadding=10 align="center">
	<tr>
    	<td><img src="../pics/buttons/deny.png" width="90%"/></td><td>&nbsp;</td>
        
        <Td><input type="image" src="../pics/buttons/approveBut.png" name="process" value=1 width="90%" /></Td>
    </tr>
</table>
</cfoutput>
</body>
</html>