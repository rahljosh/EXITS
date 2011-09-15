<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
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
		
		// Get Programs Ending Soon
		qGetProgramsEndingSoon = APPCFC.PROGRAM.getPrograms(isEndingSoon=1);

		// Get Programs Ending Soon
		qGetYearPrograms = APPCFC.PROGRAM.getPrograms(dateActive=1,isFullYear=1);

		//Get Insurance Policies
		qGetInsurancePolicies = APPCFC.INSURANCE.getInsurancePolicies(provider="global");
		
		// Get Insurance History
		qGetInsuranceHistory = APPCFC.INSURANCE.getInsuranceHistory(companyID=CLIENT.companyID);
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
                <tr><th bgcolor="##e2efc7"><span class="get_attention"><b>::</b></span> Enrollment Lists</th></tr>
                <tr><td align="center">Enroll New Students</td></tr>
                <tr>
                    <td align="center">
                        <cfif ListFind("1,2,3,4,12", CLIENT.companyID)>
                            PS: Change companies to SMG to get all ISE students.
                        <cfelseif CLIENT.companyID EQ 5>
                            PS: All ISE students will be included (Bill, Margarita, Diana, Gary and Brian divisions).
                        </cfif>
                    </td>
                </tr>                            
            </table>
		
			<!--- NEW TRANSACTION - FIRST ROW - 2 REPORTS --->
            <table cellpadding="0" cellspacing="0" align="center" width="95%" style="margin-top:5px;">
                <tr>
                    <td width="50%" valign="top" align="left">
                        <form action="insurance/newTransactionProgramID.cfm" method="POST">
                            <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="98%">
                                <tr><th colspan="2" bgcolor="##e2efc7">Enroll Students - Based on Flight Arrival Information</th></tr>
                                <tr align="left">
                                    <td valign="top">Program :</td>
                                    <td>
                                        <select name="programID" size="6" multiple>
                                            <cfloop query="qGetPrograms">
                                                <option value="#qGetPrograms.ProgramID#">#qGetPrograms.programName#</option>
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
                                <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                            </table>
                        </form>
                    </td>
                    <td width="50%" valign="top" align="right">
                        <form action="insurance/newTransactionProgramID.cfm" method="POST">
                        	<input type="hidden" name="noFlight" value="1" />
                            <table class="nav_bar" cellpadding="6" cellspacing="0" align="right" width="98%">
                                <tr><th colspan="2" bgcolor="##e2efc7">Enroll Students - Based on Given Start Date</th></tr>
                                <tr align="left">
                                    <td valign="top">Program :</td>
                                    <td>
                                        <select name="programID" size="6" multiple>
                                            <cfloop query="qGetPrograms">
                                                <option value="#qGetPrograms.ProgramID#">#qGetPrograms.programName#</option>
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
                                    <td><input type="text" name="startDate" class="datePicker" /></td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        Start Date: Today's Date or Given Date <br />
                                        End Date: Program End Date 
                                    </td>
                                </tr>                            
                                <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                            </table>
                        </form>
                    </td>
                </tr>
            </table>

            <br /><br />
						
            <!--- Return Date Correction --->
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
                <tr><th bgcolor="##e2efc7"><span class="get_attention"><b>::</b></span> Return Date / Cancelation </th></tr>
                <tr><td align="center">Active students returning home at the end of program before insurance end date</td></tr>
            </table>
            
            <table cellpadding="0" cellspacing="0" align="center" width="95%" style="margin-top:5px;">
                <tr>
                    <td width="50%" valign="top" align="left">
                        <form action="insurance/earlyReturn.cfm" method="POST">
                            <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="98%">
                                <tr><th colspan="2" bgcolor="##e2efc7">Return Date Correction - Based on Flight Departure Information</th></tr>
                                <tr align="left">
                                    <td valign="top">Program :</td>
                                    <td>
                                    	<select name="programID" size="6" multiple>
                                            <cfloop query="qGetProgramsEndingSoon">
                                            	<option value="#qGetProgramsEndingSoon.ProgramID#">#qGetProgramsEndingSoon.programName#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr><td colspan="2" align="center">&nbsp;</td></tr>					
                                <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>			
                            </table>
                        </form>
                    </td>
                    <td width="50%" valign="top" align="right">
                        <form action="insurance/cancelationProgramID.cfm" method="POST">
                            <table class="nav_bar" cellpadding="6" cellspacing="0" align="right" width="98%">
                                <tr><th colspan="2" bgcolor="##e2efc7">Cancel Insurance - Based on cancelation / withdrew date</th></tr>
                                <tr align="left">
                                    <td valign="top">Program :</td>
                                    <td>
                                    	<select name="programID" size="6" multiple>
                                            <cfloop query="qGetPrograms">
                                            	<option value="#qGetPrograms.ProgramID#">#qGetPrograms.programName#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr><td colspan="2" align="center">&nbsp;</td></tr>					
                                <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>			
                            </table>
                        </form>
                    </td>
                </tr>
            </table>
            
            <br /><br />

            <!--- Program Extension Correction --->
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
                <tr><th bgcolor="##e2efc7"><span class="get_attention"><b>::</b></span> Extension</th></tr>
                <tr>
                	<td align="center">
                		Active students that extended their program from 5 to 10 month or students with a flight departure beyond the insurance end date. 
                        <br />
                        PS: Students are insured until the last day of the program. They must purchase their own insurance beyond the program end date.
                    </td>
                </tr>
            </table>
            
            <table cellpadding="0" cellspacing="0" align="center" width="95%" style="margin-top:5px;">
                <tr>
                    <td width="50%" valign="top" align="left">
                        <form action="insurance/extensionProgramID.cfm" method="POST">
                            <input type="hidden" name="type" value="flightDeparture" />
                            <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="98%">
                                <tr><th colspan="2" bgcolor="##e2efc7">Insurance Extension - Based on Flight Departure Information</th></tr>
                                <tr align="left">
                                    <td valign="top">Program :</td>
                                    <td>
                                    	<select name="programID" size="6" multiple>
                                            <cfloop query="qGetProgramsEndingSoon">
                                            	<option value="#qGetProgramsEndingSoon.ProgramID#">#qGetProgramsEndingSoon.programName#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr><td colspan="2" align="center">&nbsp;</td></tr>					
                                <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>			
                            </table>
                        </form>
                    </td>
                    <td width="50%" valign="top" align="right">
                        <form action="insurance/extensionProgramID.cfm" method="POST">
                        	<input type="hidden" name="type" value="programExtension" />
                            <table class="nav_bar" cellpadding="6" cellspacing="0" align="right" width="98%">
                                <tr><th colspan="2" bgcolor="##e2efc7">Insurance Extension - Based on Program Extension (5 to 10 month)</th></tr>
                                <tr align="left">
                                    <td valign="top">Program :</td>
                                    <td>
                                    	<select name="programID" size="6" multiple>
                                            <cfloop query="qGetYearPrograms">
                                            	<option value="#qGetYearPrograms.ProgramID#">#qGetYearPrograms.programName#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr><td colspan="2" align="center">&nbsp;</td></tr>					
                                <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>			
                            </table>
                        </form>
                    </td>
                </tr>
            </table>

            <br /><br />

            <!--- REPORTS --->
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
                <tr><th bgcolor="##e2efc7"><span class="get_attention"><b>::</b></span> Reports</th></tr>
            </table>
            
            <table cellpadding="0" cellspacing="0" align="center" width="95%" style="margin-top:5px;">
                <tr>
                    <td width="50%" valign="top" align="left">
                        <form action="index.cfm?curdoc=insurance/studentsMissingCoverageReport" method="POST">
                            <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="98%">
                                <tr><th colspan="2" bgcolor="##e2efc7">Active Students Missing Insurance Coverage</th></tr>
                                <tr align="left">
                                    <td valign="top">Program :</td>
                                    <td>
                                    	<select name="programID" size="6" multiple>
                                            <cfloop query="qGetPrograms">
                                            	<option value="#qGetPrograms.ProgramID#">#qGetPrograms.programName#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                                <tr><td colspan="2" align="center">&nbsp;</td></tr>					
                                <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>			
                            </table>
                        </form>
                    </td>
                    <td width="50%" valign="top" align="right">&nbsp;</td>
                </tr>
            </table>

            <br /><br />
                        
            <!--- Insurance History --->
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
                <tr><th bgcolor="##e2efc7"><span class="get_attention"><b>::</b></span> Insurance Files History (Last 30 files)</th></tr>
                <tr><td align="center">Types: N = New | R = Return/Adjustment | X = Cancelation | EX = Extension Program</td></tr>
            </table>
            
            <table cellpadding="0" cellspacing="0" align="center" width="95%" style="margin-top:5px;">
                <tr>
                    <td width="100%" valign="top">

                        <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
                            <tr bgcolor="##e2efc7" style="font-weight:bold;">
                                <td>Date Created</td>
                                <td>Type</td>
                                <td>File Name</td>
                                <td align="center">Total of Students</td>
                                <td align="center">Actions</td>
                            </tr>
                            <cfloop query="qGetInsuranceHistory">
                                <tr bgcolor="#iif(qGetInsuranceHistory.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
                                    <td>#DateFormat(qGetInsuranceHistory.date, 'mm/dd/yyyy')#</td>
                                    <td>#qGetInsuranceHistory.type#</td>
                                    <td>#qGetInsuranceHistory.file#</td>
                                    <td align="center">#qGetInsuranceHistory.totalStudents#</td>
                                    <td align="center"><a href="insurance/downloadFile.cfm?file=#URLEncodedFormat(qGetInsuranceHistory.file)#&date=#URLEncodedFormat(DateFormat(qGetInsuranceHistory.date, 'mm/dd/yyyy'))#">[ Download ]</a></td>
                                </tr>                            
                            </cfloop>
                        </table>
                   
                    </td>
                </tr>
            </table>
            
            <br /><br />
                   
		</td>
	</tr>
</table>

</cfoutput>

<cfinclude template="../table_footer.cfm">