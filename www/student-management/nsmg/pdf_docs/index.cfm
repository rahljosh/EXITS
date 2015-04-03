<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		January 20, 2009
	Desc:		PDF Docs Index

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param Variables --->	
    <cfparam name="FORM.message" default="">
    
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.action" default="">
    
    <cfparam name="FORM.categoryID" default="0">
    <cfparam name="FORM.fileName" default="">
    <cfparam name="FORM.folderPath" default="">
    
	<cfscript>
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);
	
		if ( CLIENT.companyID EQ 5 ) {
			// Get ISE Info
			qGetCompany = APPCFC.COMPANY.getCompanies(companyID=1);
		} else {
			// Get Company Info
			qGetCompany = APPCFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
		}
		
		// Get PDF Categories
		if (CLIENT.companyid neq 14) {
			qGetPDFCategory = APPCFC.pdfDoc.getPDFCategories(userTypeID=CLIENT.userType);
		} else {
			qGetPDFCategory = APPCFC.pdfDoc.getPDFCategories();
		}
		
		// FORM SUBMITTED
		if ( VAL(FORM.submitted) ) {

			switch (FORM.action) {
				
				// Upload File
				case "upload": {
		
					// Data Validation
					if ( NOT VAL(FORM.categoryID) ) {
						ArrayAppend(Errors.Messages, "Please select a category.");
					}
		
					if ( NOT LEN(FORM.fileName) ) {
						ArrayAppend(Errors.Messages, "Please select a file.");
					}
					
					// Check if there are no errors
					if ( NOT VAL(ArrayLen(Errors.Messages)) ) {
						
						// Upload File
						FORM.message = APPCFC.PDFDOC.uploadPDFDocument(categoryID=FORM.categoryID, fileName=fileName).message;
						
					}
					
					break;
				}

				// Delete File
				case "delete": {
						
					FORM.message = APPCFC.PDFDOC.deletePDFDocument(folderPath=FORM.folderPath, fileName=FORM.fileName).message;
					
					break;
				}
				
			} // end of switch

		} // end of if
    </cfscript>

</cfsilent>

<script language="JavaScript">
	<!--
	//The DOM is now loaded and can be manipulated.
  	$(document).ready(function () {
		// Hide Any Divs
		hideClass('divCategory'); 
		// Display Selected Div
		displayDiv('divCategory' + $("input[name='selCategoryID']:checked").val() );
	});

	function areYouSure() { 
	   if(confirm("You are about to delete this file. Click OK to continue")) { 
		 	form.submit(); 
			return true; 
	   } else { 
			return false; 
	   } 
	} 
	
	function setCategoryID() {
		$("#categoryID").val( $("input[name='selCategoryID']:checked").val() );
	}	
	// -->
</script>

<cfoutput>

<!--- Header --->
<table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
	<tr valign="middle" height="24">
		<td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
		<td width="26" background="pics/header_background.gif"><img src="pics/docs.gif"></td>
		<td background="pics/header_background.gif"><h2> PDF Categories </h2></td>
        <cfif CLIENT.userType LTE 3>
	        <td align="right" background="pics/header_background.gif"> <a href="javascript:displayDiv('uploadForm');">Upload Document</a></td>
        </cfif>
		<td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<!--- Documents --->
<table width="100%" align="center" class="section" cellpadding="2" cellspacing="2">

	<!--- Display Messages --->
    <cfif LEN(FORM.message)>
        <tr>
            <td align="center" colspan="2" ><br /> <h3>*** #FORM.message# ***</h3></td>
        </tr>
    </cfif>	
    
    <tr>
		<td colspan="2" style="padding-left:20px;">
            Please Select a Category Below:
        </td>
        <td align="right">
            <a href="http://www.adobe.com/products/acrobat/readstep.html" target="_blank">
                <img src="pics/getacro.gif" width="88" height="31" alt="Download Adobe Acrobat Reader" border="0">
            </a>
        </td>
	</tr>
	<tr>
        <cfloop query="qGetPDFCategory">    
            <td style="padding-left:20px;">
                <input type="radio" 
                	name="selCategoryID" 
                    id="categoryID#qGetPDFCategory.ID#" 
                    value="#qGetPDFCategory.ID#" 
                    onclick="hideClass('divCategory'); displayDiv('divCategory#qGetPDFCategory.ID#'); setCategoryID();" 
                    <cfif FORM.categoryID EQ qGetPDFCategory.ID> checked="checked" </cfif> /> 
                    
                <label for="categoryID#qGetPDFCategory.ID#"> #qGetPDFCategory.name# </label> <br />
            </td>
            
            <cfif NOT VAL(qGetPDFCategory.currentRow MOD 2)>
                </tr>
                <tr>
            <cfelseif qGetPDFCategory.currentRow EQ qGetPDFCategory.recordCount>
            	</tr>
            </cfif>               
        </cfloop>
</table>  

<!--- Footer --->
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr valign="bottom">
		<td width="9" valign="top" height="12"><img src="pics/footer_leftcap.gif" ></td>
		<td width="100%" background="pics/header_background_footer.gif"></td>
		<td width="9" valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

<br />

