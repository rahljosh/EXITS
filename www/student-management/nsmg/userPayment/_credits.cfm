<!--- ------------------------------------------------------------------------- ----
	
	File:		_credits.cfm
	Author:		James Griffiths
	Date:		March 20, 2014
	Desc:		Allows input of credits based on the student or payment ID
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<cfparam name="URL.agentID" default="0">
    <cfparam name="URL.studentID" default="0">
    <cfparam name="URL.paymentID" default="0">
    <cfparam name="URL.pageNum" default="1">
    <cfparam name="URL.payments" default="0">

	<cfparam name="FORM.submitted" default="0">
	<cfparam name="FORM.agentID" default="0">
    <cfparam name="FORM.studentID" default="0">
    <cfparam name="FORM.paymentID" default="0">
    <cfparam name="FORM.payments" default="0"> 

	<cfscript>
		// URL variables
		if (VAL(URL.agentID)) {
			FORM.agentID = URL.agentID;	
		}
		if (VAL(URL.studentID)) {
			FORM.studentID = URL.studentID;	
		}
		if (VAL(URL.paymentID)) {
			FORM.paymentID = URL.paymentID;	
		}
		if (VAL(URL.payments)) {
			FORM.payments = URL.payments;	
		}
	
		// Data Validation
		if ( NOT VAL(FORM.agentID) AND NOT VAL(FORM.studentID) AND NOT VAL(FORM.paymentID) ) {
			// Error Message
			SESSION.formErrors.Add('You must enter one of the criterias below');			
		}
		
		// Check if there are errors
		if ( SESSION.formErrors.length() ) {			
			// Relocate to Inital page and display error message
			Location("#CGI.SCRIPT_NAME#?curdoc=userPayment/index&errorSection=credits", "no");
		}
		
		// Number of records per page
		vRecordsPerPage = 25;
		
		if (VAL(FORM.payments)) {
			// Get Number of payments records
			vTotalRecords = APPLICATION.CFC.USER.getRepPayments(
				companyID=CLIENT.companyID,
				userID = FORM.agentID,
				studentID = FORM.studentID,
				paymentID = FORM.paymentID,
				onlyPayments = 1,
				orderFor="credits").recordCount;
			
			// Get payment records for this page
			qGetPayments = APPLICATION.CFC.USER.getRepPayments(
				companyID=CLIENT.companyID,
				userID = FORM.agentID,
				studentID = FORM.studentID,
				paymentID = FORM.paymentID,
				onlyPayments = 1,
				orderFor="credits",
				limit=vRecordsPerPage,
				offset=(URL.pageNum-1)*vRecordsPerPage);
		} else {
			// Get Number of payments records
			vTotalRecords = APPLICATION.CFC.USER.getRepPayments(
				companyID=CLIENT.companyID,
				userID = FORM.agentID,
				studentID = FORM.studentID,
				paymentID = FORM.paymentID,
				creditStatus = 0,
				orderFor="credits").recordCount;
			
			// Get payment records for this page
			qGetPayments = APPLICATION.CFC.USER.getRepPayments(
				companyID=CLIENT.companyID,
				userID = FORM.agentID,
				studentID = FORM.studentID,
				paymentID = FORM.paymentID,
				creditStatus = 0,
				orderFor="credits",
				limit=vRecordsPerPage,
				offset=(URL.pageNum-1)*vRecordsPerPage);
		}
		
		// Paging variables
		vNumPages = Ceiling(vTotalRecords / vRecordsPerPage);
		vStartRecord = ((URL.pageNum-1)*vRecordsPerPage)+1;
		vEndRecord = URL.pageNum*vRecordsPerPage;
		if (vTotalRecords EQ 0) {
			vStartRecord = 0;	
		}
		if (vTotalRecords LT vEndRecord) {
			vEndRecord = vTotalRecords;	
		}
		vTotalColumns = 10;
		if (VAL(FORM.payments)) {
			vTotalColumns = 6;	
		}
	</cfscript>
    
    <cfif VAL(FORM.submitted)>
    	
        <cfloop query="qGetPayments">
        	<cfif FORM['creditStatus_' & ID] EQ 1>
            	<cfquery name="qGetPaymentOldID" datasource="#APPLICATION.DSN#">
                	SELECT
                    	CASE
                        	WHEN oldID = 0 THEN ID
                            ELSE (ID * 10) + 1
                      		END AS insertOldID
                    FROM smg_users_payments
                    WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ID)#"> 
                </cfquery>
                <cfquery datasource="#APPLICATION.DSN#">
                	UPDATE smg_users_payments
                    SET creditStatus = 1
                    WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ID)#">
                </cfquery>
                <cfquery datasource="#APPLICATION.DSN#">
                	INSERT INTO smg_users_payments(
                    	agentID,
                        companyID,
                        studentID,
                        programID,
                        old_programID,
                        hostID,
                        reportID,
                        paymenttype,
                        transtype,
                        amount,
                        comment,
                        date,
                        oldID,
                        inputBy,
                        isDeleted,
                        dateCreated,
                        creditStatus
                        <cfif VAL(FORM.payments)>,isPaid</cfif>
                    )
                    VALUES (
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(agentID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(companyID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(studentID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(programID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(old_programID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(hostID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(reportID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(paymenttype)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="Credit">,
                        <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM['creditAmount_' & ID] - (2 * FORM['creditAmount_' & ID])#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['comment_' & ID]#">,
                        <cfif VAL(FORM.payments)>
                        	<cfqueryparam cfsqltype="cf_sql_date" value="#FORM['date_' & ID]#">,
                        <cfelse>
                        	<cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPaymentOldID.insertOldID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="3">
                        <cfif VAL(FORM.payments)>,1</cfif>
                    )
                </cfquery>
            <cfelseif FORM['creditStatus_' & ID] EQ 2>
            	<cfquery datasource="#APPLICATION.DSN#">
                	UPDATE smg_users_payments
                    SET creditStatus = 2
                    WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ID)#">
                </cfquery>
            </cfif>
        </cfloop>
        
        <cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=credits&agentID=#FORM.agentID#&studentID=#FORM.studentID#&paymentID=#FORM.paymentID#&payments=#FORM.payments#&pageNum=#URL.pageNum#">
        
    </cfif>
    
</cfsilent>

<cfoutput>

	<form name="updateCredits" method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=credits&pageNum=#URL.pageNum#">
    	<input type="hidden" name="submitted" value="1" />
        <input type="hidden" name="agentID" value="#FORM.agentID#" />
        <input type="hidden" name="studentID" value="#FORM.studentID#" />
        <input type="hidden" name="paymentID" value="#FORM.paymentID#" />
        <input type="hidden" name="payments" value="#FORM.payments#" />
        
        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
            <tr>
                <td colspan="#vTotalColumns-3#" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Credits</td>
                <td colspan="3" style="background-color:##010066; color:##FFFFFF; font-weight:bold; text-align:right; padding-right:10px;">
                    Records #vStartRecord# to #vEndRecord# of #vTotalRecords# record(s)
                </td>
            </tr>
            <tr style="background-color:##E2EFC7; font-weight:bold;">
                <td width="#100/vTotalColumns#%">Credit Status</td>
                <td width="#100/vTotalColumns#%">Payment ID</td>
                <td width="#100/vTotalColumns#%">Agent</td>
                <cfif NOT VAL(FORM.payments)><td width="12%">Student</td></cfif>
                <td width="#100/vTotalColumns#%">Payment Type</td>
                <td width="#100/vTotalColumns#%">Payment Date</td>
                <td width="#100/vTotalColumns#%">Amount</td>
                <cfif NOT VAL(FORM.payments)>
                	<td width="#100/vTotalColumns#%">Is Paid</td>
                	<td width="#100/vTotalColumns#%">Comment</td>
                	<td width="#100/vTotalColumns#%">Credit Comment</td>
                </cfif>
            </tr>
        
            <cfloop query="qGetPayments">
                <tr bgcolor="###iif(qGetPayments.currentRow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
               		<td>
                    	<select name="creditStatus_#ID#">
                        	<option value="0">Please select</option>
                            <option value="1">Credit</option>
                            <cfif NOT VAL(FORM.payments)><option value="2">Ignore</option></cfif>
                        </select>
                    </td>    
                   	<td>#ID#</td>
                    <td>#agentName# (###agentID#)</td>
                    <cfif NOT VAL(FORM.payments)><td><cfif VAL(studentID)>#studentName# (###studentID#)</cfif></td></cfif>
                    <td>#type#</td>
                    <td>#DateFormat(date,'mm/dd/yyyy')# <input type="hidden" name="date_#ID#" value="#date#" /></td>
                    <td>
                    	<cfif VAL(FORM.payments)>
                        	$#-amount# <input type="hidden" name="creditAmount_#ID#" value="#amount#" />
                        <cfelse>
                    		$<input type="text" name="creditAmount_#ID#" value="#amount#" size="10" />
                      	</cfif>
                  	</td>
                    <cfif NOT VAL(FORM.payments)>
                    	<td>#YesNoFormat(isPaid)#</td>
                        <td>#comment#</td>
                        <td><textarea name="comment_#ID#"></textarea></td>
                   	<cfelse>
                    	<input type="hidden" name="comment_#ID#" value="VOID" />
                  	</cfif>
                </tr>
            </cfloop>
            
            <cfif vNumPages GT 1>
                <tr>
                    <td colspan="10" style="text-align:center;">
                        <cfif URL.pageNum NEQ 1>
                            <a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=credits&agentID=#FORM.agentID#&studentID=#FORM.studentID#&paymentID=#FORM.paymentID#&pageNum=#URL.pageNum-1#"><</a>
                        </cfif>
                        <cfloop from="1" to="#vNumPages#" index="i">
                            <cfif URL.pageNum EQ i>
                                <b>#i#</b>
                            <cfelse>
                                <a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=credits&agentID=#FORM.agentID#&studentID=#FORM.studentID#&paymentID=#FORM.paymentID#&pageNum=#i#">#i#</a>
                            </cfif>
                        </cfloop>
                        <cfif URL.pageNum NEQ vNumPages>
                            <a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=credits&agentID=#FORM.agentID#&studentID=#FORM.studentID#&paymentID=#FORM.paymentID#&pageNum=#URL.pageNum+1#">></a>
                        </cfif>
                    </td>
                </tr>
          	</cfif>
            
            <tr>
            	<td colspan="#vTotalColumns#" style="text-align:center;"><input type="submit" value="Update" /></td>
            </tr>
        
        </table>
        
    </form>
    
</cfoutput>