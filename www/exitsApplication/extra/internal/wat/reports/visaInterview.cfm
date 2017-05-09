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
    <cfparam name="FORM.orderOption" default="1">
    <cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.emailOption" default="1">
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.intlRepID" default="0"> <!--- 0 for all reps --->
    <cfparam name="FORM.evaluationStatus" default="all"> <!--- all, complete, missing, (1-4 -> missing specific evaluation) --->
    <cfparam name="FORM.studentStatus" default="all">
    <cfparam name="FORM.showMissingVisaDate" default="1" />
    
    <!--- Get the list of programs --->
    <cfscript>
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		qGetIntlRepList = APPLICATION.CFC.USER.getUsers(usertype=8,isActive=1,businessNameExists=1);
	</cfscript>
 
</cfsilent>
        
<!--- FORM SUBMITTED --->
<cfif FORM.submitted>

    <cfif FORM.emailOption EQ 2>    

        <cfif VAL(FORM.intlRepID)>
            <cfquery name="qGetMissingVisaInterviewDate" datasource="#APPLICATION.DSN.Source#">
                SELECT ec.uniqueID, ec.candidateID, ec.lastName, ec.firstName, ec.email, ec.sex, ec.hostcompanyid, ec.startdate, 
                        ec.enddate, ec.ds2019, ec.visaInterview, u.email AS userEmail, u.businessname
                FROM extra_candidates ec
                INNER JOIN smg_users u ON ec.intRep = u.userID
                WHERE  ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
                    AND ec.visaInterview IS NULL
                    AND ec.ds2019 <> ''
                    AND ec.status = 1
                    AND u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.intlRepID)#">
                GROUP BY ec.candidateID
                
            </cfquery>

            <cfsavecontent variable="emailContent">
                <p>Dear <cfoutput>#qGetMissingVisaInterviewDate.businessname#</cfoutput></p>
                <p style="color:red">The following stutents are missing their Visa Interview date:</p>
                <cfoutput>
                    <ul>
                    <cfloop query="qGetMissingVisaInterviewDate">
                        <li> #firstname# #lastname# (#candidateID#)</li>
                    </cfloop>
                    </ul>
                </cfoutput>
            </cfsavecontent>

            <cfscript>
                // Send out Self Placement Confirmation Email
                APPLICATION.CFC.EMAIL.sendEmail(
                    emailFrom="#APPLICATION.EMAIL.contactUs# (#CLIENT.firstName# #CLIENT.lastName# CSB-USA)",
                    emailTo=qGetMissingVisaInterviewDate.userEmail,
                    emailReplyTo=CLIENT.email,
                    emailSubject='SWT/CSB - Missing Visa Interview Date',
                    emailMessage='#emailContent#',
                    companyID=CLIENT.companyID,
                    footerType='emailRegular',
                    displayEmailLogoHeader=1
                );  
            </cfscript>

        <cfelse>
            
            <cfloop query="qGetIntlRepList" >

                <cfquery name="qGetMissingVisaInterviewDate" datasource="#APPLICATION.DSN.Source#">
                    SELECT ec.uniqueID, ec.candidateID, ec.lastName, ec.firstName, ec.email, ec.sex, ec.hostcompanyid, ec.startdate, 
                            ec.enddate, ec.ds2019, ec.visaInterview
                    FROM extra_candidates ec
                    INNER JOIN smg_users u ON ec.intRep = u.userID
                    WHERE  ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
                        AND ec.visaInterview IS NULL
                        AND ec.ds2019 <> ''
                        AND u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetIntlRepList.userID#">
                        AND ec.status = 1
                    GROUP BY ec.candidateID
                </cfquery>

                <cfif qGetMissingVisaInterviewDate.recordCount GT 0 >

                    <cfsavecontent variable="emailContent">
                        <p>Dear <cfoutput>#qGetIntlRepList.businessname#</cfoutput></p>
                        <p style="color:red">The following stutents are missing their Visa Interview date:</p>
                        <cfoutput>
                            <ul>
                            <cfloop query="qGetMissingVisaInterviewDate">
                                <li> #firstname# #lastname# (#candidateID#)</li>
                            </cfloop>
                            </ul>
                        </cfoutput>
                    </cfsavecontent>

                    <cfscript>
                        // Send out Self Placement Confirmation Email
                        APPLICATION.CFC.EMAIL.sendEmail(
                            emailFrom="#APPLICATION.EMAIL.contactUs# (#CLIENT.firstName# #CLIENT.lastName# CSB-USA)",
                            emailTo=qGetIntlRepList.email,
                            emailReplyTo=CLIENT.email,
                            emailSubject='SWT/CSB - Missing Visa Interview Date',
                            emailMessage='#emailContent#',
                            companyID=CLIENT.companyID,
                            footerType='emailRegular',
                            displayEmailLogoHeader=1
                        );  
                    </cfscript>

                </cfif>

            </cfloop>
        </cfif>



        

        

    </cfif>

    <cfif FORM.orderOption EQ 2>

        <cfquery name="qGetVisaInterviewDates" datasource="#APPLICATION.DSN.Source#">
            SELECT ec.visaInterview
            FROM extra_candidates ec
            INNER JOIN smg_users u ON ec.intRep = u.userID
            WHERE ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
                AND ec.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="1">
                AND ec.visaInterview IS NOT NULL
                <cfif VAL(FORM.intlRepID)>
                    AND u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intlRepID#">
                </cfif>
            GROUP BY visainterview
        </cfquery>

    <cfelseif FORM.orderOption EQ 1>

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

    function toggleEmailDiv() {
        //if ($("#intlRepID").val() == 'All') {
        //    $("#emailDiv").hide();
        //} else {
        //    $("#emailDiv").show();
        //}
    }

    $( document ).ready(function() {
        //toggleEmailDiv();
        setVisaMissingDate();
        
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
                    <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Program Reports -> Visa Interview Report</font>
                </td>
            </tr>
            <tr valign="middle" height="24">
                <td valign="middle" colspan="2">&nbsp;</td>
            </tr>
            <cfif CLIENT.userType LTE 4>
                <tr valign="middle">
                    <td align="right" valign="middle" class="style1" width="25%"><b>Intl. Rep.:</b> </td>
                    <td valign="middle">
                        <select name="intlRepID" id="intlRepID" class="style1">
                            <option value="All">---  All International Representatives  ---</option>
                            <cfloop query="qGetIntlRepList">
                                <option value="#qGetIntlRepList.userID#" <cfif qGetIntlRepList.userID EQ FORM.intlRepID> selected</cfif> >#qGetIntlRepList.businessname#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
            </cfif>
            <tr>
                <td align="right" class="style1"><b>Show Missing Visa Interview Date Only: </b></td>
                <td  class="style1"> 
                    <input type="radio" name="showMissingVisaDate" id="showMissingVisaDate1" value="1" onclick="setVisaMissingDate(1)" <cfif FORM.showMissingVisaDate EQ 1> checked </cfif> > <label for="showMissingVisaDate1">No</label>
                    <input type="radio" name="showMissingVisaDate" id="showMissingVisaDate2" value="2" onclick="setVisaMissingDate(2)" <cfif FORM.showMissingVisaDate EQ 2> checked </cfif> > <label for="showMissingVisaDate2">Yes</label> 
                </td>
            </tr>
            </table>

            <div id="emailOptionDiv" style="display: none">
            <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
            <tr>
                <td align="right" class="style1" width="25%"><b>Email Int. Rep.: </b></td>
                <td  class="style1"> 
                    <input type="radio" name="emailOption" id="emailOption1" value="1" <cfif FORM.emailOption EQ 1> checked </cfif> > <label for="emailOption1">No</label>
                    <input type="radio" name="emailOption" id="emailOption2" value="2" <cfif FORM.emailOption EQ 2> checked </cfif> > <label for="emailOption2">Yes</label> 
                    <span style="color:red; display:none" id="emailSentDiv">- Email sent.</span>
                </td>           
            </tr>
            </table>
            </div>

            <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
            <tr>
                <td valign="middle" align="right" class="style1" width="25%"><b>Program:</b></td>
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
            </table>

            <div id="orderOptionDiv">
            <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
            <tr>
                <td align="right" class="style1" width="25%"><b>Order By: </b></td>
                <td  class="style1"> 
                    <input type="radio" name="orderOption" id="orderOption1" value="1" <cfif FORM.orderOption EQ 1> checked </cfif> > <label for="orderOption1">Int. Representatives</label>
                    <input type="radio" name="orderOption" id="orderOption2" value="2" <cfif FORM.orderOption EQ 2> checked </cfif> > <label for="orderOption2">Date</label> 
                </td>           
            </tr>
            </table>
            </div>

            <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
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

            <cfif FORM.orderOption EQ 2>

                <cfloop query="qGetVisaInterviewDates">

                    <cfif FORM.showMissingVisaDate EQ 2>

                        <cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#">
                            SELECT ec.uniqueID, ec.candidateID, ec.lastName, ec.firstName, ec.email, ec.sex, ec.hostcompanyid, ec.startdate, 
                                    ec.enddate, ec.ds2019, ec.visaInterview, eh.name as hostcompanyname, u.userID, u.businessname
                            FROM extra_candidates ec
                            LEFT JOIN extra_hostcompany eh on eh.hostcompanyid = ec.hostcompanyid
                            LEFT JOIN smg_users u on u.userID = ec.intRep
                            WHERE ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
                                AND ec.visaInterview IS NULL
                                AND ec.ds2019 <> ''
                                AND ec.status = 1
                                <Cfif VAL(FORM.intlRepID)>
                                    AND u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.intlRepID)#">
                                </Cfif>
                            GROUP BY ec.candidateID
                            ORDER BY u.userID
                        </cfquery>

                    <cfelse>

                        <cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#">
                            SELECT ec.uniqueID, ec.candidateID, ec.lastName, ec.firstName, ec.email, ec.sex, ec.hostcompanyid, ec.startdate, 
                                    ec.enddate, ec.ds2019, ec.visaInterview, eh.name as hostcompanyname, u.userID, u.businessname
                            FROM extra_candidates ec
                            LEFT JOIN extra_hostcompany eh on eh.hostcompanyid = ec.hostcompanyid
                            LEFT JOIN smg_users u on u.userID = ec.intRep
                            WHERE ec.visaInterview = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(qGetVisaInterviewDates.visaInterview, 'yyyy-mm-dd')#">
                                AND ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
                                <Cfif VAL(FORM.intlRepID)>
                                    AND u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.intlRepID)#">
                                </Cfif>
                                AND ec.status = 1
                            GROUP BY ec.candidateID
                            ORDER BY u.userID
                        </cfquery>

                    </cfif>
                
                    
                    
                    <cfif VAL(qGetCandidates.recordCount)>
                    
                        <cfset totalCandidatesCount = totalCandidatesCount + qGetCandidates.recordCount>
                    
                        <table width="100%" cellpadding="2" cellspacing=0 align="center">
                            <tr style="padding:10px 0 0 4px">
                                <td colspan="11">
                                    <hr />
                                    <small>
                                        <strong>#DateFormat(qGetVisaInterviewDates.visaInterview, 'mm/dd/yyyy')# - Total candidates: #qGetCandidates.recordCount#</strong> 
                                    </small>
                                </td>
                            </tr>
                            <cfset currentIntRep = 0/>
                            <cfloop query="qGetCandidates">
                                <cfif qGetCandidates.userID NEQ currentIntRep >
                                    <cfset currentIntRep = qGetCandidates.userID/>
                                    <tr style="padding: 0 0 4px 4px">
                                        <td colspan="11">
                                            <small>
                                                <strong>#qGetCandidates.businessname#</strong> 
                                            </small>
                                        </td>
                                    </tr>
                                    <cfif ListFind("2,3", FORM.printOption)>
                                        <tr><td colspan="11"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td></tr>
                                    </cfif>
                                    <tr style="padding: 4px">
                                        <th align="left" class="#tableTitleClass#">Date</Th>
                                        <th align="left" class="#tableTitleClass#">Candidate</Th>
                                        <th align="left" class="#tableTitleClass#">Sex</Th>
                                        <th align="left" class="#tableTitleClass#">Start Date</Th>
                                        <th align="left" class="#tableTitleClass#">End Date</Th>
                                        <th align="left" class="#tableTitleClass#">Placement Information</th>
                                        <th align="left" class="#tableTitleClass#">DS-2019</th>
                                    </tr>
                                    <cfif ListFind("2,3", FORM.printOption)>
                                        <tr><td colspan="11"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td></tr>
                                    </cfif>
                                </cfif>
                            
                                <tr <cfif qGetCandidates.currentRow mod 2>bgcolor="##E4E4E4"</cfif>>
                                    <td class="style1">
                                        #DateFormat(visaInterview,'mm/dd/yyyy')#
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
                                </tr>
                            </cfloop>
                        </table>
                    
                    </cfif>

                </cfloop>

            <cfelseif FORM.orderOption EQ 1>
        
            	<cfloop query="qGetIntlReps">

                    <cfif FORM.showMissingVisaDate EQ 2>

                        <cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#">
                            SELECT ec.uniqueID, ec.candidateID, ec.lastName, ec.firstName, ec.email, ec.sex, ec.hostcompanyid, ec.startdate, 
                                    ec.enddate, ec.ds2019, ec.visaInterview, eh.name as hostcompanyname, u.userID, u.businessname
                            FROM extra_candidates ec
                            LEFT JOIN extra_hostcompany eh on eh.hostcompanyid = ec.hostcompanyid
                            LEFT JOIN smg_users u on u.userID = ec.intRep
                            WHERE ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
                                AND ec.visaInterview IS NULL
                                AND ec.ds2019 <> ''
                                AND ec.status = 1
                                AND ec.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(userID)#">
                            GROUP BY ec.candidateID
                        </cfquery>

                    <cfelse>
                
                    	<cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#">
                        	SELECT ec.uniqueID, ec.candidateID, ec.lastName, ec.firstName, ec.email, ec.sex, ec.hostcompanyid, ec.startdate, 
                                    ec.enddate, ec.ds2019, ec.visaInterview, eh.name as hostcompanyname
                            FROM extra_candidates ec
                            LEFT JOIN extra_hostcompany eh on eh.hostcompanyid = ec.hostcompanyid
                            WHERE ec.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(userID)#">
                                AND ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
                                AND ec.visaInterview IS NOT NULL
                                AND ec.status = 1
                            GROUP BY ec.candidateID
                        </cfquery>

                    </cfif>
                    
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
                                <th align="left" class="#tableTitleClass#">Date</Th>
                                <th align="left" class="#tableTitleClass#">Candidate</Th>
                                <th align="left" class="#tableTitleClass#">Sex</Th>
                                <th align="left" class="#tableTitleClass#">Start Date</Th>
                                <th align="left" class="#tableTitleClass#">End Date</Th>
                                <th align="left" class="#tableTitleClass#">Placement Information</th>
                                <th align="left" class="#tableTitleClass#">DS-2019</th>
                            </tr>
                            <cfif ListFind("2,3", FORM.printOption)>
                                <tr><td colspan="11"><img src="../../pics/black_pixel.gif" width="100%" height="2"></td></tr>
                            </cfif>
                            <cfloop query="qGetCandidates">
                                <tr <cfif qGetCandidates.currentRow mod 2>bgcolor="##E4E4E4"</cfif>>
                                    <td class="style1">
                                    	#DateFormat(visaInterview,'mm/dd/yyyy')#
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
                                </tr>
                            </cfloop>
                        </table>
                    
                    </cfif>
                
                </cfloop>
            </cfif>
            
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


<script>

function setVisaMissingDate() {
    if(($('#showMissingVisaDate2').is(":checked"))) {
        $("#orderOptionDiv").hide();
        $("#orderOption1").attr("checked", "checked");
        $("#emailOptionDiv").show();
    } else {
        $("#orderOptionDiv").show();
        $("#emailOptionDiv").hide();
        $("#emailOption1").attr("checked", "checked");
    }
}

</script>
