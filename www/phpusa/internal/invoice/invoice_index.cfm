<!--- Kill extra output --->
<cfsilent>

	<cfsetting requesttimeout="300">

    <cfquery name="qGetIntlReps" datasource="MySql">
        SELECT 
        	u.userID,
        	u.businessname	
        FROM 
        	smg_users u
        INNER JOIN 
        	smg_students s ON s.intrep = u.userID
        INNER JOIN 
        	php_students_in_program php ON php.studentID = s.studentID
        WHERE 
        	php.companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
        GROUP BY 
        	u.userID
        ORDER BY 
        	u.businessname, familylastname
    </cfquery>
    
    <cfquery name="qGetStudents" datasource="MySql">
        SELECT
        	s.studentID, 
            s.firstname, 
            s.familylastname, 
            php.programID, 
            php.school_acceptance,
            u.accepts_sevis_fee, 
            u.businessname,
            p.programname,
            programtype.programtypeid,
            php.assignedid, 
            php_schools.tuition_semester, 
            php_schools.tuition_year
        FROM 
        	php_students_in_program php
        INNER JOIN 
        	smg_students s ON php.studentID = s.studentID
        INNER JOIN 
        	smg_users u ON  u.userID = s.intrep
        LEFT JOIN 
        	smg_programs p ON p.programID = php.programID
        LEFT JOIN 
        	php_schools ON php_schools.schoolid = php.schoolid
        LEFT JOIN 
        	smg_program_type programtype ON programtype.programtypeid = p.type
        WHERE 
        	php.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        AND 
        	php.active =  <cfqueryparam cfsqltype="cf_sql_integer" value="1">
       <!---- AND 
        	p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
       ---->
	    ORDER BY 
        	u.businessname, 
            familylastname
    </cfquery>

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Invoicing</title>
</head>

<style type="text/css">
<!--
div.scroll {
	height: 220px;
	width:auto;
	overflow:auto;
	left:auto;
}

div.scrollAgent {
	height: 160px;
	width:auto;
	overflow:auto;
	left:auto;
}
</style>

<body>

<br />

<cfoutput>

<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr>
		<td width="100%" valign="top">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tr><td colspan="2" bgcolor="##C2D1EF"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"> <b>Finance Reports & Tools</b></td></tr>
				<tr>
					<td width="50%" valign="top"><u>:: Tools</u>
						<table border="0" cellpadding="3" cellspacing="0" width="100%">
							<tr>
								<td width="50%"><a href="?curdoc=invoice/receive_payment">Receive Payment</a></td>
								<td width="50%"><a href="?curdoc=invoice/school_tuition">School Tuition Fee List</a></td>
							</tr>
							<tr>
								<td width="50%"><a href="?curdoc=invoice/intl_rep_insurance">Intl. Rep. Insurance Type</a></td>
								<td width="50%"><a href="?curdoc=invoice/insurance_prices">Insurance Policy Prices</a></td>
							</tr>							
						</table>
					</td>
					<td width="50%" valign="top"><u>:: Reports</u>
						<table border="0" cellpadding="3" cellspacing="0" width="100%">
							<tr>
								<td width="50%">Account Statement</td>
								<td width="50%"><a href="?curdoc=invoice/m_balance_report">Balance Report</a></td>
							</tr>
						</table>
					</td>					
				</tr>				
			</table>
		</td>
	</tr>
</table>

<br />

<!--- INTERNATIONAL AGENT LIST --->
<table  width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr><td bgcolor="##C2D1EF"><b>International Agents &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; Total of #qGetIntlReps.recordcount# agent(s)</b></td></tr>
	<tr>
		<td width="100%">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">				
				<tr>
					<td width="38%"><b>Intl. Agent</b></td>
					<td width="20%" align="right"><b>Total Invoiced</b></td>
					<td width="20%" align="right"><b>Received</b></td>
					<td width="20%" align="right"><b>Outstanding</b></td>
					<td width="2%">&nbsp;</td>
				</tr>
			</table>			
			<div class="scrollAgent">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">				
			
            <cfloop query="qGetIntlReps">

				<cfquery name="qIntRepTotalInvoiced" datasource="MySql">
					SELECT 
                    	SUM(ec.amount) as amount
					FROM 
                    	egom_charges ec
					INNER JOIN 
                    	egom_invoice ON egom_invoice.invoiceid = ec.invoiceid
                    INNER JOIN
                    	smg_students s ON ec.studentID = s.studentID
					WHERE 
                    	s.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetIntlReps.userID#">
				</cfquery>
					
				<cfquery name="qIntRepTotalReceived" datasource="MySql">
					SELECT 
                    	SUM(epc.amount_paid) as amount_paid
					FROM 
                    	egom_payment_charges epc
					INNER JOIN 
                    	egom_payments ep ON ep.paymentid = epc.paymentid
                    INNER JOIN	
                    	egom_charges ec ON ec.chargeID = epc.chargeID
                    INNER JOIN	
                    	smg_students s ON ec.studentID = s.studentID
					WHERE
                    	s.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetIntlReps.userID#">
				</cfquery>			
                
                <cfscript>
					// Calculate outstanding balance
					outstanding = VAL(qIntRepTotalInvoiced.amount) - VAL(qIntRepTotalReceived.amount_paid);
				</cfscript>
			
				<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
					<td width="38%"><a href="?curdoc=invoice/account_details&intrep=#userID#">#businessname#</a></td>
					<td width="20%" align="right">#LSCurrencyFormat(VAL(qIntRepTotalInvoiced.amount))#</td>
					<td width="20%" align="right">#LSCurrencyFormat(VAL(qIntRepTotalReceived.amount_paid))#</td>
					<td width="20%" align="right">#LSCurrencyFormat(outstanding)#</td>
					<td width="1%">&nbsp;</td>
				</tr>
                
			</cfloop>
			
            </table>
			</div>
		</td>
	</tr>
