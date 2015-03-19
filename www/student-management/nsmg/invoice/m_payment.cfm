<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Payments</title>
<link rel="stylesheet" href="../smg.css" type="text/css">
<link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css"> <!-- BaseStyle -->
<link media="screen" rel="stylesheet" href="../linked/css/colorbox.css" /> <!-- Modal ColorBox -->
<cfoutput>
    <link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab Style Sheet --> 
    <script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
    <script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
</cfoutput>        
<script type="text/javascript" src="../linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput, TimePicker -->
<script type="text/javascript" src="../linked/js/jquery.cfjs.js"></script> <!-- Coldfusion functions for jquery -->
<script type="text/javascript" src="../linked/js/basescript.js "></script> <!-- BaseScript -->

<style type="text/css">

	table.frame 
	{
	border-style:solid;
	border-width:thin;
	border-color:#004080;
	border-collapse:collapse;
	background-color:#FFFFE1;
	padding:2px;
	}
	
	td.right
	{
	font:Arial, Helvetica, sans-serif;
	font-style:normal;
	font-size:small;
	color:#FFFFFF;
	font-weight:bold;
	border-right-style:solid;
	border-right-width:thin;
	border-right-color:#004080;
	border-right-collapse:collapse;
	padding:4px;
	}
	
	td.two
	{
	font:Arial, Helvetica, sans-serif;
	font-style:normal;
	font-size:small;
	border-right-style:solid;
	border-right-width:thin;
	border-right-color:#004080;
	border-right-collapse:collapse;
	padding:4px;
	}
	
	.box
	{
	border-style:solid;
	border-width:thin;
	border-color:#004080;
	border-collapse:collapse;
	background-color:#FFFFFF;
	}
	
	tr.darkBlue
	{
	background-color:#0052A4;
	}
	
	div.container
	{
	display: table;
	}
	
	div.containerRow
	{
	display: table-row;
	}
	
	div.containerLeft
	{
	display: table-cell;
	vertical-align:top;
	}
	
	div.containerRight
	{
	display: table-cell;
	}
	
