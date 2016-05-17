<!--- ------------------------------------------------------------------------- ----
	
	File:		selfPlacementConfirmation.cfm
	Author:		Marcus Melo
	Date:		December 15, 2010
	Desc:		Self Placement Information Report

	Updated: 	03/14/2012 - Added Email and Phone Confirmation 
							 Hiding contact date and method for pending list

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
    <!--- Param FORM variables --->
    <cfparam name="FORM.userID" default="0">
	<cfparam name="FORM.programID" default="0">
	<cfparam name="FORM.selfJobOfferStatus" default="">
	<cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.missingPhone" default="0">
    <cfparam name="FORM.missingDocs" default="0">

    <cfscript>
		// Get Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		// Get Intl. Rep List
		qGetIntlRepList = APPLICATION.CFC.USER.getUsers(usertype=8,isActive=1,businessNameExists=1);
	</cfscript>
    
    <!--- FORM submitted --->
    <cfif FORM.submitted>
		
        <!--- Get Intl Reps --->
		<cfquery name="qGetIntlReps" datasource="#APPLICATION.DSN.Source#">
            SELECT DISTINCT
            	u.userid, 
                u.businessname
            FROM 
            	smg_users u
           	INNER JOIN
            	extra_candidates ec ON ec.intRep = u.userID
                	AND 
                    	ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">    
           			AND
                    	ec.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
            WHERE 
            	u.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
          	<cfif CLIENT.userType EQ 8>
            	AND
                	u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
            <cfelse>
				<cfif VAL(FORM.userID)>
                    AND 
                        u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
                </cfif>
          	</cfif>
            GROUP BY
            	u.userID
            ORDER BY 
            	u.businessname
		</cfquery>

        <cfquery name="qGetProgramInfo" datasource="#APPLICATION.DSN.Source#">
            SELECT 
            	programname
            FROM 
            	smg_programs
            WHERE 
            	programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
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
                ehc.hostCompanyID,
                ehc.authentication_secretaryOfState,
                ehc.authentication_departmentOfLabor,
                ehc.authentication_googleEarth,
                ehc.authentication_incorporation,
                ehc.authentication_certificateOfExistence,
                ehc.authentication_certificateOfReinstatement,
                ehc.authentication_departmentOfState,
                ehc.authentication_businessLicenseNotAvailable,
                ehc.name,
                ehc.EIN, 
                ehc.workmensCompensation,
                ecpc.jobID AS jobTitleID,  
                ecpc.selfJobOfferStatus,
                ecpc.selfConfirmationName,
                ecpc.selfConfirmationDate,
                ecpc.selfEmailConfirmationDate,
                ecpc.selfConfirmationMethod,  
                ecpc.selfConfirmationNotes,
                ecpc.placement_date,
                ej.title AS jobTitle,          
                u.businessName,
                conf.confirmed,
                conf.confirmedDate,
                j1.numberPositions,
                j1.verifiedDate,
                <cfif VAL(FORM.missingPhone) OR VAL(FORM.missingDocs)>
                    ehaf.id AS EhaFID, 
                </cfif>
                epc.confirmation_phone
            FROM
                extra_candidates ec
            LEFT OUTER JOIN
            	extra_candidate_place_company ecpc ON ecpc.candidateID = ec.candidateID 
                	AND 
                    	ecpc.hostCompanyID = ec.hostCompanyID 
					AND 
                    	ecpc.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                        
            LEFT OUTER JOIN
            	extra_jobs ej ON ej.ID = ecpc.jobID
            LEFT OUTER JOIN 
                extra_hostcompany ehc ON ehc.hostcompanyid = ecpc.hostcompanyid                
            INNER JOIN 
                smg_programs ON smg_programs.programID = ec.programID
            INNER JOIN 
                smg_users u ON u.userid = ec.intrep
            LEFT JOIN
            	extra_confirmations conf ON conf.hostID = ecpc.hostcompanyID
                	AND conf.programID = ec.programID
          	LEFT JOIN
            	extra_j1_positions j1 ON j1.hostID = ecpc.hostcompanyID
                	AND j1.programID = ec.programID
          	LEFT OUTER JOIN extra_program_confirmations epc ON epc.hostID = ecpc.hostCompanyID
         		AND epc.programID = ec.programID
                
            <cfif VAL(FORM.missingPhone) OR VAL(FORM.missingDocs)>
            LEFT JOIN extra_hostauthenticationfiles ehaf
                   ON (ehaf.hostID = ecpc.hostcompanyid
                            AND (dateExpires >= <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
                            	OR dateExpires IS NULL)
                            AND authenticationType = "workmensCompensation")
            </cfif>
            
            WHERE 
                ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
            AND ec.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
            AND ec.wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="Self-Placement">
                
           	<cfif CLIENT.userType EQ 8>
            	AND ec.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
            <cfelse>
				<cfif VAL(FORM.userID)>
                    AND  ec.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
                </cfif>
          	</cfif>
			
			<cfif LEN(FORM.selfJobOfferStatus)>
            	AND ecpc.selfJobOfferStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.selfJobOfferStatus#">                 
			</cfif>
            
            <cfif VAL(FORM.missingPhone)>
                AND epc.confirmation_phone IS NULL
                AND (conf.confirmed = 1 OR conf.confirmedDate IS NOT NULL)
                AND (numberPositions = 0 OR verifiedDate IS NOT NULL)
                AND ehc.workmensCompensation IS NOT NULL
                AND ehc.authentication_secretaryOfState > 0
                AND ehaf.id > 0
                AND ecpc.selfEmailConfirmationDate IS NOT NULL
            <cfelseif VAL(FORM.missingDocs) >
                AND (ehc.authentication_secretaryOfState = 0
                    OR ehc.authentication_departmentOfLabor = 0
                    OR ehc.authentication_googleEarth = 0
                    OR ehc.EIN IS NULL
                    OR ehc.EIN = ''
                    OR ehaf.ID = ''
                    OR ehaf.ID IS NULL
                    )
                
                AND epc.confirmation_phone IS NOT NULL
                AND ecpc.selfEmailConfirmationDate IS NOT NULL
                AND (numberPositions = 0 OR verifiedDate IS NOT NULL)
            </cfif>
            
            GROUP BY ec.candidateID
                       
            ORDER BY
            	ehc.name,
                ec.candidateID            
        </cfquery>
        

        <cfquery name="qTotalFormsIssued" dbtype="query">
            SELECT
                ds2019
            FROM
                qGetAllCandidates
            WHERE
                ds2019 is not null
            AND
                ds2019 != ''
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

            </cfquery>
			
            <cfreturn qFilterGetAllCandidates>
        </cffunction>

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
            <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Intl. Rep. Reports -> Self Placement Vetting</font>
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
                	<option value="#programID#" <cfif qGetProgramList.programID eq FORM.programID> selected="selected" </cfif> >#programname#</option>
                </cfloop>
            </select>
        </td>
    </tr>
    <tr>
        <td valign="middle" align="right" class="style1"><b>Job Offer Status:</b></td>
        <td> 
            <select name="selfJobOfferStatus" class="style1">
                <option value="" <cfif NOT LEN(FORM.selfJobOfferStatus)> selected="selected" </cfif> >All</option>
                <option value="Pending" <cfif FORM.selfJobOfferStatus EQ 'Pending'> selected="selected" </cfif> >Pending</option>
                <option value="Confirmed" <cfif FORM.selfJobOfferStatus EQ 'Confirmed'> selected="selected" </cfif> >Confirmed</option>
                <option value="Rejected" <cfif FORM.selfJobOfferStatus EQ 'Rejected'> selected="selected" </cfif> >Rejected</option>
            </select>
        </td>
    </tr>
    <tr>
        <td valign="middle" align="right" class="style1"><b>Missing Only Phone Confirmation:</b></td>
        <td  class="style1"> 
        	<input type="checkbox" name="missingPhone" value="1" <cfif FORM.missingPhone EQ '1'>checked="checked"</cfif>> Yes
        </td>
    </tr>
    <tr>
        <td valign="middle" align="right" class="style1"><b>Missing Only Documents:</b></td>
        <td  class="style1"> 
            <input type="checkbox" name="missingDocs" value="1" <cfif FORM.missingDocs EQ '1'>checked="checked"</cfif>> Yes
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
    	
        <div style="border-bottom:1px solid ##999; margin:10px;">&nbsp;</div>
        
        <div class="style1">&nbsp; &nbsp; <strong>Total Number of Students:</strong> #qGetAllCandidates.recordCount# <br /><br /> </div>
        
        <div class="style1">&nbsp; &nbsp; <strong>Total Number of Forms Issued:</strong> #qTotalFormsIssued.recordCount# <br /><br /> </div>
        
        <cfset totalFormsNotIssued = qGetAllCandidates.recordCount - qTotalFormsIssued.recordCount>
        
        <div class="style1">&nbsp; &nbsp; <strong>Total Number of Forms to be Issued:</strong> #totalFormsNotIssued# <br /><br /> </div>
        
        <div class="style1">&nbsp; &nbsp; Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</div>
        
        <div style="border-bottom:1px solid ##999; margin:10px;">&nbsp;</div>
    	
        <table width="99%" cellpadding="4" cellspacing=0 align="center">
        
            <cfloop query="qGetIntlReps">
            
                <cfscript>
                    // Total By Agent
                    qTotalPerAgent = filterGetAllCandidates(placementType='ALL', intRep=qGetIntlReps.userID);
                </cfscript>
                
                <cfquery name="qCountFormsIssued" dbtype="query">
                    SELECT
                        ds2019
                    FROM
                        qTotalPerAgent
                    WHERE
                        ds2019 is not null
                    AND
                        ds2019 != ''
                </cfquery>
                
                <cfset formsIssued = qCountFormsIssued.recordCount>
                <cfset formsNotIssued = qTotalPerAgent.recordCount - qCountFormsIssued.recordCount>                
                
                <cfif qTotalPerAgent.recordCount>
                    <tr>
                        <td colspan="16">
                        	<strong><small>
                            	#qGetIntlReps.businessname#  |  Total candidates: #qTotalPerAgent.recordCount#  |  DS-2019 forms issued: #formsIssued#  |  DS-2019 forms to be issued: #formsNotIssued#
                            </strong></small>
                        </td>
                    </tr>
                    
                    <cfif ListFind("2,3", FORM.printOption)>
                        <tr>
                            <td colspan="9"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td>
                        </tr>
                    </cfif>
                    <tr>
                        <Th align="left" class="#tableTitleClass#">Student</Th>
                        <th align="left" class="#tableTitleClass#">Gender</th>
                        <th align="left" class="#tableTitleClass#">Start Date</th>
                        <th align="left" class="#tableTitleClass#">End Date</th>
                        <th align="left" class="#tableTitleClass#">Placement Information</th>
                        <th align="left" class="#tableTitleClass#">Job Title</th>
                        <th align="left" class="#tableTitleClass#">Placement Date</th>                        
                        <th align="left" class="#tableTitleClass#">Job Offer Status</th>
                        <!--- REMOVED - Requested by Anca
						<cfif FORM.selfJobOfferStatus NEQ "pending" AND FORM.selfJobOfferStatus NEQ "confirmed" AND FORM.selfJobOfferStatus NEQ "rejected">
                        	<th align="left" class="#tableTitleClass#">Contact Date</th>
                        </cfif>
						--->
                        <th align="left" class="#tableTitleClass#">Contact Name</th>
                        <th align="left" class="#tableTitleClass#">Confirmation of Terms</th>
                        <th align="left" class="#tableTitleClass#">Available J1 Positions</th>
                        <th align="left" class="#tableTitleClass#">Authentication Missing</th>
                        <th align="left" class="#tableTitleClass#">EIN</th>
                        <th align="left" class="#tableTitleClass#">Workmen's Compensation</th>
                        <!--- REMOVED - Requested by Anca
                        <cfif FORM.selfJobOfferStatus NEQ "pending" AND FORM.selfJobOfferStatus NEQ "confirmed" AND FORM.selfJobOfferStatus NEQ "rejected">
                        	<th align="left" class="#tableTitleClass#">Contact Method</th>
                        </cfif>
						--->
                        <th align="left" class="#tableTitleClass#">Email Confirmation</th>
                        <th align="left" class="#tableTitleClass#">Phone Confirmation</th>
                        <cfif CLIENT.userType NEQ 8>
                        	<th align="left" class="#tableTitleClass#">Notes</th>
                      	</cfif>
                    </tr>
                    <cfif ListFind("2,3", FORM.printOption)>
                        <tr>
                            <td colspan="9"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td>
                        </tr>
                    </cfif>
                    
                    
                    <cfloop query="qTotalPerAgent">
                    
                    	<!--- Get workmans compensation file --->
                        <cfquery name="qGetWCFile" datasource="#APPLICATION.DSN.Source#">
                            SELECT *
                            FROM extra_hostauthenticationfiles
                            WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qTotalPerAgent.hostCompanyID#">
                            AND (dateExpires >= <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
                            	OR dateExpires IS NULL)
                            AND authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="workmensCompensation">
                            ORDER BY dateAdded DESC
                        </cfquery>
                        
                    	
                        <cfif (NOT VAL(FORM.missingPhone)) OR ( VAL(FORM.missingPhone) AND VAL(qGetWCFile.recordCount))>
                        
                        <tr <cfif qTotalPerAgent.currentRow mod 2>bgcolor="##E4E4E4"</cfif>>                    
                            <td class="style1">
                                <a href="?curdoc=candidate/candidate_info&uniqueid=#qTotalPerAgent.uniqueID#" target="_blank" class="style4">
                                    #qTotalPerAgent.firstname# #qTotalPerAgent.lastname# (###qTotalPerAgent.candidateID#)
                                </a>
                            </td>
                            <td class="style1">#qTotalPerAgent.sex#</td>
                            <td class="style1">#DateFormat(qTotalPerAgent.startdate, 'mm/dd/yyyy')#</td>
                            <td class="style1">#DateFormat(qTotalPerAgent.enddate, 'mm/dd/yyyy')#</td>
                            <td class="style1">
                                <a href="?curdoc=hostcompany/hostCompanyInfo&hostCompanyID=#qTotalPerAgent.hostCompanyID#" target="_blank" class="style4">#qTotalPerAgent.name#</a>
                            </td>
                            <td class="style1">#qTotalPerAgent.jobTitle#</td>
                            <td class="style1">#DateFormat(qTotalPerAgent.placement_date, 'mm/dd/yyyy')#</td>                            
                            <td class="style1">#qTotalPerAgent.selfJobOfferStatus#</td>
                            <!--- REMOVED - Requested by Anca                            
                            <cfif FORM.selfJobOfferStatus NEQ "pending" AND FORM.selfJobOfferStatus NEQ "confirmed" AND FORM.selfJobOfferStatus NEQ "rejected">
	                            <td class="style1">#DateFormat(qTotalPerAgent.selfConfirmationDate, 'mm/dd/yyyy')#</td>
                            </cfif>--->
                            <td class="style1">#qTotalPerAgent.selfConfirmationName#</td>
                            <td class="style1">
                            	<cfif qTotalPerAgent.confirmed EQ 1>
                                	<cfif LEN(qTotalPerAgent.confirmedDate)>
                                    	#DateFormat(qTotalPerAgent.confirmedDate, "mm/dd/yyyy")#
                                  	<cfelse>
                                    	<font color="red">Missing</font>
                                    </cfif>
                               	<cfelse>
                                	<font color="red">Missing</font>
                               	</cfif>
                          	</td>
                            <td class="style1">
                            	<cfif qTotalPerAgent.confirmed EQ 1 AND VAL(qTotalPerAgent.numberPositions)>
                                	<cfif LEN(qTotalPerAgent.verifiedDate)>
                                    	#DateFormat(qTotalPerAgent.verifiedDate, "mm/dd/yyyy")#
                                  	<cfelse>
                                    	<font color="red">Missing</font>
                                    </cfif>
                               	<cfelse>
                                	<font color="red">Missing</font>
                               	</cfif>
                          	</td>
                            <td class="style1">
                            	<font color="red">
									<cfif NOT VAL(qTotalPerAgent.authentication_secretaryOfState) AND NOT VAL(qTotalPerAgent.authentication_businessLicenseNotAvailable)>-Business License<br /></cfif>
                                    <cfif VAL(qTotalPerAgent.authentication_businessLicenseNotAvailable)>
                                        <cfif NOT VAL(qTotalPerAgent.authentication_incorporation)>-Incorporation<br /></cfif>
                                        <cfif NOT VAL(qTotalPerAgent.authentication_certificateOfExistence)>-Certificate of Existence<br /></cfif>
                                        <cfif NOT VAL(qTotalPerAgent.authentication_certificateOfReinstatement)>-Certificate of Reinstatement<br /></cfif>
                                        <cfif NOT VAL(qTotalPerAgent.authentication_departmentOfState)>-Department of State<br /></cfif>
                                    </cfif>
                                    <cfif NOT VAL(qTotalPerAgent.authentication_departmentOfLabor)>-Department of Labor<br /></cfif>
                                    <cfif NOT VAL(qTotalPerAgent.authentication_googleEarth)>-Google Earth<br /></cfif>
                              	</font>
                                <cfif 
									( 
										VAL(qTotalPerAgent.authentication_secretaryOfState)
										OR 
										(
										 	VAL(qTotalPerAgent.authentication_businessLicenseNotAvailable)
											AND VAL(qTotalPerAgent.authentication_incorporation)
											AND VAL(qTotalPerAgent.authentication_certificateOfExistence)
											AND VAL(qTotalPerAgent.authentication_certificateOfReinstatement)
											AND VAL(qTotalPerAgent.authentication_departmentOfState)
										)
									)
									AND VAL(qTotalPerAgent.authentication_departmentOfLabor) 
									AND VAL(qTotalPerAgent.authentication_googleEarth)>
                                	n/a
                                </cfif>
                            </td>
                            <td class="style1">
                            	<cfif CLIENT.userType NEQ 8>
                                	#qTotalPerAgent.EIN#
                              	<cfelse>
                                	<cfif LEN(qTotalPerAgent.EIN)>
                                    	Yes
                                    <cfelse>
                                    	No
                                    </cfif>
                                </cfif>
                            </td>
                            <td class="style1">
                            	<cfif VAL(qGetWCFile.recordCount)>
									<cfif ListFind("0,1", qTotalPerAgent.workmensCompensation)>
                                        #YesNoFormat(qTotalPerAgent.workmensCompensation)#
                                    <cfelseif qTotalPerAgent.workmensCompensation EQ 2>
                                        N/A
                                    </cfif>
                              	<cfelse>
                                	<font color="red">Missing</font>
                                </cfif>                                           
							</td>
                            <!--- REMOVED - Requested by Anca
                            <cfif FORM.selfJobOfferStatus NEQ "pending" AND FORM.selfJobOfferStatus NEQ "confirmed" AND FORM.selfJobOfferStatus NEQ "rejected">
	                            <td class="style1">#qTotalPerAgent.selfConfirmationMethod#</td>
                            </cfif>
							--->
                            <td class="style1">
                            	<cfif LEN(qTotalPerAgent.selfEmailConfirmationDate)>
                                	#DateFormat(qTotalPerAgent.selfEmailConfirmationDate, 'mm/dd/yyyy')#
                               	<cfelse>
                                	<font color="red">Missing</font>
                                </cfif>
                          	</td>
                            <td class="style1">
                            	<cfif LEN(qTotalPerAgent.confirmation_phone)>
                                	#DateFormat(qTotalPerAgent.confirmation_phone, 'mm/dd/yyyy')#
                               	<cfelse>
                                	<font color="red">Missing</font>
                                </cfif>
                     		</td>
                            <cfif CLIENT.userType NEQ 8>
                            	<td class="style1">#qTotalPerAgent.selfConfirmationNotes#</td>
                          	</cfif>
                        </tr>
                        </cfif>
                    </cfloop>        

                    <tr><td colspan="9">&nbsp;</td></tr>
                    
                </cfif>
                                
            </cfloop>

        </table>


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
