<!--- ------------------------------------------------------------------------- ----
	
	File:		virtualFolderDocuments.cfm
	Author:		James Griffiths
	Date:		December 10, 2013
	Desc:		Upload / Print Virtual Folder Documents

	Updated:	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param URL Variables --->
    <cfparam name="URL.view" default="0">
    <cfparam name="URL.delete" default="0">
    <cfparam name="URL.studentID" default="0">
    <cfparam name="URL.hostID" default="0">
    <cfparam name="URL.documentType" default="0">

    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.studentID" default="0">
    <cfparam name="FORM.documentType" default="0">
    <cfparam name="FORM.hostID" default="0">
    <cfparam name="FORM.fileData" default="">
    
    <cfscript>	
		vDisplayFile = false;
		
		// Check if we are displaying a file
		if ( VAL(URL.view) ) {
			vDisplayFile = true;
		}		
		
		// Check if we have a valid URL values
		if ( NOT VAL(FORM.studentID) ) {
			FORM.studentID = URL.studentID;
		}
		if ( NOT VAL(FORM.documentType) ) {
			FORM.documentType = URL.documentType;
		}
		if ( NOT VAL(FORM.hostID) ) {
			FORM.hostID = URL.hostID;	
		}
		
		// Get Student Information
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=FORM.studentID);

		// Get Virtual Folder Documents
		qGetVFDocuments = APPLICATION.CFC.UDF.getVirtualFolderDocuments(documentType=FORM.documentType,studentID=FORM.studentID,hostID=FORM.hostID);
		
		// Form Submitted
		if (FORM.submitted) {
			if ( NOT LEN(FORM.fileData) ) {
                SESSION.formErrors.Add("Please select a file to upload.");
            }
		}
		
		if (VAL(URL.delete)) {
			APPLICATION.CFC.UDF.deleteFromVirtualFolder(ID=VAL(qGetVFDocuments.vfID));	
		}
		
	</cfscript>
    
    <cfif FORM.submitted AND NOT SESSION.formErrors.length()>
    	<cfscript>
			currentDirectory = "#APPLICATION.PATH.onlineApp.virtualFolder##FORM.studentID#";
			if (VAL(FORM.hostID)) {
				currentDirectory &= "/#FORM.hostID#";	
			}
            AppCFC.UDF.createFolder(currentDirectory);
		</cfscript>
    	<cffile action="upload" filefield="fileData" destination="#currentDirectory#" nameconflict="makeunique" mode="777">
        <cfscript>
			APPLICATION.CFC.UDF.insertIntoVirtualFolder(documentType=FORM.documentType,studentID=FORM.studentID,hostID=FORM.hostID,fileName=FILE.ServerFile,generatedHow="manual");
		</cfscript>
    </cfif>
    
    <cfquery name="qGetVFDocumentName" datasource="#APPLICATION.DSN#">
    	SELECT documentType
        FROM virtualfolderdocuments
        WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.documentType#">
    </cfquery>
    
</cfsilent>    

<cfoutput>

	<cfif URL.view EQ 1>
   		<!--- Determins if this is a PDF or not --->
        <cfif LCASE(RIGHT(qGetVFDocuments.fileName,3)) EQ "pdf">
        	<cfset rPath = "../" & qGetVFDocuments.filePath & qGetVFDocuments.fileName>
        	<cfcontent type="application/pdf" file="#ExpandPath(rPath)#" deletefile="no">
        <cfelse>
            <div style="text-align:center; margin:auto;">
                <img src="../#qGetVFDocuments.filePath##qGetVFDocuments.fileName#"/>
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
            <span class="rdtitle">#qGetVFDocumentName.documentType#</span> 
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
                <script language="javascript">
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
                <input type="hidden" name="studentID" value="#FORM.studentID#" />
                <input type="hidden" name="documentType" value="#FORM.documentType#" />
                <input type="hidden" name="hostID" value="#FORM.hostID#" />
                <table width="50%" cellspacing="0" cellpadding="4" class="border" align="center">
                    <tr bgcolor="##1b99da">
                        <td align="center" colspan="2">
                            <h2 style="color:##FFFFFF;">
                                <strong>Student:</strong> 
                                #qGetStudentInfo.firstName# #qGetStudentInfo.familyLastName# (###qGetStudentInfo.studentID#)
                            </h2>
						</td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                        	<p>Please upload the #qGetVFDocumentName.documentType# in any of the following formats: JPG, PNG or PDF</p>
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