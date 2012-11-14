<!--- ------------------------------------------------------------------------- ----
	
	File:		document.cfc
	Author:		Marcus Melo
	Date:		November 14, 2012
	Desc:		This holds the functions needed for the documents
	
	Update: 
	
----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="document"
	output="false" 
	hint="A collection of functions for the document">


    <cffunction name="familyAlbumUpload" hint="Upload family album images (large/resize)" returntype="struct">
        <cfargument name="categoryID" default="0" hint="categoryID is not required">
        <cfargument name="hostID" default="#APPLICATION.CFC.SESSION.getHostSession().ID#" hint="hostID is not required">
		
        <cfscript>
			// Set Result Message
			var stResult = StructNew();
			stResult.isSuccess = true;
			stResult.message = "";
		
			// List of Accepted Files
			var vAcceptedFilesList = 'jpg,jpeg';

			// Use divName to rename the files (eg bedroom, livingRoom...)
			var vCategoryName = APPLICATION.CFC.LOOKUPTABLES.getPictureCategory(ID=ARGUMENTS.categoryID).divName;
			
			// Set desired file name (keep extension consistent as jpg)
			var vNewFileName = vCategoryName & ".jpg";
			// Used to try different file names kitchen.jpg / kitchen1.jpg etc.
			var vFileCount = 0;

			// Check if default name is available
			while ( fileExists(APPLICATION.CFC.SESSION.getHostSession().PATH.albumLarge & vNewFileName) ) { 
				vFileCount ++;
				if ( VAL(vFileCount) ) {
					vNewFileName = vCategoryName & vFileCount & ".jpg";
				} else {
					vNewFileName = vCategoryName & ".jpg";
				}
			}	
			//isImageFile(); isImage();
		</cfscript>
        
		<!--- Upload the file to temp folder --->
		<cffile 
        	action="upload" 
            filefield="FORM.fileData" 
            destination="#APPLICATION.PATH.TEMP#" 
            nameconflict="makeunique">

        <!--- Check if we have a valid file --->
        <cfif ListFindNoCase(vAcceptedFilesList,FILE.ServerFileExt)>
				
			<!--- Try to resize images, if they are not a valid JPG CF throws an error --->
            <cftry>
            
                <cfscript>
                    // Set Original Image
                    vOriginalImage = ImageNew(FILE.ServerDirectory & "\" & FILE.ServerFile);
                    
                    // Get Image Info
                    vGetImageInfo = ImageInfo(vOriginalImage);

                    /***** Large Image *****/
					// Create a large version of the image by resizing them to a 800-pixel image, while maintaining the aspect ratio of the source image
					ImageScaleToFit(vOriginalImage,800,"");
					
                    // Save Large Image / eliminate problems with url friendly encoding when getting our images re-replace %20 with no-space
                    imageWrite(vOriginalImage, "#APPLICATION.CFC.SESSION.getHostSession().PATH.albumLarge#/#REReplace(vNewFileName,'%20','','ALL')#", "true");
                    
                    
                    /***** Thumb Image *****/
					// Create thumbnail version of the image by resizing them to a 100x100-pixel image, while maintaining the aspect ratio of the source image
					ImageScaleToFit(vOriginalImage,130,"");
                    
                    // Save Thumb Image / eliminate problems with url friendly encoding when getting our images re-replace %20 with no-space
                    imageWrite(vOriginalImage, "#APPLICATION.CFC.SESSION.getHostSession().PATH.albumThumbs#/#REReplace(vNewFileName,'%20','','ALL')#", "true");
                </cfscript>
            
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    INSERT INTO 
                        smg_host_picture_album 
                    (
                        fk_hostID, 
                        filename, 
                        cat
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#vNewFileName#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.categoryID#">
                    )
                </cfquery>

                <cfscript>
                    // Set Page Message
                    stResult.message = "Picture has been uploaded";
                </cfscript>
            
                <cfcatch type="any">
                
                    <cfscript>
                        // Could not resize image
                        stResult.isSuccess = false;
                        stResult.message = "You are trying to upload an invalid #UCase(FILE.ServerFileExt)# file. Please use a different file or open it using your favorite digital image software and save the file as #UCase(FILE.ServerFileExt)#.";
                    </cfscript>
                
                </cfcatch>
            
            </cftry>             
                
        <!--- Not a valid File --->
        <cfelse>
        
            <cfscript>
                // Not a valid file
                stResult.isSuccess = false;
				stResult.message = "You are trying to upload a #UCase(FILE.ServerFileExt)#. We only accept image files of type JPG or JPEG.  Please convert your file and try to upload again.";
            </cfscript>
        
        </cfif>
        
        <cfscript>
			// Delete Original File
			FileDelete(APPLICATION.PATH.TEMP & FILE.serverfile);
		</cfscript>
        
        <!--- Return Structure --->
        <cfreturn stResult>
        
    </cffunction>
    
    
</cfcomponent>