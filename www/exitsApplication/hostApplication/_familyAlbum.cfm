<!--- ------------------------------------------------------------------------- ----
	
	File:		familyAlbum.cfm
	Author:		Marcus Melo
	Date:		November 6, 2012
	Desc:		Host Family Album

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

	<!--- Param URL Variables --->
    <cfparam name="URL.deleteImageID" default="">

	<!--- Param FORM Variables --->
    <cfparam name="FORM.action" default="">
    <cfparam name="FORM.fileData" default="">
    <cfparam name="FORM.categoryID" default="">
	
    <cfscript>
		// Get Uploaded Images
		qGetUploadedImages = APPLICATION.CFC.DOCUMENT.getDocuments(
			foreignTable="smg_hosts",	
			foreignID=APPLICATION.CFC.SESSION.getHostSession().ID,
			seasonID=APPLICATION.selectedSeason,
			documentGroup="familyAlbum"
		);
	
		// Get Category List - do not require pictures for second room unless double placement is selected
		if (qGetHostFamilyInfo.acceptDoublePlacement EQ 1 AND qGetHostFamilyInfo.sharingBedroom NEQ "EachOther") {
			qGetCategoryList = APPLICATION.CFC.DOCUMENT.getDocumentType(documentGroup="familyAlbum");
		} else {
			qGetCategoryList = APPLICATION.CFC.DOCUMENT.getDocumentType(documentGroup="familyAlbum",ignoreIDs="38,39");
		}
		
	
    	vUploadedImageList = ValueList(qGetUploadedImages.documentTypeID);
		
		// Required Images
		stUploadInfo = StructNew();
		stUploadInfo.totalUpload = 0;
		stUploadInfo.totalRequired = 6;
		stUploadInfo.remainingImages = 6;
		stUploadInfo.categoryList = "";
		
		
		// Loop through uploaded images to check how many of the required images were uploaded
		for ( i=1; i LTE qGetCategoryList.recordCount; i++ ) {
			if ( ListFind(vUploadedImageList, qGetCategoryList.ID[i]) ) {
				stUploadInfo.totalUpload++;				
			} else if ( qGetCategoryList.ID[i] NEQ 26 ) {
				stUploadInfo.categoryList = ListAppend(stUploadInfo.categoryList, qGetCategoryList.name[i], ",");	
			} 
		}
		
		stUploadInfo.remainingImages = stUploadInfo.totalRequired - stUploadInfo.totalUpload;
    </cfscript>

	<!--- Delete Image --->
    <cfif VAL(URL.deleteImageID)>
    	        
		<cfscript>
            // Delete Document
            APPLICATION.CFC.DOCUMENT.deleteDocumentByID(ID=URL.deleteImageID, documentGroup="familyAlbum");

			// Set Page Message
            SESSION.pageMessages.Add("Picture has been deleted");
			
			// Refresh Page
			location("#CGI.SCRIPT_NAME#?section=#URL.section#", "no");
        </cfscript>

    </cfif>

	<!--- Update Descriptions --->
    <cfif FORM.action EQ 'updateDescription'>
    
        <cfloop query="qGetUploadedImages">
        	
            <cfscript>
				// Update Description - Allow up to 500 chars
				APPLICATION.CFC.DOCUMENT.updateDocumentDescriptionByID(ID=qGetUploadedImages.ID,description=LEFT(FORM['desc_' & qGetUploadedImages.ID], 500));
			</cfscript>
            
        </cfloop>
        
		<cfscript>
            // Successfully Updated - Set navigation page
            Location(APPLICATION.CFC.UDF.setPageNavigation(section=URL.section), "no");
        </cfscript>				
        
    </cfif>
    
    <!--- Upload File --->
	<cfif FORM.action EQ 'uploadFile'>
    
		<!--- Process Form Submission --->
        <cfscript>
            // Data Validation
            if ( NOT LEN(FORM.fileData) ) {
                SESSION.formErrors.Add("Please select a file to upload.");
            }
			
            // Data Validation
            if ( NOT LEN(FORM.categoryID) ) {
                SESSION.formErrors.Add("Please indicate which catagory this picture belongs to.");
            }
        </cfscript>
			
        <!--- No Errors - we have a file and category --->
        <cfif NOT SESSION.formErrors.length()>
        	
            <cfscript>
				// Upload Image
				stResult = APPLICATION.CFC.DOCUMENT.familyAlbumUpload(formField=FORM.fileData, documentTypeID=ReplaceNoCase(FORM.categoryID,'area','') );														   
			
				if ( stResult.isSuccess ) {
                    // Set Page Message
                    SESSION.pageMessages.Add(stResult.message);
				} else {
					// Set Error Message
					SESSION.formErrors.Add(stResult.message);
				}	
				
				// Refresh Page
				location("#CGI.SCRIPT_NAME#?section=#URL.section#", "no");
			</cfscript>
            
		</cfif>
	
	</cfif>    
    
