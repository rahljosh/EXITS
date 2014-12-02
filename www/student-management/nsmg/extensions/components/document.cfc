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
	        datasource="#APPLICATION.DSN#">
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
        	datasource="#APPLICATION.DSN#">
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
        <cfargument name="documentTypeIDList" default="" hint="documentTypeIDList is not required">
        <cfargument name="seasonID" default="" hint="seasonID is not required">
        
        <cfquery 
			name="qGetDocuments" 
			datasource="#APPLICATION.DSN#">
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
                    d.uploadedBy,
                    CONCAT(serverName, '.', serverExt) AS fileName,
                    CONCAT(location, serverName, '.', serverExt) AS filePath,
                    dt.ID AS documentTypeID,
                    dt.name AS documentType,
                    s.season,
                    u.firstname,
                    u.lastname
                    
                FROM 
                    document d
				LEFT OUTER JOIN                      
                	documenttype dt ON dt.ID = d.documentTypeID
				LEFT OUTER JOIN
                	smg_seasons s ON s.seasonID = d.seasonID
                LEFT OUTER JOIN
                	smg_users u on u.userid = d.uploadedBy
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

                <cfif LEN(ARGUMENTS.documentTypeIDList)>
                    AND    
                        d.documentTypeID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.documentTypeIDList#" list="yes"> )
  				<cfelseif LEN(ARGUMENTS.documentTypeID)>
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
		<cfargument name="foreignID" type="numeric" required="no" default="0" />
        <cfargument name="description" type="string" default="" />

        <cfquery 
			datasource="#APPLICATION.DSN#">
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
			datasource="#APPLICATION.DSN#">
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
			
            <cfcatch type="any">
				<!--- Error --->            
            </cfcatch>
        
        </cftry>
           
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
        <cfargument name="description" type="string" required="no" default="" />

		<!--- Insert the document into the database --->
        <cfquery 
            datasource="#APPLICATION.DSN#"
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
                    description,
                    dateCreated,
                    uploadedBy
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
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.description#" />,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.userid#" />
                )
        </cfquery>

        <!--- Insert hashID based on the document ID --->
        <cfquery 
            datasource="#APPLICATION.DSN#">
                UPDATE
                    document
                SET
                    hashID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#generateHashID(newRecord.GENERATED_KEY)#">
                WHERE
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#newRecord.GENERATED_KEY#">
        </cfquery>
                
	</cffunction>                


    <!--- Upload File --->
    <cffunction name="uploadFile" hint="Upload file" returntype="struct">
		<cfargument name="foreignTable" type="string" default="smg_hosts" />
		<cfargument name="foreignID" type="numeric" required="no" default="0" />
		<cfargument name="documentTypeID" type="numeric" required="yes" />
		<cfargument name="uploadPath" type="string" required="yes" />
        <cfargument name="description" type="string" required="no" default="" />
        <cfargument name="allowedExt" type="string" required="no" default="" />
		<cfargument name="blockedExt" type="string" required="no" default="" />
        <cfargument name="seasonID" required="no" default="" />
        
        <cfscript>
			// Set Result Message
			var stResult = StructNew();
			stResult.isSuccess = true;
			stResult.message = "";
		
			// List of Accepted Files
			var vAcceptedFilesList = ARGUMENTS.allowedExt;
			
			var vSeason = 0;
			if (LEN(ARGUMENTS.seasonID)) {
				vSeason = ARGUMENTS.seasonID;
			} else {
				vSeason = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID;
			}
			
			// Use documentGroup field to rename the files (eg familyAlbum/schoolAcceptance, etc)
			var vNewFileName = "season" & vSeason & "-" & getDocumentType(ID=ARGUMENTS.documentTypeID).documentGroup;
			
			// Make sure folder exists
			createFolder(ARGUMENTS.uploadPath);
		</cfscript>
        
		<!--- Upload the file to temp folder --->
		<cffile 
        	action="upload" 
            filefield="FORM.fileData" 
            destination="#APPLICATION.PATH.TEMP#" 
            nameconflict="makeunique">

        <!--- Check if we have a valid file || isImageFile(); isImage(); --->
        <cfif ListFindNoCase(vAcceptedFilesList,FILE.ServerFileExt)>
				
			<!--- Try to move file to new folder --->
            <cftry>
            
                <cfscript>
					// Used to try different file names kitchen.jpg / kitchen1.jpg etc.
					var vFileCount = 0;
		
					// Check if default name is available
					while ( fileExists(ARGUMENTS.uploadPath & vNewFileName & "." & FILE.ServerFileExt) ) { 
						vFileCount ++;
						if ( VAL(vFileCount) ) {
							vNewFileName = vNewFileName & vFileCount;
						} else {
							vNewFileName = vNewFileName;
						}
					}	
					
					// Set Complete File Name
					vCompleteFileName = vNewFileName & "." & FILE.ServerFileExt;
				</cfscript>
                
                <!--- Rename/Move File --->
                <cffile 
                	action="rename" 
                    source="#FILE.ServerDirectory#\#FILE.ServerFile#" 
                    destination="#ARGUMENTS.uploadPath##REReplace(vCompleteFileName,'%20','','ALL')#" 
                    attributes="normal">                 
                                                    
				<cfscript>   
					// Insert Document Record
					insertDocument(
						foreignTable = ARGUMENTS.foreignTable,	   
						foreignID = ARGUMENTS.foreignID,	   
						documentTypeID = ARGUMENTS.documentTypeID,
						seasonID = vSeason,
						serverExt = FILE.ServerFileExt,
						serverName = vNewFileName,
						clientExt = LCase(FILE.ClientFileExt),
						clientName = FILE.ClientFileName,
						fileSize = APPLICATION.CFC.UDF.displayFileSize(FILE.FileSize),
						fileLocation = ARGUMENTS.uploadPath,
						description = ARGUMENTS.description
					);
						
                    // Set Page Message
                    stResult.message = "File has been uploaded";
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
				
				try {
					// Try to Delete Original File
					fileDelete(APPLICATION.PATH.TEMP & FILE.serverfile);
				} catch( any error ) {					
					// file could not be found				
				}
			</cfscript>
        
        </cfif>
                
        <!--- Return Structure --->
        <cfreturn stResult>
        
    </cffunction>
       
               
</cfcomponent>