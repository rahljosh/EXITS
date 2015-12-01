<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
    <!--- Param FORM variables --->
	<cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.placementType" default="all">
    <cfparam name="FORM.userID" default="0">
	<cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.studentStatus" default="All">
	
    <cfscript>
		qGetIntlRepList = APPLICATION.CFC.USER.getUsers(usertype=8,isActive=1,businessNameExists=1);
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
	</cfscript>
        
    <!--- FORM submitted --->
    <cfif FORM.submitted>
		
        <!--- Get Intl Reps --->
		<cfquery name="qGetIntlReps" datasource="#APPLICATION.DSN.Source#">
            SELECT DISTINCT u.userid, u.businessname
            FROM smg_users u
           	INNER JOIN extra_candidates ec ON ec.intRep = u.userID
           		AND ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">    
           		AND ec.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
            WHERE u.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
            <cfif CLIENT.userType EQ 8>
            	AND u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
            <cfelseif VAL(FORM.userID)>
				AND u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
          	</cfif>
            GROUP BY u.userID
            ORDER BY u.businessname
		</cfquery>
        
        <cfscript>
			qGetProgramInfo = APPLICATION.CFC.PROGRAM.getPrograms(programID = FORM.programID);
		
			qGetAllCandidates = APPLICATION.CFC.CANDIDATE.getCandidateWithPlacementInformation(
				placementType = FORM.placementType,
				candidateStatus = FORM.studentStatus,
				programID = FORM.programID,
				intRep = FORM.userID);
		</cfscript>

        <cffunction name="filterGetAllCandidates" hint="Gets total by Intl. Rep">
        	<cfargument name="placementType" default="" hint="Placement Type is not required">
            <cfargument name="intRep" default="0" hint="IntRep is not required">
            <cfargument name="hasDS" default="" hint="0/1">
            <cfargument name="distinct" default="">
            
            <cfquery name="qFilterGetAllCandidates" dbtype="query">
                SELECT <cfif LEN(ARGUMENTS.distinct)>DISTINCT</cfif>
                    *
                FROM	
                    qGetAllCandidates
                WHERE
                	1 = 1
                    
                <cfif VAL(ARGUMENTS.intRep)>    
                    AND    
                        intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.intRep#">                        
                </cfif>
                
                <cfif ARGUMENTS.placementType NEQ 'All'>
                    AND
                        wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.placementType#">
            	</cfif>
				
                <cfif VAL(ARGUMENTS.hasDS)>
                    AND
                        ds2019 != ''
                <cfelseif ARGUMENTS.hasDS EQ 0>
                    AND
                        ds2019 = ''
				</cfif>
                
                ORDER BY 
                	wat_placement,
                    candidateID
            </cfquery>
			
            <cfreturn qFilterGetAllCandidates>
        </cffunction>
		
		<cfscript>
			// Get Overall Results
			totalCSBPlacements = filterGetAllCandidates(placementType='CSB-Placement', distinct="yes").recordCount;
		
			totalSelfPlacements = filterGetAllCandidates(placementType='Self-Placement', distinct="yes").recordCount;

			totalWalkInPlacements = filterGetAllCandidates(placementType='Walk-In', distinct="yes").recordCount;

			totalUnassigned = filterGetAllCandidates(placementType='', distinct="yes").recordCount;
			
			totalDSissued = filterGetAllCandidates(placementType='All', hasDS=1, distinct="yes").recordCount;
			
			totalDSNotIssued = filterGetAllCandidates(placementType='All', hasDS=0, distinct="yes").recordCount;
        </cfscript>	
    
    </cfif>       
    
</cfsilent>

<script type="text/javascript">
<!-- Begin
	function formHandler2(form){
		var URL = document.formagent.agent.options[document.formagent.agent.selectedIndex].value;
		window.location.href = URL;
	}
	
	function formValidation(){
		with (document.form) {
			if (intrep.value == '') {
				alert("Please, select an intl. rep.!");
				intrep.focus();
				return false;
			}
			if (program.value == '') {
				alert("Please, select a program!");
				program.focus();
				return false;
			}
		}
	}
// End -->
</script>

<style type="text/css">
<!--
.tableTitleView {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	padding:2px;
	color:#FFFFFF;
	background:#4F8EA4;
}
-->
</style>

<cfoutput>

<!--- Form --->
<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" name="form" onSubmit="return formValidation()">
<input type="hidden" name="submitted" value="1" />

