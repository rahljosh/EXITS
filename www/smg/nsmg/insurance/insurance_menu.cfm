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
		qGetPrograms = APPCFC.PROGRAM.getPrograms(companyID=CLIENT.companyID, dateActive=1);
		
		//Get Insurance Policies
		qGetInsurancePolicies = APPCFC.INSURANCE.getInsurancePolicies(provider="global");
		
		// Get Insurance History
		//qGetInsuranceHistory = APPCFC.INSURANCE.getInsuranceHistory(companyID=CLIENT.companyID);
    </cfscript>
    
</cfsilent>

<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<script>
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
        <td background="pics/header_background.gif"><h2>Caremed Insurance - Excel files and Reports</h2></td>
        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<table border="0" cellpadding="8" cellspacing="2" width="100%" class="section">
	<tr>
    	<td>
        
			<!--- NEW TRANSACTION HEADER --->
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
                <tr><th colspan="2" bgcolor="##e2efc7"><span class="get_attention"><b>::</b></span> New Transaction</th></tr>
                <tr><td colspan="2" align="center"><font size="-2">Students with Flight Information</font></td></tr>
            </table>
		
			<!--- NEW TRANSACTION - FIRST ROW - 2 REPORTS --->
            <table cellpadding="6" cellspacing="0" align="center" width="96%">
                <tr>
                    <td width="50%" valign="top">
                        <form action="insurance/new_transaction_programID.cfm" method="POST">
                        <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
                            <tr><th colspan="2" bgcolor="##e2efc7">New Transaction - Based on Flight Information</th></tr>
                            <tr align="left">
                                <td>Program :</td>
                                <td>
                                	<select name="programID" size="6" multiple>
                                        <cfloop query="qGetPrograms">
                                        	<option value="#ProgramID#">#qGetPrograms.companyshort# - #qGetPrograms.programname#</option>
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
                                	End Date: Program Insurance End Date 
                                </td>
                            </tr>                            
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                        </table>
                        </form>
                    </td>
                    <td width="50%" valign="top">
						&nbsp;
                    </td>
                </tr>
            </table>
            
            <br><br>
	
			<!--- CORRECTION HEADER --->
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
            	<tr></tr><th colspan="2" bgcolor="##e2efc7"><span class="get_attention"><b>::</b></span> INSURANCE MANAGEMENT SCREEN</th></tr>
            </table><br>
	
			<!--- CORRECTION - FIRST ROW --->
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
            	<tr></tr><th colspan="2" bgcolor="##e2efc7"><span class="get_attention"><b>::</b></span> New Transaction</th></tr>
            </table>
            
            <table cellpadding="6" cellspacing="0" align="center" width="96%">
            <tr>
                <td width="50%" valign="top">
                    <cfform action="?curdoc=insurance/new_transaction_manual" method="POST">	
                    <table class="nav_bar" cellpadding="6" cellspacing="0" align="right" width="100%">
                    <tr><th colspan="2" bgcolor="##e2efc7">New Transaction</th></tr>
                        <tr align="left">
                            <td>Program :</td>
                            <td><select name="programID" size="1">
                                    <option value=00></option>
                                    <option value=0>All Programs</option>			
                                    <cfloop query="qGetPrograms"><option value="#ProgramID#"><cfif client.companyid EQ 5>#qGetPrograms.companyshort# - </cfif>#programname#</option></cfloop>
                                </select>
                            </td></tr>
                        <tr><td colspan="2" align="center">&nbsp;</td></tr>			
                        <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>			
                    </table>
                    </cfform>
                </td>
                <td width="50%" valign="top">
                    <cfform action="?curdoc=insurance/new_manual_update" method="POST">
                    <table class="nav_bar"  cellpadding="6" cellspacing="0" align="right" width="100%">
                        <tr><th colspan="2" bgcolor="##e2efc7">Update New Transactions</th></tr>
                        <tr align="left">
                            <td>Program :</td>
                            <td><select name="programID" size="1">
                                    <option value=1></option>
                                    <option value=0>All Programs</option>			
                                    <!--- <option value=0></option> --->
                                    <cfloop query="qGetPrograms"><option value="#ProgramID#"><cfif client.companyid EQ 5>#qGetPrograms.companyshort# - </cfif>#programname#</option></cfloop>
                                </select></td></tr>
                        <tr><td colspan="2" align="center"><font color="##CC0000"><b>* See Warning</b></font></td></tr>
                        <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/update.gif" align="center" border="0" onClick="return areYouSure(this);"></td></tr>
                    </table>
                    </cfform>
                </td>
            </tr>
            </table><br><br>

			<!--- CORRECTION HEADER --->
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
            <tr></tr><th colspan="2" bgcolor="##e2efc7"><span class="get_attention"><b>::</b></span> Correction</th></tr>
            </table>
            
            <table cellpadding="6" cellspacing="0" align="center" width="96%">
            <tr>
                <td width="50%" valign="top">
                    <cfform action="?curdoc=insurance/correction" method="POST">
                    <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
                        <tr><th colspan="2" bgcolor="##e2efc7">Correction</th></tr>
                        <tr align="left">
                            <td>Program :</td>
                            <td><select name="programID" size="1">
                                    <option value=0>All Programs</option>			
                                    <!--- <option value=0></option> --->
                                    <cfloop query="qGetPrograms"><option value="#ProgramID#"><cfif client.companyid EQ 5>#qGetPrograms.companyshort# - </cfif>#programname#</option></cfloop>
                                </select>
                            </td></tr>
                        <tr><td colspan="2" align="center">&nbsp;</td></tr>			
                        <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>			
                    </table>
                    </cfform>
                </td>
                <td width="50%" valign="top">
                    <cfform action="?curdoc=insurance/correction_update" method="POST">
                    <table class="nav_bar"  cellpadding="6" cellspacing="0" align="right" width="100%">
                        <tr><th colspan="2" bgcolor="##e2efc7">Update Correction Records</th></tr>
                        <tr align="left">
                            <td>Program :</td>
                            <td><select name="programID" size="1">
                                    <option value=1></option>
                                    <option value=0>All Programs</option>			
                                    <!--- <option value=0></option> --->
                                    <cfloop query="qGetPrograms"><option value="#ProgramID#"><cfif client.companyid EQ 5>#qGetPrograms.companyshort# - </cfif>#programname#</option></cfloop>
                                </select></td></tr>
                        <tr><td colspan="2" align="center"><font color="##CC0000"><b>* See Warning</b></font></td></tr>
                        <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/update.gif" align="center" border="0" onClick="return areYouSure(this);"></td></tr>
                    </table>
                    </cfform>
                </td>
            </tr>
            </table><br><br>
        
            <!--- EARLY RETURN HEADER ---><!--- EARLY RETURN - FIRST ROW --->
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
            <tr></tr><th colspan="2" bgcolor="##e2efc7"><span class="get_attention"><b>::</b></span> Early Return</th></tr>
            <tr><td colspan="2" align="center"><font size="-2">According to Flight Departure Info</font></td></tr>
            </table>
            
            <table cellpadding="6" cellspacing="0" align="center" width="96%">
            <tr>
                <td width="50%" valign="top">
                <cfform action="?curdoc=insurance/early_return" method="POST">
                    <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
                        <tr><th colspan="2" bgcolor="##e2efc7">Early Return</th></tr>
                        <tr align="left">
                            <td>Program :</td>
                            <td><select name="programID" size="1">
                                    <option value=0>All Programs</option>			
                                    <!--- <option value=0></option> --->
                                    <cfloop query="qGetPrograms"><option value="#ProgramID#"><cfif client.companyid EQ 5>#qGetPrograms.companyshort# - </cfif>#programname#</option></cfloop>
                                </select>
                            </td></tr>
                        <tr><td colspan="2" align="center">&nbsp;</td></tr>					
                        <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>			
                    </table>
                    </cfform>
                </td>
                <td width="50%" valign="top">
                <cfform action="?curdoc=insurance/early_return_update" method="POST"> 
                    <table class="nav_bar"  cellpadding="6" cellspacing="0" align="right" width="100%">
                        <tr><th colspan="2" bgcolor="##e2efc7">Update Early Return Records</th></tr>
                        <tr align="left">
                            <td>Program :</td>
                            <td><select name="programID" size="1">
                                    <option value=1></option>
                                    <option value=0>All Programs</option>			
                                    <!--- <option value=0></option> --->
                                    <cfloop query="qGetPrograms"><option value="#ProgramID#"><cfif client.companyid EQ 5>#qGetPrograms.companyshort# - </cfif>#programname#</option></cfloop>
                                </select></td></tr>
                        <tr><td colspan="2" align="center"><font color="##CC0000"><b>* See Warning</b></font></td></tr>
                        <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/update.gif" align="center" border="0" onClick="return areYouSure(this);"></td></tr>
                    </table>
                    </cfform>
                </td>
            </tr>
            </table><br><br>
        
            
            <!--- EXTENSION HEADER ---><!--- EXTENSION - FIRST ROW --->
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
            <tr></tr><th colspan="2" bgcolor="##e2efc7"><span class="get_attention"><b>::</b></span> Extension</th></tr>
            </table>
            
            <table cellpadding="6" cellspacing="0" align="center" width="96%">
            <tr>
                <td width="50%" valign="top">
                    <cfform action="?curdoc=insurance/extension" method="POST">
                    <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
                        <tr><th colspan="2" bgcolor="##e2efc7">Extension</th></tr>
                        <tr align="left">
                            <td>Program :</td>
                            <td><select name="programID" size="1">
                                    <option value=0>All Programs</option>			
                                    <!--- <option value=0></option> --->
                                    <cfloop query="qGetPrograms"><option value="#ProgramID#"><cfif client.companyid EQ 5>#qGetPrograms.companyshort# - </cfif>#programname#</option></cfloop>
                                </select></td></tr>
                        <tr><td colspan="2" align="center">&nbsp;</td></tr>					
                        <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>			
                    </table>
                    </cfform>
                </td>
                <td width="50%" valign="top">
                    <cfform action="?curdoc=insurance/extension_update" method="POST">
                    <table class="nav_bar"  cellpadding="6" cellspacing="0" align="right" width="100%">
                        <tr><th colspan="2" bgcolor="##e2efc7">Update Extension Records</th></tr>
                        <tr align="left">
                            <td>Program :</td>
                            <td><select name="programID" size="1">
                                    <option value=1></option>
                                    <option value=0>All Programs</option>			
                                    <!--- <option value=0></option> --->
                                    <cfloop query="qGetPrograms"><option value="#ProgramID#"><cfif client.companyid EQ 5>#qGetPrograms.companyshort# - </cfif>#programname#</option></cfloop>
                                </select></td></tr>
                        <tr><td colspan="2" align="center"><font color="##CC0000"><b>* See Warning</b></font></td></tr>
                        <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/update.gif" align="center" border="0" onClick="return areYouSure(this);"></td></tr>
                    </table>
                    </cfform>
                </td>
            </tr>
            </table><br><br>
            
            <!--- CANCELATION HEADER ---> <!--- CANCELATION - FIRST ROW --->
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
            <tr></tr><th colspan="2" bgcolor="##e2efc7"><span class="get_attention"><b>::</b></span> Cancelation</th></tr>
            <tr><td colspan="2" align="center"><font size="-2">Students must be inactive (canceled) and must have insurance info (insured date)</font></td></tr>
            </table>
            
            <table cellpadding="6" cellspacing="0" align="center" width="96%">
            <tr>
                <td width="50%" valign="top">
                    <cfform action="?curdoc=insurance/cancelation" method="POST">
                    <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
                        <tr><th colspan="2" bgcolor="##e2efc7">Cancelation</th></tr>
                        <tr align="left">
                            <td>Program :</td>
                            <td><select name="programID" size="1">
                                    <option value=1></option>
                                    <option value=0>All Programs</option>			
                                    <!--- <option value=0></option> --->
                                    <cfloop query="qGetPrograms"><option value="#ProgramID#"><cfif client.companyid EQ 5>#qGetPrograms.companyshort# - </cfif>#programname#</option></cfloop>
                                </select></td></tr>
                        <tr><td colspan="2" align="center">&nbsp;</td></tr>					
                        <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>			
                    </table>
                    </cfform>
                </td>
                <td width="50%" valign="top">
                    <cfform action="?curdoc=insurance/cancelation_update" method="POST">
                    <table class="nav_bar"  cellpadding="6" cellspacing="0" align="right" width="100%">
                        <tr><th colspan="2" bgcolor="##e2efc7">Update Cancelation Records</th></tr>
                        <tr align="left">
                            <td>Program :</td>
                            <td><select name="programID" size="1">
                                    <option value='zero'></option>
                                    <option value=0>All Programs</option>			
                                    <!--- <option value=0></option> --->
                                    <cfloop query="qGetPrograms"><option value="#ProgramID#"><cfif client.companyid EQ 5>#qGetPrograms.companyshort# - </cfif>#programname#</option></cfloop>
                                </select></td></tr>
                        <tr><td colspan="2" align="center"><font color="##CC0000"><b>* See Warning</b></font></td></tr>
                        <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/update.gif" align="center" border="0" onClick="return areYouSure(this);"></td></tr>
                    </table>
                    </cfform>
                </td>
            </tr>
            </table><br><br>
	
	<!--- CREATE EXTENSION / EARLY RETURN ACCORDING TO FLIGHT  --->
	<table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
	<tr></tr><th colspan="2" bgcolor="##e2efc7"><span class="get_attention"><b>::</b></span> Extensions / Early Returns According to Flight Info.</th></tr>
	</table>
	
	<table cellpadding="6" cellspacing="0" align="center" width="96%">
	<tr>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/upd_corrections" method="POST">
			<table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
				<tr><th colspan="2" bgcolor="##e2efc7">Create Corrections According to Flight</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><cfselect name="programID" size="5" multiple required="yes" message="Please select a program.">
							<cfloop query="qGetPrograms"><option value="#ProgramID#"><cfif client.companyid EQ 5>#qGetPrograms.companyshort# - </cfif>#programname#</option></cfloop>
						</cfselect>
					</td>
				</tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>			
			</table>
			</cfform>		
		</td>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/upd_extensions" method="POST">
			<table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
				<tr><th colspan="2" bgcolor="##e2efc7">Create Extensions / New Transactions / Early Returns Data</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><cfselect name="programID" size="5" multiple required="yes" message="Please select a program.">
							<cfloop query="qGetPrograms"><option value="#ProgramID#"><cfif client.companyid EQ 5>#qGetPrograms.companyshort# - </cfif>#programname#</option></cfloop>
						</cfselect>
					</td>
				</tr>
				<tr><td><cfinput type="checkbox" name="manual"> Extension Date:</td><td><cfinput name="extensiondate" size="7" validate="date" maxlength="10"> mm/dd/yyyy</td></tr>
				<tr><td colspan="2" align="center">Use an extension date for kids with no flight information.</td></tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>			
			</table>
			</cfform>
		</td>
	</tr>
	</table><br><br>
	
	<table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
	<tr><th colspan="7" bgcolor="##e2efc7">
		<span class="get_attention"><b>::</b></span> New Transaction Insurance History &nbsp; &nbsp;
		<Cfif URL.history is 'no'>
			<a href="index.cfm?curdoc=insurance/insurance_menu&history=yes">(show list)</a>
		<cfelseif URL.history is 'yes'>
			<a href="index.cfm?curdoc=insurance/insurance_menu&history=no">(hide list)</a>
		</Cfif>
	</th></tr>
	<cfif VAL(URL.history)>
		<tr bgcolor="##e2efc7">
			<td width="20%" align="left"><b>Date Insured</b></td>
			<td width="20%" align="center"><b>Total of Students</b></td>
			<td width="20%" align="center"><b>Batch ID</b></td>			
			<td width="20%" align="center"><b>Excel File</b></td>
		</tr>
		<cfloop query="qGetInsuranceHistory">
			<tr bgcolor="#iif(qGetInsuranceHistory.currentrow MOD 2 ,DE("white") ,DE("ededed"))#">
				<td align="left"><a href="insurance/insurance_list.cfm?insudate=#DateFormat(insurance, 'yyyy-mm-dd')#" target="_blank">#DateFormat(insurance, 'mm/dd/yyyy')#</a></td>
				<td align="center"><a href="insurance/insurance_list.cfm?insudate=#DateFormat(insurance, 'yyyy-mm-dd')#" target="_blank">#total#</a></td>
				<td align="center"><a href="insurance/insurance_excel_list.cfm?insudate=#DateFormat(insurance, 'yyyy-mm-dd')#" target="_blank"><img src="pics/excelico.jpg" border="0"></a></td>
			</tr>
		</cfloop>
		<tr><td colspan="4">* Click in the link(s) above to see the list of students.</td></tr>  
	</cfif>
	</table><br>

<cfif client.usertype EQ '1'>
	<table cellpadding="6" cellspacing="0" align="center" width="96%">
	<tr>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/upd_corrections_no_flight" method="POST">
			<table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="##e2efc7">Update Insurance Dates</th></tr>
				<tr><td colspan="2">Update all students that do not have flight arrival information</td></tr>
					<tr align="left">
						<td>Program :</td>
						<td><cfselect name="programID" multiple  size="6">
					<cfloop query="qGetPrograms"><option value="#ProgramID#"><cfif client.companyid EQ 5>#qGetPrograms.companyshort# - </cfif>#programname#</option></cfloop></cfselect></td></tr>
					<tr align="left">
						<td>New Start Date :</td><td><cfinput type="text" size="7" name="newdate" required="yes" message="You must enter a date" validate="date"></td>
					</tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
			</table>
			</cfform>	
		</td>
		
		<td width="50%" valign="top">&nbsp;
					
		</td>
	</tr>
	</table>
</cfif>

</td></tr>
</table>

</cfoutput>
<cfinclude template="../table_footer.cfm">