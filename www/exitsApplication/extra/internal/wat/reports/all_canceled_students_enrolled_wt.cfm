<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param FORM variables --->
	<cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.userID" default="0">
	<cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.submitted" default="0">

    <cfscript>
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		qGetIntlRepList = APPLICATION.CFC.USER.getUsers(usertype=8,isActive=1,businessNameExists=1);
	</cfscript>
    
    <!--- FORM submitted --->
    <cfif FORM.submitted>
		
        <!--- Get Intl Reps --->
		<cfquery name="qGetIntlReps" datasource="#APPLICATION.DSN.Source#">
            SELECT DISTINCT u.userid, u.businessname
            FROM smg_users u
           	INNER JOIN extra_candidates ec ON ec.intRep = u.userID
          		AND ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">    
          		AND ec.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
            WHERE u.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
			<cfif CLIENT.userType EQ 8>
            	AND u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
            <cfelse>
				<cfif VAL(FORM.userID)>
                    AND u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
                </cfif>
          	</cfif>
            GROUP BY u.userID
            ORDER BY u.businessname
		</cfquery>

        <cfquery name="qGetProgramInfo" datasource="#APPLICATION.DSN.Source#">
            SELECT programname
            FROM smg_programs
            WHERE programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
        </cfquery> 
    	
        <cfquery name="qGetAllCandidates" datasource="#APPLICATION.DSN.Source#">
            SELECT 
                ec.candidateID,
                ec.uniqueID,
                ec.firstname, 
                ec.lastname, 
                ec.placedby, 
                ec.sex, 
                ec.hostcompanyid, 
                ec.ds2019,
                ec.startdate, 
                ec.enddate,
                ec.intrep, 
                ec.wat_placement,
                ec.cancel_date,
                ec.cancel_reason,
                ehc.name,                 
                u.businessName
            FROM extra_candidates ec
            LEFT JOIN extra_hostcompany ehc ON ehc.hostcompanyid = ec.hostcompanyid
            INNER JOIN smg_programs ON smg_programs.programID = ec.programID
            INNER JOIN smg_users u ON u.userid = ec.intrep
            WHERE ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
            AND ec.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
           	<cfif CLIENT.userType EQ 8>
            	AND ec.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
            <cfelse>
				<cfif VAL(FORM.userID)>
                    AND ec.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
                </cfif>
          	</cfif>
        </cfquery>


        <cffunction name="filterGetAllCandidates" hint="Gets total by Intl. Rep">
        	<cfargument name="placementType" default="" hint="Placement Type is not required">
            <cfargument name="intRep" default="0" hint="IntRep is not required">
            <cfargument name="hasDS" default="" hint="0/1">
            
            <cfquery name="qFilterGetAllCandidates" dbtype="query">
                SELECT
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
			totalCSBPlacements = filterGetAllCandidates(placementType='CSB-Placement').recordCount;
		
			totalSelfPlacements = filterGetAllCandidates(placementType='Self-Placement').recordCount;

			totalWalkInPlacements = filterGetAllCandidates(placementType='Walk-In').recordCount;

			totalUnassigned = filterGetAllCandidates(placementType='').recordCount;
			
			totalDSissued = filterGetAllCandidates(placementType='All', hasDS=1).recordCount;
			
			totalDSNotIssued = filterGetAllCandidates(placementType='All', hasDS=0).recordCount;
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
            <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;Intl. Rep. Reports -> All Cancelled Candidates</font>
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
    <Tr>
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
        		
            <table width="99%" cellpadding="4" cellspacing=0 align="center">
                    <tr>
                        <td colspan="8">
                            <small>
                                <strong>#qGetIntlReps.businessname# - Total candidates: #qTotalPerAgent.recordCount# &nbsp;</strong> 
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
                        <td colspan=8><img src="../../pics/black_pixel.gif" width="100%" height="2"></td>
                    </tr>
				</cfif>
                <tr>
                    <Th align="left" class="#tableTitleClass#">Candidate</Th>
                    <th align="left" class="#tableTitleClass#">Sex</th>
                    <th align="left" class="#tableTitleClass#">Start Date</th>
                    <th align="left" class="#tableTitleClass#">End Date</th>
                    <th align="left" class="#tableTitleClass#">Placement Information</th>
                    <th align="left" class="#tableTitleClass#">DS-2019</th>
                    <th align="left" class="#tableTitleClass#">Option</th>
                    <th align="left" class="#tableTitleClass#">Cancelation Date</th>
                    <th align="left" class="#tableTitleClass#">Cancelation Reason</th>
                </tr>
                <cfif ListFind("2,3", FORM.printOption)>
                    <tr>
                        <td colspan=8><img src="../../pics/black_pixel.gif" width="100%" height="2"></td>
                    </tr>
				</cfif>
                <cfloop query="qTotalPerAgent">
                    <tr <cfif qTotalPerAgent.currentRow mod 2>bgcolor="##E4E4E4"</cfif>>                    
                        <td class="style1">
                        	<a href="?curdoc=candidate/candidate_info&uniqueid=#qTotalPerAgent.uniqueID#" target="_blank" class="style4">
                        		#qTotalPerAgent.firstname# #qTotalPerAgent.lastname# (###qTotalPerAgent.candidateID#)
							</a>                                
                        </td>
                        <td class="style1">#qTotalPerAgent.sex#</td>
                        <td class="style1">#DateFormat(qTotalPerAgent.startdate, 'mm/dd/yyyy')#</td>
                        <td class="style1">#DateFormat(qTotalPerAgent.enddate, 'mm/dd/yyyy')#</td>
                        <td class="style1">#qTotalPerAgent.name#</td>
                        <td class="style1">#qTotalPerAgent.ds2019#</td>
                        <td class="style1">#qTotalPerAgent.wat_placement#</td>
                        <td class="style1">#DateFormat(qTotalPerAgent.cancel_date, 'mm/dd/yyyy')#</td>
                        <td class="style1">#qTotalPerAgent.cancel_reason#</td>
                    </tr>
                </cfloop>        
            </table>
            <br />	
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
