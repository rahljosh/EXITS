<!--- ------------------------------------------------------------------------- ----
	
	File:		getExpiredHosts.cfm
	Author:		Marcus Melo
	Date:		May 20, 2010
	Desc:		Scheduled CBCs - Gets records that are expired and inserts a new
				record so they are re-run automatically.

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <!--- Param Variables --->
    <cfparam name="userType" default="">

	<cfscript>
		// Get Expired CBCs
		qGetExpiredHostCBC = APPLICATION.CFC.CBC.getExpiredHostCBC(cbcType=userType);
	</cfscript>
    
</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Get Expired CBCs for Hosts/Members</title>
</head>

<body>

<cfoutput>

<table width="80%" cellpadding="2" frame="box" style="margin-top:10px; margin-bottom:10px;">
	<tr bgcolor="##CCCCCC"><td colspan="4"><b>Get Expired CBCs for Host #userType#</b></td></tr>
	<tr bgcolor="##CCCCCC">
    	<td><b>Host Family</b></td>
        <td><b>CBC Sent Date</b></td>
	</tr>

	<cfloop query="qGetExpiredHostCBC">
	
        <tr>
            <td>###qGetExpiredHostCBC.hostID# - #qGetExpiredHostCBC.familylastname#</td>
            <td align="center">#DateFormat(qGetExpiredHostCBC.date_sent, 'mm/dd/yyyy')#</td>
        </tr>
        
        <cfscript>
			// set New Seadon
			newSeason = qGetExpiredHostCBC.seasonID + 1;
			
			// Insert record
			APPLICATION.CFC.CBC.insertHostCBC(
				hostID = qGetExpiredHostCBC.hostID,								 
				familyMemberID = qGetExpiredHostCBC.familyID,
				cbcType=userType,
				seasonID = newSeason,
				companyID = qGetExpiredHostCBC.companyID,
				dateAuthorized = qGetExpiredHostCBC.date_authorized,
				isReRun=1
			);
		</cfscript>
            
	</cfloop>

	<tr><td colspan="4">Total of host #userType# #qGetExpiredHostCBC.recordCount# records</td></tr>
</table>
</cfoutput>

</body>
</html>