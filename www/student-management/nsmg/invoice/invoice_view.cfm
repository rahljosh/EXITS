<!--- ------------------------------------------------------------------------- ----
	
	File:		invoice_view.cfm
	Author:		Marcus Melo
	Date:		June 02, 2011
	Desc:		Invoice View

	Updated:	This file is included by:
				invoice/m_hs_invoiceBatch.cfm
				invoice/user_account_details.cfm
				intRep/invoice_view.cfm	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <cfsetting requesttimeout="99999">
	
    <!--- Param URL Variables --->
    <cfparam name="URL.id" default="0">
    
    <cfparam name="totalPaid" default="0">
    <cfparam name="linkSSL" default="s">
	
    <cfscript>
		// Declare variables | set them to zero otherwise balance will be wrong when user_account_details.cfm generates the invoice PDF
		totalReceived = 0;
		totalPaid = 0;
		invBalance = 0;
	</cfscript>
    
    <cfquery name="qGetInvoiceInfo" datasource="MySQL">
        SELECT 
            c.chargeID,
            c.agentID,
            c.companyID,
            c.stuID,
            c.invoiceID,
            c.programID,
            c.old_programID,
            c.description,
            c.type,
            c.date,
            c.amount_due,
            c.amount,
            c.userInput,
            c.invoiceDate,
            c.active,
            p.type AS progType, 
            (
            	CASE 
                    <!--- Trainee --->
                    WHEN p.type = 7 THEN 7
                    WHEN p.type = 8 THEN 7
                    WHEN p.type = 9 THEN 7
                    <!--- WAT --->
                    WHEN p.type = 11 THEN 8
                    <!--- H2B --->
                    WHEN p.type = 22 THEN 8
                    WHEN p.type = 23 THEN 8
                    ELSE c.companyid
                END
			) AS setCompanyID,
            (
            	CASE 
                    <!--- Trainee --->
                    WHEN p.type = 7 THEN ec.firstname
                    WHEN p.type = 8 THEN ec.firstname
                    WHEN p.type = 9 THEN ec.firstname
                    <!--- WAT --->
                    WHEN p.type = 11 THEN ec.firstname
                    <!--- H2B --->
                    WHEN p.type = 22 THEN ec.firstname
                    WHEN p.type = 23 THEN ec.firstname
                    ELSE ss.firstname
                END
			) AS firstname,
            (
            	CASE 
                    <!--- Trainee --->
                    WHEN p.type = 7 THEN ec.lastname
                    WHEN p.type = 8 THEN ec.lastname
                    WHEN p.type = 9 THEN ec.lastname
                    <!--- WAT --->
                    WHEN p.type = 11 THEN ec.lastname
                    <!--- H2B --->
                    WHEN p.type = 22 THEN ec.lastname
                    WHEN p.type = 23 THEN ec.lastname
                    ELSE ss.familylastname
                END
			) AS lastname
        FROM 
            smg_charges c
        LEFT OUTER JOIN 
            smg_programs p ON p.programid = c.programid
        LEFT OUTER JOIN 
            smg_students ss ON ss.studentID = c.stuID
        LEFT OUTER JOIN 
            extra_candidates ec ON ec.candidateID = c.stuID
        WHERE 
            c.invoiceid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.id)#">
        GROUP BY 
            c.stuid
        ORDER BY 
            firstname,
            lastname
    </cfquery>
    
    <cfquery name="qGetInvoicePayments" datasource="MySQL">
        SELECT 
            SUM(spc.amountapplied) AS amountapplied,
            spr.paymenttype,
            spr.paymentref,
            spr.date,
            spr.totalreceived
        FROM
            smg_payment_charges spc
        LEFT OUTER JOIN
            smg_payment_received spr ON spr.paymentid = spc.paymentid
        LEFT OUTER JOIN
            smg_charges sc ON sc.chargeid = spc.chargeid
        WHERE
            sc.invoiceid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetInvoiceInfo.invoiceID)#">
        GROUP BY
            spr.paymentref
        ORDER BY
            spr.date DESC
    </cfquery>

    <cfquery name="qGetIntlRepInfo" datasource="MySQL">
        SELECT 
            u.userID,
            u.businessName,
            u.firstName,
            u.lastName,
			u.address,
            u.address2,
            u.city,
            u.zip,
            u.email,
            u.phone,
            u.fax,
            u.billing_company,
            u.billing_contact,
            u.billing_address,
            u.billing_address2,
            u.billing_city,
			u.billing_zip,
            u.billing_email,
            u.billing_phone,
            u.billing_fax,            
        	userCountry.countryName, 
	        billCountry.countryname as billCountryName
        FROM 
        	smg_users u  
        LEFT OUTER JOIN 
        	smg_countrylist userCountry ON userCountry.countryid = u.country  
        LEFT OUTER JOIN 
        	smg_countrylist billCountry ON billCountry.countryid = u.billing_country  
        WHERE 
        	u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetInvoiceInfo.agentid)#">
    </cfquery>

	<!----Retrieve Total Due from Invoice---->
    <cfquery name="qTotalDue" datasource="MySQL">
        SELECT 
        	sum(amount_due) AS total_due 
        FROM 
        	smg_charges
        WHERE 
        	invoiceid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetInvoiceInfo.invoiceID#">
    </cfquery>
    
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Invoice <cfoutput>###qGetInvoiceInfo.invoiceID#</cfoutput></title>
<link rel="stylesheet" href="../profile.css" type="text/css">
<style type="text/css">
	<!--
	body{
		font-family: Arial, Helvetica, sans-serif;	
	}
	
	table,tr,td{
		font-size:12px;
	}

	table.nav_bar { 
		font-size: 10px; 
		background-color: #ffffff; 
		border: 1px solid #000000; 
	}
	
	.thin-border { 
		border: 1px solid #000000;
	}
	
	.thin-border-right { 
		border-right: 1px solid #000000;
	}
	
	.thin-border-left { 
		border-left: 1px solid #000000;
	}
	
	.thin-border-right-bottom { 
		border-right: 1px solid #000000; 
		border-bottom: 1px solid #000000;
	}
	
	.thin-border-bottom {
		border-bottom: 1px solid #000000;
	}
	
	.thin-border-top { 
		border-top: 1px solid #000000;
	}
	
	.thin-border-left-bottom { 
		border-left: 1px solid #000000; 
		border-bottom: 1px solid #000000;
	}
	
	.thin-border-left-bottom-right { 
		border-left: 1px solid #000000; 
		border-bottom: 1px solid #000000; 
		border-right: 1px solid #000000;
	}
	
	.style1 {
		color: #FF0000;
		font-weight: bold;
	}
	.style3 {
		color: #FF0000; 
		font-weight: bold; 
		font-size: 16px; 
	}
	-->
