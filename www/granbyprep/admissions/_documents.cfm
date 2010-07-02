<!--- ------------------------------------------------------------------------- ----
	
	File:		_documents.cfm
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		Section 1 of the Online Application

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	

	<!--- Param FORM Variables --->
    <cfparam name="FORM.submittedType" default="">
    <cfparam name="FORM.currentTabID" default="3">
    <!--- Student Details --->
    <cfparam name="FORM.studentID" default="#APPLICATION.CFC.STUDENT.getStudentID()#">
    <cfparam name="FORM.foreignTable" default="student">

	<cfajaxproxy cfc="extensions.components.document" jsclassname="proxyDocument">

    <cfscript>
		// Get Current Student Information
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(ID=FORM.studentID);
		
		// Get a list of document types
		qGetDocumentType = APPLICATION.CFC.DOCUMENT.getDocumentType(applicationID=1);
	</cfscript>
    
</cfsilent>

<cfoutput>

<!--- Application Body --->
<div class="form-container">
    
    <!--- Upload Documents --->    
    <fieldset>

	   <legend>Upload Documents</legend>

        <div class="documentList" align="center">
        
            <cffileupload 
	            title="Select one or more files and click on Upload"
                name="fileData" 
                url="upload.cfm?#urlEncodedFormat(SESSION.URLToken)#"
                extensionfilter="jpg,jpeg,gif,png,bmp,tiff,pdf" 
                oncomplete="handleComplete"             
                maxfileselect="5" 
                maxuploadsize="3" 
                bgcolor="##FFFFFF" 
                align="center"
                width="650px">

		</div>
        
    </fieldset>
	

	<!--- File Options Successfull Message --->
    <div id="pageMessages" class="pageMessages"></div>
    
    <form name="filePropertySection" id="filePropertySection" class="documentProperties" onsubmit="return updateFile();">
    	 <input type="hidden" name="documentID" id="documentID" value="" />
         
        <fieldset>
    
           <legend>File Properties</legend>
    
            <!--- File Name --->
            <div class="field">
                <label for="fileName">File Name <em>*</em></label> 
                <input type="text" name="fileName" id="fileName" value="" class="largeField" maxlength="100" disabled="disabled" />
            </div>
            
            <!--- File Category --->
            <div class="field">
                <label for="fileCategory">Category <em>*</em></label> 
                <select name="documentTypeID" id="documentTypeID" class="largeField">
                    <option value="0"></option>
                    <cfloop query="qGetDocumentType">
                        <option value="#qGetDocumentType.ID#">#qGetDocumentType.name#</option>
                    </cfloop>
                </select>
            </div>
            
        </fieldset>

        <div class="buttonrow">
            <input type="submit" value="Save" class="button ui-corner-top" />
        </div>
    
    </form>


	<!--- Uploaded Documents --->
    <fieldset>

	   	<legend>Uploaded Documents</legend>

		<div class="documentList" align="center">
            <cfform>
            <!--- These variables are used in the CFGrid --->
            <input type="hidden" name="foreignTable" id="foreignTable" value="#FORM.foreignTable#" />
            <input type="hidden" name="studentID" id="studentID" value="#FORM.studentID#" />

            <cfgrid name="documentList" 
                title="Uploaded Files - Click on Edit to update the file category information"
                format="html"
                bind="cfc:extensions.components.document.getDocumentsRemote({foreignTable},{studentID},{cfgridPage},{cfgridPageSize},{cfgridSortColumn},{cfgridSortDirection})"                    
                width="650px"
                pagesize="6"
                bgcolor="##FFFFFF" 
                highlighthref="yes">
                                    
                <cfgridcolumn name="ID" display="no">
                <cfgridcolumn name="fileName" header="File Name" width="240">
                <cfgridcolumn name="documentType" header="Category" width="200">
                <cfgridcolumn name="fileSize" header="Size" width="60">
                <cfgridcolumn name="displayDateCreated" header="Date" width="60">
                <cfgridcolumn name="action" header="Actions" width="90">
            </cfgrid>
			
            </cfform>
        </div>
		
	</fieldset>    
        
</div><!-- /form-container -->

</cfoutput>

<script type="text/javascript">
	// this function is called after a file has been uploaded
	var handleComplete = function(res) {		
		console.dir(res);
		if(res.STATUS==200) {
			// Refresh Grid
			ColdFusion.Grid.refresh('documentList', true);
		}
	}

	// Function to find the index in an array of the first entry with a specific value. 
	// It is used to get the index of a column in the column list. 
	Array.prototype.findIdx = function(value){ 
		for (var i=0; i < this.length; i++) { 
			if (this[i] == value) { 
				return i; 
			} 
		} 
	} 

	// Display File Properties
	var displayFile = function(id) {		
		// Create an instance of the proxy. 
		var documentCFC = new proxyDocument();
		documentCFC.setCallbackHandler(populateFileDetails);
		documentCFC.setErrorHandler(myErrorHandler);
		documentCFC.getDocumentByIDRemote(id);
	}
	
	// Populate File Name and Category
	var populateFileDetails = function(result) {		
		var docID = result.DATA[0][result.COLUMNS.findIdx('ID')];
		var fileName = result.DATA[0][result.COLUMNS.findIdx('FILENAME')];
		var documentTypeID = result.DATA[0][result.COLUMNS.findIdx('DOCUMENTTYPEID')];
		
		$("#documentID").val(docID);
		$("#fileName").val(fileName);
		$("#documentTypeID").val(documentTypeID);

		// Slide down form field div
		if ($("#filePropertySection").css("display") == "none") {
			$("#filePropertySection").slideDown("fast");		
		}
	}
	
	// Update File Category
	var updateFile = function() {		
		// Data Validation

		sendFileData();
		return false; // do not remove - firefox needs it in order to work properly
	}				
				
	var sendFileData = function() { 		
		// Create an instance of the proxy. 
		var documentCFC = new proxyDocument();
		documentCFC.setCallbackHandler(submitResponse);
		documentCFC.setErrorHandler(myErrorHandler);
		documentCFC.updateDocumentTypeIDRemote(
			$("#documentID").val(),
			$("#documentTypeID").val()
		);
	}
	
	var submitResponse = function() { 
		// Erase Information
		$("#documentID").val("");
		$("#fileName").val("");
		$("#documentTypeID").val("");
		
		// Hide Section
		$("#filePropertySection").slideUp("slow",function(){
	   		// Display successfully message
			$("#pageMessages").html("<p><em>The file category has been saved Successfully.</em></p>");		
			// FadeIn and FadeOut Message
			$("#pageMessages").fadeIn().fadeOut(4000);
		});
		
		// Refresh Grid
		ColdFusion.Grid.refresh('documentList', true);
	}

	/* Delete File */
	var deleteFile = function(id) { 
		if(confirm('Are you sure you wish to permanently delete this file?')){
			// Create an instance of the proxy. 
			var documentCFC = new proxyDocument();
			documentCFC.setCallbackHandler(deleteFileConfirmation);
			documentCFC.setErrorHandler(myErrorHandler);
			documentCFC.deleteDocumentRemote(id);
		}
	}
	
	function deleteFileConfirmation() {
		// Set up message
		$("#pageMessages").html("<p><em>The file has been deleted.</em></p>");
		// FadeIn and FadeOut Message
		$("#pageMessages").fadeIn().fadeOut(4000);
		
		// Refresh Grid
		ColdFusion.Grid.refresh('documentList', true);
	}
	
	/* Error Handler */
	var myErrorHandler = function(statusCode,statusMessage) { 
		alert('Status: ' + statusCode + ', ' + statusMessage); 
	}
</script>

