<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfloop list="#form.agentId#" index="indexAgentId">
	
    <cfif ISDEFINED('form.email#indexAgentId#')>
    
        <cfquery name="getInvoicesCreditNotes" datasource="MySQL">
        SELECT t.invoice, t.invoiceid, t.date, SUM( t.amount_due ) AS invBalance, t.companyid, t.testCompId
        FROM (
        SELECT 'invoice', sc.invoiceid, sc.date, sc.amount_due, sc.companyid, (CASE 
WHEN sp.type IN (7,8,9) THEN 7
WHEN sp.type = 11 THEN 8
WHEN sc.companyid IN (1,2,3,4,5,12) THEN 1
ELSE sc.companyid
END) AS testCompId
        FROM smg_charges sc
        LEFT JOIN smg_programs sp ON sp.programid = sc.programid
        WHERE sc.agentid = #indexAgentId#
        <cfif CLIENT.companyID EQ 14>
        	AND sc.companyid = 14
        <cfelse>
        	AND sc.companyid IN (1,2,3,4,5,7,8,10,12)
        </cfif>
        UNION ALL
        SELECT 'payment', sc.invoiceid, spr.date, SUM( spc.amountapplied ) * -1 AS amountApplied, spr.companyid, (CASE 
WHEN sp.type IN (7,8,9) THEN 7
WHEN sp.type = 11 THEN 8
WHEN spr.companyid IN (1,2,3,4,5,12) THEN 1
ELSE spr.companyid
END) AS testCompId
        FROM smg_payment_charges spc
        LEFT JOIN smg_charges sc ON sc.chargeid = spc.chargeid
        LEFT JOIN smg_programs sp ON sp.programid = sc.programid
        LEFT JOIN smg_payment_received spr ON spr.paymentid = spc.paymentid
        WHERE spr.agentid = #indexAgentId#
        <cfif CLIENT.companyID EQ 14>
        	AND sc.companyid = 14
        <cfelse>
        	AND sc.companyid IN (1,2,3,4,5,7,8,10,12)
        </cfif>
        GROUP BY sc.invoiceid
        )t
        GROUP BY t.invoiceid HAVING invBalance > 0
        UNION ALL
        SELECT 'credit note', sc.creditid, sc.date, SUM(sc.amount - sc.amount_applied)*-1, sc.companyid, (CASE 
WHEN sp.type IN (7,8,9) THEN 7
WHEN sp.type = 11 THEN 8
WHEN sc.companyid IN (1,2,3,4,5,12) THEN 1
ELSE sc.companyid
END) AS testCompId
        FROM smg_credit sc
        LEFT JOIN smg_charges sch ON sch.chargeid = sc.chargeid
        LEFT JOIN smg_programs sp ON sp.programid = sch.programid
        WHERE sc.agentid = #indexAgentId#
        <cfif CLIENT.companyID EQ 14>
        	AND sc.companyid = 14
        <cfelse>
        	AND sc.companyid IN (1,2,3,4,5,7,8,10,12)
        </cfif>
        AND sc.active = 1
        GROUP BY creditid
        ORDER BY date DESC
        </cfquery>

