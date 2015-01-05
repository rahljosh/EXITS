<!--- ------------------------------------------------------------------------- ----
	
	File:		culturalActivityReport.cfm
	Author:		James Griffiths
	Date:		May 24, 2012
	Desc:		Cultural Activity Report

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <!--- Param FORM Variables --->	
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.solved" default="0">
    <cfparam name="FORM.status" default="0">
    <cfparam name="FORM.studentStatus" default="All">

    <cfscript>
		// Get Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
	</cfscript>

    <!--- FORM submitted --->
    <cfif FORM.submitted>
     
        <cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#">
            SELECT DISTINCT
                ec.*,
                h.name,
                <cfif NOT VAL(FORM.status)>
                    eca.dateActivity,
                    eca.details,
              	</cfif>
                u.businessname,
                p.programName,
                p.programID,
                eic.subject         
            FROM
                extra_candidates ec
            INNER JOIN
                smg_users u ON u.userid = ec.intrep               
          	INNER JOIN
            	smg_programs p ON p.programID = ec.programID
          	INNER JOIN
            	extra_hostcompany h ON h.hostCompanyID = ec.hostCompanyID
            <cfif NOT VAL(FORM.status)>
                INNER JOIN
                    extra_cultural_activity eca ON eca.candidateID = ec.candidateID
         	</cfif>
            LEFT JOIN extra_incident_report eic ON eic.candidateID = ec.candidateID
              	AND eic.isSolved = 0
                AND eic.subject = "Terminated"         
            WHERE 
                ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
           	<cfif VAL(FORM.status)>
            	AND NOT EXISTS ( SELECT a.candidateID FROM extra_cultural_activity a WHERE a.candidateID = ec.candidateID )
            </cfif>
           	<cfif VAL(FORM.programID)>  
                AND 
                    ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
           	</cfif>
            AND
            	ec.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="cancelled">
         	<cfif FORM.studentStatus NEQ 'All'>
            	AND
                	ec.status = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentStatus#">
            </cfif>
       		GROUP BY
            	ec.candidateID
            ORDER BY
                ec.lastname
        </cfquery>
    
    </cfif>

</cfsilent>

<cfoutput>

    <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
        <input type="hidden" name="submitted" value="1">
        
        <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
            <tr valign="middle" height="24">
                <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>
                    <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Program Reports -> Cultural Activity Report</font>
                </td>
            </tr>
            <tr>
                <td valign="middle" align="right" class="style1"><b>Program: </b></td>
                <td> 
                    <select name="programID" class="style1">
                        <cfloop query="qGetProgramList">
                            <option value="#qGetProgramList.programID#" <cfif qGetProgramList.programid EQ FORM.programID> selected</cfif>>#qGetProgramList.programname#</option>
                        </cfloop>
                    </select>
                </td>
            </tr>
            <tr>
                <td valign="middle" align="right" class="style1"><b>Status: </b></td>
                <td> 
                    <select name="status" class="style1">
                 		<option value="0" <cfif FORM.status EQ 0>selected="selected"</cfif> >Candidates with cultural activity</option>
                        <option value="1" <cfif FORM.status EQ 1>selected="selected"</cfif>>Candidates without cultural activity</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td valign="middle" align="right" class="style1"><b>Student Status:</b></td>
                <td> 
                    <select name="studentStatus" class="style1">
                        <option value="All" <cfif "All" eq FORM.studentStatus> selected</cfif>>All</option>
                        <option value="1" <cfif 1 eq FORM.studentStatus> selected</cfif>>Active</option>
                        <option value="0" <cfif 0 eq FORM.studentStatus> selected</cfif>>Inactive</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td align="right"  class="style1"><b>Format: </b></td>
                <td class="style1"> 
                    <input type="radio" name="printOption" id="printOption1" value="1" <cfif FORM.printOption EQ 1> checked </cfif> > <label for="printOption1">Onscreen (View Only)</label>
                    <input type="radio" name="printOption" id="printOption2" value="2" <cfif FORM.printOption EQ 2> checked </cfif> > <label for="printOption2">Print (FlashPaper)</label> 
                    <input type="radio" name="printOption" id="printOption3" value="3" <cfif FORM.printOption EQ 3> checked </cfif> > <label for="printOption3">Print (PDF)</label>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <br /> <input type="submit" class="style1" value="Generate Report" />
                </td>
            </tr>
        </table> <br/>
    
    </form>

</cfoutput>

