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
    <cfparam name="URL.userID" default="0">

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
    <cfscript>
		// Check if User has access to view these payments
		allowAccess = APPLICATION.CFC.USER.checkUserAccess(currentUserID=CLIENT.userID, currentRegionID=CLIENT.regionID, currentUserType=CLIENT.userType, viewUserID=URL.userID );
		
		if (NOT allowAccess) {
			URL.userID = CLIENT.userID;		
		}
		
		// Get Rep Information
		qRepInfo = APPLICATION.CFC.USER.getUserByID(userID=VAL(URL.userID));
		
		// Get Company Information
		qGetCompanyShort = APPLICATION.CFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
		
		// Get All of a Rep's payments
		qGetRepPayments = APPLICATION.CFC.USER.getRepPayments(userID=URL.userID,companyID=CLIENT.companyID);
		
		// Get Total Payments by Program
		qGetRepTotalPayments = APPLICATION.CFC.USER.getRepTotalPayments(userID=URL.userID, companyID=CLIENT.companyID);
	</cfscript>
              
</cfsilent>

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

<cfoutput>

<!--- Call tableHeader CustomTag and pass the variables --->
<gui:tableHeader
    imageName="user.gif"
    tableTitle="#qGetCompanyShort.companyshort#"
    tableRightTitle="Payment List for #qRepInfo.firstName# #qRepInfo.lastname# (###qRepInfo.userID#)"
/>

<cfif NOT VAL(URL.userID)>

    <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
        <tr><td><p>An error has occurred. Please go back and try again.</p></td></tr>
        <tr><td align="center" width="50%">&nbsp;<input type="image" value="Back" src="pics/back.gif" onClick="javascript:history.back()"></td></tr>
    </table>

	<!--- Call tableFooter CustomTag --->
    <gui:tableFooter />
    
    <cfabort>
</cfif>

<cfquery name="qGetTotal" dbtype="query">
	SELECT SUM(amount) AS total
    FROM qGetRepPayments
    WHERE ( paidDate >= <cfqueryparam cfsqltype="cf_sql_date" value="2014-04-04"> OR paidDate IS NULL)
</cfquery>

<cfquery name="qGetTotalPayments" dbtype="query">
	SELECT SUM(amount) AS total
    FROM qGetRepPayments
    WHERE creditStatus = 3
    AND paymentType = 37
    AND ( paidDate >= <cfqueryparam cfsqltype="cf_sql_date" value="2014-04-04"> OR paidDate IS NULL)
</cfquery>

<cfscript>
	vTotal = 0;
	vPaid = 0;
	vBalance = 0;
	
	seperationDisplayed = 0;
	previousPayment = 0;
	
	if (VAL(qGetTotal.recordCount)) {
		vBalance = 	qGetTotal.total;
		vTotal = vBalance;
	}
	
	if (VAL(qGetTotalPayments.recordCount)) {
		vPaid = -qGetTotalPayments.total;
		vTotal = vTotal + vPaid;
	}
</cfscript>

