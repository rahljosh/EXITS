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
		<cfargument name="ignoreIDs" default="" hint="list of ID's to ignore">

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
                	documenttype
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
				
				<cfif LEN(ARGUMENTS.ignoreIDs)>
					AND
						ID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ignoreIDs#" list="yes">)
				</cfif>
                                      
        </cfquery> 

		<cfreturn qGetDocumentType>
	</cffunction>


    <!--- Function to get a document list --->
	<cffunction name="getDocuments" access="public" returntype="query" output="false" hint="Returns a list of documents">
        <cfargument name="ID" default="" hint="ID is required">
		<cfargument name="foreignTable" type="string" default="" />
		<cfargument name="foreignID" required="no" default="" />
        <cfargument name="foreignIDList" default="" hint="List of foreign IDs">
		<cfargument name="documentGroup" default="" hint="documentGroup is not required">   
        <cfargument name="documentTypeID" default="" hint="documentTypeID is not required">
        <cfargument name="seasonID" default="" hint="seasonID is not required">
        
        <cfquery 
			name="qGetDocuments" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					d.ID,
                    d.hashID,
                    d.foreignTable,
                    d.foreignID,
                    d.documentTypeID,
                    d.seasonID,
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
                    dt.ID AS documenttypeID,
                    dt.name AS documentType,
                    s.season
                FROM 
                    document d
				LEFT OUTER JOIN                      
                	documenttype dt ON dt.ID = d.documentTypeID
				LEFT OUTER JOIN
                	smg_seasons s ON s.seasonID = d.seasonID
                WHERE 
                	d.isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">

                <cfif LEN(ARGUMENTS.ID)>
                    AND    
                        d.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
				</cfif>
                
                <cfif LEN(ARGUMENTS.foreignTable)>
                AND    
                    d.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">
				</cfif>
                
                <cfif LEN(ARGUMENTS.foreignIDList)>
                    AND    
                        d.foreignID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.foreignIDList#" list="yes"> )
                <cfelseif LEN(ARGUMENTS.foreignID)>
                    AND
                        d.foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.foreignID)#">  
				</cfif>                
                    
				<cfif LEN(ARGUMENTS.documentGroup)>
	                AND 
                        dt.documentGroup = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.documentGroup#">
                </cfif>  
                
  				<cfif LEN(ARGUMENTS.documentTypeID)>
	                AND 
                        d.documentTypeID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(ARGUMENTS.documentTypeID)#">
                </cfif>  
                
  				<cfif LEN(ARGUMENTS.seasonID)>
	                AND 
                        d.seasonID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(ARGUMENTS.seasonID)#">
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

        <!----<cftry>
        
			<!--- Delete File | Document or Large Image | 
            <cffile action="delete" file="#qGetDoc.filePath#">            
			
            <cfif ARGUMENTS.documentGroup EQ 'familyAlbum'>
            
                <!--- Delete Thumb Image --->
                <cffile action="delete" file="#APPLICATION.CFC.SESSION.getHostSession().PATH.albumThumbs##qGetDoc.filename#"> 
            
            </cfif>
                    
            <cfcatch type="any">
				<!--- Error --->            
            </cfcatch>
        --->
        </cftry>---->
           
	</cffunction>
    
    
    <!---  Insert the document into the database --->
	<cffunction name="insertDocument" access="public" returntype="void" hint="Inserts a document">
		<cfargument name="foreignTable" default="" hint="foreignTable is not required">
		<cfargument name="foreignID" default="0" hint="foreignID is not required">
		<cfargument name="documentTypeID" default="0" hint="documentTypeID is not required">
        <cfargument name="seasonID" default="0" hint="seasonID is not required">
		<cfargument name="serverExt" default="" hint="serverExt is not required">
		<cfargument name="serverName" default="" hint="serverName is not required">
		<cfargument name="clientExt" default="" hint="clientExt is not required">
		<cfargument name="clientName" default="" hint="clientName is not required">
		<cfargument name="fileSize" default="" hint="fileSize is not required">
        <cfargument name="fileLocation" default="" hint="location is not required">

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
                    seasonID,
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
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.foreignID)#" />,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.documentTypeID)#" />,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.serverExt#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.serverName#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.clientExt#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.clientName#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.fileSize#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.fileLocation#" />,
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
			while ( fileExists(APPLICATION.CFC.SESSION.getHostSession().PATH.albumLarge & vNewFileName & "." & vNewFileExtension) ) { 
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
					
					// Insert Document Record
					insertDocument(
						foreignTable = ARGUMENTS.foreignTable,	   
						foreignID = ARGUMENTS.foreignID,	   
						documentTypeID = ARGUMENTS.documentTypeID,
						seasonID = APPLICATION.CFC.SESSION.getHostSession().seasonID,
						serverExt = vNewFileExtension,
						serverName = vNewFileName,
						clientExt = LCase(CFFILE.ClientFileExt),
						clientName = CFFILE.ClientFileName,
						fileSize = APPLICATION.CFC.UDF.displayFileSize(CFFILE.FileSize),
						fileLocation = APPLICATION.CFC.SESSION.getHostSession().PATH.albumLarge
					);
						
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
    

	<!--- Creates CBC Authorization PDF Document --->
	<cffunction name="generateCBCAuthorization" access="public" returntype="struct" output="no" hint="Creates PDF files and return status message">
		<cfargument name="foreignTable" type="string" default="" />
		<cfargument name="foreignID" type="numeric" required="no" default="" />
        <cfargument name="documentTypeID" type="numeric" required="yes" />
        <cfargument name="signature" default="" hint="signature is not required" />
		<cfargument name="address" default="" hint="Address is not required" />
        <cfargument name="address2" default="" hint="address2 is not required" />
        <cfargument name="city" default="" hint="city is not required" />
        <cfargument name="state" default="" hint="state is not required" />
        <cfargument name="zip" default="" hint="zip is not required" />
		
        <cfscript>
			// Set Result Message
			var stResult = StructNew();
			stResult.isSuccess = true;
			stResult.message = "";
			
			// Remove Blank Spaces From File Name
			vFileName = ReplaceNoCase(ARGUMENTS.signature, " ", "-", "All") & "-season" & APPLICATION.CFC.SESSION.getHostSession().seasonID & "-cbcAuthorization";
			// File Extension
			vFileExtension = "pdf";
		</cfscript>
        
        <cftry>
        
			<cfscript>
                // Set desired file name (keep extension consistent as jpg)
                var vNewFileName = vFileName;
                
                // Used to try different file names kitchen.jpg / kitchen1.jpg etc.
                var vFileCount = 0;
    
                // Check if default name is available
                while ( fileExists(APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS & vNewFileName & "." & vFileExtension) ) { 
                    vFileCount ++;
                    if ( VAL(vFileCount) ) {
                        vNewFileName = vFileName & vFileCount;
                    } else {
                        vNewFileName = vFileName;
                    }
                }	
                
                // Complete File Name
                vCompleteFileName = vNewFileName & "." & vFileExtension;
            </cfscript>
            
            <!--- Create PDF --->
            <cfdocument format="PDF" filename="#APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS##vCompleteFileName#" overwrite="no">
                <cfoutput>
                    <img src="#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='profileHeaderImage')#" border="0" />
                    
                    <!--- ESI wanted a different opening paragraph --->
                    <cfif SESSION.COMPANY.ID EQ 14>
                        <p>
                            As mandated, a Criminal Background Check on all Office Staff, Regional Directors/Managers, Regional Advisors, 
                            Area Representatives and all members of the host family aged 18 and above is required for involvement with the program.
                        </p>
                    <cfelse>
                        <p>
                            As mandated by the Department of State, a Criminal Background Check on all Office Staff, Regional Directors/
                            Managers, Regional Advisors, Area Representatives and all members of the host family aged 18 and above is 
                            required for involvement with the J-1 Secondary School Exchange Visitor Program.
                        </p>
                  	</cfif>
                    
                    <p>
                        I do hereby authorize verification of all information in my application for involvement with the Exchange Program from all necessary sources and additionally 
                        authorize any duly recognized agent of General Information Services, Inc. to obtain the said records and any such disclosures.
                    </p>
                    
                    <p>
                        Information appearing on this Authorization will be used exclusively by General Information Services, Inc. for identification
                        purposes and for the release of information that will be considered in determining any suitability for participation in the Exchange Program.
                    </p>
                    
                    <p>
                        Upon proper identification and via a request submitted directly to General Information Services, Inc., I have the right to
                        request from General Information Services, Inc. information about the nature and substance of all records on file about me
                        at the time of my request. This may include the type of information requested as well as those who requested reports from
                        General Information Services, Inc. within the two-year period preceding my request.  <br />
                    </p>
                    
                    <table>
                        <tr>
                            <td><u>Current Address</u></td>
                        </tr>
                        <tr>    
                            <td>
                                <strong>
                                    #ARGUMENTS.address#<br />
                                    <cfif LEN(ARGUMENTS.address2)>#ARGUMENTS.address2#<br /></cfif>
                                    #ARGUMENTS.city# #ARGUMENTS.state#, #ARGUMENTS.zip#
                                </strong>
                            </td>
                        </tr>
                    </table>   
                
                    <br /><br />

                    <hr width="70%" align="center" />
                    
                    <br /><br />
                
                    <u>Electronically Signed</u><br />
                    #ARGUMENTS.signature#<br />
                    <em>This form has already been electronically signed and submitted.  This copy is for your records only.</em> <br />
                    #DateFormat(now(), 'mmm d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')#<br />
                    IP: #CGI.REMOTE_ADDR# <br /><br />
                </cfoutput>
            </cfdocument>
            
            <cfscript>
                // Get File Information
                stGetFileInfo = GetFileInfo(APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS & vNewFileName & "." & vFileExtension);
            
                // Insert Document Record
                insertDocument(
                    foreignTable = ARGUMENTS.foreignTable,	   
                    foreignID = ARGUMENTS.foreignID,	   
                    documentTypeID = ARGUMENTS.documentTypeID,	
					seasonID = APPLICATION.CFC.SESSION.getHostSession().seasonID,
                    serverExt = vFileExtension,
                    serverName = vNewFileName,
                    clientExt = vFileExtension,
                    clientName = vNewFileName,
                    fileSize = APPLICATION.CFC.UDF.displayFileSize(stGetFileInfo.size),
                    fileLocation = APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS
                );
            </cfscript>

            <cfcatch type="any">
            
				<cfscript>
                    // Error - Could not generate CBC
                    stResult.isSuccess = false;
                    stResult.message = "There was a problem generating the CBC authorization, please try again. If problem persists, please contact support.";
                </cfscript>
                            
            </cfcatch>
        
        </cftry>
        
        <cfreturn stResult>        
	</cffunction>
    
    
    <!--- Creates W-9 Signature PDF Document --->
	<cffunction name="generateW9Signature" access="public" returntype="struct" output="no" hint="Creates PDF files and return status message">
		<cfargument name="foreignTable" type="string" default="" />
		<cfargument name="foreignID" type="numeric" required="no" default="" />
        <cfargument name="documentTypeID" type="numeric" required="yes" />
        <cfargument name="signature" default="" hint="signature is not required" />
		<cfargument name="address" default="" hint="Address is not required" />
        <cfargument name="address2" default="" hint="address2 is not required" />
        <cfargument name="city" default="" hint="city is not required" />
        <cfargument name="state" default="" hint="state is not required" />
        <cfargument name="zip" default="" hint="zip is not required" />
		
        <cfscript>
			// Set Result Message
			var stResult = StructNew();
			stResult.isSuccess = true;
			stResult.message = "";
			
			// Remove Blank Spaces From File Name
			vFileName = ReplaceNoCase(ARGUMENTS.signature, " ", "-", "All") & "-season" & APPLICATION.CFC.SESSION.getHostSession().seasonID & "-w9Signature";
			// File Extension
			vFileExtension = "pdf";
		</cfscript>
        
        <cftry>
        
			<cfscript>
                // Set desired file name (keep extension consistent as jpg)
                var vNewFileName = vFileName;
                
                // Used to try different file names kitchen.jpg / kitchen1.jpg etc.
                var vFileCount = 0;
    
                // Check if default name is available
                while ( fileExists(APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS & vNewFileName & "." & vFileExtension) ) { 
                    vFileCount ++;
                    if ( VAL(vFileCount) ) {
                        vNewFileName = vFileName & vFileCount;
                    } else {
                        vNewFileName = vFileName;
                    }
                }	
                
                // Complete File Name
                vCompleteFileName = vNewFileName & "." & vFileExtension;
            </cfscript>
            
            <!--- Create PDF --->
            <cfdocument format="PDF" filename="#APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS##vCompleteFileName#" overwrite="no">
                <cfoutput>
                    <img src="#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='profileHeaderImage')#" border="0" />
                    
                    <p>
                        Under penalties of perjury, I certify that:
                        <br/>
                        1. The number shown on this form is my correct taxpayer identification number (or I am waiting for a number to be issued to me), and
                        <br/>
                        2. I am not subject to backup withholding because: (a) I am exempt from backup withholding, or (b) I have not been notified by the Internal 
                        Revenue Service (IRS) that I am subject to backup withholding as a result of a failure to report all interest or dividends, or (c) the 
                        IRS has notified me that I am no longer subject to backup withholding, and
                        <br/>
                        3. I am a U.S. citizen or other U.S. person (defined below), and
                        <br/>
                        4. The FATCA code(s) entered on this form (if any) indicating that I am exempt from FATCA reporting is correct.
                        <br/>
                        <b>Certification instructions.</b> You must cross out item 2 above if you have been notified by the IRS that you are currently subject to backup 
                        withholding because you have failed to report all interest and dividends on your tax return. For real estate transactions, item 2 does not apply. 
                        For mortgage interest paid, acquisition or abandonment of secured property, cancellation of debt, contributions to an individual retirement arrangement 
                        (IRA), and generally, payments other than interest and dividends, you are not required to sign the certification, but you must provide your correct TIN. 
                        See the Instructions on page 3.
                    </p>
                    
                    <table>
                        <tr>
                            <td><u>Current Address</u></td>
                        </tr>
                        <tr>    
                            <td>
                                <strong>
                                    #ARGUMENTS.address#<br />
                                    <cfif LEN(ARGUMENTS.address2)>#ARGUMENTS.address2#<br /></cfif>
                                    #ARGUMENTS.city# #ARGUMENTS.state#, #ARGUMENTS.zip#
                                </strong>
                            </td>
                        </tr>
                    </table>   
                
                    <br /><br />

                    <hr width="70%" align="center" />
                    
                    <br /><br />
                
                    <u>Electronically Signed</u><br />
                    #ARGUMENTS.signature#<br />
                    <em>This form has already been electronically signed and submitted.  This copy is for your records only.</em> <br />
                    #DateFormat(now(), 'mmm d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')#<br />
                    IP: #CGI.REMOTE_ADDR# <br /><br />
                </cfoutput>
            </cfdocument>
            
            <cfscript>
                // Get File Information
                stGetFileInfo = GetFileInfo(APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS & vNewFileName & "." & vFileExtension);
            
                // Insert Document Record
                insertDocument(
                    foreignTable = ARGUMENTS.foreignTable,	   
                    foreignID = ARGUMENTS.foreignID,	   
                    documentTypeID = ARGUMENTS.documentTypeID,	
					seasonID = APPLICATION.CFC.SESSION.getHostSession().seasonID,
                    serverExt = vFileExtension,
                    serverName = vNewFileName,
                    clientExt = vFileExtension,
                    clientName = vNewFileName,
                    fileSize = APPLICATION.CFC.UDF.displayFileSize(stGetFileInfo.size),
                    fileLocation = APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS
                );
            </cfscript>

            <cfcatch type="any">
            
				<cfscript>
                    // Error - Could not generate CBC
                    stResult.isSuccess = false;
                    stResult.message = "There was a problem generating the CBC authorization, please try again. If problem persists, please contact support.";
                </cfscript>
                            
            </cfcatch>
        
        </cftry>
        
        <cfreturn stResult>        
	</cffunction>
    
    
	<!--- Creaates CBC Authorization PDF Document --->
	<cffunction name="generateDisclaimer" access="public" returntype="struct" output="no" hint="Creates PDF files and return status message">
		<cfargument name="foreignTable" type="string" default="" />
		<cfargument name="foreignID" type="numeric" required="no" default="" />
        <cfargument name="documentTypeID" type="numeric" required="yes" />
        <cfargument name="signature" default="" hint="signature is not required" />
		
        <cfscript>
			// Set Result Message
			var stResult = StructNew();
			stResult.isSuccess = true;
			stResult.message = "";
			
			// Remove Blank Spaces From File Name
			vFileName = ReplaceNoCase(ARGUMENTS.signature, " ", "-", "All") & "-season" & APPLICATION.CFC.SESSION.getHostSession().seasonID & "-disclaimer";
			// File Extension
			vFileExtension = "pdf";
		</cfscript>
        
        <cftry>
        
			<cfscript>
                // Set desired file name (keep extension consistent as jpg)
                var vNewFileName = vFileName;
                
                // Used to try different file names kitchen.jpg / kitchen1.jpg etc.
                var vFileCount = 0;
    
                // Check if default name is available
                while ( fileExists(APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS & vNewFileName & "." & vFileExtension) ) { 
                    vFileCount ++;
                    if ( VAL(vFileCount) ) {
                        vNewFileName = vFileName & vFileCount;
                    } else {
                        vNewFileName = vFileName;
                    }
                }	
                
                // Complete File Name
                vCompleteFileName = vNewFileName & "." & vFileExtension;
            </cfscript>
            
            <!--- Create PDF --->
            <cfdocument format="PDF" filename="#APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS##vCompleteFileName#" overwrite="no">
                <cfoutput>
                    <img src="#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='profileHeaderImage')#" border="0" />
                    
                    <h2>Terms for Submission</h2>
                    
                    <p>
                        Applicants and their families certify that all information submitted in the Host Family Application - including the application, 
                        the Host Family Letter, any supplements, and any other supporting materials - is honestly presented and accurate; these documents 
                        will become the property of the exchange organization and will not be returned.         
                    </p>        
                    
                    <p>
                        Applicants and their families understand that the signature below constitutes a willingness of all members of the household to host an Exchange Student 
                        through the exchange organization and comply with the exchange organization and the Department of State Regulations. 
                        Applicants also agree, as per Department of State mandate, to notify the exchange organization if the composition of their household changes and if additional 
                        criminal background checks need to be conducted.
                    </p>
                    
                    <p>
                        Applicants and their families understand and acknowledge that by signing this application the exchange organization maintains jurisdiction over all aspects 
                        of the student exchange program.  In the event of any problem between the student and the American host family, the exchange organization reserves the right to 
                        remove the student at any time to resolve the situation.
                    </p>        
        			
                    <br /><br />

                    <hr width="70%" align="center" />
                    
                    <br /><br />
                
                    <u>Electronically Signed</u><br />
                    #ARGUMENTS.signature#<br />
                    <em>This form has already been electronically signed and submitted.  This copy is for your records only.</em> <br />
                    #DateFormat(now(), 'mmm d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')#<br />
                    IP: #CGI.REMOTE_ADDR# <br /><br />
                </cfoutput>
            </cfdocument>
            
            <cfscript>
                // Get File Information
                stGetFileInfo = GetFileInfo(APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS & vNewFileName & "." & vFileExtension);
            
                // Insert Document Record
                insertDocument(
                    foreignTable = ARGUMENTS.foreignTable,	   
                    foreignID = ARGUMENTS.foreignID,	   
                    documentTypeID = ARGUMENTS.documentTypeID,	
					seasonID = APPLICATION.CFC.SESSION.getHostSession().seasonID,
                    serverExt = vFileExtension,
                    serverName = vNewFileName,
                    clientExt = vFileExtension,
                    clientName = vNewFileName,
                    fileSize = APPLICATION.CFC.UDF.displayFileSize(stGetFileInfo.size),
                    fileLocation = APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS
                );
            </cfscript>

            <cfcatch type="any">
            
				<cfscript>
                    // Error - Could not generate CBC
                    stResult.isSuccess = false;
                    stResult.message = "There was a problem generating the disclaimer, please try again. If problem persists, please contact support.";
                </cfscript>
                            
            </cfcatch>
        
        </cftry>
        
        <cfreturn stResult>        
	</cffunction>

        
</cfcomponent>