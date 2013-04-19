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

	<cfsetting requesttimeout="300">

    <!--- Param Variables --->
    <cfparam name="userType" default="">
    <cfparam name="isUpcomingProgram" default="">

	<cfscript>
		if ( VAL(isUpcomingProgram) ) {
			// Get Expired CBCs for hosts linked to an upcoming student
			qGetExpiredHostCBC = APPLICATION.CFC.CBC.getExpiredHostCBC(cbcType=userType, isUpcomingProgram=isUpcomingProgram);
		} else {
			// Get Expired CBCs
			qGetExpiredHostCBC = APPLICATION.CFC.CBC.getExpiredHostCBC(cbcType=userType);
		}
    </cfscript>
    
</cfsilent>

<cfoutput>

<table width="70%" cellpadding="2" style="margin-top:20px; margin-bottom:20px; border:1px solid ##CCCCCC">
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
