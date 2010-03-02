<!--- ------------------------------------------------------------------------- ----
	
	File:		submit.cfm
	Author:		Marcus Melo
	Date:		December 14, 2009
	Desc:		Project Help Submit Form

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param Variables --->
    <cftry>
    
	    <cfparam name="studentID" type="numeric" default="0">
        <cfparam name="FORM.submitted" default="0">
    	<cfparam name="FORM.projectHelpID" default="0">
        <cfparam name="FORM.activityID" default="0">

        <cfcatch type="any">
			<cfset studentID = 0>
			<cfset FORM.submitted = 0> 
			<cfset FORM.projectHelpID = 0>
            <cfset FORM.activityID = 0> 
        </cfcatch>
        
    </cftry>

    <cfparam name="regionID" default="0">
    <cfparam name="isActive" default="1">

	<!--- Variables for the edit/print page options --->
	<cfparam name="imagePath" default="">
    <cfparam name="className" default="section">

	<cfparam name="FORM.message" default="">
    <cfparam name="FORM.action" default="">
    <cfparam name="FORM.isApproved" default="1">
    <cfparam name="FORM.reason" default="">
    <cfparam name="FORM.date_completed" default="#DateFormat(now(), 'mm/dd/yyyy')#">
    <cfparam name="FORM.activity" default="">
    <cfparam name="FORM.hours" default="">

	<!--- Check if we have a valid studentID --->
	<cfif NOT VAL(studentID)>    	
        <cflocation url="index.cfm?curdoc=project_help" addtoken="no">
        <cfabort>
    </cfif>

	<cfscript>
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);

		// Get Student Information
		qStudentInfo = APPCFC.STUDENT.getStudentByID(studentID=studentID); 

		// Get Program
		qProgram = APPCFC.PROGRAM.getPrograms(programID=qStudentInfo.programID);

		// Get Supervising Representative
		qGetHost = APPCFC.HOST.getHosts(hostID=qStudentInfo.hostID);
	
		// Get Supervising Representative
		qGetSR = APPCFC.USER.getUserByID(userID=qStudentInfo.areaRepID);
		
		// Get Regional Advisort
		qGetAdvisor = APPCFC.USER.getUserByID(userID=VAL(APPCFC.USER.getUserAccessRights(userID=qStudentInfo.areaRepID, regionID=qStudentInfo.regionAssigned).advisorID));
		
		// Get Regional Manager		
		qGetRD = APPCFC.USER.getRegionalManager(regionID=qStudentInfo.regionAssigned);
		
		// Get Regional Manager		
		qGetFacilitator = APPCFC.USER.getUserByID(userID=VAL(APPCFC.REGION.getRegions(regionID=qStudentInfo.regionAssigned).regionFacilitator));		
		
		// Get International Agent
		qIntlAgent = APPCFC.USER.getUserByID(userID=qStudentInfo.intRep);

		// FORM SUBMITTED
		if ( VAL(FORM.submitted) ) {

			switch (FORM.action) {
				
				// Adding new activity
				case "activity": {

					// Data Validation
					if ( NOT IsDate(FORM.date_completed) ) {
						ArrayAppend(Errors.Messages, "Please enter a valid date (mm/dd/yyyy).");
						FORM.date_completed = '';
					}
		
					if ( NOT LEN(FORM.activity) ) {
						ArrayAppend(Errors.Messages, "Please enter an activity.");
						FORM.activity = '';
					}
		
					if ( NOT IsNumeric(FORM.hours) ) {
						ArrayAppend(Errors.Messages, "Please enter total of hours (Eg. 1.5).");
						FORM.hours = '';
					}

					// Check if there are no errors
					if ( NOT VAL(ArrayLen(Errors.Messages)) ) {
						
						// Insert Activity
						APPCFC.STUDENT.insertProjectHelpActivity(
							projectHelpID=FORM.projectHelpID,
							srUserID=qGetSR.userID,
							raUserID=qGetAdvisor.userID,
							rdUserID=qGetRD.userID,
							nyUserID=qGetFacilitator.userID,
							studentID=studentID,
							activity=FORM.activity,
							hours=FORM.hours,
							dateCompleted=FORM.date_completed,
							userType=CLIENT.userType
						);

						// Set Message for User
						FORM.message = FORM.activity & ' successfully inserted';

					}

					break;
				}

				// Delete Activity by ID
				case "delete": {
						
					APPCFC.STUDENT.deleteProjectHelpActivity(
						activityID=FORM.activityID
					);
					
					// Set Message for User
					FORM.message = 'Activity successfully deleted';
					
					break;
				}

				// Supervising Rep. & Regional Advisor & Regional Manager & NY Office Approvals
				case "superRep": 
				case "regionalAdvisor": 
				case "regionalManager": 
				case "office": {
					
					// Check for reason if they are rejecting a report
					if ( NOT VAL(FORM.isApproved) AND NOT LEN(FORM.reason) ) {
						ArrayAppend(Errors.Messages, "Please enter a reason");
					}

					// Check if there are no errors
					if ( NOT VAL(ArrayLen(Errors.Messages)) ) {
						
						// Submit Approval/Rejection
						APPCFC.STUDENT.submitProjectHelp(
							projectHelpID=FORM.projectHelpID,
							approvedBy=CLIENT.userID,
							approvedType=FORM.action,
							isApproved=FORM.isApproved,
							reason=FORM.reason
						);

						// Set Message for User
						if ( VAL(FORM.isApproved) ) {
							FORM.message = 'Report Successfully approved';
						} else {
							FORM.message = 'Report Successfully rejected';
						}
					}					
					
					break;
				}

			} // end of switch
			
		} // end of if
	

		// Get Project Help
		qGetProjectHelpDetail = APPCFC.STUDENT.getProjectHelpDetail(studentID=qStudentInfo.studentID);  
		
		// Get Project Help Activities
		qGetPHActivities = APPCFC.STUDENT.getProjectHelpActivities(projectHelpID=qGetProjectHelpDetail.ID);  

		// Get Total of Hours for this project
		getPHTotalHours = APPCFC.STUDENT.getProjectHelpTotalHours(projectHelpID=qGetProjectHelpDetail.ID);  
	</cfscript>
    
