<!--- ------------------------------------------------------------------------- ----
	
	File:		housingAddressList.cfm
	Author:		James Griffiths
	Date:		December 27, 2012
	Desc:		Shows candidate arrival addresses.

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- PARAM FORM VARIABLES --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.intlRepID" default="0"> <!--- 0 for all reps --->
    <cfparam name="FORM.hostCompanyID" default="0"> <!--- 0 for all host companies --->
    <cfparam name="FORM.hostCompany" default="all"> <!--- all, primary, secondary --->
    <cfparam name="FORM.status" default="all"> <!--- all, active, inactive --->
    
    <!--- Get the list of programs and reps --->
    <cfscript>
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		qGetIntlRepList = APPLICATION.CFC.USER.getIntlReps();
		//qGetHostCompanyList = APPLICATION.CFC.HOSTCOMPANY.getHostCompanies();
	</cfscript>

    <cfquery name="qGetHostCompanyList" datasource="#APPLICATION.DSN.Source#">
        SELECT *
        FROM extra_hostcompany
        WHERE name != ""
            AND companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        <cfif CLIENT.userType EQ 28>
            AND hostCompanyID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#CLIENT.hostCompanyID#">)
        </cfif>
         AND active = 1
        ORDER BY name
    </cfquery>
 
</cfsilent>
        
