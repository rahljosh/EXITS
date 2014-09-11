<!--- ------------------------------------------------------------------------- ----
	
	File:		hostOrientation.cfm
	Author:		James Griffiths
	Date:		December 11, 2013
	Desc:		Upload / Print Host Family Orientation

	Updated:	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param URL Variables --->
    <cfparam name="URL.view" default="0">
    <cfparam name="URL.hostID" default="0">
    <cfparam name="URL.seasonID" default="0">
    <cfparam name="URL.delete" default="0">

    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.hostID" default="0">
    <cfparam name="FORM.seasonID" default="0">
    <cfparam name="FORM.signedDate" default="">
    <cfparam name="FORM.fileData" default="">
    
    <cfscript>	
		vDisplayFile = false;
		
		// Check if we are displaying a file
		if ( VAL(URL.view) ) {
			vDisplayFile = true;
		}		
		
		// Check if we have a valid URL.hostID
		if ( VAL(URL.hostID) AND NOT VAL(FORM.hostID) ) {
			FORM.hostID = URL.hostID;
		}
		
		// Check if we have a valid URL.seasonID
		if ( VAL(URL.seasonID) AND NOT VAL(FORM.seasonID) ) {
			FORM.seasonID = URL.seasonID;
		}

		// Get List of Host Family Applications
		qGetHostInfo = APPLICATION.CFC.HOST.getApplicationList(hostID=FORM.hostID);	

		// Get Uploaded Images
		qGetHostOrientation = APPLICATION.CFC.DOCUMENT.getDocuments(
			foreignTable="smg_hosts",	
			foreignID=FORM.hostID, 			
			documentGroup="hostOrientation",
			seasonID=FORM.seasonID
		);
		
		// Delete File
		if (VAL(URL.delete)) {
			APPLICATION.CFC.DOCUMENT.deleteDocumentByID(ID=VAL(qGetHostOrientation.ID));
		}
	</cfscript>
    
    <cfquery name="qGetDocumentID" datasource="#APPLICATION.DSN#">
    	SELECT ID
        FROM documentType
        WHERE documentGroup = "hostOrientation"
    </cfquery>
    
    <!--- FORM Submitted --->
    <cfif FORM.submitted>
    
		<cfscript>
			// Data Validation
			
			if ( NOT VAL(FORM.hostID) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("A host family record could not be found, please close this window and try again.");
			}	
			
            // Data Validation
            if ( NOT LEN(FORM.fileData) ) {
                SESSION.formErrors.Add("Please select a file to upload.");
            }
		</cfscript>
        
		<!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length() AND VAL(FORM.hostID)>			
			
            <cfscript>
				// Set Upload Path
				vSetUploadPath = APPLICATION.PATH.hostApp & FORM.hostID & "/docs/";

				// Upload File
				stResult = APPLICATION.CFC.DOCUMENT.uploadFile(
					foreignTable="smg_hosts",
					foreignID=FORM.hostID, 
					documentTypeID=qGetDocumentID.ID,
					uploadPath=vSetUploadPath,					
					description="Host Family Orientation",
					allowedExt="jpg,jpeg,png,pdf",
					seasonID=FORM.seasonID
				);

				if ( stResult.isSuccess ) {

					// Use same approval process of the host family sections
					APPLICATION.CFC.HOST.updateSectionStatus(
						hostID=FORM.hostID,
						seasonID=FORM.seasonID,
						itemID=19,
                        action="approved",
                        notes="",
						areaRepID=qGetHostInfo.areaRepresentativeID,
						regionalAdvisorID=qGetHostInfo.regionalAdvisorID,
						regionalManagerID=qGetHostInfo.regionalManagerID
					);
					
                    // Set Page Message
                    SESSION.pageMessages.Add(stResult.message);
				} else {
					// Set Error Message
					SESSION.formErrors.Add(stResult.message);
				}	

				// Set Page Message
				// SESSION.pageMessages.Add("Report successfully submitted. This window will close shortly.");
			</cfscript>
		
        </cfif>

	</cfif>
    
