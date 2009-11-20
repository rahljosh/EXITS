<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param Variables --->
    <cfparam name="FORM.studentID" type="numeric" default="0">
    <cfparam name="FORM.assignedID" type="numeric" default="0">
	<cfparam name="FORM.systemID" type="numeric" default="2">
    
</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Create Invoice</title>
</head>

<body>

<script>
// -->
// opens letters in a defined format
function OpenInvoice(url) {
	newwindow=window.open(url, 'Invoice', 'height=580, width=790, location=no, scrollbars=yes, menubar=yes, toolbars=yes, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script> 

<cfoutput>

<br /><br />

<cftransaction>

	<!--- AXIS SYSTEM --->
	<cfset FORM.systemid = 2>

	<!--- ADD CHARGES --->

	<!--- DEPOSIT FEE --->
	<cfquery name="deposit_charges" datasource="MySql">
		SELECT invoiceid
		FROM egom_charges
		WHERE studentid = '#FORM.studentid#'
			AND programid = '#FORM.programid#'
			AND chargetypeid = '#FORM.deposit_id#'
	</cfquery>
	<cfif IsDefined('FORM.deposit_ckbox') AND FORM.deposit NEQ '' AND deposit_charges.recordcount EQ '0'>
		<cfquery name="insert_charges" datasource="MySQL">
			INSERT INTO egom_charges 
				(studentid, chargetypeid, programid, amount, description, date)
			VALUES
				('#FORM.studentid#', '#FORM.deposit_id#', '#FORM.programid#', 
				'#FORM.deposit#', '#FORM.deposit_desc#', #CreateODBCDate(now())#)
		</cfquery>
	</cfif>

	<!--- SCHOOL TUITION --->
	<cfquery name="tuition_charges" datasource="MySql">
		SELECT invoiceid
		FROM egom_charges
		WHERE studentid = '#FORM.studentid#'
			AND programid = '#FORM.programid#'
			AND chargetypeid = '#FORM.school_tuition_id#'
	</cfquery>
	<cfif IsDefined('FORM.school_tuition_ckbox') AND FORM.school_tuition NEQ '' AND tuition_charges.recordcount EQ '0'>
		<cfquery name="insert_charges" datasource="MySQL">
			INSERT INTO egom_charges 
				(studentid, chargetypeid, programid, amount, description, date)
			VALUES
				('#FORM.studentid#', '#FORM.school_tuition_id#', '#FORM.programid#', 
				'#FORM.school_tuition#', '#FORM.school_tuition_desc#', #CreateODBCDate(now())#)
		</cfquery>
	</cfif>

	<!--- CANCELATION FEE --->
	<cfquery name="cancelation_charges" datasource="MySql">
		SELECT invoiceid
		FROM egom_charges
		WHERE studentid = '#FORM.studentid#'
			AND programid = '#FORM.programid#'
			AND chargetypeid = '#FORM.cancelation_id#'
	</cfquery>
	<cfif IsDefined('FORM.cancelation_ckbox') AND FORM.cancelation NEQ '' AND cancelation_charges.recordcount EQ '0'>
		<cfquery name="insert_charges" datasource="MySQL">
			INSERT INTO egom_charges 
				(studentid, chargetypeid, programid, amount, description, date)
			VALUES
				('#FORM.studentid#', '#FORM.cancelation_id#', '#FORM.programid#', 
				'#FORM.cancelation#', '#FORM.cancelation_desc#', #CreateODBCDate(now())#)
		</cfquery>
	</cfif>

	<!--- SEVIS FEE --->
	<cfquery name="sevis_charges" datasource="MySql">
		SELECT invoiceid
		FROM egom_charges
		WHERE studentid = '#FORM.studentid#'
			AND programid = '#FORM.programid#'
			AND chargetypeid = '#FORM.sevis_fee_id#'
	</cfquery>	
	<cfif IsDefined('FORM.sevis_fee_ckbox') AND FORM.sevis_fee NEQ '' AND sevis_charges.recordcount EQ '0'>
		<cfquery name="insert_charges" datasource="MySQL">
			INSERT INTO egom_charges 
				(studentid, chargetypeid, programid, amount, description, date)
			VALUES
				('#FORM.studentid#', '#FORM.sevis_fee_id#', '#FORM.programid#', 
				'#FORM.sevis_fee#', '#FORM.sevis_fee_desc#', #CreateODBCDate(now())#)
		</cfquery>
	</cfif>

	<!--- INSURANCE FEE --->
	<cfquery name="insurance_charges" datasource="MySql">
		SELECT invoiceid
		FROM egom_charges
		WHERE studentid = '#FORM.studentid#'
			AND programid = '#FORM.programid#'
			AND chargetypeid = '#FORM.insurance_id#'

	</cfquery>		
	<cfif IsDefined('FORM.insurance_ckbox') AND FORM.insurance NEQ '' AND insurance_charges.recordcount EQ '0'>
		<cfquery name="insert_charges" datasource="MySQL">
			INSERT INTO egom_charges 
				(studentid, chargetypeid, programid, amount, description, date)
			VALUES
				('#FORM.studentid#', '#FORM.insurance_id#', '#FORM.programid#', 
				'#FORM.insurance#', '#FORM.insurance_desc#', #CreateODBCDate(now())#)
		</cfquery>		
	</cfif>

	<!--- OTHER CHARGES --->	
	<cfquery name="other_charges" datasource="MySql">
		SELECT invoiceid
		FROM egom_charges
		WHERE studentid = '#FORM.studentid#'
			AND programid = '#FORM.programid#'
			AND chargetypeid = '#FORM.other_charges_id#'
			AND amount = '#FORM.other_charges#'
	</cfquery>			
	<cfif IsDefined('FORM.other_charges_ckbox') AND other_charges_id NEQ '0' AND FORM.other_charges NEQ '' AND other_charges.recordcount EQ '0'>	
		<cfquery name="insert_charges" datasource="MySQL">
			INSERT INTO egom_charges 
				(studentid, chargetypeid, programid, amount, description, date)
			VALUES
				('#FORM.studentid#', '#FORM.other_charges_id#', '#FORM.programid#', 
				'#FORM.other_charges#', '#FORM.other_charges_desc#', #CreateODBCDate(now())#)
		</cfquery>	
	</cfif>	
	
	<!--- CHECK CHARGES ADDED --->
	<cfquery name="get_charges" datasource="MySql">
		SELECT invoiceid, studentid
		FROM egom_charges
		WHERE studentid = '#FORM.studentid#'
			AND programid = '#FORM.programid#'
			AND invoiceid = '0'
	</cfquery>
	
	<!--- CREATE INVOICE --->
	<cfif get_charges.recordcount>
		<!--- NEW INVOICE --->
		<cfif NOT IsDefined('FORM.invoiceid')>
			<cfset FORM.uniqueid = createuuid()>
			<cfquery name="create_invoice" datasource="MySQL">
				INSERT INTO egom_invoice
					(uniqueid, intrepid, systemid, companyid, userid, date)
				VALUES
					('#FORM.uniqueid#', '#FORM.intrepid#', '#FORM.systemid#', '#client.companyid#', #client.userid#, #CreateODBCDate(now())#)
			</cfquery> 
			<cfquery name="get_invoice" datasource="MySql">
				SELECT max(invoiceid) as invoiceid
				FROM egom_invoice
			</cfquery>
		<!--- EXISTING INVOICE --->	
		<cfelse>
			<cfset get_invoice.invoiceid = #FORM.invoiceid#>
		</cfif>
	
		<!--- ASSIGN CHARGES TO INVOICE --->
		<cfquery name="assign_charges" datasource="MySql">
			UPDATE egom_charges
			SET invoiceid = '#get_invoice.invoiceid#'
			WHERE studentid = '#FORM.studentid#'
				AND programid = '#FORM.programid#'
				AND invoiceid = '0'
		</cfquery>

		<!--- SUMMARY OF CHARGES --->
		<cfquery name="summary_charges" datasource="MySql">
			SELECT chargeid, egom_charges.invoiceid, studentid, programid, amount, description, egom_charges.date, egom_charges.full_paid,
				type.charge,
				egom_invoice.uniqueid
			FROM egom_charges
			INNER JOIN egom_charges_type type ON type.chargetypeid = egom_charges.chargetypeid
			LEFT JOIN egom_invoice ON egom_invoice.invoiceid = egom_charges.invoiceid
			WHERE egom_charges.invoiceid = '#get_invoice.invoiceid#'
		</cfquery>
		
		<cfquery name="get_student" datasource="MySql">
			SELECT s.studentid, s.firstname, s.familylastname,
				u.businessname, u.userid,
				p.programname,
				php_schools.schoolname, php_schools.boarding_school,
				programtype.programtype
			FROM php_students_in_program php
			INNER JOIN smg_students s ON s.studentid = php.studentid
			INNER JOIN smg_users u ON  u.userid = s.intrep
			INNER JOIN smg_programs p ON p.programid = php.programid
			LEFT JOIN php_schools ON php_schools.schoolid = php.schoolid
			LEFT JOIN smg_program_type programtype ON programtype.programtypeid = p.type
			WHERE php.studentid = <cfqueryparam value="#FORM.studentid#" cfsqltype="cf_sql_integer">
				AND php.assignedid = <cfqueryparam value="#FORM.assignedid#" cfsqltype="cf_sql_char" maxlength="7">
		</cfquery>
		
		<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td width="100%" valign="top">
					<table border="0" cellpadding="3" cellspacing="0" width="90%" align="center">
						<tr><th colspan="2" bgcolor="##C2D1EF">Invoice ###get_invoice.invoiceid#</th></tr>
						<tr><td colspan="2">
								<table border="0" cellpadding="3" cellspacing="0" width="100%">
									<tr><td><b>Intl. Agent</b></td>
										<td><b>Student</b></td>
										<td><b>Program</b></td>
										<td><b>Program Type</b></td>
										<td><b>School</b></td>
										<td><b>Day/Board</b></td>
									</tr>
									<tr>
										<td>#get_student.businessname#</td>
										<td>#get_student.firstname# #get_student.familylastname# (###get_student.studentid#)</td>
										<td>#get_student.programname#</td>
										<td>#get_student.programtype#</td>
										<td>#get_student.schoolname#</td>
										<td>
											<cfif get_student.boarding_school EQ 0>Day
											<cfelseif get_student.boarding_school EQ 1>Board
											<cfelseif get_student.boarding_school EQ 2>Day/Board
											<cfelseif get_student.boarding_school EQ 3>n/a
											</cfif>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr><td width="60%" valign="top">	
								<table border="0" cellpadding="3" cellspacing="0" width="100%">
									<tr><th colspan="3" bgcolor="##C2D1EF">Summary of Charges<th></tr>
									<tr>
										<td width="40%"><b>Charge Type</b></td>
										<td width="20%"><b>Amount US$</b></td>
										<td width="40%"><b>Description</b></td>
									</tr>									
									<cfset total_invoice = '0'>
									<cfloop query="summary_charges">
									<tr>
										<td>#charge#</td>
										<td>#LSCurrencyFormat(amount, 'local')#</td>
										<td>#description#</td>
									</tr>
									<cfset total_invoice = total_invoice + amount>
									</cfloop>
									<tr>
										<td><b>Total Invoice</b></td>
										<td colspan="2"><b>#LSCurrencyFormat(total_invoice, 'local')#</b></td>
									</tr>
								</table>
							</td>
							<td width="40%" valign="top">
								<table border="0" cellpadding="3" cellspacing="0" width="100%">
									<tr><th colspan="2" bgcolor="##C2D1EF">Invoice Tools</th></tr>
									<tr>
										<td width="40%">
											<b><a href="javascript:OpenInvoice('invoice/view_invoice.cfm?i=#summary_charges.uniqueid#')">Print Invoice</a></b>
											&nbsp; <a href="javascript:OpenInvoice('invoice/view_invoice_email.cfm?i=#summary_charges.uniqueid#');" onclick="return confirm ('Invoice ###summary_charges.invoiceid# will be sent to #get_student.businessname#. Click OK to continue.');"><img src="pics/email.gif" border="0" alt="Email Invoice ###summary_charges.invoiceid# to #get_student.businessname#."></a>
	
										</td>
										<td width="60%"><b><a href="?curdoc=invoice/account_details&intrep=#get_student.userid#">#get_student.businessname# Account Details</a></b></td>
									</tr>
									<tr>
										<td>&nbsp;</td>
										<td>
                                        	<b><a href="?curdoc=invoice/invoice_index">Invoicing Menu</a> 
                                            <br /><a href="?curdoc=invoice/create_student_invoice&studentID=#FORM.studentID#&assignedID=#FORM.assignedID#"><img src="pics/back.gif" border="0" /></a></b>
                                        </td>
									</tr>									
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</table>
	<!--- NO CHARGES WERE CREATED ---->
	<cfelse>
		<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td width="100%" valign="top">
					<table border="0" cellpadding="3" cellspacing="0" width="90%" align="center">
						<tr><th bgcolor="##C2D1EF">Invoice Error</th></tr>
						<tr><td width="100%" valign="top">	
								<table border="0" cellpadding="3" cellspacing="0" width="100%">
									<tr><td>&nbsp;</td></tr>
									<tr><th>Please check at least one charge in order to create an invoice and make sure you entered the charge amount.</th></tr>
									<tr><th>Please go back and try again.</th></tr>
									<tr><td>&nbsp;</td></tr>
									<tr bgcolor="##C2D1EF"><th><a href="javascript:history.back()"><img src="pics/back.gif" border="0" /></a></th></tr>						
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</table>
	</cfif>
	
</cftransaction>
<br /><br />

</cfoutput>

</body>
</html>