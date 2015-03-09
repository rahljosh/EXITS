<cfsetting requesttimeout="99999">

<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfparam name="FORM.companyID" default="#CLIENT.companyID#">
<cfparam name="FORM.submitted" default="0">

<!--- Quick Search Form --->
<cfparam name="FORM.quickSearchAutoSuggestAgentID" default="type agent, ID, contact">
<cfparam name="FORM.quickSearchAgentID" default="">

<cfscript>
	// Quick Search User
	if ( VAL(FORM.quickSearchAgentID) ) {
		Location("index.cfm?curdoc=invoice/user_account_details&userid=#FORM.quickSearchAgentID#", "no");	
	}
</cfscript>

<script type="text/javascript">
	// Avoid two selections on quick search
	var quickSearchValidation = function() {		
		$(".quickSearchField").val("");
	}
	
	$(function() {

		// Quick Search - User Auto Suggest
		$("#quickSearchAutoSuggestAgentID").autocomplete({
														
			source: function(request, response) {
				$.ajax({
					url: "extensions/components/user.cfc?method=remoteLookUpUser",
					dataType: "json",
					data: { 
						searchString: request.term
					},
					success: function(data) {
						response( $.map( data, function(item) {
							return {
								//label: item.DISPLAYNAME,
								value: item.DISPLAYNAME,
								valueID: item.USERID
							}
						}));
					}
				})
			},
			select: function(event, ui) {
				$("#quickSearchAgentID").val(ui.item.valueID);
				$("#quickSearchAgentForm").submit();
			},
			minLength: 2	
			
		});
		
	});	
</script>

<cfif FORM.submitted>
	
	<!--- query to get company info --->
	<cfquery name="qCompanyDetail" datasource="#APPLICATION.DSN#">
		SELECT companyID, companyShort, companyName
		FROM smg_companies
		WHERE companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyID#">
	</cfquery>
	
	<cfset CLIENT.companyID = qCompanyDetail.companyID>
	<cfset CLIENT.companyShort = qCompanyDetail.companyShort>
	<cfset CLIENT.companyName = qCompanyDetail.companyName>
	
	<cflocation url="#CGI.SCRIPT_NAME#?#cgi.QUERY_STRING#" addtoken="no">
</cfif>

<cfsetting requestTimeOut = "800">

