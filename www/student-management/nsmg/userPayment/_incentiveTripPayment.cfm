<!--- ------------------------------------------------------------------------- ----
	
	File:		_incentiveTripPayment.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Records Incentive Trip Payments
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <cfscript>
		// Data Validation
		if ( NOT VAL(FORM.userID) ) {
			// Error Message
			SESSION.formErrors.Add('You must select one representative');			
		}
		
		// Check if there are errors
		if ( SESSION.formErrors.length() ) {			
			// Relocate to Inital page and display error message
			Location("#CGI.SCRIPT_NAME#?curdoc=userPayment/index&errorSection=incentiveTrip", "no");
		}
		
		// Get Rep Information
		qGetRepInfo = APPLICATION.CFC.USER.getUserByID(userID=VAL(FORM.userID));
	</cfscript>
    
    <cfquery name="qGetTripInfo" datasource="MySQL">
        SELECT 
        	id,
            type             
        FROM 
        	smg_payment_types 
        WHERE 
        	paymenttype = <cfqueryparam cfsqltype="cf_sql_varchar" value="Trip">
    </cfquery>

    <cfquery name="qGetPaymentDetails" datasource="MySQL">
        SELECT 
        	srp.id,            
            srp.amount,
            srp.comment,
            spt.type
        FROM 
        	smg_rep_payments srp
        INNER JOIN 
        	smg_payment_types spt ON srp.paymenttype = spt.id 
        WHERE
        	srp.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymentID#">
    </cfquery>
    
    <!--- FORM Submitted --->
    <cfif FORM.submitted>

        <cftransaction action="begin" isolation="serializable">
            
            <cfquery datasource="MySQL" result="newRecord">
                INSERT INTO 
                	smg_rep_payments 
                (
                	agentid, 
                    studentID,
                    paymenttype, 
                    date, 
                    transtype, 
                    inputby, 
                    amount, 
                    companyID, 
                    comment
				)
				VALUES 
                (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.paymentType#">, 
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="Trip">,  
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.amount#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.comments#">
				)
            </cfquery>

        </cftransaction>
        
        <!--- Location --->
        <cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=incentiveTripPayment&userID=#FORM.userID#&paymentID=#newRecord.GENERATED_KEY#" addtoken="no">
    
    </cfif>
    
</cfsilent>

<cfoutput>

    <h2 style="margin-top:10px;">
        Representative: #qGetRepInfo.firstName# #qGetRepInfo.lastname# (###qGetRepInfo.userid#) &nbsp; <span class="get_attention"><b>::</b></span>
        <a href="javascript:openPopUp('userPayment/index.cfm?action=paymentHistory&userid=#qGetRepInfo.userid#', 700, 500);" class="nav_bar">Payment History</a>
    </h2>

	<!--- Display Payment Confirmation --->
    <cfif qGetPaymentDetails.recordCount>
    
        <div style="margin-top:10px;">Below is a summary of the recorded payments:</div>

        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;"> 
            <tr>
                <td colspan="4" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Incentive Trip Payment</td>
            </tr>
            <tr style="background-color:##E2EFC7; font-weight:bold;">
                <td width="10%">Payment ID</td>
                <td width="20%">Type</td>
                <td width="10%">Amount</td>
                <td width="60%">Comment</td>
            </tr>
            <tr>
                <td width="10%">#qGetPaymentDetails.id#</td>
                <Td width="20%">#qGetPaymentDetails.type#</Td>  
                <td width="10%">#LSCurrencyFormat(qGetPaymentDetails.amount, 'local')#</td>
                <td width="60%">#qGetPaymentDetails.comment#</td>
            </tr>
        </table>
        
        <br />

        <div align="center"><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index"><img src="pics/newpayment.gif" border="0" align="bottom"></a></div>
        
    <!--- Display FORM --->
    <cfelse>
    
        <div style="margin-top:10px;">Fill in the details for the Incentive Trip Payment.</div>
        
        <cfform method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=incentiveTripPayment">
            <input type="hidden" name="submitted" value="1">
            <input type="hidden" name="userID" value="#FORM.userID#">

            <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;"> 
                <tr>
                    <td colspan="3" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Incentive Trip Payment</td>
                </tr>
                <tr style="background-color:##E2EFC7; font-weight:bold;">
                    <td width="20%">Type</td>
                    <td width="10%">Amount</td>
                    <td width="70%">Comment</td>
				</tr>
	            <tr>
                    <td>
                        <cfselect name="paymentType" required="yes" message="Please select a type" class="mediumField">
                            <Cfloop query="qGetTripInfo">
                                <option value="#id#">#type#</option>	
                            </Cfloop>
                        </cfselect>
                    </td>  
                    <td><cfinput type="text" name="amount" size="6" required="yes" message="Please enter an amount"></td>
                    <td><input type="text" name="comments" size="40"></td>
                </tr>                
                <tr style="background-color:##E2EFC7;">
                    <td colspan="5" align="center"> <input name="submit" type="image" src="pics/submit.gif" border="0" alt="submit"></td>
                </tr>
            </table>
            
        </cfform>
    
    </cfif>

</cfoutput>