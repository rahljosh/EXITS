<!--- ------------------------------------------------------------------------- ----
	
	File:		insurance_menu.cfm
	Author:		Marcus Melo
	Date:		October 07, 2009
	Desc:		Displays insurance menu options.

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <cfinclude template="../querys/get_active_programs.cfm">
    
    <cfinclude template="../querys/get_intl_reps.cfm">
    
    <cfquery name="get_insutypes" datasource="MySql">
        SELECT 
            insutypeid, 
            type
        FROM 
            smg_insurance_type
        WHERE 
            insutypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="14">
    </cfquery>
    
    <cfquery name="get_pending" datasource="MySql">
        SELECT 
            h.transtype, 
            count(h.candidateid) as total  
        FROM 
            extra_insurance_history h
        INNER JOIN 
            extra_candidates c ON c.candidateid = h.candidateid
        WHERE 
            c.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        AND 
            h.filed_date IS NULL
        GROUP BY 
            transtype
        ORDER BY 
            transtype
    </cfquery>
    
    <cfquery name="get_history" datasource="MySql">
        SELECT 
        	h.transtype, 
            h.filed_date, 
            count(h.candidateid) as total  
        FROM 
        	extra_insurance_history h
        INNER JOIN 
        	extra_candidates c ON c.candidateid = h.candidateid
        WHERE 
        	c.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        AND 
        	h.filed_date IS NOT NULL
        GROUP BY 
        	filed_date, 
            transtype
        ORDER BY 
        	filed_date DESC, 
            transtype
    </cfquery>

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Insurance Menu</title>
</head>

<body>

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
										<cfform name="new_transaction" action="insurance/new_transaction_programid.cfm" method="post">
										<tr bgcolor="C2D1EF"><td class="style2" bgcolor="8FB6C9" colspan="2">&nbsp;:: Insurance New Transaction - Excel Spreadsheet</td></tr>
										<tr>
											<td class="style1"><b>Program:</b></td>
											<td class="style1" align="left">
												<cfselect name="programid" size="5" multiple="yes"  class="style1">
													<cfloop query="get_active_programs">
														<option value="#programid#">#programname# &nbsp; &nbsp;</option>
													</cfloop>
												</cfselect>	
											</td>
										</tr>
										<tr>
											<td class="style1"><b>Intl. Rep.:</b></td>
											<td class="style1" align="left">
												<cfselect name="intrep"  class="style1">
													<option value="0">All</option>
													<cfloop query="get_intl_reps">
														<option value="#userid#"><cfif len(businessname) GT 40>#Right(businessname, 38)#..<cfelse>#businessname#</cfif></option>
													</cfloop>
												</cfselect>												
											</td>
										</tr>
										<tr>
											<td class="style1"><b>Insurance Type</b></td>
											<td><cfselect name="extra_insurance_typeid"  class="style1" query="get_insutypes" value="insutypeid" display="type"></cfselect></td>
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
	
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="C7CFDC">	
				<tr>
					<td width="100%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr bgcolor="C2D1EF"><td class="style2" bgcolor="8FB6C9">&nbsp;:: Insurance Management Screen</td></tr>
						</table>
					</td>
				</tr>
			</table><br>
	
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="C7CFDC">	
				<tr>
					<td width="49%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF" valign="top">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF"><td class="style2" bgcolor="8FB6C9" colspan="2">&nbsp;:: Pending Manual Transactions</td></tr>
										<tr><td class="style1"><b>Transaction</b></td><th class="style1">Total</th></tr>
										<cfloop query="get_pending">
											<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
												<td class="style1">#transtype#</td>
												<td align="center" class="style1">#total#</td>
											</tr>
										</cfloop>
										<cfif get_pending.recordcount EQ 0>
											<tr bgcolor="e9ecf1"><td colspan="2" class="style1">There are no pending transactions.</td></tr>
										</cfif>
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
										<cfform name="manual_transaction" action="insurance/manual_transaction.cfm" method="post">
										<tr bgcolor="C2D1EF"><td class="style2" bgcolor="8FB6C9" colspan="2">&nbsp;:: Manual Transaction - Excel Spreadsheet</td></tr>														
										<tr>
											<td class="style1">Transacation Type :</td>
											<td class="style1" align="left">
												<select name="transtype"  class="style1">
													<option value=""></option>
													<option value="new">New App</option>
													<option value="correction">Correction</option>
													<option value="early return">Early Return</option>
													<option value="cancellation">Cancellation</option>
													<option value="extension">Extension</option>
												</select>
											</td>
										</tr>																	
										<tr><td align="center" colspan="2"><cfinput type="image" name="submit" value=" Submit " src="../pics/save.gif"></td></tr>
										</cfform>	
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table><br>	

			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="C7CFDC">	
				<tr>
					<td width="100%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr bgcolor="C2D1EF"><td class="style2" bgcolor="8FB6C9" colspan="3">&nbsp;:: Insurance History - Excel Files</td></tr>
						</table>
					</td>
				</tr>
			</table><br>

			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="C7CFDC">	
				<tr>
					<td width="100%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<th width="25%" class="style1">Transaction Type</th>
								<th width="25%" class="style1">Filed Date</th>
								<th width="25%" class="style1">Total of Candidates</th>
								<th width="25%" class="style1">List of Candidates</th>
							</tr>
							<cfloop query="get_history">
							<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
								<td align="center" class="style1"><a href="insurance/open_history.cfm?type=#transtype#&date=#DateFormat(filed_date, 'yyyy/mm/dd')#" class="style4">#transtype#</a></td>
								<td align="center" class="style1"><a href="insurance/open_history.cfm?type=#transtype#&date=#DateFormat(filed_date, 'yyyy/mm/dd')#" class="style4">#DateFormat(filed_date, 'mm/dd/yyyy')#</a></td>
								<td align="center" class="style1"><a href="insurance/open_history.cfm?type=#transtype#&date=#DateFormat(filed_date, 'yyyy/mm/dd')#" class="style4">#total#</a></td>
								<td align="center" class="style1"><a href="insurance/transaction_cand_list.cfm?type=#transtype#&date=#DateFormat(filed_date, 'yyyy/mm/dd')#" class="style4" target="_blank">List</a></td>
							</tr>
							</cfloop>
						</table>
					</td>
				</tr>
			</table><br>
		</td>
	</tr>
</table>

</cfoutput>

</body>
</html>