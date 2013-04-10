<!--- ------------------------------------------------------------------------- ----
	
	File:		terminatedListReport.cfm
	Author:		James Griffiths
	Date:		March 4, 2013
	Desc:		Shows a list of terminated candidates.

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- PARAM FORM VARIABLES --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.intlRepID" default="0"> <!--- 0 for all reps --->
    <cfparam name="FORM.status" default="all"> <!--- all, active, inactive --->
    
    <!--- Get the list of programs --->
    <cfscript>
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		qGetIntlRepList = APPLICATION.CFC.USER.getIntlReps();
	</cfscript>
 
</cfsilent>
        
<!--- FORM SUBMITTED --->
<cfif FORM.submitted>

	<cfquery name="qGetResults" datasource="#APPLICATION.DSN.Source#">
    	SELECT c.candidateID, c.uniqueID, c.lastName, c.firstName, c.sex, c.wat_placement, c.startDate, c.endDate,
            u.userID, u.businessName,
            ecpc.isSecondary,
            eh.hostCompanyID, eh.name AS hostCompanyName
        FROM extra_candidates c
        LEFT JOIN smg_users u ON c.intRep = u.userID
        LEFT JOIN extra_candidate_place_company ecpc ON ecpc.candidateID = c.candidateID
        	AND ecpc.status = 1
       	LEFT JOIN extra_hostcompany eh ON eh.hostCompanyID = ecpc.hostCompanyID
        WHERE c.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
        <cfif VAL(FORM.intlRepID)>
        	AND c.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.intlRepID)#">
        </cfif>
        <cfif FORM.status NEQ "all">
            AND c.status = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.status)#">
        </cfif>
		AND c.candidateID IN (SELECT candidateID FROM extra_incident_report WHERE subject="Terminated")
    </cfquery>
    
    <cfquery name="qGetResultsGrouped" datasource="#APPLICATION.DSN.Source#">
    	SELECT c.candidateID, c.uniqueID, c.lastName, c.firstName, c.sex, c.wat_placement, c.startDate, c.endDate,
            u.userID, u.businessName,
            eh.hostCompanyID, eh.name AS hostCompanyName
        FROM extra_candidates c
        LEFT JOIN smg_users u ON c.intRep = u.userID
        LEFT JOIN extra_candidate_place_company ecpc ON ecpc.candidateID = c.candidateID
        	AND ecpc.status = 1
       	LEFT JOIN extra_hostcompany eh ON eh.hostCompanyID = ecpc.hostCompanyID
        WHERE c.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
        <cfif VAL(FORM.intlRepID)>
        	AND c.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.intlRepID)#">
        </cfif>
        <cfif FORM.status NEQ "all">
            AND c.status = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.status)#">
        </cfif>
        AND c.candidateID IN (SELECT candidateID FROM extra_incident_report WHERE subject="Terminated")
        GROUP BY c.candidateID
    </cfquery>
	
</cfif>

<script type="text/javascript">
	function formValidation(){
		with (document.form) {
			if (program.value == '') {
				alert("Please, select a program!");
				program.focus();
				return false;
			}
		}
	}
</script>

<style type="text/css">
	.tableTitleView {
		font-family: Verdana, Arial, Helvetica, sans-serif;
		font-size: 10px;
		padding:2px;
		color:#FFFFFF;
		background:#4F8EA4;
	}
</style>

