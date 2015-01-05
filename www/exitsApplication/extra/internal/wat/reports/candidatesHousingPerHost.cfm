<!--- ------------------------------------------------------------------------- ----
	
	File:		candidatesHousingPerHost.cfm
	Author:		James Griffiths
	Date:		July 29, 2013
	Desc:		Report showing candidate's housing arrangements by Host.

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<!--- Param FORM variables --->
	<cfparam name="FORM.hostCompanyID" default="0">
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.housingArrangements" default="All">
	<cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.submitted" default="0">

    <cfscript>
		qGetHostCompanyList = APPLICATION.CFC.HOSTCOMPANY.getHostCompanies(companyID=CLIENT.companyID);
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		if (VAL(FORM.submitted)) {
			qGetProgramInfo = APPLICATION.CFC.PROGRAM.getPrograms(programID = FORM.programID);	
		}
	</cfscript>
    
     <!--- FORM submitted --->
    <cfif FORM.submitted>
		
        <!--- Get Hosts --->
		<cfquery name="qGetHosts" datasource="#APPLICATION.DSN.Source#">
        	SELECT h.hostCompanyID, h.name
            FROM extra_hostcompany h
            INNER JOIN extra_candidates c ON h.hostCompanyID = c.hostCompanyID
            	AND c.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
                AND c.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                <cfif CLIENT.userType EQ 8>
                	AND c.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                </cfif>
                <cfif FORM.housingArrangements NEQ "All">
                	<cfif FORM.housingArrangements EQ "employerProvides">
                    	AND h.isHousingProvided = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    <cfelse>
                    	AND h.isHousingProvided != <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    	<cfif FORM.housingArrangements NEQ "All_notProvided">
                        	AND c.housingArrangedPrivately = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.housingArrangements)#">
                        </cfif>
                    </cfif>
                </cfif>
            WHERE h.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND h.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
            <cfif VAL(FORM.hostCompanyID)>
            	AND h.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostCompanyID#">
          	</cfif>
            GROUP BY h.hostCompanyID
            ORDER BY h.name
		</cfquery>
        
        <cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#">
            SELECT 
                candidate.candidateID,
                candidate.uniqueID,
                candidate.lastName, 
                candidate.firstName, 
                candidate.sex, 
                candidate.email, 
                candidate.wat_placement, 
                candidate.housingArrangedPrivately,
                candidate.housingDetails,
                candidate.ds2019,
                candidate.hostCompanyID,
                host.isHousingProvided,
                host.city,
                program.startDate,
                program.endDate,
                state.stateName,
                rep.userID,
                rep.businessname,
                country.countryName,
                CASE
                    WHEN candidateID IN (SELECT candidateID FROM extra_incident_report WHERE isSolved = 0 AND subject = "Terminated") THEN "1"
                    ELSE "0"
                    END AS isTerminated
            FROM extra_candidates candidate
            INNER JOIN smg_users rep ON candidate.intRep = rep.userID
            INNER JOIN extra_hostcompany host ON candidate.hostCompanyID = host.hostCompanyID
            INNER JOIN smg_programs program ON candidate.programID = program.programID
                AND program.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
            LEFT JOIN smg_states state ON host.state = state.ID
            LEFT JOIN smg_countrylist country ON country.countryID = candidate.citizen_country
            WHERE candidate.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            <cfif VAL(FORM.hostCompanyID)>
            	AND candidate.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostCompanyID#">
          	</cfif>
            <cfif CLIENT.userType EQ 8>
                AND candidate.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
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
                    <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Host Company Reports -> Candidate Housing</font>
                </td>
            </tr>
            <tr valign="middle" height="24">
                <td valign="middle" colspan="2">&nbsp;</td>
            </tr>
            <tr valign="middle">
                <td align="right" valign="middle" class="style1"><b>Host Company:</b> </td>
                <td valign="middle">
                    <select name="hostCompanyID" class="style1">
                        <option value="All">---  All Host Companies  ---</option>
                        <cfloop query="qGetHostCompanyList">
                            <option value="#qGetHostCompanyList.hostCompanyID#" <cfif qGetHostCompanyList.hostCompanyID EQ FORM.hostCompanyID> selected</cfif> >
                            	#qGetHostCompanyList.name#
                          	</option>
                        </cfloop>
                    </select>
                </td>
            </tr>
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
        	
            <cfloop query="qGetHosts">
            	
                <cfquery name="qGetCandidatesPerHost" dbtype="query">
                	SELECT *
                    FROM qGetCandidates
                    WHERE hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHosts.hostCompanyID#">
                </cfquery>
                
                <cfquery name="placementCSB" dbtype="query">
                	SELECT *
                    FROM qGetCandidatesPerHost
                    WHERE wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="CSB-Placement">
             	</cfquery>
                
                <cfquery name="placementSelf" dbtype="query">
                	SELECT *
                    FROM qGetCandidatesPerHost
                    WHERE wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="Self-Placement">
             	</cfquery>
                
                <cfquery name="placementWalkIn" dbtype="query">
                	SELECT *
                    FROM qGetCandidatesPerHost
                    WHERE wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="Walk-In">
             	</cfquery>
                
                <cfquery name="housingProvidedByHost" dbtype="query">
                	SELECT *
                    FROM qGetCandidatesPerHost
                    WHERE isHousingProvided = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                </cfquery>
                
                <cfquery name="housingFound" dbtype="query">
                	SELECT *
                    FROM qGetCandidatesPerHost
                    WHERE isHousingProvided != <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    AND housingArrangedPrivately = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                </cfquery>
                
                <cfquery name="housingNotFound" dbtype="query">
                	SELECT *
                    FROM qGetCandidatesPerHost
                    WHERE isHousingProvided != <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    AND housingArrangedPrivately = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                </cfquery>
                
                <table width="99%" cellpadding="4" cellspacing=0 align="center">
                    <tr>
                        <td colspan="11">
                            <small>
                                <strong>#qGetHosts.name# - Total candidates: #qGetCandidatesPerHost.recordCount#</strong> 
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
                        <th align="left" class="#tableTitleClass#" width="10%">Last Name</Th>
                        <th align="left" class="#tableTitleClass#" width="10%">First Name</Th>
                        <th align="left" class="#tableTitleClass#" width="8%">Sex</th>
                        <th align="left" class="#tableTitleClass#" width="10%">Country</th>
                        <th align="left" class="#tableTitleClass#" width="15%">E-mail</th>
                        <th align="left" class="#tableTitleClass#" width="7%">Start Date</th>
                        <th align="left" class="#tableTitleClass#" width="7%">End Date</th>
                        <th align="left" class="#tableTitleClass#" width="7%">Intl. Rep.</th>
                        <th align="left" class="#tableTitleClass#" width="7%">Option</th>
                        <th align="left" class="#tableTitleClass#" width="8%">Housing Arranged</th>
                        <th align="left" class="#tableTitleClass#" width="6%">Housing Details</th>
                    </tr>
                    <cfif ListFind("2,3", FORM.printOption)>
                        <tr>
                            <td colspan="14"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td>
                        </tr>
                    </cfif>
                    <cfloop query="qGetCandidatesPerHost">
                        <tr <cfif qGetCandidatesPerHost.currentRow mod 2>bgcolor="##E4E4E4"</cfif>>                    
                            <td class="style1">
                                <a href="?curdoc=candidate/candidate_info&uniqueid=#qGetCandidatesPerHost.uniqueID#" target="_blank" class="style4">
                                    #candidateID#
                                    <cfif VAL(isTerminated)>
                                        <font color="red"><b>T</b></font>
                                    </cfif>
                                </a>
                            </td>
                            <td class="style1">
                                <a href="?curdoc=candidate/candidate_info&uniqueid=#qGetCandidatesPerHost.uniqueID#" target="_blank" class="style4">
                                    #lastname#
                                </a>
                            </td>
                            <td class="style1">
                                <a href="?curdoc=candidate/candidate_info&uniqueid=#qGetCandidatesPerHost.uniqueID#" target="_blank" class="style4">
                                    #firstname#
                                </a>
                            </td>
                            <td class="style1">#sex#</td>
                            <td class="style1">#countryName#</td>
                            <td class="style1">#email#</td>
                            <cfif NOT LEN(ds2019)>
                                <td class="style1" colspan="2">Awaiting DS-2019</td>
                            <cfelseif isHousingProvided NEQ 1 AND NOT VAL(housingArrangedPrivately) AND DateAdd("d",15,NOW()) GTE startDate>
                                <cfif DateAdd("d",9,NOW()) GTE startDate>
                                    <td class="style1" colspan="2"><font color="red">Alert - program start date: #DateFormat(startdate, 'mm/dd/yyyy')#</font></td>
                                <cfelse>
                                    <td class="style1" colspan="2"><font color="yellow">Alert - program start date: #DateFormat(startdate, 'mm/dd/yyyy')#</font></td>
                                </cfif>
                            <cfelse>
                                <td class="style1">#DateFormat(startdate, 'mm/dd/yyyy')#</td>
                                <td class="style1">#DateFormat(enddate, 'mm/dd/yyyy')#</td>
                            </cfif>
                            <td class="style1">#businessName# (###userID#)</td>
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
                    <div class="title1">Candidate Housing Report by Host</div>
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
                    <div class="title1">Candidate Housing Report by Host</div>
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