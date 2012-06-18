<!--- ------------------------------------------------------------------------- ----
	
	File:		watDailyDocumentExpiration.cfm
	Author:		James Griffiths
	Date:		June 18, 2012
	Desc:		Scheduled Task: Removes documents if they have expired.
					1: Removes english businees license document from an 
					international representative if it has reached its 
					expiration date.
					2: Removes secretary of state documents if they have
					expired.
					--It shoud be run daily.

----- ------------------------------------------------------------------------- --->

<!--- English Business License --->
<cfquery datasource="MySql">
	UPDATE
    	smg_users
  	SET
    	watDocEnglishBusinessLicense = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
   	WHERE
    	userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
   	AND
    	watDocEnglishBusinessLicenseExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>

<!--- Secretary of State --->
<cfquery name="qGetHosts" datasource="MySql">
	SELECT
    	*
   	FROM
    	extra_hostCompany
   	WHERE
    	authentication_secretaryOfStateExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>

<cfoutput query="qGetHosts">
	<!--- remove image if it exists --->
     <cfif fileExists("#APPLICATION.PATH.businessLicense##hostCompanyID#.jpg")>
        <cffile action="delete"  file="#APPLICATION.PATH.businessLicense##hostCompanyID#.jpg">
  	</cfif>
    <!--- remove authentications --->
    <cfquery datasource="MySql">
    	UPDATE
        	extra_hostCompany
       	SET
        	authentication_secretaryOfState = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
       	WHERE
        	hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostCompanyID#">
    </cfquery>
</cfoutput>

<p>Complete</p>