<!--- 		<cfquery name="getTotalBalancePerAgent" datasource="MySQL"> 
        SELECT t.agentid, t.businessname, SUM(t.total) AS totalPerAgent
        FROM (
        SELECT sch.agentid, su.businessname, sch.programid, IFNULL(SUM(sch.amount_due),0) AS total, (CASE 
WHEN sp.type IN (7,8,9) THEN 7
WHEN sp.type = 11 THEN 8
WHEN sch.companyid IN (1,2,3,4,5,12) THEN 1
ELSE sch.companyid
END) AS testCompId
        FROM smg_charges sch
        LEFT JOIN smg_programs sp ON sp.programid = sch.programid
        LEFT JOIN smg_users su ON su.userid = sch.agentid
        WHERE sch.agentid = #indexAgentId#
        AND sch.companyid IN (1,2,3,4,5,7,8,10,12)
        GROUP BY sch.agentid
        UNION ALL
        SELECT sch.agentid, su.businessname, sch.programid, IFNULL(SUM(spc.amountapplied)*-1,0) AS total,  
(CASE 
WHEN sp.type IN (7,8,9) THEN 7
WHEN sp.type = 11 THEN 8
WHEN sch.companyid IN (1,2,3,4,5,12) THEN 1
ELSE sch.companyid
END) AS testCompId
        FROM smg_payment_charges spc
        LEFT JOIN smg_charges sch ON sch.chargeid = spc.chargeid
        LEFT JOIN smg_programs sp ON sp.programid = sch.programid
        LEFT JOIN smg_users su ON su.userid = sch.agentid
        WHERE  sch.agentid = #indexAgentId#
        AND sch.companyid IN (1,2,3,4,5,7,8,10,12)
        GROUP BY sch.agentid
        UNION ALL
        SELECT sc.agentid, su.businessname, sch.programid, IFNULL(SUM(sc.amount - sc.amount_applied)* -1,0) AS total, 
(CASE 
WHEN sp.type IN (7,8,9) THEN 7
WHEN sp.type = 11 THEN 8
WHEN sc.companyid IN (1,2,3,4,5,12) THEN 1
ELSE sc.companyid
END) AS testCompId
        FROM smg_credit sc
        LEFT JOIN smg_charges sch ON sch.chargeid = sc.chargeid
        LEFT JOIN smg_programs sp ON sp.programid = sch.programid
        LEFT JOIN smg_users su ON su.userid = sc.agentid
        WHERE sc.active =1
        AND sc.companyid IN (1,2,3,4,5,7,8,10,12)
        AND sc.agentid = #indexAgentId#
        GROUP BY sc.agentid
        ) t
        GROUP BY t.agentid    
        </cfquery> --->
        
        <cfquery name="getCompIDs" dbtype="query"> 
        SELECT
        	distinct(testCompID) as compID
        FROM
        	getInvoicesCreditNotes
        </cfquery>
        
        <cfquery name="getTotalBalancePerAgent" dbtype="query"> 
        SELECT
            SUM(invBalance) AS totalPerAgent
        FROM
            getInvoicesCreditNotes
        </cfquery>
        
        <cfquery name="getAgentInfo" datasource="MySQL">
        SELECT *
        FROM smg_users su
        WHERE su.userid = #indexAgentId#
        </cfquery>
        
        <cfparam name="missingEmail" default="0">
        <cfif getAgentInfo.email IS "" AND getAgentInfo.billing_email IS "">
        	<cfset missingEmail = 1>
        </cfif>
        
        <cfif getAgentInfo.email IS NOT "" AND getAgentInfo.billing_email IS "">
        	<cfquery name="getAgentInfoSecRun" datasource="MySQL">
            UPDATE smg_users su
            SET su.billing_email = su.email
            WHERE userid = #indexAgentId#
            </cfquery>
            
            <cfquery name="getAgentInfo" datasource="MySQL">
            SELECT *
            FROM smg_users su
            WHERE su.userid = #indexAgentId#
            </cfquery>
        </cfif>
        
        <cfif getAgentInfo.billing_email IS NOT "" AND getTotalBalancePerAgent.totalPerAgent GT 0>
        
<cfswitch expression="#CLIENT.companyID#">	
	<cfcase value="14">
		<cfset emailFrom = 'stacy@exchange-service.org'>
	</cfcase>
	<cfdefaultcase>
		<cfset emailFrom = 'jennifer@iseusa.org'>
	</cfdefaultcase>
