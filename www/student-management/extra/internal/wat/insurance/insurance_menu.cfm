<!--- ------------------------------------------------------------------------- ----
	
	File:		insurance_menu.cfm
	Author:		Marcus Melo
	Date:		January 10, 2011
	Desc:		Insurance Information

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <!--- Param variables --->
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.intRep" default="0">
    <cfparam name="FORM.verification_received" default="">
    <cfparam name="FORM.submitted" default="0">

    <cfquery name="qGetInsuranceTypes" datasource="MySql">
        SELECT 
        	insutypeid, type
        FROM 
        	smg_insurance_type
        WHERE 
        	insutypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="14">
    </cfquery>
    
    <cfquery name="qGetPendingTransactions" datasource="MySql">
        SELECT 
        	h.transtype, 
            count(h.candidateid) AS total  
        FROM 
        	extra_insurance_history h
        INNER JOIN 
        	extra_candidates c ON c.candidateid = h.candidateid
        WHERE 
        	c.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        AND 
        	h.filed_date IS NULL
        GROUP BY 
        	transtype
        ORDER BY 
        	transtype
    </cfquery>
    
    <cfquery name="qGetHistory" datasource="MySql">
        SELECT 
        	h.transtype, 
            h.filed_date, 
            count(h.candidateid) AS total  
        FROM 
        	extra_insurance_history h
        INNER JOIN 
        	extra_candidates c ON c.candidateid = h.candidateid
        WHERE 
        	c.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        AND 
        	h.filed_date IS NOT NULL
        GROUP BY 
        	filed_date, 
            transtype
        ORDER BY 
        	filed_date DESC, 
            transtype
        LIMIT 50
    </cfquery>
    
