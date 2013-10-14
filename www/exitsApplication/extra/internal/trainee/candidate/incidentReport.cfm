<!--- ------------------------------------------------------------------------- ----
	
	File:		incidentReport.cfm
	Author:		Marcus Melo
	Date:		July 14, 2011
	Desc:		Incident Report Tool

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />	
    
    <!--- PARAM URL Variables --->
	<cfparam name="URL.uniqueID" default="">
    <cfparam name="URL.incidentID" default="0">
    
    <!--- PARAM FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.uniqueID" default="">	
    <cfparam name="FORM.incidentID" default="0">
    <cfparam name="FORM.hostCompanyID" default="0">
    <cfparam name="FORM.dateIncident" default="">
	<cfparam name="FORM.subject" default="">
	<cfparam name="FORM.notes" default="">
    <cfparam name="FORM.previousNotes" default="">
    <cfparam name="FORM.isSolved" default="0">

    <cfscript>
		if ( LEN(URL.uniqueID) ) {
			FORM.uniqueID = URL.uniqueID;
		}
		
		if ( VAL(URL.incidentID) ) {
			FORM.incidentID = URL.incidentID;
		}
		
		// Get Current Candidate Information
		qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(uniqueID=FORM.uniqueID);
		
		// Get Complete History
		qGetPlacementHistory = APPLICATION.CFC.CANDIDATE.getCandidatePlacementInformation(candidateID=qGetCandidateInfo.candidateID,placementStatus="");
		
		// Get Incident Information
		qGetIncidentInfo = APPLICATION.CFC.CANDIDATE.getIncidentReport(incidentID=FORM.incidentID, candidateID=qGetCandidateInfo.candidateID);
		
		// Get The Incident Subjects
		qGetIncidentSubjects = APPLICATION.CFC.CANDIDATE.getIncidentSubjects();
    
    	// FORM Submitted
		if ( FORM.submitted ) {
			
			// Check required Fields
			if ( NOT IsDate(FORM.dateIncident) ) {
				SESSION.formErrors.Add('Please enter a date');
			}

			if ( NOT LEN(FORM.subject) ) {
				SESSION.formErrors.Add('Please enter a subject');
			}

			if ( NOT VAL(qGetIncidentInfo.recordCount) AND NOT LEN(FORM.notes) ) {
				SESSION.formErrors.Add('Please enter notes');
			}
			
			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				

				// Add | Update Incident
				APPLICATION.CFC.CANDIDATE.insertUpdateIncident(
					incidentID = FORM.incidentID,
					candidateID = qGetCandidateInfo.candidateID,
					hostCompanyID = FORM.hostCompanyID,
					userID = CLIENT.userID,
					dateIncident = FORM.dateIncident,
					subject = FORM.subject,
					notes = FORM.notes,
					previousNotes = FORM.previousNotes,
					isSolved = FORM.isSolved
				);

				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");

			}
			
		} else {
			
			// Set the default values of the FORM 
			FORM.incidentID = VAL(qGetIncidentInfo.ID);
			FORM.hostCompanyID = VAL(qGetIncidentInfo.hostCompanyID);
			FORM.dateIncident = qGetIncidentInfo.dateIncident;
			FORM.subject = qGetIncidentInfo.subject;
			if ( NOT VAL(qGetIncidentInfo.recordCount) ) {
				FORM.notes = FORM.notes;
			}
			FORM.isSolved = qGetIncidentInfo.isSolved;
			FORM.previousNotes = qGetIncidentInfo.notes;
		}
    </cfscript>

