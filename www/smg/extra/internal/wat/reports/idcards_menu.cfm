<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>ID Cards Menu</title>
</head>

<body>

<cftry>

<cfinclude template="../querys/get_active_programs.cfm">

<cfquery name="get_intl_reps" datasource="mysql">
	SELECT u.userid, u.businessname, u.extra_insurance_typeid
	FROM smg_users u
 	INNER JOIN extra_candidates extra ON u.userid = extra.intrep
	WHERE u.usertype = '8'
		AND extra.companyid = '#client..companyid#'
	GROUP BY userid
	ORDER BY businessname	
</cfquery>

<cfquery name="verification_dates" datasource="MySql">
	SELECT ec.verification_received
	FROM extra_candidates ec 
	WHERE ec.active = '1'
		AND ec.companyid = '#client.companyid#'
		AND ec.verification_received IS NOT NULL
	GROUP BY ec.verification_received
	ORDER BY ec.verification_received DESC
</cfquery>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="FFFFFF">
	<tr>
		<td bordercolor="FFFFFF">
			<!----Header Table---->
			<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
				<tr bgcolor="E4E4E4">
					<td class="title1">&nbsp; &nbsp; ID Cards Menu</td>
				</tr>
			</table><br>
			
			<!--- INSURANCE ID CARDS --->
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="C7CFDC">	
				<tr>
					<td width="49%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF" valign="top">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<cfform name="new_ticket" action="reports/idcards_per_intl_rep.cfm" method="post" target="_blank">
										<tr bgcolor="C2D1EF"><td class="style2" bgcolor="8FB6C9" colspan="2">&nbsp;:: ID Cards - Avery 5371</td></tr>
										<tr>
											<td class="style1" valign="top" align="right"><b>Program:</b></td>
											<td class="style1" align="left">
											<cfselect name="programid" size="5" multiple="yes" class="style1">
												<cfloop query="get_active_programs">
													<option value="#programid#">#programname#</option>
												</cfloop>
											</cfselect>	
											</td>
										</tr>
										<tr>
											<td class="style1" align="right"><b>Intl. Rep.:</b></td>
											<td class="style1" align="left">
											<cfselect name="intrep" class="style1">
												<option value="0">All</option>
												<cfloop query="get_intl_reps">
													<option value="#userid#"><cfif len(businessname) GT 40>#Right(businessname, 38)#..<cfelse>#businessname#</cfif></option>
												</cfloop>
											</cfselect>												
											</td>
										</tr>
										<tr>
											<td class="style1" align="right"><b>DS Verification Received:</b></td>
											<td class="style1" align="left">
												<cfselect name="verification_received" query="verification_dates" value="verification_received" display="verification_received" queryPosition="below" class="style1">
												<option value=""></option>
												</cfselect>
											</td>
										</tr>
										<tr><td align="center" colspan="2"><cfinput type="image" name="submit" value=" Submit " src="../pics/view.gif"></td></tr>
										</cfform>	
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td width="2%" valign="top">&nbsp;</td>
					<td width="49%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF" valign="top">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<cfform name="new_ticket" action="reports/idcards_list.cfm" method="post" target="_blank">
										<tr bgcolor="C2D1EF"><td class="style2" bgcolor="8FB6C9" colspan="2">&nbsp;:: ID Cards List</td></tr>
										<tr>
											<td class="style1" valign="top" align="right"><b>Program:</b></td>
											<td class="style1" align="left">
											<cfselect name="programid" size="5" multiple="yes" class="style1">
												<cfloop query="get_active_programs">
													<option value="#programid#">#programname#</option>
												</cfloop>
											</cfselect>	
											</td>
										</tr>
										<tr>
											<td class="style1" align="right"><b>Intl. Rep.:</b></td>
											<td class="style1" align="left">
											<cfselect name="intrep" class="style1">
												<option value="0">All</option>
												<cfloop query="get_intl_reps">
													<option value="#userid#"><cfif len(businessname) GT 40>#Right(businessname, 38)#..<cfelse>#businessname#</cfif></option>
												</cfloop>
											</cfselect>												
											</td>
										</tr>
										<tr>
											<td class="style1" align="right"><b>DS Verification Received:</b></td>
											<td class="style1" align="left">
												<cfselect name="verification_received" class="style1" query="verification_dates" value="verification_received" display="verification_received" queryPosition="below">
												<option value="0"></option>
												</cfselect>
											</td>
										</tr>										
										<tr><td align="center" colspan="2"><cfinput type="image" name="submit" value=" Submit " src="../pics/view.gif"></td></tr>
										</cfform>	
									</table>
								</td>
							</tr>
						</table>
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