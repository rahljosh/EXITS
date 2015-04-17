<!--- ------------------------------------------------------------------------- ----
	
	File:		content.cfc
	Author:		Marcus Melo
	Date:		August 06, 2010
	Desc:		This holds the functions for the content

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="content"
	output="false" 
	hint="A collection of functions for lookup tables">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="content" output="false" hint="Returns the initialized content object">
		
		<cfscript>
			// Return this initialized instance
			return(this);
		</cfscript>
        
	</cffunction>


	<cffunction name="getContentByKey" access="public" returntype="query" output="false" hint="Returns a content">
    	<cfargument name="contentKey" hint="Content Key is required">
        
        <cfquery 
        	name="qGetContentByKey"
        	datasource="#APPLICATION.DSN.Source#">
                SELECT 
                	ID,
                    applicationID,
                    contentKey,
                    name,
                    content,
                    dateCreated,
                    dateUpdated
				FROM
                	applicationcontent
                WHERE
                	contentKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.contentKey#">
        </cfquery> 
		       
		<cfreturn qGetContentByKey>
	</cffunction>


</cfcomponent>