<!--- ------------------------------------------------------------------------- ----
	
	File:		document.cfc
	Author:		Marcus Melo
	Date:		September 15, 2010
	Desc:		This holds functions for uploading and modifying the documents

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="document"
	output="false" 
	hint="This holds functions for uploading and modifying the documents">

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
	<cffunction name="HashID" access="public" returntype="string" output="no" hint="Hashes the given ID for security reasons. To be used for documents only.">
		<cfargument name="ID" type="numeric" required="yes" />
		
		<!--- Return hash --->
		<cfreturn (
			((ARGUMENTS.ID * 64) MOD 29) & 
			Chr(Right(ARGUMENTS.ID, 1) + 65) & 
			(ARGUMENTS.ID MOD 4)
			) />
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
        <cfargument name="applicationID" default="0" hint="Application ID is required to get the correct file options">

        <cfquery 
        	name="qGetDocumentType"
        	datasource="#APPLICATION.DSN.Source#">
                SELECT 
                	ID,
                    applicationID,
                    name,
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
                ORDER BY
                	name                        
        </cfquery> 

		<cfreturn qGetDocumentType>
	</cffunction>


	<cffunction name="getDocumentByID" access="public" returntype="query" output="false" hint="Returns a document">
        <cfargument name="ID" required="yes" hint="ID is required">

        <cfquery 
			name="qGetDocumentByID" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					ID,
                    hashID,
                    foreignTable,
                    foreignID,
                    documentTypeID,
                    serverName,
                    serverExt,
                    clientName,
                    clientExt,
                    fileSize,
                    location,
                    CONCAT(location, serverName, '.', serverExt) AS filePath,
                    isDeleted,
                    dateCreated,
                    dateUpdated
                FROM 
                    document
                WHERE
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">
		</cfquery>
		   
		<cfreturn qGetDocumentByID>
	</cffunction>


	<cffunction name="getDocumentsByFilter" access="public" returntype="query" output="false" hint="Returns a list of documents">
        <cfargument name="foreignTable" default="" hint="foreignTable is not required">
        <cfargument name="foreignID" default="" hint="foreignID is not required">
        <cfargument name="documentTypeID" default="" hint="documentTypeID is not required">
        <cfargument name="clientExt" default="" hint="clientExt is not required">
		<cfargument name="NotClientExt" default="" hint="Get extensions that are not this type">
        <cfargument name="orderBy" default="" hint="Get extensions that are not this type">
        
        <cfquery 
			name="qGetDocumentsByFilter" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					ID,
                    hashID,
                    foreignTable,
                    foreignID,
                    documentTypeID,
                    description,
                    serverName,
                    serverExt,
                    clientName,
                    clientExt,
                    fileSize,
                    location,
                    CONCAT(location, serverName, '.', serverExt) AS filePath,
                    <cfif ARGUMENTS.documentTypeID EQ 7>
                    	CONVERT(CONCAT('<a href="onlineApplication/publicDocument.cfm?ID=', ID, '&Key=', hashID, '" class="style4">[ Download Job Offer ]</a> &nbsp; ') USING latin1) AS downloadLink,
                    <cfelseif ARGUMENTS.documentTypeID EQ 9>
                    	CONVERT(CONCAT('<a href="onlineApplication/publicDocument.cfm?ID=', ID, '&Key=', hashID, '" class="style4">[ Download Resume ]</a> &nbsp; ') USING latin1) AS downloadLink,
                    <cfelseif ARGUMENTS.documentTypeID EQ 36>
                    	CONVERT(CONCAT('<a href="onlineApplication/publicDocument.cfm?ID=', ID, '&Key=', hashID, '" class="style4">[ Download DS-2019 ]</a> &nbsp; ') USING latin1) AS downloadLink,
                    <cfelse>
                    	CONVERT(CONCAT('<a href="onlineApplication/publicDocument.cfm?ID=', ID, '&Key=', hashID, '" class="style4">[ Download File ]</a> &nbsp; ') USING latin1) AS downloadLink,
                    </cfif>
                    isDeleted,
                    dateCreated,
                    dateUpdated
                FROM 
                    document
                WHERE
                    isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                <cfif LEN(ARGUMENTS.foreignTable)>
                	AND
                    	foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">
                </cfif>
                <cfif LEN(ARGUMENTS.foreignID)>
                	AND
                    	foreignID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignID#">
                </cfif>
                <cfif LEN(ARGUMENTS.documentTypeID)>
                	AND
                    	documentTypeID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.documentTypeID#">
                </cfif>
                <cfif LEN(ARGUMENTS.clientExt)>
                	AND
                    	clientExt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.clientExt#">
                </cfif>
                <cfif LEN(ARGUMENTS.NotClientExt)>
                	AND
                    	clientExt != <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.NotClientExt#">
                </cfif>
               
              	ORDER BY
                	<cfif LEN(ARGUMENTS.orderBy)>
                	#ARGUMENTS.orderBy#
                    <cfelse>
                    description
                    </cfif>
		</cfquery>
		   
		<cfreturn qGetDocumentsByFilter>
	</cffunction>
    
    
    <cffunction name="delete" access="public" returntype="void" output="no" hint="Sets a document to deleted status">
    	<cfargument name="documentID" required="yes">
        
        <cfquery datasource="#APPLICATION.DSN.Source#">
        	UPDATE document
            SET isDeleted = 1
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.documentID#">
        </cfquery>
    </cffunction>


	<!--- Uploads a document into the system --->
	<cffunction name="upload" access="public" returntype="void" output="no" hint="Uploads a document into the system and returns a document instance">
		<cfargument name="ForeignTable" type="string" required="no" default="" />
		<cfargument name="ForeignID" type="numeric" required="no" default="0" />
		<cfargument name="documentTypeID" type="numeric" required="no" default="0" />
		<cfargument name="uploadPath" type="string" required="yes" />
        <cfargument name="AllowedExt" type="string" required="no" default="" />
		<cfargument name="BlockedExt" type="string" required="no" default="" />
		
        <cfscript>
			// Declare Accept File Variable
			var acceptFile = 1;
			
			// Make sure folder exists
			createFolder(ARGUMENTS.uploadPath);
			
			/* 	
				Convert the extension lists to lowercase. Also, lets replace any spaces in 
				the list with commas, since people might not know hot to make a list. 
			*/
			ARGUMENTS.AllowedExt = ListAppend(Replace(LCase(ARGUMENTS.AllowedExt), " ", ",", "ALL"), VARIABLES.My.AllowedExt);
			ARGUMENTS.BlockedExt = ListAppend(Replace(LCase(ARGUMENTS.BlockedExt), " ", ",", "ALL"), VARIABLES.My.BlockedExt);
		</cfscript>
        
		<!--- Upload the document to the file directory --->
		<cffile 
        	action="upload" 
            filefield="fileData" 
            destination="#ARGUMENTS.uploadPath#" 
            nameconflict="makeunique">
			
		<cfscript>
			/*
				Check to see if we are dealing with the right kind of file by checking
				the list of allowed or blocked extensions. First, check to see if we
				have a list of allowed exts.
			*/
			if ( Len(ARGUMENTS.AllowedExt) AND (NOT ListFind(ARGUMENTS.AllowedExt, LCase(CFFILE.ServerFileExt))) ) {
				// This is not an allowed file
				acceptFile = 0;
			}
		
			// Check for blocked extensions
        	if ( ListFind(ListAppend(VARIABLES.My.BlockedExt, ARGUMENTS.BlockedExt), LCase(CFFILE.ServerFileExt)) ) {
				// This is a blocked file
				acceptFile = 0;
			}
        </cfscript>

		<!--- Check to see if we can upload the file --->
		<cfif VAL(acceptFile)>
        
			<!--- The file has been uploaded and accepted --->
            <cfscript>
				insertDocument(
					ForeignTable=ARGUMENTS.ForeignTable,
					ForeignID=ARGUMENTS.ForeignID,
					documentTypeID=ARGUMENTS.documentTypeID,
					serverExtension=LCase(CFFILE.ServerFileExt),
					serverName=CFFILE.ServerFileName,
					clientExtension=LCase(CFFILE.ClientFileExt),
					clientName=CFFILE.ClientFileName,
					filesize=APPLICATION.CFC.UDF.displayFileSize(CFFILE.FileSize),
					uploadPath=ARGUMENTS.uploadPath);
			</cfscript> 
                        
        <cfelse>
        	
			<!--- Delete File --->
            <cffile action="delete" file="#CFFILE.serverDirectory#/#CFFILE.ServerFile#">            
        
		</cfif>

	</cffunction>
    
    <cffunction name="insertDocument" access="public" returntype="void" output="no" hint="Inserts a new document">
    	<cfargument name="ForeignTable" type="string" required="no" default="" />
		<cfargument name="ForeignID" type="numeric" required="no" default="0" />
		<cfargument name="documentTypeID" type="numeric" required="no" default="0" />
		<cfargument name="serverExtension" type="any" required="yes" />
        <cfargument name="serverName" type="any" required="yes" />
        <cfargument name="clientExtension" type="any" required="yes" />
        <cfargument name="clientName" type="any" required="yes" />
        <cfargument name="filesize" type="any" required="yes" />
        <cfargument name="uploadPath" type="any" required="yes" />
		
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
                description,
                dateCreated       
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.foreignID#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.documentTypeID#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.serverExtension#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.serverName#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.clientExtension#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.clientName#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.filesize#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.uploadPath#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="" />,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            )
        </cfquery>
        
        <!--- Insert hashID based on the document ID --->
        <cfquery 
            datasource="#APPLICATION.DSN.Source#">
            UPDATE
                document
            SET
                hashID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hashID(newRecord.GENERATED_KEY)#">
            WHERE
                ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#newRecord.GENERATED_KEY#">
        </cfquery>
    </cffunction>


    <!--- Function to get a document list for a candidate --->
	<cffunction name="getDocuments" access="public" returntype="query" output="false" hint="Returns a list of documents">
    	<cfargument name="foreignTable" required="yes" hint="Foreign Table Name">
        <cfargument name="foreignID" required="yes" hint="Foreign ID">
        <cfargument name="documentType" required="no" default="">      

        <cfquery 
			name="qGetDocuments" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					d.ID,
                    CONCAT(d.serverName, '.', d.serverExt) AS fileName,
                    d.fileSize,
                    d.location,
                    d.dateCreated,
                    DATE_FORMAT(d.dateCreated, '%m/%d/%y') as displayDateCreated,
                    dt.name as documentType
                FROM 
                    document d
				LEFT OUTER JOIN                      
                	documenttype dt ON dt.ID = d.documentTypeID
				WHERE 
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                AND    
                    foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">
				AND
                	foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.foreignID#"> 
               	<cfif LEN(ARGUMENTS.documentType)>
                	AND
                    	dt.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.documentType#">
                </cfif>
                ORDER BY
                    d.dateCreated DESC     
		</cfquery>
		
		<cfreturn qGetDocuments />
	</cffunction>


    <!--- Gets a list of documents uploaded --->
	<cffunction name="getDailyDocumentReport" access="public" returntype="query" output="false" hint="Returns a list of uploaded documents in the last 24 hours">
    	<cfargument name="foreignTable" required="yes" hint="Foreign Table Name">

        <cfquery 
			name="qGetDailyDocumentReport" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					d.ID,
                    CONCAT(d.serverName, '.', d.serverExt) AS fileName,
                    d.fileSize,
                    d.location,
                    d.dateCreated,
                    DATE_FORMAT(d.dateCreated, '%m/%d/%y') as displayDateCreated,
                    CONVERT(CONCAT('<a href=''#APPLICATION.SITE.URL.main#internal/wat/onlineApplication/publicDocument.cfm?ID=', d.ID, '&Key=', d.hashID, '''>[ Download ]</a> ') USING latin1) AS action,
                    dt.name as documentType,
                    c.candidateID,
                    c.firstName,
                    c.lastName,
                    c.uniqueid,
                    u.businessName,
                    apsJN.dateCreated
                FROM 
                    document d
				LEFT OUTER JOIN                      
                	documenttype dt ON dt.ID = d.documentTypeID
                LEFT JOIN
                	applicationstatusjn apsJN on apsJN.foreignID = c.candidateid
                INNER JOIN
                	extra_candidates c ON c.candidateID = d.foreignID
						AND
                        	c.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                        AND
                        	c.applicationStatusID = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
                INNER JOIN
                	smg_users u ON u.userID = c.intRep
                WHERE 
                	d.isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                AND    
                    d.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">
                 AND 
        	apsJN.applicationStatusID = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
				AND
                   	d.dateUpdated >= DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL -25 HOUR)                     
                ORDER BY
                    c.candidateID,
                    d.dateCreated DESC     
		</cfquery>
		
		<cfreturn qGetDailyDocumentReport />
	</cffunction>

	
    <!--- Remote function to get a document list for a candidate --->
	<cffunction name="getDocumentsRemote" access="remote" returnFormat="json" output="false" hint="Returns a list of documents">
    	<cfargument name="foreignTable" required="yes" hint="Foreign Table Name">
        <cfargument name="foreignID" required="yes" hint="Foreign ID">        
		<cfargument name="page" required="yes">
		<cfargument name="pageSize" required="yes">
		<cfargument name="gridSortColumn" default="dateCreated" hint="By Default dataCreated">
		<cfargument name="gridSortDirection" default="DESC" hint="By Default DESC">
        <cfargument name="blockEditDelete" default="0" hint="Set to 1 to block editing and deleting">

        <cfquery 
			name="qGetDocumentsRemote" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					d.ID,
                    CONCAT(d.serverName, '.', d.serverExt) AS fileName,
                    d.fileSize,
                    d.location,
                    d.dateCreated,
                    DATE_FORMAT(d.dateCreated, '%m/%d/%y') as displayDateCreated,
                    dt.name as documentType,
                    <cfif VAL(ARGUMENTS.blockEditDelete)>
                    	CONVERT(CONCAT('<a href=''publicDocument.cfm?ID=', d.ID, '&Key=', d.hashID, '''>[View]</a> ', ' - <a href=''javascript:displayFile(', d.ID, ');''>[Edit]</a> ') USING latin1) AS action
                    <cfelse>
						CONVERT(CONCAT('<a href=''publicDocument.cfm?ID=', d.ID, '&Key=', d.hashID, '''>[View]</a> ', ' - <a href=''javascript:displayFile(', d.ID, ');''>[Edit]</a> ', ' - <a href=''javascript:deleteFile(', d.ID, ');''>[Delete]</a> ') USING latin1) AS action
               		</cfif>
                FROM 
                    document d
				LEFT OUTER JOIN                      
                	documenttype dt ON dt.ID = d.documentTypeID
				WHERE 
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                AND    
                    foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">
				AND
                	foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.foreignID#">  

				<cfif LEN(ARGUMENTS.gridsortcolumn)>
                    ORDER BY 
                        #ARGUMENTS.gridSortColumn# #ARGUMENTS.gridSortDirection#
                <cfelse>
                    ORDER BY
                        d.dateCreated DESC     
                </cfif>
		</cfquery>
		
		<cfreturn QueryconvertForGrid(qGetDocumentsRemote,page,pagesize)/>
	</cffunction>

	
    <!--- Remote function to get a document information by ID --->
	<cffunction name="getDocumentByIDRemote" access="remote" returnFormat="json" output="false" hint="Returns a document in Json format">
        <cfargument name="ID" required="yes" hint="ID is required">

        <cfquery 
			name="qGetDocumentByIDRemote" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					ID,
                    CONCAT(serverName, '.', serverExt) AS fileName,
                    documentTypeID
                FROM 
                    document
                WHERE
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">
		</cfquery>
		   
		<cfreturn qGetDocumentByIDRemote>
	</cffunction>


	<!--- Remote function to update documentTypeID --->
	<cffunction name="updateDocumentTypeIDRemote" access="remote" returntype="void" hint="Update category ID.">
        <cfargument name="ID" required="yes" hint="ID is required">
        <cfargument name="documentTypeID" required="yes" hint="documentTypeID is required">

        <cfquery 
			datasource="#APPLICATION.DSN.Source#">
                UPDATE
					document
				SET
                    documentTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.documentTypeID#">
                WHERE
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">
		</cfquery>
		   
	</cffunction>
    

	<!--- Remote function to delete a file --->
	<cffunction name="deleteDocumentRemote" access="remote" returntype="void" hint="Update category ID.">
        <cfargument name="ID" required="yes" hint="ID is required">
		
        <cfscript>
			// Get File Information
			qGetDoc = getDocumentByID(ARGUMENTS.ID);		
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
        
			<!--- Delete File --->
            <cffile action="delete" file="#APPLICATION.CFC.CANDIDATE.getCandidateSession().myUploadFolder#/#qGetDoc.serverName#.#qGetDoc.serverExt#">            
        
            <cfcatch type="any">
				<!--- Error --->            
            </cfcatch>
        
        </cftry>
           
	</cffunction>

</cfcomponent>
