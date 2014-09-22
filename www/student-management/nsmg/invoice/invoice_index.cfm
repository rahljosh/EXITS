<!--- Request a longer timeout --->
<cfsetting requesttimeout="300">

<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfif isDefined('url.invall')>
	<Cfset form.view = 'all'>
<cfelse>
	<cfset form.view = #client.companyid#>		
</cfif>

<cfif client.companyid is 5>
	<cfoutput>
    	<div align="center">
        	<a href="?curdoc=invoice/invoice_index">Show only SMG</a> :: <a href="?curdoc=invoice/invoice_index&invall">Include all company numbers</a>
     	</div>
	</cfoutput>
</cfif>

Click on Business Name or enter Agent ID to add charges, see current charges, create invoice, credit account, etc.<Br><br>
<!----Sizing table---->

<Table width=100% border=0>
	<tr>
		<td width=50% valign="top">
	
<!----Quick Access Agent---->
					
            <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                <tr valign=middle height=24>
                    <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                    <td width=26 background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
                    <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Specific Agent Quick Access </td><td background="pics/header_background.gif" width=16></a></td>
                    <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
                </tr>
            </table>
						
            <table width=100% cellpadding=2 cellspacing=0 border=0 class="section" >
                <tr>
                    <td style="line-height:20px;" valign="top">
                        <table>
                            <tr>
                                <td valign="top" width=60%>
                                    Do you know the Agent ID?<br>
                                    Enter it here, and click next<br> to access their account.<br><br>
                                    <form action="index.cfm?curdoc=invoice/account_redirect" method="post">Agent ID: <input type="text" name="userid" size=5> <input type="image" value=" New Ticket " src="pics/next.gif" align="middle"></form>
                                </td>
                                <td>&nbsp;</td>
                                <td valign="top">
                                    <cfoutput>
                                        <u>Last Five Accessed Agents</u><br>
                                        <cfif isDefined('cookie.intagentlist')>
                                            <cfloop list=#cookie.intagentlist# index=x>
                                                <cfquery name="agent_name" datasource="#APPLICATION.DSN#">
                                                    SELECT businessname
                                                    FROM smg_users
                                                    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
                                                </cfquery>
                                                <a href="?curdoc=invoice/user_account_details&userid=#x#">#agent_name.businessname#</a><br>
                                            </cfloop>
                                        <cfelse>
                                            List not available.
                                        </cfif>
                                    </cfoutput>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
                    
			<!----footer of table---->
            <table width=100% cellpadding=0 cellspacing=0 border=0>
                <tr valign=bottom >
                    <td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
                    <td width=100% background="pics/header_background_footer.gif"></td>
                    <td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
                </tr>
            </table>
            
		</td>
		<td>&nbsp;</td>
		<td valign="top">
        
			<!----Finance Reports---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                <tr valign=middle height=24>
                    <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                    <td width=26 background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
                    <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Finance Reports & Tools </td><td background="pics/header_background.gif" width=16></a></td>
                    <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
                </tr>
            </table>
			
            <table width=100% cellpadding=4 cellspacing=0 border=0 class="section" >
                <tr>
                    <td style="line-height:20px;" valign="top">
                    	<table width = 100%>
                            <tr>
                                <td bgcolor=#e2efc7 width=50%>::Reports</td><td bgcolor=#e2efc7>::Tools</td>
                            </tr>
                            <tr>
                                <td valign="top"><!----Reports---->
                                    <a href="invoice/reports/outstanding_balances.cfm">Balance Report</a><br />
                                    <a href="?curdoc=invoice/reports/balance_report_options">Balance Report w/ options</a><br />
                                    <a href="invoice/m_balanceReport.cfm?RequestTimeout=3000" target="_blank">Balance Report per Program</a><br />
                                </td>
                                <td valign="top"><!----Tools---->
                                    <a href="?curdoc=invoice/int_rep_rates&userid=all&compid=1">International Rep Rates</a><br />
                                    <a href="?curdoc=invoice/insurance_rates">Insurance Rates</a><br />
                                    <a href="index.cfm?curdoc=tools/programs">Program Maintenance</a><br />
                                    <a href="?curdoc=invoice/reports/check_fees_menu">Check Fees Per Intl. Rep</a><br />
                                </td>
                            </tr>
                    	</table>
					</td>
				</tr>
			</table>
            
			<!----footer of table---->
            <table width=100% cellpadding=0 cellspacing=0 border=0>
                <tr valign=bottom >
                    <td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
                    <td width=100% background="pics/header_background_footer.gif"></td>
                    <td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
                </tr>
            </table>
            
        </td>
    </tr>
