<!--- ------------------------------------------------------------------------- ----
	
	File:		insurance_menu.cfm
	Author:		Marcus Melo
	Date:		January 06, 2010
	Desc:		Manages Insurance Information

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param URL Variables --->
	<cfparam name="URL.history" default="no">
    
	<cfscript>
		// Get Programs
		qGetPrograms = APPCFC.PROGRAM.getPrograms(dateActive=1);
		
		//Get Insurance Policies
		qGetInsurancePolicies = APPCFC.INSURANCE.getInsurancePolicies(provider="global");
		
		// Get Insurance History
		//qGetInsuranceHistory = APPCFC.INSURANCE.getInsuranceHistory(companyID=CLIENT.companyID);
    </cfscript>
    
</cfsilent>

<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<script type="text/javascript" language="javascript">
	//Confirm Update
	function areYouSure() { 
	   if(confirm("You're about to update the records, this can not be undone, are you sure?")) { 
		 form.submit(); 
			return true; 
	   } else { 
			return false; 
	   } 
	} 
</script>		

<cfoutput>

<table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
    <tr valign="middle" height="24">
        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
        <td width="26" background="pics/header_background.gif"><img src="pics/students.gif"></td>
        <td background="pics/header_background.gif"><h2>Insurance - Excel files and Reports</h2></td>
        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<table border="0" cellpadding="8" cellspacing="2" width="100%" class="section">
	<tr>
    	<td>
        
			<!--- NEW TRANSACTION HEADER --->
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
                <tr><th colspan="2" bgcolor="##e2efc7"><span class="get_attention"><b>::</b></span> New Transaction</th></tr>
            </table>
		
			<!--- NEW TRANSACTION - FIRST ROW - 2 REPORTS --->
            <table cellpadding="6" cellspacing="0" align="center" width="96%">
                <tr>
                    <td width="50%" valign="top">
                        <form action="insurance/newTransactionProgramID.cfm" method="POST">
                            <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
                                <tr><th colspan="2" bgcolor="##e2efc7">New Transaction - Based on Flight Arrival Information</th></tr>
                                <tr align="left">
                                    <td>Program :</td>
                                    <td>
                                        <select name="programID" size="6" multiple>
                                            <cfloop query="qGetPrograms">
                                                <option value="#ProgramID#">#qGetPrograms.programname#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr align="left">
                                    <td>Policy Type :</td>
                                    <td>
                                        <select name="policyID">
                                            <option value="0"></option>
                                            <cfloop query="qGetInsurancePolicies">
                                                <option value="#insuTypeID#">#qGetInsurancePolicies.type#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        Start Date: Arrival Date <br>
                                        End Date: Program End Date 
                                    </td>
                                </tr>      
                                <tr>
                                    <td colspan="2">
                                        <cfif ListFind("1,2,3,4,12", CLIENT.companyID)>
                                        	PS: Change companies to SMG to get all ISE students.
                                        <cfelseif CLIENT.companyID EQ 5>
											PS: All ISE students will be included (Bill, Margarita, Diana, Gary and Brian divisions).
										</cfif>
                                    </td>
                                </tr>                            
                                <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                            </table>
                        </form>
                    </td>
                    <td width="50%" valign="top">
                        <form action="insurance/newTransactionProgramID.cfm" method="POST">
                        	<input type="hidden" name="noFlight" value="1" />
                            <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
                                <tr><th colspan="2" bgcolor="##e2efc7">New Transaction - Based on Given Start Date</th></tr>
                                <tr align="left">
                                    <td>Program :</td>
                                    <td>
                                        <select name="programID" size="6" multiple>
                                            <cfloop query="qGetPrograms">
                                                <option value="#ProgramID#">#qGetPrograms.programname#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr align="left">
                                    <td>Policy Type :</td>
                                    <td>
                                        <select name="policyID">
                                            <option value="0"></option>
                                            <cfloop query="qGetInsurancePolicies">
                                                <option value="#insuTypeID#">#qGetInsurancePolicies.type#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr align="left">
                                    <td>Start Date :</td>
                                    <td><input type="text" name="startDate" class="date-pick" /></td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        Start Date: Today's Date or Given Date <br>
                                        End Date: Program End Date 
                                    </td>
                                </tr>                            
                                <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                            </table>
                        </form>
                    </td>
                </tr>
            </table>
            
            <br><br>
			
            <!--- Return Date Correction --->
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
                <tr><th colspan="2" bgcolor="##e2efc7"><span class="get_attention"><b>::</b></span> Return Date Correction</th></tr>
                <tr><td colspan="2" align="center"><font size="-2">Active students returning home at the end of the program</font></td></tr>
            </table>
            
            <table cellpadding="6" cellspacing="0" align="center" width="96%">
                <tr>
                    <td width="50%" valign="top">
                        <form action="insurance/earlyReturn.cfm" method="POST">
                            <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
                                <tr><th colspan="2" bgcolor="##e2efc7">Return Date Correction - Based on Flight Departure Information</th></tr>
                                <tr align="left">
                                    <td>Program :</td>
                                    <td>
                                    	<select name="programID" size="6" multiple>
                                            <cfloop query="qGetPrograms"><option value="#ProgramID#">#programname#</option></cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr align="left">
                                    <td>Policy Type :</td>
                                    <td>
                                        <select name="policyID">
                                            <option value="0"></option>
                                            <cfloop query="qGetInsurancePolicies">
                                                <option value="#insuTypeID#">#qGetInsurancePolicies.type#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr><td colspan="2" align="center">&nbsp;</td></tr>					
                                <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>			
                            </table>
                        </form>
                    </td>
                    <td width="50%" valign="top">&nbsp;
                        
                    </td>
                </tr>
            </table>
            
            <br><br>

            <!--- Cancelation --->
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
                <tr><th colspan="2" bgcolor="##e2efc7"><span class="get_attention"><b>::</b></span> Cancelation</th></tr>
                <tr><td colspan="2" align="center"><font size="-2">Canceled insured students that withdrew the program</font></td></tr>
            </table>
            
            <table cellpadding="6" cellspacing="0" align="center" width="96%">
                <tr>
                    <td width="50%" valign="top">
                        <form action="insurance/cancelationProgramID.cfm" method="POST">
                            <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
                                <tr><th colspan="2" bgcolor="##e2efc7">Cancelation - Based on cancelation date</th></tr>
                                <tr align="left">
                                    <td>Program :</td>
                                    <td>
                                    	<select name="programID" size="6" multiple>
                                            <cfloop query="qGetPrograms"><option value="#ProgramID#">#programname#</option></cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr><td colspan="2" align="center">&nbsp;</td></tr>					
                                <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>			
                            </table>
                        </form>
                    </td>
                    <td width="50%" valign="top">&nbsp;
                        
                    </td>
                </tr>
            </table>
            
            <br><br>
            
            <!--- Insurance History --->
                   
		</td>
	</tr>
</table>

</cfoutput>
<cfinclude template="../table_footer.cfm">