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


	<!--- Set up the properties of this component --->
	<cfproperty 
		name="My" 
		type="struct"
		hint="Holds instance data for this document controller"
		/>
		
	<cfproperty 
		name="FileRoot" 
		type="string"
		hint="The expanded path of the folder used to store documents within the file managemtn system"
		/>

	<cfproperty 
		name="My.AllowedExt" 
		type="string" 
		hint="List of possibly dangerous file extensions that the document controller will not upload." 
		/>
		
	<cfproperty 
		name="My.BlockedExt" 
		type="string" 
		hint="List of possibly dangerous file extensions that the document controller will not upload." 
		/>
		
		
	<!--- Invoke Pseudo-contructure --->
	<cfset VARIABLES.DSN = StructNew() />
	
	<!--- Instance variables --->
	<cfset VARIABLES.My = StructNew() />
	<cfset VARIABLES.My.FileRoot = "" />
    <cfset VARIABLES.My.AllowedExt = "jpg,jpeg,gif,png,bmp,tiff,pdf" />
	<cfset VARIABLES.My.BlockedExt = "dll,wsh,bas,cpl,inf,lnk,msp,reg,vb,pif,wsf,bat,crt,ins,mdb,mst,scf,scr,abe,chm,exe,isp,mde,pcd,sct,vbs,adp,cmd,hlp,msc,wsc,shs,vbe,asx,com,hta,jse,msi,prf,url" />


	<!--- Return the initialized UDF object --->
	<cffunction name="Init" access="public" returntype="document" output="No" hint="Returns the initialized document object">

		<cfscript>
			// Return this initialized instance
			return(this);
		</cfscript>

	</cffunction>
    
    
	<!--- Create Folder if it does not exist --->
	<cffunction name="createFolder" access="public" returntype="void" output="no" hint="Check if folder exits, if it does not, it creates it">
        <cfargument name="fullPath" type="string" required="yes" hint="Full Path is required" />
        
		<cftry>
        
			<!--- Make sure the directories are set up correctly --->
            <cfif NOT directoryExists(ARGUMENTS.fullPath)>
                
                <cfdirectory 
                	action="create" 
                    directory="#ARGUMENTS.fullPath#" 
                	/>
            
            </cfif>
		
            <cfcatch type="any">
            	<!--- Error Handler --->
				
            </cfcatch>
               
        </cftry>
        
	</cffunction>


	<!--- This hashes the given ID for security reasons --->
	<cffunction name="generateHashID" access="public" returntype="string" output="no" hint="Hashes the given ID for security reasons. To be used for documents only.">
		<cfargument name="ID" type="numeric" required="yes" />
		
        <cfscript>
			// Return hash
			return( ((ARGUMENTS.ID * 64) MOD 29) & (Chr(Right(ARGUMENTS.ID, 1) + 65)) & (ARGUMENTS.ID MOD 4) );		
		</cfscript>
        
	</cffunction>


	<!--- Check to see if the given document exists --->
	<cffunction name="DocumentExists" access="public" returntype="boolean" output="no" hint="Check to see if the given document exists">
		<cfargument name="ID" type="numeric" required="yes" />
		
		<!--- Query for document --->
		<cfquery 
        	name="qDocuments" 
	        datasource="#APPLICATION.DSN.Source#">
                SELECT
					ID,
                    CONCAT(location, serverName, '.', serverExt) AS filePath
                FROM 
                    document d
                WHERE
                    id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ID#" />		
		</cfquery>
		
        <cfscript>
			// Check to see if we have a returned record 
			if ( qDocuments.RecordCount ) {
				// Document exists in database - Return file existence
				return FileExists(qDocuments.filePath);
			} else {				
				return false;	
			}
		</cfscript>
        
	</cffunction>


	<!--- Check to see if the given file exists --->
	<cffunction name="checkFileExists" access="public" returntype="boolean" output="no" hint="Check to see if the given file exists">
		<cfargument name="filePath" type="string" required="yes" />
        
        <cfscript>
			// Return file existence
			return FileExists(ARGUMENTS.filePath);
		</cfscript>
        
	</cffunction>


	<cffunction name="getDocumentType" access="public" returntype="query" output="false" hint="Returns a list of document types">
    	<cfargument name="ID" default="0" hint="ID is not required">
        <cfargument name="applicationID" default="3" hint="Host Family Application = 3">
        <cfargument name="documentGroup" default="" hint="documentGroup is not required">

        <cfquery 
        	name="qGetDocumentType"
        	datasource="#APPLICATION.DSN.Source#">
                SELECT 
                	ID,
                    applicationID,
                    name,
                    documentGroup,
                    divName,
                    description,
                    dateCreated,
                    dateUpdated
				FROM
                	documentType
				WHERE
                	1 = 1
                    
				<cfif VAL(ARGUMENTS.ID)>
	                AND 
                        ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">
                </cfif>  
                                      
				<cfif VAL(ARGUMENTS.applicationID)>
	                AND 
                        applicationID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationID#">
                </cfif>  
                                      
				<cfif LEN(ARGUMENTS.documentGroup)>
	                AND 
                        documentGroup = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.documentGroup#">
                </cfif>  
                                      
        </cfquery> 

		<cfreturn qGetDocumentType>
	</cffunction>


    <!--- Function to get a document list --->
	<cffunction name="getDocuments" access="public" returntype="query" output="false" hint="Returns a list of documents">
        <cfargument name="ID" default="" hint="ID is required">
		<cfargument name="foreignTable" type="string" default="smg_hosts" />
		<cfargument name="foreignID" type="numeric" required="no" default="#APPLICATION.CFC.SESSION.getHostSession().ID#" />
		<cfargument name="documentGroup" default="" hint="documentGroup is not required">            

        <cfquery 
			name="qGetDocuments" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					d.ID,
                    d.hashID,
                    d.foreignTable,
                    d.foreignID,
                    d.documentTypeID,
                    d.description,
                    d.serverName,
                    d.serverExt,
                    d.clientName,
                    d.clientExt,
                    d.fileSize,
                    d.location,
                    d.isDeleted,
                    d.dateCreated,
                    d.dateUpdated,
                    CONCAT(serverName, '.', serverExt) AS fileName,
                    CONCAT(location, serverName, '.', serverExt) AS filePath,
                    dt.ID AS documentTypeID,
                    dt.name AS documentType
                FROM 
                    document d
				LEFT OUTER JOIN                      
                	documentType dt ON dt.ID = d.documentTypeID
				WHERE 
                	d.isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                AND    
                    d.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">
				AND
                	d.foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.foreignID)#">  
                
                <cfif LEN(ARGUMENTS.ID)>
                    AND    
                        d.ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(ARGUMENTS.ID)#">
                </cfif>
                    
				<cfif LEN(ARGUMENTS.documentGroup)>
	                AND 
                        dt.documentGroup = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.documentGroup#">
                </cfif>  
                    
                ORDER BY
                    d.dateCreated DESC     
		</cfquery>
		
		<cfreturn qGetDocuments />
	</cffunction>
    

	<!--- Update Description --->
	<cffunction name="updateDocumentDescriptionByID" access="public" returntype="void" output="false" hint="Updates document description">
		<cfargument name="ID" required="yes" hint="ID is required">
        <cfargument name="foreignTable" type="string" default="smg_hosts" />
		<cfargument name="foreignID" type="numeric" required="no" default="#APPLICATION.CFC.SESSION.getHostSession().ID#" />
        <cfargument name="description" type="string" default="" />

        <cfquery 
			datasource="#APPLICATION.DSN.Source#">
                UPDATE
                    document 
                SET
                	description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.description#"> 
				WHERE 
                	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">  
                AND 
                    foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">
				AND
                	foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.foreignID)#">  
		</cfquery>

	</cffunction>
    

	<!--- Delete Document --->
	<cffunction name="deleteDocumentByID" access="public" returntype="void" hint="Deletes a document">
		<cfargument name="ID" required="yes" hint="ID is required">
		<cfargument name="documentGroup" default="" hint="documentGroup is not required">            
		
        <cfscript>
			// Get File Information
			qGetDoc = getDocuments(ARGUMENTS.ID);		
		</cfscript>
        
        <cfquery 
			datasource="#APPLICATION.DSN.Source#">
                UPDATE
					document
				SET
                    isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                WHERE
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">
		</cfquery>

        <cftry>
        
			<!--- Delete File | Document or Large Image | --->
            <cffile action="delete" file="#qGetDoc.filePath#">            
			
            <cfif ARGUMENTS.documentGroup EQ 'picture'>
            
                <!--- Delete Thumb Image --->
                <cffile action="delete" file="#APPLICATION.CFC.SESSION.getHostSession().PATH.albumThumbs##qGetDoc.filename#"> 
            
            </cfif>
                    
            <cfcatch type="any">
				<!--- Error --->            
            </cfcatch>
        
        </cftry>
           
	</cffunction>


    <!--- Upload Family Album --->
    <cffunction name="familyAlbumUpload" hint="Upload family album images (large/resize)" returntype="struct">
		<cfargument name="foreignTable" type="string" default="smg_hosts" />
		<cfargument name="foreignID" type="numeric" required="no" default="#APPLICATION.CFC.SESSION.getHostSession().ID#" />
		<cfargument name="documentTypeID" type="numeric" required="yes" />
		
        <cfscript>
			// Set Result Message
			var stResult = StructNew();
			stResult.isSuccess = true;
			stResult.message = "";
		
			// List of Accepted Files
			var vAcceptedFilesList = 'jpg,jpeg';

			// Use divName to rename the files (eg bedroom, livingRoom...)
			var vCategoryName = getDocumentType(ID=ARGUMENTS.documentTypeID).divName;						
			
			// Set desired file name (keep extension consistent as jpg)
			var vNewFileName = vCategoryName;
			var vNewFileExtension = "jpg";
			
			// Used to try different file names kitchen.jpg / kitchen1.jpg etc.
			var vFileCount = 0;

			// Check if default name is available
			while ( fileExists(APPLICATION.CFC.SESSION.getHostSession().PATH.albumLarge & vNewFileName) ) { 
				vFileCount ++;
				if ( VAL(vFileCount) ) {
					vNewFileName = vCategoryName & vFileCount;
				} else {
					vNewFileName = vCategoryName;
				}
			}	
			
			// Complete File Name
			vCompleteFileName = vNewFileName & "." & vNewFileExtension;
		</cfscript>
        
		<!--- Upload the file to temp folder --->
		<cffile 
        	action="upload" 
            filefield="FORM.fileData" 
            destination="#APPLICATION.PATH.TEMP#" 
            nameconflict="makeunique">

        <!--- Check if we have a valid file || isImageFile(); isImage(); --->
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
                    imageWrite(vOriginalImage, "#APPLICATION.CFC.SESSION.getHostSession().PATH.albumLarge#/#REReplace(vCompleteFileName,'%20','','ALL')#", "true");
                    
                    
                    /***** Thumb Image *****/
					// Create thumbnail version of the image by resizing them to a 100x100-pixel image, while maintaining the aspect ratio of the source image
					ImageScaleToFit(vOriginalImage,130,"");
                    
                    // Save Thumb Image / eliminate problems with url friendly encoding when getting our images re-replace %20 with no-space
                    imageWrite(vOriginalImage, "#APPLICATION.CFC.SESSION.getHostSession().PATH.albumThumbs#/#REReplace(vCompleteFileName,'%20','','ALL')#", "true");
                </cfscript>

				<!--- Insert the document into the database --->
                <cfquery 
                    datasource="#APPLICATION.DSN.Source#"
                    result="newRecord">
                        INSERT INTO 
                            document
                        (
                            foreignTable,
                            foreignID,
                            documentTypeID,
                            serverExt,
                            serverName,
                            clientExt,
                            clientName,
                            fileSize,
                            location,
                            dateCreated
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#" />,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(ARGUMENTS.foreignID)#" />,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.documentTypeID#" />,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#vNewFileExtension#" />,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#vNewFileName#" />,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(CFFILE.ClientFileExt)#" />,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFFILE.ClientFileName#" />,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.displayFileSize(CFFILE.FileSize)#" />,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.SESSION.getHostSession().PATH.albumLarge#" />,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                        )
                </cfquery>
                
                <!--- Insert hashID based on the document ID --->
                <cfquery 
                    datasource="#APPLICATION.DSN.Source#">
                        UPDATE
                            document
                        SET
                            hashID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#generateHashID(newRecord.GENERATED_KEY)#">
                        WHERE
                            ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#newRecord.GENERATED_KEY#">
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
			fileDelete(APPLICATION.PATH.TEMP & FILE.serverfile);
		</cfscript>
        
        <!--- Return Structure --->
        <cfreturn stResult>
        
    </cffunction>
    
    
</cfcomponent>