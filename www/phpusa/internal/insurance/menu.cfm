<!--- ------------------------------------------------------------------------- ----
	
	File:		menu.cfm
	Author:		Marcus Melo
	Date:		August 03, 2010
	Desc:		Insurance Menu Options

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <cfinclude template="../querys/get_programs.cfm">

	<cfscript>
		//Get Insurance Policies
		qGetInsurancePolicies = APPCFC.INSURANCE.getInsurancePolicies(provider="global");
		
		// Get Insurance History
		qGetInsuranceHistory = APPCFC.INSURANCE.getInsuranceHistory();
    </cfscript>

</cfsilent>

<cfoutput>

<table width="90%" class="nav_bar" cellpadding="3" cellspacing="0" align="center">
	<tr>
    	<td bgcolor="##C4CDE7"><b>I N S U R A N C E</b></td>
    </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" width="90%" align="center">
	<tr>
    	<td>

			<!--- ROW 1 - 2 boxes --->
            <table cellpadding="3" cellspacing="0" align="center" width="100%">
                <tr>
                    <td width="50%" valign="top">
                        <form action="insurance/new_transaction_programID.cfm" method="post" target="blank">
                        <table cellpadding="3" cellspacing="0" width="100%">
                            <tr><th colspan="2" bgcolor="##C4CDE7">New Transaction - Based on Flight Arrival Information</th></tr>
                            <tr align="left">
                                <td>Program :</td>
                                <td>
                                    <select name="programID" size="6" multiple>
                                        <cfloop query="get_programs">
                                            <option value="#get_programs.ProgramID#">#get_programs.programname#</option>
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
                                            <option value="#qGetInsurancePolicies.insuTypeID#">#qGetInsurancePolicies.type#</option>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    Start Date: Arrival Date <br />
                                    End Date: Program End Date 
                                </td>
                            </tr>      
                            <tr><td colspan="2" align="center" bgcolor="##C4CDE7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                        </table>
                        </form>
                    </td>
                    <td width="50%" valign="top">
                        <form action="insurance/new_transaction_programID.cfm" method="post" target="blank">
                        <input type="hidden" name="noFlight" value="1" />
                        <table cellpadding="3" cellspacing="0" width="100%">
                            <tr><th colspan="2" bgcolor="##C4CDE7">New Transaction - Based on Given Start Date</th></tr>
                            <tr align="left">
                                <td>Program :</td>
                                <td>
                                    <select name="programID" size="6" multiple>
                                        <cfloop query="get_programs">
                                            <option value="#get_programs.ProgramID#">#get_programs.programname#</option>
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
                                            <option value="#qGetInsurancePolicies.insuTypeID#">#qGetInsurancePolicies.type#</option>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr>
                            <tr align="left">
                                <td>Start Date :</td>
                                <td><input type="text" name="startDate" class="date-pick" maxlength="10" /></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    Start Date: Given Date <br />
                                    End Date: Program End Date 
                                </td>
                            </tr>                            
                            <tr><td colspan="2" align="center" bgcolor="##C4CDE7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                        </table>
                        </form>
                    </td>
                </tr>
            </table><br />
	

			<!--- ROW 1 - 2 boxes --->
            <table cellpadding="3" cellspacing="0" align="center" width="100%">
                <tr>
                    <td valign="top">
                        <table cellpadding="3" cellspacing="0" width="100%">
                            <tr bgcolor="##C4CDE7">
                            	<th colspan="4">New Transaction History</th>
                            </tr>
                            <tr align="left">
                                <td width="20%"><strong>Date Created</strong></td>
                                <td width="40%"><strong>File Name</strong></td>
                                <td width="20%"><strong>Total of Students</strong></td>
                                <td width="20%"><strong>Actions</strong></td>
                            </tr>
                            <cfloop query="qGetInsuranceHistory">
                            	<tr>
                                	<td>#DateFormat(qGetInsuranceHistory.date, 'mm/dd/yyyy')#</td>
                                    <td>#qGetInsuranceHistory.file#</td>
                                    <td>#qGetInsuranceHistory.totalStudents#</td>
                                    <td><a href="index.cfm?curdoc=insurance/download_file&file=#URLEncodedFormat(qGetInsuranceHistory.file)#&date=#URLEncodedFormat(DateFormat(qGetInsuranceHistory.date, 'mm/dd/yyyy'))#">[ Download ]</a></td>
								</tr>                            
                            </cfloop>
                        </table>
                    </td>
                </tr>
            </table><br />
    
		</td>
	</tr>
</table><br />

</cfoutput>