</cfsilent>
<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
<META HTTP-EQUIV="EXPIRES" CONTENT="01 Jan 1970 00:00:00 GMT">
<META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE">
<head>
<cfheader name="expires" value="#now()#"> 
<cfheader name="pragma" value="no-cache"> 
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">
</head>
<style type="text/css">
	.box{
		margin: 10px 0px;
		padding:15px 10px 15px 50px;
		background-repeat: no-repeat;
		background-position: 10px center;
		position:relative;
		color: #000;
		background-color:#FFC;
		background-image: url('images/info.png');
	}
</style>

<script type="text/javascript">
	$(document).ready(function(){
		$('.box').hide();
		
		$('#dropdown').change(function() {
			$('.box').hide();
			$('#div' + $(this).val()).show();
		});
		
	});
	
	$(document).ready(function(){
		//Examples of how to assign the ColorBox event to elements
		$(".jQueryModal").colorbox( {
			width:"80%", 
			height:"95%", 
			iframe:true,
			overlayClose:false,
			escKey:false,
			onClosed:function(){ location.reload(true)}

    		
		});	
		
		//Examples of how to assign the ColorBox event to elements
		$(".jQueryModalRefresh").colorbox( {
			width:"80%", 
			height:"95%", 
			iframe:true, 
			overlayClose:false,
			escKey:false, 
			onClosed:function(){ window.location.reload(); } 
		});
		

	});
</script>

