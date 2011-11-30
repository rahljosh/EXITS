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
    <cfparam name="FORM.getDatesFrom" default="program">
    <cfparam name="FORM.flightEndDate" default="">
    
    <cfquery name="qGetInsuranceTypeList" datasource="MySql">
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
            h.input_date,
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
        	input_date, 
            transtype
        ORDER BY 
        	input_date DESC, 
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
			</table><br />
		
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
											<td class="style1">
                                                <cfselect
                                                    name="programID" 
                                                    id="programID"
                                                    class="style1"
                                                    multiple="yes"
                                                    size="7"
                                                    value="programID"
                                                    display="programName"
                                                    selected="#FORM.programID#"
                                                    bind="cfc:extra.extensions.components.program.getProgramsRemote()" 
                                                    bindonload="true" />                                                     
											</td>
										</tr>
										<tr>
											<td class="style1">Intl. Rep. :</td>
											<td class="style1">
                                                <cfselect
                                                    name="intRep" 
                                                    id="intRep"
                                                    class="style1" 
                                                    value="userID"
                                                    display="businessName"
                                                    selected="#FORM.intRep#"
                                                    bind="cfc:extra.extensions.components.user.getIntlRepRemote({programID})" /> 
											</td>
										</tr>
                                        <tr>
											<td class="style1" valign="top">Verification Received :</td>
											<td class="style1">
                                                <cfselect 
                                                    name="verification_received"
                                                    id="verification_received"
                                                    class="style1"
                                                    style="width:100px;"
                                                    multiple="yes"
                                                    size="10"
                                                    value="verificationReceived"
                                                    display="verificationReceivedDisplay"
                                                    selected="#FORM.verification_received#"
                                                    bind="cfc:extra.extensions.components.user.getVerificationDate({intRep},{programID})" /> 
											</td>
										</tr>
                                        <tr>
											<td class="style1" valign="top">Get Dates From :</td>
											<td class="style1">
                                                <select name="getDatesFrom" id="getDatesFrom" class="style1">
                                                	<option value="program" <cfif FORM.getDatesFrom EQ 'program' > selected="selected" </cfif> >Use Program Dates</option>
                                                    <option value="flightInformation" <cfif FORM.getDatesFrom EQ 'flightInformation' > selected="selected" </cfif> >Use Flight Information</option>
                                                </select>
											</td>
										</tr>
                                        <tr>
											<td class="style1" colspan="2">Please enter an end date if flight information option is selected</td>
										</tr>
                                        <tr>
											<td class="style1" valign="top">End Date:</td>
                                            <td class="style1">
                                            	<input type="text" name="flightEndDate" id="flightEndDate" class="datePicker" value="#DateFormat(FORM.flightEndDate, 'mm/dd/yyyy')#" />
                                            </td>
										</tr>
										<tr>
											<td class="style1">Insurance Type</td>
											<td><cfselect name="extra_insurance_typeid" query="qGetInsuranceTypeList" value="insutypeid" display="type" class="style1" /></td>
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
											<td class="style1">
                                                <cfselect
                                                    name="programID" 
                                                    id="programID2"
                                                    class="style1"
                                                    multiple="yes"
                                                    size="7"
                                                    value="programID"
                                                    display="programName"
                                                    selected="#FORM.programID#"
                                                    bind="cfc:extra.extensions.components.program.getProgramsRemote()" 
                                                    bindonload="true" />                                                     
											</td>
										</tr>
										<tr>
											<td class="style1">Intl. Rep. :</td>
											<td class="style1">
                                                <cfselect
                                                    name="intRep" 
                                                    id="intRep2"
                                                    class="style1"
                                                    value="userID"
                                                    display="businessName"
                                                    selected="#FORM.intRep#"
                                                    bind="cfc:extra.extensions.components.user.getIntlRepRemote({programID2})" /> 
											</td>
										</tr>
                                        <tr>
											<td class="style1" valign="top">Verification Received :</td>
											<td class="style1">
                                                <cfselect 
                                                    name="verification_received" 
                                                    id="verification_received2"
                                                    class="style1"
                                                    style="width:100px;"
                                                    multiple="yes"
                                                    size="10"
                                                    value="verificationReceived"
                                                    display="verificationReceivedDisplay"
                                                    selected="#FORM.verification_received#"
                                                    bind="cfc:extra.extensions.components.user.getVerificationDate({intRep2},{programID2})" /> 
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
			</table><br />
	
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="##C7CFDC">	
				<tr>
					<td width="100%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##FFFFFF">
							<tr bgcolor="##C2D1EF"><td class="style2" bgcolor="##8FB6C9">&nbsp;:: Insurance Management Screen</td></tr>
						</table>
					</td>
				</tr>
			</table><br />
	
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
											<td class="style1">
												<select name="transtype"  class="style1">
													<option value=""></option>
													<option value="new">New App</option>
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
			</table><br />	

			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="##C7CFDC">	
				<tr>
					<td width="100%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##FFFFFF">
							<tr bgcolor="##C2D1EF"><td class="style2" bgcolor="##8FB6C9" colspan="4">&nbsp;:: Insurance History - Excel Files</td></tr>
							<tr>
								<th width="10%" class="style1">Transaction Type</th>
								<th width="15%" class="style1">Filed Date</th>
								<th width="15%" class="style1">Total of Candidates</th>
                                <td width="20%"><strong>Actions</strong></td>
							</tr>
							<cfloop query="qGetHistory">
							<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
								<td align="center" class="style1">#transtype#</td>
								<td align="center" class="style1">#DateFormat(filed_date, 'mm/dd/yyyy')#</td>
								<td align="center" class="style1">#total#</td>
								<td align="center" class="style1">
                                	<a href="insurance/downloadFile.cfm?type=#URLEncodedFormat(qGetHistory.transType)#&date=#URLEncodedFormat(qGetHistory.input_date)#" class="style4">[ Download ]</a>
                                    &nbsp; | &nbsp;
                                    <a href="insurance/downloadFile.cfm?type=#URLEncodedFormat(qGetHistory.transType)#&date=#URLEncodedFormat(qGetHistory.input_date)#&option=list" class="style4" target="_blank">[ List ]</a>
                                </td>
							</tr>
							</cfloop>
						</table>
					</td>
				</tr>
			</table><br />
		</td>
	</tr>
</table>

</cfoutput>