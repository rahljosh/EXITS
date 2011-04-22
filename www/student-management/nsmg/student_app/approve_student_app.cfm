<!--- ------------------------------------------------------------------------- ----
	
	File:		approve_student_app.cfm
	Author:		Marcus Melo
	Date:		March 23, 2011
	Desc:		Approves an application

	Updated:	03/23/2011 - Ability to assign a program and region
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param URL Variables --->
    <cfparam name="studentID" default="0">
    
    <cfparam name="URL.unqID" default="">

    <!--- Param FORM Variables --->
	<cfparam name="FORM.submitted" default="0">    
    <cfparam name="FORM.companyID" default="0">
	<cfparam name="FORM.programID" default="0">	
    <cfparam name="FORM.regionID" default="0">  
    <cfparam name="FORM.directPlace" default="3">  
      
	
    <cfscript>
		// Get Student By UniqueID
		if ( LEN(URL.unqID) ) {
			qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(uniqueID=URL.unqID);
			CLIENT.studentID = qGetStudentInfo.studentID;
		} else {
			qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=studentID);	
		}
		
		// Get Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(isUpcomingPrograms=1);
		
		// Get Company List
		qGetCompanyList = APPLICATION.CFC.COMPANY.getCompanies(companyIDList=APPLICATION.SETTINGS.COMPANYLIST.All);

		// Get Intl. Rep Information
		qGetIntRepInfo = APPLICATION.CFC.USER.getUserByID(qGetStudentInfo.intrep);
		
		// Program Information
		qGetProgramInfo = APPLICATION.CFC.PROGRAM.getOnlineAppPrograms(app_programID=qGetStudentInfo.app_indicated_program);
		
		// Additional Program
		qGetAdditionalProgramInfo = APPLICATION.CFC.PROGRAM.getOnlineAppPrograms(app_programID=qGetStudentInfo.app_additional_program);
	</cfscript>

    <cfdirectory directory="#APPLICATION.PATH.onlineApp.picture#" name="file" filter="#qGetStudentInfo.studentid#.*">

    <cfquery name="qGetStatesRequested" datasource="MySQL">
        SELECT 
        	state1, 
            sta1.statename as statename1, 
            state2, 
            sta2.statename as statename2, 
            state3, 
            sta3.statename as statename3
        FROM 
        	smg_student_app_state_requested 
        LEFT JOIN 
        	smg_states sta1 ON sta1.id = state1
        LEFT JOIN 
        	smg_states sta2 ON sta2.id = state2
        LEFT JOIN 
        	smg_states sta3 ON sta3.id = state3
        WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentid#">
    </cfquery>
    
    <cfscript>
		// Check if FORM has been submitted
		if ( FORM.submitted ) {

			// Data Validation
			if ( NOT VAL(FORM.companyID) ) {
				SESSION.formErrors.Add('You must select a company');
			}
			
			if ( FORM.companyID NEQ 6 AND NOT VAL(FORM.regionID) ) {
				SESSION.formErrors.Add('You must select a region');
			}
			
			if ( FORM.companyID NEQ 6 AND NOT VAL(FORM.programID) ) {
				SESSION.formErrors.Add('You must select a program');
			}
			if ( FORM.directPlace EQ 3 ) {
				SESSION.formErrors.Add('Please indicate if this is a direct placement');
			}

			// Check if there are no errors 
			if ( NOT SESSION.formErrors.length() ) {
				
				// Get Current Application Status
				vStudentStatus = APPLICATION.CFC.ONLINEAPPLICATION.getCurrentApplicationStatus(studentID=FORM.studentID).status;
			
				// Get Next Status
				vSetNewStatus = APPLICATION.CFC.ONLINEAPPLICATION.setNextStatusID(statusID=vStudentStatus,type='approve');
				
				// If program is changing we need to add it to the history
				if ( qGetStudentInfo.programID NEQ 0 AND qGetStudentInfo.programID NEQ FORM.programID ) {
					
					// Insert History
					APPLICATION.CFC.PROGRAM.insertProgramHistory(
						studentID=FORM.studentID,
						programID=FORM.programID,
						reason="ONLINE APP RE-APPROVED - #qGetStudentInfo.cancelreason#",
						changedBy=CLIENT.userID
					);
					
				}
				
				// Approve Application
				APPLICATION.CFC.ONLINEAPPLICATION.approveStudentApplication(
					studentID=FORM.studentID,
					statusID=vSetNewStatus,
					companyID=FORM.companyID,
					programID=FORM.programID,
					regionID=FORM.regionID,
					directPlace=FORM.directPlace,
					approvedBy=CLIENT.userID
				);
				
				// Set Up Page Message
				SESSION.pageMessages.Add('Application successfully approved. This window should close automatically.');

			}
			
		}
    </cfscript>
    
