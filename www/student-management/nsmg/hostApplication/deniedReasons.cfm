<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" href="../linked/css/baseStyle.css" />
<title>App Denied Reasons</title>
</head>
<Cfquery name="getDeniedReasons" datasource="#application.dsn#">
select tdld.arearepDenial, tdld.regionalAdvisorDenial, tdld.regionalDirectorDenial,tdld.facDenial, tdl.description 
from smg_ToDoListDates tdld
left join smg_ToDoList tdl on tdl.id = tdld.itemID 
where fk_hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.hostid#">
and (tdld.arearepDenial != '' OR 
	 tdld.regionalAdvisorDenial != '' OR 
     tdld.regionalDirectorDenial != '' OR
     tdld.facDenial != '')
</Cfquery>

<cfquery name="generalReason" datasource="#application.dsn#">
select  applicationDenied, reasonAppDenied 
from smg_hosts
where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.hostid#">
</cfquery>

<body>
<Cfoutput>
<br />
 <div class="rdholder" style="width:100%;float:left;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Denied on #dateFormat(generalReason.applicationDenied, 'mmm. d, yyyy')# for the following:</span> 
               
            	</div> <!-- end top --> 
             <div class="rdbox">

<Table class=border width=80% align="center" cellpadding="4" cellspacing="0">
	<Tr >
    	<Th align="left">Item</Th><th align="left">Problem Found</th>
    </Tr>
<cfif getDeniedReasons.recordcount eq 0>
	<tr bgcolor="##F7F7F7" >
    	<td colspan=2 align="center">No item specific issues were on the application.<br><br>General Reasons posted below.</td>
    </tr>
<cfelse>
    <cfloop query="getDeniedReasons">
        <Tr <cfif currentRow mod 2> bgcolor="##F7F7F7"</cfif>>
            <Td>#description#</Td><td>#arearepDenial# #regionalAdvisorDenial# #regionalDirectorDenial# #facdenial#</td>
        </Tr>       
    </cfloop>
</cfif>
<tr>
	<Td>
</Table>

<br /><br />
<Table class=border width=80% align="center" cellpadding="4" cellspacing="0">
	<Tr >
    	<td><h3>General Application Comments:</h3></td>
    </Tr>
    <tr>
    	<Td>
			<Cfif len(generalReason.reasonAppDenied) eq 0>
                No other information was given.
            <cfelse>
                #generalReason.reasonAppDenied#
            </Cfif>
		</Td>
     </tr>
  </Table>
</div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
</Cfoutput>
</body>
</html>