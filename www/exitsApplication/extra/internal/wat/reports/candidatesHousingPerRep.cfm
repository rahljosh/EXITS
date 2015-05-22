<!--- ------------------------------------------------------------------------- ----
	
	File:		candidatesHousingPerRep.cfm
	Author:		James Griffiths
	Date:		July 29, 2013
	Desc:		Report showing candidate's housing arrangements by Rep.

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<!--- Param FORM variables --->
	<cfparam name="FORM.userID" default="0">
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.housingArrangements" default="All">
    <cfparam name="FORM.emailRep" default="0">
	<cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.submitted" default="0">

    <cfscript>
		qGetIntlRepList = APPLICATION.CFC.USER.getUsers(usertype=8,isActive=1,businessNameExists=1);
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		if (VAL(FORM.submitted)) {
			qGetProgramInfo = APPLICATION.CFC.PROGRAM.getPrograms(programID = FORM.programID);	
		}
	</cfscript>
    
     <!--- FORM submitted --->
    <cfif FORM.submitted>
		
        <!--- Get Intl Reps --->
		<cfquery name="qGetIntlReps" datasource="#APPLICATION.DSN.Source#">
            SELECT u.userid, u.businessname, u.email
            FROM smg_users u
            WHERE u.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
            <cfif CLIENT.userType EQ 8>
            	AND u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
            <cfelseif VAL(FORM.userID)>
				AND u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.userID)#">
          	</cfif>
            AND u.userID IN (
            	SELECT ec.intrep
                FROM extra_candidates ec
                INNER JOIN extra_hostcompany eh ON ec.hostCompanyID = eh.hostCompanyID
                WHERE ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
                AND ec.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                <cfif FORM.housingArrangements NEQ "All">
                	<cfif FORM.housingArrangements EQ "employerProvides">
                    	AND eh.isHousingProvided = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    <cfelse>
                    	AND eh.isHousingProvided != <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    	<cfif FORM.housingArrangements NEQ "All_notProvided">
                        	AND ec.housingArrangedPrivately = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.housingArrangements)#">
                        </cfif>
                    </cfif>
                </cfif> )
            GROUP BY u.userID
            ORDER BY u.businessname
		</cfquery>
        
        <cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#">
            SELECT 
                candidate.candidateID,
                candidate.intRep,
                candidate.uniqueID,
                candidate.lastName, 
                candidate.firstName, 
                candidate.sex, 
                candidate.email, 
                candidate.wat_placement,
                candidate.wat_vacation_start,
                candidate.startdate,
                candidate.enddate,
                candidate.housingArrangedPrivately,
                candidate.housingDetails,
                candidate.ds2019,
                host.isHousingProvided,
                host.city,
                host.name AS hostCompanyName,
                host.hostCompanyID,
                state.stateName,
                CASE
                    WHEN candidateID IN (SELECT candidateID FROM extra_incident_report WHERE isSolved = 0 AND subject = "Terminated") THEN "1"
                    ELSE "0"
                    END AS isTerminated
            FROM extra_candidates candidate
            INNER JOIN extra_hostcompany host ON candidate.hostCompanyID = host.hostCompanyID
            INNER JOIN smg_programs program ON candidate.programID = program.programID
                AND program.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
            LEFT JOIN smg_states state ON host.state = state.ID
            WHERE candidate.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            <cfif VAL(FORM.userID)>
            	AND candidate.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
          	</cfif>
            <cfif FORM.housingArrangements NEQ "All">
                <cfif FORM.housingArrangements EQ "employerProvides">
                    AND host.isHousingProvided = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                <cfelse>
                    AND host.isHousingProvided != <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    <cfif FORM.housingArrangements NEQ "All_notProvided">
                        AND candidate.housingArrangedPrivately = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.housingArrangements)#">
                    </cfif>
                </cfif>
            </cfif>
        </cfquery>
        
        <cfquery name="placementCSBTotal" dbtype="query">
            SELECT *
            FROM qGetCandidates
            WHERE wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="CSB-Placement">
        </cfquery>
        
        <cfquery name="placementSelfTotal" dbtype="query">
            SELECT *
            FROM qGetCandidates
            WHERE wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="Self-Placement">
        </cfquery>
        
        <cfquery name="placementWalkInTotal" dbtype="query">
            SELECT *
            FROM qGetCandidates
            WHERE wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="Walk-In">
        </cfquery>
        
        <cfquery name="housingProvidedByHostTotal" dbtype="query">
            SELECT *
            FROM qGetCandidates
            WHERE isHousingProvided = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        </cfquery>
        
        <cfquery name="housingFoundTotal" dbtype="query">
            SELECT *
            FROM qGetCandidates
            WHERE isHousingProvided != <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND housingArrangedPrivately = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        </cfquery>
        
        <cfquery name="housingNotFoundTotal" dbtype="query">
            SELECT *
            FROM qGetCandidates
            WHERE isHousingProvided != <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND housingArrangedPrivately = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        </cfquery>
        
 	</cfif>

