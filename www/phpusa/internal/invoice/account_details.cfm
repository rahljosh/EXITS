<!--- Kill extra output --->
<cfsilent>
       
    <cfparam name="URL.intRep" default="0">
    <cfparam name="total_inv" default="0">
    <cfparam name="total_rec" default="0">
    <cfparam name="total_gen_inv" default="0">
    <cfparam name="total_gen_rec" default="0">
    
    <cfquery name="qGetAgent" datasource="MySql">
        SELECT 
        	userid, 
        	businessname
        FROM 
        	smg_users
        WHERE 
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.intRep#">
    </cfquery>
    
    <cfquery name="qGetStudents" datasource="MySql"> 
        SELECT 
            s.studentid, 
            s.firstname, 
            s.familylastname, 
            php.programid, 
            php.active, 
            php.canceldate,
            u.accepts_sevis_fee,
            p.programname,
            programtype.programTypeID,
            php.assignedid, 
            php_schools.tuition_semester, 
            php_schools.tuition_year
        FROM 
            php_students_in_program php
        INNER JOIN 
            smg_students s ON php.studentid = s.studentid
        INNER JOIN 
            smg_users u ON  u.userid = s.intRep
        LEFT JOIN 
            smg_programs p ON p.programid = php.programid
        LEFT JOIN 
            php_schools ON php_schools.schoolid = php.schoolid
        LEFT JOIN 
            smg_program_type programtype ON programtype.programTypeID = p.type
        WHERE 
            php.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        AND 
            s.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.intRep#">
        ORDER BY 
            p.programname, 
            familylastname
    </cfquery>

	<!--- GENERAL INVOICES --->
	<cfquery name="qGeneralInvoices" datasource="MySql">
		SELECT DISTINCT 
        	i.invoiceID, 
            i.uniqueid
		FROM 
        	egom_invoice i
		INNER JOIN 
        	egom_charges c ON c.invoiceID = i.invoiceID
		WHERE 
        	i.intrepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.intRep#">
		AND 
        	c.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
		GROUP BY 
        	i.invoiceID
	</cfquery>
    
</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Create Charges for Student</title>
</head>
<body>