<cfoutput>
	
    <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" name="form" onSubmit="return formValidation()">
		<input type="hidden" name="submitted" value="1" />
        
        <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
            <tr valign="middle" height="24">
                <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>
                    <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Program Reports -> Terminated List</font>
                </td>
            </tr>
            <tr valign="middle" height="24">
                <td valign="middle" colspan="2">&nbsp;</td>
            </tr>
            <cfif CLIENT.userType LTE 4>
                <tr valign="middle">
                    <td align="right" valign="middle" class="style1"><b>Intl. Rep.:</b> </td>
                    <td valign="middle">
                        <select name="intlRepID" class="style1">
                            <option value="All">---  All International Representatives  ---</option>
                            <cfloop query="qGetIntlRepList">
                                <option value="#qGetIntlRepList.userID#" <cfif qGetIntlRepList.userID EQ FORM.intlRepID> selected</cfif> >#qGetIntlRepList.businessname#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
            </cfif>
            <tr>
                <td valign="middle" align="right" class="style1"><b>Program:</b></td>
                <td> 
                    <select name="programID" class="style1">
                        <option value="0">Select a Program</option>
                        <cfloop query="qGetProgramList">
                            <option value="#programID#" <cfif qGetProgramList.programID eq FORM.programID> selected</cfif> >#programname#</option>
                        </cfloop>
                    </select>
                </td>
            </tr>
            <tr>
                <td valign="middle" align="right" class="style1"><b>Status:</b></td>
                <td> 
                    <select name="status" class="style1">
                        <option value="all" <cfif "all" EQ FORM.status> selected</cfif>>All</option>
                        <option value="1" <cfif 1 EQ FORM.status> selected</cfif>>Active</option>
                        <option value="0" <cfif 0 EQ FORM.status> selected</cfif>>Inactive</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td align="right" class="style1"><b>Format: </b></td>
                <td  class="style1"> 
                    <input type="radio" name="printOption" id="printOption1" value="1" <cfif FORM.printOption EQ 1> checked </cfif> > <label for="printOption1">Onscreen (View Only)</label>
                    <input type="radio" name="printOption" id="printOption2" value="2" <cfif FORM.printOption EQ 2> checked </cfif> > <label for="printOption2">Print (FlashPaper)</label> 
                    <input type="radio" name="printOption" id="printOption3" value="3" <cfif FORM.printOption EQ 3> checked </cfif> > <label for="printOption3">Print (PDF)</label>
                </td>           
            </tr>
            <tr>
                <td colspan=2 align="center"><br />
                    <input type="submit" value="Generate Report" class="style1" />
                    <br />
                </td>
            </tr>
      	</table>
        
   	</form>
    
    <!--- Print --->
	<cfif FORM.submitted>
        
        <cfscript>
            if (FORM.printOption EQ 1) {
                tableTitleClass = 'tableTitleView';
            } else {
                tableTitleClass = 'style2';
            }
        </cfscript>
        
        <cfsavecontent variable="reportContent">
            
			<table width="99%" cellpadding="4" cellspacing=0 align="center">
          		<tr>
               		<td colspan="11">
                        <small>
                            <strong>Total candidates: #qGetResults.recordCount#</strong> 
                        </small>
                 	</td>
            	</tr>
				<cfif ListFind("2,3", FORM.printOption)>
                    <tr><td colspan="11"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td></tr>
                </cfif>
                <tr>
                    <th align="left" class="#tableTitleClass#">Candidate</Th>
                    <th align="left" class="#tableTitleClass#">Sex</th>
                    <th align="left" class="#tableTitleClass#">Start Date</th>
                    <th align="left" class="#tableTitleClass#">End Date</th>
                    <th align="left" class="#tableTitleClass#">Placement Information</th>
                    <th align="left" class="#tableTitleClass#">Option</th>
                    <th align="left" class="#tableTitleClass#">Intl. Rep.</th>
                </tr>
				<cfif ListFind("2,3", FORM.printOption)>
                    <tr><td colspan="11"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td></tr>
                </cfif>
                <cfloop query="qGetResultsGrouped">
                	<tr <cfif qGetResultsGrouped.currentRow mod 2>bgcolor="##E4E4E4"</cfif>>
                        <td class="style1">
                        	<a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueID#" target="_blank" class="style4">
                            	#firstname# #lastname# (###candidateid#)
                          	</a>
                      	</td>
                        <td class="style1">#sex#</td>
                        <td class="style1">#DateFormat(startDate,'mm/dd/yyyy')#</td>
                        <td class="style1">#DateFormat(endDate,'mm/dd/yyyy')#</td>
                        <td class="style1">
                        	<cfquery name="qGetPlacements" dbtype="query">
                            	SELECT *
                                FROM qGetResults
                                WHERE candidateID = #candidateID#
                                ORDER BY isSecondary
                            </cfquery>
                            <cfloop query="qGetPlacements">
                            	<cfif VAL(isSecondary)>
                                	Secondary:
                                <cfelse>
                                	Primary: 
                                </cfif>
                            	#hostCompanyName# (###hostCompanyID#)
                                <cfif qGetPlacements.currentRow NEQ qGetPlacements.recordCount>
                                	<br/>
                                </cfif>
                            </cfloop>
                        </td>
                        <td class="style1">#wat_placement#</td>
                        <td class="style1">#businessName# (###userID#)</td>
                    </tr>
               	</cfloop>
  			</table>
        
        </cfsavecontent>
        
        <!-----Display Reports---->
    	<cfswitch expression="#FORM.printOption#">
    
			<!--- Screen --->
            <cfcase value="1">
                #reportContent#
            </cfcase>
        
            <!--- Flash Paper --->
            <cfcase value="2">
                <cfdocument format="flashpaper" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">
                    <style type="text/css">
                    <!--
                    .style1 {
                        font-family: Verdana, Arial, Helvetica, sans-serif;
                        font-size: 10px;
                        padding:2;
                    }
                    .style2 {
                        font-family: Verdana, Arial, Helvetica, sans-serif;
                        font-size: 10px;
                        padding:2;
                    }
                    .title1 {
                        font-family: Verdana, Arial, Helvetica, sans-serif;
                        font-size: 15px;
                        font-weight: bold;
                        padding:5;
                    }					
                    -->
                    </style>
                   
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    <div class="title1">All active students enrolled in the program by Intl. Rep. and Program</div>
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    
                    #reportContent#
                </cfdocument>
            </cfcase>
            
            <!--- PDF --->
            <cfcase value="3">   
                <cfdocument format="pdf" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">          	
                    <style type="text/css">
                    <!--
                    .style1 {
                        font-family: Verdana, Arial, Helvetica, sans-serif;
                        font-size: 10px;
                        padding:2;
                    }
                    .style2 {
                        font-family: Verdana, Arial, Helvetica, sans-serif;
                        font-size: 8px;
                        padding:2;
                    }
                    .title1 {
                        font-family: Verdana, Arial, Helvetica, sans-serif;
                        font-size: 15px;
                        font-weight: bold;
                        padding:5;
                    }					
                    -->
                    </style>
        
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    <div class="title1">All active students enrolled in the program by Intl. Rep. and Program</div>
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    
                    #reportContent#
                </cfdocument>
            </cfcase>
        
            <cfdefaultcase>    
                <div align="center" class="style1">
                    <br />
                    Print results will replace the menu options and take a bit longer to generate. <br />
                    Onscreen will allow you to change criteria with out clicking your back button.
                </div>  <br />
            </cfdefaultcase>
            
        </cfswitch>

	<cfelse>
    
        <div align="center" class="style1">
            <br />
            Print results will replace the menu options and take a bit longer to generate.
            <br />
            Onscreen will allow you to change criteria with out clicking your back button.
        </div>
        <br />
    
    </cfif>
    
</cfoutput>