</style>
</head>
<body>

<cfoutput>
	
    <!--- Not Valid Invoice ID --->
    <cfif NOT VAL(URL.id)> 
        <table align="center" width="90%" frame="box">
        	<tr>
            	<th>No invoice specified, please go back and select an invoice. <br />If you received this error from clicking directly on a link, contact the person who sent you the link.</th>
            </tr>
        </table>
        <cfabort>

    <!--- Invoice Not Found --->
	<cfelseif NOT VAL(qGetInvoiceInfo.recordcount)> 
        <table align="center" width="90%" frame="box">
        	<tr>
            	<th>No invoice was found with the id: #URL.id# please go back and select a different invoice. <br />If you recieved this error from clicking directly on a link, contact the person who sent you the link.</th>
			</tr>
        </table>
        <cfabort>

    <!--- Intl. Rep. Viewing Invoice --->
	<cfelseif NOT ListFind("1,2,3,4", CLIENT.usertype)>
    
        <cfif qGetInvoiceInfo.agentID NEQ CLIENT.userID> 
            <table align="center" width="90%" frame="box">
                <tr>
                    <td valign="top"><img src="../../nsmg/pics/error.gif"></td>
                    <td valign="top">
                    	<font color="##CC3300">
                        	You can only view your invoices. The invoice that you are trying to view does not belong to you. <br />
                            If you received this error from clicking directly on a link, contact the person who sent you the link.
                        </font>
                    </td>
                </tr>
            </table>
            <cfabort>
        </cfif>
        
    </cfif>
    
    <table align="center">
        <tr>
            <td>
                <!--- this cfif is good as long as the trainee invoices are not automated, which they will be in the future. THE CFELSE PART SHOULD BE GOOD AT ALL TIMES --->
                <cfif qGetInvoiceInfo.type EQ 'trainee program'>
                    
                    <img src="../../nsmg/pics/logos/csb_banner.gif"/>
                
				<cfelse>
                    
                    <cfswitch expression="#qGetInvoiceInfo.setCompanyID#">
                        
                        <!--- Extra --->
                        <cfcase value="8">
                            <img src="../../nsmg/pics/logos/csb_banner.jpg" width="640" height="114" align="center"/>
                        </cfcase>
                        
                        <!--- Case --->
                        <cfcase value="10">
                            <img src="../../nsmg/pics/case_banner.jpg" width="665" height="113" align="center" />
                        </cfcase>
                        
                        <!--- SMG Canada --->
                        <cfcase value="13">
                            <img src="../../nsmg/pics/Canada_logo_1.png" width="665" height="80" align="center" />
                        </cfcase>
                        
						<!--- ESI --->
                        <cfcase value="14">
                            <img src="../../nsmg/pics/esiBanner.jpg" width="665" height="80" align="center" />
                        </cfcase>
                        
                        
                  <!--- ISE --->   
                        <cfdefaultcase>
                            <img src="../../nsmg/pics/ise_banner.jpg" align="center" />
                        </cfdefaultcase>
                        
                    </cfswitch>  
                                          
                </cfif>                   
            </td>
        </tr>
    </table>
    
    <br />
    
    <table width="100%" border="0" cellspacing="0" cellpadding="2"> 
        <tr>
            <td bgcolor="##CCCCCC" class="thin-border" background="../pics/cccccc.gif">Remit To:</td>
            <td width="10px;">&nbsp;</td>
            <td bgcolor="##CCCCCC" class="thin-border" >Bill To:</td>
            <td rowspan="2">  
                
                <table border="0" cellspacing="0" cellpadding="2" align="right" class="thin-border">
                    <tr>
                        <td bgcolor="##CCCCCC" align="center" class="thin-border-bottom"><strong><font size="+1">Invoice</font></strong></td>
                    </tr>
                    <tr>
                        <td align="center" class="thin-border-bottom"><strong><font size=+1>## #qGetInvoiceInfo.invoiceid#</font></strong></td>
                    </tr>
                    <tr>
                        <td bgcolor="##CCCCCC" align="center" class="thin-border-bottom">Date</td>
                    </tr>
                    <tr>
                        <td  align="center" class="thin-border-bottom">#DateFormat(qGetInvoiceInfo.invoicedate, 'mm/dd/yyyy')#</td>
                    </tr>
                    <tr>
                        <td bgcolor="##CCCCCC" align="center"  class="thin-border-bottom">Terms </td>
                    </tr>
                    <tr>
                        <td align="center">Due Upon Receipt</td>
                    </tr>
                </table>
                
        	</td>
        </tr>
		<tr>
            <td valign="top" class="thin-border-left-bottom-right">

				<!--- this cfif is good as long as the trainee invoices are not automated, which they will be in the future. THE CFELSE PART SHOULD BE GOOD AT ALL TIMES --->
                <cfif qGetInvoiceInfo.type EQ 'trainee program'>
                	
                    <!--- EXTRA - Trainee --->  
                    <span class="style3">
                        Please note our new bank information <br />  <br />               
                        International Student Exchange<br />
                        Chase Bank<br />
                        595 Sunrise Highway<br />
                        West Babylon, NY 11704<br />
                        ABA/Routing: 021000021<br />
                        Account: 465496912<br />
                        SWIFT code: CHASUS33<br />      
                    </span>                                  
                    
                <cfelse>
                
                    <cfswitch expression="#qGetInvoiceInfo.setCompanyID#">

						<!--- EXTRA - Trainee --->                
                        <cfcase value="7">
                            <span class="style3">
                                Please note our new bank information <br />  <br />               
                                International Student Exchange<br />
                                Chase Bank<br />
                                595 Sunrise Highway<br />
                                West Babylon, NY 11704<br />
                                ABA/Routing: 021000021<br />
                                Account: 465496912<br />
                                SWIFT code: CHASUS33<br />      
                            </span> 
                        </cfcase>

                        <!--- Extra - WAT --->
                        <cfcase value="8">
                            <span class="style3">CSB International</span><br />
                            JPMorgan Chase<br />
                            595 Sunrise Highway<br />
                            West Babylon, NY 11704<br />
                            ABA/Routing: 021000021<br />
                            <span class="style3">Account: 745938175</span><br />
                            SWIFT code: CHASUS33<br />            
                        </cfcase>
                        
                        <!--- CASE --->
                        <cfcase value="10">
                            <span class="style3">Cultural Academic Student Exchange</span><br />
                            Chase Bank<br />
                            Red Bank, NJ 07701<br /><br />
                            ABA/Routing: 021202337<br />
                            <span class="style3">Account: 747523579</span><br />
                            SWIFT## : CHASUS33<br />            
                        </cfcase>
                        
                        <!--- ESI --->
                        <cfcase value="14">
                            <span class="style3">SLB Consulting Corporation</span><br />
                            Chase Bank<br />
                            289 Market Street<br />
                            Saddle Brook, NJ 07663<br /><br />
                            ABA/Routing: 021202337<br />
                            Account: 913619078<br />
                            SWIFT code:  CHASUS33<br /><br />
                        </cfcase>
                        
                         <!--- SMG Canada --->
                        <cfcase value="13">
                            <span class="style3">Student Management Group, Inc.</span><br />
                            Student Management Group, Inc.<br />
                            119 Cooper St.<br />
                            Babylon, NY 11702 <br /><br />
                            <strong>Intermediary Bank</strong><br />
                            SWIFT/BIC: ROYCCAT2<br />
                            Royal Bank of Canada, Toronto<br />
                            Account No: 07172-100-012-4 <br /><br />
                            <strong>Beneficiary Bank</strong><br />
                            SWIFT/BIC: CHASCATTCTS<br />
                            JPMorgan Chase Bank, N.A., Toronto Branch<br />
                            Account No: 4683000887<br /><br />
                            <strong>For EFT/ACH Payments </strong> - Transit No. 00012 - Bank No. 270<br /><br />
                  </cfcase>
                        
                        <!--- ISE --->
                        <cfdefaultcase>
                            <span class="style3">
                                Please note our new bank information <br />  <br />               
                                International Student Exchange<br />
                                Chase Bank<br />
                                595 Sunrise Highway<br />
                                West Babylon, NY 11704<br />
                                ABA/Routing: 021000021<br />
                                Account: 773701875<br />
                                SWIFT code: CHASUS33<br />      
                            </span>            
                            
                            <!--- SMG ACCOUNT INFO --->
                            <!---
							Student Management Group<br />
							JPMorgan Chase<br />
							403 N. Little E. Neck Rd.<br />
							West Babylon, NY 11704<br />
							ABA/Routing: 021000021<br />
							Account: 773701750<br />
							SWIFT code: CHASUS33<br />
							--->
                        </cfdefaultcase>
                    
                    </cfswitch>  
                
				</cfif>
            </td>
            <td>&nbsp;</td>
            <td valign=top class="thin-border-left-bottom-right">
                #qGetIntlRepInfo.billing_company#<br />
                #qGetIntlRepInfo.billing_contact#<br />
                #qGetIntlRepInfo.billing_address#<br />
              <cfif NOT LEN(qGetIntlRepInfo.billing_address2)>#qGetIntlRepInfo.billing_address2# <br /></cfif>
                #qGetIntlRepInfo.billing_city# #qGetIntlRepInfo.billcountryname# #qGetIntlRepInfo.billing_zip#<br />
                E: #qGetIntlRepInfo.billing_email#<br />
                P: #qGetIntlRepInfo.billing_phone#<br />
                F: #qGetIntlRepInfo.billing_fax#<br />
            </td>
		</tr>
        
		<cfif qGetIntlRepInfo.billing_address NEQ qGetIntlRepInfo.address 
			OR qGetIntlRepInfo.billing_address2 NEQ qGetIntlRepInfo.address2
			OR qGetIntlRepInfo.billing_city NEQ qGetIntlRepInfo.city 
			OR qGetIntlRepInfo.billing_zip NEQ qGetIntlRepInfo.zip>

            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td bgcolor="##CCCCCC" class="thin-border" background="../pics/cccccc.gif">Local Contact:</td>
            </tr>
            <tr>
                <td valign=top class="thin-border-left-bottom-right">
	                #qGetIntlRepInfo.businessname# (#qGetIntlRepInfo.userid#)<br />
    	            #qGetIntlRepInfo.firstname# #qGetIntlRepInfo.lastname#<br />
   	            #qGetIntlRepInfo.address#<br />
            	    <cfif NOT LEN(qGetIntlRepInfo.address2)>#qGetIntlRepInfo.address2#<br /></cfif>
                	#qGetIntlRepInfo.city#, #qGetIntlRepInfo.countryname# #qGetIntlRepInfo.zip#<br />
	                E: #qGetIntlRepInfo.email#<br />
    	            P: #qGetIntlRepInfo.phone#<br />
        	        F: #qGetIntlRepInfo.fax#<br />
				</td>
			</tr>
		</cfif>
        
	</table>
    
	<br />

	<!-----Invoice with Students---->
    <div align="center"><img src="../../nsmg/pics/detach.jpg" ></div><br />

    <table width="100%" cellspacing="0" cellpadding="2" class="thin-border" border="0"> 
        <tr bgcolor="##CCCCCC" >
            <td class="thin-border-right-bottom">
                Student
            </td>
            <td class="thin-border-right-bottom">
                Description / Type
            </td>
            <td class="thin-border-right-bottom" align="right">
                Charge
            </td>
            <td class="thin-border-bottom" align="right">
                Total
            </td>
        </tr>
        
        <cfif client.companyid EQ 14>
        
            <tr>
                <td></td>
                <td colspan="3">
                    <font color="##FF0000">Note: If the charge for Insurance and Sevis is $0.00, it means that they are included in the program fee, or not relevant to program.</font></td>
            </tr>
        
        </cfif>

        <cfloop query="qGetInvoiceInfo">
        
            <cfquery name="qGetChargeCount" datasource="MySQL">
                SELECT 	
                	chargeid, 
                    stuid, 
                    description, 
                    type, amount 
				FROM 
                	smg_charges
                WHERE 
                	invoiceid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetInvoiceInfo.invoiceID#"> 
                AND 
                	stuid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetInvoiceInfo.stuid#">
            </cfquery>
            
            <cfquery name="qGetTotalStudent" datasource="MySQL">
                SELECT 
                	sum(amount) AS total_stu_amount
                FROM 
                	smg_charges
                WHERE 
                	invoiceid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetInvoiceInfo.invoiceID#">  
                AND
                	stuid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetInvoiceInfo.stuid#">
            </cfquery>
            
            <cfloop query="qGetChargeCount">
                <tr>
                    <td>
						<cfif qGetChargeCount.CurrentRow EQ 1>
                            #qGetInvoiceInfo.firstname# #qGetInvoiceInfo.lastname# (###qGetInvoiceInfo.stuid#)
						</cfif>
                    </td>
                    <td>
                        #qGetChargeCount.description# / #qGetChargeCount.type#
                    </td>
                    <td align="right">
                        #LSCurrencyFormat(qGetChargeCount.amount,'local')#
                    </td>
                    <td align="right">
						<cfif qGetChargeCount.CurrentRow EQ qGetChargeCount.recordCount>
                            #LSCurrencyFormat(qGetTotalStudent.total_stu_amount, 'local')#
                        </cfif>
                    </td>
                </tr>
            </cfloop>
            
            <cfquery name="qVerifyIfShowDeposit" datasource="MySQL">
                SELECT 
                	sch.amount_due, 
                    sch.amount
                FROM 
                	smg_charges sch
                WHERE 
                	sch.stuid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetInvoiceInfo.stuid#">
                AND 
                	sch.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetInvoiceInfo.programid#">
                AND 
                	sch.agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetInvoiceInfo.agentid#">
                AND 
                	sch.type = <cfqueryparam cfsqltype="cf_sql_varchar" value="program fee">
                AND 
                	sch.invoiceid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetInvoiceInfo.invoiceID#">
            </cfquery>
            
            <!--- if amount_due is different than amount, it means that there is a deposit invoice --->
            <cfif qVerifyIfShowDeposit.amount_due NEQ qVerifyIfShowDeposit.amount>
            
                <cfquery name="qFindDepositInvoice" datasource="MySQL">
                    SELECT 
                    	sch.invoiceid, 
                        sch.type, 
                        amount_due
                    FROM 
                    	smg_charges sch
                    WHERE 
                    	sch.stuid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetInvoiceInfo.stuid#">
                    AND 
                    	sch.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetInvoiceInfo.programid#">
                    AND 
                    	sch.agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetInvoiceInfo.agentid#">
                    AND 
                    	sch.invoiceid < <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetInvoiceInfo.invoiceID#">
                    AND 
                    	sch.type = <cfqueryparam cfsqltype="cf_sql_varchar" value="deposit">
                    ORDER BY 
                    	invoiceid DESC
                </cfquery>
            
				<cfif qFindDepositInvoice.type EQ 'deposit'>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            #qGetChargeCount.description# / #qFindDepositInvoice.type# - <a href="invoice_view.cfm?id=#qFindDepositInvoice.invoiceid#">invoice ###qFindDepositInvoice.invoiceid#</a>
                        </td>
                        <td align="right">
                            <font color="##FF0000">(#LSCurrencyFormat(qFindDepositInvoice.amount_due,'local')#)</font>
                        </td>
                        <td align="right">
                            #LSCurrencyFormat(qGetTotalStudent.total_stu_amount - qFindDepositInvoice.amount_due, 'local')#
                        </td>
                    </tr>
                </cfif>
            
            </cfif>
        
        </cfloop>

	</table>
	
    <table width="100%" cellspacing="0" cellpadding="2" border="0">	
        <tr>
            <td valign="top" rowspan="#qGetInvoicePayments.recordCount+4#" width="470"> 
				<cfif qGetInvoiceInfo.type IS 'trainee program' OR qGetInvoiceInfo.companyid EQ 8>
					
					<!--- this cfif is good as long as the trainee invoices are not automated, which they will be in the future. THE CFELSE PART SHOULD IS GOOD AT ALL TIMES --->
                    <img src="../../nsmg/pics/logos/csb_logo_small.jpg" height="100"/>
                    
                <cfelse>
                
                    <cfswitch expression="#qGetInvoiceInfo.setCompanyID#">
                    
                        <!--- Extra --->
                        <cfcase value="8,9,11,22,23">
                            <img src="../../nsmg/pics/logos/csb_logo_small.jpg" height="100"/>
                        </cfcase>
                        
                        <!--- Extra Trainee: ISE logo --->
                        <cfcase value="7">
                            <img src="../../nsmg/pics/logos/1.gif" height="100"/>
                        </cfcase>
                        
                        <!--- ESI --->
                        <cfcase value="14">
                            <img src="../../nsmg/pics/logos/14.gif" />
                        </cfcase>
                        
                        <!--- SMG Canada --->
                        <cfcase value="13">
                        <img src="../../nsmg/pics/logos/13_header_logo.png" />
                        </cfcase>
                        
                        <!--- ISE / CASE --->
                        <cfdefaultcase>
                        <img src="../../nsmg/pics/logos/#qGetInvoiceInfo.companyid#.gif" height="100"/>
                        </cfdefaultcase>
                    
                    </cfswitch>                        
                
                </cfif>
          </td>
            <td width="300" colspan="7" height="50" align="right" class="thin-border-left-bottom"><strong>SUB - TOTAL:</strong></td>
            <td align="right" class="thin-border-right-bottom"><strong>#LSCurrencyFormat(qTotalDue.total_due,'local')#</td>
        </tr>
        
        <cfif VAL(qGetInvoicePayments.recordCount)>
            <tr>
                <td colspan="3" align="left" class="thin-border-left"><strong>Payments Applied to this invoice:</strong></td>
                <td align="left"><strong>Payment Type</strong></td>
                <td align="left"><strong>Payment Reference</strong></td>
                <td align="left"><strong>Original Amount</strong></td>
                <td align="left"><strong>Date Received</strong></td>
                <td align="right"  class="thin-border-right"><strong>Amount Applied to this invoice</strong></td>
            </tr>
        
            <cfloop query="qGetInvoicePayments">
                <tr>
                    <td colspan="3" align="left" class="thin-border-left">&nbsp;</td>
                    <td align="left">
						<cfif qGetInvoicePayments.paymenttype EQ 'apply credit'>
                            credit note
                            
                            <cfquery name="qGetTotalCreditNote" datasource="MySQL">
                                SELECT
                                    SUM(amount) AS amount
                                FROM
                                    smg_credit
                                WHERE
                                    creditid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetInvoicePayments.paymentref#">
                                GROUP BY
                                    creditid
                            </cfquery>
                            
                            <cfset totalReceived = qGetTotalCreditNote.amount>
                            
						<cfelse>
                        
                            #qGetInvoicePayments.paymenttype#
                            <cfset totalReceived = qGetInvoicePayments.totalreceived>
                        
						</cfif>
                    </td>
                    <td align="left">#qGetInvoicePayments.paymentref#</td>
                    <td align="left">#LSCurrencyFormat(variables.totalReceived, 'local')#</td>
                    <td align="left">#dateFormat(qGetInvoicePayments.date, 'mm/dd/yyyy')#</td>
                    <td align="right" class="thin-border-right"><font color="##FF0000">-#LSCurrencyFormat(qGetInvoicePayments.amountapplied, 'local')#</font></td>
                </tr>
                <cfset totalPaid = totalPaid + qGetInvoicePayments.amountapplied>
            </cfloop>
            <tr>
                <td colspan="6" class="thin-border-top">&nbsp;</td>
                <td align="right" height="50" class="thin-border-left-bottom-right thin-border-top"><strong>TOTAL PAID:</strong></td>
                <td align="right" class="thin-border-right-bottom  thin-border-top">
                	<strong><font color="##FF0000">-#LSCurrencyFormat(variables.totalPaid, 'local')#</font></strong>
                </td>
            </tr>
        </cfif>
        
        <cfset invBalance = qTotalDue.total_due - variables.totalPaid>
        
        <tr>
            <td width="300" colspan="6">&nbsp;</td>
            <td align="right" height="50" bgcolor="##CCCCCC"  class="thin-border-left-bottom-right"><strong>TOTAL DUE:</strong></td>
            <td align="right" bgcolor="##CCCCCC" class="thin-border-right-bottom">
            <strong>#LSCurrencyFormat(variables.invBalance, 'local')#</strong>
            </td>
        </tr>
    </table>
    
    <br /><br />
    
</cfoutput>
    
</body>
</html>