<!--- ------------------------------------------------------------------------- ----
	
	File:		company.cfc
	Author:		Marcus Melo
	Date:		October, 09 2009
	Desc:		This holds the functions needed for the company

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="company"
	output="false" 
	hint="A collection of functions for the company">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="company" output="false" hint="Returns the initialized Company object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	
	<cffunction name="getCompanies" access="public" returntype="query" output="false" hint="Gets a list of companies, if companyID is passed gets a company by ID">
    	<cfargument name="companyID" default="0" hint="CompanyID is not required">
    	<cfargument name="companyIDList" default="" hint="List of Company IDs / not required">
    	<cfargument name="httpHost" default="" hint="httpHost is not required">
        
        <cfquery 
			name="qGetCompanies" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
                	companyID,
                    team_ID,
                    system_ID,
                    companyName,
                    companyShort,
                    companyShort_nocolor,
                    URL,
                    pm_email,
                    projectManager,
                    financeEmail,
                    address,
                    city,
                    state,
                    zip,
                    phone,
                    toll_free,
                    fax,
                    support_email,
                    orgCode,
                    sevis_userID,
                    iap_auth,
                    usbank_iap_aut,
                    gis_account,
                    gis_username,
                    gis_password,
                    gis_email,
                    admission_person,
                    verification_letter,
                    letterSig,
                    dos_letter_sig,
                    dos_letter_title,
                    system_ID,
                    website,
                    url_ref,
                    company_color
                FROM 
                    smg_companies
                WHERE	
                	1 = 1
				
				<cfif VAL(ARGUMENTS.companyID)>
                	AND
                    	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                </cfif>    

				<cfif LEN(ARGUMENTS.companyIDList)>
                	AND
                    	companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyIDList#" list="yes"> )
                </cfif> 
                
                <cfif LEN(ARGUMENTS.httpHost)>
                	AND
                    	url_ref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.httpHost#">
                </cfif>   
                
                ORDER BY 
                    companyShort_nocolor,                    
                    companyshort
		</cfquery>
           
		<cfreturn qGetCompanies>
	</cffunction>
    

	<cffunction name="getCompanyByID" access="public" returntype="query" output="false" hint="Gets a company by ID">
    	<cfargument name="companyID" default="0" hint="CompanyID is not required">
              
        <cfquery 
			name="qGetCompanyByID" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
                	companyID,
                    companyName,
                    team_ID,
                    companyShort,
                    companyShort_nocolor,
                    URL,
                    address,
                    city,
                    state,
                    zip,
                    phone,
                    toll_free,
                    fax,
                    support_email,
                    orgCode,
                    sevis_userID,
                    iap_auth,
                    usbank_iap_aut,
                    gis_account,
                    gis_username,
                    gis_password,
                    gis_email,
                    admission_person,
                    verification_letter,
                    letterSig,
                    dos_letter_sig,
                    dos_letter_title,
                    system_ID,
                    website
                FROM 
                    smg_companies
                WHERE	
                    companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.companyID)#">
		</cfquery>
           
		<cfreturn qGetCompanyByID>
	</cffunction>

</cfcomponent>