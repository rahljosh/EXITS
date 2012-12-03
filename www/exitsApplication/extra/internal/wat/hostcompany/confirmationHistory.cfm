<!--- ------------------------------------------------------------------------- ----
	
	File:		confirmationHistory.cfm
	Author:		James Griffiths
	Date:		Decemeber 3, 2012
	Desc:		Host Company Confirmation of Terms History

----- ------------------------------------------------------------------------- --->

<cfsilent>
	
    <cfparam name="URL.hostID" default="0">
    
    <cfquery name="qGetHost" datasource="MySql">
    	SELECT *
        FROM extra_hostcompany
        WHERE hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#">
    </cfquery>
    
    <cfquery name="qGetSeasons" datasource="MySql">
    	SELECT p.programID, p.programName, hih.dateChanged, hsh.confirmed, hsh.confirmedDate
        FROM smg_programs p, extra_hostseasonhistory hsh, extra_hostinfohistory hih
        WHERE p.programID = hsh.programID
        AND hsh.hostHistoryID = hih.historyID
        AND hih.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostID)#">
        ORDER BY p.startDate ASC, hih.dateChanged ASC
    </cfquery>
    
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../../style.css">
	<title>Host Company Confirmation of Terms History</title>
</head>
<body>

<table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="C7CFDC" bgcolor="FFFFFF">
	<tr>
 		<td bordercolor="FFFFFF">
            	
			<table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
            	<tr valign="middle" height="24">
                	<td align="right" class="title1"><cfoutput>Confirmation of Terms History for #qGetHost.name# (###qGetHost.hostCompanyID#)</cfoutput></td>
              	</tr>
             	<tr><td>&nbsp;</td></tr>
        	</table>
            
            <table width="100%">
				<cfoutput query="qGetSeasons" group="programID">
                    <tr>
                        <td valign="top" style="border:thin solid black">
                    		<table width="100%" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td class="style2" bgcolor="8FB6C9" align="center" colspan="4"><u>#programName#</u></td>
                                </tr>
                           		<tr>
                             		<td class="style2" bgcolor="8FB6C9">Date Changed</td>
                                    <td class="style2" bgcolor="8FB6C9">Date Verified</td>
                                    <td class="style2" bgcolor="8FB6C9"><center>Confirmed</center></td>
                                </tr>
                                <cfquery name="qGetPositions" dbtype="query">
                                    SELECT *
                                    FROM qGetSeasons
                                    WHERE programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(programID)#">
                                </cfquery>
                                <cfset lastNumber = -1>
                                <cfset lastDate = "*">
                                <cfloop query="qGetPositions">
                                    <cfif confirmed NEQ lastNumber OR confirmedDate NEQ lastDate>
                                        <tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffff") ,DE("F7F7F7") )#">
                                            <td>#DateFormat(dateChanged,'mm/dd/yyyy')#</td>
                                            <td>#DateFormat(confirmedDate,'mm/dd/yyyy')#</td>
                                            <td><center><cfif confirmed EQ 0>NO<cfelse>YES</cfif></center></td>
                                            <cfset lastNumber = #confirmed#>
                                            <cfset lastDate = #confirmedDate#>
                                       	</tr>
                                    </cfif>
                                </cfloop>
                          	</table>
                     	</td>
                 	</tr>
                </cfoutput>
          	</table>
            
    	</td>
  	</tr>
</table>