<!--- FORM SUBMITTED --->
<cfif FORM.submitted>

	<!--- Get selected reps with candidates in the selected program --->
	<cfquery name="qGetIntlReps" datasource="#APPLICATION.DSN.Source#">
		SELECT u.userID, u.businessName
		FROM smg_users u
		INNER JOIN extra_candidates ec ON ec.intRep = u.userID
			AND ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
			AND ec.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
			<cfif FORM.status NEQ 'All'>
				AND ec.status = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.status#">
			</cfif>
            <cfif FORM.hostCompany EQ "primary">
            	AND ec.hostcompanyid != 0
          	<cfelseif FORM.hostCompany EQ "secondary">
            	AND ec.candidateID IN (SELECT candidateID FROM extra_candidate_place_company WHERE isSecondary = 1 AND status = 1)
            </cfif>
            <cfif VAL(FORM.hostCompanyID)>
            	AND ec.hostcompanyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostCompanyID#">
            <cfelseif CLIENT.userType EQ 28>
                AND ec.hostCompanyID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#CLIENT.hostCompanyID#">)
            </cfif>
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

    $(document).ready(function() {
        $("#totalStudents").html("Total Number of Students: " + $('#totalStudentsCount').val());
        $("#totalCheckedIn").html("Checked-in: " + $('#totalCheckedInCount').val());
        $("#pendingCheckedIn").html("Pending to be Checked-in: " + $('#pendingCheckedInCount').val());
    });

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
                    <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Program Reports -> Housing Address List</font>
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
            <cfif CLIENT.userType LTE 4 OR CLIENT.userType EQ 28>
                <tr valign="middle">
                    <td align="right" valign="middle" class="style1"><b>Host Companies:</b> </td>
                    <td valign="middle">
                    <Cfif qGetHostCompanyList.recordCount EQ 1>
                        #qGetHostCompanyList.name#
                        <input type="hidden" name="hostcompanyID" value="#qGetHostCompanyList.hostcompanyID#" />
                    <cfelse>
                        <select name="hostCompanyID" class="style1">
                            <option value="ALL">---  All Host Companies  ---</option>
                            <cfloop query="qGetHostCompanyList">
                                <option value="#hostcompanyID#" <cfif qGetHostCompanyList.hostcompanyID EQ FORM.hostCompanyID> selected </cfif> >#qGetHostCompanyList.name#</option>
                            </cfloop>
                        </select>
                    </Cfif>
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
                    <select name="hostCompany" class="style1">
                        <option value="all">All</option>
                        <option value="primary" <cfif FORM.hostCompany eq 'primary'>selected</cfif>>Primary Placements</option>
                        <option value="secondary" <cfif FORM.hostCompany eq 'secondary'>selected</cfif>>Secondary Placements</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td valign="middle" align="right" class="style1"><b>Status:</b></td>
                <td> 
                    <select name="gf" class="style1">
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

        <span style="font-size:11px">
            <div id="totalStudents"></div>
            --------------------------------------<br />
            <div id="totalCheckedIn"></div>
            <div id="pendingCheckedIn"></div>
            -------------------------------------- <br /><br />
        </span>
        
        <cfscript>
            if (FORM.printOption EQ 1) {
                tableTitleClass = 'tableTitleView';
            } else {
                tableTitleClass = 'style2';
            }
        </cfscript>

        <cfset totalStudentsCount = 0 />
        <cfset totalCheckedInCount = 0 />
        <cfset pendingCheckedInCount = 0 />
        
        <cfsavecontent variable="reportContent">
        
        	<cfloop query="qGetIntlReps">
            
            	<cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#">
                	SELECT ec.candidateID, ec.uniqueID, ec.hostCompanyID, ec.lastName, ec.firstName, ec.sex, ec.email, ec.startDate, ec.endDate, ec.ds2019, ec.wat_placement, ec.watDateCheckedIn,
                    	ec.arrivalDate, ec.arrival_address, ec.arrival_address_2, ec.arrival_apt_number, ec.arrival_city, ec.arrival_zip,
                        s.state, ehc.name, eir.subject
                    FROM extra_candidates ec
                    LEFT JOIN smg_states s ON s.id = ec.arrival_state
                   	LEFT JOIN extra_hostcompany ehc ON ehc.hostCompanyID = ec.hostCompanyID
                    LEFT JOIN extra_incident_report eir ON eir.candidateID = ec.candidateID
            			AND eir.isSolved = 0
            			AND eir.subject = "Terminated"
                    WHERE ec.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(userID)#">
                    AND ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
                    AND ec.status != "canceled"
                    <cfif FORM.status NEQ "all">
                    	AND ec.status = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.status)#">
                    </cfif>
                    <cfif FORM.hostCompany EQ "primary">
                    	AND ec.hostcompanyid != 0
                    <cfelseif FORM.hostCompany EQ "secondary">
                    	AND ec.candidateID IN (SELECT candidateID FROM extra_candidate_place_company WHERE isSecondary = 1 AND status = 1)
                    </cfif>
                    <cfif VAL(FORM.hostCompanyID)>
                    	AND ec.hostcompanyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostCompanyID#">
                    <cfelseif CLIENT.userType EQ 28>
                        AND ehc.hostCompanyID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#CLIENT.hostCompanyID#">)
                    </cfif>
                    GROUP BY ec.candidateID
                </cfquery>
            
            	<table width="99%" cellpadding="4" cellspacing=0 align="center">
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
                        <th align="left" class="#tableTitleClass#" width="16%">Candidate</Th>
                        <th align="left" class="#tableTitleClass#" width="4%">Sex</th>
                        <th align="left" class="#tableTitleClass#" width="4%">Email</th>
                        <th align="left" class="#tableTitleClass#" width="8%">Start Date</th>
                        <th align="left" class="#tableTitleClass#" width="8%">End Date</th>
                        <th align="left" class="#tableTitleClass#" width="24%">Placement Information</th>
                        <th align="left" class="#tableTitleClass#" width="10%">DS-2019</th>
                        <th align="left" class="#tableTitleClass#" width="10%">Option</th>
                        <th align="left" class="#tableTitleClass#" width="8%">Check-in Date</th>
                        <th align="left" class="#tableTitleClass#" width="12%">Arrival Address</th>
                    </tr>
                    <cfif ListFind("2,3", FORM.printOption)>
                        <tr><td colspan="11"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td></tr>
                    </cfif>
                    <cfloop query="qGetCandidates">
                        <cfset totalStudentsCount = totalStudentsCount + 1 />
                        <cfif val(watDateCheckedIn) >
                            <cfset totalCheckedInCount = totalCheckedInCount + 1 />
                        <cfelse>
                            <cfset pendingCheckedInCount = pendingCheckedInCount + 1 />
                        </cfif>
                    	<cfif FORM.hostCompany NEQ "primary">
                            <cfquery name="qGetSecondaryPlacements" datasource="#APPLICATION.DSN.Source#">
                                SELECT ecpc.hostCompanyID, h.name
                                FROM extra_candidate_place_company ecpc
                                INNER JOIN extra_hostcompany h ON h.hostCompanyID = ecpc.hostCompanyID
                                WHERE ecpc.candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(candidateID)#">
                                AND ecpc.status = 1
                                AND ecpc.isSecondary = 1
                            </cfquery>
                        </cfif>
                    	<tr <cfif qGetCandidates.currentRow mod 2>bgcolor="##E4E4E4"</cfif>>
                        	<td class="style1">
                            	<a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueID#" target="_blank" class="style4">
                            		#firstname# #lastname# (###candidateid#)
                              	</a>
                                <cfif LEN(subject)>
                                    <font color="red"><b>T</b></font>
                                </cfif>
                           	</td>
                            <td class="style1">#sex#</td>
                            <td class="style1"><a href="#email#">#email#</a></td>
                            <td class="style1">#DateFormat(startDate,'mm/dd/yyyy')#</td>
                            <td class="style1">#DateFormat(endDate,'mm/dd/yyyy')#</td>
                            <td class="style1">
                            	<cfif hostCompanyID NEQ 0>
                                	<a href="?curdoc=hostcompany/hostCompanyInfo&hostCompanyID=#hostCompanyID#"  target="_blank" class="style4">
                                        #name#
                                    </a>
                                </cfif>
                                <cfif FORM.hostCompany NEQ "primary">
                                	<cfloop query="qGetSecondaryPlacements">
                                    	<br/>
                                        <a href="?curdoc=hostcompany/hostCompanyInfo&hostCompanyID=#hostCompanyID#"  target="_blank" class="style4">
                                            #name#
                                        </a>
                                    </cfloop>
                                </cfif>
                            </td>
                            <td class="style1">#ds2019#</td>
                            <td class="style1">#wat_placement#</td>
                            <td class="style1">#DateFormat(watDateCheckedIn,'mm/dd/yyyy')#</td>
                            <td class="style1">#arrival_address#  <cfif len(arrival_apt_number)>## #arrival_apt_number#</cfif><cfif len(arrival_address_2)><br />#arrival_address_2#</cfif><br/>#arrival_city#<cfif state NEQ "">,</cfif> #state# #arrival_zip#</td>
                        </tr>
                    </cfloop>
                </table>
            
            </cfloop>

            <input type="hidden" id="totalStudentsCount" value="#totalStudentsCount#" />
            <input type="hidden" id="totalCheckedInCount" value="#totalCheckedInCount#" />
            <input type="hidden" id="pendingCheckedInCount" value="#pendingCheckedInCount#" />
        
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
