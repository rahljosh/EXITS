<!--- ------------------------------------------------------------------------- ----
	
	File:		metadata.cfc
	Author:		Marcus Melo
	Date:		October 10, 2010
	Desc:		This holds the functions needed for the metadata system

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="metadata"
	output="false" 
	hint="A collection of functions for the Metadata module">

	
	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="metadata" output="false" hint="Returns the initialized content object">
		
		<cfscript>
			// Return this initialized instance
			return(this);
		</cfscript>
        
	</cffunction>


	<cffunction name="getMetadataBySite" access="public" returntype="query" output="false" hint="Get metadata used on site pages">
        <cfargument name="site" type="string" default="trips.exitsapplication.com" />
		
		<cfquery 
			name="qGetMetadataBySite" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					ID, 
                    site,
                    URL,
                    pageTitle,
                    pageDescription,
                    pageKeywords, 
                    dateCreated, 
                    dateUpdated
				FROM
					metadata					
				WHERE
                    site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.site)#">
		</cfquery>

		<cfreturn qGetMetadataBySite />
	</cffunction>


	<cffunction name="getMetadataByURL" access="public" returntype="query" output="false" hint="Get metadata used on site pages">
        <cfargument name="URL" type="string" default="" />

		<cfscript>
			try {
				 // Check if we have a query in the application scope, if not store the query.
				getQuery = APPLICATION.QUERY.qMetadata;
			} catch (Any e) {
				// Set Query
				APPLICATION.QUERY.qMetadata = getMetadataBySite();
			}
		</cfscript>

		<cfquery  
			name="qGetMetadataByURL" 
			dbtype="query">
				SELECT
					*
				FROM
					APPLICATION.QUERY.qMetadata
				WHERE
	                URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(LCase(ARGUMENTS.URL))#">
		</cfquery>
		
		<cfreturn qGetMetadataByURL />
	</cffunction>
    

	<cffunction name="getPageMetadata" access="public" returntype="query" output="false" hint="Get metadata used on pages based on URL">
        <cfargument name="URL" type="string" required="yes" />
		
        <cfscript>
			var defaultURL = '/index.cfm';
		
			// Get Metadata for current page
			qGetMetadata = getMetadataByURL(URL=ARGUMENTS.URL);
			
			// Check if we have metadata for this page
			if ( NOT qGetMetadata.recordCount ) {
				// Get Default Metadata
				qGetMetadata = getMetadataByURL(URL=defaultURL);
			} 
			
			// Return Query
			return qGetMetadata;
		</cfscript>
        
	</cffunction>
    
</cfcomponent>