</cfsilent>    
    
<script type="text/javascript" language="javascript">
	// Date Pick Function
	$(function() {
		$('.date-pick').datePicker({startDate:'01/01/2009'});
	});	

	// Display Reason and Submit Form
	function displayReason(divID, formName) {
		
		if($("#" + divID).css("display") == "none"){
			$("#" + divID).fadeIn("slow");
		} else {
			
			// Check if there is not a reason
			if ($("#reason").val() == "") {
				$("#rejectReasonMessage").text("Reason is required.").show().fadeOut(2000); 
			} else {
				// set IsApproved = 0
				$("#isApproved").val(0);
				// Submit Form
				$("#" + formName).submit();
			}
	
		}	
	}

	// Display Reason and Submit Form
	function submitActivity() {
		
		if ($("#activity").val() == "") {
			$("#insertActivityMessage").text("Activity is required.").show().fadeOut(2000); 
		} else if ( $("#hours").val() == "" ) {
			// Display Validation Message
			$("#insertActivityMessage").text("Hours is required.").show().fadeOut(2000); 		
		} else {
			// Submit Form
			$("#projectHelpActivity").submit();
		}

	}
</script>

<!--- Check if USER is an Area Rep, Advisor or Manager. 
	If none of the above, go back to the list --->
<cfif CLIENT.userType GTE 5 
	AND CLIENT.userID NEQ qGetSR.userID 
	AND	CLIENT.userID NEQ qGetAdvisor.userID
	AND	CLIENT.userID NEQ qGetRD.userID	>     	
	<cflocation url="index.cfm?curdoc=project_help" addtoken="no">
	<cfabort>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>EXITS</title>
