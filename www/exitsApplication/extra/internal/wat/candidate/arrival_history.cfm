<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../../style.css">
	<title>Arrival Verification History</title>
</head>
<body>

<cfif not IsDefined('url.uniqueID')>
	<cfinclude template="../error_message.cfm">
</cfif>

<cfscript>
	qGetCandidate = APPLICATION.CFC.CANDIDATE.getCandidateByID(uniqueID=URL.uniqueID);
</cfscript>

<cfquery name="qGetRecords" datasource="#APPLICATION.DSN.Source#">
	SELECT e.*, u.firstName AS uFirstName, u.lastName AS uLastName, s.state AS sState
    FROM extra_candidates_history e
    LEFT JOIN smg_users u ON u.userID = e.changedBy
    LEFT JOIN smg_states s ON s.id = e.arrival_state
    WHERE candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.candidateID)#">
</cfquery>

<cfoutput>
	<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
    	<tr>
			<td bordercolor="FFFFFF">
            	
                <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                	<tr valign=middle height=24>
                        <td align="right" class="title1">Arrival Verification History for <u>#qGetCandidate.firstName# #qGetCandidate.lastName#</u> (###qGetCandidate.candidateID#)</td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                </table>
                
                <table width="100%" border=0 cellpadding=5 cellspacing=0>
                	<tr>
                        <td class="style2" bgcolor="8FB6C9">Date Changed</td>
                        <td class="style2" bgcolor="8FB6C9">Changed By</td>
                        <td class="style2" bgcolor="8FB6C9">U.S. Phone</td>
                        <td class="style2" bgcolor="8FB6C9">Address</td>
                        <td class="style2" bgcolor="8FB6C9">Suite/Apt ## </td>
                        <td class="style2" bgcolor="8FB6C9">Other</td>
                        <td class="style2" bgcolor="8FB6C9">City</td>
                        <td class="style2" bgcolor="8FB6C9">State</td>
                        <td class="style2" bgcolor="8FB6C9">Zip</td>
                    </tr>
                    <cfif qGetRecords.recordcount EQ '0'>
                    	<tr><td colspan="6" align="center" class="style1">There is no Arrival Verification History for this student.</td></tr>
                    <cfelse>
                    	<cfloop query="qGetRecords">
                            <tr bgcolor="#iif(qGetRecords.currentrow MOD 2 ,DE("ffffff") ,DE("F7F7F7") )#">
                                <td align="left" class="style5">#DateFormat(dateChanged, 'mm/dd/yyyy')#</td>
                                <td align="left" class="style5">
                                	<cfif changedBy EQ 0>
                                    	System
                                   	<cfelse>
                                    	#uFirstName# #uLastName# (###changedBy#)
                                   	</cfif>
                               	</td>
                                <td align="left" class="style5" align="top">#us_phone#</td>
                                <td align="left" class="style5" align="top">#arrival_address#  </td>
                                <td align="left" class="style5" align="top"><cfif val(#arrival_apt_number#)>#arrival_apt_number#</cfif></td>
                                <td align="left" class="style5" align="top"> #arrival_address_2#</td>
                                <td align="left" class="style5" align="top">#arrival_city#</td>
                                <td align="left" class="style5" align="top">#sState#</td>
                                <td align="left" class="style5" align="top">#arrival_zip#</td>
                            </tr>
                        </cfloop>
                    </cfif>
                </table>
                
                <br>
                
                <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
                    <tr><td align="center" width="50%">&nbsp;<input type="image" value="close window" src="../../pics/close.gif" onClick="javascript:window.close()"></td></tr>
                </table>
                
            </td>
      	</tr>
    </table>
</cfoutput>

</body>
</html>