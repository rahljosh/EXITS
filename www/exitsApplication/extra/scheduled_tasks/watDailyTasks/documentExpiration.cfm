<!--- ------------------------------------------------------------------------- ----
	
	File:		watDailyDocumentExpiration.cfm
	Author:		James Griffiths
	Date:		June 18, 2012
	Desc:		Scheduled Task: Removes documents if they have expired.
					1: Removes english businees license document from an 
					international representative if it has reached its 
					expiration date.
					2: Removes authentication documents if they have
					expired.
					--It shoud be run daily.

----- ------------------------------------------------------------------------- --->

<!--- List of hosts that are going to be changed - used to add history records --->
<cfquery name="qChangedHosts" datasource="MySql">
	SELECT *
   	FROM extra_hostcompany
   	WHERE ( authentication_secretaryOfStateExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
        AND authentication_secretaryOfState = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> )
    OR ( authentication_departmentOfLaborExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
    	AND authentication_departmentOfLabor = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> )
    OR ( authentication_googleEarthExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
    	AND authentication_googleEarth = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> )
</cfquery>
<cfset vChangedHosts = ValueList(qChangedHosts.hostCompanyID)>

<!--- Intl. Rep Documents --->
<!---Dates and bit values --->
<cfquery datasource="#APPLICATION.DSN.Source#">
	UPDATE smg_users
  	SET watDocBusinessLicense = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
   	WHERE userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
   	AND watDocBusinessLicenseExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<cfquery datasource="#APPLICATION.DSN.Source#">
	UPDATE smg_users
  	SET watDocEnglishBusinessLicense = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
   	WHERE userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
   	AND watDocEnglishBusinessLicenseExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<cfquery datasource="#APPLICATION.DSN.Source#">
	UPDATE smg_users
  	SET watDocWrittenReference1 = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
   	WHERE userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
   	AND watDocWrittenReference1Expiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<cfquery datasource="#APPLICATION.DSN.Source#">
	UPDATE smg_users
  	SET watDocWrittenReference2 = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
   	WHERE userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
   	AND watDocWrittenReference2Expiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<cfquery datasource="#APPLICATION.DSN.Source#">
	UPDATE smg_users
  	SET watDocWrittenReference3 = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
   	WHERE userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
   	AND watDocWrittenReference3Expiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<cfquery datasource="#APPLICATION.DSN.Source#">
	UPDATE smg_users
  	SET watDocOriginalCBC = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
   	WHERE userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
   	AND watDocOriginalCBCExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<cfquery datasource="#APPLICATION.DSN.Source#">
	UPDATE smg_users
  	SET watDocEnglishCBC = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
   	WHERE userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
   	AND watDocEnglishCBCExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<!--- Only Dates --->
<cfquery datasource="#APPLICATION.DSN.Source#">
	UPDATE smg_users
  	SET watDocNotarizedFinancialStatementExpiration = NULL
   	WHERE userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
   	AND watDocNotarizedFinancialStatementExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<cfquery datasource="#APPLICATION.DSN.Source#">
	UPDATE smg_users
  	SET watDocBankruptcyDisclosureExpiration = NULL
   	WHERE userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
   	AND watDocBankruptcyDisclosureExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<cfquery datasource="#APPLICATION.DSN.Source#">
	UPDATE smg_users
  	SET watDocPreviousExperienceExpiration = NULL
   	WHERE userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
   	AND watDocPreviousExperienceExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<cfquery datasource="#APPLICATION.DSN.Source#">
	UPDATE smg_users
  	SET watDocOriginalAdvertisingMaterialExpiration = NULL
   	WHERE userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
   	AND watDocOriginalAdvertisingMaterialExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<cfquery datasource="#APPLICATION.DSN.Source#">
	UPDATE smg_users
  	SET watDocEnglishAdvertisingMaterialExpiration = NULL
   	WHERE userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
   	AND watDocEnglishAdvertisingMaterialExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>


<!--- Authentications --->

<!--- Secretary Of State --->
<cfquery name="qGetHosts_expiredSOS" datasource="MySql">
	SELECT *
   	FROM extra_hostcompany
   	WHERE authentication_secretaryOfStateExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<cfloop query="qGetHosts_expiredSOS">
    <cfquery datasource="MySql">
    	UPDATE extra_hostcompany
       	SET authentication_secretaryOfState = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
       	WHERE hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostCompanyID#">
    </cfquery>
</cfloop>

<!--- Incorporation --->
<cfquery name="qGetHosts_expiredIncorporation" datasource="MySql">
	SELECT *
   	FROM extra_hostcompany
   	WHERE authentication_incorporationExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<cfloop query="qGetHosts_expiredIncorporation">
    <cfquery datasource="MySql">
    	UPDATE extra_hostcompany
       	SET authentication_incorporation = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
       	WHERE hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostCompanyID#">
    </cfquery>
</cfloop>

<!--- Certificate of Existence --->
<cfquery name="qGetHosts_expiredCertificateOfExistence" datasource="MySql">
	SELECT *
   	FROM extra_hostcompany
   	WHERE authentication_certificateOfExistenceExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<cfloop query="qGetHosts_expiredCertificateOfExistence">
    <cfquery datasource="MySql">
    	UPDATE extra_hostcompany
       	SET authentication_certificateOfExistence = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
       	WHERE hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostCompanyID#">
    </cfquery>
