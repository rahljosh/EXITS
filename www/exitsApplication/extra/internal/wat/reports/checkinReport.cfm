<!--- ------------------------------------------------------------------------- ----
	
	File:		visaInterview.cfm
	Author:		Bruno Lopes
	Date:		March 30, 2016
	Desc:		

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- PARAM FORM VARIABLES --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.intlRepID" default="0"> <!--- 0 for all reps --->
    <cfparam name="FORM.evaluationStatus" default="all"> <!--- all, complete, missing, (1-4 -> missing specific evaluation) --->
    <cfparam name="FORM.studentStatus" default="all">
    
    <!--- Get the list of programs --->
    <cfscript>
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		qGetIntlRepList = APPLICATION.CFC.USER.getUsers(usertype=8,isActive=1,businessNameExists=1);
	</cfscript>
 
</cfsilent>
        
<!--- FORM SUBMITTED --->
<cfif FORM.submitted>

	<!--- Get selected reps with candidates in the selected program --->
	<cfquery name="qCheckinDates" datasource="#APPLICATION.DSN.Source#">
		SELECT  ec.watDateCheckedIn
        FROM extra_candidates ec
        LEFT JOIN extra_hostcompany h ON ec.hostCompanyID = h.hostCompanyID
        WHERE  ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
        <cfif VAL(FORM.intlRepID)>
            AND ec.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.intlRepID)#">
        </cfif>
        <cfif CLIENT.userType EQ 28>
            AND h.hostCompanyID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#CLIENT.hostCompanyID#">)
        </cfif>
            AND ec.watDateCheckedIn IS NOT NULL
        GROUP BY ec.watDateCheckedIn
	</cfquery>

    <cfquery name="qGetStateList" datasource="#APPLICATION.DSN.Source#">
        SELECT id, state, stateName
        FROM smg_states
        ORDER BY stateName
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
                    <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Program Reports -> Check-in Report</font>
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
        
        	<cfloop query="qCheckinDates">
            
            	<cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#">
                	SELECT ec.uniqueID, ec.candidateID, ec.lastName, ec.firstName, ec.email, ec.sex, ec.hostcompanyid, ec.startdate, 
                            ec.enddate, ec.ds2019, ec.visaInterview, ec.watDateCheckedIn, ec.arrival_address, ec.arrival_apt_number, 
                            ec.arrival_apt_number, ec.arrival_city, ec.arrival_state, ec.arrival_zip, eh.name as hostcompanyname
                    FROM extra_candidates ec
                    LEFT JOIN extra_hostcompany eh on eh.hostcompanyid = ec.hostcompanyid
                    WHERE ec.watDateCheckedIn = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#qCheckinDates.watDateCheckedIn#">
                        AND ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#"> 
                    GROUP BY ec.candidateID
                </cfquery>
                
                <cfif VAL(qGetCandidates.recordCount)>
                
                	<cfset totalCandidatesCount = totalCandidatesCount + qGetCandidates.recordCount>
                
                	<table width="100%" cellpadding="4" cellspacing=0 align="center">
                        <tr>
                            <td colspan="11">
                                <small>
                                    <strong>#DateFormat(qCheckinDates.watDateCheckedIn, "mm/dd/yyyy")# - Total candidates: #qGetCandidates.recordCount#</strong> 
                                </small>
                            </td>
                        </tr>
                        <cfif ListFind("2,3", FORM.printOption)>
                            <tr><td colspan="11"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td></tr>
                        </cfif>
                        <tr>
                            <th align="left" class="#tableTitleClass#">Check-in</Th>
                            <th align="left" class="#tableTitleClass#">Candidate</Th>
                            <th align="left" class="#tableTitleClass#">Sex</Th>
                            <th align="left" class="#tableTitleClass#">Start Date</Th>
                            <th align="left" class="#tableTitleClass#">End Date</Th>
                            <th align="left" class="#tableTitleClass#">Placement Information</th>
                            <th align="left" class="#tableTitleClass#">DS-2019</th>
                            <th align="left" class="#tableTitleClass#">Arrival Address</th>
                        </tr>
                        <cfif ListFind("2,3", FORM.printOption)>
                            <tr><td colspan="11"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td></tr>
                        </cfif>
                        <cfloop query="qGetCandidates">
                            <tr <cfif qGetCandidates.currentRow mod 2>bgcolor="##E4E4E4"</cfif>>
                                <td class="style1">
                                	#dateFormat(watDateCheckedIn, 'mm/dd/yyyy')#
                               	</td>
                                <td class="style1">
                                    <a href="index.cfm?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#lastname#, #firstname# (#candidateID#)</a>
                                </td>
                                <td class="style1">#sex#</a></td>
                                <td class="style1">#DateFormat(startDate,'mm/dd/yyyy')#</td>
                                <td class="style1">#DateFormat(endDate,'mm/dd/yyyy')#</td>
                                <td class="style1">
                                    <a href="index.cfm?curdoc=hostcompany/hostCompanyInfo&hostCompanyID=#hostcompanyid#"  class="style4">#hostcompanyname#</a></td>
                                <td class="style1">
                                    <cfif ds2019 NEQ ''>
                                        #ds2019#
                                    <cfelse>
                                        -
                                    </cfif></td>
                                <td class="style1">#arrival_address#<cfif arrival_apt_number NEQ ''>, #arrival_apt_number#</cfif> - #arrival_city# <cfloop query="qGetStateList">
                                                        <cfif qGetStateList.id EQ qGetCandidates.arrival_state>
                                                            #state#
                                                        </cfif>
                                                    </cfloop> #arrival_zip#</td>
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