<table width="100%" border="0" cellpadding="8" cellspacing="" class="section">
	<!---Removed as per Paul on 4/17/14
    <tr>
        <td><b>Total</b></td>
        <td>
            <b>#LSCurrencyFormat(vTotal, 'local')#</b>
        </td>
    </tr>
    <tr>
        <td><b>Payments</b></td>
        <td>
            <b>#LSCurrencyFormat(vPaid, 'local')#</b>
        </td>
    </tr>--->
    <tr>
        <td><b>Balance</b></td>
        <td>
            <b>#LSCurrencyFormat(vBalance, 'local')#</b>
        </td>
    </tr>

    <cfif NOT VAL(qGetRepPayments.recordcount)>
        <tr>
            <td colspan="3">No payments have been submitted for this user.</td>
        </tr>
    </cfif>
    
    <tr class="programList">
        <td>&nbsp;</td>
        <td colspan="2">
            <table width="100%" border="0" cellpadding="4" cellspacing="0">
                <tr>
                    <td><b>Date</b></td>
                    <td><b>ID</b></Td>
                    <td><b>Student</b></td>
                    <td><b>Host</b></td>
                    <td><b>Program</b></td>
                    <td><b>Type</b></td>
                    <td><b>Checks / Credits</b></td>
                    <td><b>Fees Earned</b></td>
                    <td><b>Balance</b></td>
                    <td><b>Comment</b></td>
                </tr>
                
                <cfloop query="qGetRepPayments">
                    <cfif (paidDate LT "2014-04-04" AND IsDate(paidDate) AND seperationDisplayed EQ 0) OR (paymentType EQ 37 AND previousPayment EQ 0)>
                        <cfif paymenttype NEQ 37>
                            <cfset seperationDisplayed = 1>
                        </cfif>
                        <tr><td colspan="10"><hr /></td></tr>
                    </cfif>
                    <cfif paymenttype EQ 37>
                        <cfset previousPayment = 1>
                    <cfelse>
                        <cfset previousPayment = 0>
                    </cfif>
                    
                    <cfscript>
                        vBackgroundColor = "FFFFFF";
                        if (currentrow MOD 2) {
                            vBackgroundColor = "EEEEEE";	
                        }
                        if (transtype EQ "Payment") {
                            vBackgroundColor = "lightgreen";	
                        }
                    </cfscript>
                    <tr bgcolor="#vBackgroundColor#">
                        <td>
                            <cfif IsDate(paidDate)>
                                #DateFormat(paidDate, 'mm/dd/yyyy')#
                            <cfelse>
                                Pending    
                            </cfif>
                        </td>
                        <td>#id#</Td>
                        <td>
                            <cfif transtype EQ "Payment">
                                Check for all fees #DateFormat(paidDate,'mm/dd/yyyy')#
                            <cfelseif VAL(studentID)>
                                #firstName# #familyLastName# (#studentID#)
                            </cfif>
                        </td>
                        <td>
                            <cfif VAL(hostID)> 
                                #fatherFirstName#
                                <cfif LEN(fatherFirstName) AND LEN(motherFirstName)> &</cfif>
                                 #motherFirstName# #hostFamilyLastName# (#hostID#) 
                            </cfif>
                        </td>
                        <td>#programName#</Td> 
                        <td>#type#</Td>
                        <cfif amount GTE 0 AND paymenttype NEQ 37>
                            <td></td>
                            <td>#LSCurrencyFormat(amount, 'local')#</td>
                        <cfelse>
                            <cfscript>
                                vAmount = -amount;
                            </cfscript>
                            <td>#LSCurrencyFormat(vAmount, 'local')#</td>
                            <td></td>
                        </cfif>
                        <td>
                            <cfif paidDate GTE "2014-04-04" OR NOT IsDate(paidDate)>
                                #LSCurrencyFormat(vBalance, 'local')#
                            </cfif>
                        </td>
                        <td>
                            <cfif transtype EQ "Payment">
                                <cfif IsDate(paidDate)>
                                    <cfscript>
                                        vCheckSent = APPLICATION.CFC.UDF.addBusinessDays(inputDate=paidDate,numDays=1);
                                        vExpectReceiptBegin = APPLICATION.CFC.UDF.addBusinessDays(inputDate=paidDate,numDays=3);
                                        vExpectReceiptEnd = APPLICATION.CFC.UDF.addBusinessDays(inputDate=paidDate,numDays=6);
                                    </cfscript>
                                    Check Sent On: #DateFormat(vCheckSent,'mm/dd/yyyy')#
                                    <br/>Expect receipt between: #DateFormat(vExpectReceiptBegin,'mm/dd/yyyy')# and #DateFormat(vExpectReceiptEnd,'mm/dd/yyyy')#
                                </cfif>
                            <cfelse>
                                #comment#
                            </cfif>
                        </td>
                    </tr>
                    <cfscript>
                        vBalance = vBalance - amount;
                    </cfscript>
                </cfloop>
    
            </table>
        </td>
    </tr>
    
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