</table>
<br />

<!--- STUDENTS LIST --->
<table  width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr><td bgcolor="##C2D1EF"><b>Students &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Total of #qGetStudents.recordcount# student(s)</b></td></tr>
	<tr>
		<td width="100%">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">				
				<tr>
					<td width="24%"><b>Intl. Agent</b></td>
					<td width="24%"><b>Student</b></td>
					<td width="10%"><b>Program</b></td>
					<td width="10%" align="right"><b>School Tuition</b></td>
					<td width="10%" align="right"><b>Total Invoiced</b></td>
					<td width="10%" align="right"><b>Received</b></td>
					<td width="10%" align="right"><b>Outstanding</b></td>
					<td width="2%">&nbsp;</td>
				</tr>
			</table>			
			<div class="scroll">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">				
			<cfloop query="qGetStudents">
				
                <cfquery name="qStuTotalInvoiced" datasource="MySql">
					SELECT 
                    	SUM(amount) as amount
					FROM 
                    	egom_charges
					WHERE 
                    	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentID#"> 
					AND 
                    	programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#programID#"> 
				</cfquery>
                								
				<cfquery name="qStuTotalReceived" datasource="MySql">
					SELECT 
                    	SUM(amount_paid) as amount_paid
					FROM 
                    	egom_payment_charges
					INNER JOIN 
                    	egom_charges ON egom_charges.chargeid = egom_payment_charges.chargeid
					WHERE 
                    	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentID#"> 
					AND 
                    	programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#programID#">
				</cfquery>			
                
                <cfscript>
					// Calcuate Balance
					balance_due = VAL(qStuTotalInvoiced.amount) - VAL(qStuTotalReceived.amount_paid);
					
					// Set Tuition Semester/Year
					if ( ListFind("1,2", programtypeid) ) {
						school_tuition = tuition_year;
					} else if ( ListFind("3,4", programtypeid) ) {
						school_tuition = tuition_semester;
					} else {
						school_tuition = 0;
					}							
				</cfscript>

				<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
					<td width="24%"><a href="?curdoc=invoice/create_student_invoice&studentID=#studentID#&assignedid=#assignedid#">#businessname#</a></td>
					<td width="24%"><a href="?curdoc=invoice/create_student_invoice&studentID=#studentID#&assignedid=#assignedid#">#firstname# #familylastname# (###studentID#)</a> <cfif school_acceptance NEQ ''>*Accepted*</cfif></td>
					
					<cfif NOT VAL(programID)>
                        <td align="center" bgcolor="##FFCCFF">Program Missing</td>
                    <cfelse>
                        <td width="10%">#programname#</td>
                    </cfif>
					
					<cfif NOT LEN(school_tuition)>
                        <td align="center" bgcolor="##9999FF">Tuition Missing</td>
                   	<cfelse>
                    	<td width="10%" align="right">#LSCurrencyFOrmat(school_tuition, 'local')#</td>                    
                    </cfif>
                    
                    <td width="10%" align="right">#LSCurrencyFormat(VAL(qStuTotalInvoiced.amount))#</td>
                    <td width="10%" align="right">#LSCurrencyFormat(VAL(qStuTotalReceived.amount_paid))#</td>
                    <td width="10%" align="right">#LSCurrencyFOrmat(balance_Due)#</td>
                    <td width="1%">&nbsp;</td>
                    
				</tr>
			</cfloop>
			</table>
			</div>
		</td>
	</tr>
</table><br />

</cfoutput>
</body>
</html>