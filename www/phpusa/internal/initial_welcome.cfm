<table cellSpacing="0" cellPadding="0" align="center" class="regContainer">
    <tr>
        <td colSpan="3" height="10">&nbsp;</td>
    </tr>
    <tr>
        <td class="orangeLine" colSpan="3" height="11"><img height=11 src="spacer.gif" width=1></td>
    </tr>
    <tr>
        <td colSpan="3" height="10">&nbsp;</td>
    </tr>
    <tr>
        <td width="10">&nbsp;</td>
        <td>
			<!---- Outer Table (outline and title) ---->
            <table cellspacing="0" cellpadding="3" width="100%" border="0">
                <tr>
                    <td class="groupTopLeft">&nbsp;</td>
                    <td class="groupCaption" nowrap="true">News & Announcments</td>
                    <td class="groupTop" width="95%">&nbsp;</td>
                    <td class="groupTopRight">&nbsp;</td>
                </tr>
                <tr>
                    <td class="groupLeft">&nbsp;</td>
                    <td colspan="2">
						<!----News & Announcements---->
                        <cfquery name="news_messages" datasource="#application.dsn#">
                            select *
                            from smg_news_messages
                            where messagetype = 'news'
                            and expires > #now()# and startdate < #now()#
                            and companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
                            ORDER BY startdate DESC
                        </cfquery>
                        <table border=0 width=100%>
                            <tr>
                                <td valign="top">
                                    <cfif news_messages.recordcount eq 0>
                                        <strong><cfoutput>#DateFormat(now(), 'mmm. d, yyyy')#</cfoutput></strong><br>
                                        There are currently no announcements or news items.
                                    <cfelse>
                                        <cfoutput query="news_messages">
                                            <p><b>#message#</b><br>
                                            #DateFormat(startdate, 'MMMM D, YYYY')# - #replaceList(details, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#
											<cfif additional_file is not ''>
                                                <br /><img src="pics/info.gif" height="15" border="0" />&nbsp;<a href="uploadedfiles/news/#additional_file#" target="_blank">Additional Information (pdf)</font></a>
                                            </cfif>
                                            </p>
                                        </cfoutput>
                                    </cfif>
                                </td>
                                <td align="right"><img src="pics/tower.gif" width="31" height="51"></td>
                            </tr>
                        </table>
                    </td>
                    <td class="groupRight">&nbsp;</td>
				</tr>
                <tr>
					<td class="groupBottomLeft">&nbsp;</td>
                    <td class="groupBottom" colspan="2">&nbsp;</td>
                    <td class="groupBottomRight">&nbsp;</td>
				</tr>
            </table>
			<!---- End Outer Table (outline and title) ---->				
		</td>
		<td width="10">&nbsp;</td>
	</tr>
                            
<!----Info for Reps---->
<cfif client.usertype neq 8>

    <tr>
        <td width="10">&nbsp;</td>
        <td>
			<!---- Outer Table (outline and title) ---->
            <table cellspacing="0" cellpadding="3" width="100%" border="0">
                <tr>
                    <td class="groupTopLeft">&nbsp;</td>
                    <td class="groupCaption" nowrap="true">Progress Reports</td>
                    <td class="groupTop" width="95%">&nbsp;</td>
                    <td class="groupTopRight">&nbsp;</td>
                </tr>
                <tr>
                    <td class="groupLeft">&nbsp;</td>
                    <td colspan="2">
						<!----Progress Reports ---->
                        <a href="index.cfm?curdoc=lists/progress_reports">Progress Reports</a>
                    </td>
                    <td class="groupRight">&nbsp;</td>
				</tr>
                <tr>
					<td class="groupBottomLeft">&nbsp;</td>
                    <td class="groupBottom" colspan="2">&nbsp;</td>
                    <td class="groupBottomRight">&nbsp;</td>
				</tr>
            </table>
			<!---- End Outer Table (outline and title) ---->				
		</td>
		<td width="10">&nbsp;</td>
	</tr>
				