<!----Cookie list for recent agents accessed---->
<cfif isDefined('cookie.intagentlist')>
	<cfset intagentlist = #cookie.intagentlist#>
	<cfif listcontains(intagentlist,#url.userid#, ',')>
		<cfset cookie.intagentlist = #intagentlist#>
	<cfelse>
		<cfif listlen(intagentlist) eq 5>
			<cfset intagentlist = #ListDeleteAt(intagentlist, 1, ',')#>
			<cfset intagentlist = #ListAppend(intagentlist, #url.userid#, ',')#>
		<cfelse>
			<cfset intagentlist = #ListAppend(intagentlist, #url.userid#, ',')#>
		</cfif>
	</cfif>
	<cfcookie name=intagentlist value="#intagentlist#" expires="never">
<cfelse>
	<cfcookie name=intagentlist value="#url.userid#" expires="never">
</cfif>

<cfif isDefined('url.invall')>
	<cfset form.view = 'all'>
<cfelse>
	<cfset form.view = #FORM.companyID#>		
</cfif>

<cfoutput>
	<cfif client.companyID NEQ 14>
		<div align="center">
        	<a href="?curdoc=invoice/user_account_details&userid=#url.userid#">Show only this Company</a> :: 
            <a href="?curdoc=invoice/user_account_details&userid=#url.userid#&invall">Include all company numbers</a>
     	</div>
    </cfif>
</cfoutput>

<cfquery name="agent_details" datasource="#APPLICATION.DSN#">
	SELECT businessname, firstname, lastname, city, smg_countrylist.countryname
	FROM smg_users
	LEFT JOIN smg_countrylist ON smg_countrylist.countryid = smg_users.country
	WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
</cfquery>

<cfquery name="agentTotalBalance" datasource="#APPLICATION.DSN#">
	SELECT SUM(t.total) AS totalPerAgent
	FROM (
		SELECT sch.agentid, su.businessname, sch.programid, IFNULL(SUM(sch.amount_due),0) AS total, sch.companyid
        FROM smg_charges sch
        LEFT JOIN smg_programs sp ON sp.programid = sch.programid
        LEFT JOIN smg_users su ON su.userid = sch.agentid
        WHERE sch.agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
        <cfswitch expression="#client.companyid#">
            <cfcase value="5,10,13,14">
                AND sch.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
            </cfcase>
            <cfcase value="7,8">
                AND sch.companyid IN (7,8)
            </cfcase>
            <cfdefaultcase>
                AND sch.companyid IN (1,2,3,4,5,7,8,10,12)
            </cfdefaultcase>
        </cfswitch>
		GROUP BY sch.companyid<!--- testCompId --->
		<cfif form.view is not 'all'>
        	HAVING sch.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyid#">
		</cfif>
        UNION ALL
        SELECT sch.agentid, su.businessname, sch.programid, IFNULL(SUM(spc.amountapplied)*-1,0) AS total, sch.companyid
        FROM smg_payment_charges spc
        LEFT JOIN smg_charges sch ON sch.chargeid = spc.chargeid
        LEFT JOIN smg_programs sp ON sp.programid = sch.programid
        LEFT JOIN smg_users su ON su.userid = sch.agentid
        WHERE  sch.agentid = #url.userid#
        <cfswitch expression="#client.companyid#">
            <cfcase value="5,10,14">
                AND sch.companyid = #client.companyid#
            </cfcase>
            <cfcase value="7,8">
                AND sch.companyid IN (7,8)
            </cfcase>
            <cfdefaultcase>
                AND sch.companyid IN (1,2,3,4,5,7,8,10,12)
            </cfdefaultcase>
        </cfswitch>
		GROUP BY sch.companyid<!--- testCompId --->
		<cfif form.view is not 'all'>
        	HAVING sch.companyid = #FORM.companyID#
		</cfif>
        UNION ALL
        SELECT sc.agentid, su.businessname, sch.programid, IFNULL(SUM(sc.amount - sc.amount_applied)* -1,0) AS total, sc.companyid
        FROM smg_credit sc
        LEFT JOIN smg_charges sch ON sch.chargeid = sc.chargeid
        LEFT JOIN smg_programs sp ON sp.programid = sch.programid
        LEFT JOIN smg_users su ON su.userid = sc.agentid
        WHERE sc.active =1
        <cfswitch expression="#client.companyid#">
            <cfcase value="5,10,13,14">
                AND sc.companyid = #client.companyid#
            </cfcase>
            <cfcase value="7,8">
                AND sc.companyid IN (7,8)
            </cfcase>
            <cfdefaultcase>
                AND sc.companyid IN (1,2,3,4,5,7,8,10,12)
            </cfdefaultcase>
        </cfswitch>
        AND sc.agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
		GROUP BY sc.companyid<!--- testCompId --->
		<cfif form.view is not 'all'>
        	HAVING sc.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyid#">
		</cfif>
	) t
	GROUP BY t.agentid
</cfquery>

<!----total credits in system---->
<cfquery name="total_credit_amount" datasource="#APPLICATION.DSN#">
    SELECT sum(amount) as credit_amount
    FROM smg_credit
    WHERE agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
    <cfif form.view is not 'all'>
    	AND companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyid#">
    </cfif>
    AND active = 1
</cfquery>
			
<cfif total_credit_amount.credit_amount is ''>
	<cfset total_credit_amount.credit_amount = 0>
</cfif>
            
<!----Total credits applied---->
<cfquery name="total_Credit_applied" datasource="#APPLICATION.DSN#">
    SELECT sum(amount_applied) as credit_amount
    FROM smg_credit
    WHERE agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
	<cfif form.view is not 'all'>
    	AND companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyid#">
    </cfif>
    AND active = 1
</cfquery>
			
<cfif total_Credit_applied.credit_amount is ''>
	<cfset total_Credit_applied.credit_amount = 0>
</cfif>
			
<cfset total_credit = #total_credit_amount.credit_amount# - #total_credit_applied.credit_amount#>

<!----Refund Query not combined---->
<cfquery name="refunds" datasource="#APPLICATION.DSN#">
    SELECT *
    FROM smg_invoice_refunds
    WHERE smg_invoice_refunds.agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
    <cfif form.view is not 'all'>
    	AND smg_invoice_refunds.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyid#">
    </cfif>
    AND smg_invoice_refunds.refund_receipt_id = 0
</cfquery>
			
<cfquery name="refunds" datasource="#APPLICATION.DSN#">
    SELECT smg_invoice_refunds.id, smg_invoice_refunds.refund_receipt_id, smg_invoice_refunds.date, smg_invoice_refunds.amount,
    	smg_credit.creditid, smg_credit.amount as credit_amount, smg_credit.description
    FROM smg_invoice_refunds right join smg_credit on smg_invoice_refunds.creditid = smg_credit.id
    WHERE smg_invoice_refunds.agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
    <cfif FORM.companyID EQ 5 AND form.view is not 'all'>
    	AND smg_invoice_refunds.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyid#">
    </cfif>
    AND smg_invoice_refunds.refund_receipt_id = 0
</cfquery>

<!----Refund Query not combined---->
<cfquery name="refunds1" datasource="#APPLICATION.DSN#">
    SELECT  distinct smg_invoice_refunds.refund_receipt_id
    FROM smg_invoice_refunds 
    WHERE smg_invoice_refunds.agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
    <cfif FORM.companyID EQ 5 AND form.view is not 'all'>
    	AND smg_invoice_refunds.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyid#">
    </cfif>
    AND smg_invoice_refunds.refund_receipt_id <> 0
</cfquery>

<script type="text/javascript">
	function displayMenu() {
		document.getElementById("chargesMenu").style.display = "block";
	}
	
	function hideMenu() {
		document.getElementById("chargesMenu").style.display = "none";
	}
	
	function displayMenu1() {
		document.getElementById("cancellationMenu").style.display = "block";
	}
	
	function hideMenu1() {
		document.getElementById("cancellationMenu").style.display = "none";
	}	
</script>

<style type="text/css">
	.menuInvoice {
		border-style:solid;
		border-width:thin;
		border-color:#004080;
		background-color:#FFFFEC;
		padding-left:0.3cm;
		padding-bottom:0.1cm;
		display:none;
		font-size:11px;
	}
</style>
		
<cfoutput>

	<table width=100% border=0>
		<tr>
			<td width=50% valign="top">
				
				<!----Overview---->
				<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                    <tr valign=middle height=24>
                        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width=26 background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
                        <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Overview</td><td background="pics/header_background.gif" width=16></a></td>
                        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
				
                <table width=100% cellpadding=2 cellspacing=0 border=0 class="section">
					<tr>
						<td style="line-height:20px;" valign="top">
							<table width = 100%>
								<tr>
									<td valign="top" width=50%>
                                    	<cfform name="quickSearchAgentForm" id="quickSearchAgentForm" method="post" action="" style="margin:0px; padding:0px;">
                                    		<input 
                                            	type="text" 
                                                style="font-size:11px; font-style:italic; color:##666666;" 
                                                name="quickSearchAutoSuggestAgentID" 
                                                id="quickSearchAutoSuggestAgentID" 
                                                value="#FORM.quickSearchAutoSuggestAgentID#" 
                                                onclick="quickSearchValidation();" 
                                                class="mediumField quickSearchField" 
                                                maxlength="20" />
                                        	<input 
                                            	type="hidden" 
                                                name="quickSearchAgentID" 
                                                id="quickSearchAgentID" 
                                                value="#FORM.quickSearchAgentID#" 
                                                class="quickSearchField" />
                                    	</cfform>
										
                                        <b>#agent_details.businessname#</b><br>
										Agent ID: #userid#<br>
                                        #agent_Details.firstname# #agent_details.lastname#<br>
                                        #agent_details.city#, #agent_details.countryname#</br>
		
        								<cfquery name="qCompShort" datasource="#APPLICATION.DSN#">
                                            SELECT companyid, companyshort
                                            FROM smg_companies
                                            WHERE companyid != 11
                                        </cfquery>
		
										<cfif client.companyid NEQ 10>
                                            <cfform name="changeCompany" method="post" action="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#">
                                                <input type="hidden" name="submitted" value="1" />
                                                Change company:
                                                <cfselect 
                                                	name="companyid" 
                                                    query="qCompShort" 
                                                    display="companyshort" 
                                                    value="companyid" 
                                                    selected="#FORM.companyID#" 
                                                    onChange="javaScript:changeCompany.submit();">
                                                </cfselect>
                                            </cfform>
										</cfif>
									</td>
									<td>&nbsp;</td>
									<td valign="top" align="right">

										<!---Current Balance---->
                                        <table align="right">
											<tr>
												<td><b>Balance:</b></td><td>
												<b>#LSCurrencyFormat(agentTotalBalance.totalPerAgent, 'local')#</b></td>
											</tr>
											<tr>
												<td>Last Payment</td>
                                                <td>
                                                    <cfquery name="recent_date" datasource="#APPLICATION.DSN#">
                                                        SELECT max(date) as recent_pay
                                                        FROM smg_payment_received
                                                        WHERE agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
                                                        <cfif form.view is not 'all'>
                                                        	AND companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyid#">
                                                        </cfif>
                                                    </cfquery>
                                                    
													<cfif recent_Date.recent_pay is ''>
                                                    	<cfset last_payment.totalreceived = 0>
                                                    <cfelse>
                                                        <cfquery name="last_payment" datasource="#APPLICATION.DSN#">
                                                            SELECT totalreceived 
                                                            FROM smg_payment_received
                                                            WHERE agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
                                                            AND date = #recent_date.recent_pay#
                                                        </cfquery>
                                                    </cfif>
													#LSCurrencyFormat(last_payment.totalreceived, 'local')#
												</td>
											</tr>
											<tr>
												<td>Pay Date:</td><Td><cfif last_payment.totalreceived is not 0>#DateFormat(recent_date.recent_pay, 'mm/dd/yyyy')#</cfif></Td>
											</tr>
											<tr>
												<td>Credit</td><td>#LSCurrencyFormat(total_credit, 'local')#</td>
											</tr>
										</table>
									
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
				
         	<td></td>
			
            <td valign="top">
			
			<!----Account Options---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                <tr valign=middle height=24>
                    <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                    <td width=26 background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
                    <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Account Tasks</td><td background="pics/header_background.gif" width=16></a></td>
                    <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
                </tr>
            </table>

			<table width=100% cellpadding=4 cellspacing=0 border=0 class="section" >
				<tr>
					<td style="line-height:20px;" valign="top">
						<cfif form.view is not 'all'>
							<table id="menuAddCharge" border=0 width=100%>
								<tr>
									<td onmouseover="javaScript:displayMenu()" onMouseOut="javaScript:hideMenu()">  					
										:: 
										<cfif client.userid NEQ 1967>
											<a 
                                            	class=nav_bar href="" 
                                                onClick="javaScript:win=window.open('invoice/add_charge.cfm?userid=#url.userid#', 'Charges', 'height=395, width=602, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">
                                                </cfif>Add Charge</a>
                                <div class="menuInvoice" id="chargesMenu" align="justify">
                                	<a href="" onClick="javaScript:win=window.open('invoice/add_charge.cfm?userid=#url.userid#', 'Charges', 'height=395, width=602, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">High School</a><br />
                                    <a href="" onClick="javaScript:win=window.open('invoice/m_w&t_addCharge.cfm?userid=#url.userid#', 'Charges', 'height=395, width=602, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Work & Travel</a><br />
                                    <a href="" onClick="javaScript:win=window.open('invoice/m_trainee_addCharge.cfm?userid=#url.userid#', 'Charges', 'height=395, width=602, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Trainee</a><br />
                                    <a href="" onClick="javaScript:win=window.open('invoice/m_h2b_addCharge.cfm?userid=#url.userid#', 'Charges', 'height=395, width=602, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">H2B Program</a><br />
                                    <a href="" onClick="javaScript:win=window.open('invoice/m_misc_addCharge.cfm?userid=#url.userid#', 'Charges', 'height=395, width=602, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Miscellaneous</a><br />
								</div>
                                </td>
                                <td>::<cfif client.userid NEQ 1967> <a href="?curdoc=invoice/select_invoice_type&agentid=#url.userid#"></cfif>Create Invoice</a></td>
								<td>:: <a class=nav_bar href="" onClick="javascript: win=window.open('invoice/issue_refund.cfm?userid=#url.userid#', 'Refund', 'height=395, width=622, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Issue Refund</a></td>
							</tr>
							<tr>
								<td>:: <cfif client.userid NEQ 1967><a class=nav_bar href="" onClick="javascript: win=window.open('invoice/receive_payment.cfm?userid=#url.userid#', 'Payments', 'height=395, width=602, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"></cfif>Receive Payment</a></td>
								<td onmouseover="javaScript:displayMenu1()" onMouseOut="javaScript:hideMenu1()">:: <cfif client.userid is 1967><cfelse><a class=nav_bar href="" onClick="javascript: win=window.open('invoice/credit_account.cfm?userid=#url.userid#', 'Payments', 'height=395, width=602, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"></cfif>Credit Account</a>
                                <div class="menuInvoice" id="cancellationMenu" align="justify">
                                	<a href="" onClick="javaScript:win=window.open('invoice/m_cancelStud.cfm?userid=#url.userid#', 'Charges', 'height=800, width=1000, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Cancel a student</a><br/>
                                </div>
                                </td>
								<td>:: <a class=nav_bar href="" onClick="javascript: win=window.open('invoice/create_refund_receipt.cfm?userid=#url.userid#', 'Refund', 'height=395, width=622, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Create Refund Receipt</a></td>
							</tr>
							<tr>
								<td>:: <a href="?curdoc=invoice/date_range&userid=#url.userid#">Monthly Statement</a></td><td>::<cfif client.userid NEQ 1967> <a href="?curdoc=forms/program_discount&userid=#url.userid#"></cfif>Fee Maintenance</a></td>
								<td>&nbsp;</td>
						  </tr>
							
							</table>
						</cfif>
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



</cfoutput>

<!--- test to select which query to run: current_charges OR current_charges_extra --->
<cfquery name="selectQuery" datasource="#APPLICATION.DSN#">
SELECT s.stuid, s.programid, sp.type AS progType
FROM smg_charges s
LEFT JOIN smg_programs sp ON sp.programid = s.programid
WHERE s.agentid = #url.userid#
AND s.invoiceid = 0
	<cfif form.view is not 'all'>
    AND s.companyid = #FORM.companyID#
    </cfif>
</cfquery>

<cfoutput query="selectQuery">

    <cfif progType EQ 7 OR progType EQ 8 OR progType EQ 9 OR progType EQ 11 OR progType EQ 22 OR progType EQ 23>
        
		<!----Current Charges Work not invoiced---->
        <cfquery name="current_charges" datasource="#APPLICATION.DSN#">
        SELECT s.chargeid, s.stuid, s.invoiceid, s.description, s.date, s.amount, s.type, ec.firstname, ec.lastname
        from smg_charges s
        INNER JOIN extra_candidates ec ON ec.candidateid = s.stuid
        where s.agentid = #url.userid# and s.invoiceID = 0
                    <cfif form.view is not 'all'>
                    and s.companyid = #FORM.companyID#
                    </cfif>
        </cfquery>
            
		<cfelse>
         
			<!----Current Charges High School not invoiced---->
            <cfquery name="current_charges" datasource="#APPLICATION.DSN#">
            SELECT s.chargeid, s.stuid, s.invoiceid, s.description, s.date, s.amount, s.type, ss.firstname, ss.familylastname AS lastname
            from smg_charges s
            LEFT JOIN smg_students ss ON ss.studentid = s.stuid
            where s.agentid = #url.userid# and s.invoiceID = 0
                        <cfif form.view is not 'all'>
                        and s.companyid = #FORM.companyID#
                        </cfif>
            </cfquery>

	</cfif>	 
</cfoutput>

<br>
<!----Sizing table---->
<Table width=100% border=0>
	<tr>
		<td width=50% valign="top">
<!----Recent Charges Not Invoiced---->
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
            <tr valign=middle height=24>
                <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                <td width=26 background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
                <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Recent Charges Not Yet Invoiced</td><td background="pics/header_background.gif" width=16></a></td>
                <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
            </tr>
        </table>
							
		
								
							<table width=100% cellpadding=2 cellspacing=0 border=0 class="section" >
								
			<tr>
				<td></td><td>Student</td><td>Description</td><td>Type</td><td>Amount</td>
			</tr>
			<cfif selectQuery.recordcount NEQ 0>
				<cfoutput query="current_charges">
                    <tr <cfif current_charges.currentrow mod 2>bgcolor="ededed"</cfif>>
                    	<td>
                        	<p>E</p>
                    		<p>D</p>
                    	</td>
                    	<td>#firstname# #lastname# <cfif stuid is 0><Cfelse>(#stuid#)</cfif></td>
                        <td>#description#</td><Td>#type#</Td><td>#LSCurrencyFormat(amount,'local')#</td>
                    </Tr>
                </cfoutput>
			<cfelse>				               
                <tr>
                    <td colspan=5 align="center">No open charges.</td>
                </tr>
			</cfif>
			
		</table>
		

		<!----foter table---->
		<table width=100% cellpadding=0 cellspacing=0 border=0>
            <tr valign=bottom >
                <td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
                <td width=100% background="pics/header_background_footer.gif"></td>
                <td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
            </tr>
        </table>
		
	</td>
	
	<td></td>
	<td>
			<!----Refunds---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                <tr valign=middle height=24>
                    <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                    <td width=26 background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
                    <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Refunds </td><td background="pics/header_background.gif" align="right">
                    </td>
                    <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
                </tr>
            </table>
							
		
								
							<table width=100% cellpadding=2 cellspacing=0 border=0 class="section" >
								
			<tr>
				<td>ID</td><td>Date</td><td>Description</td><td>Amount</td>
			</tr>
			<cfif refunds.recordcount eq 0 and refunds1.recordcount eq 0>
			<tr>
				<td colspan=3>No refunds have been issued.</td>
			</tr>
			<cfelse>
			<cfoutput>
			<cfloop query="refunds">
			<tr>
				<td><a href="invoice/refund_receipt.cfm?id=#id#&userid=#url.userid#" target="_top">#creditid#</td><td>#DateFormat(date, 'mm/dd/yyyy')#</td><td>#description#</td><td>#LSCurrencyFormat(refunds.amount,'local')#</td>
			</tr>
			</cfloop>
			<cfloop query="refunds1">
						<cfquery name="refunds1_date" datasource="#APPLICATION.DSN#">
						select  distinct date 
						from smg_invoice_refunds 
						where refund_receipt_id = #refund_receipt_id#
						</cfquery>
						<cfquery name="refund_total" datasource="#APPLICATION.DSN#">
						select sum(smg_credit.amount) as total_amount
						from smg_invoice_refunds right join smg_credit on smg_invoice_refunds.creditid = smg_credit.creditid
						where smg_invoice_refunds.agentid =#url.userid#
						and smg_invoice_refunds.refund_receipt_id = #refund_receipt_id#
						</cfquery>
				<tr>
				<td><a href="invoice/view_refund_receipt.cfm?id=#refund_receipt_id#&userid=#url.userid#" target="_top">#refund_receipt_id#</td><td>#DateFormat(refunds1_date.date, 'mm/dd/yyyy')#</td><td><a href="invoice/view_refund_receipt.cfm?id=#refund_receipt_id#&userid=#url.userid#" target="_top">Click to see detailsls</td><td><!----#LSCurrencyFormat(refund_sent.amount,'local')#----></td>
			</tr>
			</cfloop>
	
			</cfoutput>
			</cfif>
			
		</table>
		<!----foter table---->
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






<style type="text/css">
<!--
div.scroll {
	height: 200px;
	width: 99.8%;
	overflow: auto;
	border-left: 2px solid #c6c6c6; background: #Ffffe6;
}
-->
</style>

<br>
<table width=100% align="center">
	<tr>
		<td>
		


				<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="pics/header_background.gif"></td>
							<td background="pics/header_background.gif"><h2>Invoices</td><td background="pics/header_background.gif" width=16></td>
							<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>

<!----Invoices this Month---->
<cfquery name="current_invoices" datasource="#APPLICATION.DSN#">
    SELECT invoiceid, invoicedate, SUM(amount_due) AS invoice_due, companyid 
    FROM smg_charges
    WHERE agentid = #url.userid#
    AND invoiceid <> 0
<cfif form.view is not 'all'>
	<cfswitch expression="#FORM.companyID#">
		<cfcase value="1,2,3,4,12">
			and companyid in (1,2,3,4,12)
		</cfcase>
		<cfdefaultcase>
			and companyid = #FORM.companyID#
		</cfdefaultcase>
	</cfswitch>
<cfelse>
	and companyid != 14
</cfif>
GROUP BY 
	invoiceid DESC, companyID 
</cfquery>

<div class=scroll>
<cfparam name="form.docNumber" default="0">
<cfparam name="emailDoc" default="0">
<cfform method="post">
	<cfinput name="emailDoc" value="1" type="hidden">
		<table width=98% cellpadding=4 cellspacing =0>
			<tr>
				<Td>
					<cfinput name="sendEmail" type="image" src="pics/email.gif">
				</Td>
				<td>Invoice</td><td>Date Created</td><td>Amount</td><td>Payments</td><td>C/C/R</td><td>Balance</td><!--- <cfif form.view is 'all'> ---><td>Comp</td><!--- </cfif> --->
			</tr>
				
				
			<cfoutput query="current_invoices">
            	
				<cfquery name="get_applied_amount" datasource="#APPLICATION.DSN#">
                SELECT s.invoiceid, SUM(spc.amountapplied) AS total_received
                FROM smg_payment_charges spc
                RIGHT JOIN smg_charges s ON s.chargeid = spc.chargeid
                WHERE s.agentid =#url.userid#
                    
				<cfif (FORM.companyID EQ 5 OR FORM.companyID EQ 10 OR FORM.companyID EQ 13) AND form.view is not 'all'>
					AND 
						s.companyid = #FORM.companyID#
				<cfelse>
					AND 
						s.companyid = #current_invoices.companyid#
				</cfif> 
				
                AND s.invoiceid = #current_invoices.invoiceid#
                GROUP BY s.invoiceid
                ORDER BY s.invoiceid DESC
                </cfquery>
                                	
			<Tr <cfif current_invoices.currentrow mod 2>bgcolor="ededed"</cfif>>
				<Td>
               		<cfinput name="docNumber" value="#invoiceid#" type="checkbox"><!--- #current_invoices.currentrow# --->
                </Td>
                <td>
                <a href="invoice/invoice_view.cfm?id=#invoiceid#" target="top">#invoiceid#</a>
                </td>
                <td>
                #DateFormat(invoicedate, 'mm-dd-yyyy')#
                </td>
                <td>
                #LSCurrencyFormat(invoice_due, 'local')#
                </td>
                <td>
                <cfif #get_applied_amount.total_received# IS ''>
                	<cfset amount_received = 0>
                    <cfelse>
                        <cfset amount_received = #get_applied_amount.total_received#>
                </cfif>
                #LSCurrencyFormat(amount_received, 'local')#                
				<!--- <font size=-2>#payref.paymentref#</font> --->
                </td>
                <td>
                </td>
                <td>
                 <cfset inv_balance = #current_invoices.invoice_due# - #amount_received#>                #LSCurrencyFormat(inv_balance, 'local')#
                </td>
             	<!--- <cfif form.view is 'all'> --->
                	<td>
                    #companyid#
                    </td>
				<!--- </cfif> --->
			</Tr>
            </cfoutput>
			
			<!--- </cfoutput> --->
		</table>
</cfform>
	</div>
				<table width=100% cellpadding=0 cellspacing=0 border=0>
					<tr valign=bottom >
						<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
						<td width=100% background="pics/header_background_footer.gif"></td>
						<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
					</tr>
				</table>
</td>
<td>&nbsp;</td>
<td width = 50%>

				<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="pics/header_background.gif"></td>
							<td background="pics/header_background.gif"><h2>Payments Received - <font size=-2>payments from / applied from all companies</font></h2></td><td background="pics/header_background.gif" width=16></td>
							<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>
					<div class=scroll>
<table width=98% cellpadding=4 cellspacing =0>


	<tr>
		<Td></Td><td>Payment Ref</td><td>Payment Type</td><td>Date Received</td><td>Amount</td>
	</tr>
	
<Cfquery name="payments_received" datasource="#APPLICATION.DSN#">
    SELECT 
        sch.agentid, 
        su.businessname, 
        sch.programid,                
        sp.paymentref,
        sp.paymenttype,                
        sp.date,                
        sp.date_applied,
        IFNULL(SUM(spc.amountapplied),0) AS total,  
        (CASE 
        WHEN sch.companyid = 1 THEN 1
        WHEN sch.companyid = 2 THEN 1
        WHEN sch.companyid = 3 THEN 1
        WHEN sch.companyid = 4 THEN 1                
        WHEN sch.companyid = 12 THEN 1
        ELSE sch.companyid
        END) AS testCompId
    FROM 
        smg_payment_charges spc
    LEFT JOIN 
        smg_charges sch
    ON 
        sch.chargeid = spc.chargeid
    LEFT JOIN 
        smg_payment_received sp 
    ON 
        sp.paymentid = spc.paymentid
    LEFT JOIN 
        smg_users su 
    ON 
        su.userid = sch.agentid
    WHERE  
        sch.agentid = #url.userid#
		<cfif form.view is not 'all'>
            <cfswitch expression="#FORM.companyID#">
                <cfcase value="1,2,3,4,12,13">
                    and sch.companyid in (1,2,3,4,12,13)
                </cfcase>
                <cfdefaultcase>
                    and sch.companyid = #FORM.companyID#
                </cfdefaultcase>
            </cfswitch>
        <cfelse>
            and sch.companyid != 14
        </cfif>
    GROUP BY 
        sp.paymentref, sp.date       
    ORDER BY            
        sp.date DESC		
</Cfquery>
	
<cfoutput query="payments_received">
	<cfquery name="totals" datasource="#APPLICATION.DSN#">
	select spr.agentid, spr.paymenttype, spr.date, spr.paymentref, spr.paymenttype, sum(spc.amountapplied) as payment_total, sc.companyid
	from smg_payment_received spr
	right join smg_payment_charges spc on spc.paymentid = spr.paymentid
	right join smg_charges sc on sc.chargeid = spc.chargeid
	where paymentref = '#paymentref#'
    and spr.agentid = #url.userid# 
    and paymenttype = '#paymenttype#'
    and spr.date = <cfqueryparam cfsqltype="cf_sql_date" value="#payments_received.date#">
	<cfif client.companyid EQ 10 OR client.companyid EQ 14>
		and sc.companyid = #client.companyid#
	</cfif>
	</cfquery>

	<cfloop query="totals">
		<cfquery name="agent_details" datasource="#APPLICATION.DSN#">
		select businessname
		from smg_users
		where userid = #VAL(totals.agentid)#
		</cfquery>
	
		<Tr <cfif payments_received.currentrow mod 2>bgcolor="ededed"</cfif>>
			<td>#payments_received.currentrow#</td><td><a class=nav_bar href="" onClick="javascript: win=window.open('invoice/payment_details.cfm?ref=#paymentref#&userid=#url.userid#&dateRec=#DateFormat(date, 'yyyy-mm-dd')#', 'Payment_Details', 'height=395, width=602, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#paymentref#</a></td><td>#paymenttype#</td><td>#DateFormat(date, 'mm-dd-yyyy')#</td><td>#LSCurrencyFormat(payment_total, 'local')#</td><cfif form.view is 'all'><td></td></cfif>
		</Tr>
	</cfloop>
</cfoutput>
</table>
</div>
				<table width=100% cellpadding=0 cellspacing=0 border=0>
					<tr valign=bottom >
						<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
						<td width=100% background="pics/header_background_footer.gif"></td>
						<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
					</tr>
				</table>
		</td>
	</tr>
	<tr>
		<td colspan=3>
		
		<br>

		
		

<!----Unapplied Credits---->
				
<Cfquery name="credits_active" datasource="#APPLICATION.DSN#">
select sc.date, sc.type, sc.description, sc.stuid, sc.invoiceid, sc.amount, sc.creditid, sc.amount_applied, sc.credit_type, c.companyshort
from smg_credit sc
LEFT JOIN smg_companies c ON c.companyid = sc.companyid
where agentid = #url.userid# 
<cfif form.view is not 'all'>
	<cfswitch expression="#FORM.companyID#">
		<cfcase value="1,2,3,4,12">
			and sc.companyid in (1,2,3,4,12)
		</cfcase>
		<cfdefaultcase>
			and sc.companyid = #FORM.companyID#
		</cfdefaultcase>
	</cfswitch>
<cfelse>
	and sc.companyid != 14
</cfif>
and  sc.active = 1
ORDER BY sc.creditid DESC, sc.stuid DESC, sc.chargeid ASC
</cfquery>

<cfform method="post">
	<cfinput name="emailDoc" value="2" type="hidden">
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="pics/header_background.gif"></td>
							<td background="pics/header_background.gif"><h2>Credits & Cancellations Unapplied</h2></td><td background="pics/header_background.gif" width=16></td>
							<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>
					<div class=scroll>
<table width=100% cellpadding=4 cellspacing =0>

<tr>
		<Td><cfinput name="sendEmail" type="image" src="pics/email.gif"></Td>
		<Td>ID</Td><td>Comp</td><td>Date</td><td>Type</td><td>Progr</td><td>Description</td><td>Student ID</td><td>Invoice</td><td>Amount</td><td>Applied</td><td>Remaining</td>
	</tr>
<Cfoutput>

	
<cfif credits_active.recordcount is 0>
	<tr>
		<td colspan=8 align="center">No credits, refunds or discounts applied to your account.</td>
	</tr>
<cfelse>
	<cfparam name="previousNote" default="0">
	<cfloop query="credits_active">
		<Tr <cfif credits_active.currentrow mod 2>bgcolor="ededed"</cfif>>
			<Td>
				<cfif credits_active.creditid NEQ previousNote>
					<cfinput name="docNumber" value="#creditid#" type="checkbox">
				</cfif>
			</Td>
			<td><a href="invoice/credit_note.cfm?creditid=#creditid#" target="_blank">#credits_active.creditid#</a></td><td>#companyshort#</td><td>#DateFormat(date, 'mm-dd-yyyy')#</td><td>#type#</td><td>#credit_type#</td><td>#description#</td><td><Cfif stuid is 0 or stuid is ''>N/A<cfelse>#stuid#</Cfif></td><td><Cfif invoiceid is 0 or invoiceid is ''>N/A<cfelse>#invoiceid#</Cfif></td><td>#LSCurrencyFormat(amount,'local')#</td><td>#LSCurrencyFormat(amount_applied,'local')#</td><td><cfset bal=#amount# - #amount_applied#>#LSCurrencyFormat(bal,'local')#</td>
		</Tr>
		<cfset previousNote = #creditid#>
	</cfloop>
</cfif>
</Cfoutput>	
</table>
</cfform>
</div>
<!----Footer of Credits Table---->
		<table width=100% cellpadding=0 cellspacing=0 border=0>
									<tr valign=bottom >
										<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
										<td width=100% background="pics/header_background_footer.gif"></td>
										<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
									</tr>
								</table>
								
</td>
</tr>
<tr><td colspan=3>

<br>
<!----Applied Credits---->

<Cfquery name="credits" datasource="#APPLICATION.DSN#">
select sc.date, sc.type, sc.description, sc.stuid, sc.invoiceid, sc.amount, sc.creditid, sc.credit_type, c.companyshort
from smg_credit sc
LEFT OUTER JOIN smg_companies c ON c.companyid = sc.companyid
where agentid = #url.userid#
<cfif form.view is not 'all'>
	<cfswitch expression="#FORM.companyID#">
		<cfcase value="1,2,3,4,12">
			and sc.companyid in (1,2,3,4,12)
		</cfcase>
		<cfdefaultcase>
			and sc.companyid = #FORM.companyID#
		</cfdefaultcase>
	</cfswitch>
<cfelse>
	and sc.companyid != 14
</cfif>
and sc.active = 0
ORDER BY sc.creditid DESC, sc.stuid DESC, sc.chargeid ASC
</Cfquery>

<cfform method="post">
	<cfinput name="emailDoc" value="2" type="hidden">
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="pics/header_background.gif"></td>
							<td background="pics/header_background.gif"><h2>Credits & Cancellations Applied</h2></td><td background="pics/header_background.gif" width=16></td>
							<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>
					<div class=scroll>
<table width=98% cellpadding=4 cellspacing =0>

	<tr>
		<Td><cfinput name="sendEmail" type="image" src="pics/email.gif"></Td>
		<Td>ID</Td><td>Comp</td><td>Date</td><td>Type</td><td>Progr</td><td>Description</td><td>Student ID</td><td>Invoice</td><td>Amount</td>
	</tr>
<Cfoutput>

	
<cfif credits.recordcount is 0>
	<tr>
		<td colspan=8 align="center">No credits, refunds or discounts applied to your account.</td>
	</tr>
<cfelse>
	<cfparam name="previousNote" default="0">
	<cfloop query="credits">
		<Tr <cfif credits.currentrow mod 2>bgcolor="ededed"</cfif>>
			<Td>
				<cfif credits.creditid NEQ previousNote>
					<cfinput name="docNumber" value="#creditid#" type="checkbox">
				</cfif>
			</Td>
			<td><a href="invoice/credit_note.cfm?creditid=#creditid#" target="_blank">#credits.creditid#</a></td><td>#companyshort#</td><td>#DateFormat(date, 'mm-dd-yyyy')#</td><td>#type#</td><td>#credit_type#</td><td>#description#</td><td><Cfif stuid is 0 or stuid is ''>N/A<cfelse>#stuid#</Cfif></td><td><Cfif invoiceid is 0 or invoiceid is ''>N/A<cfelse>#invoiceid#</Cfif></td><td>#LSCurrencyFormat(amount,'local')#</td>
		</Tr>
		<cfset previousNote = #creditid#>
	</cfloop>
</cfif>
</Cfoutput>	
</table>
</cfform>
</div>
<!----Footer of Credits Table---->
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

<!--- email invoices, credit notes to intl agents --->

<cfif directoryExists("#AppPath.uploadedFiles#invoices_pdf")>
	<cfdirectory directory="#AppPath.uploadedFiles#invoices_pdf" action="delete" recurse="yes">
</cfif>

<cfif form.docNumber EQ 0>
	<cfabort>
</cfif>

<cfdirectory action="create" directory="#AppPath.uploadedFiles#invoices_pdf" mode="777">

<cfquery name="getAgentInfo" datasource="#APPLICATION.DSN#">
SELECT *
FROM smg_users su
WHERE su.userid = #url.userid#
</cfquery>

<cfif getAgentInfo.email IS NOT "" AND getAgentInfo.billing_email IS "">
	<cfquery name="getAgentInfoSecRun" datasource="#APPLICATION.DSN#">
	UPDATE smg_users su
	SET su.billing_email = su.email
	WHERE userid = #url.userid#
	</cfquery>
	
	<cfquery name="getAgentInfo" datasource="#APPLICATION.DSN#">
	SELECT *
	FROM smg_users su
	WHERE su.userid = #url.userid#
	</cfquery>
</cfif>

<cfswitch expression="#FORM.companyID#">
	<cfcase value="10">
		<cfset compName = "case">
		<cfset emailFrom = 'jennifer@case-usa.org'>
	</cfcase>
	<cfcase value="5">
		<cfset compName = "smg">
		<cfset emailFrom = 'jennifer@iseusa.org'>
	</cfcase>	
	<cfcase value="14">
		<cfset compName = "esi">
		<cfset emailFrom = 'stacy@exchange-service.org'>
	</cfcase>
    <cfcase value="13">
		<cfset compName = "smgcanada">
		<cfset emailFrom = 'jennifer@student-management.com'>
	</cfcase>
	<cfdefaultcase>
		<cfset compName = "ise">
		<cfset emailFrom = 'jennifer@iseusa.org'>
	</cfdefaultcase>
</cfswitch>

<cfswitch expression="#emailDoc#">
	<cfcase value="1">
		<cfset docType = "invoice">
	</cfcase>
	<cfcase value="2">
		<cfset docType = "credit_note">
	</cfcase>
</cfswitch>

<cfloop list="#form.docNumber#" index="iDocNumb">

	<cfswitch expression="#docType#">
		<cfcase value="invoice">
			<cfset url.id = #iDocNumb#>
		</cfcase>
		<cfcase value="credit_note">
			<cfset url.creditid = #iDocNumb#>
		</cfcase>
	</cfswitch>
	
    <!--- Remove "s" from https image links --->	
    <cfset linkSSL = ''>
    
	<cfdocument format="PDF" filename="#AppPath.uploadedFiles#invoices_pdf/#variables.compName#_#variables.docType#_#iDocNumb#.pdf" overwrite="yes">
	
		<cfswitch expression="#docType#">
			<cfcase value="invoice">
	            <cfinclude template="invoice_view.cfm">
			</cfcase>
			<cfcase value="credit_note">
				<cfinclude template="credit_note.cfm">
			</cfcase>
		</cfswitch>

	</cfdocument>
	
</cfloop>

<cfmail from="#variables.emailFrom#" to="#getAgentInfo.billing_email#" bcc="#variables.emailFrom#" subject="#getAgentInfo.businessname#: #variables.compName# #variables.docType#s - please find attached." type="html">

<small>
Dear Partner<br/><br/>

<cfswitch expression="#docType#">

	<cfcase value="invoice">
Please find attached your invoices.<br/>

<font color="##FF0000"><strong>IMPORTANT</strong></font>: In order to avoid balance differences, please check if everything is being correctly charged. If you find an error, please let me know as soon as possible so that I may adjust your account accordingly.<br/>

<font color="##FF0000"><strong>PAYMENT INSTRUCTION</strong></font>: For every payment remitted, please send me an e-mail with the wire receipt for proper payment identification. Please also include the invoice number and respective amounts being paid on all payment information so that I am able to record the payments correctly.<br/>

		<cfif FORM.companyID NEQ 13>
        Payments by check should be mailed directly to our office address (Do not mail checks directly to our bank).<br/>
        </cfif>
        
		<cfif FORM.companyID EQ 14>
            Please keep in mind that the deposit is required before the districts will release the I-20. Final payment is required before our office will release the 			
            I-20 to you.<br/><br/>
            
            Thank you for your cooperation,<br/>
            Stacy
        <cfelseif ListFind("1,2,3,4,5,12",FORM.companyID)>
            Thank you for your cooperation,<br/><br/>
            
            Jennifer<br/>
            Financial Department<br/><br/>
            
            International Student Exchange<br/>
            119 Cooper St<br/>
            Babylon, NY 11702<br/>
            800-766-4656-Toll Free<br/>
            631-893-4540-Phone<br/>
            631-893-4550-Fax<br/>
            jennifer@iseusa.org<br/><br/>
            
            visit our web site at #CLIENT.exits_url#</small>
        <cfelseif FORM.companyID EQ 13>
        	Thank you for your cooperation,<br/><br/>
            
            SMG Canada  
       	<cfelse>
        	Thank you for your cooperation,<br/><br/>
            
            Jennifer<br/>
            Financial Department<br/><br/>
            
            Student Management Group<br/>
            119 Cooper St<br/>
            Babylon, NY 11702<br/>
            800-766-4656-Toll Free<br/>
            631-893-4540-Phone<br/>
            631-893-4550-Fax<br/>
            jennifer@iseusa.org<br/><br/>
            
            visit our web site at #CLIENT.exits_url#</small>
        </cfif>

	</cfcase>
	
	<cfcase value="credit_note">
Please find attached your credit notes. <br/>

These are documents that confirm the cancellations that have been processed in your account. There you can verify the invoice number, student id, a brief description and the amount that was canceled. After receiving these credit notes, please update your records accordingly.<br/><br/>

I'll wait for your instructions on how to apply each credit note just as we normally do for a regular payment (just let me know/confirm the invoice number and respective amounts to apply it). <br/><br/>

These confirmations are one more effort to keep both, yours and our records in the same page.<br/><br/>

		<cfif FORM.companyID EQ 14>            
            Thank you for your cooperation,<br/>
            Stacy
        <cfelseif FORM.companyID EQ 13>
        	Thank you for your cooperation,<br/>
            SMG Canada    
        <cfelse>
            Thank you for your cooperation,<br/><br/>
            
            Jennifer<br/>
            Financial Department<br/><br/>
            
            International Student Exchange<br/>
            119 Cooper St<br/>
            Babylon, NY 11702<br/>
            800-766-4656-Toll Free<br/>
            631-893-4540-Phone<br/>
            631-893-4550-Fax<br/>
            jennifer@iseusa.org<br/><br/>
            
            visit our web site at #CLIENT.exits_url#</small> 
        </cfif>
    
	</cfcase>
</cfswitch>

	<cfloop list="#form.docNumber#" index="iDocNumb">
		<cfmailparam disposition="attachment" type="html" file="#AppPath.uploadedFiles#invoices_pdf/#variables.compName#_#variables.docType#_#iDocNumb#.pdf">
	</cfloop>
	
</cfmail>

<cfset form.docNumber = 0>