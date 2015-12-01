<!--- Kill extra output --->
<cfsilent>

	<cfsetting requesttimeout="9999">

    <!--- Param FORM Variables --->
	<cfparam name="FORM.programID" default="">
	<cfparam name="FORM.hostCompanyID" default="0">
	<cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.placementType" default="All">
    <cfparam name="FORM.studentStatus" default="All">
    
    <cfparam name="URL.programID" default="0">
    <cfparam name="URL.hostCompanyID" default="0">

    <cfscript>
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		qGetHostCompanyList = APPLICATION.CFC.HOSTCOMPANY.getHostCompanies(companyID=CLIENT.companyID);
		
		if (VAL(URL.programID) AND NOT VAL(FORM.programID)) {
			FORM.programID = URL.programID;	
		}
		if (VAL(URL.hostCompanyID) AND NOT VAL(FORM.hostCompanyID)) {
			FORM.hostCompanyID = URL.hostCompanyID;
		}
	</cfscript>

    <!--- FORM submitted --->
    <cfif FORM.submitted>

        <!--- Get Host Companies Assigned to Candidates --->
        <cfquery name="qGetHostCompany" datasource="#APPLICATION.DSN.Source#">
            SELECT 
                ehc.hostCompanyID,
                ehc.name
            FROM 
            	extra_hostcompany ehc
         	WHERE
            	ehc.hostCompanyID IN (
                	SELECT 
                    	ecpc.hostCompanyID 
                 	FROM
                    	extra_candidate_place_company ecpc 
                 	INNER JOIN 
                   		extra_candidates ec ON ec.candidateID = ecpc.candidateID
                 	WHERE
                    	ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
					AND
                    	ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
                    AND 
                        ec.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
                  	AND
                    	ecpc.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                  	<cfif FORM.placementType EQ 1>
                    	AND
                        	ecpc.isSecondary = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                   	<cfelseif FORM.placementType EQ 2>
                    	AND
                        	ecpc.isSecondary = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    </cfif> )

			<cfif VAL(FORM.hostcompanyID)> 
                AND
                    ehc.hostcompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">                               
            </cfif>

       		GROUP BY
            	ehc.hostCompanyID
            ORDER BY
            	ehc.name
		</cfquery>
		
        <!--- Get All Candidates --->
        <cfquery name="qGetAllCandidates" datasource="#APPLICATION.DSN.Source#">
            SELECT 
                c.candidateID,
                c.uniqueID,
                c.visaInterview,
                ecpc.hostCompanyID,
                ecpc.isSecondary,
                c.firstname,             
                c.lastname, 
                c.sex, 
                c.dob,                
                c.email, 
                c.ssn, 
                c.ds2019,
                c.startdate, 
                c.enddate, 
                c.wat_placement, 
                c.status,
                c.englishAssessment,
                ej.title,
                u.businessname,
                country.countryname,
                eir.subject
            FROM   
                extra_candidates c
            INNER JOIN
                smg_users u on u.userid = c.intrep
            INNER JOIN
            	extra_candidate_place_company ecpc ON ecpc.candidateID = c.candidateID
                	AND
                    	ecpc.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                  	<cfif FORM.placementType EQ 1>
                    	AND
                    		ecpc.isSecondary = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                    <cfelseif FORM.placementType EQ 2>
                    	AND
                        	ecpc.isSecondary = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    </cfif>
            LEFT JOIN 
                smg_countrylist country ON country.countryid = c.home_country
            LEFT JOIN
            	extra_jobs ej ON ej.ID = ecpc.jobID
          	LEFT JOIN
            	extra_incident_report eir ON eir.candidateID = c.candidateID
                AND
                	eir.isSolved = 0
              	AND
                	eir.subject = "Terminated"
            WHERE 
                c.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">    
            AND 
                c.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
            AND 
                c.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
      		<cfif FORM.studentStatus NEQ 'All'>
  				AND
        			c.status = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentStatus#">
   			</cfif>
           	<cfif VAL(FORM.hostcompanyID)> 
                AND
                    ecpc.hostcompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">                               
			</cfif>              
       		ORDER BY
                c.candidateID
		</cfquery>
        
        <cfquery name="qGetTotalNumberCandidates" dbtype="query">
        	SELECT DISTINCT
            	candidateID
          	FROM
            	qGetAllCandidates
        </cfquery>
        
        <cfquery name="qGetTotalNumberCSBCandidates" dbtype="query">
        	SELECT DISTINCT
            	candidateID
          	FROM
            	qGetAllCandidates
          	WHERE
            	wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="CSB-Placement">
        </cfquery>
        
        <cfquery name="qGetTotalNumberSelfCandidates" dbtype="query">
        	SELECT DISTINCT
            	candidateID
          	FROM
            	qGetAllCandidates
          	WHERE
            	wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="Self-Placement">
        </cfquery>
        
        <cfquery name="qGetTotalNumberWalkInCandidates" dbtype="query">
        	SELECT DISTINCT
            	candidateID
          	FROM
            	qGetAllCandidates
          	WHERE
            	wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="Walk-In">
        </cfquery>

        <cffunction name="filterGetAllCandidates" hint="Gets total by Host Company">
        	<cfargument name="placementType" default="" hint="Placement Type is not required">
            <cfargument name="hostCompanyID" default="0" hint="hostCompanyID is not required">
            
            <cfquery name="qFilterGetAllCandidates" dbtype="query">
                SELECT
                    *
                FROM	
                    qGetAllCandidates
                WHERE
                	1 = 1
                    
				<cfif VAL(ARGUMENTS.hostcompanyID)> 
                    AND
                        hostcompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostcompanyID#">                               
                </cfif>                
                
                <cfif ARGUMENTS.placementType NEQ 'All'>
                    AND
                        wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.placementType#">
            	</cfif>
                
                ORDER BY 
                    candidateID
            </cfquery>
            
            <cfreturn qFilterGetAllCandidates>
        </cffunction>

	</cfif>

