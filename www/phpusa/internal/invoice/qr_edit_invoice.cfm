<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Edit Invoice</title>
</head>

<body>

<cfoutput>

<cfset total_boxes = 0>

<br /><br />

<cftransaction>

	<cfloop from="1" to="#total_editbox#" index="x">
		<cfif IsDefined('form.edit_box'&x)>
			<cfquery name="update_charge" datasource="MySql">
				UPDATE egom_charges
				SET amount = '#form["edit_tuition" & x]#',
					description = '#form["edit_desc" & x]#'
				WHERE chargeid = '#form["chargeid" & x]#'
				LIMIT 1
			</cfquery>

			<cfquery name="create_history" datasource="MySql">
				INSERT INTO egom_charges_history
					(chargeid, oldamount, newamount, changedby)
				VALUES ('#form["chargeid" & x]#', '#form["previous_tuition" & x]#', '#form["edit_tuition" & x]#', '#client.userid#')
			</cfquery>

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
									<tr><th>Please check at least one charge in order to edit..</th></tr>
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