<!--- Categories --->
<cfloop query="qGetPDFCategory">    
	
    <cfscript>
		// Set Folder Path
		setFolderPath = "#AppPath.pdfDocs##qGetCompany.companyShort_noColor#/#qGetPDFCategory.folder_name#";
		
		// Set Download Path - Replace backwards slashes.
		//setDownloadPath = Replace("#AppPath.pdfDocs##qGetCompany.companyShort_noColor#/#qGetPDFCategory.folder_name#", "\", "/", "ALL");
    	setDownloadPath = "uploadedfiles/pdf_docs/#qGetCompany.companyShort_noColor#/#qGetPDFCategory.folder_name#";
		
		// Check if folder exits
		APPCFC.pdfDoc.createFolder(fullPath=setFolderPath);
    </cfscript>
    
    <!--- Get a Directory List for Each Category --->
    <cfdirectory name="listCategory#qGetPDFCategory.ID#" action="List" directory="#setFolderPath#" sort="name asc" filter="*.pdf">

    <div id="divCategory#qGetPDFCategory.ID#" style="display:none;" class="divCategory">
    
        <!--- Header --->
        <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
            <tr valign="middle" height="24">
                <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                <td width="26" background="pics/header_background.gif"><img src="pics/docs.gif"></td>
                <td background="pics/header_background.gif"><h2> #qGetPDFCategory.name# </h2></td>
                <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
            </tr>
        </table>
    
        <!--- PDF Document List --->
        <table width="100%" align="center" class="section" cellpadding="2" cellspacing="2">
            <tr bgcolor="##ffffe6" style="font-weight:bold;">
                <td style="padding-left:20px;">Name</td>
                <td>Last Modified</td>
                <td>Size</td>
                <td>Expiration Date</td> 
                <cfif CLIENT.userType LTE 3>
                    <th>Delete</th>
                </cfif>
            </tr> 

            <cfloop query="listCategory#qGetPDFCategory.ID#">
            
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("FFFFE6") ,DE("FFFFFF") )#">
                    <td style="padding-left:20px;"><a href="#setDownloadPath#/#name#" title="#name#" target="_blank">#name#</a></td>
                    <td>#DateFormat(dateLastModified, 'mm/dd/yyyy')#</td>
                    <td>#AppCFC.UDF.displayFileSize(size=size)#</td>
                	<td>#DateFormat(DateAdd('d',365,dateLastModified),"mm/dd/yyyy")#</td>
                    <cfif CLIENT.userType LTE 3>
                    <th>
                        <form method="post" action="" name="Delete">
                        	<input type="hidden" name="submitted" value="1" />
                            <input type="hidden" name="action" value="delete" />
                            <input type="hidden" name="categoryID" value="#qGetPDFCategory.ID#" />
                            <input type="hidden" name="folderPath" value="#setFolderPath#">
	                        <input type="hidden" name="fileName" value="#name#">
    	                    <input type="image" name="submit" src="pics/deletex.gif" alt="Delete this file" onclick="return areYouSure(this);"> 
                        </form>	                    
                    </th>
                    </cfif>
                    
                </tr>
                
            </cfloop> 

        </table>  
    
        <!--- Footer --->
        <table width="100%" cellpadding="0" cellspacing="0" border="0">
            <tr valign="bottom">
                <td width="9" valign="top" height="12"><img src="pics/footer_leftcap.gif" ></td>
                <td width="100%" background="pics/header_background_footer.gif"></td>
                <td width="9" valign="top"><img src="pics/footer_rightcap.gif"></td>
            </tr>
        </table>
        
        <br />
    
    </div>

</cfloop>


<!--- Upload Section --->
<cfif CLIENT.userType LTE 3>
    
    <div id="uploadForm" style="display:none">
    
        <!--- Header --->
        <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
            <tr valign="middle" height="24">
                <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                <td width="26" background="pics/header_background.gif"><img src="pics/docs.gif"></td>
                <td background="pics/header_background.gif"><h2> Upload Document </h2></td>
                <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
            </tr>
        </table>
    
        <form name="Upload" method="post" action="?#cgi.QUERY_STRING#" enctype="multipart/form-data">
        <input type="hidden" name="submitted" value="1">
        <input type="hidden" name="action" value="upload">
        
        <table width="100%" align="center" class="section">

            <!--- Display Errors --->
            <cfif VAL(ArrayLen(Errors.Messages))>
                <tr>
                    <td align="center" style="color:##FF0000">
                        <strong>*** Please review the following items: ***</strong> <br>
                        
                        <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                            #Errors.Messages[i]# <br>        	
                        </cfloop>
                    </td>
                </tr>
            </cfif>	
        
            <tr><td style="padding-left:20px;">Please upload your file here:</td></tr>
            <tr>
                <td style="padding-left:20px;"> 
                    Category: <br>
                    <select name="categoryID" id="categoryID">
                        <option value="0">Select</option>
                        <cfloop query="qGetPDFCategory">    
                            <option value="#qGetPDFCategory.ID#" <cfif qGetPDFCategory.ID EQ FORM.categoryID> selected="selected" </cfif> >#qGetPDFCategory.name#</option>
                        </cfloop>
                    </select>
                </td>
            </tr>
            <tr>
                <td style="padding-left:20px;"> 
                    Browse for the file..<br>
                    <input type="file" name="fileName" size="40">
                </td>
            </tr>
            <tr><td align="center"><input name="submit" type="image" src="pics/submit.gif" alt="Upload File"></td></tr>
        </table>
        
        </form>
        
        <!--- Footer --->
        <table width="100%" cellpadding="0" cellspacing="0" border="0">
            <tr valign="bottom">
                <td width="9" valign="top" height="12"><img src="pics/footer_leftcap.gif" ></td>
                <td width="100%" background="pics/header_background_footer.gif"></td>
                <td width="9" valign="top"><img src="pics/footer_rightcap.gif"></td>
            </tr>
        </table>
    
    </div>

</cfif>

</cfoutput>