</cfsilent>

<cfoutput>

	<cfif vDisplayFile>
    	<cfif qGetHostOrientation.serverExt EQ "pdf">
        	<cflocation url="../uploadedfiles/hostApp/#FORM.hostID#/docs/#qGetHostOrientation.serverName#.#qGetHostOrientation.serverExt#">
        <cfelse>
        	<div style="text-align:center; margin:auto;">
                <img src="../uploadedfiles/hostApp/#FORM.hostID#/docs/#qGetHostOrientation.serverName#.#qGetHostOrientation.serverExt#"/>
            </div>
        </cfif>
        <cfabort/>
    </cfif> 

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
        filePath="../"
    />	

	<!--- Host Family Summary --->
    <div class="rdholder"> 
    
        <div class="rdtop"> 
            <span class="rdtitle">Host Family Orientation</span> 
        </div> <!-- end top --> 
        
        <div class="rdbox">

			<!--- Page Messages --->
            <gui:displayPageMessages 
                pageMessages="#SESSION.pageMessages.GetCollection()#"
                messageType="divOnly"
                width="90%"
                />
            
            <!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="divOnly"
                width="90%"
                />

			<!--- Close Window --->
            <cfif VAL(FORM.submitted) AND NOT SESSION.formErrors.length()>
                <script type="text/javascript">
                    // Close Window After 1.5 Seconds
                    setTimeout(function() { parent.$.fn.colorbox.close(); }, 1500);
                </script>
            <cfelseif VAL(URL.delete)>
				<script type="text/javascript">
                    // Close Window After immediately
                    setTimeout(function() { parent.$.fn.colorbox.close(); }, 1);
                </script> 
            </cfif> 

			<!--- Upload Form --->        
			<form action="#CGI.SCRIPT_NAME#" enctype="multipart/form-data" method="post">        
                <input type="hidden" name="submitted" value="1" />
                <input type="hidden" name="hostID" value="#FORM.hostID#" />
                <input type="hidden" name="seasonID" value="#FORM.seasonID#" />
                <table width="50%" cellspacing="0" cellpadding="4" class="border" align="center">
                    <tr bgcolor="##1b99da">
                        <td align="center" colspan="2">
                            <h2 style="color:##FFFFFF;">
                                <strong>Host Family:</strong> 
                                #APPLICATION.CFC.HOST.displayHostFamilyName(
                                    fatherFirstName=qGetHostInfo.fatherFirstName,
                                    fatherLastName=qGetHostInfo.fatherLastName,
                                    motherFirstName=qGetHostInfo.motherFirstName,
                                    motherLastName=qGetHostInfo.motherLastName)# (###qGetHostInfo.hostid#) - 
                                    #qGetHostInfo.city#, #qGetHostInfo.state# #qGetHostInfo.zip#
                            </h2>
						</td>
                    </tr>
                  
                   <tr>
                        <td align="center" colspan="2">
                        	<p>Use <a href="hostOrientationSignOff.cfm?hostID=#qGetHostInfo.hostid#&seasonID=#url.seasonid#" target="_new">THIS</a> form for the Host Family Orientation<br /><br />
						</td>
                    </tr>
                    
                   
                    <tr>
                        <td align="center" colspan="2">
                        	<p>Please upload the host family orientation in any of the following formats: JPG, PNG or PDF</p>
							<em>Scanned as a JPG works best</em> <br /><br />
						</td>
                    </tr>
                    <tr>
                        <td align="right"><strong>Select File:</strong></td>
                        <td align="left"><input type="file" name="fileData" /></td>
                    </tr>
                    <tr bgcolor="##F7F7F7">
                        <td align="center" colspan="2"><input type="image" src="../pics/buttons/submit.png" /></td>
                    </tr>
                </table>
            </form>
       
        </div>
        
        <div class="rdbottom"></div> <!-- end bottom --> 
        
	</div>
        
    <!--- Page Footer --->
    <gui:pageFooter
        footerType="noFooter"
        filePath="../"
    />

</cfoutput>