<link rel="shortcut icon" href="#imagePath#pics/favicon.ico" type="image/x-icon" />
</head>

<body>

<cfif VAL(FORM.submitted) AND FORM.action EQ 'print'>

	<cfscript>
		// Set imagePath for Print View
		imagePath = "../";
		className = "";
	</cfscript>
    
    <link rel="stylesheet" href="../smg.css" type="text/css">
    <link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css">
</cfif>

<cfoutput>

<cfif FORM.action NEQ 'print'>
	<!--- Header --->
    <table width="80%" cellpadding="0" cellspacing="0" border="0" height="24" align="center">
        <tr height="24">
            <td height="24" width="13" background="#imagePath#pics/header_leftcap.gif">&nbsp;</td>
            <td width="26" background="#imagePath#pics/header_background.gif"><img src="#imagePath#pics/current_items.gif"></td>
            <td background="#imagePath#pics/header_background.gif"><h2>H.E.L.P. Community Service Hours</h2></td>
            <cfif FORM.action NEQ 'print'>
                <td background="#imagePath#pics/header_background.gif" align="right">
                	<a href="index.cfm?curdoc=project_help&regionID=#regionID#&isActive=#isActive#">Back to Progress Help List</a>
                </td>
            </cfif>
            <td width="17" background="#imagePath#pics/header_rightcap.gif">&nbsp;</td>
        </tr>
    </table>
</cfif>