<!----Info for agents---->
<cfelse>
	
    <!--- 07/19/2011 - Commenting this out - Need to check if information is accurate --->
    <!---
    
    <tr>
        <td width="10">&nbsp;</td>
        <td>
			<!---- Outer Table (outline and title) ---->
            <table cellspacing="0" cellpadding="3" width="100%" border="0">
                <tr>
                    <td class="groupTopLeft">&nbsp;</td>
                    <td class="groupCaption" nowrap="true">Account Balance</td>
                    <td class="groupTop" width="95%">&nbsp;</td>
                    <td class="groupTopRight">&nbsp;</td>
                </tr>
                <tr>
                    <td class="groupLeft">&nbsp;</td>
                    <td colspan="2">
                        <!--- info spacing table --->
                        <TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
                        	<TR>
                        		<TD valign="center">
									<!----Financial Summary---->
                                    <table border="0" cellpadding="3" cellspacing="0" width="100%">
                                        <tr>
                                            <td>Account Balance</td>
                                            <td>Recent Payments</td>
                                        </tr>
                                        <tr valign="top">
                                            <td>
												<!----Amount Due---->
                                                <cfquery name="amount_due" datasource="#application.dsn#">
                                                    select sum(amount) as total_Due
                                                    from egom_charges
                                                    LEFT JOIN egom_invoice on egom_invoice.invoiceid = egom_charges.invoiceid
                                                    where egom_invoice.intrepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                                                    and egom_charges.full_paid = 0
                                                    and egom_invoice.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
                                                </cfquery>
												<cfif amount_due.total_due is ''>
                                                	<strong>$0.00</strong>
                                                <cfelse>
                                                	<strong><cfoutput>#LSCurrencyFormat(amount_due.total_due, 'local')#</cfoutput></strong>
                                                </cfif>
                                                <br />
                                                <font size="-2"><a href="index.cfm?curdoc=invoice/int_rep_invoice_index">View full account details</a></font>
                                            </td>
                                            <td>
												<cfset daysago = now() - 30>
                                                <!----Recent Payments---->
                                                <cfquery name="payments_received" datasource="#application.dsn#">
                                                    select sum(total_amount) as payments_received
                                                    from egom_payments
                                                    where intrepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                                                    and companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
                                                    and (date_applied between #CreateODBCDateTime(daysago)# and #CreateODBCDateTime(now())#)
                                                </cfquery>
                                                <A href="?curdoc=invoice/int_rep_account_activity">
                                                    <cfif payments_received.payments_received is ''>
                                                        <strong>$0.00</strong>
                                                    <cfelse>
                                                        <strong><cfoutput>#LSCurrencyFormat(payments_received.payments_received, 'local')#</cfoutput></strong>
                                                    </cfif>
                                                </A>
												<br />
                                                <font size="-2">Last 30 days, <A href="index.cfm?curdoc=invoice/int_rep_account_activity">click for all</A></font>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td width="40%" valign="top">
                                    <table border="0" cellpadding="3" cellspacing="0" width="100%">
                                        <tr><td><u>Last Payment</u><br></td></tr>
                                        <tr>
                                            <td>
                                                <cfquery name="max_payment_id" datasource="#application.dsn#">
                                                    select max(paymentid) as payid
                                                    from egom_payments
                                                    where intrepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                                                </cfquery>
                                                <cfif max_payment_id.payid is ''>
                                               		No payments have been processed.
                                                <cfelse>
                                                    <cfquery name="last_payment" datasource="#application.dsn#">
                                                        select total_amount, date_applied, paymenttypeid
                                                        from egom_payments
                                                        where paymentid = #max_payment_id.payid#
                                                    </cfquery>
                                                    <cfoutput>#LSCurrencyFormat(last_payment.total_amount, 'local')# on #DateFormat(last_payment.date_applied,'mm/dd/yyyy')#</cfoutput>
                                                </cfif>
                                            </td>
                                        </tr>
                                    </table>
                                </TD>
                             </tr>
                        </table>
                        <!--- info spacing table --->
                    </td>
                    <td class="groupRight">&nbsp;</td>
				</tr>
                <tr>
					<td class="groupBottomLeft">&nbsp;</td>
                    <td class="groupBottom" colspan="2">&nbsp;</td>
                    <td class="groupBottomRight">&nbsp;</td>
				</tr>
            </table>
			<!---- End Outer Table (outline and title) ---->				
		</td>
		<td width="10">&nbsp;</td>
	</tr>
	
	--->
    		
</cfif>
			
    <tr>
        <td colSpan="3" height="10">&nbsp;</td>
    </tr>
</table>
<br />