</cfloop>

<!--- Certificate of Reinstatement --->
<cfquery name="qGetHosts_expiredCertificateOfReinstatement" datasource="MySql">
	SELECT *
   	FROM extra_hostcompany
   	WHERE authentication_certificateOfReinstatementExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<cfloop query="qGetHosts_expiredCertificateOfReinstatement">
    <cfquery datasource="MySql">
    	UPDATE extra_hostcompany
       	SET authentication_certificateOfReinstatement = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
       	WHERE hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostCompanyID#">
    </cfquery>
</cfloop>

<!--- Department of State --->
<cfquery name="qGetHosts_expiredDepartmentOfState" datasource="MySql">
	SELECT *
   	FROM extra_hostcompany
   	WHERE authentication_departmentOfStateExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<cfloop query="qGetHosts_expiredDepartmentOfState">
    <cfquery datasource="MySql">
    	UPDATE extra_hostcompany
       	SET authentication_departmentOfState = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
       	WHERE hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostCompanyID#">
    </cfquery>
</cfloop>

<!--- Department Of Labor --->
<cfquery name="qGetHosts_expiredDOL" datasource="MySql">
	SELECT *
   	FROM extra_hostcompany
   	WHERE authentication_departmentOfLaborExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<cfloop query="qGetHosts_expiredDOL">
    <cfquery datasource="MySql">
    	UPDATE extra_hostcompany
       	SET authentication_departmentOfLabor = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
       	WHERE hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostCompanyID#">
    </cfquery>
</cfloop>

<!--- Google Earth --->
<cfquery name="qGetHosts_expiredGE" datasource="MySql">
	SELECT *
   	FROM extra_hostcompany
   	WHERE authentication_googleEarthExpiration < <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
</cfquery>
<cfloop query="qGetHosts_expiredGE">
    <cfquery datasource="MySql">
    	UPDATE extra_hostcompany
       	SET authentication_googleEarth = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
       	WHERE hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostCompanyID#">
    </cfquery>
</cfloop>

<!--- Insert New History Records --->
<cfquery name="qGetUpdatedRecord" datasource="MySql">
	SELECT *
    FROM extra_hostcompany
    WHERE hostCompanyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#VAL(vChangedHosts)#"> )
</cfquery>

<cfloop query="qGetUpdatedRecord">

    <cfquery name="qGetRecentSeasonHistory" datasource="MySql">
        SELECT *
        FROM extra_hostseasonhistory ehsh
        WHERE ehsh.hostHistoryID = (
        	SELECT historyID 
            FROM extra_hostinfohistory 
            WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetUpdatedRecord.hostCompanyID#">
            ORDER BY historyID DESC 
            LIMIT 1 )
    </cfquery>
    
    <cfquery datasource="MySql">
        INSERT INTO extra_hostinfohistory (
            hostID,
            dateChanged,
            personJobOfferName,
            personJobOfferTitle,
            EIN,
            workmensCompensation,
            WCDateExpired,
            homepage,
            observations,
            authentication_secretaryOfState,
            authentication_departmentOfLabor,
            authentication_googleEarth,
            authentication_secretaryOfStateExpiration,
            authentication_departmentOfLaborExpiration,
            authentication_googleEarthExpiration )
        VALUES (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetUpdatedRecord.hostCompanyID#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetUpdatedRecord.personJobOfferName#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetUpdatedRecord.personJobOfferTitle#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetUpdatedRecord.EIN#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetUpdatedRecord.workmensCompensation#" null="#NOT IsNumeric(qGetUpdatedRecord.workmensCompensation)#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#qGetUpdatedRecord.WCDateExpired#" null="#NOT IsDate(qGetUpdatedRecord.WCDateExpired)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetUpdatedRecord.homepage#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetUpdatedRecord.observations#">,
            <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(qGetUpdatedRecord.authentication_secretaryOfState)#">,
            <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(qGetUpdatedRecord.authentication_departmentOfLabor)#">,
            <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(qGetUpdatedRecord.authentication_googleEarth)#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#qGetUpdatedRecord.authentication_secretaryOfStateExpiration#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#qGetUpdatedRecord.authentication_departmentOfLaborExpiration#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#qGetUpdatedRecord.authentication_googleEarthExpiration#"> )
    </cfquery>
    
    <cfquery name="qGetNewHistoryID" datasource="MySql">
    	SELECT historyID
        FROM extra_hostinfohistory
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetUpdatedRecord.hostCompanyID#">
        ORDER BY historyID DESC
        LIMIT 1
    </cfquery>
    
    <cfloop query="qGetRecentSeasonHistory">
    	<cfquery datasource="MySql">
        	INSERT INTO extra_hostseasonhistory (
            	hostHistoryID,
                programID,
                j1Positions,
                j1Date,
                confirmed,
                confirmedDate )
           	VALUES (
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewHistoryID.historyID)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#programID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#j1Positions#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#j1Date#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#confirmed#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#confirmedDate#"> )
        </cfquery>
    </cfloop>
    
</cfloop>
