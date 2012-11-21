<!--- ------------------------------------------------------------------------- ----
	
	File:		addHostHistoryRecord.cfm
	Author:		James Griffiths
	Date:		November 21, 2012
	Desc:		Temporary Task - Desgined to add all of the host company info records
				to the current host companies.

----- ------------------------------------------------------------------------- --->

<cfsetting requesttimeout="1000"> 

<cfquery name="qGetHostCompanies" datasource="MySql">
	SELECT *
    FROM extra_hostcompany
    WHERE hostCompanyID NOT IN (SELECT hostID FROM extra_hostinfohistory)
</cfquery>
<cfoutput>BEFORE: #qGetHostCompanies.recordCount# <br /></cfoutput>

<cfloop query="qGetHostCompanies">
	
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
            <cfqueryparam cfsqltype="cf_sql_integer" value="#hostCompanyID#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#personJobOfferName#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#personJobOfferTitle#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#EIN#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#workmensCompensation#" null="#NOT IsNumeric(workmensCompensation)#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#WCDateExpired#" null="#NOT IsDate(WCDateExpired)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#homepage#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#observations#">,
            <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(authentication_secretaryOfState)#">,
            <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(authentication_departmentOfLabor)#">,
            <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(authentication_googleEarth)#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#authentication_secretaryOfStateExpiration#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#authentication_departmentOfLaborExpiration#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#authentication_googleEarthExpiration#"> )
    </cfquery>
    
    <cfquery name="qGetNewHistoryID" datasource="MySql">
    	SELECT historyID
        FROM extra_hostinfohistory
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostCompanyID#">
        ORDER BY historyID DESC
        LIMIT 1
    </cfquery>
    
	<cfquery name="qGetActivePrograms" datasource="MySql">
    	SELECT p.programID, j.numberPositions, j.verifiedDate, conf.confirmed, conf.confirmedDate
      	FROM smg_programs p
        INNER JOIN smg_companies c ON c.companyID = p.companyID
        LEFT OUTER JOIN extra_j1_positions j ON j.programID = p.programID
			AND j.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(hostCompanyID)#">
       	LEFT OUTER JOIN extra_confirmations conf ON conf.programID = p.programID
        	AND conf.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(hostCompanyID)#">
      	WHERE dateDiff(p.endDate,NOW()) >= <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND p.active = 1
        AND p.is_deleted = 0
        AND p.companyID = 8
    </cfquery>
    
    <cfloop query="qGetActivePrograms">
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
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(programID)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(numberPositions)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#verifiedDate#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(confirmed)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#confirmedDate#"> )
        </cfquery>
    </cfloop>
    
</cfloop>

<!--- To check if any records were missed --->
<cfquery name="qGetHostCompanies" datasource="MySql">
	SELECT *
    FROM extra_hostcompany
    WHERE hostCompanyID NOT IN (SELECT hostID FROM extra_hostinfohistory)
</cfquery>
<cfoutput>AFTER: #qGetHostCompanies.recordCount# <br /></cfoutput>