<script>
// -->
// opens letters in a defined format
function OpenPaymentDetail(url) {
	newwindow=window.open(url, 'Invoice', 'height=350, width=700, location=no, scrollbars=yes, menubar=yes, toolbars=yes, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script> 

<cfoutput>

<br />
<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr><th colspan="2" bgcolor="##C2D1EF">#qGetAgent.businessname# - Account Details</th></tr>
	<tr>
		<td width="100%" valign="top">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tr>
					<td width="50%" valign="top"><u>:: Tools</u>
						<table border="0" cellpadding="3" cellspacing="0" width="100%">
							<tr>
								<td width="50%"><a href="?curdoc=invoice/create_general_invoice&intRep=#qGetAgent.userid#">General Invoice</a></td>
								<td width="50%"><a href="?curdoc=invoice/receive_payment&intRep=#qGetAgent.userid#">Receive Payment</a></td>
							</tr>	
							<tr>
								<td width="50%"><a href="?curdoc=invoice/payment_breakdown&intRep=#qGetAgent.userid#">Payment Break Down</a></td>
								<td width="50%"></td>
							</tr>																				
						</table>
					</td>
					<td width="50%" valign="top"><u>:: Reports</u>
						<table border="0" cellpadding="3" cellspacing="0" width="100%">
							<tr>
								<td width="50%">Account Statement</td>
								<td width="50%">Balance Report</td>
							</tr>
						</table>
					</td>
				</tr>				
			</table>
		</td>
	</tr>
</table>
<br />
<cfquery name="qCredits" datasource="#application.dsn#">
select *
from egom_credits
where intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.intRep#">
</cfquery>
<table  width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr><td bgcolor="##C2D1EF"><b>Credits</b></td></tr>
	<tr>
		<td width="100%">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">				
				<tr>
					<td width="38%"><b>Original Payment Ref</b></td>
					<td width="12%"><b>Date</b></td>
					<td width="12%"><b>Ammount</b></td>
		
				
				</tr>
                <cfif qCredits.recordcount eq 0>
                <tr>
                	<td align="Center" colspan=3>No Credits Available</td>
                 </tr>
                  <Cfset total_credits = 0>
                <cfelse>
                <Cfset total_credits = 0>
				<cfloop query="qCredits">
                <tr bgcolor="#iif(qCredits.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
                	<td width="38%"><b>#originalPayRef#</b></td>
					<td width="12%"><b>#DateFormat(date,'mm/dd/yy')#</b></td>
					<td width="12%"><b>#LSCurrencyFormat(amount, 'local')#</b></td>
                 </tr>
                 <cfset total_credits = #total_credits# + #amount#>
                 </cfloop>
                 </cfif>
                 </table>
                </td>
            </tr>
 		</table>
        <br />
<table  width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr><td bgcolor="##C2D1EF"><b>Students &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Total of #qGetStudents.recordcount# student(s)</b></td></tr>
	<tr>
		<td width="100%">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">				
				<tr>
					<td width="38%"><b>Student</b></td>
					<td width="12%"><b>Status</b></td>
					<td width="12%"><b>Program</b></td>
					<td width="12%" align="right"><b>Total Invoiced</b></td>
					<td width="12%" align="right"><b>Received</b></td>
					<td width="12%" align="right"><b>Outstanding</b></td>
					<td width="2%">&nbsp;</td>
				</tr>
				<cfloop query="qGetStudents">
                
					<cfquery name="qTotalInvoiced" datasource="MySql">
						SELECT 
                        	SUM(amount) as amount
						FROM 
                        	egom_charges
						WHERE 
                        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.studentid#">
                        AND 
                        	programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.programid#">
					</cfquery>
					
					<cfquery name="qTotalReceived" datasource="MySql">
						SELECT 
                        	SUM(amount_paid) as amount_paid
						FROM 
                        	egom_payment_charges
						INNER JOIN 
                        	egom_charges ON egom_charges.chargeid = egom_payment_charges.chargeid
						WHERE 
                        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.studentid#">
                        AND 
                        	programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.programid#">
					</cfquery>	
					
                    <cfscript>
						// set balance
						balance_due = VAL(qTotalInvoiced.amount) - VAL(qTotalReceived.amount_paid);
					
						// Set Tuition Semester/Year
						if ( ListFind("1,2", qGetStudents.programTypeID) ) {
							school_tuition = qGetStudents.tuition_year;
						} else if ( ListFind("3,4", qGetStudents.programTypeID) ) {
							school_tuition = qGetStudents.tuition_semester;
						} else {
							school_tuition = 0;
						}							
						
						// Calculate running total
						total_inv = total_inv + VAL(qTotalInvoiced.amount);
						total_rec = total_rec + VAL(qTotalReceived.amount_paid);
					</cfscript>

					<tr bgcolor="#iif(qGetStudents.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
						<td width="38%"><a href="?curdoc=invoice/create_student_invoice&studentid=#qGetStudents.studentid#&assignedid=#qGetStudents.assignedid#">#qGetStudents.firstname# #qGetStudents.familylastname# (###qGetStudents.studentid#)</a></td>				
						<cfif NOT VAL(qGetStudents.programid)>
							<td colspan="2" align="center" bgcolor="##FFCCFF">Student has not been assigned to a program.</td>
						<cfelseif NOT LEN(school_tuition)>
							<td colspan="2" align="center" bgcolor="##9999FF">Tuition for this school has not been recorded.</td>
						<cfelse>
							<td width="12%"><cfif LEN(qGetStudents.canceldate)>Canceled<cfelseif VAL(qGetStudents.active)>Active<cfelse>Inactive</cfif></td>
							<td width="12%">#qGetStudents.programname#</td>
						</cfif>
                        <td width="12%" align="right">#LSCurrencyFormat(VAL(qTotalInvoiced.amount))#</td>
                        <td width="12%" align="right"><a href="javascript:OpenPaymentDetail('invoice/payment_breakdown_student.cfm?studentid=#qGetStudents.studentid#&programid=#qGetStudents.programid#')">#LSCurrencyFormat(VAL(qTotalReceived.amount_paid))#</a></td>						
                        <td width="12%" align="right">#LSCurrencyFOrmat(balance_Due)#</td>
                        <td width="1%">&nbsp;</td>
					</tr>
				</cfloop>
                
				<!--- TOTALS --->
				<cfset total_out = total_inv - total_rec>
                
				<tr>
					<td colspan="3" align="right"><b>Sub-Total</b></td>
					<td align="right"><b>#LSCurrencyFormat(total_inv)#</b></td>
					<td align="right"><b>#LSCurrencyFormat(total_rec)#</b></td>
					<td align="right"><b>#LSCurrencyFormat(total_out)#</b></td>
				</tr>
                <tr>
					<td colspan="3" align="right"><b>Unapplied Credits</b></td>
					<td align="right"><b></b></td>
					<td align="right"><b>#LSCurrencyFormat(total_credits)#</b></td>
					<td align="right"></td>
				</tr>
                <tr>
					<td colspan="3" align="right"><b>Totals</b></td>
					<td align="right"><b>#LSCurrencyFormat(total_inv)#</b></td>
					<td align="right"><cfset gtotal_rec = #total_rec# + #total_credits#><b>#LSCurrencyFormat(gtotal_rec)#</b></td>
					<td align="right"><Cfset gtotalDue = #total_out# - #total_credits#><b>#LSCurrencyFormat(gTotalDue)#</b></td>
				</tr>
				<tr><td colspan="5">&nbsp;</td></tr>
			</table>
			</div>
		</td>
	</tr>
    
	<tr><td bgcolor="##C2D1EF"><b>General Invoices &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Total of #qGeneralInvoices.recordcount# invoice(s)</b></td></tr>	
	<tr>
		<td width="100%">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">				
				<tr>
					<td width="50%"><b>Invoice</b></td>
					<td width="12%"></td>
					<td width="12%" align="right"><b>Total Invoiced</b></td>
					<td width="12%" align="right"><b>Received</b></td>
					<td width="12%" align="right"><b>Outstanding</b></td>
					<td width="2%">&nbsp;</td>
				</tr>
				<cfloop query="qGeneralInvoices">
                
					<cfquery name="total_gen_invoiced" datasource="MySql">
						SELECT 
                        	SUM(amount) as amount
						FROM 
                        	egom_charges
						WHERE 
                        	invoiceID = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoiceID#">
					</cfquery>	
                    							
					<cfquery name="total_gen_received" datasource="MySql">
						SELECT 
                        	SUM(amount_paid) as amount_paid
						FROM
                        	egom_payment_charges
						INNER JOIN 
                        	egom_charges ON egom_charges.chargeid = egom_payment_charges.chargeid
						WHERE 
                        	invoiceID = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoiceID#">
					</cfquery>	
                    		
					<cfset balance_gen_due = VAL(total_gen_invoiced.amount) - VAL(total_gen_received.amount_paid)>
                    <cfset total_gen_inv = VAL(total_gen_inv) + VAL(total_gen_invoiced.amount)>
					<cfset total_gen_rec =  VAL(total_gen_rec) +  VAL(total_gen_received.amount_paid)>
                   
					<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
						<td><a href="?curdoc=invoice/create_general_invoice_view&i=#uniqueid#">###invoiceID#</a></td>				
						<td></td>
						<td align="right">#LSCurrencyFormat(VAL(total_gen_invoiced.amount))#</td>
						<td align="right">#LSCurrencyFormat(VAL(total_gen_received.amount_paid))#</td>
						<td align="right">#LSCurrencyFOrmat(VAL(balance_gen_due))#</td>
						<td>&nbsp;</td>
					</tr>
				</cfloop>
				<cfset total_gen_out = total_gen_inv - total_gen_rec>
				<tr>
					<td colspan="2" align="right"><b>Total</b></td>
					<td align="right"><b>#LSCurrencyFormat(total_gen_inv)#</b></td>
					<td align="right"><b>#LSCurrencyFormat(total_gen_rec)#</b></td>
					<td align="right"><b>#LSCurrencyFormat(total_gen_out)#</b></td>
				</tr>
				<tr><td colspan="5">&nbsp;</td></tr>				
			</table>			
		</td>
	</tr>
</table><br /><br />

</cfoutput>

</body>
</html>