</cfsilent>
    

<script language="javascript">
	// Load the list when page is ready
	$(document).ready(function() {
		displayAddlInformation();
	});

	// Display Additional Information for Public High School
	var displayAddlInformation = function(pageNumber,titleSortBy) { 
		// Get CompanyID
		vCompanyID = $("#companyID").val();
		if ( vCompanyID != 0 && vCompanyID != 6 ) {
			$(".additionalInformation").fadeIn();		
		} else {
			$(".additionalInformation").fadeOut();	
		}
	}
</script>

<!--- FORM Submitted - Refresh Opener and Close PopUp --->
<cfif FORM.submitted AND NOT SESSION.formErrors.length()>

	<script language="javascript">
		// Refresh Opener
		// window.opener.location.reload();
		
		// Close Window After 1.5 Seconds
		setTimeout(function() { window.close(); }, 1500);
	</script>
	
</cfif>

<cfoutput>

	<!--- HEADER OF TABLE --->
    <table width="100%" cellpadding="0" cellspacing="0">
        <tr height="33">
            <td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
            <td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
            <td class="tablecenter"><h2>Approve Application - #qGetStudentInfo.firstName# #qGetStudentInfo.familyLastName# ###qGetStudentInfo.studentID#</h2></td>
            <td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
        </tr>
    </table>
    
    <div class="section" style="padding-top:20px;">
    
		<!--- Page Messages --->
        <gui:displayPageMessages 
            pageMessages="#SESSION.pageMessages.GetCollection()#"
            messageType="onlineApplication"
            width="660"
            />
        
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="onlineApplication"
            width="660"
            />
    
        <table width="660px" border="0" cellpadding="4" cellspacing="2" align="center">	
            <tr>
                <td width="150" rowspan="10" align="left" valign="top">
                    <cfif file.recordcount>
                        <img src="../uploadedfiles/web-students/#file.name#" width="130" height="150"><br>
                    <cfelse>
                        <img src="pics/no_image.gif" border="0">
                    </cfif>
                    <div align="center"><img src="pics/app_approved.gif" align="middle"></div>
                </td>
                <td colspan="3"><b>Student's Name</b></td>
            </tr>
            <tr>
                <td width="200"><em>Family Name</em></td>
                <td width="180"><em>First Name</em></td>
                <td width="140"><em>Middle Name</em></td>		
            </tr>
            <tr>
                <td valign="top">#qGetStudentInfo.familylastname#<br><img src="pics/line.gif" width="195" height="1" border="0" align="absmiddle"></td>
                <td valign="top">#qGetStudentInfo.firstname#<br><img src="pics/line.gif" width="175" height="1" border="0" align="absmiddle"></td>
                <td valign="top">#qGetStudentInfo.middlename#<br><img src="pics/line.gif" width="135" height="1" border="0" align="absmiddle"></td>
            </tr>
            <tr><td colspan="3">&nbsp;</td></tr>
            <tr><td colspan="3">
                    <table width="100%" border="0" cellpadding=0 cellspacing=0 align="center">	
                        <tr><td colspan="2"><b>Program Information</b></td></tr>
                        <tr>
                            <td><em>Program</em></td>
                            <td><em>Additional Programs</em></td>
                        </tr>
                        <tr>
                            <td>#qGetProgramInfo.app_program#<br><img src="pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
                            <td>
                                <cfif NOT VAL(qGetAdditionalProgramInfo.recordcount)>
                                    None
                                <cfelse>
                                    #qGetAdditionalProgramInfo.app_program#
                                </cfif>
                                <br><img src="pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
                        </tr>
                        <tr><td colspan="2">&nbsp;</td></tr>
                    </table>
            </td></tr>
            <tr>
                <td><em>International Representative</em></td><td><em>Requested Region</em></td><td><em>Requested States</em></td>
            </tr>
            <tr>
                <td valign="bottom">#qGetIntRepInfo.businessname#<br><img src="pics/line.gif" width="195" height="1" border="0" align="absmiddle"></td>
                <td valign="bottom">
                    <cfswitch expression="#qGetStudentInfo.app_region_guarantee#">
        
                        <cfcase value="1">
                            Region 1 - East
                        </cfcase>
                    
                        <cfcase value="2">
                            Region 2 - South
                        </cfcase>
                    
                        <cfcase value="3">
                            Region 3 - Central
                        </cfcase>
                    
                        <cfcase value="4">
                            Region 4 - Rocky Mountain
                        </cfcase>
                    
                        <cfcase value="5">
                            Region 5 - West
                        </cfcase>
                    	<cfcase value="6">
                            West
                        </cfcase>
                    
                        <cfcase value="7">
                            Central
                        </cfcase>
                    
                        <cfcase value="8">
                            South
                        </cfcase>
                    
                        <cfcase value="9">
                            East
                        </cfcase>
                    
                        
                        <cfdefaultcase>
                            n/a
                        </cfdefaultcase>
                    
                    </cfswitch>
                    <br><img src="pics/line.gif" width="175" height="1" border="0" align="absmiddle">
                </td>
                <td valign="bottom">
                    <cfif NOT VAL(qGetStatesRequested.state1) OR NOT VAL(qGetStatesRequested.recordcount)>
                        n/a
                    <cfelse>
                        1st Choice: #qGetStatesRequested.statename1# <br>
                        2nd Choice: #qGetStatesRequested.statename2#<br>
                        3rd Choice: #qGetStatesRequested.statename3#
                    </cfif>
                    <br><img src="pics/line.gif" width="135" height="1" border="0" align="absmiddle">
                </td>
            </tr>
        </table>
        
        <br>
        
        <!--- FORM --->
        <cfform method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
        	<input type="hidden" name="submitted" value="1">
            <input type="hidden" name="studentID" value="#qGetStudentInfo.studentID#">
            <table width="660px" border="0" cellpadding="4" cellspacing="2" align="center" style="border:1px solid ##CCC; padding:5px;">	
                <tr><th colspan="2"><h3><u>The following information is required to finish the approval of the application.</u></h3></th></tr>
                <tr>
                    <td width="30%" align="right">Company: </td>
                    <td>
                    	<select name="companyID" id="companyID" onChange="displayAddlInformation();">
                        	<option value="0">--- Select a Company ---</option>
                            <cfloop query="qGetCompanyList">
                            	<option value="#qGetCompanyList.companyID#" <cfif FORM.companyID EQ qGetCompanyList.companyID>selected</cfif>>#qGetCompanyList.companyShort_nocolor# - #qGetCompanyList.team_id#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
                <tr class="displayNone additionalInformation">
                    <td align="right">Region: </td>
                    <td>
                      <cfselect
                          name="regionID" 
                          id="regionID"
                          value="regionID"
                          display="regionName"
                          selected="#FORM.regionID#"
                          bindonload="yes"
                          bind="cfc:nsmg.extensions.components.region.getRegionRemote({companyID})" /> 
                    </td>
                </tr>
                <tr class="displayNone additionalInformation">
                    <td align="right">Program: </td>
                    <td>
                        <select name="programID" id="programID">
                            <option value="0">--- Select a Program ---</option>
                            <cfloop query="qGetProgramList">
                            	<option value="#qGetProgramList.programID#" <cfif FORM.programID EQ qGetProgramList.programID>selected</cfif>>#programName#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
                <Cfif qGetStudentInfo.studentid eq 28304>
                <tr class="displayNone additionalInformation">
                    <td align="right">Direct Placement: </td>
                    <td>
                       <input type="radio" name="directPlace" value=1>Yes &nbsp;&nbsp;&nbsp;<input type="radio" name="directPlace" value=0>No 
                    </td>
                </tr>
                </Cfif>
                <tr>
                    <td align="center" colspan="2">
                        <input name="submit" type=image src="pics/approve.gif" alt='Approve Application'>		
                    </td>
                </tr>
            </table>
            
            <br>
            
            <table width="660px" border="0" cellpadding="4" cellspacing="2" align="center">	
                <tr>
                    <td align="center">
                        Upon Approval and Company Assignment, notification will be sent to the student (if an email is on file) to let him/her know his/her application has been approved and they are awaiting placement.<br>
                        Student will also immediately show up in the unplaced listing of students waiting for placement.
                    </td>
               </tr>
            </table>
        
        </cfform>
    
    </div>
    
    <cfinclude template="footer_table.cfm">

</cfoutput>