</cfsilent>

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="extraNoHeader"
    />
    
        <cfif VAL(FORM.submitted) AND NOT SESSION.formErrors.length()>
        
            <script language="javascript">
                // Close Window After 1.5 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 1500);
            </script>
        
        </cfif>
    
        <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" style="border-color:##CCCCCC; background-color:##f4f4f4; margin-bottom:10px;">
            <tr>
                <td valign="top">
        
                    <!----Header Table---->
                    <table width="97%" cellpadding=0 cellspacing=0 border="0" align="center" height="25" style="background-color:##E4E4E4; margin-bottom:10px;">
                        <tr>
                            <td class="title1">&nbsp; &nbsp; Incident Management </td>
                            <td class="title1" align="right">#qGetCandidateInfo.firstname# #qGetCandidateInfo.lastname# (###qGetCandidateInfo.candidateid#) &nbsp; &nbsp;</td>
                        </tr>
                    </table>
    
                    <!--- Form --->
                    <form name="incidentReport" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
                        <input type="hidden" name="submitted" value="1">
                        <input type="hidden" name="uniqueID" value="#FORM.uniqueID#">
                        <input type="hidden" name="incidentID" value="#FORM.incidentID#">
    
                        <!--- Page Messages --->
                        <gui:displayPageMessages 
                            pageMessages="#SESSION.pageMessages.GetCollection()#"
                            messageType="tableSection"
                            width="97%"
                            />
                        
                        <!--- Form Errors --->
                        <gui:displayFormErrors 
                            formErrors="#SESSION.formErrors.GetCollection()#"
                            messageType="tableSection"
                            width="97%"
                            />
                            
                        <table width="97%" cellpadding="3" cellspacing="0" align="center" style="padding:5px; background-color:##FFFFFF; border:1px solid ##C7CFDC; padding-bottom:10px; margin-bottom:10px;">
                            <tr>
                                <td width="25%" class="style2" style="background-color:##8FB6C9; border-bottom:1px solid ##C7CFDC; text-align:right; padding-right:10px;">Host Company</td>
                                <td width="75%" style="border-bottom:1px solid ##C7CFDC;">
                                	<select name="hostCompanyID" id="hostCompanyID" class="xLargeField">
                                    	<cfloop query="qGetPlacementHistory">
                                        	<option value="#qGetPlacementHistory.hostCompanyID#" <cfif qGetPlacementHistory.hostCompanyID EQ FORM.hostCompanyID> selected="selected" </cfif> >#qGetPlacementHistory.hostCompanyName#</option>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td class="style2" style="background-color:##8FB6C9; border-bottom:1px solid ##C7CFDC; text-align:right; padding-right:10px;">Date</td>
                                <td style="border-bottom:1px solid ##C7CFDC;">
                                    <input type="text" name="dateIncident" id="dateIncident" value="#DateFormat(FORM.dateIncident, 'mm/dd/yyyy')#" class="datePicker">
                                </td>
                            </tr>
                            <tr>
                                <td class="style2" style="background-color:##8FB6C9; border-bottom:1px solid ##C7CFDC; text-align:right; padding-right:10px;">Nature of Complaint</td>
                                <td style="border-bottom:1px solid ##C7CFDC;">
                                	<select name="subject" id="subject" class="xLargeField">
                                    	<cfloop query="qGetIncidentSubjects">
                                        	<option value="#qGetIncidentSubjects.subject#" <cfif qGetIncidentSubjects.subject EQ FORM.subject> selected="selected" </cfif> >
                                            	#qGetIncidentSubjects.subject#
                                          	</option>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr>
                            <cfif VAL(qGetIncidentInfo.recordCount)>
                            	<script type="text/javascript">
									var commentsArray = null;
									$(document).ready(function() {
										var incidentComments = $("##previousNotes").val();
										var comments = incidentComments.split("<p>");
										commentsArray = new Array((comments.length-1)*2);
										for (var i=1; i<comments.length; i++) {
											commentsArray[(i-1)*2] = comments[i].substring(8,comments[i].indexOf("</strong>"));
											commentsArray[((i-1)*2)+1] = comments[i].substring(comments[i].indexOf("</strong>")+17,comments[i].indexOf("</p>"));
										}
										for (var j=0; j<commentsArray.length; j+=2) {
											$("##previousNotesDiv").html(
												$("##previousNotesDiv").html() + 
												"<strong><div contenteditable='true' id='comment" + j + "'>" + commentsArray[j] + "</div></strong>" +
												commentsArray[j+1] + "<br/><br/>");	
										}
									});
									
									function updatePreviousNotes() {
										var newPreviousNotes = "";
										for (var i=0; i<commentsArray.length; i+=2) {
											// Do not include empty comments
											if ($("##comment" + i).html() != "<br>" && $("##comment" + i).html() != "") {
												newPreviousNotes = newPreviousNotes + "<p><strong>" + $("##comment" + i).html() + "</strong> <br / >" + commentsArray[i+1] + "</p>";
											}
										}
										$("##previousNotes").val(newPreviousNotes);
									}
								</script>
                            	<input type="hidden" name="previousNotes" id="previousNotes" value="#FORM.previousNotes#"/>
                                <tr>
                                    <td class="style2" style="background-color:##8FB6C9; border-bottom:1px solid ##C7CFDC; text-align:right; padding-right:10px; vertical-align:top;">Previous Notes</td>
                                    <td style="border-bottom:1px solid ##C7CFDC;" valign="top">
                                        <div id="previousNotesDiv"></div>
                                    </td>
                                </tr>
                            </cfif>
                            <tr>
                                <td class="style2" style="background-color:##8FB6C9; border-bottom:1px solid ##C7CFDC; text-align:right; padding-right:10px; vertical-align:top;">Notes</td>
                                <td style="border-bottom:1px solid ##C7CFDC;">
                                    <textarea name="notes" id="notes" class="xLargeTextArea">#FORM.notes#</textarea>
                                </td>
                            </tr>
                            <tr>
                                <td class="style2" style="background-color:##8FB6C9; border-bottom:1px solid ##C7CFDC; text-align:right; padding-right:10px; vertical-align:top;">Solved</td>
                                <td style="border-bottom:1px solid ##C7CFDC;">
                                    <select name="isSolved" id="isSolved">
                                    	<option value="0" <cfif FORM.isSolved EQ 0>selected</cfif> >No</option>
                                        <option value="1" <cfif FORM.isSolved EQ 1>selected</cfif> >Yes</option>                                    
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
                                    <input type="image" name="submit" src="../../pics/update.gif" border="0" alt=" update " onclick="updatePreviousNotes()">
                                </td>
                            </tr>                            
                        </table>
                    </form>    
                        
                </td>
            </tr>
        </table>

	<!--- Page Footer --->
    <gui:pageFooter
        footerType="extra"
    />

</cfoutput>