<!--- FORM submitted --->
<cfif FORM.submitted>

    <cfsavecontent variable="reportContent">
    
    	<cfoutput>
        	<p style="font-size:12px;"><strong>&nbsp;&nbsp;&nbsp;Total number of candidates in this report: #qGetCandidates.recordCount#</strong></p>
        </cfoutput>
    
    	<cfif VAL(qGetCandidates.recordCount)>
        
        	<cfscript>
				qGetAgents = APPLICATION.CFC.USER.getUsers(usertype=8,isActive=1);
			</cfscript>
                    
      		<cfloop query="qGetAgents">
                    
                <cfquery name="qGetCandidatesUnderAgent" dbtype="query">
                    SELECT
                        *
                    FROM
                        qGetCandidates
                    WHERE
                        intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetAgents.userID#">
                </cfquery>
                        
				<cfif VAL(qGetCandidatesUnderAgent.recordCount)>
                    
                    <cfoutput>
                        <table width="98%" cellpadding="3" cellspacing="0" align="center" style="margin-top:20px; margin-bottom:20px; border:1px solid ##4F8EA4"> 
                            <tr>
                                <td colspan="5" style="font-weight:bold; font-size: 11px;">#qGetAgents.businessName#: #qGetCandidatesUnderAgent.recordCount#</td>
                            </tr>
                            <tr style="background-color:##4F8EA4; color:##FFF; padding:5px; font-weight:bold; font-size: 12px;">
                                <td width="40%">Candidate</Td>
                                <td width="10%">Start Date</Td>
                                <td width="10%">End Date</Td>
                                <td width="20%">Placement Information</Td>
                                <td width="20%"><cfif NOT VAL(FORM.status)>Cultural Activity</cfif></Td>
                            </tr>
                    </cfoutput>
                            
					<cfscript>
                        vRowCount = 0;
                    </cfscript>
                        
					<cfoutput query="qGetCandidatesUnderAgent">
                    
                        <cfscript>
                            vRowCount++;
                            qGetCulturalActivityReport = APPLICATION.CFC.CANDIDATE.getCulturalActivityReport(candidateID=qGetCandidatesUnderAgent.candidateID);
                        </cfscript>
                    
                        <tr bgcolor="###IIf(vRowCount MOD 2 ,DE("FFFFFF") ,DE("E4E4E4") )#" style="font-size:11px;">
                            <td valign="center">
                                <a href="?curdoc=candidate/candidate_info&uniqueid=#qGetCandidatesUnderAgent.uniqueID#" target="_blank" class="style4">
                                    #qGetCandidatesUnderAgent.firstname# #qGetCandidatesUnderAgent.lastname# (###qGetCandidatesUnderAgent.candidateid#)
                                    <cfif LEN(qGetCandidatesUnderAgent.subject)>
                                        <font color="red"><b>T</b></font>
                                    </cfif>
                                </a>
                            </td>
                            <td valign="center">#DateFormat(qGetCandidatesUnderAgent.startDate, 'mm/dd/yyyy')#</td>
                            <td valign="center">#DateFormat(qGetCandidatesUnderAgent.endDate, 'mm/dd/yyyy')#</td>
                            <td valign="center">#qGetCandidatesUnderAgent.name#</td>
                            <td valign="top">
                                <cfloop query="qGetCulturalActivityReport">
                                    #DateFormat(qGetCulturalActivityReport.dateActivity, 'mm/dd/yyyy')# - #qGetCulturalActivityReport.details#
                                    <br />
                                </cfloop>
                            </td>
                        </tr>
                        
					</cfoutput>
                    
                    </table>
                    
               	</cfif>
                    
      		</cfloop>
        
        <cfelse>
            <table width="98%" cellpadding="3" cellspacing="0" align="center" style="margin-top:20px; margin-bottom:20px; border:1px solid ##4F8EA4"> 
                <tr style="background-color:##4F8EA4; color:##FFF; padding:5px; font-size: 12px; text-align:center;">
                    <td>No Cultural Activities found.</td>
                </tr>
			</table>        
        </cfif>
        
        <cfoutput>
            <img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <br/><br/>
            <span  class="style1">Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</span>     
		</cfoutput>
        
    </cfsavecontent>


	<cfoutput>
    
        <!-----Display Reports---->
        <cfswitch expression="#FORM.printOption#">
        
            <!--- Screen --->
            <cfcase value="1">
                <!--- Include Report --->
                #reportContent#
            </cfcase>
            
            <!--- Flash Paper --->
            <cfcase value="2">
                <cfdocument format="PDF" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">
                    <style type="text/css">
                    <!--
                    .style1 { 
                        font-family: Arial, Helvetica, sans-serif;
                        font-size: 10;
                        }
                    -->
                    </style>
                    
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    <strong><font size="4" face="Verdana, Arial, Helvetica, sans-serif" >Missing Documents Report</font></strong><br>                
                    
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
                        font-family: Arial, Helvetica, sans-serif;
                        font-size: 10;
                        }
                    -->
                    </style>
                    
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    <strong><font size="4" face="Verdana, Arial, Helvetica, sans-serif" >Missing Documents Report</font></strong><br>                
                    
                    <!--- Include Report --->
                    #reportContent#
                </cfdocument>
            </cfcase>
        
            <cfdefaultcase>    
                <div align="center" class="style1">
                    Print results will replace the menu options and take a bit longer to generate. <br />
                    Onscreen will allow you to change criteria with out clicking your back button.
                </div>
            </cfdefaultcase>
            
        </cfswitch>
    
    </cfoutput>

</cfif>