<cfoutput>

    <h2>Family Album</h2> 

	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="section"
        />

	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
    
    Please upload photos of you, your family, and your home including the exterior and grounds, kitchen, student's bedroom, student's bathroom, 
    and family and living areas with a brief description of each. <br /><br />
    
    <h3>Upload Single Pictures<br /></h3>

    <font size=-2><em>Once you upload a picture, you will be able to add a description for each picture.</em></font><br /><br />

	<cfif NOT VAL(stUploadInfo.remainingImages)>
        No additional images are required, feel free to upload more.
    <cfelseif stUploadInfo.remainingImages EQ 6>
		At least 6 images are required, one for each of the following categories: <cfloop list="#stUploadInfo.categoryList#" index="i"><cfif i EQ ListLast(stUploadInfo.categoryList)> and <cfelseif i NEQ ListFirst(stUploadInfo.categoryList)>, </cfif>#i#</cfloop> .
	<cfelse>
        #stUploadInfo.remainingImages# additional images are required, one for each of the following categories: <cfloop list="#stUploadInfo.categoryList#" index="i"><cfif i EQ ListLast(stUploadInfo.categoryList)> and <cfelseif i NEQ ListFirst(stUploadInfo.categoryList)>, </cfif>#i#</cfloop> .
    </cfif> <br /><br />

	<!--- Check if FORM submission is allowed --->
    <cfif APPLICATION.CFC.UDF.allowFormSubmission(section=URL.section)>
        
        <!--- Upload Form --->        
        <cfform method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" enctype="multipart/form-data">  
            <input type="hidden" name="action" value="uploadFile" />
            <table width="100%" cellspacing="0" cellpadding="2" class="border">
                <tr>
                    <td colspan="4">
                        <cfloop query="qGetCategoryList">
                            <div id="divarea#ID#" class="box" display="hidden">#qGetCategoryList.description#</div>
                        </cfloop>
                    </td>
                </tr>
                <tr>
                    <td>
                        Select a category for this picture:<br />
                        <select name="categoryID" id="dropdown" class="xLargeField">
                            <option value="0"></option>
                            <cfloop query="qGetCategoryList">
								<cfif qGetCategoryList.ID NEQ 26>
	                                <option value="area#qGetCategoryList.ID#" <cfif ListFind(vUploadedImageList, qGetCategoryList.ID)> style="background-color:##deeaf3;" </cfif> <cfif FORM.categoryID EQ "area#qGetCategoryList.ID#">selected</cfif>>
	                                    #qGetCategoryList.name#
                                    	<cfif ListFind(vUploadedImageList, qGetCategoryList.ID)>(Uploaded)</cfif>
	                                    <span class="required">*</span>
	                                </option>
								</cfif>
                            </cfloop>
							<!--- This is to ensure that the misc category appears last --->
							<cfloop query="qGetCategoryList">
								<cfif qGetCategoryList.ID EQ 26>
	                                <option value="area#qGetCategoryList.ID#" <cfif ListFind(vUploadedImageList, qGetCategoryList.ID)> style="background-color:##deeaf3;" </cfif> <cfif FORM.categoryID EQ "area#qGetCategoryList.ID#">selected</cfif>>
	                                    #qGetCategoryList.name#
                                    	<cfif ListFind(vUploadedImageList, qGetCategoryList.ID)>(Uploaded)</cfif>
	                                </option>
								</cfif>
                            </cfloop>
                        </select>
                    </td>
                    <td><input type="file" name="fileData"   /><br /></td>
                    <td><cfinput type="submit" name="Submit" validateat="onSubmit"  validate="submitonce" value="Submit" /></td>
                    <!----src="images/buttons/BlkSubmit.png"---->
                </tr>
            </table>
        </cfform> <br />
    
    </cfif>
    
    <span class="required">*At least one picture from this category is required. More than one photo may be needed to clearly depict each room.</span> <br /><br />

    <h3>Your Photo Album</h3>
   
    <!--- Update Description --->
    <form method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
    	<input type="hidden" name="action" value="updateDescription" />
        <cfset vTrRowCount = 1>
    	<table width="100%" cellspacing="0" cellpadding="4" class="border">
            <tr>
                <cfloop query="qGetUploadedImages">
                    
                    <cfscript>
						viewImagePath = "#APPLICATION.CFC.SESSION.getHostSession().PATH.relativeAlbumLarge##qGetUploadedImages.fileName#";
                        absoluteLargePath = "#APPLICATION.CFC.SESSION.getHostSession().PATH.albumLarge##qGetUploadedImages.fileName#";
                        absoluteThumbPath = "#APPLICATION.CFC.SESSION.getHostSession().PATH.albumThumbs##qGetUploadedImages.fileName#";
					</cfscript>
                    
                	<td width="50%" valign="top" align="center">
                        
                        <div style="display:block; margin:5px 0 2px 0;">
							
                            <span style="float:left; margin-right:3px;">
                                <label for="#qGetUploadedImages.ID#" style="font-weight:bold;">
                                	<span style="display:block; margin-bottom:5px;">#qGetUploadedImages.documentType#</span>
         							<a href="viewImage.cfm?viewImagePath=#viewImagePath#&absoluteLargePath=#absoluteLargePath#&absoluteThumbPath=#absoluteThumbPath#&label=#qGetUploadedImages.documentType#" class="jQueryModal">
                                   
                         <Cfif FileExists('#SESSION.HOST.PATH.albumThumbs##qGetUploadedImages.fileName#')> 
                       
                                    <!--- specify image via filename
								<cfset myImage = APPLICATION.CFC.UDF.imageExifOrientationRotate('#APPLICATION.CFC.SESSION.getHostSession().PATH.relativeAlbumThumbs##qGetUploadedImages.fileName#') />
                                <!--- resize --->
                                <cfset imageResize(myImage,"100","") />
                                <!--- display --->
                                <cfimage action="writeToBrowser" source="#myImage#" />
							 --->
                             <img src="#APPLICATION.CFC.SESSION.getHostSession().PATH.relativeAlbumThumbs##qGetUploadedImages.fileName#" border="0" width = 100>
                          <cfelse>
                          		<img src="images/problemPhoto.jpg" border="0">
                          </cfif>
						  
                                    <!----
                                    	<img src="#APPLICATION.CFC.SESSION.getHostSession().PATH.relativeAlbumThumbs##qGetUploadedImages.fileName#" border="0">
										---->
                                    </a>
                                    <!--- <cfimage action="writeToBrowser" source="#APPLICATION.CFC.SESSION.getHostSession().PATH.albumThumbs##qGetUploadedImages.fileName#"> --->
                                </label>
                            </span>    
                            
                            <span style="display:block; margin-bottom:5px;">Description of picture:</span>
                            <textarea name="desc_#qGetUploadedImages.ID#" id="#qGetUploadedImages.ID#" cols="20" rows="6">#qGetUploadedImages.description#</textarea>
                            
                        </div>

						<!--- Check if FORM submission is allowed --->
                        <cfif APPLICATION.CFC.UDF.allowFormSubmission(section=URL.section)>                         
                            <div style="display:block; margin:3px 0 5px 0; clear:both;"> 
                                <a href="index.cfm?section=familyAlbum&deleteImageID=#qGetUploadedImages.ID#" title="Click to delete #qGetUploadedImages.documentType# picture" onClick="return confirm('Are you sure you want to delete the #qGetUploadedImages.documentType# picture?')">
                                    <img src="images/buttons/deleteGreyRed.png" border="0"/>
                                </a>
                            </div>
						</cfif>                            
                    </td>
            		<cfif qGetUploadedImages.currentRow MOD 2 EQ 0>
                    	<cfset vTrRowCount ++>
                        </tr>
		                <tr <cfif vTrRowCount MOD 2 EQ 0> bgcolor="##deeaf3" </cfif> >
                    <cfelseif qGetUploadedImages.currentRow EQ qGetUploadedImages.recordCount>
                    	<td width="50%">&nbsp;</td> 
        		    </cfif>
		        </cfloop>
            
			<cfif NOT qGetUploadedImages.recordcount>
                <tr><td align="center"><h3>No pictures were found.  Not a  problem though, just upload a few and you'll be set.</h3></td></tr>
            </cfif>
    	</table>

        <!--- Check if FORM submission is allowed --->
        <cfif APPLICATION.CFC.UDF.allowFormSubmission(section=URL.section)>
            <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
                <tr>
                    <td align="center" valign="center">
                        When you are done editing the descriptions, just click "Next"
                    </td>                    
                    <td align="right">
                        <input name="Submit" type="image" src="images/buttons/Next.png"/>
                    </td>
                </tr>
            </table>
		</cfif>
        
    </form>
    
</cfoutput>