<!--- ------------------------------------------------------------------------- ----
	
	File:		_incentiveTripPayment.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Records Incentive Trip Payments
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
    
    <!--- Param FORM variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.userID" default="0">
    <cfparam name="FORM.paymentType" default="0">
    <cfparam name="FORM.amount" default="0">
    <cfparam name="FORM.comments" default="0">

	<!--- Representative not selected - Display error message --->
	<cfif NOT VAL(FORM.userID)>
		<cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&displayIncentiveTripError=1" addtoken="no">
	</cfif>

    <cfquery name="qGetTripInfo" datasource="MySQL">
        SELECT 
        	id,
            type             
        FROM 
        	smg_payment_types 
        WHERE 
        	paymenttype = <cfqueryparam cfsqltype="cf_sql_varchar" value="Trip">
    </cfquery>
    
    <cfquery name="qGetRepInfo" datasource="MySQL">
        SELECT 
        	userID,
            firstName,
            lastName
        FROM 
        	smg_users
        WHERE 
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#userID#">
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
                    studentid,
                    paymenttype, 
                    date, 
                    transtype, 
                    inputby, 
                    amount, 
                    companyid, 
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
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.comments#">
				)
            </cfquery>

        </cftransaction>
        
        <!--- Location --->
        <cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=incentiveTripPayment&userID=#FORM.userID#&paymentID=#newRecord.GENERATED_KEY#" addtoken="no">
    
    </cfif>
    
</cfsilent>

<cfoutput>

    <h2>
        Representitive: #qGetRepInfo.firstname# #qGetRepInfo.lastname# (###qGetRepInfo.userid#) &nbsp; <span class="get_attention"><b>::</b></span>
		<a href="javascript:openPopUp('userPayment/index.cfm?action=paymentHistory&userid=#qGetRepInfo.userid#', 700, 500);" class="nav_bar">Payment History</a>
    </h2> <br />

	<!--- Display Payment Confirmation --->
    <cfif qGetPaymentDetails.recordCount>
    
        Below is a summary of the payment recorded. <br />
        
        <table width="90%" cellpadding="4" cellspacing="0">
            <tr>
                <td bgcolor="##010066" colspan="5"><font color="white"><strong>Placed Students</strong></font></td>
            </tr>
            <tr bgcolor="##E5E5E5">
                <Td >Payment ID</Td><td>Type</td><td>Amount</td><td>Comment</td>
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
    
        Fill in the details for the Incentive Trip Payment.<br />
        
        <cfform method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=incentiveTripPayment">
            <input type="hidden" name="submitted" value="1">
            <input type="hidden" name="userID" value="#FORM.userID#">
        
            <table width="90%" cellpadding="4" cellspacing="0">
                <tr>
                    <td bgcolor="##010066" colspan=3><font color="white"><strong>Incentive Trip </strong></font></td>
                </tr>
                <tr bgcolor="##E5E5E5">
                    <td>Type</td><td>Amount</td><td>Comment</td>
                </tr>
                <tr>
                    <td width="20%">
                        <cfselect name="paymentType" required="yes" message="Please select a type">
                            <Cfloop query="qGetTripInfo">
                                <option value="#id#">#type#</option>	
                            </Cfloop>
                        </cfselect>
                    </td>  
                    <td width="10%"><cfinput type="text" name="amount" size=6 required="yes" message="Please enter an amount"></td>
                    <td width="70%"><input type="text" name="comments" size="40"></td>
                </tr>                
                <tr>
                    <td colspan="5" align="right"><cfinput name="submit" type="image" src="pics/submit.gif" align="right" border="0" alt="submit" submitOnce></td>
                </Tr>
            </table>
            
        </cfform>
    
    </cfif>

</cfoutput>