</cfsilent>

<cfoutput>

<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
<input type="hidden" name="submitted" value="1" />

    <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
        <tr valign="middle" height="24">
            <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan="2">
            	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Host Company Reports -> All Participating Candidates</font>
			</td>                
        </tr>
        <tr valign="middle" height="24">
            <td valign="middle" colspan="2">&nbsp;</td>
        </tr>
        <tr valign="middle">
            <td align="right" valign="middle" class="style1"><b>Host Company: </b></td>
            <td valign="middle">  
                <select name="hostCompanyID" class="style1">
                    <option value="ALL">---  All Host Companies  ---</option>
                    <cfloop query="qGetHostCompanyList">
                    	<option value="#hostcompanyID#" <cfif qGetHostCompanyList.hostcompanyID EQ FORM.hostCompanyID> selected </cfif> >#qGetHostCompanyList.name#</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
            <td valign="middle" align="right" class="style1"><b>Program: </b></td><td>
                <select name="programID" class="style1">
                    <option value="0"></option>
                    <cfloop query="qGetProgramList">
                    	<option value="#programID#" <cfif qGetProgramList.programID EQ FORM.programID> selected </cfif> >#programname#</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
        	<td valign="middle" align="right" class="style1"><b>Placement Type:</b></td>
            <td>
            	<select name="placementType" class="style1">
                	<option value="All" <cfif "All" EQ FORM.placementType> selected</cfif>>All</option>
                    <option value="1" <cfif "1" EQ FORM.placementType> selected</cfif>>Primary</option>
                    <option value="2" <cfif "2" EQ FORM.placementType> selected</cfif>>Secondary</option>
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
            <td class="style1"> 
                <input type="radio" name="printOption" id="printOption1" value="1" <cfif FORM.printOption EQ 1> checked="checked" </cfif> > <label for="printOption1">Onscreen (View Only)</label>
                <input type="radio" name="printOption" id="printOption2" value="2" <cfif FORM.printOption EQ 2> checked="checked" </cfif> > <label for="printOption2">Print (PDF)</label> 
                <input type="radio" name="printOption" id="printOption3" value="3" <cfif FORM.printOption EQ 3> checked="checked" </cfif> > <label for="printOption3">Excel (XLS)</label>
            </td>            
        </tr>
        <tr>
            <td colspan="2" align="center"><br />
                <input type="submit" value="Generate Report" class="style1" /><br />
            </td>
        </tr>
    </table>

