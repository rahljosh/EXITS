<!--- ------------------------------------------------------------------------- ----
	
	File:		pdfDoc.cfc
	Author:		Marcus Melo
	Date:		January, 16 2010
	Desc:		This holds the functions needed for the pdf docs section

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="pdfDoc"
	output="false" 
	hint="A collection of functions for the company">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="pdfDoc" output="false" hint="Returns the initialized pdfDoc object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	
	<cffunction name="getPDFCategories" access="public" returntype="query" output="false" hint="Gets a list of PDF categories">
    	<cfargument name="categoryID" default="0" hint="categoryID is not required">
        <cfargument name="userTypeID" default="0" hint="userTypeID is not required">
              
        <cfquery 
			name="qGetPDFCategories" 
			datasource="#APPLICATION.dsn#">
                SELECT
					id,
                    userType_ID,
                    name,
                    folder_name,
                    is_active,
                    sort_by,
                    date_created,
                    date_updated

                FROM 
                    smg_pdf_categories
                WHERE
                	1 = 1
                    
				<cfif VAL(ARGUMENTS.categoryID)>
                	AND	
                    	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.categoryID#">
                </cfif>

				<cfif VAL(ARGUMENTS.userTypeID) GT 4>
                	AND	
                    	userType_ID >= <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userTypeID#">
                            
                </cfif>
                AND 
                	 companyAccess like "%#client.companyID#%"
                ORDER BY 
                    sort_by                
		</cfquery>
		   
		<cfreturn qGetPDFCategories>
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
					mode="777"
                	/>
            
            </cfif>
		
            <cfcatch type="any">
            	<!--- Error Handler --->
				
            </cfcatch>
               
        </cftry>
        
	</cffunction>


	<!--- Upload PDF Document --->
	<cffunction name="uploadPDFDocument" access="public" returntype="struct" output="no" hint="Uploads a PDF Document and returns a string.">
		<cfargument name="categoryID" type="numeric" required="yes" hint="CategoryID is required" />
        <cfargument name="fileName" type="string" required="yes" hint="File Name is required" />

			<cfscript>
				// Set Response Struct
				response.success = 1;
				response.message = 'File Uploaded Successfully';

				// Get Folder Name
				folderName = getPDFCategories(categoryID=ARGUMENTS.categoryID).folder_name;
				
				// Get Company Short Name
				shortName = APPLICATION.CFC.COMPANY.getCompanies(companyID=CLIENT.companyID).companyShort_nocolor;
				
				// Set Folder Path
				setFolderPath = "#APPLICATION.PATH.pdfDocs#/#shortName#/#folderName#";
				
				// Check if folder exits
				createFolder(fullPath=setFolderPath);
			</cfscript>
			
            <cftry>
            
				<!--- Upload File /  filefield -> Do not use ## or Scope.  --->
                <cffile action="UPLOAD" 
                    attributes="normal" 
                    filefield="fileName"
                    destination="#setFolderPath#"
                    nameconflict="MAKEUNIQUE" 
                    mode="777"
                    />
                
				<cfcatch type="any">
					<!--- Error Handler --->
                                        
                	<cfscript>
						response.success = 0;
						response.message = 'An error has occured and the file could not be uploaded';
					</cfscript>
                    
                </cfcatch>
                
			</cftry>                

		<cfreturn response>
            
	</cffunction>


	<!--- Delete PDF Document --->
	<cffunction name="deletePDFDocument" access="public" returntype="struct" output="no" hint="Uploads a PDF Document and returns a string.">
		<cfargument name="folderPath" type="string" required="yes" hint="folderPath is required" />
        <cfargument name="fileName" type="string" required="yes" hint="File Name is required" />

			<cfscript>
				// Set Response Struct
				response.success = 1;
				response.message = 'File Deleted Successfully';
			</cfscript>

            <cftry>
            
				<!--- Delete PDF --->
                <cffile 
                	action="DELETE" 
                    file = "#ARGUMENTS.folderPath#/#ARGUMENTS.fileName#">
               
				<cfcatch type="any">
					<!--- Error Handler --->
                                        
                	<cfscript>
						response.success = 0;
						response.message = 'An error has occured and the file could not be deleted';
					</cfscript>
                    
                </cfcatch>
                
			</cftry>                

		<cfreturn response>
            
	</cffunction>


</cfcomponent>