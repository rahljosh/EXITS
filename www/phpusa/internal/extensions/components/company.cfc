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
        <cfargument name="website" default="" hint="website is not required">
              
        <cfquery 
			name="qGetCompanies" 
			datasource="#APPLICATION.dsn#">
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
                    bcc_userID,
                    bcc_password,
                    gis_account,
                    gis_username,
                    gis_password,
                    gis_email,
                    admission_person,
                    verification_letter,
                    routingNumber,
                    accountNumber,
                    letterSig,
                    dos_letter_sig,
                    dos_letter_title,
                    system_ID,
                    website
                FROM 
                    smg_companies
                WHERE	
                	1 = 1
				<cfif VAL(ARGUMENTS.companyID)>
                	AND
                    	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                </cfif>    
				<cfif LEN(ARGUMENTS.website)>
                	AND
                    	website = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.website#">
                </cfif>    
                ORDER BY 
                    companyshort
		</cfquery>
		   
		<cfreturn qGetCompanies>
	</cffunction>

</cfcomponent>