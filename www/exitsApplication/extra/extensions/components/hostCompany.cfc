<!--- ------------------------------------------------------------------------- ----
	
	File:		hostCompany.cfc
	Author:		Marcel
	Date:		December 08, 2010
	Desc:		This holds the functions needed for the host company

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="hostCompany"
	output="false" 
	hint="A collection of functions for the host company">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="hostCompany" output="false" hint="Returns the initialized HostCompany object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	
	<cffunction name="getJobTitle" access="remote" returntype="query" hint="Gets a list of job titles for a given host company">
        <cfargument name="hostcompanyID" default="0">

        <cfquery name="qGetJobTitle" 
        	datasource="MySQL">
            SELECT
                ID,
                title
            FROM
                extra_jobs
            WHERE
            	1 = 1
            	<cfif Val(ARGUMENTS.hostcompanyID)>
                AND
                	hostcompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostcompanyID#">
                </cfif>
            ORDER BY
                title
        </cfquery>        
        
        <cfscript>
			qNewGetJobTitle = QueryNew("ID, title");
			
			QueryAddRow(qNewGetJobTitle, 1);
			QuerySetCell(qNewGetJobTitle, "ID", 0);	
			QuerySetCell(qNewGetJobTitle, "title", "---- Select a Job Title ----");
			
			For ( i=1; i LTE qGetJobTitle.recordCount; i=i+1 ) {
				QueryAddRow(qNewGetJobTitle, 1);
				QuerySetCell(qNewGetJobTitle, "ID", qGetJobTitle.ID[i]);	
				QuerySetCell(qNewGetJobTitle, "title", qGetJobTitle.title[i]);
			}
			
			return qNewGetJobTitle;
		</cfscript>
        
	</cffunction>
    
    <cffunction name="getHostCompanyInfo" access="remote" returntype="struct" hint="Gets Host Company Info based on Host Company ID in struct Format">
    	<cfargument name="hostCompanyID" type="numeric" required="yes">
        
        <cfquery name="qGetHCInfo" datasource="MySql">
        	SELECT
            	*
          	FROM
            	extra_hostcompany
           	WHERE
            	hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostCompanyID#">
        </cfquery>
        
        <cfscript>
			result = StructNew();
			result.hasCompany = 0;
			result.authenticationSecretaryOfState = 0;
			result.authenticationDepartmentOfLabor = 0;
			result.authenticationGoogleEarth = 0;
			result.EIN = "";
			result.WC = 0;
			result.WCE = "";
			
			if (qGetHCInfo.recordCount) {
				result.hasCompany = 1;
				result.authenticationSecretaryOfState = qGetHCInfo.authentication_secretaryOfState;
				result.authenticationDepartmentOfLabor = qGetHCInfo.authentication_departmentOfLabor;
				result.authenticationGoogleEarth = qGetHCInfo.authentication_googleEarth;
				result.EIN = qGetHCInfo.EIN;
				result.WC = qGetHCInfo.workmenscompensation;
				result.WCE = DateFormat(qGetHCInfo.WCDateExpired, 'mm/dd/yyyy');
			}
			return result;
		</cfscript>
        
    </cffunction>

</cfcomponent>