<!--- ------------------------------------------------------------------------- ----
	
	File:		_checkSummary.cfm
	Author:		James Griffiths
	Date:		April 11, 2014
	Desc:		Shows a list checks paid
				
----- ------------------------------------------------------------------------- --->

<cfparam name="FORM.checkDate" default="">
<cfparam name="FORM.submitted" default="0">

<cfif VAL(FORM.submitted)>

    <cfquery name="qGetChecks" datasource="#APPLICATION.DSN#">
        SELECT 
            p.ID,
            p.agentID,
            p.date,
            p.amount*(-1) AS amount,
            r.firstName,
            r.middleName,
            r.lastName
        FROM smg_users_payments p
        INNER JOIN smg_users r ON r.userID = p.agentID
        WHERE p.creditStatus = 3
        AND p.transtype = "Payment"
        AND p.paymenttype = 37
        AND p.date = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.checkDate#">
        ORDER BY p.date DESC, r.firstName, r.lastName
    </cfquery>
</cfif>

<cfoutput>

	<!--- Check Summary --->
    <form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=checkSummary">
        <input type="hidden" name="submitted" value="1">
        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
            <tr>
                <td colspan="2" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Check Summary</td>
            </tr>
            <tr>		
                <td align="center"><br>
                    Date: <input type="text" name="checkDate" class="datePicker" value="<cfif IsDate(FORM.checkDate)>#checkDate#<cfelse>#DateFormat(NOW(),'mm/dd/yyyy')#</cfif>" />
                </td>
            </tr>
            <tr style="background-color:##E2EFC7;">
                <td align="center" colspan="2"><input name="submit" type="image" src="pics/submit.gif" align="center" border="0" alt="Next"></td>
            </tr>
        </table>
    </form>
    <!--- End of Check Summary --->
    
    <cfif VAL(FORM.submitted)>
		<table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
            <tr>
                <td colspan="3" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Results</td>
                <td colspan="2" style="background-color:##010066; color:##FFFFFF; font-weight:bold; text-align:right; padding-right:10px;">
                    Total of #qGetChecks.recordCount# record(s) <cfif IsDate(FORM.checkDate)>for #FORM.checkDate#</cfif>
                </td>
            </tr>
            <tr style="background-color:##E2EFC7; font-weight:bold;">
                <td>ID</td>
                <td>Representative</td>
                <td>Date</td>
                <td>Amount</td>
                <td>Running Total</td>
            </tr>
            
            <cfset vRunningTotal = 0>
        
            <cfloop query="qGetChecks">
                <cfset vRunningTotal = vRunningTotal + amount>
                <tr bgcolor="###iif(qGetChecks.currentRow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                    <td>#ID#</td>
                    <td>#firstName# #middleName# #lastName# - #agentID#</td>
                    <td>#DateFormat(date,'mm/dd/yyyy')#</td>
                    <td>#LSCurrencyFormat(amount,'local')#</td>
                    <td>#LSCurrencyFormat(vRunningTotal,'local')#</td>
                </tr>
            </cfloop>
        
        </table>
    </cfif>
    
</cfoutput>