<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
    <tr valign="middle" height="24">
        <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>
            <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Intl. Rep. Reports -> All Participating Candidates</font>
        </td>
    </tr>
    <tr valign="middle" height="24">
        <td valign="middle" colspan="2">&nbsp;</td>
    </tr>
    <cfif CLIENT.userType LTE 4>
        <tr valign="middle">
            <td align="right" valign="middle" class="style1"><b>Intl. Rep.:</b> </td>
            <td valign="middle">
                <select name="userID" class="style1">
                    <option value="All">---  All International Representatives  ---</option>
                    <cfloop query="qGetIntlRepList">
                        <option value="#qGetIntlRepList.userID#" <cfif qGetIntlRepList.userID EQ FORM.userID> selected</cfif> >#qGetIntlRepList.businessname#</option>
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
    	<td valign="middle" align="right" class="style1"><b>Placement:</b></td>
        <td>
        	<select name="placementType" class="style1">
            	<option value="all">All</option>
                <option value="primary" <cfif FORM.placementType eq 'primary'>selected</cfif>>Primary Placements</option>
                <option value="secondary" <cfif FORM.placementType eq 'secondary'>selected</cfif>>Secondary Placements</option>
            </select>
        </td>
    </tr>
    <tr>
        <td valign="middle" align="right" class="style1"><b>Status:</b></td>
        <td> 
            <select name="studentStatus" class="style1">
            	<option value="All" <cfif "All" eq FORM.studentStatus> selected</cfif>>All</option>
                <option value="1" <cfif 1 eq FORM.studentStatus> selected</cfif>>Active</option>
                <option value="0" <cfif 0 eq FORM.studentStatus> selected</cfif>>Inactive</option>
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
    </Tr>
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
		// On Screen
		if (FORM.printOption EQ 1) {
			tableTitleClass = 'tableTitleView';
		} else {
			tableTitleClass = 'style2';
		}
	</cfscript>
    
	<cfsavecontent variable="reportContent">
    
        <img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <br /><br /><br />
        
        <div class="style1"><strong>&nbsp; &nbsp; CSB-Placement:</strong> #totalCSBPlacements#</div>	
        <div class="style1"><strong>&nbsp; &nbsp; Self-Placement:</strong> #totalSelfPlacements#</div>
        <div class="style1"><strong>&nbsp; &nbsp; Walk-In:</strong> #totalWalkInPlacements#</div>
        <div class="style1"><strong>&nbsp; &nbsp; Unassigned:</strong> #totalUnassigned#</div>
        <div class="style1"><strong>&nbsp; &nbsp; --------------------------------------</strong></div>
        <div class="style1"><strong>&nbsp; &nbsp; Total Number of Students:</strong> #qGetAllCandidates.recordCount#</div>
        <div class="style1"><strong>&nbsp; &nbsp; --------------------------------------</strong></div>
        <div class="style1"><strong>&nbsp; &nbsp; DS-2019 Forms issued:</strong> #totalDSissued#</div>
        <div class="style1"><strong>&nbsp; &nbsp; DS-2019 Forms to be issued:</strong> #totalDSNotIssued#</div> 
        <div class="style1"><strong>&nbsp; &nbsp; --------------------------------------</strong></div>			
        
        <br />
                
        <div class="style1">&nbsp; &nbsp; Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</div>
        
        <img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <br />
    	
        <cfloop query="qGetIntlReps">
		
			<cfscript>
                // Total By Agent
                qTotalPerAgent = filterGetAllCandidates(placementType='ALL', intRep=qGetIntlReps.userID);
				
				totalPerAgentCSBPlacements = filterGetAllCandidates(placementType='CSB-Placement', intRep=qGetIntlReps.userID).recordCount;
                
                totalPerAgentSelfPlacements = filterGetAllCandidates(placementType='Self-Placement', intRep=qGetIntlReps.userID).recordCount;
                
                totalPerAgentWalkInPlacements = filterGetAllCandidates(placementType='Walk-In', intRep=qGetIntlReps.userID).recordCount;
                
                totalPerAgentUnassigned = filterGetAllCandidates(placementType='', intRep=qGetIntlReps.userID).recordCount;     
				
				totalPerAgentDSissued = filterGetAllCandidates(placementType='ALL', hasDS=1, intRep=qGetIntlReps.userID).recordCount;
				
				totalPerAgentDSNotIssued = filterGetAllCandidates(placementType='ALL', hasDS=0, intRep=qGetIntlReps.userID).recordCount;
            </cfscript>
            
            <cfif qTotalPerAgent.recordCount>
        		
                <table width="99%" cellpadding="4" cellspacing=0 align="center">
                        <tr>
                            <td colspan="14">
                                <small>
                                    <strong>#qGetIntlReps.businessname# - Total candidates: #qTotalPerAgent.recordCount#</strong> 
                                    (
                                        #totalPerAgentCSBPlacements# CSB; &nbsp; 
                                        #totalPerAgentSelfPlacements# Self; &nbsp; 
                                        #totalPerAgentWalkInPlacements# Walk-In; &nbsp; 
                                        #totalPerAgentUnassigned# Unassigned &nbsp;
                                    ) &nbsp; | &nbsp;
                                    <strong>DS-2019 Forms issued: &nbsp;</strong> #totalPerAgentDSissued#  &nbsp; | &nbsp;
                                    <strong>DS-2019 Forms to be issued: &nbsp;</strong> #totalPerAgentDSNotIssued#
                                </small>
                            </td>
                        </tr>
                    <cfif ListFind("2,3", FORM.printOption)>
                        <tr>
                            <td colspan="14"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td>
                        </tr>
                    </cfif>
                    <tr>
                        <th align="left" class="#tableTitleClass#" width="4%">ID</Th>
                        <th align="left" class="#tableTitleClass#" width="8%">Last Name</Th>
                        <th align="left" class="#tableTitleClass#" width="8%">First Name</Th>
                        <th align="left" class="#tableTitleClass#" width="3%">Sex</th>
                        <th align="left" class="#tableTitleClass#" width="8%">E-mail</th>
                        <th align="left" class="#tableTitleClass#" width="5%">Start Date</th>
                        <th align="left" class="#tableTitleClass#" width="5%">End Date</th>
                        <th align="left" class="#tableTitleClass#" width="18%">Placement Information</th>
                        <th align="left" class="#tableTitleClass#" width="8%">Job Title</th>
                        <th align="left" class="#tableTitleClass#" width="6%">City</th>
                        <th align="left" class="#tableTitleClass#" width="6%">State</th>
                        <th align="left" class="#tableTitleClass#" width="8%">DS-2019</th>
                        <th align="left" class="#tableTitleClass#" width="8%">Option</th>
                        <th align="left" class="#tableTitleClass#" width="5%">Visa Interview</th>
                    </tr>
                    <cfif ListFind("2,3", FORM.printOption)>
                        <tr>
                            <td colspan="14"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td>
                        </tr>
                    </cfif>
                    <cfloop query="qTotalPerAgent">
                    
                        <cfif FORM.placementType NEQ "primary">
                    
                            <cfquery name="qGetAllPlacements" datasource="#APPLICATION.DSN.Source#">
                                SELECT
                                    ecpc.hostCompanyID,
                                    ecpc.jobID,
                                    h.name,
                                    h.city,
                                    s.state,
                                    ej.title AS jobTitle
                                FROM
                                    extra_candidate_place_company ecpc
                                INNER JOIN
                                    extra_hostcompany h ON h.hostCompanyID = ecpc.hostCompanyID
                                INNER JOIN
                                    smg_states s ON s.id = h.state
                                LEFT JOIN
                                    extra_jobs ej ON ej.ID = ecpc.jobID
                                WHERE
                                    candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qTotalPerAgent.candidateID#">
                                AND
                                    status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                                <cfif FORM.placementType EQ "primary">
                                    AND
                                        isSecondary = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                                <cfelseif FORM.placementType EQ "secondary">
                                    AND
                                        isSecondary = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                                </cfif>
                            </cfquery>
                        
                        </cfif>
                    
                        <tr <cfif qTotalPerAgent.currentRow mod 2>bgcolor="##E4E4E4"</cfif>>                    
                            <td class="style1">
                                <a href="?curdoc=candidate/candidate_info&uniqueid=#qTotalPerAgent.uniqueID#" target="_blank" class="style4">
                                    #qTotalPerAgent.candidateID#
                                    <cfif qTotalPerAgent.subject EQ "Terminated">
                                    	<font color="red"><b>T</b></font>
                                  	</cfif>
                                </a>
                            </td>
                            <td class="style1">
                                <a href="?curdoc=candidate/candidate_info&uniqueid=#qTotalPerAgent.uniqueID#" target="_blank" class="style4">
                                    #qTotalPerAgent.lastname#
                                </a>
                            </td>
                            <td class="style1">
                                <a href="?curdoc=candidate/candidate_info&uniqueid=#qTotalPerAgent.uniqueID#" target="_blank" class="style4">
                                    #qTotalPerAgent.firstname#
                                </a>
                            </td>
                            <td class="style1">#qTotalPerAgent.sex#</td>
                            <td class="style1">#qTotalPerAgent.email#</td>
                            <td class="style1">#DateFormat(qTotalPerAgent.startdate, 'mm/dd/yyyy')#</td>
                            <td class="style1">#DateFormat(qTotalPerAgent.enddate, 'mm/dd/yyyy')#</td>
                            <td class="style1" colspan="4">
                                <table width="100%">
                                    <cfif FORM.placementType NEQ "primary">
                                        <cfloop query="qGetAllPlacements">
                                            <tr>
                                                <td width="50%">
                                                    <cfif FORM.placementType NEQ "secondary">
                                                    <a href="?curdoc=hostcompany/hostCompanyInfo&hostCompanyID=#qGetAllPlacements.hostCompanyID#"  target="_blank" class="style4">
                                                        #qGetAllPlacements.name#
                                                    </a>
                                                    <cfelse>
                                                        #qGetAllPlacements.name#
                                                    </cfif><br />
                                                    <cfscript>
														qGetSeekingEmploymentComments = APPLICATION.CFC.CANDIDATE.getSeekingEmploymentComments(candidateID=qTotalPerAgent.candidateID);
													</cfscript>
													<cfif VAL(qGetSeekingEmploymentComments.recordCount) AND qGetAllPlacements.hostCompanyID EQ 195>
														<table>
															<tr>
																<td><strong><u>Comments:</u></strong><br />
																	<cfloop query="qGetSeekingEmploymentComments">
																		<b>On #DateFormat(date,'mm/dd/yyyy')# at #TimeFormat(date,'h:mm tt')# by #firstName# #lastName#</b>
																		<br/>
																		#note#
																		<br/>
																	</cfloop>
																</td>
															</tr>
														</table>
													</cfif>
                                                </td>
                                                <td width="20%">
                                                    #qGetAllPlacements.jobTitle#
                                                </td>
                                                <td width="15">
                                                    #qGetAllPlacements.city#
                                                </td>
                                                <td width="15%">
                                                    #qGetAllPlacements.state#
                                                </td>
                                            </tr>
                                        </cfloop>
                                    <cfelse>
                                        <tr>
                                            <td width="50%">
                                                <a href="?curdoc=hostcompany/hostCompanyInfo&hostCompanyID=#qTotalPerAgent.hostCompanyID#"  target="_blank" class="style4">
                                                    #qTotalPerAgent.hostCompanyName#
                                                </a>
                                            </td>
                                            <td width="20%">
                                                #qTotalPerAgent.jobTitle#
                                            </td>
                                            <td width="15">
                                                #qTotalPerAgent.hostCompanyCity#
                                            </td>
                                            <td width="15%">
                                                #qTotalPerAgent.hostCompanyState# 
                                            </td>
                                        </tr>
                                    </cfif>
                                </table>
                            </td>
                            <td class="style1">#qTotalPerAgent.ds2019#</td>
                            <td class="style1">#qTotalPerAgent.wat_placement#</td>
                            <td class="style1">#DateFormat(qTotalPerAgent.visaInterview,'mm/dd/yyyy')#</td>
                        </tr>
                    </cfloop>        
                </table>
                <br />	
                
         	</cfif>
                
		</cfloop>
        
        <cfif ListFind("2,3", FORM.printOption)> 
            <div class="style1"><strong>&nbsp; &nbsp; Program:</strong> #qGetProgramInfo.programName#</div>	
            <div class="style1"><strong>&nbsp; &nbsp; Intl. Rep.:</strong> 
				<cfif FORM.userID EQ "All"> 
                	All International Rep. 
				<cfelse>
                	#qGetIntlReps.businessname#
				</cfif>
            </div>
        </cfif>
        
    </cfsavecontent>

	<!-----Display Reports---->
    <cfswitch expression="#FORM.printOption#">
    
        <!--- Screen --->
        <cfcase value="1">
            <!--- Include Report --->
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
                
                <!--- Include Report --->
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
                
                <!--- Include Report --->
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
        Print results will replace the menu options and take a bit longer to generate. <br />
        Onscreen will allow you to change criteria with out clicking your back button.
    </div>  <br />

</cfif>    

</cfoutput>
