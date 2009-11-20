<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>General Invoice</title>
</head>
<body>

<cfquery name="get_agent" datasource="MySql">
	SELECT userid, businessname
	FROM smg_users
	WHERE userid = <cfqueryparam value="#url.intrep#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_other_charges" datasource="MySql">
	SELECT chargetypeid, charge
	FROM egom_charges_type
	WHERE type = 'other'
		AND (systemid = '0' OR systemid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">)	 
</cfquery>

<cfoutput>

<br /><br />
<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td width="100%" valign="top">
			<table border="0" cellpadding="3" cellspacing="0" width="90%" align="center">
				<tr><th colspan="2" bgcolor="##C2D1EF">CREATE GENERAL INVOICE</th></tr>
				<tr><td valign="top">	
						<table border="0" cellpadding="3" cellspacing="0" width="100%">
							<tr><td><b>Intl. Agent:</b> &nbsp; #get_agent.businessname# (###get_agent.userid#)</td></tr>
						</table><br />		
																			
						<cfform name="invoice" action="?curdoc=invoice/create_general_invoice_qr" method="post">
						<!--- HIDDEN FIELDS --->
						<cfinput type="hidden" name="intrepid" value="#get_agent.userid#">
						<table border="0" cellpadding="3" cellspacing="0" width="100%">
							<tr><td colspan="4" bgcolor="##C2D1EF"><b>New Charges</b></td></tr>
							<tr>
								<td width="12%"><b>Include Charge</b></td>
								<td width="48%"><b>Charge Type</b></td>
								<td width="15%"><b>Amount US$</b></td>
								<td width="25%"><b>Description</b></td>
							</tr>					
							<!--- OTHER CHARGES - UP TO 5 CHARGES --->
							<cfloop from="1" to="5" index="i">
								<tr>
									<td align="center"><cfinput type="checkbox" name="other_charges_ckbox_#i#"></td>
									<td>Other Charges &nbsp; 
										<cfselect name="other_charges_id_#i#">
											<option value="0"></option>
											<cfloop query="get_other_charges">
												<option value="#chargetypeid#">#charge#</option>
											</cfloop>
										</cfselect>
									</td>
									<td><cfinput type="text" name="other_charges_#i#" size="8"></td>
									<td><cfinput type="text" name="other_charges_desc_#i#" value="" size="24"></td>
								</tr>
							</cfloop>					
							<tr><td colspan="4">* Only boxes that are checked will be included in this invoice.</td></tr>
							<tr><td colspan="4">&nbsp;</td></tr>			
							<tr bgcolor="##C2D1EF"><th colspan="4"><a href="?curdoc=invoice/account_details&intrep=#get_agent.userid#"><img src="pics/back.gif" border="0" /></a> &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; <cfinput type="image" name="next" value=" Submit " src="pics/submit.gif" submitOnce></th></tr>						
						</table>
						</cfform>
					</td>
				</tr>				
			</table>
		</td>
	</tr>
</table>
<br /><br />

</cfoutput>

</body>
</html>