</cfswitch>

            <cfmail from="#VARIABLES.emailFrom#" to="#getAgentInfo.billing_email#" bcc="#VARIABLES.emailFrom#" subject="#getAgentInfo.businessname# - Account Balance Update" type="html">
            
                <style type="text/css">
    
                    table.frame 
                    {
                    border-style:solid;
                    border-width:thin;
                    border-color:##004080;
                    border-collapse:collapse;
                    background-color:##FFFFE1;
                    padding:2px;
                    }
                    
                    td.right
                    {
                    font:Arial, Helvetica, sans-serif;
                    font-style:normal;
                    font-size:medium;
                    color:##FFFFFF;
                    font-weight:bold;
                    border-right-style:solid;
                    border-right-width:thin;
                    border-right-color:##004080;
                    border-right-collapse:collapse;
                    padding:4px;
                    }
                    
                    .two
                    {
                    font:Arial, Helvetica, sans-serif;
                    font-style:normal;
                    font-size:medium;
                    border-right-style:solid;
                    border-right-width:thin;
                    border-right-color:##004080;
                    border-right-collapse:collapse;
                    padding:4px;
                    }
                    
                    tr.darkBlue
                    {
                    background-color:##0052A4;
                    }
                
                    .style2 {color: ##FF0000}
                
                </style>
            
                Dear Partner<br/><br/>
                
                This e-mail is to keep you posted on the status of your account.<br/><br/>
                
                As of now, your account has a total outstanding balance amount <strong>#LsCurrencyFormat(getTotalBalancePerAgent.totalPerAgent)#</strong> as follows:<br/><br/>
            
    			<cfloop query="getCompIDs">
                
                    <table class="frame">
                                
                        <tr class="darkBlue">
                            <td class="right"><strong><small>Type</small></strong></td>
                            <td class="right"><strong><small>Docum Numb</small></strong></td>
                            <td class="right"><strong><small>Date Created</small></strong></td>
                            <td class="right"><strong><small>Amount</small></strong></td>
                            <td class="right"><strong><small>Company</small></strong></td>
                        </tr>
                        
                        <cfquery name="getInvCredNotes" dbtype="query">
                        SELECT *
                        FROM getInvoicesCreditNotes
                        WHERE testCompId = #getCompIDs.compID#
                        </cfquery>
                        
                        <cfloop query="getInvCredNotes">
                                 
                            <cfswitch expression="#getInvCredNotes.testCompId#">
                                <cfcase value="1,2,3,4,12">
                                    <cfset company = 'ISE High School'>
                                </cfcase>
                                <cfcase value="5">
                                    <cfset company = 'SMG'>
                                </cfcase>
                                <cfcase value="7">
                                    <cfset company = 'Trainee'>
                                </cfcase>
                                <cfcase value="8">
                                    <cfset company = 'CSB Work & Travel'>
                                </cfcase>
                                <cfcase value="10">
                                    <cfset company = 'CASE High School'>
                                </cfcase>
                                <cfcase value="14">
                                    <cfset company = 'ESI'>
                                </cfcase>
                            </cfswitch>
                
                            <tr <cfif getInvCredNotes.currentRow MOD 2>bgcolor="##FFFFFF"</cfif>>
                                <td class="two <cfif getInvCredNotes.invBalance LT 0>style2</cfif>"><small>#getInvCredNotes.invoice#</small></td>
                                <td class="two">
                                    <cfif getInvCredNotes.invoice IS "invoice">
                                        <small><a href="#CLIENT.exits_url#/nsmg/intrep/invoice/invoice_view.cfm?id=#getInvCredNotes.invoiceid#" target="_top">#getInvCredNotes.invoiceid#</a></small>
                                        <cfelse>
                                            <small><a href="#CLIENT.exits_url#/nsmg/intrep/invoice/credit_note.cfm?creditid=#getInvCredNotes.invoiceid#" target="_top">#getInvCredNotes.invoiceid#</a></small>
                                    </cfif>
                                </td>
                                <td class="two"><small>#DateFormat(getInvCredNotes.date,'mm/dd/yyyy')#</small></td>
                                <td class="two <cfif getInvCredNotes.invBalance LT 0>style2</cfif>"><small>#LsCurrencyFormat(getInvCredNotes.invBalance)#</small></td>
                                <td class="two"><small>#variables.company#</small></td>
                            </tr>
                        
                        </cfloop>
                        
                        <cfquery name="getBalPerComp" dbtype="query"> 
                        SELECT
                            SUM(invBalance) as compBal
                        FROM
                            getInvoicesCreditNotes
                        WHERE
                            testCompID = #compID#
                        </cfquery>
            
                        <tr style="background-color:##0052A4;">
                            <td class="right"></td>
                            <td class="right"></td>
                            <td class="right"><strong><small>Total</small></strong></td>
                            <td class="right"><strong><small>#LsCurrencyFormat(getBalPerComp.compBal)#</small></strong></td>
                            <td class="right"></td>
                        </tr>
                                
                    </table><br/>
                
                </cfloop>
        
                We will appreciate if you transfer the total amount <strong>#LsCurrencyFormat(getTotalBalancePerAgent.totalPerAgent)#</strong> as soon as possible. 
                <cfif CLIENT.companyID NEQ 14>
                Please check the invoices for the correct bank account when making payments since ISE, CSB and CASE are separate companies and thus have their own bank accounts. Payments remitted to the wrong bank account will be returned to your bank account without exception.<br/><br/>
                </cfif>
                
                <small><strong>Notes:</strong><br/><br/>
                
                <!--- - <span style="font-size:medium; color:##0000A0">"You can "<span style="font-size:medium; color:##FF0000">view</span>" and "<span style="font-size:medium; color:##FF0000">print</span>" your invoices and credit notes by clicking on the "<strong><span style="font-size:medium; color:##000000">Docum Numb</span></strong>" on the table above. In order to do this, you need to log in into your EXITS account (<a href="#CLIENT.exits_url#/flash/" target="_top"><strong>click here to log in</strong></a>, when the page pops up click on "EXITS login portal", then enter your username and password).</span><br/><br/> --->
                
                - The amounts in <span style="font-size:small; font-weight:bolder; color:##FF0000">red</span> between parentheses are negative values that decrease your balance. They represent the credit notes that were issued to cancel/offset charges that are no longer due. If you wish to apply a credit note against an unpaid invoice, you can just send me an e-mail requesting it (credit notes must be applied against invoices under the same company).<br/><br/>
                
                - When sending payments, please e-mail us the wire receipt (along with information on the invoice number(s) and respective amount(s) being paid) so that we can identify your payment and properly apply it to your account. This will help us keep both records, yours and ours on the same page.<br/><br/>
                
                - Please allow 2 weeks for payment processing, in other words, if you have sent a payment for an invoice listed above within the past 2 weeks, your payment is yet to be processed. If you have sent a payment more than 2 weeks ago, please e-mail me the wire receipt so that I can work with our bank to identify the missing payment.<br/><br/></small>
                
                Thank you for your cooperation.<br/><br/>
                
                Best regards,<br/>
                <cfswitch expression="#CLIENT.companyID#">	
                    <cfcase value="14">
                        Stacy
                    </cfcase>
                    <cfdefaultcase>
                        Bryan
                    </cfdefaultcase>
                </cfswitch>
    
            </cfmail>
            
            <cfelse>
            	Missing Email:	<cfoutput>
                					<a href="#CLIENT.exits_url#/nsmg/index.cfm?curdoc=forms/edit_user&userid=#indexAgentId#" target="_blank">#getAgentInfo.businessname#</a>
								</cfoutput><br/>
            
    	</cfif>
	
	</cfif>

</cfloop>

<cfif variables.missingEmail NEQ 1>
	<script>
        window.close();
    </script>
</cfif>