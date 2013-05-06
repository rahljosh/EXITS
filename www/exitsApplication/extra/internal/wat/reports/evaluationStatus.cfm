<!--- ------------------------------------------------------------------------- ----
	
	File:		evaluationStatus.cfm
	Author:		James Griffiths
	Date:		January 02, 2013
	Desc:		Shows the evaluation status of candidates under a given rep and in
				a given program.

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- PARAM FORM VARIABLES --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.intlRepID" default="0"> <!--- 0 for all reps --->
    <cfparam name="FORM.evaluationStatus" default="all"> <!--- all, complete, missing, (1-4 -> missing specific evaluation) --->
    
    <!--- Get the list of programs --->
    <cfscript>
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		qGetIntlRepList = APPLICATION.CFC.USER.getUsers(usertype=8,isActive=1,businessNameExists=1);
	</cfscript>
 
</cfsilent>
        
<!--- FORM SUBMITTED --->
<cfif FORM.submitted>

	<!--- Get selected reps with candidates in the selected program --->
	<cfquery name="qGetIntlReps" datasource="#APPLICATION.DSN.Source#">
		SELECT u.userID, u.businessName
		FROM smg_users u
		INNER JOIN extra_candidates ec ON ec.intRep = u.userID
			AND ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
			AND ec.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="1">
		WHERE u.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
		<cfif CLIENT.userType EQ 8>
			AND u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
		<cfelseif VAL(FORM.intlRepID)>
			AND u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intlRepID#">
		</cfif>
        GROUP BY u.userID
		ORDER BY u.businessname
	</cfquery>
	