<table width="80%" border="0" cellpadding="4" cellspacing="0" class="#className#" align="center">

	<cfif FORM.action EQ 'print'>
        <tr>
            <td colspan="2" align="center">
                <h2>H.E.L.P. Community Service Hours</h2>
            </td>
        </tr>		                   
	</cfif>
    
	<!--- Display Messages --->
    <cfif LEN(FORM.message)>
        <tr>
            <td align="center" colspan="2"><h1>*** #FORM.message# ***</h1></td>
        </tr>
    </cfif>	

	<!--- Display Errors --->
    <cfif VAL(ArrayLen(Errors.Messages))>
        <tr>
            <td align="center" colspan="2" style="color:##FF0000">
                <strong>*** Please review the following items: ***</strong> <br>
                
                <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                    #Errors.Messages[i]# <br>        	
                </cfloop>
            </td>
        </tr>
    </cfif>	

    <!--- Message for Super Rep --->
	<cfif CLIENT.userID EQ qGetSR.userID>
        <cfif NOT VAL(getPHTotalHours)>	           
            <tr>
                <td class="projectHelpWArning" align="center" colspan="2">
                    You must enter at least one activity in order to submit a report. Please add an activity below.
                </td>
            </tr>
        <cfelseif qGetProjectHelpDetail.status_key EQ Constants.projectHelpStatus[1]>
            <tr>
                <td class="projectHelpWArning" align="center" colspan="2">
                    This report is in pending status, and will not be viewable by anyone else until you approve it.
                </td>
            </tr>
        </cfif>    
    </cfif>
    
    <tr>
	    <th colspan="2">
        	<h1>
            	All students performing community service will receive a H.E.L.P. Certificate. <br>
                Students doing over 20 hours of community service will receive an extra recognition.
            </h1>
        </th>
    </tr>
    <tr>
	    <td align="center" colspan="2">
        	H.E.L.P. Community Service is time volunteered by individuals to benefit the community or its institutions. Community service is not babysitting, performing in the
            school play or band, belonging to a school club (with the exception of the volunteer activities done with a Key Club or similar club), singing in the choir at church,
            and other activities that are performed as chores or recreation.
        </td>
    </tr>
    <tr>
    	<td align="center" colspan="2">
        	<br /> <a href="index.cfm?curdoc=student_info&studentid=#qStudentInfo.studentID#"><h2>Student: #qStudentInfo.firstName# #qStudentInfo.familyLastName# (###qStudentInfo.studentID#)</h2></a> <br />
        </td>
    </tr>
    
    <!--- Status --->
    <tr class="projectHelpTitle">
    	<th colspan="2">Status</th>
        <th>&nbsp;</th>
    </tr>
    
    <!--- Supervising Rep. --->
    <tr>
        <th align="right">
        	Supervising Rep.:
        </th>
        <td>
        	<cfif LEN(qGetProjectHelpDetail.sr_date_submitted)>
            	Approved on #DateFormat(qGetProjectHelpDetail.sr_date_submitted, 'mm/dd/yyyy')# #TimeFormat(qGetProjectHelpDetail.sr_date_submitted, 'hh:mm:ss tt')#
            <cfelse>
                Pending
            </cfif>        
        </td>
    </tr>
    
    <tr>
        <th align="right">
            Regional Advisor: 
        </th>
        <td>
            <cfif LEN(qGetProjectHelpDetail.ra_date_approved)>
                Approved #DateFormat(qGetProjectHelpDetail.ra_date_approved, 'mm/dd/yyyy')# #TimeFormat(qGetProjectHelpDetail.ra_date_approved, 'hh:mm:ss tt')#
            <cfelseif LEN(qGetProjectHelpDetail.ra_date_rejected)>            
                <span class="projectHelpAttention"> Rejected on #DateFormat(qGetProjectHelpDetail.ra_date_rejected, 'mm/dd/yyyy')# #TimeFormat(qGetProjectHelpDetail.ra_date_rejected, 'hh:mm:ss tt')# </span>
			<cfelseif LEN(qGetProjectHelpDetail.rd_date_approved)>
            	Approved by RD            
			<cfelseif NOT VAL(qGetAdvisor.recordCount)>
                N/A
            <cfelse>
                Pending
            </cfif>
        </td>
    </tr>
    <cfif LEN(qGetProjectHelpDetail.ra_reason)>
        <tr>
            <th align="right">
                Reason:
            </th>
            <td>#qGetProjectHelpDetail.ra_reason#</td>
        </tr>
    </cfif>

    <!--- Regional Director --->
    <tr>
        <th align="right">
        	Regional Director:
        </th>
        <td>
			<cfif LEN(qGetProjectHelpDetail.rd_date_approved)>
            	Approved on #DateFormat(qGetProjectHelpDetail.rd_date_approved, 'mm/dd/yyyy')# #TimeFormat(qGetProjectHelpDetail.rd_date_approved, 'hh:mm:ss tt')#
			<cfelseif LEN(qGetProjectHelpDetail.rd_date_rejected)>            
            	<span class="projectHelpAttention"> Rejected on #DateFormat(qGetProjectHelpDetail.rd_date_rejected, 'mm/dd/yyyy')# #TimeFormat(qGetProjectHelpDetail.rd_date_rejected, 'hh:mm:ss tt')# </span>
			<cfelseif LEN(qGetProjectHelpDetail.ny_date_approved)>
                Approved by PM
            <cfelse>
            	Pending
            </cfif>
        </td>
    </tr>
    <cfif LEN(qGetProjectHelpDetail.rd_reason)>
        <tr>
            <th align="right">
                Reason:
            </th>
            <td>#qGetProjectHelpDetail.rd_reason#</td>
        </tr>
    </cfif>
    
    <!--- Program Manager --->
    <tr>
        <th align="right">
        	Program Manager :
        </th>
        <td>
			<cfif LEN(qGetProjectHelpDetail.ny_date_approved)>
            	Approved on #DateFormat(qGetProjectHelpDetail.ny_date_approved, 'mm/dd/yyyy')# #TimeFormat(qGetProjectHelpDetail.ny_date_approved, 'hh:mm:ss tt')#
			<cfelseif LEN(qGetProjectHelpDetail.ny_date_rejected)>            
            	<span class="projectHelpAttention"> Rejected on #DateFormat(qGetProjectHelpDetail.ny_date_rejected, 'mm/dd/yyyy')# #TimeFormat(qGetProjectHelpDetail.ny_date_rejected, 'hh:mm:ss tt')# </span>
            <cfelse>
            	Pending
            </cfif>
        </td>
    </tr>
    <cfif LEN(qGetProjectHelpDetail.ny_reason)>
        <tr>
            <th align="right">
                Reason:
            </th>
            <td>#qGetProjectHelpDetail.ny_reason#</td>
        </tr>
    </cfif>
    
    <!--- Program Information --->
    <tr class="projectHelpTitle">
    	<th colspan="2">Program</th>
        <th>&nbsp;</th>
    </tr>
    <tr>
	    <th align="right">Program Name:</th>
        <td>#qProgram.programName# (###qProgram.programID#)</td>
    </tr>
    <tr>
    	<th align="right">Supervising Representative:</th>
        <td>#qGetSR.firstName# #qGetSR.lastName# (###qGetSR.userID#)</td>
    </tr>
    <tr>
    	<th align="right">Regional Advisor:</th>
        <td>
        	<cfif qGetAdvisor.recordCount>
	            #qGetAdvisor.firstName# #qGetAdvisor.lastName# (###qGetAdvisor.userID#)
        	<cfelse>
            	Reports Directly to Regional Director
            </cfif>
        </td>
    </tr>
    <tr>
    	<th align="right">Regional Director:</th>
        <td>#qGetRD.firstName# #qGetRD.lastName# (###qGetRD.userID#)</td>
    </tr>
    <tr>
    	<th align="right">Facilitator:</th>
        <td>#qGetFacilitator.firstName# #qGetFacilitator.lastName# (###qGetFacilitator.userID#)</td>
    </tr>
    <tr>
    	<th align="right">Host Family:</th>
        <td>#qGetHost.familyLastName# (###qGetHost.hostID#)</td>
    </tr>
    <tr>
    	<th align="right">International Agent:</th>
        <td>#qIntlAgent.businessName# (###qIntlAgent.userID#)</td>
    </tr>

    <!--- Activity Detail --->
    <tr class="projectHelpTitle">
    	<th colspan="2">
        	Activity Detail
        </th>
    	<th>
	        <cfif FORM.action NEQ 'print'>
	            <a href="javascript:displayClass('insertActivity');" class="projectHelpNew"> NEW </a>
            </cfif>
        </th>
    </tr>
	
    <tr>
    	<td colspan="2">
            <table width="80%" border="0" cellpadding="4" cellspacing="0" align="center">

                <!--- Form - Add Activity --->
                <form name="projectHelpActivity" id="projectHelpActivity" action="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#" method="post">
                <input type="hidden" name="submitted" value="1" />
                <input type="hidden" name="projectHelpID" value="#qGetProjectHelpDetail.ID#" />
                <input type="hidden" name="studentID" value="#qStudentInfo.studentID#" />
                <input type="hidden" name="action" value="activity" />
				
                <!--- Display Data Validation --->
                <tr>
                	<td align="center" colspan="5">
						<span id="insertActivityMessage" class="projectHelpAttention"></span>		                
                    </td>
				</tr>                    
                
                <!--- Table Headers --->
                <tr class="insertActivity" <cfif FORM.action NEQ 'activity' AND VAL(getPHTotalHours) OR ( VAL(qGetProjectHelpDetail.recordCount) AND NOT VAL(ArrayLen(Errors.Messages)) )> style="display:none;" </cfif>>
                	<td width="5%">&nbsp;</td>
                	<td class="projectHelpActivityTitle">Date</td>                        
                	<td class="projectHelpActivityTitle">Activity</td>                        
                	<td class="projectHelpActivityTitle">Hours</td> 
                    <td width="">&nbsp;</td>                       
				</tr> 

                <tr class="insertActivity" <cfif FORM.action NEQ 'activity' AND VAL(getPHTotalHours) OR ( VAL(qGetProjectHelpDetail.recordCount) AND NOT VAL(ArrayLen(Errors.Messages)) )> style="display:none;" </cfif>>
                    <td>&nbsp;</td>
                    <td><input type="text" name="date_completed" value="#DateFormat(FORM.date_completed, 'mm/dd/yyyy')#" class="date-pick" maxlength="10"/></td>
                    <td><input type="text" name="activity" id="activity" value="#FORM.activity#" class="projectHelpActivity" maxlength="200" /></td>
                    <td><input type="text" name="hours" id="hours" value="#FORM.hours#" class="projectHelpHours" maxlength="3"/></td>
                    <td>
                        <a href="javascript:submitActivity();" title="Save Only">
                            <img src="#imagePath#pics/save_only.gif" border="0" alt="Save Only" />
                        </a> <br />         
                    </td>
                </tr>

                <tr class="insertActivity" <cfif FORM.action NEQ 'activity' AND VAL(getPHTotalHours) OR ( VAL(qGetProjectHelpDetail.recordCount) AND NOT VAL(ArrayLen(Errors.Messages)) )> style="display:none;" </cfif>>
                	<td colspan="5" align="center">
	                    PS: Adding an activity to a report already approved will reset current approvals.                         
                        <br />
						<hr class="projectHelpRule" />                   
					</td>
                </tr>
                </form>
                <!--- End of Form - Add Activity --->
                
            	<!--- Table Headers --->
                <tr>
                	<td width="5%">&nbsp;</td>
                	<td class="projectHelpActivityTitle">Date</td>                        
                	<td class="projectHelpActivityTitle">Activity</td>                        
                	<td class="projectHelpActivityTitle">Hours</td> 
                    <td class="projectHelpActivityTitle">PM Approved</td> 
                    <td width="">&nbsp;</td>                       
				</tr> 

                <!--- Activities ---->
                <cfloop query="qGetPHActivities">
                    
                    <form name="form_#qGetPHActivities.id#" id="form_#qGetPHActivities.id#" action="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#" method="post">
                        <input type="hidden" name="submitted" value="1">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="activityID" value="#qGetPHActivities.id#">
                        <input type="hidden" name="studentID" value="#qStudentInfo.studentID#" />
                    </form>
                    
                    <tr bgcolor="#IIF(qGetPHActivities.currentRow MOD 2 ,DE("EEEEEE") ,DE("FFFFFF") )#">
                        <td>&nbsp;</td>
                        <td>#DateFormat(qGetPHActivities.date_completed, 'mm/dd/yyyy')#</td>
                        <td>#qGetPHActivities.activity#</td>
                        <td>#qGetPHActivities.hours#</td>
                        <td>
                        	<cfif LEN(qGetPHActivities.date_approved)>
								#DateFormat(qGetPHActivities.date_approved, 'mm/dd/yyyy')#
							<cfelse>
                            	Pending
                            </cfif>                                                            
                        </td>
                        <td>
                        	<!--- Do not display delete option if report has been approved --->
                        	<cfif NOT LEN(qGetPHActivities.date_approved)															<!--- NOT Approved by Office --->
								AND ( CLIENT.userID EQ qGetSR.userID AND NOT LEN (qGetProjectHelpDetail.sr_date_submitted) ) 		<!--- SR user and NOT submitted --->
								OR ( CLIENT.userID EQ qGetAdvisor.userID AND NOT LEN (qGetProjectHelpDetail.ra_date_approved) )  	<!--- RA user and NOT submitted --->
	                            OR ( CLIENT.userID EQ qGetRD.userID AND NOT LEN (qGetProjectHelpDetail.rd_date_approved) ) >		<!--- RD user and NOT submitted --->
                                <a href="javascript:form_#qGetPHActivities.id#.submit();" onClick="return confirm('Are you sure you want to delete this Activity?')" title="Delete #qGetPHActivities.activity#">
                                	<img src="#imagePath#pics/delete.png" border="0" alt="Delete #qGetPHActivities.activity#" />
                                </a>
                            </cfif>
                        </td>
                    </tr>
                </cfloop>
                
                <!--- Summary --->
                <cfif VAL(getPHTotalHours)>
                <tr>
                    <td colspan="2">&nbsp;</td>
                    <td class="projectHelpActivityTitle">
                    	Total Hours
	                </td>
    				<td class="projectHelpActivityTitle">
						#getPHTotalHours#
                    </td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
				</tr>  
                </cfif>                                  

				<!--- Check if there are no activities --->
				<cfif NOT VAL(qGetPHActivities.recordCount)>
                	<tr>
                    	<td colspan="5" align="center">There are not activities yet.</td>
					</tr>                                        
                </cfif>
                
            </table>
    	</td>
    </tr>

    <!--- Approve/Reject --->
    <cfif FORM.action NEQ 'print'>
        <tr>
            <td align="center" colspan="2">
                
                <form name="submitProjectHelp" id="submitProjectHelp" action="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#" method="post">
                    <input type="hidden" name="submitted" value="1" />
                    <input type="hidden" name="projectHelpID" value="#qGetProjectHelpDetail.ID#" />
                    <input type="hidden" name="studentID" value="#qStudentInfo.studentID#" />
                    <input type="hidden" name="isApproved" id="isApproved" value="1" />
                    <!--- Used on the go to project help list link --->
                    <input type="hidden" name="regionID" value="#regionID#" />
                    <input type="hidden" name="isActive" value="#isActive#" />  
                                  
                    <!--- Supervising Approval --->
                    <cfif CLIENT.userID EQ qGetSR.userID															<!--- SR is logged in --->
                        AND VAL(getPHTotalHours)																	<!--- Valid Hours --->
                        AND ( NOT LEN(qGetProjectHelpDetail.sr_date_submitted)										<!--- Not Approved by SR --->
                        OR ( VAL(qGetAdvisor.userID) AND LEN(qGetProjectHelpDetail.ra_date_rejected) )  			<!--- Advisor - Advisor Rejected --->
                        OR ( NOT VAL(qGetAdvisor.userID) AND LEN(qGetProjectHelpDetail.rd_date_rejected) ) )>  		<!--- No Advisor - Manager Rejected --->
    
                        <input type="hidden" name="action" value="superRep" />                
                        <input name="Submit" onClick="return confirm('Are you sure you want to approve this report?')" type="image" src="#imagePath#pics/approve.gif" border="0" alt="Approve"/>
                        
                    <!--- Advisor Approval --->
                    <cfelseif CLIENT.userID EQ qGetAdvisor.userID																		<!--- RA is logged in --->
                        AND VAL(getPHTotalHours)																						<!--- Valid Hours --->
                        AND NOT LEN(qGetProjectHelpDetail.ra_date_rejected) AND NOT LEN(qGetProjectHelpDetail.ra_date_approved)	 		<!--- Not Rejected and not Approved by Advisor --->
                        AND ( LEN(qGetProjectHelpDetail.sr_date_submitted) OR LEN(qGetProjectHelpDetail.rd_date_rejected) )>			<!--- Submitted by SR or Rejected by RD --->				
    
                        <input type="hidden" name="action" value="regionalAdvisor" />                
                        <input name="Submit" onClick="return confirm('Are you sure you want to approve this report?')" type="image" src="#imagePath#pics/approve.gif" border="0" alt="Approve"/>
                        &nbsp; &nbsp;
                        <a href="javascript:displayReason('rejectReason','submitProjectHelp');" title="Reject"><img src="#imagePath#pics/reject.gif" border="0" alt="Reject" /></a>
                    
                    <!--- Regional Director --->
                    <cfelseif CLIENT.userID EQ qGetRD.userID 																		<!--- RM is logged in --->
                        AND VAL(getPHTotalHours)																					<!--- Valid Hours --->
                        AND NOT LEN(qGetProjectHelpDetail.rd_date_rejected) AND NOT LEN(qGetProjectHelpDetail.rd_date_approved)		<!--- Not Rejected and not Approved by Director --->	
                        AND ( ( NOT VAL(qGetAdvisor.userID) AND LEN(qGetProjectHelpDetail.sr_date_submitted) )						<!--- No Advisor - SR Approved --->
                        OR ( VAL(qGetAdvisor.userID) AND LEN(qGetProjectHelpDetail.ra_date_approved) ) 								<!--- Advisor - Advisor Approved --->
                        OR LEN(qGetProjectHelpDetail.ny_date_rejected) )>  															<!--- Rejected by Office --->
    
                        <input type="hidden" name="action" value="regionalManager" />                
                        <input name="Submit" onClick="return confirm('Are you sure you want to approve this report?')" type="image" src="#imagePath#pics/approve.gif" border="0" alt="Approve"/>
                        &nbsp; &nbsp;
                        <a href="javascript:displayReason('rejectReason','submitProjectHelp');" title="Reject"><img src="#imagePath#pics/reject.gif" border="0" alt="Reject" /></a>
                        
                    <!--- Program Manager --->
                    <cfelseif VAL(CLIENT.userType) LTE 4																			<!--- PM is logged in --->
                        AND VAL(getPHTotalHours)																					<!--- Valid Hours --->
                        AND NOT LEN(qGetProjectHelpDetail.ny_date_approved) AND NOT LEN(qGetProjectHelpDetail.ny_date_rejected) >	<!--- Not Rejected and not Approved by PM --->
                        
                        <input type="hidden" name="action" value="office" />                
                        <input name="Submit" onClick="return confirm('Are you sure you want to approve this report?')" type="image" src="#imagePath#pics/approve.gif" border="0" alt="Approve"/>
                        &nbsp; &nbsp;
                        <a href="javascript:displayReason('rejectReason','submitProjectHelp');" title="Reject"><img src="#imagePath#pics/reject.gif" border="0" alt="Reject" /></a>
                        
                    </cfif>
    
                    <!--- Display Data Validation --->
                    <br /> <span id="rejectReasonMessage" class="projectHelpAttention"></span>
        
                    <div id="rejectReason" <cfif FORM.action EQ 'activity' OR NOT VAL(qGetPHActivities.recordCount) OR ( VAL(qGetProjectHelpDetail.recordCount) AND NOT VAL(ArrayLen(Errors.Messages)) )> style="display:none;" </cfif>>
                        Please enter a reason: <br />                     
                        <textarea name="reason" id="reason" class="projectHelpReason">#FORM.reason#</textarea>                
                    </div>
                
                </form>  
			
            </td>
            
            <td>
                <form action="project_help/submit.cfm" method="post" target="_blank">
                    <input type="hidden" name="submitted" value="1" />
                    <input type="hidden" name="projectHelpID" value="#qGetProjectHelpDetail.ID#" />
                    <input type="hidden" name="studentID" value="#qStudentInfo.studentID#" />
                    <input type="hidden" name="action" value="print" />
                    <input name="Submit" type="image" src="#imagePath#pics/printer.gif" alt="Print Report" border="0">
                </form>
            </td>  
        </tr>
	</cfif>
    
</table>

<cfif FORM.action NEQ 'print'>
	<!--- Footer --->
    <table width="80%" cellpadding="0" cellspacing="0" border="0" align="center">
        <tr valign="bottom">
            <td width="9px" valign="top" height="12"><img src="#imagePath#pics/footer_leftcap.gif"></td>
            <td width="100%" background="#imagePath#pics/header_background_footer.gif"></td>
            <td width="9px" valign="top"><img src="#imagePath#pics/footer_rightcap.gif"></td>
        </tr>
    </table>
</cfif>

</cfoutput>

</body>
</html>