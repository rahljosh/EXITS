<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param Variables --->
    <cfparam name="studentID" type="numeric" default="0">
    <cfparam name="assignedID" type="numeric" default="0">

    <cfquery name="qGetStudentInfo" datasource="MySql">
        SELECT 
        	s.studentID, s.firstname, s.familylastname, s.intrep,
            u.businessname, u.accepts_sevis_fee, u.php_insurance_typeid, u.php_contact_email, u.email, u.php_billing_email,
            insu.type, insu.ayp5, insu.ayp10, insu.ayp12,
            p.programname,
            php.assignedID, php.programid, php.active, php.return_student,
            php_schools.schoolname, php_schools.nonref_deposit, php_schools.tuition_semester, 
            php_schools.tuition_year, php_schools.boarding_school,	php.programid, 
            programtype.programtypeid, programtype.programtype,
            IFNULL(alp.name, 'n/a') AS PHPReturnOption
        FROM 
        	php_students_in_program php
        INNER JOIN 
        	smg_students s ON s.studentID = php.studentID
        INNER JOIN 
        	smg_users u ON  u.userid = s.intrep
        INNER JOIN 
        	smg_programs p ON p.programid = php.programid
        LEFT JOIN 
        	php_schools ON php_schools.schoolid = php.schoolid
        LEFT JOIN 
        	smg_program_type programtype ON programtype.programtypeid = p.type
        LEFT JOIN 
        	smg_insurance_type insu ON insu.insutypeid = u.php_insurance_typeid
        LEFT OUTER JOIN
        	 applicationlookup alp ON alp.fieldID = php.return_student
            	 AND
                 	fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="PHPReturnOptions">            
        WHERE 
        	php.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentID#">
        AND 
        	php.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#assignedID#">
    </cfquery>
       
    <!--- CHECK IF STUDENT IS ASSIGNED TO MORE THAN ON PROGRAM --->
    <cfquery name="get_programs_assigned" datasource="MySql">
        SELECT
        	php_stu.assignedID, php_stu.programid, php_stu.active, p.programname, sum(egom_charges.amount) as amount
        FROM 
        	php_students_in_program php_stu
        INNER JOIN 
        	smg_programs p ON p.programid = php_stu.programid
        LEFT JOIN 
        	egom_charges ON (php_stu.studentID = egom_charges.studentID AND php_stu.programid = egom_charges.programid)
        WHERE 
        	php_stu.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentID#">
        GROUP BY 
        	php_stu.assignedID
        ORDER BY 
        	php_stu.assignedID DESC
    </cfquery>
    
    <cfquery name="get_other_charges" datasource="MySql">
        SELECT 
        	chargetypeid, charge
        FROM 
        	egom_charges_type
        WHERE 
        	type = 'other'
        AND 
        	(	
            	systemid = '0' 
            OR 
            	systemid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            )	 
    </cfquery>
    
    <body>
    
    <cfset extend_fee = 500.00>
    
    <!--- SCHOOL TUITION --->
    <cfif qGetStudentInfo.programtypeid EQ 1 OR qGetStudentInfo.programtypeid EQ 2>
        <cfset school_tuition = qGetStudentInfo.tuition_year>
    <!--- EXTENDING STUDENTS  = YEAR PRICE - SEMESTER + 500.00 fee --->
    <cfelseif qGetStudentInfo.return_student EQ 2 AND (qGetStudentInfo.programtypeid EQ 3 OR qGetStudentInfo.programtypeid EQ 4)>
        <cfset school_tuition = NumberFormat((qGetStudentInfo.tuition_year - qGetStudentInfo.tuition_semester) + extend_fee, "0.00")>
    <cfelseif qGetStudentInfo.programtypeid EQ 3 OR qGetStudentInfo.programtypeid EQ 4>
        <cfset school_tuition = qGetStudentInfo.tuition_semester>
    <cfelse>
        <cfset school_tuition = ''>
    </cfif>
    
    <!--- INSURANCE CHARGE --->
    <cfif qGetStudentInfo.programtypeid EQ 1>
        <cfset setInsuranceCharge = qGetStudentInfo.ayp10>
    <cfelseif qGetStudentInfo.programtypeid EQ 2>
        <cfset setInsuranceCharge = qGetStudentInfo.ayp12>
    <cfelseif qGetStudentInfo.programtypeid EQ 3 OR qGetStudentInfo.programtypeid EQ 4>
        <cfset setInsuranceCharge = qGetStudentInfo.ayp5>
    <cfelse>
        <cfset setInsuranceCharge = ''>
    </cfif>
    
