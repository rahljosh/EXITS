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
    <cfparam name="FORM.dateIncident" default="">
	<cfparam name="FORM.subject" default="">
	<cfparam name="FORM.notes" default="">
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
		
		// Get Host Company Information
		qGetPlacementInformation = APPLICATION.CFC.CANDIDATE.getCandidatePlacementInformation(candidateID=qGetCandidateInfo.candidateID);
		
		// Get Incident Information
		qGetIncidentInfo = APPLICATION.CFC.CANDIDATE.getIncidentReport(incidentID=FORM.incidentID, candidateID=qGetCandidateInfo.candidateID);
    
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
					hostCompanyID = VAL(qGetPlacementInformation.hostCompanyID),
					userID = CLIENT.userID,
					dateIncident = FORM.dateIncident,
					subject = FORM.subject,
					notes = FORM.notes,
					isSolved = FORM.isSolved
				);

				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");

			}
			
		} else {
			
			// Set the default values of the FORM 
			FORM.incidentID = VAL(qGetIncidentInfo.ID);
			FORM.dateIncident = qGetIncidentInfo.dateIncident;
			FORM.subject = qGetIncidentInfo.subject;
			if ( NOT VAL(qGetIncidentInfo.recordCount) ) {
				FORM.notes = FORM.notes;
			}
			FORM.isSolved = qGetIncidentInfo.isSolved;
			
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
                                <td width="75%" style="border-bottom:1px solid ##C7CFDC;">#qGetPlacementInformation.hostCompanyName#</td>
                            </tr>
                            <tr>
                                <td class="style2" style="background-color:##8FB6C9; border-bottom:1px solid ##C7CFDC; text-align:right; padding-right:10px;">Date</td>
                                <td style="border-bottom:1px solid ##C7CFDC;">
                                    <input type="text" name="dateIncident" id="dateIncident" value="#DateFormat(FORM.dateIncident, 'mm/dd/yyyy')#" class="datePicker">
                                </td>
                            </tr>
                            <tr>
                                <td class="style2" style="background-color:##8FB6C9; border-bottom:1px solid ##C7CFDC; text-align:right; padding-right:10px;">Subject</td>
                                <td style="border-bottom:1px solid ##C7CFDC;">
                                    <input type="text" name="subject" id="subject" value="#FORM.subject#" class="xxLargeField" maxlength="250">
                                </td>
                            </tr>
                            <cfif VAL(qGetIncidentInfo.recordCount)>
                                <tr>
                                    <td class="style2" style="background-color:##8FB6C9; border-bottom:1px solid ##C7CFDC; text-align:right; padding-right:10px; vertical-align:top;">Previous Notes</td>
                                    <td style="border-bottom:1px solid ##C7CFDC;" valign="top">
                                        #qGetIncidentInfo.notes#
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
                                    <input type="image" name="submit" src="../../pics/update.gif" border="0" alt=" update ">
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