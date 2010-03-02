<!--- ------------------------------------------------------------------------- ----
	
	File:		rep_payments_made.cfm
	Author:		Marcus Melo
	Date:		February 25, 2010
	Desc:		Display payments made to an user

	Updated:  	02-25-2010 - Grouped by Program Name

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <!--- Param Variables --->	
    <cfparam name="URL.user" default="0">

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	
    
    <cfscript>
		allowAccess = APPCFC.USER.checkUserAccess(currentUserID=CLIENT.userID, currentRegionID=CLIENT.regionID, currentUserType=CLIENT.userType, viewUserID=URL.user);
		
		if (NOT allowAccess) {
			URL.user = CLIENT.userID;		
		}
		
		// Get Rep Information
		qRepInfo = APPCFC.USER.getUserByID(userID=VAL(URL.user));
		
		// Get Company Information
		qGetCompanyShort = APPCFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
		
		// Get Total Payments by Program
		qGetRepTotalPayments = APPCFC.USER.getRepTotalPayments(userID=VAL(URL.user), companyID=CLIENT.companyID);
	</cfscript>
              
</cfsilent>

<cfif NOT VAL(URL.user)>
	<cfinclude template="error_message.cfm">
</cfif>

<script language="JavaScript"> 
	function displayPaymentDetails(trName) {
		if ( $("#" + trName).css("display") == "none" ) {						
			// Display Table
			$("#" + trName).fadeIn("slow");
			//$("#" + trName).slideToggle();
		} else {
			// Hide Table
			$("#" + trName).fadeOut("slow");
			//$("#" + trName).slideUp();
		}
	}

	// Expand/Collapse All
	function expandAll() {
		if ( $(".programList").css("display") == "none" ) {						
			$(".programList").fadeIn("slow");
		} else {
			$(".programList").fadeOut("slow");
		}
	}
</script>

<link rel="stylesheet" href="../smg.css" type="text/css">

<cfoutput>

<!--- Call tableHeader CustomTag and pass the variables --->
<gui:tableHeader
    imageName="user.gif"
    tableTitle="#qGetCompanyShort.companyshort#"
    tableRightTitle="Payment List for #qRepInfo.firstname# #qRepInfo.lastname# (###qRepInfo.userID#)"
/>

<table width="100%" border="0" cellpadding="8" cellspacing="" class="section">
	<tr>
        <td width="80px">
            <a href="javascript:expandAll();">[ View All ]</a>
        </td>            
        <td width="300px">
            <b>Season</b>  
		</td>
        <td><b>Total</b></td>
	</tr>

	<cfif NOT VAL(qGetRepTotalPayments.recordcount)>
        <tr>
            <td colspan="3">No payments have been submitted for this user.</td>
        </tr>
    </cfif>
    
    <cfloop query="qGetRepTotalPayments">
        <tr bgcolor="#iif(qGetRepTotalPayments.currentrow MOD 2 ,DE("EEEEEE") ,DE("FFFFFF") )#">
            <td>
            	<a href="javascript:displayPaymentDetails('programList#qGetRepTotalPayments.seasonID#');">[ View Details ]</a>
            </td>            
            <td>
                <b>#qGetRepTotalPayments.season#</b> 
            </td>
            <td>
            	<b>#LSCurrencyFormat(qGetRepTotalPayments.totalPerProgram, 'local')#</b>
            </td>
        </tr>
        
        <cfscript>
			// Get Payment List for current programID
			qPaymentList = APPCFC.USER.getRepPaymentsBySeasonID(userID=URL.user, seasonID=qGetRepTotalPayments.seasonID, companyID=CLIENT.companyID);		
		</cfscript>
        
        <tr id="programList#qGetRepTotalPayments.seasonID#" class="programList" style="display:none">
            <td>&nbsp;</td>
            <td colspan="2">
       
        		<!--- Detail Table --->
            	<table width="100%" border="0" cellpadding="4" cellspacing="0">
                    <tr>
                        <td><b>Date</b></td>
                        <td><b>ID</b></Td>
                        <td><b>Student</b></td>
                        <td><b>Program</b></td>
                        <td><b>Type</b></td>
                        <td><b>Amount</b></td>
                        <td><b>Comment</b></td>
                        <td><b>Trans. Type</b></td>
                        <td><b>Prog. Manager</b></td>
                    </tr>

					<cfif NOT VAL(qPaymentList.recordcount)>
                        <tr>
                            <td colspan="8" style="padding-left:40px;">No payments submitted for this season.</td>
                        </tr>
                    </cfif>

                    <cfloop query="qPaymentList">
                        <tr bgcolor="#iif(qPaymentList.currentrow MOD 2 ,DE("EEEEEE") ,DE("FFFFFF") )#">
                            <td>#DateFormat(qPaymentList.date, 'mm/dd/yyyy')#</td>
                            <td>#qPaymentList.id#</Td>
                            <td><cfif NOT VAL(qPaymentList.studentID)> n/a <cfelse> #qPaymentList.firstname# #qPaymentList.familylastname# (#qPaymentList.studentid#) </cfif></td>
                            <td>#qPaymentList.programName#</Td> 
                            <td>#qPaymentList.type#</Td>  
                            <td>#LSCurrencyFormat(qPaymentList.amount, 'local')#</td>
                            <td>#qPaymentList.comment#</td>
                            <td>#qPaymentList.transtype#</td>
                            <td>#qPaymentList.team_id#</td>
                        </tr>
                    </cfloop>

				</table>
                
        	</td>
		</tr>            
    </cfloop>     
    
    <tr>
    	<td colspan="8">&nbsp;</td>
	</tr>            
</table>   

<table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
	<tr><td align="center" width="50%">&nbsp;<input type="image" value="Back" src="pics/back.gif" onClick="javascript:history.back()"></td></tr>
</table>

<!--- Call tableFooter CustomTag --->
<gui:tableFooter />

</ cfoutput>
