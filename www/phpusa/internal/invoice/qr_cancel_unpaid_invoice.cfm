<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Cancel Invoice</title>
</head>

<body>

<cfoutput>

<cfset total_boxes = 0>

<br /><br />

<cftransaction>
	
	<cfloop from="1" to="#total_cancelbox#" index="x">
		<cfif IsDefined('form.cancel_box'&x)>
			<!--- CANCELATION TYPE = #13 --->		
			<cfquery name="get_charge_cancel" datasource="MySql">
				SELECT chargeid, invoiceid, chargetypeid, studentid, programid, amount, description 
				FROM egom_charges
				WHERE chargeid = '#form["chargeid" & x]#'
			</cfquery>
			<!--- DOUBLE CHECK CANCELATION --->
			<cfquery name="check_cancelation" datasource="MySql">
				SELECT chargeid, invoiceid, chargetypeid, studentid, programid, amount, description 
				FROM egom_charges
				WHERE chargetypeid = '13'
					AND amount = '-#get_charge_cancel.amount#'
					AND invoiceid = '#get_charge_cancel.invoiceid#'
			</cfquery>
			
			<cfif check_cancelation.recordcount EQ 0>
				<cfquery name="insert_charges" datasource="MySQL">
					INSERT INTO egom_charges 
						(studentid, invoiceid, chargetypeid, programid, amount, description, date, canceled)
					VALUES
						('#get_charge_cancel.studentid#', '#get_charge_cancel.invoiceid#', '13', '#get_charge_cancel.programid#', 
						'-#get_charge_cancel.amount#', 'Cancelation #get_charge_cancel.description#', #CreateODBCDate(now())#, '1')
				</cfquery>
				<cfquery name="update_canceled_charge" datasource="MySql">
					UPDATE egom_charges
					SET canceled = '1'
					WHERE chargeid = '#form["chargeid" & x]#'
					LIMIT 1
				</cfquery>
			</cfif>
			
			<cfset total_boxes = total_boxes + 1>
		</cfif>
	</cfloop>	
	
	<cfif total_boxes EQ 0>
		<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td width="100%" valign="top">
					<table border="0" cellpadding="3" cellspacing="0" width="90%" align="center">
						<tr><th bgcolor="##C2D1EF">Invoice Error</th></tr>
						<tr><td width="100%" valign="top">	
								<table border="0" cellpadding="3" cellspacing="0" width="100%">
									<tr><td>&nbsp;</td></tr>
									<tr><th>Please check at least one charge to be cancelled.</th></tr>
									<tr><th>Please go back and try again.</th></tr>
									<tr><td>&nbsp;</td></tr>
									<tr bgcolor="##C2D1EF"><th><a href="?curdoc=invoice/create_student_invoice&studentid=#form.studentid#&assignedID=#form.assignedID#"><img src="pics/back.gif" border="0" /></a></th></tr>						
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</table><br />
		<cfabort>
	</cfif>
	
</cftransaction>

<script language="JavaScript">
<!-- 
alert("You have successfully updated this page. Thank You.");
	location.replace("?curdoc=invoice/create_student_invoice&studentid=#form.studentid#&assignedID=#form.assignedID#");
-->
</script>

</cfoutput>

</body>
</html>