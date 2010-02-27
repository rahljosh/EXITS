<!--- ------------------------------------------------------------------------- ----
	
	File:		user.cfc
	Author:		Marcus Melo
	Date:		October, 27 2009
	Desc:		This holds the functions needed for the user

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="user"
	output="false" 
	hint="A collection of functions for the company">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="user" output="false" hint="Returns the initialized User object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	
	<cffunction name="getUsers" access="public" returntype="query" output="false" hint="Gets a list of users, if usertype is passed gets users by usertype">
    	<cfargument name="userID" default="0" hint="userID is not required">
    	<cfargument name="usertype" default="0" hint="usertype is not required">
              
        <cfquery 
			name="qGetUsers" 
			datasource="#APPLICATION.dsn#">
                SELECT
					*
                FROM 
                    smg_users
                WHERE
                	1 = 1
                    
				<cfif VAL(ARGUMENTS.usertype)>
                	AND	
                    	usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.usertype#">
                </cfif>
                
				<cfif VAL(ARGUMENTS.usertype)>
                    ORDER BY 
                        businessName                
                <cfelse>
                    ORDER BY 
                        lastName
                </cfif>
		</cfquery>
		   
		<cfreturn qGetUsers>
	</cffunction>


	<cffunction name="getUserByID" access="public" returntype="query" output="false" hint="Gets a user by ID">
    	<cfargument name="userID" type="numeric" hint="userID is required">
              
        <cfquery 
			name="qGetUserByID" 
			datasource="#APPLICATION.dsn#">
                SELECT
					*
                FROM 
                    smg_users
                WHERE	
                    userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
		</cfquery>
		   
		<cfreturn qGetUserByID>
	</cffunction>


	<cffunction name="getUserAccessRights" access="public" returntype="query" output="false" hint="Gets user access rights for a user or region">
    	<cfargument name="userID" type="numeric" default="0" hint="userID is required">
        <cfargument name="regionID" type="numeric" default="0" hint="regionID is required">
              
        <cfquery 
			name="qGetUserAccessRights" 
			datasource="#APPLICATION.dsn#">
                SELECT
					uar.id,
                    uar.userID,
                    uar.companyID,
                    uar.regionID,
                    uar.userType,
                    uar.advisorID,
                    uar.default_region,
                    uar.default_access,
                    uar.changeDate,
                    r.regionID,
                    r.regionName
                FROM 
                    user_access_rights uar
                INNER JOIN
                	smg_regions r ON r.regionID = uar.regionID
                WHERE
                	1 = 1

				<cfif VAL(ARGUMENTS.userID )>
                	AND
                    	uar.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                </cfif>                  
                    
				<cfif VAL(ARGUMENTS.regionID )>
                	AND
                    	uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
                </cfif>                  
		</cfquery>
		   
		<cfreturn qGetUserAccessRights>
	</cffunction>


	<cffunction name="getRegionalManager" access="public" returntype="query" output="false" hint="Gets a regional manager for a given region">
        <cfargument name="regionID" type="numeric" default="0" hint="regionID is required">
              
        <cfquery 
			name="qGetRegionalManager" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                	u.userid,
                    u.firstName,
                    u.lastName,
                    u.email
                FROM 
                	smg_users u
                INNER JOIN 
                	user_access_rights uar ON u.userid = uar.userid
                WHERE 
                	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND 
                    uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
                AND 
                	uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
		</cfquery>
		   
		<cfreturn qGetRegionalManager>
	</cffunction>


	<cffunction name="getUserMemberByID" access="public" returntype="query" output="false" hint="Gets a user member by ID">
    	<cfargument name="ID" type="numeric" hint="ID is required">
        <cfargument name="userID" default="0" hint="userID is not required">
              
        <cfquery 
			name="qGetUserMemberByID" 
			datasource="#APPLICATION.dsn#">
                SELECT
					id,
                    userID,
                    firstName,
                    middleName,
                    LastName,
                    sex,
                    relationShip,
                    DOB,
                    SSN,
                    drivers_license,
                    auth_received,
                    auth_received_type,
                    no_members
                FROM 
                    smg_user_family
                WHERE	
                    id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">
                <cfif VAL(ARGUMENTS.userID)>
                AND    
                    userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
				</cfif>                    
		</cfquery>
		   
		<cfreturn qGetUserMemberByID>
	</cffunction>


	<!--- Payments --->
	<cffunction name="getRepTotalPayments" access="public" returntype="query" output="false" hint="Gets reps total payment by program">
    	<cfargument name="userID" hint="UserID is required">
        <cfargument name="companyID" hint="companyID is required">
              
            <cfquery 
                name="qGetRepTotalPayments" 
                datasource="#APPLICATION.dsn#">
                SELECT 
                    rep.programID, 
                    SUM(rep.amount) as totalPerProgram,
                    p.programName            
                FROM 
                    smg_rep_payments rep
                LEFT JOIN
                    smg_programs p ON p.programID = rep.programID
                WHERE 
                    rep.agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                <cfif ARGUMENTS.companyID GT 5>
                    AND rep.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                <cfelse>
                    AND rep.companyid < <cfqueryparam cfsqltype="cf_sql_integer" value="6"> 
                </cfif>
                GROUP BY
                    rep.programID            
                ORDER BY 
                    p.startDate DESC
            </cfquery>
		   
		<cfreturn qGetRepTotalPayments>
	</cffunction>

    
	<cffunction name="getRepPaymentsByProgramID" access="public" returntype="query" output="false" hint="Gets rep payments by a programID">
    	<cfargument name="userID" hint="UserID is required">
        <cfargument name="programID" hint="ProgramID is required">
        <cfargument name="companyID" hint="companyID is required">
              
        <cfquery 
			name="qGetRepPaymentsByProgramID" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                    rep.id, 
                    rep.amount, 
                    rep.comment, 
                    rep.date, 
                    rep.transtype,
                    s.studentid,
                    s.firstname, 
                    s.familylastname,             
                    c.team_id,
                    type.type,
                    p.programName
                FROM 
                    smg_rep_payments rep
                LEFT JOIN 
                    smg_students s ON s.studentid = rep.studentid
                LEFT JOIN 
                    smg_payment_types type ON type.id = rep.paymenttype
                LEFT JOIN 
                    smg_companies c ON c.companyid = rep.companyid
                LEFT JOIN
                    smg_programs p ON p.programID = rep.programID
                WHERE 
                    rep.agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
				AND
                	rep.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">                  
				<cfif ARGUMENTS.companyID GT 5>
                    AND 
                    	rep.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                <cfelse>
                    AND 
                    	rep.companyID < <cfqueryparam cfsqltype="cf_sql_integer" value="6"> 
                </cfif>
                ORDER BY 
                    rep.date DESC
		</cfquery>
		   
		<cfreturn qGetRepPaymentsByProgramID>
	</cffunction>


	<!--- Training --->
	<cffunction name="getTraining" access="public" returntype="query" output="false" hint="Gets a list of training records for a userID">
    	<cfargument name="userID" default="0" hint="userID is not required">
              
        <cfquery 
			name="qGetTraining" 
			datasource="#APPLICATION.dsn#">
                SELECT
					id,
                    user_id,
                    office_user_id,
                    notes,
                    date_trained,
                    date_created,
                    date_updated
                FROM 
                    smg_users_training
                WHERE
                    user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                ORDER BY 
                    date_created
		</cfquery>
		   
		<cfreturn qGetTraining>
	</cffunction>


	<cffunction name="insertTraining" access="public" returntype="void" output="false" hint="Inserts a training. UserID must be passed.">
    	<cfargument name="userID" hint="userID is required">
        <cfargument name="officeUserID" hint="officeUserID is required">
        <cfargument name="notes" default="" hint="notes is not required">
        <cfargument name="dateTrained" hint="dateTrained is required">
              
        <cfquery 
			name="qInsertTraining" 
			datasource="#APPLICATION.dsn#">
                INSERT INTO
                	smg_users_training
                (
                    user_id,
                    office_user_id,
                    notes,
                    date_trained,
                    date_created,
                    date_updated
                )
                VALUES
                (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.officeUserID#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.notes#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(ARGUMENTS.dateTrained)#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">,
                	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">
                )	
		</cfquery>
		   
	</cffunction>


	<cffunction name="reportTrainingByRegion" access="public" returntype="query" output="false" hint="Gets a list of training records for a userID">
    	<cfargument name="regionID" default="0" hint="List of region IDs">
              
        <cfquery 
			name="qReportTrainingByRegion" 
			datasource="#APPLICATION.dsn#">
                SELECT
					u.userID,
                    u.firstName,
                    u.lastName,
                    r.regionID,
                    r.regionName,
                    sut.notes,
                    sut.date_trained
                FROM 
                    smg_users u
                INNER JOIN 
                	user_access_rights uar ON uar.userID = u.userID 
                        AND 
                            uar.regionID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#" list="yes">)
                INNER JOIN
                	smg_regions r ON r.regionID = uar.regionID   
                LEFT OUTER JOIN
                	smg_users_training sut ON sut.user_ID = u.userID
                WHERE	
                	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">                
                ORDER BY 
                    r.regionName,
                    u.lastName,
                    sut.date_trained DESC
		</cfquery>
		   
		<cfreturn qReportTrainingByRegion>
	</cffunction>


</cfcomponent>