</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Create Charges for Student</title>

<script>
// -->
// opens letters in a defined format
function OpenInvoice(URL) {
	newwindow=window.open(URL, 'Invoice', 'height=580, width=790, location=no, scrollbars=yes, menubar=yes, toolbars=yes, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}

function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}
//-->
</script> 

</head>

<br /><br />

<cfoutput query="qGetStudentInfo">

<cfif get_programs_assigned.recordcount GT 1>
    <table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
        <tr>
            <td width="100%" valign="top">
                <table border="0" cellpadding="3" cellspacing="0" width="100%" align="center">	
					<tr><th bgcolor="##C2D1EF">PROGRAMS</th></tr>
					<form name="form" id="form">
                    <tr><td align="center">
                        This student is assigned to more than one program. Currently showing 
                        <select name="jumpMenu" id="jumpMenu" onChange="MM_jumpMenu('parent',this,0)">
                        <cfloop query="get_programs_assigned">
                            <option value="?curdoc=invoice/create_student_invoice&studentID=#studentID#&assignedID=#assignedID#" <cfif qGetStudentInfo.programid EQ programid>selected</cfif>>#programname#</option>
                        </cfloop>
                        </select> program.
                    </td></tr>
	                </form>
                </table>
                <table border="0" cellpadding="3" cellspacing="0" width="100%" align="center">	
                    <tr>
                        <td colspan="3" bgcolor="##C2D1EF"><b>Total Previously Invoiced</b></td>
                    </tr>							
                    <tr>	
                        <td><b>Program</b></td>
                        <td><b>Active</b></td>
                        <td><b>Amount</b></td>
                    </tr>
                    <cfset grand_total = 0>
					<cfloop query="get_programs_assigned">
	                    <cfset grand_total = grand_total + val(amount)>
                    <tr>
                        <td>#programname#</td>
                        <td>#yesNoFormat(active)#</td>
                        <td>#LSCurrencyFormat(amount, 'local')#</td>
                    </tr>							
					</cfloop>
                    <tr bgcolor="##C2D1EF">
                        <td colspan="2"><b>Grand Total Previously Invoiced</b></td>
                        <td><b>#LSCurrencyFormat(grand_total, 'local')#</b></td>
                    </tr>							
                </table>
            </td>
        </tr>
    </table><br />
</cfif>

<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr>
		<td width="100%" valign="top">
			<table border="0" cellpadding="3" cellspacing="0" width="100%" align="center">
				<tr><th colspan="2" bgcolor="##C2D1EF">CREATE INVOICE</th></tr>
				<tr><td valign="top">	
						<cfform name="invoice" action="?curdoc=invoice/create_student_invoice_qr" method="post">
						<!--- HIDDEN FIELDS --->
						<cfinput type="hidden" name="studentID" value="#studentID#">
						<cfinput type="hidden" name="assignedID" value="#assignedID#">
						<cfinput type="hidden" name="intrepid" value="#intrep#">
						<cfinput type="hidden" name="programid" value="#programid#">
						<!--- CHARGES TYPE ID--->
						<cfinput type="hidden" name="deposit_id" value="1">
						<cfinput type="hidden" name="school_tuition_id" value="3">
						<cfinput type="hidden" name="insurance_id" value="4">
						<cfinput type="hidden" name="sevis_fee_id" value="6">
						<cfinput type="hidden" name="cancelation_id" value="7">
						<table border="0" cellpadding="3" cellspacing="0" width="100%">
							<tr>
								<td><b>Intl. Agent</b></td>
								<td><b>Student</b></td>
								<td><b>Program</b></td>
								<td><b>Program Type</b></td>
								<td><b>School</b></td>
								<td><b>Day/Board</b></td>
								<td><b>Status</b></td>
							</tr>
							<tr>
								<td>#businessname# (###intrep#)</td>
								<td>#firstname# #familylastname# (###studentID#)</td>
								<td>#programname#</td>
								<td>#programtype#</td>
								<td>#schoolname#</td>
								<td>
									<cfif boarding_school EQ 0>Day
										<cfelseif boarding_school EQ 1>Board
										<cfelseif boarding_school EQ 2>Day/Board
										<cfelseif boarding_school EQ 3>n/a
									</cfif>
								</td>
								<td>#qGetStudentInfo.PHPReturnOption#</td>
							</tr>
						</table><br />							
						<table border="0" cellpadding="3" cellspacing="0" width="100%">
							<tr><td colspan="4" bgcolor="##C2D1EF"><b>New Charges</b></td></tr>
							<tr>
								<td width="12%"><b>Include Charge</b></td>
								<td width="48%"><b>Charge Type</b></td>
								<td width="15%"><b>Amount US$</b></td>
								<td width="25%"><b>Description</b></td>
							</tr>					
							
							<!--- DEPOSIT FEE --->
							<cfquery name="deposit_charges" datasource="MySql">
								SELECT invoiceid, amount, date, description
								FROM egom_charges
								WHERE studentID = '#studentID#' 
                                AND programid = '#programid#'
                                AND chargetypeid = '1'
							</cfquery>
							<cfif deposit_charges.recordcount EQ 0>
							<tr>	
								<td align="center"><cfinput type="checkbox" name="deposit_ckbox"></td>
								<td>Deposit Fee</td>
								<td><cfinput type="text" name="deposit" value="" size="8"></td>
								<td><cfinput type="text" name="deposit_desc" value="Deposit Fee" size="24"></td>
							</tr>
							</cfif>
							
							<!--- SCHOOL TUITION --->
							<cfquery name="tuition_charges" datasource="MySql">
								SELECT invoiceid, amount, date, description
								FROM egom_charges
								WHERE studentID = '#studentID#' 
                                AND programid = '#programid#'
                                AND chargetypeid = '3'
							</cfquery>
							<cfif tuition_charges.recordcount EQ 0>
							<tr>
								<td align="center"><cfinput type="checkbox" name="school_tuition_ckbox"></td>
								<td>
									School Tuition 
									<cfif return_student EQ 2 AND (programtypeid EQ 3 OR programtypeid EQ 4)>
										&nbsp; (Year #LSCurrencyFormat(tuition_year,'local')# - Sem. #LSCurrencyFormat(tuition_semester,'local')# + Ext. Fee #LSCurrencyFormat(extend_fee,'local')#)
									</cfif>
								</td>
								<td><cfinput type="text" name="school_tuition" value="#school_tuition#" size="8"></td>
								<td><cfinput type="text" name="school_tuition_desc" value="School Tuition" size="24"></td>
							</tr>
							</cfif>
							
							<!--- INSURANCE FEE --->
							<cfquery name="insurance_charges" datasource="MySql">
								SELECT invoiceid, amount, date, description
								FROM egom_charges
								WHERE studentID = '#studentID#' 
                                AND programid = '#programid#'
                                AND chargetypeid = '4'
							</cfquery>
							<cfif insurance_charges.recordcount EQ 0>
							<tr>
								<!--- INSURANCE INFO MISSING --->
								<cfif php_insurance_typeid EQ 0>
								<td align="center"><cfinput type="checkbox" name="insurance_ckbox" disabled></td>
								<td colspan="3">Insurance Policy Type is Missing</td>
								<!--- DOES NOT TAKE INSURANCE --->
								<cfelseif php_insurance_typeid EQ 1>
								<td align="center"><cfinput type="checkbox" name="insurance_ckbox" disabled></td>
								<td colspan="3">#businessname# does not take insurance provided by PHP</td>								
								<cfelse>
								<td align="center"><cfinput type="checkbox" name="insurance_ckbox"></td>
								<td>Insurance #type# Policy</td>
								<td><cfinput type="text" name="insurance" size="8" value="#setInsuranceCharge#"></td>
								<td><cfinput type="text" name="insurance_desc" value="Insurance #type# Policy" size="24"></td>
								</cfif>
							</tr>
							</cfif>	
							
							<!--- CANCELATION FEE --->
							<cfif qGetStudentInfo.active EQ 0>
								<cfquery name="cancelation_charges" datasource="MySql">
									SELECT invoiceid, amount, date, description
									FROM egom_charges
									WHERE studentID = '#studentID#' 
                                    AND programid = '#programid#'
                                    AND chargetypeid = '7'
								</cfquery>
								<cfif cancelation_charges.recordcount EQ 0>
								<tr>
									<td align="center"><cfinput type="checkbox" name="cancelation_ckbox"></td>
									<td>Cancelation Fee <b>(Student is currently inactive)</b></td>
									<td><cfinput type="text" name="cancelation" value="500.00" size="8"></td>
									<td><cfinput type="text" name="cancelation_desc" value="Cancelation Fee" size="24"></td>
								</tr>
								</cfif>
							</cfif>
							
							<!--- SEVIS FEE --->
							<cfquery name="sevis_charges" datasource="MySql">
								SELECT invoiceid, amount, date, description
								FROM egom_charges
								WHERE studentID = '#studentID#' 
                                AND programid = '#programid#'
                                AND chargetypeid = '6'
							</cfquery>							
							<cfif sevis_charges.recordcount EQ 0>
							<tr>
								<!--- DOES NOT ACCEPT SEVIS FEE --->							
								<cfif accepts_sevis_fee EQ 0>
									<td align="center"><cfinput type="checkbox" name="sevis_fee_ckbox"></td>
									<td>SEVIS Fee (#businessname# does not accept SEVIS FEE)</td>
									<td><cfinput type="text" name="sevis_fee" size="8" value="200.00"></td>
									<td><cfinput type="text" name="sevis_fee_desc" value="SEVIS Fee" size="24"></td>																	
								<cfelse>
									<td align="center"><cfinput type="checkbox" name="sevis_fee_ckbox"></td>
									<td>SEVIS Fee</td>
									<td><cfinput type="text" name="sevis_fee" size="8" value="200.00"></td>
									<td><cfinput type="text" name="sevis_fee_desc" value="SEVIS Fee" size="24"></td>
								</cfif>
							</tr>
							</cfif>
							
							<!--- OTHER CHARGES --->
							<tr>
								<td align="center"><cfinput type="checkbox" name="other_charges_ckbox"></td>
								<td>Other Charges &nbsp; 
									<cfselect name="other_charges_id">
										<option value="0"></option>
										<cfloop query="get_other_charges">
											<option value="#chargetypeid#">#charge#</option>
										</cfloop>
									</cfselect>
								</td>
								<td><cfinput type="text" name="other_charges" size="8"></td>
								<td><cfinput type="text" name="other_charges_desc" value="" size="24"></td>
							</tr>					
							
							<tr><td colspan="4">* Only boxes that are checked will be included in this invoice.</td></tr>							
							
							<!--- ADD CHARGES TO AN EXISTING INVOICE --->
							<cfquery name="get_invoices" datasource="MySql">
								SELECT egom_charges.invoiceid, sum(amount) as total_invoice 
								FROM egom_charges
								WHERE studentID = '#studentID#'
									AND programid = '#programid#'
									AND canceled = '0'
								GROUP BY invoiceid							
								ORDER BY invoiceid
							</cfquery>
							<cfif get_invoices.recordcount>
								<tr><td colspan="4"><b>Would you like to create charges in a existing invoice? If yes, please select one invoice below:</b></td></tr>
								<tr>
									<td colspan="4">
										<table border="0" cellpadding="0" cellspacing="0" width="100%">
											<tr>
												<cfloop query="get_invoices">
													<td><cfinput type="radio" name="invoiceid" value="#invoiceid#">&nbsp; Invoice: ###invoiceid# - #LSCurrencyFormat(total_invoice, 'local')#</td>
													<cfif get_invoices.currentrow MOD 4 EQ 0></tr><tr></tr></cfif>
												</cfloop>
											
										</table>
									</td>
								</tr>
							</cfif>
						</table><br />	
						
						<!--- STANDARD CHARGES HISTORY --->							
						<table border="0" cellpadding="3" cellspacing="0" width="100%">
							<tr><td colspan="6" bgcolor="##C2D1EF"><b>Standard Charges</b></td></tr>
							<tr>	
								<td><b>Date</b></td>
								<td><b>Invoice</b></td>
								<td><b>Description</b></td>
								<td><b>Amount</b></td>
								<td><b>Received</b></td>
								<td><b>Running Total</b></td>							
							</tr>			
							<cfquery name="standard_charges" datasource="MySql">
								SELECT egom_charges.invoiceid, egom_charges.chargeid, programid, studentID, amount, description, canceled, egom_charges.full_paid, 
									egom_charges.date,  
									type.charge, type.type,
									egom_invoice.uniqueid
								FROM egom_charges
								INNER JOIN egom_charges_type type ON type.chargetypeid = egom_charges.chargetypeid
								LEFT JOIN egom_invoice ON egom_invoice.invoiceid = egom_charges.invoiceid
								WHERE studentID = '#studentID#'
                                AND type != 'other'
                                AND programid = '#programid#'
								ORDER BY invoiceid, canceled, chargeid
							</cfquery>	
							<cfset balance = 0>																		
							<cfloop query="standard_charges">
								<cfquery name="check_partial" datasource="mysql">
									SELECT sum(amount_paid) as amount_paid 
									FROM egom_payment_charges
									WHERE chargeid = #chargeid#
								</cfquery>
								<cfif check_partial.amount_paid is ''>
									<cfset check_partial.amount_paid = 0>
								</cfif>							
								<tr>
									<td>#DateFormat(date, 'mm/dd/yy')#</td>
									<td><a href="javascript:OpenInvoice('invoice/view_invoice.cfm?i=#uniqueid#')">Invoice ###invoiceid#</a> &nbsp; 
										<a href="javascript:OpenInvoice('invoice/view_invoice_email.cfm?i=#uniqueid#');" onClick="return confirm ('Invoice ###invoiceid# will be sent to #qGetStudentInfo.businessname# at #qGetStudentInfo.php_billing_email#. Click OK to continue.');"><img src="pics/email.gif" border="0" alt="Email Invoice ###invoiceid# to #qGetStudentInfo.businessname#."></a>
									</td>
									<td><cfif canceled EQ 1><font color="##FF0000">#description#</font><cfelse>#description#</cfif></td>
									<td><!---<cfif canceled EQ 1><span class="strike"></cfif>--->#LSCurrencyFormat(amount, 'local')#</td>
									<td>#LSCurrencyFormat(check_partial.amount_paid,'local')#</td>
									<td><cfif full_paid NEQ 1 AND canceled NEQ 1><cfset balance = balance + amount - check_partial.amount_paid></cfif>#LSCurrencyFormat(balance,'local')#</td>
								</tr>
							</cfloop>
							
							<!--- MISCELANEOUS CHARGES --->
							<tr><td colspan="6" bgcolor="##C2D1EF"><b>Miscelaneous Charges</b></td></tr>
							<cfquery name="other_charges" datasource="MySql">
								SELECT egom_charges.invoiceid, egom_charges.chargeid, amount, egom_charges.date, description, canceled, egom_charges.full_paid,  
									type.charge,
									egom_invoice.uniqueid
								FROM egom_charges
								INNER JOIN egom_charges_type type ON type.chargetypeid = egom_charges.chargetypeid
								LEFT JOIN egom_invoice ON egom_invoice.invoiceid = egom_charges.invoiceid
								WHERE studentID = '#studentID#'
                                AND programid = '#programid#'
                                AND type = 'other'
							</cfquery>							
							<cfloop query="other_charges">
								<cfquery name="check_partial" datasource="mysql">
									SELECT sum(amount_paid) as amount_paid 
									FROM egom_payment_charges
									WHERE chargeid = #chargeid#
								</cfquery>
								<cfif check_partial.amount_paid is ''>
									<cfset check_partial.amount_paid = 0>
								</cfif>							
								<tr>
									<td>#DateFormat(date, 'mm/dd/yy')#</td>
									<td><a href="javascript:OpenInvoice('invoice/view_invoice.cfm?i=#uniqueid#')">Invoice ###invoiceid#</a> &nbsp; 
										<a href="javascript:OpenInvoice('invoice/view_invoice_email.cfm?i=#uniqueid#');" onClick="return confirm ('Invoice ###invoiceid# will be sent to #qGetStudentInfo.businessname# at #qGetStudentInfo.email#. Click OK to continue.');"><img src="pics/email.gif" border="0" alt="Email Invoice ###invoiceid# to #qGetStudentInfo.businessname#."></a>
									</td>
									<td><cfif canceled EQ 1><font color="##FF0000">Canceled &nbsp; </font></cfif>#description#</td>
									<td><cfif canceled EQ 1><span class="strike"></cfif>#LSCurrencyFormat(amount, 'local')#</td>
									<td>#LSCurrencyFormat(check_partial.amount_paid,'local')#</td>
									<td><cfif full_paid NEQ 1 AND canceled NEQ 1><cfset balance = balance + amount - check_partial.amount_paid></cfif>#LSCurrencyFormat(balance,'local')#</td>
								</tr>
							</cfloop>
							
							<tr><td colspan="6">&nbsp;</td></tr>
							
							<!--- TOTAL INVOICED --->							
							<cfquery name="total_invoiced" datasource="MySql">
								SELECT sum(amount) as amount
								FROM egom_charges
								WHERE studentID = '#studentID#'
								AND programid = '#programid#'
							</cfquery>								
							<tr>
								<td colspan="5" bgcolor="##C2D1EF"><b>Total Previously Invoiced</b></td>
								<td bgcolor="##C2D1EF"><b>#LSCurrencyFormat(total_invoiced.amount, 'local')#</b></td>
							</tr>							
							<tr><td colspan="6">&nbsp;</td></tr>			
							<tr bgcolor="##C2D1EF"><th colspan="6">
                            	<a href="?curdoc=invoice/invoice_index"><img src="pics/back.gif" border="0" /></a>
                                    &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;
                                    <cfinput type="image" name="next" value=" Submit " src="pics/submit.gif" submitOnce>
                            </th></tr>
							</cfform>
						</table>
					</td>
				</tr>				
			</table>
		</td>
	</tr>
</table><br />

<!--- EDIT / CANCEL CHARGES --->
<cfquery name="get_charges" datasource="MySql">
	SELECT 
		egom_charges.invoiceid, egom_charges.chargeid, programid, studentID, amount, 
		egom_charges.date, description, egom_charges.full_paid, egom_charges.canceled,
		type.charge,
		egom_invoice.uniqueid
	FROM 
		egom_charges
	INNER JOIN 
		egom_charges_type type ON type.chargetypeid = egom_charges.chargetypeid
	LEFT JOIN 
		egom_invoice ON egom_invoice.invoiceid = egom_charges.invoiceid
	WHERE 
		studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentID#">
	AND 
		programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#programid#">
	AND 
		egom_charges.chargetypeid !=  <cfqueryparam cfsqltype="cf_sql_integer" value="13"> <!--- cancelation --->
	ORDER BY 
		invoiceid, chargeid
</cfquery>	

<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr>
		<td width="100%" valign="top">
			<table border="0" cellpadding="3" cellspacing="0" width="100%" align="center">		
				<!--- EDIT CHARGES --->														
				<cfform name="edit_invoice" action="?curdoc=invoice/qr_edit_invoice" method="post">
				<tr bgcolor="##C2D1EF"><th colspan="4"><b>EDIT CHARGES</b></th></tr>
				<tr>
					<td width="12%"><b>Include Charge</b></td>
					<td width="48%"><b>Charge Type</b></td>
					<td width="15%"><b>Amount US$</b></td>
					<td width="25%"><b>Description</b></td>
				</tr>
				<cfinput type="hidden" name="total_editbox" value="#get_charges.recordcount#">
				<cfinput type="hidden" name="studentID" value="#studentID#">
                <cfinput type="hidden" name="assignedID" value="#assignedID#">
				
				<cfloop query="get_charges">
					<cfinput type="hidden" name="chargeid#currentrow#" value="#chargeid#">						
					<cfif full_paid EQ 0 AND canceled NEQ 1>
						<cfinput type="hidden" name="previous_tuition#currentrow#" value="#amount#">
						<tr>
							<td align="center"><cfinput type="checkbox" name="edit_box#currentrow#"></td>
							<td>#charge# on invoice ###invoiceid#</td>
							<td><cfinput type="text" name="edit_tuition#currentrow#" value="#amount#" size="8"></td>
							<td><cfinput type="text" name="edit_desc#currentrow#" value="#description#" size="24"></td>
						</tr>
					</cfif>	
				</cfloop>
				<tr bgcolor="##C2D1EF"><th colspan="5">
                	<a href="?curdoc=invoice/invoice_index"><img src="pics/back.gif" border="0" /></a>
                    &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;
                    <cfinput type="image" name="next" value=" Submit " src="pics/submit.gif" submitOnce>
                </th></tr>
				</cfform>	
			</table>
		</td>
	</tr>
</table><br />

<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr>
		<td width="100%" valign="top">
			<table border="0" cellpadding="3" cellspacing="0" width="100%" align="center">
				<!--- CANCEL UNPAID CHARGE --->
				<cfform name="cancel_invoice" action="?curdoc=invoice/qr_cancel_unpaid_invoice" method="post">
				<tr bgcolor="##C2D1EF"><th colspan="4"><b>CANCEL UNPAID CHARGES</b></th></tr>
				<tr>
					<td width="12%"><b>Include Charge</b></td>
					<td width="48%"><b>Charge Type</b></td>
					<td width="15%"><b>Amount US$</b></td>
					<td width="25%"><b>Description</b></td>
				</tr>								
				<cfinput type="hidden" name="total_cancelbox" value="#get_charges.recordcount#">
				<cfinput type="hidden" name="studentID" value="#studentID#">
                <cfinput type="hidden" name="assignedID" value="#assignedID#">
				
				<cfloop query="get_charges">
					<cfinput type="hidden" name="chargeid#currentrow#" value="#chargeid#">						
					<cfquery name="total_received" datasource="MySql">
						SELECT sum(amount_paid) as amount_paid
						FROM egom_payment_charges
						INNER JOIN egom_charges ON egom_charges.chargeid = egom_payment_charges.chargeid
						WHERE egom_charges.chargeid = '#chargeid#'
					</cfquery>
					
					<cfif total_received.amount_paid EQ ''>
						<cfquery name="check_cancelation" datasource="MySql">
							SELECT chargeid, invoiceid, chargetypeid, studentID, programid, amount, description 
							FROM egom_charges
							WHERE chargetypeid = '13'
                            AND amount = '-#amount#'
                            AND invoiceid = '#invoiceid#'
                            AND programid = '#programid#'
						</cfquery>
						<cfif check_cancelation.recordcount EQ 0>
						<tr>
							<td align="center"><cfinput type="checkbox" name="cancel_box#currentrow#"></td>
							<td>Cancel #charge# on invoice ###invoiceid#</td>
							<td>(#LSCurrencyFormat(amount, 'local')#)</td>
							<td><cfinput type="text" name="cancel_reason#currentrow#" size="24" value="Cancelation #description#"></td>
						</tr>
						</cfif>
					</cfif>	
				</cfloop>
				<tr bgcolor="##C2D1EF"><th colspan="5">
                	<a href="?curdoc=invoice/invoice_index"><img src="pics/back.gif" border="0" /></a>
                    &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;
                    <cfinput type="image" name="next" value=" Submit " src="pics/submit.gif" submitOnce>
                </th></tr>
				</cfform>
			</table>
		</td>
	</tr>
</table><br />

</cfoutput>

</body>
</html>