</cfsilent>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##FFFFFF">
	<tr>
		<td bordercolor="##FFFFFF">
			<!----Header Table---->
			<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="##CCCCCC">
				<tr bgcolor="##CCCCCC">
					<td class="title1">&nbsp; &nbsp; Insurance</td>
				</tr>
			</table><br>
		
			<!--- INSURANCE FILES --->
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="##C7CFDC">	
				<tr>
					<td width="49%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##FFFFFF">
							<tr>
								<td bordercolor="##FFFFFF" valign="top">
                                    <cfform name="new_transaction" action="insurance/new_transaction_programid.cfm" method="post">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="##C2D1EF"><td class="style2" bgcolor="##8FB6C9" colspan="2">&nbsp;:: Enroll Candidates - Excel Spreadsheet</td></tr>
										<tr>
											<td class="style1" valign="top">Program :</td>
											<td class="style1" align="left">
                                                <cfselect
                                                    name="programID" 
                                                    id="programID"
                                                    class="style1"
                                                    value="programID"
                                                    display="programName"
                                                    multiple="yes"
                                                    size="7"
                                                    selected="#FORM.programID#"
                                                    bind="cfc:extra.extensions.components.program.getProgramsRemote()" 
                                                    bindonload="true" /> 
											</td>
										</tr>
										<tr>
											<td class="style1">Intl. Rep. :</td>
											<td class="style1" align="left">
		                                        <cfselect
                                                	name="intRep" 
                                                    id="intRep"
                                                    value="userID"
                                                    display="businessName"
                                                	bind="cfc:extra.extensions.components.user.getIntlRepRemote({programID})" 
                                                    bindonload="true" /> 
											</td>
										</tr>
                                        <tr>
											<td class="style1">Verification Received :</td>
											<td class="style1" align="left">
                                                <cfselect 
                                                    name="verification_received" 
                                                    id="verification_received"
                                                    value="verificationReceived"
                                                    display="verificationReceived"
                                                    bind="cfc:extra.extensions.components.user.getVerificationDate({intRep})" /> 
											</td>
										</tr>
										<tr>
											<td class="style1">Insurance Type</td>
											<td><cfselect name="extra_insurance_typeid" query="qGetInsuranceTypes" value="insutypeid" display="type"></cfselect></td>
										</tr>																														
										<tr><td align="center" colspan="2"><input type="image" name="submit" value=" Submit " src="../pics/view.gif"></td></tr>										
									</table>
                                    </cfform>	
								</td>
							</tr>
						</table>
					</td>
					<td width="2%" valign="top">&nbsp;</td>
					<td width="49%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##FFFFFF">
							<tr>
								<td bordercolor="##FFFFFF" valign="top">
                                    <cfform name="toBeInsured" action="index.cfm?curdoc=insurance/toBeInsured" method="post">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="##C2D1EF"><td class="style2" bgcolor="##8FB6C9" colspan="2">&nbsp;:: Candidates to be Insured</td></tr>
										<tr>
											<td class="style1" valign="top">Program :</td>
											<td class="style1" align="left">
                                                <cfselect
                                                    name="programID" 
                                                    id="programID2"
                                                    class="style1"
                                                    value="programID"
                                                    display="programName"
                                                    multiple="yes"
                                                    size="7"
                                                    selected="#FORM.programID#"
                                                    bind="cfc:extra.extensions.components.program.getProgramsRemote()" 
                                                    bindonload="true" /> 
											</td>
										</tr>
										<tr>
											<td class="style1">Intl. Rep. :</td>
											<td class="style1" align="left">
		                                        <cfselect
                                                	name="intRepID" 
                                                    id="intRepID2"
                                                    value="userID"
                                                    display="businessName"
                                                	bind="cfc:extra.extensions.components.user.getIntlRepRemote({programID2})" 
                                                    bindonload="true"> 
                                                </cfselect> 
											</td>
										</tr>
                                        <tr>
											<td class="style1">Verification Received :</td>
											<td class="style1" align="left">
                                                <cfselect 
                                                    name="verification_received" 
                                                    id="verification_received2"
                                                    value="verificationReceived"
                                                    display="verificationReceived"
                                                    bind="cfc:extra.extensions.components.user.getVerificationDate({intRepID2})"> 
                                                </cfselect> 
											</td>
										</tr>
                                        <tr>
                                            <td align="right" class="style1"><b>Format: </b></td>
                                            <td  class="style1"> 
                                                <input type="radio" name="printOption" id="printOption1" value="1" checked> <label for="printOption1">Onscreen (View Only)</label>
                                                <input type="radio" name="printOption" id="printOption2" value="2"> <label for="printOption2">Print (FlashPaper)</label> 
                                                <input type="radio" name="printOption" id="printOption3" value="3"> <label for="printOption3">Print (PDF)</label>
                                            </td>           
                                        </tr>
										<tr><td align="center" colspan="2"><input type="image" name="submit" value=" Submit " src="../pics/view.gif"></td></tr>										
									</table>
                                    </cfform>	
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table><br>
	
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="##C7CFDC">	
				<tr>
					<td width="100%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##FFFFFF">
							<tr bgcolor="##C2D1EF"><td class="style2" bgcolor="##8FB6C9">&nbsp;:: Insurance Management Screen</td></tr>
						</table>
					</td>
				</tr>
			</table><br>
	
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="##C7CFDC">	
				<tr>
					<td width="49%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##FFFFFF">
							<tr>
								<td bordercolor="##FFFFFF" valign="top">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="##C2D1EF"><td class="style2" bgcolor="##8FB6C9" colspan="2">&nbsp;:: Pending Manual Transactions</td></tr>
										<tr><td class="style1"><b>Transaction</b></td><th class="style1">Total</th></tr>
										<cfloop query="qGetPendingTransactions">
											<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
												<td class="style1">#transtype#</td>
												<td align="center" class="style1">#total#</td>
											</tr>
										</cfloop>
										<cfif qGetPendingTransactions.recordcount EQ 0>
											<tr bgcolor="e9ecf1"><td colspan="2" class="style1">There are no pending transactions.</td></tr>
										</cfif>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td width="2%" valign="top">&nbsp;</td>
					<td width="49%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##FFFFFF">
							<tr>
								<td bordercolor="##FFFFFF" valign="top">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<cfform name="manual_transaction" action="insurance/manual_transaction.cfm" method="post">
										<tr bgcolor="##C2D1EF"><td class="style2" bgcolor="##8FB6C9" colspan="2">&nbsp;:: Manual Transaction - Excel Spreadsheet</td></tr>														
										<tr>
											<td class="style1">Transaction Type :</td>
											<td class="style1" align="left">
												<select name="transtype"  class="style1">
													<option value="0"></option>
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

			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="##C7CFDC">	
				<tr>
					<td width="100%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##FFFFFF">
							<tr bgcolor="##C2D1EF"><td class="style2" bgcolor="##8FB6C9" colspan="4">&nbsp;:: Insurance History - Excel Files</td></tr>
							<tr>
								<th width="25%" class="style1">Transaction Type</th>
								<th width="25%" class="style1">Filed Date</th>
								<th width="25%" class="style1">Total of Candidates</th>
								<th width="25%" class="style1">List of Candidates</th>
							</tr>
							<cfloop query="qGetHistory">
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