<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Create General Invoice</title>
</head>

<body>

<cfoutput>

	<!--- GET AGENT --->
	<cfquery name="get_agent" datasource="MySql">
		SELECT userid, businessname
		FROM smg_users
		WHERE userid = <cfqueryparam value="#form.intrepid#" cfsqltype="cf_sql_integer">
	</cfquery>

	<!--- AXIS SYSTEM --->
	<cfset form.systemid = 2>

	<cfset chargelist = 0>
	
	<!--- OTHER CHARGES UP TO 5 --->	
	<cfloop from="1" to="5" index="i">
		<cfquery name="check.charges_#i#" datasource="MySql">
			SELECT invoiceid
			FROM egom_charges
			WHERE chargetypeid = '#form["other_charges_id_" & i]#'
				AND amount = '#form["other_charges_" & i]#'
				AND date = #CreateODBCDate(now())#
		</cfquery>	
		
		<cfif IsDefined('form.other_charges_ckbox_'&i) AND form["other_charges_id_" & i] NEQ '0' AND form["other_charges_" & i] NEQ '' AND check["charges_" & i].recordcount EQ '0' >	
			<cfquery name="insert_charges" datasource="MySQL">
				INSERT INTO egom_charges 
					(studentid, chargetypeid, programid, amount, description, date)
				VALUES 
					('0', '#form["other_charges_id_" & i]#', '0', '#form["other_charges_" & i]#', '#form["other_charges_desc_" & i]#', #CreateODBCDate(now())#)
			</cfquery>	
			<cfquery name="last_charge" datasource="MySql">
				SELECT max(chargeid) as chargeid
				FROM egom_charges
			</cfquery>
			<cfset chargelist = ListAppend(chargelist, last_charge.chargeid)>
		</cfif>	
	</cfloop>

	<!--- CHECK CHARGES ADDED --->
	<cfquery name="get_charges" datasource="MySql">
		SELECT invoiceid
		FROM egom_charges
		WHERE ( <cfloop list="#chargelist#" index="charge">chargeid = #charge# <cfif charge EQ #ListLast(chargelist)#><Cfelse>OR </cfif></cfloop> )
	</cfquery>

	<!--- CREATE INVOICE --->
	<cfif chargelist NEQ 0 AND get_charges.recordcount>
		
		<!--- NEW INVOICE --->
		<cfset form.uniqueid = createuuid()>
		<cfquery name="create_invoice" datasource="MySQL">
			INSERT INTO egom_invoice
				(uniqueid, intrepid, systemid, companyid, userid, date)
			VALUES
				('#form.uniqueid#', '#form.intrepid#', '#form.systemid#', '#client.companyid#', #client.userid#, #CreateODBCDate(now())#)
		</cfquery> 
		<cfquery name="get_invoice" datasource="MySql">
			SELECT max(invoiceid) as invoiceid
			FROM egom_invoice
		</cfquery>
	
		<!--- ASSIGN CHARGES TO INVOICE --->
		<cfquery name="assign_charges" datasource="MySql">
			UPDATE egom_charges
			SET invoiceid = '#get_invoice.invoiceid#'
			WHERE invoiceid = '0'
		</cfquery>
 
		<cflocation url="?curdoc=invoice/create_general_invoice_view&i=#URLEncodedFormat(form.uniqueid)#" addtoken="no">

	<!--- NO CHARGES WERE CREATED ---->
	<cfelse>
		<br /><br />	
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
		<br /><br />
	</cfif>

</cfoutput>
</body>
</html>