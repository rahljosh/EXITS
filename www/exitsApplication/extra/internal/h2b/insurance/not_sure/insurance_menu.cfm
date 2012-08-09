<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Insurance Menu</title>
</head>

<body>

<cftry>

<cfinclude template="../querys/get_active_programs.cfm">

<cfinclude template="../querys/get_intl_reps.cfm">

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="FFFFFF">
	<tr>
		<td bordercolor="FFFFFF">
			<!----Header Table---->
			<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
				<tr bgcolor="E4E4E4">
					<td class="title1">&nbsp; &nbsp; Insurance</td>
				</tr>
			</table><br>
		
			<!--- INSURANCE FILES --->
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="C7CFDC">	
				<tr>
					<td width="49%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF" valign="top">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<cfform name="new_ticket" action="insurance/new_registration.cfm" method="post">
										<tr bgcolor="C2D1EF"><td class="style2" bgcolor="8FB6C9" colspan="2">&nbsp;:: Insurance New Registration - Excel Spreadsheet</td></tr>
										<tr>
											<td class="style1">Program :</td>
											<td class="style1" align="left">
											<cfselect name="programid" size="5" multiple="yes">
												<cfloop query="get_active_programs">
													<option value="#programid#">#programname#</option>
												</cfloop>
											</cfselect>	
											</td>
										</tr>
										<tr>
											<td class="style1">Intl. Rep. :</td>
											<td class="style1" align="left">
											<cfselect name="intrep">
												<option value="0">All</option>
												<cfloop query="get_intl_reps">
													<option value="#userid#">#businessname#</option>
												</cfloop>
											</cfselect>												
											</td>
										</tr>										
										<tr><td align="center" colspan="2"><cfinput type="image" name="submit" value=" Submit " src="../pics/save.gif"></td></tr>
										</cfform>	
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td width="2%" valign="top">&nbsp;</td>
					<td width="49%" valign="top">

					</td>
				</tr>
			</table><br>
		</td>
	</tr>
</table>

</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>