.style1 {color: #FF0000}
</style>
</head>

<!--- CHECK INVOICE RIGHTS  --->
<cfinclude template="check_rights.cfm">

<body>

<cfquery name="qAgents" datasource="MySQL">
SELECT userid, businessname
FROM smg_users
WHERE usertype = 8
ORDER BY businessname
</cfquery>

<cfparam name="form.choseNAgent" default="0">
<cfparam name="form.selectInvoice" default="0">
<cfparam name="form.amount_received" default="0">
<cfparam name="form.sumAmountApplied" default="0">
<cfparam name="variables.totalReceived" default="0">
<cfparam name="form.creditId" default="0">
<cfparam name="variables.confirm" default="0">


<!--- Process Payment --->
<cfif form.selectInvoice NEQ 0>
	
    <cfset difference = form.sumAmountApplied - form.amount_received>
    
	<cfif difference GT 0>
    	<cfoutput>
        	<table align="center">
            	<tr height="200">
                	<td>
                    </td>
                </tr>
            	<tr align="center">
                	<td>
           			<h1>The total amount assigned to invoice(s) is greater than the amount received.<br/>
            		Please take #LSCurrencyFormat(1*variables.difference,'local')# off of any checked invoice(s) in order to match the amount received.</h1>
                	</td>
            	</tr>
                <tr>
                    <td align="center">
                    <FORM>
                        <INPUT TYPE="button" VALUE="Go Back" ONCLICK="history.go(-1)">
                    </FORM>
                    </td>
            	</tr>
            </table>
		</cfoutput>
		<cfabort>
    <cfelseif difference LT 0>
		<cfoutput>
        	<table align="center">
            	<tr height="200">
                	<td>
                    </td>
                </tr>
            	<tr align="center">
                	<td>
                    <h1>The amount received is greater than the total amount assigned to invoice(s).<br/>
                    Please assign addicional #LSCurrencyFormat(-1*variables.difference,'local')# to any invoice(s) in order to match the amount received.</h1>
                	</td>
            	</tr>
                <tr>
                    <td align="center">
                    <FORM>
                        <INPUT TYPE="button" VALUE="Go Back" ONCLICK="history.go(-1)">
                    </FORM>
                    </td>
            	</tr>
            </table>
		</cfoutput>
		<cfabort>
    </cfif>

	<cfloop list="#form.selectInvoice#" index="iInvoiceNumber">
		<cfset totalReceived = #variables.totalReceived# + #EVALUATE('form.payInv' & '#iInvoiceNumber#')#>
	</cfloop>
	
	<cfif form.creditId NEQ 0>
		<cfset form.date_received = #now()#>
		<cfset form.pay_ref = #form.creditId#>
		<cfset form.payment_method = 'apply credit'>
		
		<cfquery name="get_bal" datasource="mysql">
			select id, amount_applied, amount 
			from smg_credit
			where creditid = #form.pay_ref#
			and active = 1
			</cfquery>
			
			<cfparam name="appliedNow" default="0">
			<cfparam name="totalApplied" default="0">
		
			<cfloop query="get_bal">
				
				<cfset totalAppliedBefore = #variables.totalApplied#>
				<cfset amountToApply = #form.amount_received# - #variables.totalAppliedBefore#>
				<cfset credBal = #get_bal.amount# - #get_bal.amount_applied#>
				
				<cfif variables.amountToApply GTE variables.credBal>
					<cfset new_amount_received = #variables.credBal#>
					<cfelse>
						<cfset new_amount_received = #variables.amountToApply#>
				</cfif>
				
				<cfset newTotalApplied = #get_bal.amount_applied# + #variables.new_amount_received#> 
				
				<cfif variables.amountToApply GT 0>
				
					<cfquery name="update_amount_applied" datasource="MySQL">
					update smg_credit
					set amount_applied = #variables.newTotalApplied#
					where id = #get_bal.id#
					</cfquery>
					
					<cfif variables.credBal eq variables.new_amount_received>
						<cfquery name="deactivate_credit" datasource="MySQL">
						update smg_credit
						set active = 0
						where id = #get_bal.id#
						</cfquery>
					</cfif>
					
					<cfset appliedNow = #variables.new_amount_received#>
					<cfset totalApplied = #variables.totalAppliedBefore# + #variables.appliedNow#>
				
				</cfif>
			
			</cfloop>
	</cfif>
	
<!--- 	<cfset difference = #form.amount_received# - #variables.totalReceived#>
	<cfif variables.difference LT 0>
		<cfoutput>
		<h1 align="center">The total amount assigned to invoice(s) is greater than the amount received.<br/>
		Please take #LSCurrencyFormat(-1*variables.difference,'local')# off of any checked invoice(s) (Hit "Back" on your browser).</h1>
		</cfoutput>
		<cfabort>
	</cfif>
	<cfif variables.difference GT 0> 
		<cfoutput>
		<h1 align="center">The amount received is greater than the total amount assigned to invoice(s).<br/>
		Please assign addicional #LSCurrencyFormat(variables.difference,'local')# to any invoice(s) (Hit "Back" on your browser).</h1>
		</cfoutput>
		<cfabort>
	</cfif> --->
	
	<!--- <cfif client.companyid LT 5>
		<cfset compId = 1>
		<cfelse>
			<cfset compId = #client.companyid#>
	</cfif> --->
	
	<cfquery name="payment_Details" datasource="MySQL">
	insert into smg_payment_received (date, date_applied, paymentref, paymenttype, totalreceived, agentid<!--- , companyid --->)
					values(#CreateODBCDate(form.date_received)#, #CreateODBCDate(now())#, '#form.pay_ref#', '#form.payment_method#', #form.amount_received#, #FORM.choseNAgent#<!--- , #variables.compId# --->)
	</cfquery>
	
	<cfquery name="paymentid" datasource="mysql">
	select max(paymentid) as payid from smg_payment_received
	</cfquery>
			
	<cfloop list="#form.selectInvoice#" index="iInvoiceNumber">
	
		<cfset paymBalance = #LSPARSECURRENCY(EVALUATE('form.payInv' & '#iInvoiceNumber#'))#>

		<cfquery name="qTotalPerStudent" datasource="MySQL"> 
		SELECT t.invoiceid, t.stuid, t.chargeid, t.companyid, SUM( t.total ) AS totalPerStud
		FROM (
		SELECT sch.invoiceid, sch.stuid, sch.chargeid, sch.companyid, IFNULL( SUM( sch.amount_due ) , 0 ) AS total
		FROM smg_charges sch
		WHERE sch.invoiceid = #iInvoiceNumber#
        <cfswitch expression="#client.companyid#">
        <cfcase value="5,10,13,14,15">
        	AND sch.companyid = #client.companyid#
        </cfcase>
        <cfcase value="7,8">
        	AND sch.companyid IN (7,8)
        </cfcase>
        <cfdefaultcase>
        	AND sch.companyid IN (1,2,3,4,5,7,8,10,12)
        </cfdefaultcase>
        </cfswitch>
		GROUP BY sch.stuid
		UNION ALL
		SELECT sch.invoiceid, sch.stuid, sch.chargeid, sch.companyid, IFNULL( SUM( spc.amountapplied ) * -1, 0 ) AS total
		FROM smg_payment_charges spc
		LEFT JOIN smg_charges sch ON sch.chargeid = spc.chargeid
		WHERE sch.invoiceid = #iInvoiceNumber#
        <cfswitch expression="#client.companyid#">
        <cfcase value="5,10,14,15">
        	AND sch.companyid = #client.companyid#
        </cfcase>
        <cfcase value="7,8">
        	AND sch.companyid IN (7,8)
        </cfcase>
        <cfdefaultcase>
        	AND sch.companyid IN (1,2,3,4,5,7,8,10,12)
        </cfdefaultcase>
        </cfswitch>
		GROUP BY sch.stuid
		) t
		GROUP BY t.stuid
		ORDER BY t.stuid DESC  
		</cfquery>
		
		<cfloop query="qTotalPerStudent">
		
			<cfset duePerStud = #qTotalPerStudent.totalPerStud#>
		
			<cfquery name="qChargeBalance" datasource="MySQL"> 
			SELECT t.invoiceid, t.chargeid, t.companyid, SUM( t.total ) AS totalPerCharge
			FROM (
			SELECT sch.invoiceid, sch.chargeid, sch.companyid, IFNULL( SUM( sch.amount_due ) , 0 ) AS total
			FROM smg_charges sch
			WHERE sch.invoiceid = #iInvoiceNumber#
			AND sch.stuid = #qTotalPerStudent.stuid#
			GROUP BY sch.chargeid
			UNION ALL
			SELECT sch.invoiceid, sch.chargeid, sch.companyid, IFNULL( SUM( spc.amountapplied ) * -1, 0 ) AS total
			FROM smg_payment_charges spc
			LEFT JOIN smg_charges sch ON sch.chargeid = spc.chargeid
			WHERE sch.invoiceid = #iInvoiceNumber#
			AND sch.stuid = #qTotalPerStudent.stuid#
			GROUP BY sch.chargeid
			) t
			GROUP BY t.chargeid HAVING totalPerCharge > 0
			ORDER BY t.total ASC    
			</cfquery>
			
			<cfloop query="qChargeBalance">
			
				<cfif variables.paymBalance GT 0>
				
					<cfif qChargeBalance.totalPerCharge LTE variables.duePerStud>
						<cfset insertAmount = #qChargeBalance.totalPerCharge#>
					<cfelse>
						<cfset insertAmount = #variables.duePerStud#>
					</cfif>
					
					<cfif variables.insertAmount GT variables.paymBalance>
						<cfset insertAmount = #variables.paymBalance#>
					</cfif>
					
					<cfquery name="pay_charges" datasource="MySQL">
					insert into smg_payment_charges (paymentid, chargeid, amountapplied)
									values(#paymentid.payid#, #qChargeBalance.chargeid#, #variables.insertAmount#)
					</cfquery>
					
					<cfset duePerStud = #variables.duePerStud# - #variables.insertAmount#>
					<cfset paymBalance = #variables.paymBalance# - #variables.insertAmount#>
				
				</cfif>
				
			</cfloop>
		
		</cfloop>
			
	</cfloop>
	
	<cfoutput>
		<script type="text/javascript">
		window.open('../invoice/payment_details.cfm?ref=#form.pay_ref#&userid=#FORM.choseNAgent#&dateRec=#DateFormat(form.date_received, 'yyyy-mm-dd')#', 'Payment_Details', 'location=no', 'scrollbars=yes', 'menubars=no', 'toolbars=no', 'resizable=yes', 'width=150', 'height=150');  
		</script>
	</cfoutput>
	
</cfif>
<!--- End of Process Payment --->


<!--- Forms --->
<cfform method="post" action="#CGI.SCRIPT_NAME#">

    <table align="center">
        <tr>
        	<td>
            <h3 align="center"><font color="#0000A0" face="Arial, Helvetica, sans-serif">Select International Agent</font></h3>
            </td>
            <td></td>
            <td></td>
        </tr>
        <tr>
        	<td>
            <select name="choseNAgent" size="1" onChange="javaScript:this.form.submit();">
                <option></option>
                <cfoutput query="qAgents">
                    <option value="#qAgents.userid#" <cfif qAgents.userid EQ choseNAgent>selected="selected"</cfif>>#qAgents.businessname# (#qAgents.userid#)</option>
                </cfoutput>
            </select>
            </td>
            <td></td>
            <td></td>
        </tr>
    </table>
    
	<cfif choseNAgent NEQ 0>

        <cfquery name="qAgent" datasource="MySQL">
        SELECT userid, businessname
        FROM smg_users
        WHERE userid = #FORM.choseNAgent#
        </cfquery>
        
        <cfquery name="get_credits" datasource="MySQL">
        select 
        	creditid,SUM(amount) AS amount,companyid, 
            SUM(amount_applied) AS amount_applied from smg_credit
        where 
        	agentid = #FORM.choseNAgent# 
        and 
        	active =1
		<cfif CLIENT.companyID EQ 14>
            AND companyID = 14
        <cfelse>
            AND companyID != 14
        </cfif> 
        GROUP BY 
        	creditid
        </cfquery>	

        <table align="center">
            <tr>
                <td>
            	<h3><cfoutput><a href="index.cfm?curdoc=invoice/user_account_details&userid=#qAgent.userid#" target="_blank">#qAgent.businessname# (#qAgent.userid#)</a></cfoutput></h3>
                </td>
                <td></td>
                <td></td>
            </tr>
		</table>
        
 <table align="center" width="100%">
 	<tr>
    	<td valign="top"> 
            <table style="margin-left:80px; border-style:solid; border-color:#000066; border-width:thin; background-color:#FFFFE1;">
                <tr>
                    <td style="padding-top:10px;">
                        <font size=-1 color="#0052A4"><strong>Payment Method:</strong></font>
                    </td>
                    <td style="padding-top:10px;">
                        <cfselect name="payment_method" message="Please Select a Payment Type" required="yes">
                            <option value='wire transfer'><font size=-1>Wire Transfer</font></option>
                            <option value='check'><font size=-1>Check</font></option>
                            <option value='ACH Credit'><font size=-1>ACH Credit</font></option>
                            <option value='Direct Deposit'><font size=-1>Direct Deposit</font></option>
                            <option value='travelers check'><font size=-1>Travelers Check</font></option>
                            <option value='cash'><font size=-1>Cash</font></option>
                            <option value='money order'><font size=-1>Money Order</font></option>
                            <option value='money order'><font size=-1>Chase QuickPay</font></option>
                            <option value='account transfer'><font size=-1>Account Transfer</font></option>
                        </cfselect>
                    </td>
                </tr>
                
                <Cfif get_credits.recordcount gt 0>
                    <Tr height="40px;">
                        <Td>
                        <font size=-1 color="#0052A4"><strong>Credit Available to Apply:</strong></font>
                        </Td>
                        <td>
                        <cfoutput>
                            <script type="text/javascript">									
                                function getCreditValue(currentamount) {
                                    document.getElementById("amount_received").value = currentamount;
                                }
                            </script>
                        </cfoutput>
                        <cfoutput query="get_credits">
                            <cfquery name="companyname" datasource="mysql">
                            select companyshort
                            from smg_companies
                            where companyid = #get_credits.companyid#
                            </cfquery>
                            <cfset amount_avail = #amount# - #amount_applied#> 
                            <cfinput type="radio" name="creditId" id="creditId#creditid#" value="#creditid#" onClick="javaScript:getCreditValue('#amount_avail#');">
                            <cfinput type="hidden" name="creditAvail#creditid#" id="creditAvail#creditid#" value="#amount_avail#">
                            <font size="-1">#creditid# - #amount_avail# #companyname.companyshort#</font><br>
                        </cfoutput>
                        </td>
                    </Tr>
                </Cfif>
                <tr>
                    <td valign="top">
                    <font size=-1 color="#0052A4"><strong>Date Received:</strong></font>
                    </td>
                    <td>
                    <input type="text" name="date_received" class="datePicker">
                    </td>
                </tr>
                <tr>
                    <td valign="top"></td>
                    <td>
                    <font size=-2>(for apply credit, leave blank)</font>
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                    <font size=-1 color="#0052A4"><strong>Amount Received:</strong></font>
                    </td>
                    <td>
                    <input type="text" name="amount_received" id="amount_received"> <br/>
                    <font size=-2>(for apply credit, leave blank)</font> 
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                    <font size=-1 color="#0052A4"><strong>Total Being Applied:</strong></font>
                    </td>
                    <td>
                    <input type="text" disabled="disabled" name="sumAmountApplied1" id="sumAmountApplied1" style="background-color:#FFFFE1; border:hidden">
                    <input type="hidden" name="sumAmountApplied" id="sumAmountApplied" style="background-color:#FFFFE1; border:hidden">
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                    <font size=-1 color="#0052A4"><strong>Payment Reference:</strong></font>
                    </td>
                    <td>
                    <input type="text" name="pay_ref"> <br/> 
                    <font size=-2>Check Number, Wire Trans #, etc</font> <br/>
                    <font size=-2>(for apply credit, leave blank)</font> <br /><br />
                    </td>
                </tr>
                <tr height="40px">
                	<td align="center" colspan="2" style="border-top:solid 1px #CCCCCC;">
                    	<input type="image" src="../pics/submit.gif" name="submit">
                    </td>
                </tr>
            </table>     
		</td>
        
        <td align="left">
            <cfquery name="qInvBalance" datasource="MySQL"> 
            SELECT t.invoiceid, t.date, t.companyid, SUM( t.total ) AS totalPerInvoice
            FROM (
            SELECT sch.invoiceid, sch.date, sch.companyid, IFNULL( SUM( sch.amount_due ) , 0 ) AS total
            FROM smg_charges sch
            WHERE sch.agentid = #FORM.choseNAgent#
            <cfswitch expression="#client.companyid#">
            <cfcase value="5,10,13,14,15">
                AND sch.companyid = #client.companyid#
            </cfcase>
            <cfcase value="7,8">
                AND sch.companyid IN (7,8)
            </cfcase>
            <cfdefaultcase>
                AND sch.companyid IN (1,2,3,4,5,7,8,10,12,13)
            </cfdefaultcase>
            </cfswitch>
            GROUP BY sch.invoiceid
            UNION ALL
            SELECT sch.invoiceid, sch.date, sch.companyid, IFNULL( SUM( spc.amountapplied ) * -1, 0 ) AS total
            FROM smg_payment_charges spc
            LEFT JOIN smg_charges sch ON sch.chargeid = spc.chargeid
            WHERE sch.agentid = #FORM.choseNAgent#
            <cfswitch expression="#client.companyid#">
            <cfcase value="5,10,13,14,15">
                AND sch.companyid = #client.companyid#
            </cfcase>
            <cfcase value="7,8">
                AND sch.companyid IN (7,8)
            </cfcase>
            <cfdefaultcase>
                AND sch.companyid IN (1,2,3,4,5,7,8,10,12,13)
            </cfdefaultcase>
            </cfswitch>
            GROUP BY sch.invoiceid
            ) t
            GROUP BY t.invoiceid HAVING totalPerInvoice > 0
            ORDER BY t.invoiceid DESC    
            </cfquery>
            
            <cfif qInvBalance.recordCount EQ 0>
                <h3 align="center">There are no outstanding invoices</h3>
                <cfabort>
            </cfif>
            
            <cfset counter = #qInvBalance.recordCount#>
            <cfset arrayInvoiceId = arrayNew(1)>
            <cfloop query="qInvBalance">
                <cfset #arrayAppend(arrayInvoiceId,"#qInvBalance.invoiceid#")#>
            </cfloop>
            
            <cfoutput>
            <script type="text/javascript" language="javascript">
                var jsCounter = #counter#;
                var #toScript(arrayInvoiceId, "jsArrayInvoiceId")#;			
                
                function calculator() {
                    var paymAmount = 0;
                    for (var i=0; i<=jsCounter-1; i++) {
                        if (document.getElementById("selectInvoice"+jsArrayInvoiceId[i]).checked == true) {
                            //multiply by 1 to force conversion to a number;
                            paymAmount = paymAmount +  document.getElementById("paying"+jsArrayInvoiceId[i]).value * 1; 
                        }
                        document.getElementById("sumAmountApplied").value = paymAmount;
						document.getElementById("sumAmountApplied1").value = paymAmount;
                    }	
                }
            </script>
            </cfoutput>
            
            <table class="frame" align="left">
                <tr class="darkBlue">
                    <td class="right">
                    </td>
                    <td class="right">Comp</td>
                    <td class="right">Invoice</td>
                    <td class="right">Date</td>
                    <td class="right">Balance</td>
                    <td class="right">Paying</td>
                </tr>
                <cfoutput query="qInvBalance">
                <tr>
                    <td class="two">
                    <cfinput name="selectInvoice" id="selectInvoice#qInvBalance.invoiceid#" value="#qInvBalance.invoiceid#" type="checkbox" onClick="javaScript:calculator();">
                    </td>
                    <td class="two">
                    #qInvBalance.companyid#
                    </td>
                    <td class="two">
                    <a href="invoice_view.cfm?id=#qInvBalance.invoiceid#" target="_blank">#qInvBalance.invoiceid#</a>
                    </td>
                    <td class="two" width="60">
                    #DateFormat(qInvBalance.date,'mm-dd-yyyy')#
                    </td>
                    <td class="two">
                    #LSCurrencyFormat(qInvBalance.totalPerInvoice,'local')#
                    </td>
                    <td class="two">
                    <cfinput name="payInv#qInvBalance.invoiceid#" id="paying#qInvBalance.invoiceid#" type="text" value="#qInvBalance.totalPerInvoice#" onChange="javaScript:calculator();" size="6">
                    </td>
                </tr>
                </cfoutput>
            </table>

        </td>
	</tr>
</table>
			    
            

	</cfif>           

</cfform>
          
</body>
</html>