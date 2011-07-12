<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>State Status</title>
<head>
<style>
	table.statenavbar {
	   border-collapse: collapse;
	}
	table.statenavbar td {
	   border: 1px solid black;
	}
	table.statenavbar td a{
	   display: block;
	   width: 200px;
	   padding: 3px;
	   text-decoration: none;
	}
	table.statenavbar td a:link, table.statenavbar td a:visited {
	   color: #000;
	   
	}
	table.statenavbar td a:hover, table.statenavbar td a:active {
	   color: #fff;
	   background-color: #CCCCCC;
	}
</style>
</head>

<body>
<cfset closedList = ''>
<cfif isDefined('url.stateID')>

	<cfif url.isActive eq 0>
   
        <Cfquery datasource="#application.dsn#">
            insert into regionStateClosure (fk_stateID, fk_programid)
                                values(#url.stateid#, #url.programid#)
        </cfquery>
    
    <Cfelse>
        <Cfquery datasource="#application.dsn#">
    	delete from regionStateClosure where fk_stateid = #url.stateid# and fk_programid = #url.programid#
		</cfquery>
    </cfif>
</cfif>
<cfquery name="states" datasource="#application.dsn#">
select s.statename, s.id
from smg_states s
where (s.id < 52 AND s.id !=11 and s.id !=2)
</cfquery>

<Cfquery name="statesClosed" datasource="#application.dsn#">
select sc.fk_stateID, s.statename
from regionStateClosure sc 
LEFT join smg_states s on s.id = sc.fk_stateID
where  sc.fk_programid = #url.programid#
</cfquery>
<Cfloop query="statesClosed">
	<cfset closedList = #ListAppend(closedList, fk_stateID)#>
</Cfloop>

<cfoutput>
<div align="center">
	<h2>Program: #url.program# <BR /> Season: #url.label#</h2>
</div>
	<table width=670 border=0 cellpadding=4 cellspacing="0" align="center" class="statenavbar">

        <tr>
        <cfloop query="states">
        	<td <cfif ListFind(closedList, id)>bgcolor="##f0d0d1"</cfif>><A href="stateStatus.cfm?stateid=#id#&isActive=<cfif ListFind(closedList, id)>1<cfelse>0</cfif>&programid=#url.programid#&label=#url.label#&program=#url.program#">#statename#</A></td>
        	<cfif states.currentrow mod 4>
            <cfelse>
            </tr>
            <tr>
            </cfif>
        </cfloop>
		</tr>
     </table>
</cfoutput>			
<Br /><Br />
<table align="Center" width=670 class="statenavbar">
	<tr>
    	<Td>State is Showing on Application</Td><td bgcolor="#f0d0d1">State is NOT showing on Application</td>
    </tr>
</table>
					
</body>
</html>