</cfsilent>

<script type="text/javascript">	
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
	
	function checkToDisplayEmail(value) {
		if (value === "0") {
			$("#emailRepDiv").removeAttr("style");
		} else {
			$("#emailRepDiv").attr("style","display:none");
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
                    <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Intl. Rep. Reports -> Candidate Housing</font>
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
                <td valign="middle" align="right" class="style1"><b>Housing Availability:</b></td>
                <td> 
                    <select name="housingArrangements" class="style1" onchange="checkToDisplayEmail(this.value);">
                    	<option value="All" <cfif FORM.housingArrangements EQ "All">selected="selected"</cfif>>All</option>
                        <option value="employerProvides" <cfif FORM.housingArrangements EQ "employerProvides">selected="selected"</cfif>>Housing provided</option>
                        <option value="All_notProvided" <cfif FORM.housingArrangements EQ "All_notProvided">selected="selected"</cfif>>Housing not provided - all</option>
                        <option value="1" <cfif FORM.housingArrangements EQ "1">selected="selected"</cfif>>Housing not provided - housing arranged</option>
                        <option value="0" <cfif FORM.housingArrangements EQ "0">selected="selected"</cfif>>Housing not provided - housing not arranged</option>
                    </select>
                </td>
            </tr>
            <tr id="emailRepDiv" <cfif FORM.housingArrangements NEQ 0>style="display:none;"</cfif>>
                <td valign="middle" align="right" class="style1"><b>Email International Representative:</b></td>
                <td> 
                    <input type="checkbox" name="emailRep" value="1" <cfif FORM.emailRep EQ 1>checked="checked"</cfif> />
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
    
	<cfif FORM.submitted>
    
    	<br/>
    	<div class="style1"><strong>&nbsp; &nbsp; CSB-Placement:</strong> #placementCSBTotal.recordCount#</div>	
        <div class="style1"><strong>&nbsp; &nbsp; Self-Placement:</strong> #placementSelfTotal.recordCount#</div>
        <div class="style1"><strong>&nbsp; &nbsp; Walk-In:</strong> #placementWalkInTotal.recordCount#</div>
        <div class="style1"><strong>&nbsp; &nbsp; --------------------------------------</strong></div>
        <div class="style1"><strong>&nbsp; &nbsp; Housing on premises:</strong> #housingProvidedByHostTotal.recordCount#</div>
        <div class="style1"><strong>&nbsp; &nbsp; Yes:</strong> #housingFoundTotal.recordCount#</div>
        <div class="style1"><strong>&nbsp; &nbsp; No:</strong> #housingNotFoundTotal.recordCount#</div> 
        <div class="style1"><strong>&nbsp; &nbsp; --------------------------------------</strong></div>
        <div class="style1"><strong>&nbsp; &nbsp; Total Number of Students:</strong> #qGetCandidates.recordCount#</div>
        <div class="style1"><strong>&nbsp; &nbsp; --------------------------------------</strong></div>
        <br/>	
    	
        <cfscript>
			// On Screen
			if (FORM.printOption EQ 1) {
				tableTitleClass = 'tableTitleView';
			} else {
				tableTitleClass = 'style2';
			}
		</cfscript>
    
        <cfsavecontent variable="reportContent">
        
            <cfloop query="qGetIntlReps">
            	
                <cfquery name="qGetCandidatesPerRep" dbtype="query">
                	SELECT *
                    FROM qGetCandidates
                    WHERE intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetIntlReps.userID#">
                </cfquery>
                
                <cfquery name="placementCSB" dbtype="query">
                	SELECT *
                    FROM qGetCandidatesPerRep
                    WHERE wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="CSB-Placement">
             	</cfquery>
                
                <cfquery name="placementSelf" dbtype="query">
                	SELECT *
                    FROM qGetCandidatesPerRep
                    WHERE wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="Self-Placement">
             	</cfquery>
                
                <cfquery name="placementWalkIn" dbtype="query">
                	SELECT *
                    FROM qGetCandidatesPerRep
                    WHERE wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="Walk-In">
             	</cfquery>
                
                <cfquery name="housingProvidedByHost" dbtype="query">
                	SELECT *
                    FROM qGetCandidatesPerRep
                    WHERE isHousingProvided = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                </cfquery>
                
                <cfquery name="housingFound" dbtype="query">
                	SELECT *
                    FROM qGetCandidatesPerRep
                    WHERE isHousingProvided != <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    AND housingArrangedPrivately = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                </cfquery>
                
                <cfquery name="housingNotFound" dbtype="query">
                	SELECT *
                    FROM qGetCandidatesPerRep
                    WHERE isHousingProvided != <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    AND housingArrangedPrivately = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                </cfquery>
                
                <cfsavecontent variable="emailText">
                	<p>
                    	Dear #qGetIntlReps.businessname#,
 						<br/>
                        <br/>
						Please take notice of the list of all participants who are missing the Housing Arrangements Form from their applications. 
                        As previously notified, due to concerns over the health, welfare and safety of the SWT Program participants, this form 
                        <font color="red">must be filled-in and uploaded in EXTRA system (online application, upload section) with 15 (fifteen) days before their specific program start dates.</font> 
                        In certain special cases (e.g. late visa interview, unforeseen delay in arrival, etc.), the maximum limit allowed for 
                        compliance with this requirement is for the form to be filled-in and uploaded with 10 (ten) days before arrival.
 						<br/>
                        <br/>
                        Please ensure you submit this crucial form on time. If you have any questions or concerns, please feel free to contact us.
 						<br/>
                        <br/>
                        Note: If meanwhile you have submitted the requested information, thank you and please disregard this notice.
                    </p>
                </cfsavecontent>
                
                <cfsavecontent variable="listPerRep">
                    <table width="99%" cellpadding="4" cellspacing=0 align="center">
                        <tr>
                            <td colspan="11">
                                <small>
                                    <strong>#qGetIntlReps.businessname# - Total candidates: #qGetCandidatesPerRep.recordCount#</strong> 
                                    (
                                        #placementCSB.recordCount# CSB; &nbsp; 
                                        #placementSelf.recordCount# Self; &nbsp; 
                                        #placementWalkIn.recordCount# Walk-In; &nbsp; 
                                    )
                                    <br/>
                                    Housing provided: #housingProvidedByHost.recordCount# &nbsp; | &nbsp;
                                    Housing not provided - housing found: #housingFound.recordCount# &nbsp; | &nbsp;
                                    Housing not provided - housing not found: #housingNotFound.recordCount#
                                </small>
                            </td>
                        </tr>
                        <cfif ListFind("2,3", FORM.printOption)>
                            <tr>
                                <td colspan="14"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td>
                            </tr>
                        </cfif>
                        <tr>
                            <th align="left" class="#tableTitleClass#" width="5%">ID</Th>
                            <th align="left" class="#tableTitleClass#" width="8%">Last Name</Th>
                            <th align="left" class="#tableTitleClass#" width="8%">First Name</Th>
                            <th align="left" class="#tableTitleClass#" width="8%">Sex</th>
                            <th align="left" class="#tableTitleClass#" width="11%">E-mail</th>
                            <th align="left" class="#tableTitleClass#" width="8%">Start Date</th>
                            
                            <th align="left" class="#tableTitleClass#" width="8%">Placement Information</th>
                            <th align="left" class="#tableTitleClass#" width="8%">City</th>
                            <th align="left" class="#tableTitleClass#" width="7%">State</th>
                            <th align="left" class="#tableTitleClass#" width="7%">Option</th>
                            <th align="left" class="#tableTitleClass#" width="8%">Housing Arranged</th>
                            <th align="left" class="#tableTitleClass#" width="6%">Housing Details</th>
                        </tr>
                        <cfif ListFind("2,3", FORM.printOption)>
                            <tr>
                                <td colspan="14"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td>
                            </tr>
                        </cfif>
                        <cfloop query="qGetCandidatesPerRep">
                            <tr <cfif qGetCandidatesPerRep.currentRow mod 2>bgcolor="##E4E4E4"</cfif>>                    
                                <td class="style1">
                                    <a href="?curdoc=candidate/candidate_info&uniqueid=#qGetCandidatesPerRep.uniqueID#" target="_blank" class="style4">
                                        #candidateID#
                                        <cfif VAL(isTerminated)>
                                            <font color="red"><b>T</b></font>
                                        </cfif>
                                    </a>
                                </td>
                                <td class="style1">
                                    <a href="?curdoc=candidate/candidate_info&uniqueid=#qGetCandidatesPerRep.uniqueID#" target="_blank" class="style4">
                                        #lastname#
                                    </a>
                                </td>
                                <td class="style1">
                                    <a href="?curdoc=candidate/candidate_info&uniqueid=#qGetCandidatesPerRep.uniqueID#" target="_blank" class="style4">
                                        #firstname#
                                    </a>
                                </td>
                                <td class="style1">#sex#</td>
                                <td class="style1">#email#</td>
                                <cfif NOT LEN(ds2019)>
                                    <td class="style1">Awaiting <br /> DS-2019</td>
                                <cfelseif isHousingProvided NEQ 1 AND NOT VAL(housingArrangedPrivately) AND DateAdd("d",15,NOW()) GTE startdate>
                               		<cfif DateAdd("d",9,NOW()) GTE startdate>
                                        <td class="style1"><font color="red">Alert!! <BR> #DateFormat(startdate, 'mm/dd/yyyy')#</font></td>
                                    <cfelse>
                                        <td class="style1"><font color="orange">Alert!! <BR>#DateFormat(startdate, 'mm/dd/yyyy')#</font></td>
                                    </cfif>
                                <cfelse>
                                    <td class="style1">#DateFormat(startdate, 'mm/dd/yyyy')#</td>
                                    
                                </cfif>
                                <td class="style1"><a href="index.cfm?curdoc=hostCompany/hostCompanyInfo&hostCompanyID=#hostCompanyID#" class="style4">#hostCompanyName#</a></td>
                                <td class="style1">#city#</td>
                                <td class="style1">#stateName#</td>
                                <td class="style1">#wat_placement#</td>
                                <td class="style1">
                                    <cfif isHousingProvided EQ 1>
                                        Housing provided
                                    <cfelse>
                                        <cfif VAL(housingArrangedPrivately)>
                                            Yes
                                        <cfelse>
                                        	<font color="red">No</font>
                                        </cfif>
                                    </cfif>
                                </td>
                                <td class="style1">
                                	<cfif isHousingProvided EQ 1>
                                      	n/a
                                    <cfelse>
                                        <cfif VAL(housingArrangedPrivately)>
                                            #housingDetails#
                                        <cfelse>
                                        	pending
                                        </cfif>
                                    </cfif>
                              	</td>
                            </tr>
                        </cfloop>
                    </table>
				</cfsavecontent>
                
                #listPerRep#
                
                <cfif VAL(emailRep)>
                	<cfscript>
						APPLICATION.CFC.EMAIL.sendEmail(
							emailTo=qGetIntlReps.email,
							emailSubject="SWT CSB Participants – Missing Housing Arrangements Form",
							emailMessage=emailText & listPerRep,
							companyID=CLIENT.companyID,
							footerType="emailRegular");
					</cfscript>
                </cfif>
                
            </cfloop>
            
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
                    </style>
                   
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    <div class="title1">Candidate Housing Report by International Reps</div>
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    
                    <!--- Include Report --->
                    #reportContent#
                </cfdocument>
            </cfcase>
            
            <!--- PDF --->
            <cfcase value="3">   
                <cfdocument format="pdf" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">          	
                    <style type="text/css">
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
                    </style>
        
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    <div class="title1">Candidate Housing Report by International Reps</div>
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