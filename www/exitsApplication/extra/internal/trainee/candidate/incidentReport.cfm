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
    <cfparam name="FORM.reportedBy" default="">
    <cfparam name="FORM.relationshipToParticipant" default="">
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
		
		// Get Incident Notes
		qGetIncidentNotes = APPLICATION.CFC.CANDIDATE.getIncidentNotes(incidentID=FORM.incidentID);
		
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
				
				// Create struct with previous notes to update if neccessary
				previousNotes = ArrayNew(2);
				for (i = 1; i <= qGetIncidentNotes.recordCount; i = i + 1) {
					note = ArrayNew(1);
					note[1] = qGetIncidentNotes.id[i];
					note[2] = FORM['#qGetIncidentNotes.id[i]#'];
					previousNotes[i] = note;
				}
				
				// Add | Update Incident
				APPLICATION.CFC.CANDIDATE.insertUpdateIncident(
					incidentID = FORM.incidentID,
					candidateID = qGetCandidateInfo.candidateID,
					hostCompanyID = FORM.hostCompanyID,
					dateIncident = FORM.dateIncident,
					subject = FORM.subject,
					reportedBy = FORM.reportedBy,
					relationshipToParticipant = FORM.relationshipToParticipant,
					previousNotes=previousNotes,
					notes = FORM.notes,
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
			FORM.reportedBy = qGetIncidentInfo.reportedBy;
			FORM.relationshipToParticipant = qGetIncidentInfo.relationshipToParticipant;
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
                            <tr>
                                <td class="style2" style="background-color:##8FB6C9; border-bottom:1px solid ##C7CFDC; text-align:right; padding-right:10px;">Reported By</td>
                                <td style="border-bottom:1px solid ##C7CFDC;">
                                	<input type="text" name="reportedBy" value="#FORM.reportedBy#" class="xLargeField"/>
                                </td>
                            </tr>
                            <tr>
                                <td class="style2" style="background-color:##8FB6C9; border-bottom:1px solid ##C7CFDC; text-align:right; padding-right:10px;">Relationship to Participant</td>
                                <td style="border-bottom:1px solid ##C7CFDC;">
                                	<select name="relationshipToParticipant" id="relationshipToParticipant" class="xLargeField">
                                    	<option value="Self">Self</option>
                                        <option value="Friend">Friend</option>
                                        <option value="Intl. Rep.">Intl. Rep.</option>
                                        <option value="Host Company">Host Company</option>
                                        <option value="DOS">DOS</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </td>
                            </tr>
                            <cfif VAL(qGetIncidentNotes.recordCount)>
                                <tr>
                                    <td class="style2" style="background-color:##8FB6C9; border-bottom:1px solid ##C7CFDC; text-align:right; padding-right:10px; vertical-align:top;">Notes</td>
                                    <td style="border-bottom:1px solid ##C7CFDC;" valign="top">
                                        <cfloop query="qGetIncidentNotes">
                                            <b>On #DateFormat(date,'mm/dd/yyyy')# at #TimeFormat(date,'HH:MM')# by #firstName# #lastName#</b>
                                            <br/>
                                            <textarea name="#id#" class="xLargeTextArea" style="height:36px;">#note#</textarea>
                                            <br/>
                                        </cfloop>
                                    </td>
                                </tr>
                            </cfif>
                            <tr>
                                <td class="style2" style="background-color:##8FB6C9; border-bottom:1px solid ##C7CFDC; text-align:right; padding-right:10px; vertical-align:top;">New Notes</td>
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