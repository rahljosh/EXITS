<!--- ------------------------------------------------------------------------- ----
	
	File:		culturalActivityReport.cfm
	Author:		James Griffiths
	Date:		May 24, 2012
	Desc:		Cultural Activity Report Tool

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />	
    
    <!--- PARAM URL Variables --->
	<cfparam name="URL.uniqueID" default="">
    <cfparam name="URL.activityID" default="0">
    
    <!--- PARAM FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.uniqueID" default="">	
    <cfparam name="FORM.activityID" default="0">
    <cfparam name="FORM.date" default="">
	<cfparam name="FORM.details" default="">

    <cfscript>
		if ( LEN(URL.uniqueID) ) {
			FORM.uniqueID = URL.uniqueID;
		}
		
		if ( VAL(URL.activityID) ) {
			FORM.activityID = URL.activityID;
		}
		
		// Get Current Candidate Information
		qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(uniqueID=FORM.uniqueID);
		
		// Get Host Company Information
		qGetPlacementInformation = APPLICATION.CFC.CANDIDATE.getCandidatePlacementInformation(candidateID=qGetCandidateInfo.candidateID);
		
		// Get Cultural Activity Information
		qGetCulturalActivityInfo = APPLICATION.CFC.CANDIDATE.getCulturalActivityReport(activityID=FORM.activityID,candidateID=qGetCandidateInfo.candidateID);
    
		// Get All Cultural Activity Information
		qGetAllCulturalActivityInfo = APPLICATION.CFC.CANDIDATE.getCulturalActivityReport(candidateID=qGetCandidateInfo.candidateID);
		
    	// FORM Submitted
		if ( FORM.submitted ) {
			
			// Check required Fields
			if ( NOT IsDate(FORM.date) ) {
				SESSION.formErrors.Add('Please enter a date');
			}

			if ( NOT LEN(FORM.details) ) {
				SESSION.formErrors.Add('Please enter details');
			}
			
			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				

				// Add | Update Incident
				APPLICATION.CFC.CANDIDATE.insertUpdateCulturalActivity(
					activityID = FORM.activityID,
					candidateID = qGetCandidateInfo.candidateID,
					userID = CLIENT.userID,
					date = FORM.date,
					details = FORM.details
				);

				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");

			}
			
		} else {
			
			// Set the default values of the FORM 
			FORM.activityID = VAL(qGetCulturalActivityInfo.ID);
			FORM.date = qGetCulturalActivityInfo.dateActivity;
			FORM.details = qGetCulturalActivityInfo.details;
			
		}
    </cfscript>

</cfsilent>

<cfif VAL(FORM.submitted) AND NOT SESSION.formErrors.length()>

	<cflocation url="culturalActivityReport.cfm?uniqueID=#URL.uniqueID#">

</cfif>

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="extraNoHeader"
    />
    
        <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" style="border-color:##CCCCCC; background-color:##f4f4f4; margin-bottom:10px;">
            <tr>
                <td valign="top">
        
                    <!----Header Table---->
                    <table width="97%" cellpadding=0 cellspacing=0 border="0" align="center" height="25" style="background-color:##E4E4E4; margin-bottom:10px;">
                        <tr>
                            <td class="title1">&nbsp; &nbsp; Cultural Activity Management </td>
                            <td class="title1" align="right">#qGetCandidateInfo.firstname# #qGetCandidateInfo.lastname# (###qGetCandidateInfo.candidateid#) &nbsp; &nbsp;</td>
                        </tr>
                    </table>
    
                    <!--- Form --->
                    <form name="culturalActivityReport" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
                        <input type="hidden" name="submitted" value="1">
                        <input type="hidden" name="uniqueID" value="#FORM.uniqueID#">
                        <input type="hidden" name="activityID" value="#FORM.activityID#">
    
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
                                <td class="style2" style="background-color:##8FB6C9; border-bottom:1px solid ##C7CFDC; text-align:right; padding-right:10px;">Date</td>
                                <td style="border-bottom:1px solid ##C7CFDC;">
                                    <input type="text" name="date" id="date" value="#DateFormat(FORM.date, 'mm/dd/yyyy')#" class="datePicker">
                                </td>
                            </tr>
                            <tr>
                                <td class="style2" style="background-color:##8FB6C9; border-bottom:1px solid ##C7CFDC; text-align:right; padding-right:10px;">Details</td>
                                <td style="border-bottom:1px solid ##C7CFDC;">
                                    <input type="text" name="details" id="details" value="#FORM.details#" class="xxLargeField" maxlength="250">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
                                    <input type="image" name="submit" src="../../pics/update.gif" border="0" alt=" update ">
                                </td>
                            </tr>                            
                        </table>
                    </form> 
                    
                    <!--- List of cultural activities --->
                    <table width="97%" cellpadding="3" cellspacing="0" align="center" style="padding:5px; background-color:##FFFFFF; border:1px solid ##C7CFDC; padding-bottom:10px; margin-bottom:10px;">
                        <tr style="background-color:##E4E4E4; font-weight:bold;">
                        	<td width="15%">Date</td>
                            <td>Details</td>
                        </tr>
                        <cfloop query="qGetAllCulturalActivityInfo">
                            <tr>
                            	<td>#DateFormat(dateActivity,'mm/dd/yyyy')#</td>
                                <td>#details#</td>
                            </tr>
                        </cfloop>
                  	</table> 
                        
                </td>
            </tr>
        </table>

	<!--- Page Footer --->
    <gui:pageFooter
        footerType="extra"
    />

</cfoutput>