</cfif>

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
                    <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Program Reports -> Evaluation Status Report</font>
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
                <td valign="middle" align="right" class="style1"><b>Evaluation Status:</b><br/><span style="font-size:8.5px;">(Based on applicable evaluations)</span></td>
                <td> 
                    <select name="evaluationStatus" class="style1">
                        <option value="all" <cfif "all" EQ FORM.evaluationStatus> selected</cfif>>All</option>
                        <option value="complete" <cfif "complete" EQ FORM.evaluationStatus> selected</cfif>>All Complete</option>
                        <option value="missing" <cfif "missing" EQ FORM.evaluationStatus> selected</cfif>>All Missing</option>
                        <option value="1" <cfif "1" EQ FORM.evaluationStatus> selected</cfif>>Missing First Evaluation</option>
                        <option value="2" <cfif "2" EQ FORM.evaluationStatus> selected</cfif>>Missing Second Evaluation</option>
                        <option value="3" <cfif "3" EQ FORM.evaluationStatus> selected</cfif>>Missing Third Evaluation</option>
                        <option value="4" <cfif "4" EQ FORM.evaluationStatus> selected</cfif>>Missing Fourth Evaluation</option>
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
        
        	<cfset totalCandidatesCount = 0>
        	<span style="font-size:12px" id="totalCandidatesInput"></span>
        
        	<cfloop query="qGetIntlReps">
            
            	<cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#">
                	SELECT ec.candidateID, ec.lastName, ec.firstName, ec.email, ec.sex, ec.watDateCheckedIn, ec.watDateEvaluation1, ec.watDateEvaluation2, ec.watDateEvaluation3, ec.watDateEvaluation4, eir.subject, eh.name as hostcompanyname
                    FROM extra_candidates ec
                    LEFT JOIN extra_incident_report eir ON eir.candidateID = ec.candidateID
            			AND eir.isSolved = 0
            			AND eir.subject = "Terminated"
                    LEFT JOIN extra_hostcompany eh on eh.hostcompanyid = ec.hostcompanyid
                    WHERE ec.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(userID)#">
                    AND ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
                    AND ec.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    <cfif FORM.evaluationStatus EQ "missing">
                    	AND DATEDIFF(NOW(),watDateCheckedIn) > 30
                        AND watDateEvaluation1 IS NULL
                        AND watDateEvaluation2 IS NULL
                        AND watDateEvaluation3 IS NULL
                        AND watDateEvaluation4 IS NULL
                   	<cfelseif FORM.evaluationStatus EQ "complete">
                    	AND ((
                        	DATEDIFF(NOW(),watDateCheckedIn) > 90
                            AND watDateEvaluation1 IS NOT NULL
                            AND watDateEvaluation2 IS NOT NULL
                            AND watDateEvaluation3 IS NOT NULL
                            AND watDateEvaluation4 IS NOT NULL )
                      	OR (
                        	DATEDIFF(NOW(),watDateCheckedIn) > 60
                            AND watDateEvaluation1 IS NOT NULL
                            AND watDateEvaluation2 IS NOT NULL
                            AND watDateEvaluation3 IS NOT NULL )
                        OR (
                        	DATEDIFF(NOW(),watDateCheckedIn) > 30
                            AND watDateEvaluation1 IS NOT NULL
                            AND watDateEvaluation2 IS NOT NULL )
                        OR (
                            watDateEvaluation1 IS NOT NULL )
                      	)
                  	<cfelseif FORM.evaluationStatus EQ "1">
                    	AND DATEDIFF(NOW(),watDateCheckedIn) > 30
                        AND watDateEvaluation1 IS NULL
                    <cfelseif FORM.evaluationStatus EQ "2">
                    	AND DATEDIFF(NOW(),watDateCheckedIn) > 60
                        AND watDateEvaluation2 IS NULL
                    <cfelseif FORM.evaluationStatus EQ "3">
                    	AND DATEDIFF(NOW(),watDateCheckedIn) > 90
                        AND watDateEvaluation3 IS NULL
					<cfelseif FORM.evaluationStatus EQ "4">
                    	AND DATEDIFF(NOW(),watDateCheckedIn) > 120
                        AND watDateEvaluation4 IS NULL
					</cfif>
                    GROUP BY ec.candidateID
                </cfquery>
                
                <cfif VAL(qGetCandidates.recordCount)>
                
                	<cfset totalCandidatesCount = totalCandidatesCount + qGetCandidates.recordCount>
                
                	<table width="100%" cellpadding="4" cellspacing=0 align="center">
                        <tr>
                            <td colspan="11">
                                <small>
                                    <strong>#qGetIntlReps.businessname# - Total candidates: #qGetCandidates.recordCount#</strong> 
                                </small>
                            </td>
                        </tr>
                        <cfif ListFind("2,3", FORM.printOption)>
                            <tr><td colspan="11"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td></tr>
                        </cfif>
                        <tr>
                            <th align="left" class="#tableTitleClass#" width="2%">ID</Th>
                            <th align="left" class="#tableTitleClass#" width="7%">Last Name</Th>
                            <th align="left" class="#tableTitleClass#" width="7%">First Name</Th>
                            <th align="left" class="#tableTitleClass#" width="8%">E-mail</Th>
                            <th align="left" class="#tableTitleClass#" width="20%">Host Company</Th>
                            <th align="left" class="#tableTitleClass#">Sex</th>
                            <th align="left" class="#tableTitleClass#">Check-in Date</th>
                            <th align="left" class="#tableTitleClass#">Evaluations</th>
                        </tr>
                        <cfif ListFind("2,3", FORM.printOption)>
                            <tr><td colspan="11"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td></tr>
                        </cfif>
                        <cfloop query="qGetCandidates">
                            <tr <cfif qGetCandidates.currentRow mod 2>bgcolor="##E4E4E4"</cfif>>
                                <td class="style1">
                                	#candidateid#
                                    <cfif LEN(subject)>
                                    	<font color="red"><b>T</b></font>
                                    </cfif>
                               	</td>
                                <td class="style1">#lastname#</td>
                                <td class="style1">#firstname#</td>
                                <td class="style1">#email#</td>
                                <td class="style1">#hostcompanyname#</td>
                                <td class="style1">#sex#</td>
                                <td class="style1">#DateFormat(watDateCheckedIn,'mm/dd/yyyy')#</td>
                                <td class="style1">
                                	<cfif isDate(watDateCheckedIn)>
                                        First Evaluation: 
                                        <cfif watDateEvaluation1 NEQ "" AND isDate(watDateEvaluation1)>
                                            #DateFormat(watDateEvaluation1,'mm/dd/yyyy')#
                                        <cfelse>
                                            pending
                                        </cfif>
                                        <cfif DATEDIFF('d', watDateCheckedIn, NOW()) GT 30>
                                            <br/>
                                            Second Evaluation: 
                                            <cfif watDateEvaluation2 NEQ "" AND isDate(watDateEvaluation2)>
                                                #DateFormat(watDateEvaluation2,'mm/dd/yyyy')#
                                            <cfelse>
                                                pending
                                            </cfif>
                                        </cfif>
                                        <cfif DATEDIFF('d', watDateCheckedIn, NOW()) GT 60>
                                            <br />
                                            Third Evaluation: 
                                            <cfif watDateEvaluation3 NEQ "" AND isDate(watDateEvaluation3)>
                                                #DateFormat(watDateEvaluation3,'mm/dd/yyyy')#
                                            <cfelse>
                                                pending
                                            </cfif>
                                        </cfif>
                                        <cfif DATEDIFF('d', watDateCheckedIn, NOW()) GT 90>
                                            <br />
                                            Fourth Evaluation: 
                                            <cfif watDateEvaluation4 NEQ "" AND isDate(watDateEvaluation4)>
                                                #DateFormat(watDateEvaluation4,'mm/dd/yyyy')#
                                            <cfelse>
                                                pending
                                            </cfif>
                                        </cfif>
                                   	<cfelse>
                                    	missing check-in date
                                  	</cfif>
                              	</td>
                            </tr>
                        </cfloop>
                    </table>
                
                </cfif>
            
            </cfloop>
            
            <input type="hidden" id="totalCandidates" value="#totalCandidatesCount#" />
            
            <script type="text/javascript">
				$(document).ready(function() {
					$("##totalCandidatesInput").text("Total Number of Students: " + $('##totalCandidates').val());
				});
			</script>
        
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
                    <div class="title1">Evaluation Status Report by Intl. Rep. and Program</div>
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
                    <div class="title1">Evaluation Status Report by Intl. Rep. and Program</div>
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