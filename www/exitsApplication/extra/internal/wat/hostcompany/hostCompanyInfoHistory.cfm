<!--- ------------------------------------------------------------------------- ----
	
	File:		hostCompanyInfoHistory.cfm
	Author:		James Griffiths
	Date:		November 21, 2012
	Desc:		Host Company Information History records

----- ------------------------------------------------------------------------- --->

<cfsilent>
	
    <cfparam name="URL.hostID" default="0">
    
    <cfquery name="qGetHost" datasource="MySql">
    	SELECT *
        FROM extra_hostcompany
        WHERE hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#">
    </cfquery>
    
    <cfquery name="qGetHistoryRecords" datasource="MySql">
    	SELECT hih.*, u.firstName, u.lastName, u.userID
        FROM extra_hostinfohistory hih
        LEFT JOIN smg_users u ON u.userID = hih.changedBy
        WHERE hih.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#">
        ORDER BY hih.historyID ASC
    </cfquery>
    
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../../style.css">
	<title>Host Company Information History</title>
</head>
<body>

<cfoutput>
	
    <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="C7CFDC" bgcolor="FFFFFF">
    	<tr>
        	<td bordercolor="FFFFFF">
            	
                <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                	<tr valign="middle" height="24">
                    	<td align="right" class="title1">Host Company History for #qGetHost.name# (###qGetHost.hostCompanyID#)</td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                </table>
                
                <table width="100%" border=0 cellpadding=5 cellspacing=0>
                	<tr>
                    	<td class="style2" bgcolor="8FB6C9">Date Changed</td>
                        <td class="style2" bgcolor="8FB6C9">Changed By</td>
                    	<td class="style2" bgcolor="8FB6C9">Person Signing Job Offer</td>
                        <td class="style2" bgcolor="8FB6C9">Title</td>
                        <td class="style2" bgcolor="8FB6C9">
                        	<table width="100%" style="border-left:thin solid white">
                            	<tr><td colspan="3" align="center"><u>Seasonal Information</u></td></tr>
                                <tr>
                                	<td width="50%" align="left">Season</td>
                                	<td width="25%" align="center">Confirmation of Terms</td>
                                    <td width="25%" align="center">Available J1 Positions</td>
                              	</tr>
                            </table>
                        </td>
                        <td class="style2" bgcolor="8FB6C9">
                        	<table width="100%" style="border-left:thin solid white; border-right:thin solid white;">
                            	<tr><td colspan="3" align="center"><u>Authentication</u></td></tr>
                                <tr>
                                	<td width="33%" align="center">Secretary of State</td>
                                    <td width="33%" align="center">Department of Labor</td>
                                    <td width="34%" align="center">Google Earth</td>
                               	</tr>
                            </table>	
                      	</td>
                        <td class="style2" bgcolor="8FB6C9">EIN</td>
                        <td class="style2" bgcolor="8FB6C9">WC</td>
                        <td class="style2" bgcolor="8FB6C9">WC Expiration</td>
                        <td class="style2" bgcolor="8FB6C9">Carrier Name</td>
                        <td class="style2" bgcolor="8FB6C9">Carrier Phone</td>
                        <td class="style2" bgcolor="8FB6C9">Policy Number</td>
                        <td class="style2" bgcolor="8FB6C9">Homepage</td>
                        <td class="style2" bgcolor="8FB6C9">Observations</td>
                    </tr>
                    <cfif qGetHistoryRecords.recordcount EQ '0'>
                    	<tr><td colspan="10" align="center" class="style1">There are currently no history records for this host company.</td></tr>
                    <cfelse>
                    
                    	<cfloop query="qGetHistoryRecords">
                        
                        	<cfquery name="qGetSeasonHistory" datasource="MySql">
                            	SELECT hsh.*, p.programName
                                FROM extra_hostseasonhistory hsh
                                INNER JOIN smg_programs p ON p.programID = hsh.programID
                                WHERE hsh.hostHistoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#historyID#">
                            </cfquery>
                            
							<tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffff") ,DE("F7F7F7") )#">
                            	<td align="left" class="style5">#DateFormat(dateChanged,'mm/dd/yyyy')#</td>
                                <td align="left" class="style5">
                                	<cfif changedBy EQ 0>
                                    	System
                                    <cfelse>
                                    	#firstName# #lastName# (###userID#)
                                    </cfif>
                                </td>
                                <td align="left" class="style5">#personJobOfferName#</td>
                                <td align="left" class="style5">#personJobOfferTitle#</td>
                                <td align="left" class="style5">
                                	<table width="100%">
                                    	<cfloop query="qGetSeasonHistory">
                                        	<tr>
                                            	<td width="50%" align="left">#programName#</td>
                                                <td width="25%" align="center"><input type="checkbox" disabled <cfif confirmed EQ 1>checked</cfif> ></td>
                                                <td width="25%" align="center">#j1Positions#</td>
                                            </tr>
                                        </cfloop>
                                    </table>
                                </td>
                                <td align="left" class="style5">
                                    <table width="100%">
                                        <tr>
                                            <td width="33%" align="center"><input type="checkbox" disabled <cfif authentication_secretaryOfState EQ 1>checked</cfif> ></td>
                                            <td width="33%" align="center"><input type="checkbox" disabled <cfif authentication_departmentOfLabor EQ 1>checked</cfif> ></td>
                                            <td width="34%" align="center"><input type="checkbox" disabled <cfif authentication_googleEarth EQ 1>checked</cfif> ></td>
                                       	</tr>
                                    </table>
                                </td>
                                <td align="left" class="style5">#ein#</td>
                                <td align="left" class="style5">
                                	<cfif workmensCompensation EQ 1>
                                    	Yes
                                   	<cfelse>
                                    	No
                                  	</cfif>
                               	</td>
                                <td align="left" class="style5">#DateFormat(WCDateExpired,'mm/dd/yyyy')#</td>
                                <td align="left" class="style5">#WC_carrierName#</td>
                                <td align="left" class="style5">#WC_carrierPhone#</td>
                                <td align="left" class="style5">#WC_policyNumber#</td>
                                <td align="left" class="style5">#homepage#</td>
                                <td align="left" class="style5">#observations#</td>
                            </tr>
                            
                      	</cfloop>
                        
                    </cfif>
                </table>
                
            </td>
        </tr>
    </table>
    
</cfoutput>

</body>
</html>