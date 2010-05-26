<!--- ------------------------------------------------------------------------- ----
	
	File:		getExpiredUsers.cfm
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
		qGetExpiredUserCBC = APPLICATION.CFC.CBC.getExpiredUserCBC(cbcType=userType);
	</cfscript>
    
</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Get Expired CBCs for Users/Members</title>
</head>

<body>

<cfoutput>

<table width="70%" cellpadding="2" frame="box" style="margin-top:10px; margin-bottom:10px;">
	<tr bgcolor="##CCCCCC"><td colspan="4"><b>Get Expired CBCs for #userType#</b></td></tr>
	<tr bgcolor="##CCCCCC">
    	<td><b>User</b></td>
        <td><b>Member ID</b></td>
        <td><b>CBC Sent Date</b></td>
	</tr>

	<cfloop query="qGetExpiredUserCBC">
	
        <tr>
            <td>###qGetExpiredUserCBC.userID# - #qGetExpiredUserCBC.firstname# #qGetExpiredUserCBC.lastname#</td>
            <td>###qGetExpiredUserCBC.familyID#</td>
            <td align="center">#DateFormat(qGetExpiredUserCBC.date_sent, 'mm/dd/yyyy')#</td>
        </tr>
        
        <cfscript>
			// set New Seadon
			newSeason = qGetExpiredUserCBC.seasonID + 1;
			
			// Insert record
			APPLICATION.CFC.CBC.insertUserCBC(
				userID = qGetExpiredUserCBC.userID,								 
				familyMemberID = qGetExpiredUserCBC.familyID,
				seasonID = newSeason,
				companyID = qGetExpiredUserCBC.companyID,
				dateAuthorized = qGetExpiredUserCBC.date_authorized,
				isReRun=1
			);
		</cfscript>
            
	</cfloop>

	<tr><td colspan="4">Total of #userType# #qGetExpiredUserCBC.recordCount# records</td></tr>
</table>
</cfoutput>

</body>
</html>