</table>

<br>

<!----Retrieve all int reps, and sum of payments received, credtis, and charges outstainding.---->

<!----Retrive list of reps---->
<cfquery name="get_int_Reps" datasource="#APPLICATION.DSN#">
    SELECT  distinct smg_users.userid, smg_users.firstname, smg_users.lastname, smg_users.businessname, smg_users.userid, smg_users.usertype
    FROM smg_users
    WHERE smg_users.usertype = 8
    ORDER BY businessname
</cfquery>

<style type="text/css">
	div.scroll2 {
		height: 220px;
		width:auto;
		overflow:auto;
		border-left: 2px solid #c6c6c6;
		border-right: 2px solid #c6c6c6;
		background: #Ffffe6;
		left:auto;
	}
</style>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
    <tr valign=middle height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=26 background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
        <td background="pics/header_background.gif"><h2>All International Agents</td><td background="pics/header_background.gif" align="right" ><h2>Totals for <cfoutput>#client.programmanager#</cfoutput></td>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<div class="scroll2">
	<table width=100% cellpadding=4 cellspacing=0 border=0 >

        <tr bgcolor="#eeeeee">
            <TD>Business Name</TD><td># to Inv.</td><td>Due</td><td>Received</td><Td>Credit</Td><td>Outstanding</td>
        </tr>
	
		<cfoutput query="get_int_reps">
            
            <cfquery name="total_Due" datasource="#APPLICATION.DSN#">
                SELECT IFNULL(sum(amount_due),0) as amount_due
                FROM smg_charges
                WHERE agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(userID)#"> 
                <cfif form.view is not 'all'>
                    AND companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
                </cfif>
            </cfquery>
        
            <cfif total_due.amount_due is ''>
                <cfset total_due.amount_due = 0>
            </cfif>
        
            <cfquery name="total_received" datasource="#APPLICATION.DSN#">
                SELECT ifnull(sum(totalreceived),0) as total_received
                FROM smg_payment_received
                WHERE agentid = #userid# 			
                <cfif form.view is not 'all'>
                    AND companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
                </cfif>
            </cfquery>
            
            <cfif total_received.total_received is ''>
                <cfset total_received.total_received = 0>
            </cfif>
            
            <!----total credits in system---->
            <cfquery name="total_Credit_amount" datasource="#APPLICATION.DSN#">
                SELECT IFNULL(sum(amount),0) as credit_amount
                FROM smg_credit
                WHERE agentid = #userid#
                <cfif form.view is not 'all'>
                    AND companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
                </cfif>
                AND active = 1
            </cfquery>
            
            <cfif total_Credit_amount.credit_amount is ''>
                <cfset total_Credit_amount.credit_amount = 0>
            </cfif>
        
            <!----Total credits applied---->
            <cfquery name="total_Credit_applied" datasource="#APPLICATION.DSN#">
                SELECT ifnull(sum(amount_applied),0) as credit_amount
                FROM smg_credit
                WHERE agentid = #userid#
                <cfif form.view is not 'all'>
                    AND companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
                </cfif>
                AND active = 1
            </cfquery>
            
            <cfif total_Credit_applied.credit_amount is ''>
                <cfset total_Credit_applied.credit_amount = 0>
            </cfif>
        
            <cfset total_credit = #total_credit_amount.credit_amount# - #total_credit_applied.credit_amount#>
        
            <cfquery name="overpayment_credit" datasource="#APPLICATION.DSN#">
                SELECT ifnull(sum(amount),0) as overpayment_amount
                FROM smg_credit
                WHERE agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#userID#">
                AND payref <> '' 
                AND active = 0
                <cfif form.view is not 'all'>
                    AND companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
                </cfif>
            </cfquery>
            
            <cfif overpayment_credit.overpayment_amount is ''>
                <cfset overpayment_credit.overpayment_amount = 0>
            </cfif>


            <cfquery name="total_refund" datasource="#APPLICATION.DSN#">
                SELECT IFNULL(sum(smg_credit.amount),0) as total_refund
                FROM smg_invoice_refunds right join smg_credit on smg_invoice_refunds.creditid = smg_credit.creditid
                WHERE smg_invoice_refunds.agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#userID#">
                <cfif form.view is not 'all'>
                    AND smg_invoice_refunds.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
                </cfif>
            </cfquery>
            
            <cfif total_refund.total_refund is ''>
                <cfset total_refund.total_refund = 0>
            </cfif>

            <cfquery name="refunds" datasource="#APPLICATION.DSN#">
                SELECT smg_invoice_refunds.creditid, smg_invoice_refunds.id, smg_invoice_refunds.refund_receipt_id, smg_invoice_refunds.date, smg_invoice_refunds.amount,
                    smg_credit.creditid, smg_credit.amount as credit_amount, smg_credit.description
                FROM smg_invoice_refunds right join smg_credit on smg_invoice_refunds.creditid = smg_credit.creditid
                WHERE smg_invoice_refunds.agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#userID#">
                <cfif form.view is not 'all'>
                    AND smg_invoice_refunds.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
                </cfif>
                AND smg_invoice_refunds.refund_receipt_id = 0
            </cfquery>
            
            <!----Refund Query not combined---->
            <cfquery name="refunds1" datasource="#APPLICATION.DSN#">
                SELECT  distinct smg_invoice_refunds.refund_receipt_id
                FROM smg_invoice_refunds 
                WHERE smg_invoice_refunds.agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#userID#">
                <cfif form.view is not 'all'>
                    AND smg_invoice_refunds.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
                </cfif>
                AND smg_invoice_refunds.refund_receipt_id <> 0
            </cfquery>
			
            <cfquery name="agents_Students" datasource="#APPLICATION.DSN#">
                SELECT studentid
                FROM smg_students 
                WHERE intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#userid#"> 
                AND companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
            </cfquery>

            <cfset balance_due = #total_due.amount_due# - #total_credit#- #total_received.total_received# + #overpayment_credit.overpayment_amount#>
            
            <tr <cfif get_int_reps.currentrow mod 2>bgcolor="##ffffff"</cfif>>
                <td><a href="?curdoc=invoice/user_account_details&userid=#userid#">#businessname# (#userid#)</a></td>
                <td>#agents_students.recordcount#</td>
                <td><cfif total_Due.amount_due is ''>N/A <cfset amount_due = 0><cfelse>#LSCurrencyFormat(total_due.amount_due, 'local')# <Cfset amount_due = #total_due.amount_due#></cfif></td>
                <td><cfif total_received.total_received is ''>N/A <cfset amount_paid = 0><cfelse>#LSCurrencyFormat(total_received.total_received, 'local')# <Cfset amount_paid = #total_received.total_received#></cfif></td>
                <td><cfif total_credit is ''>N/A <cfset credit_Amount = 0><cfelse>#LSCurrencyFormat(total_credit, 'local')#<Cfset credit_amount = #total_credit#></cfif></td>
                <td>#LSCurrencyFormat(balance_due, 'local')#</td>
            </tr>
    
        </cfoutput>
           
		<tr>
            <cfquery name="sum_due" datasource="#APPLICATION.DSN#">
            	SELECT IFNULL(sum(amount_due),0) as total_amount_due 
                FROM smg_charges 
       			<cfif form.view is not 'all'>
                	WHERE companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
                </cfif>
            </cfquery>
      		
            <cfquery name="sum_received" datasource="#APPLICATION.DSN#">
            	SELECT ifnull(sum(totalreceived),0) as total_received
                FROM smg_payment_received 
       			<cfif form.view is not 'all'>
                	WHERE companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
                </cfif>
            </cfquery>
            
			<cfoutput>
          		<td align="right">Totals</td>
                <td></td>
                <td>#LSCurrencyFormat(sum_due.total_amount_due, 'local')#</td>
                <td>#LSCurrencyFormat(sum_received.total_received, 'local')#</td>
                <td></td>
                <td><cfset outstanding_total = #sum_due.total_amount_due# - #sum_received.total_received#>#LSCurrencyFormat(outstanding_total, 'local')#</td>
      		</cfoutput>
		</tr>
	</table>
</div>

<!----footer of table--->
<table width=100% cellpadding=0 cellspacing=0 border=0>
    <tr valign=bottom >
        <td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
        <td width=100% background="pics/header_background_footer.gif"></td>
        <td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
    </tr>
</table>