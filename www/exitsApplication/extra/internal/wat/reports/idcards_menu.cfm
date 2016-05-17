<!--- ------------------------------------------------------------------------- ----
	
	File:		idcards_menu.cfm
	Author:		Marcus Melo
	Date:		January 10, 2011
	Desc:		ID Cards Menu

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <!--- Param variables --->
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.intRep" default="0">
    <cfparam name="FORM.verification_received" default="">
    <cfparam name="FORM.submitted" default="0">

</cfsilent>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="##ffffff">
	<tr>
		<td bordercolor="##ffffff">
			<!----Header Table---->
			<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="##E4E4E4">
				<tr bgcolor="##E4E4E4">
					<td class="title1">&nbsp; &nbsp; ID Cards Menu</td>
				</tr>
			</table><br>
			
			<!--- ID CARDS --->
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="##C7CFDC">	
				<tr>
					<td width="49%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
							<tr>
								<td bordercolor="##ffffff" valign="top">
                                    <cfform name="idCardsAvery5371" action="reports/idcards_per_intl_rep.cfm" method="post" target="_blank">
                                        <table width="100%" cellpadding=3 cellspacing=0 border=0>
                                            <tr bgcolor="##C2D1EF"><td class="style2" bgcolor="##8FB6C9" colspan="2">&nbsp;:: ID Cards - Avery 5371</td></tr>
                                            <tr>
                                                <td class="style1" valign="top" align="right"><b>Program:</b></td>
                                                <td class="style1" align="left">
                                                    <cfselect
                                                        name="programID" 
                                                        id="programID"
                                                        size="7"
                                                        multiple="yes"
                                                        class="style1"
                                                        value="programID"
                                                        display="programname"
                                                        selected="#FORM.programID#"
                                                        bind="cfc:extensions.components.program.getProgramsRemote()" 
                                                        bindonload="true" /> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right"><b>Intl. Rep.:</b></td>
                                                <td class="style1" align="left">
                                                    <cfselect
                                                        name="intRep" 
                                                        id="intRep"
                                                        class="style1"
                                                        value="userID"
                                                        display="businessName"
                                                        selected="#FORM.intRep#"
                                                        bind="cfc:extensions.components.user.getIntlRepRemote({programID})" /> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right"><b>DS Verification Received:</b></td>
                                                <td class="style1" align="left">
                                                    <cfselect 
                                                        name="verification_received" 
                                                        id="verification_received"
                                                        class="style1"
                                                        value="verificationReceived"
                                                        display="verificationReceived"
                                                        selected="#FORM.verification_received#"
                                                        bind="cfc:extensions.components.user.getVerificationDate({intRep},{programID})" /> 
                                                </td>
                                            </tr>
                                            <tr><td align="center" colspan="2"><cfinput type="image" name="submit" value=" Submit " src="../pics/view.gif"></td></tr>
										</table>
                                    </cfform>	
								</td>
							</tr>
						</table>
					</td>
					<td width="2%" valign="top">&nbsp;</td>
					<td width="49%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
							<tr>
								<td bordercolor="##ffffff" valign="top">
                                	<cfform name="idCardsList" action="reports/idcards_list.cfm" method="post" target="_blank">
                                        <table width="100%" cellpadding=3 cellspacing=0 border=0>
                                            <tr bgcolor="##C2D1EF"><td class="style2" bgcolor="##8FB6C9" colspan="2">&nbsp;:: ID Cards List</td></tr>
                                            <tr>
                                                <td class="style1" valign="top" align="right"><b>Program:</b></td>
                                                <td class="style1" align="left">
                                                    <cfselect
                                                        name="programID" 
                                                        id="programID2"
                                                        size="7"
                                                        multiple="yes"
                                                        class="style1"
                                                        value="programID"
                                                        display="programName"
                                                        selected="#FORM.programID#"
                                                        bind="cfc:extensions.components.program.getProgramsRemote()" 
                                                        bindonload="true" /> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right"><b>Intl. Rep.:</b></td>
                                                <td class="style1" align="left">
                                                    <cfselect
                                                        name="intRep" 
                                                        id="intRep2"
                                                        class="style1"
                                                        value="userID"
                                                        display="businessName"
                                                        selected="#FORM.intRep#"
                                                        bind="cfc:extensions.components.user.getIntlRepRemote({programID2})" /> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right"><b>DS Verification Received:</b></td>
                                                <td class="style1" align="left">
                                                    <cfselect 
                                                        name="verification_received" 
                                                        id="verification_received2"
                                                        class="style1"
                                                        value="verificationReceived"
                                                        display="verificationReceived"
                                                        selected="#FORM.verification_received#"
                                                        bind="cfc:extensions.components.user.getVerificationDate({intRep2},{programID2})" /> 
                                                </td>
                                            </tr>										
                                            <tr><td align="center" colspan="2"><cfinput type="image" name="submit" value=" Submit " src="../pics/view.gif"></td></tr>
										</table>
                                    </cfform>	
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table><br>
            
            
			<!--- INSURANCE ID CARDS --->
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="##C7CFDC">	
				<tr>
					<td width="49%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
							<tr>
								<td bordercolor="##ffffff" valign="top">
	                                <cfform name="InsuranceCards" action="reports/insurance_cards.cfm" method="post" target="_blank">
                                        <table width="100%" cellpadding=3 cellspacing=0 border=0>
                                            <tr bgcolor="##C2D1EF"><td class="style2" bgcolor="##8FB6C9" colspan="2">&nbsp;:: Insurance ID Cards</td></tr>
                                            <tr>
                                                <td class="style1" valign="top" align="right"><b>Program:</b></td>
                                                <td class="style1" align="left">
                                                    <cfselect
                                                        name="programID" 
                                                        id="programID3"
                                                        size="7"
                                                        multiple="yes"
                                                        class="style1"
                                                        value="programID"
                                                        display="programName"
                                                        selected="#FORM.programID#"
                                                        bind="cfc:extensions.components.program.getProgramsRemote()" 
                                                        bindonload="true" /> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right"><b>Intl. Rep.:</b></td>
                                                <td class="style1" align="left">
                                                    <cfselect
                                                        name="intRep" 
                                                        id="intRep3"
                                                        class="style1"
                                                        value="userID"
                                                        display="businessName"
                                                        selected="#FORM.intRep#"
                                                        bind="cfc:extensions.components.user.getIntlRepRemote({programID3})" /> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right"><b>DS Verification Received:</b></td>
                                                <td class="style1" align="left">
                                                    <cfselect 
                                                        name="verification_received" 
                                                        id="verification_received3"
                                                        class="style1"
                                                        value="verificationReceived"
                                                        display="verificationReceived"
                                                        selected="#FORM.verification_received#"
                                                        bind="cfc:extensions.components.user.getVerificationDate({intRep3},{programID3})" /> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" colspan="2">
                                                    Set margins to: <br><br>
                                                    IE: top: 0.5 / bottom: 0.4 / left: 0.7 / right: 0.5 <br><br>                                                
                                                    Firefox: top: 0.3 / bottom: 0.3 / left: 0.5 / right: 0.5 <br><br>                                                
                                                    Make sure you set page scaling to: Shrink to Printable Area <br><br>
                                                </td>
                                            </tr>
                                            <tr><td align="center" colspan="2"><cfinput type="image" name="submit" value=" Submit " src="../pics/view.gif"></td></tr>
                                        </table>
                                	</cfform>	     
								</td>
							</tr>
						</table>
					</td>
					<td width="2%" valign="top">&nbsp;</td>
					<td width="49%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
							<tr>
								<td bordercolor="##ffffff" valign="top">
                                    <cfform name="InsuranceCardsPDF" action="reports/insurance_cards_pdf.cfm" method="post" target="_blank">
                                        <table width="100%" cellpadding=3 cellspacing=0 border=0>
                                            <tr bgcolor="##C2D1EF"><td class="style2" bgcolor="##8FB6C9" colspan="2">&nbsp;:: Insurance ID Cards - PDF File</td></tr>
                                            <tr>
                                                <td class="style1" valign="top" align="right"><b>Program:</b></td>
                                                <td class="style1" align="left">
                                                    <cfselect
                                                        name="programID" 
                                                        id="programID4"
                                                        size="7"
                                                        multiple="yes"
                                                        class="style1"
                                                        value="programID"
                                                        display="programName"
                                                        selected="#FORM.programID#"
                                                        bind="cfc:extensions.components.program.getProgramsRemote()" 
                                                        bindonload="true" /> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right"><b>Intl. Rep.:</b></td>
                                                <td class="style1" align="left">
                                                    <cfselect
                                                        name="intRep" 
                                                        id="intRep4"
                                                        class="style1"
                                                        value="userID"
                                                        display="businessName"
                                                        selected="#FORM.intRep#"
                                                        bind="cfc:extensions.components.user.getIntlRepRemote({programID4})" /> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right"><b>DS Verification Received:</b></td>
                                                <td class="style1" align="left">
                                                    <cfselect 
                                                        name="verification_received" 
                                                        id="verification_received4"
                                                        class="style1"
                                                        value="verificationReceived"
                                                        display="verificationReceived"
                                                        selected="#FORM.verification_received#"
                                                        bind="cfc:extensions.components.user.getVerificationDate({intRep4},{programID4})" /> 
                                                </td>
                                            </tr>
                                            <tr><td align="center" colspan="2"><cfinput type="image" name="submit" value=" Submit " src="../pics/view.gif"></td></tr>
                                        </table>
                                    </cfform>	                                        
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
