<!--- ------------------------------------------------------------------------- ----
	
	File:		_payReps.cfm
	Author:		James Griffiths
	Date:		March 25, 2014
	Desc:		Pay Reps
				
				#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=payReps
				
----- ------------------------------------------------------------------------- --->

<cfparam name="URL.printPage" default="0">
<cfparam name="FORM.submitted" default="0">
<cfparam name="FORM.payRep" default="0">

<cfquery name="qGetPayments" datasource="#APPLICATION.DSN#">
	SELECT 
    	p.*,
        p.ID,
        t.type,
        CASE 
            WHEN s.middleName != "" THEN CONCAT(s.firstName, " ", s.middleName, " ", s.familyLastName)
            ELSE CONCAT(s.firstName, " ", s.familyLastName)
            END AS studentName
    FROM smg_users_payments p
    LEFT JOIN smg_users_payments_type t ON t.ID = p.paymentType
    LEFT JOIN smg_students s ON s.studentID = p.studentID
    WHERE p.isDeleted = 0
    AND (p.isPaid = 0 OR p.isPaid IS NULL)
    AND p.date >- "2014-04-04"
    <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
        AND p.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
    <cfelse>
        AND p.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
    </cfif>
</cfquery>

<cfquery name="qGetPaymentsGrouped" datasource="#APPLICATION.DSN#">
	SELECT 
    	p.*, 
        SUM(p.amount) AS total,
        CASE
            WHEN u.middleName != "" THEN CONCAT(u.firstName, " ", u.middleName, " ", u.lastName)
            ELSE CONCAT(u.firstName, " ", u.lastName)
            END AS agentName
    FROM smg_users_payments p
    LEFT JOIN smg_users u ON u.userID = p.agentID
    WHERE p.isDeleted = 0
    AND p.date >= "2014-04-04"
    <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
        AND p.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
    <cfelse>
        AND p.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
    </cfif>
    GROUP BY p.agentID
</cfquery>

<cfquery name="qGetResults" dbtype="query">
	SELECT *
    FROM qGetPaymentsGrouped
    WHERE total > 0
    ORDER BY agentName
</cfquery>

<cfquery name="qGetTotalPayment" dbtype="query">
	SELECT SUM(total) AS total
    FROM qGetResults
</cfquery>

<cfif VAL(FORM.submitted)>

	<cfloop query="qGetResults">
    	<cfif ListFind(FORM.payRep,qGetResults.agentID)>
        	<cfquery name="qGetRepPayments" dbtype="query">
                SELECT *
                FROM qGetPayments
                WHERE agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(agentID)#">
            </cfquery>
            <cfif VAL(qGetRepPayments.recordCount)>
                <cfquery datasource="#APPLICATION.DSN#">
                    UPDATE smg_users_payments
                    SET
                        isPaid = 1,
                        date = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
                    WHERE ID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(qGetRepPayments.ID)#" list="yes"> )
                </cfquery>
            </cfif>
            <cfquery datasource="#APPLICATION.DSN#">
                INSERT INTO smg_users_payments(
                    agentID,
                    companyID,
                    paymenttype,
                    transtype,
                    amount,
                    date,
                    inputBy,
                    isDeleted,
                    isPaid,
                    dateCreated,
                    creditStatus
                )
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(agentID)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(companyID)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="37">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="Payment">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="-#total#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="3">
                )
            </cfquery>
     	</cfif>
    </cfloop>
    
    <cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=payReps">
        
</cfif>

<cfoutput>

	<cfif VAL(URL.printPage)>
		
		<script type="text/javascript">
            window.onload = function() {
				window.print();
			}
        </script>
    
    </cfif>

	<form name="updatePaidReps" method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=payReps">
    	<input type="hidden" name="submitted" value="1" /> 
    
    	<table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
			<tr>
                <td style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Pay Representatives</td>
                <td style="background-color:##010066; color:##FFFFFF; font-weight:bold; text-align:right; padding-right:10px;">
                    Total of #qGetResults.recordCount# representative(s)
                </td>
            </tr>
            <tr style="background-color:##E2EFC7; font-weight:bold;">
                <td width="20%">Representative</td>
                <td width="80%">
                	Payments 
                    <cfif NOT VAL(URL.printPage)>
                    	<span style="float:right;">
                            <input type="checkbox" onclick="if ($(this).prop('checked')) {$(':checkbox').prop('checked',true);} else {$(':checkbox').prop('checked',false);}" />Select All
                        </span>
                  	</cfif>
             	</td>
            </tr>
        
            <cfloop query="qGetResults">
            	<cfquery name="qGetRepPayments" dbtype="query">
                	SELECT *
                    FROM qGetPayments
                    WHERE agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(agentID)#">
                </cfquery>
                <tr bgcolor="###iif(qGetResults.currentRow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
               		<td>#agentName# (###agentID#)</td>
                    <td>
                    	<table width="100%">
                        	<tr style="font-weight:bold; text-decoration:underline;">
                            	<td width="20%">Date Entered</td>
                                <td width="50%">Student</td>
                                <td width="20%">Payment Type</td>
                                <td width="10%" align="right">Amount</td>
                            </tr>
                            <cfloop query="qGetRepPayments">
                            	<tr>
                                	<td>#DateFormat(date,'mm/dd/yyyy')#</td>
                                    <td>#studentName# (###studentID#)</td>
                                    <td>#type#</td>
                                    <td align="right">#LSCurrencyFormat(amount, 'local')#</td>
                                </tr>
                            </cfloop>
                            <tr>
                            	<td colspan="2">&nbsp;</td>
                                <td colspan="2" align="right">
                                	<b>
                                    	<cfif NOT VAL(URL.printPage)>
                                        	<input type="checkbox" name="payRep" value="#agentID#" />
                                      	</cfif>
                                        Pay Representative #DollarFormat(total)#
                               		</b>
                           		</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </cfloop>
            
            <tr>
            	<td colspan="2" align="right" style="border-top:thin solid black; font-size:14px;">
                	<b>
                    	Total: #DollarFormat(qGetTotalPayment.total)#
                 	</b>
             	</td>
            </tr>
            
            <cfif NOT VAL(URL.printPage)>
                <tr>
                    <td colspan="2" style="text-align:center;">
                    	<input type="submit" value="Update" />
                    	<input type="button" value="Print" onclick="window.location = 'userPayment/_payReps.cfm?printPage=1';" />
                 	</td>
                </tr>
          	</cfif>
        
        </table>
        
  	</form>
    
</cfoutput>