</form>

<br />

<!--- Print --->
<cfif FORM.submitted>
	
	<cfsavecontent variable="reportContent">
		
        <cfloop query="qGetHostCompany">
			            
			<cfscript>
                // Total By Agent
                qTotalPerHostCompany = filterGetAllCandidates(placementType='ALL', hostCompanyID=qGetHostCompany.hostCompanyID);
				
				totalPerHostCompanyCSBPlacements = filterGetAllCandidates(placementType='CSB-Placement', hostCompanyID=qGetHostCompany.hostCompanyID).recordCount;
                
                totalPerHostCompanySelfPlacements = filterGetAllCandidates(placementType='Self-Placement', hostCompanyID=qGetHostCompany.hostCompanyID).recordCount;
                
                totalPerHostCompanyWalkInPlacements = filterGetAllCandidates(placementType='Walk-In', hostCompanyID=qGetHostCompany.hostCompanyID).recordCount;
            </cfscript>
            
            <cfif qTotalPerHostCompany.recordCount>

                <table width="98%" cellpadding="4" cellspacing="0" align="center" style="margin-top:10px; margin-bottom:20px; border:1px solid ##4F8EA4; line-height:15px;"> 
                    <tr>
                        <td colspan="17">
                                <strong>#qGetHostCompany.name# - Total candidates: #qTotalPerHostCompany.recordCount#</strong> 
                                (
                                    #totalPerHostCompanyCSBPlacements# CSB; &nbsp; 
                                    #totalPerHostCompanySelfPlacements# Self; &nbsp; 
                                    #totalPerHostCompanyWalkInPlacements# Walk-In 
                                )
                            </small>
                        </td>
                    </tr>
                    <tr style="background-color:##4F8EA4; color:##FFF; padding:5px; font-weight:bold; font-size: 11px; vertical-align:top;">
                        <td width="4%">ID</td>
                        <td width="10%">Last Name</td>
                        <td width="8%">First Name</td>
                        <td width="3%">Sex</td>
                        <td width="5%">DOB</td>
                        <td width="5%">Country</td>
                        <td width="10%">Email</td>
                        <td width="7%">Job Title</td>
                        <td width="5%">DS-2019</td>
                        <td width="5%">SSN</td>
                        <td width="5%">Start Date</td>
                        <td width="5%">End Date</td>
                        <td width="10%">Intl. Rep.</td>
                        <td width="7%">Option</td>
                        <td width="5%">Placement Type</td>
                        <td width="8%">English Assessment CSB</td>
                        <td width="5%">Visa Interview</td>
                    </tr>
                    <cfloop query="qTotalPerHostCompany">
                        <tr bgcolor="###IIf(qTotalPerHostCompany.currentRow MOD 2 ,DE("FFFFFF") ,DE("E4E4E4") )#">
                            <td>
                            	<a href="?curdoc=candidate/candidate_info&uniqueid=#qTotalPerHostCompany.uniqueID#" target="_blank" class="style4">
                                	#qTotalPerHostCompany.candidateID#
                                    <cfif LEN(qTotalPerHostCompany.subject)>
                                    	<font color="red"><b>T</b></font>
                                    </cfif>
                               	</a>
                           	</td>
                            <td><a href="?curdoc=candidate/candidate_info&uniqueid=#qTotalPerHostCompany.uniqueID#" target="_blank" class="style4">#qTotalPerHostCompany.lastname#</a></td>
                            <td><a href="?curdoc=candidate/candidate_info&uniqueid=#qTotalPerHostCompany.uniqueID#" target="_blank" class="style4">#qTotalPerHostCompany.firstname#</a></td>
                            <td class="style1">#qTotalPerHostCompany.sex#</td>
                            <td class="style1">#dateformat(qTotalPerHostCompany.dob, 'mm/dd/yyyy')#</td>
                            <td class="style1">#qTotalPerHostCompany.countryname#</td>
                            <td class="style1"><a href="mailto:#qTotalPerHostCompany.email#" class="style4">#qTotalPerHostCompany.email#</a></td>
                            <td class="style1">#qTotalPerHostCompany.title#</td>
                            <td class="style1">#qTotalPerHostCompany.ds2019#</td>
                            <td class="style1">
                                <cfif ListFind("1,2,3,4", CLIENT.userType) AND LEN(qTotalPerHostCompany.SSN)>
                                    <span class="style1">#APPLICATION.CFC.UDF.displaySSN(qTotalPerHostCompany.SSN)#</span>
                                </cfif>                        
                            </td>
                            <cfif LEN(qTotalPerHostCompany.ds2019)>
                                <td><span class="style1">#dateformat(qTotalPerHostCompany.startdate, 'mm/dd/yyyy')#</span></td>
                                <td><span class="style1">#dateformat(qTotalPerHostCompany.enddate, 'mm/dd/yyyy')# </span></td>
                            <cfelse>
                                <td colspan="2" align="center"><span class="style1">Awaiting DS-2019</span></td>
                            </cfif>
                            <td><span class="style1">#qTotalPerHostCompany.businessname#</span></td>
                            <td><span class="style1">#qTotalPerHostCompany.wat_placement#</span></td>
                            <td><span class="style1"><cfif VAL(qTotalPerHostCompany.isSecondary)>Secondary<cfelse>Primary</cfif></span></td>
                            <td><span class="style1">#qTotalPerHostCompany.englishAssessment#</span></td>
                            <td><span class="style1">#DateFormat(qTotalPerHostCompany.visaInterview,'mm/dd/yyyy')#</span></td>
                        </tr>
                        
                        <!--- Seeking Employment or Exempt from Pre-Placement - Display Reason --->
                        <cfif ListFind("195,4600",qGetHostCompany.hostCompanyID)>
                        	
                            <cfscript>
                            	// Get Seeking Employment Comments
								qGetSeekingEmploymentComments = APPLICATION.CFC.CANDIDATE.getSeekingEmploymentComments(candidateID=qTotalPerHostCompany.candidateID);
							</cfscript>
                        
                            <cfquery name="qGetHostHistory" datasource="#APPLICATION.DSN.Source#">
                                SELECT  
                                    reason_host,
                                    placement_date,
                                    seekingDeadline
                                FROM 
                                    extra_candidate_place_company 
                                WHERE 
                                    candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qTotalPerHostCompany.candidateID#">
                                AND	
                                    reason_host != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                                ORDER BY
                                    candCompID DESC
                                LIMIT 1		                           
                            </cfquery>
                            
                            <cfscript>
								daysSincePlacement = ROUND(NOW() - qGetHostHistory.placement_date);
								alertColor = "black";
								if (daysSincePlacement GTE 7) {
									alertColor = "orange";
								}
								if (daysSincePlacement GTE 14) {
									alertColor = "red";
								}
							</cfscript>
                            
                            <!--- Only display for Seeking Employment --->
							<cfif qGetHostCompany.hostCompanyID EQ 195>
                                <tr bgcolor="###IIf(qTotalPerHostCompany.currentRow MOD 2 ,DE("FFFFFF") ,DE("E4E4E4") )#">
                                    <td colspan="17" class="style1" style="border-top:1px solid ###IIf(qTotalPerHostCompany.currentRow MOD 2 ,DE("E4E4E4") ,DE("FFFFFF") )#;">
										<strong>Reason:</strong> 
                                        <cfloop query="qGetHostHistory">
                                            #qGetHostHistory.reason_host# <br />
                                        </cfloop>
                                    </td>
                                </tr>
                                
                                <cfif qGetSeekingEmploymentComments.recordCount GT 0 >
                                <tr bgcolor="###IIf(qTotalPerHostCompany.currentRow MOD 2 ,DE("FFFFFF") ,DE("E4E4E4") )#">
                                    <td colspan="17" class="style1" style="border-top:1px solid ###IIf(qTotalPerHostCompany.currentRow MOD 2 ,DE("E4E4E4") ,DE("FFFFFF") )#;">
										<strong>Comments:</strong> 
                                        <cfloop query="qGetSeekingEmploymentComments">
                                            #DateFormat(qGetSeekingEmploymentComments.date, 'mm/dd/yyyy')# - #qGetSeekingEmploymentComments.note#
                                            <hr style="margin: 5px 10px; border: none; border-bottom: 1px solid ##ccc" />
                                        </cfloop>
                                    </td>
                                </tr>
                                </cfif>
                                
                            </cfif>
                           	
                            <tr bgcolor="###IIf(qTotalPerHostCompany.currentRow MOD 2 ,DE("FFFFFF") ,DE("E4E4E4") )#">
                                <td colspan="17" class="style1" style="border-top:1px solid ###IIf(qTotalPerHostCompany.currentRow MOD 2 ,DE("E4E4E4") ,DE("FFFFFF") )#;">
                                  	<strong>Deadline: </strong><cfif IsDate(qGetHostHistory.seekingDeadline)>#DateFormat(qGetHostHistory.seekingDeadline,'mm/dd/yyyy')#<cfelse>n/a</cfif>
                                    <strong>
                                    	Days Since Placement: 
                                    	<span style="color:#alertColor#;">#daysSincePlacement#</span>
                                  	</strong> 
                                </td>
                            </tr>
                        </cfif>
                        
                    </cfloop>
    
                </table>
                
         	</cfif>
         
		</cfloop>
          
        <div class="style1"><strong>&nbsp; &nbsp; CSB-Placement:</strong> #qGetTotalNumberCSBCandidates.recordCount#</div>	
        <div class="style1"><strong>&nbsp; &nbsp; Self-Placement:</strong> #qGetTotalNumberSelfCandidates.recordCount#</div>
        <div class="style1"><strong>&nbsp; &nbsp; Walk-In:</strong> #qGetTotalNumberWalkInCandidates.recordCount#</div>
        <div class="style1"><strong>&nbsp; &nbsp; ---------------------------------------------</strong></div>
        <div class="style1"><strong>&nbsp; &nbsp; Total Number of Students:</strong> #qGetTotalNumberCandidates.recordCount#</div>
        <div class="style1"><strong>&nbsp; &nbsp; ---------------------------------------------</strong></div>  		
		    	
    </cfsavecontent>

	<!-----Display Reports---->
    <cfswitch expression="#FORM.printOption#">
    
        <!--- Screen --->
        <cfcase value="1">
            <!--- Include Report --->
            #reportContent#
        </cfcase>
    
        <!--- PDF --->
        <cfcase value="2">   
            <cfdocument format="pdf" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">          	
                <style type="text/css">
                <!--
                .style1 {
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
                <div class="title1">Students hired per company</div>
                <img src="../../pics/black_pixel.gif" width="100%" height="2">
                
                <!--- Include Report --->
                #reportContent#
            </cfdocument>
        </cfcase>
    
        <!--- Excel --->
        <cfcase value="3">
    
            <!--- set content type --->
            <cfcontent type="application/msexcel">
            
            <!--- suggest default name for XLS file --->
            <cfheader name="Content-Disposition" value="attachment; filename=studentsHiredPerCompany.xls"> 
    
            <style type="text/css">
            <!--
            .style1 {
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
            <div class="title1">Students hired per company</div>
            <img src="../../pics/black_pixel.gif" width="100%" height="2">
            
            <!--- Include Report --->
            #reportContent#
            
            <cfabort>
    
        </cfcase>
        
        <cfdefaultcase>    
            <div align="center" class="style1">
                Print results will replace the menu options and take a bit longer to generate. <br />
                Onscreen will allow you to change criteria with out clicking your back button.
            </div>  <br />
        </cfdefaultcase>
        
    </cfswitch>

<cfelse>

    <div align="center" class="style1">
        Print results will replace the menu options and take a bit longer to generate. <br />
        Onscreen will allow you to change criteria with out clicking your back button.
    </div>  <br />

</cfif>    

</cfoutput>
