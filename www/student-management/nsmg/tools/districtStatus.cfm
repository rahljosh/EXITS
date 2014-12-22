<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>District Status</title>
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
<!----Get all Regions---->
<cfscript>
	// Get List of Canada Districts
	qGetESIDistrictChoice = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='ESIDistrictChoice',sortBy='sortOrder',isActive='');
</cfscript>

<cfset closedList = ''>
<cfif isDefined('url.districtID')>

	<cfif url.isActive eq 0>
        <Cfquery datasource="#application.dsn#">
            insert into regionstateclosure (fk_districtID, fk_programid, fk_companyid)
                                values(#url.districtID#, #url.programid#, #client.companyid#)
        </cfquery>
    <Cfelse>
        <Cfquery datasource="#application.dsn#">
    	 delete from regionstateclosure where fk_districtID = #url.districtID# and fk_programid = #url.programid#
		</cfquery>
    </cfif>
</cfif>


<Cfquery name="districtClosed" datasource="#application.dsn#">
select sc.fk_districtID
from regionstateclosure sc 
where  sc.fk_programid = #url.programid#

and fk_companyid = #client.companyid#

</cfquery>


<Cfloop query="districtClosed">
	<cfset closedList = #ListAppend(closedList, fk_districtID)#>
</Cfloop>

<cfoutput>
 <div align="center">
	<h2>Program: #url.program# <BR /> Season: #url.label#</h2>
</div>

		<table width=670 border=0 cellpadding=4 cellspacing="0" align="center" class="statenavbar">

        <tr>
        <cfloop query="qGetESIDistrictChoice">
        	<td <cfif ListFind(closedList, id)>bgcolor="##f0d0d1"</cfif>><A href="districtStatus.cfm?districtID=#id#&isActive=<cfif ListFind(closedList, id)>1<cfelse>0</cfif>&programid=#url.programid#&label=#url.label#&program=#url.program#">#name#</A></td>
        	<cfif qGetESIDistrictChoice.currentrow mod 4>
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
    	<Td>District is Showing on Application</Td><td bgcolor="#f0d0d1">District is NOT showing on Application</td>
    </tr>
</table>

</body>
</html>