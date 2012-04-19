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
        <cfargument name="isActive" default="1" hint="isActive is not required">
              
        <cfquery 
			name="qGetUsers" 
			datasource="#APPLICATION.dsn#">
                SELECT DISTINCT
					u.*
                FROM 
                    smg_users u
                INNER JOIN
                	user_access_rights uar ON uar.userID = u.userID
                WHERE
                	1 = 1

				<cfif VAL(ARGUMENTS.userID)>
                	AND	
                    	u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                </cfif>
                    
                <cfif LEN(ARGUMENTS.isActive)>
                	AND
                    	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isActive#">
                </cfif>

				<cfif VAL(ARGUMENTS.usertype)>
                	AND	
                    	uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.usertype#">
                </cfif>
                
                GROUP BY
                	u.userID 
                                   
				<cfif VAL(ARGUMENTS.usertype)>
                    ORDER BY 
                        u.businessName                
                <cfelse>
                    ORDER BY 
                        u.lastName
                </cfif>
		</cfquery>
		   
		<cfreturn qGetUsers>
	</cffunction>


	<cffunction name="getUserByID" access="public" returntype="query" output="false" hint="Gets a user by ID">
    	<cfargument name="userID" type="any" hint="userID is required">
              
        <cfquery 
			name="qGetUserByID" 
			datasource="#APPLICATION.dsn#">
                SELECT
					*
                FROM 
                    smg_users
                WHERE	
                    userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
		</cfquery>
		   
		<cfreturn qGetUserByID>
	</cffunction>


	<cffunction name="getIntlRepresentatives" access="public" returntype="query" output="false" hint="Gets a list of intl. representatives assigned to active students">
        <cfargument name="isActive" default="1" hint="isActive is not required">

        <cfquery 
			name="qGetIntlRepresentatives" 
			datasource="#APPLICATION.dsn#">
                SELECT DISTINCT
					u.*
                FROM 
                    smg_users u
                INNER JOIN
                	user_access_rights uar ON uar.userID = u.userID
                INNER JOIN
                	smg_students s ON s.intRep = u.userID
                    	AND
                        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
						<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISE, CLIENT.companyID)>
                            AND          
                                s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
                        <cfelse>
                            AND          
                                s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#"> 
                        </cfif>
                WHERE
                    uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
                    
                <cfif LEN(ARGUMENTS.isActive)>
                	AND
                    	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.isActive#">
                </cfif>

                GROUP BY
                	u.userID 
                                   
                ORDER BY 
                    u.businessName                
			</cfquery>
		   
		<cfreturn qGetIntlRepresentatives>
	</cffunction>


	<cffunction name="getCompleteUserAddress" access="public" returntype="query" output="false" hint="Returns complete user address">
    	<cfargument name="userID" default="" hint="userID is required">
        
        <cfquery 
			name="qGetCompleteUserAddress" 
			datasource="#APPLICATION.dsn#">
                SELECT
                	userID,
                    CONCAT(address, ', ', city, ', ', state, ', ', zip) AS completeAddress
                FROM 
                    smg_users
                WHERE
                    userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
		</cfquery>
		   
		<cfreturn qGetCompleteUserAddress>
	</cffunction>


	<cffunction name="getUserStateListByRegionID" access="public" returntype="string" output="false" hint="Returns a list of user states assigned to a region">
    	<cfargument name="regionID" type="numeric" hint="regionID is required">

        <cfquery 
			name="qGetUserStateListByRegionID" 
			datasource="#APPLICATION.DSN#">
                SELECT
					u.state
                FROM 
                    smg_users u
                INNER JOIN
                	user_access_rights uar ON uar.userID = u.userID
                WHERE	
                    uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
                AND
                	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                GROUP BY
                	u.state
                ORDER BY
                	u.state
		</cfquery>
		
        <cfscript>
			var vReturnState = ValueList(qGetUserStateListByRegionID.state);			
			
			// Return List
			return vReturnState;
		</cfscript>
           
	</cffunction>


	<cffunction name="getUserAccessRights" access="public" returntype="query" output="false" hint="Gets user access rights for a user or region">
    	<cfargument name="userID" type="numeric" default="0" hint="userID is required">
        <cfargument name="regionID" type="numeric" default="0" hint="regionID is required">
        <cfargument name="companyID" type="numeric" default="0" hint="companyID is required">
              
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

				<cfif ARGUMENTS.companyID EQ 10>
                	AND
                    	uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                <cfelse>
                	AND
                    	uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
                </cfif>

				ORDER BY
                	uar.default_access DESC                               
		</cfquery>
		   
		<cfreturn qGetUserAccessRights>
	</cffunction>


	<cffunction name="checkUserAccess" access="public" returntype="boolean" output="false" hint="Checks if current user is allow to see a record for another user, returns an userID">
    	<cfargument name="currentUserID" type="numeric" hint="currentUserID is required">
        <cfargument name="currentRegionID" type="numeric" hint="currentRegionID is required">
        <cfargument name="currentUserType" type="numeric" hint="currentUserType is required">
        <cfargument name="viewUserID"type="numeric" hint="viewUserID is required">
              
        <cfscript>
			var allowAccess = false;

			if ( ARGUMENTS.currentUserType LTE 4 OR ARGUMENTS.currentUserID EQ ARGUMENTS.viewUserID ) {
				
				// Allow Access to office users and users seeing their own information
				allowAccess = true;
			
			} else {

				// Get view user access				
				viewUserAccess = getUserAccessRights(userID=ARGUMENTS.viewUserID, regionID=ARGUMENTS.currentRegionID);
				
				if ( VAL(viewUserAccess.recordCount) ) {
				
					switch(ARGUMENTS.currentUserType) {
						
						// Regional Manager
						case 5: {
							 allowAccess = true;
							 break;
						}
						
						// Regional Advisor
						case 6: {
							 if ( ARGUMENTS.currentUserID EQ viewUserAccess.advisorID ) {
								 allowAccess = true;
							 }
							 break;
						}
						
						// Area Rep is only allowed to see their own information
					}								 
				}
			}
		</cfscript>
        
        <cfreturn allowAccess>
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
                    u.email,
                    u.phone,
                    u.work_phone,
                    r.regionName
                FROM 
                	smg_users u
                INNER JOIN 
                	user_access_rights uar ON u.userid = uar.userid
				INNER JOIN
                	smg_regions r ON r.regionID = uar.regionID                    
                WHERE 
                	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND 
                    uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
                AND 
                	uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
		</cfquery>
		   
		<cfreturn qGetRegionalManager>
	</cffunction>


	<cffunction name="getSupervisedUsers" access="public" returntype="query" output="false" hint="Gets a list of supervised users">
        <cfargument name="usertype" type="numeric" hint="usertype is required">
        <cfargument name="userID" type="numeric" hint="userID is required">
        <cfargument name="regionID" type="numeric" hint="regionID is required">
        <cfargument name="is2ndVisitIncluded" default="0" type="numeric" hint="is2ndVisitIncluded is not required">
        <cfargument name="includeUserIDs" default="" hint="area reps will be able to see themselves and current assigned users on the list">
        
        <!--- Office Users --->
        <cfif ListFind("1,2,3,4", ARGUMENTS.userType)>
            
            <!--- Get all users for a specific region --->  
            <cfquery 
                name="qGetSupervisedUsers" 
                datasource="#APPLICATION.dsn#">
                    SELECT DISTINCT
                        u.*
                    FROM 
                    	smg_users u
                    INNER JOIN 
                    	user_access_rights uar ON uar.userid = u.userid
                    WHERE 
                    	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    AND 
                    	uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
                    AND
                    	u.accountCreationVerified != <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                    <!---
					AND
						u.dateAccountVerified IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
					--->						
                    <cfif VAL(is2ndVisitIncluded)>
                        AND 
                            uar.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7,15" list="yes"> )
                    <cfelse>
                        AND 
                            uar.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7" list="yes"> )
                    </cfif>

                    <!--- Include Current Assigned User --->
                    <cfif LEN(ARGUMENTS.includeUserIDs)>
                    	OR
                            u.userID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.includeUserIDs#" list="yes"> )
                    </cfif>
                    
                    ORDER BY 
                    	u.lastname,
                        u.firstName
            </cfquery>

		<cfelse>
        
            <cfquery 
                name="qGetSupervisedUsers" 
                datasource="#APPLICATION.dsn#">
                    SELECT DISTINCT
                        u.*
                    FROM 
                    	smg_users u
                    INNER JOIN 
                    	user_access_rights uar ON uar.userid = u.userid
                    WHERE 
                    	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    AND
                    	u.accountCreationVerified != <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                    <!---
					AND
						u.dateAccountVerified IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
					--->						
                    
					<cfif ListLen(ARGUMENTS.regionID) EQ 1>
                        AND 
                            uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
                    <cfelse>
                        AND 
                            uar.regionid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#"> )
                    </cfif>
                        
                    <cfswitch expression="#ARGUMENTS.userType#">
                    	
                        <!--- Regional Manager --->
                    	<cfcase value="5">
                        
							<cfif VAL(is2ndVisitIncluded)>
                                AND 
                                    uar.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7,15" list="yes"> )
                            <cfelse>
                                AND 
                                    uar.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7" list="yes"> )
                            </cfif>
                            
                        </cfcase>
                        
                        <!--- Regional Advisor - Returns users under them --->
                    	<cfcase value="6">
                            AND 
                               	(
                                	uar.advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
	                            OR
    	                        	u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
        						)
                        </cfcase>
                        
                    	<!--- Area Representative | 2nd Visit Representative - Returns themselves --->	
                    	<cfcase value="7,15">
                        	AND
                                u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                        </cfcase>
                        
                    </cfswitch>
					
                    <!--- Include Current Assigned User --->
                    <cfif LEN(ARGUMENTS.includeUserIDs)>
                    	OR
                            u.userID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.includeUserIDs#" list="yes"> )
                    </cfif>
                    
                    ORDER BY 
                    	u.lastname,
                        u.firstName
            </cfquery>
        
        </cfif>
               
		<cfreturn qGetSupervisedUsers>
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


	<!--- ------------------------------------------------------------------------- ----
		
		Start of Payment Section
	
	----- ------------------------------------------------------------------------- --->
    
	<cffunction name="getRepTotalPayments" access="public" returntype="query" output="false" hint="Gets reps total payment by program">
    	<cfargument name="userID" hint="UserID is required">
        <cfargument name="companyID" hint="companyID is required">
              
            <cfquery 
                name="qGetRepTotalPayments" 
                datasource="#APPLICATION.dsn#">
                SELECT                     
                    s.seasonID,
                    SUM(rep.amount) as totalPerProgram,
                    s.season           
                FROM 
                    smg_rep_payments rep
                LEFT JOIN
                    smg_programs p ON p.programID = rep.programID
                LEFT JOIN
                	smg_seasons s ON s.seasonID = p.seasonID    
                WHERE 
                    rep.agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                <cfif ARGUMENTS.companyID GT 5>
                    AND rep.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                <cfelse>
                    AND rep.companyid < <cfqueryparam cfsqltype="cf_sql_integer" value="6"> 
                </cfif>
                GROUP BY
                    s.seasonID            
                ORDER BY 
                    s.seasonID DESC
            </cfquery>
		   
		<cfreturn qGetRepTotalPayments>
	</cffunction>

    
	<cffunction name="getRepPaymentsBySeasonID" access="public" returntype="query" output="false" hint="Gets rep payments by a programID">
    	<cfargument name="userID" hint="UserID is required">        
        <cfargument name="companyID" hint="companyID is required">
        <cfargument name="seasonID" hint="seasonID is required">
              
        <cfquery 
			name="qGetRepPaymentsByProgramID" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                    rep.id, 
                    rep.amount, 
                    rep.comment, 
                    rep.date, 
                    rep.transtype,
                    stu.studentid,
                    stu.firstname, 
                    stu.familylastname,             
                    c.team_id,
                    type.type,
                    p.programName
                FROM 
                    smg_rep_payments rep
                LEFT JOIN 
                    smg_students stu ON stu.studentid = rep.studentid
                INNER JOIN
                    smg_programs p ON p.programID = rep.programID
                INNER JOIN	
                	smg_seasons s ON s.seasonID = p.seasonID
                LEFT JOIN 
                    smg_payment_types type ON type.id = rep.paymenttype
                LEFT JOIN 
                    smg_companies c ON c.companyid = rep.companyid
                WHERE 
                    rep.agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
				AND
                	s.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">                  
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


	<cffunction name="getPlacementBonusReport" access="public" returntype="query" output="false" hint="Gets placement bonus report">
    	<cfargument name="programID" hint="programID is required">        
        <cfargument name="paymentTypeID" hint="paymentTypeID is required">
        <cfargument name="regionID" hint="regionID is required">
              
        <cfquery 
			name="qGetPlacementBonusReport" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                    u.userID,
                    u.firstName,
                    u.lastName,
                    SUM(rep.amount) AS totalPaid,
                    type.ID,
                    type.type,
                    r.regionID,
                    r.regionName
                FROM 
                    smg_rep_payments rep
                INNER JOIN
                	smg_users u ON u.userID = rep.agentID
                INNER JOIN
                    smg_payment_types type ON type.id = rep.paymenttype
                INNER JOIN
                	smg_students s ON s.studentID = rep.studentID
                        AND
                            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#" list="yes"> )
                        AND
                            s.regionAssigned IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#" list="yes"> )
                INNER JOIN
                	smg_regions r ON r.regionID = s.regionAssigned                	
                WHERE 
                	rep.paymentType IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.paymentTypeID#" list="yes"> )
                GROUP BY
                	rep.agentID,
                    type.ID
                ORDER BY
                    r.regionName,
                    u.lastName,
                    type.type
		</cfquery>
		   
		<cfreturn qGetPlacementBonusReport>
	</cffunction>

	<!--- ------------------------------------------------------------------------- ----
		
		End of Payment Section
	
	----- ------------------------------------------------------------------------- --->

    
	<!--- ------------------------------------------------------------------------- ----
		
		Start of User Training
	
	----- ------------------------------------------------------------------------- --->
    
	<cffunction name="getTraining" access="public" returntype="query" output="false" hint="Gets a list of training records for a userID">
    	<cfargument name="userID" default="0" hint="userID is not required">

        <cfquery 
			name="qGetTraining" 
			datasource="#APPLICATION.dsn#">
                SELECT DISTINCT
					sut.id,
                    sut.user_id,
                    sut.office_user_id,
                    sut.training_id,
                    sut.date_trained,
                    sut.score,
                    sut.has_passed,
                    sut.date_created,
                    sut.date_updated,
                    alup.name as trainingName,
                    <!--- Office User --->
                    CAST(CONCAT(officeUser.firstName, ' ', officeUser.lastName,  ' ##', officeUser.userID) AS CHAR) AS officeUser                    
                FROM 
                    smg_users_training sut
				INNER JOIN	
                	applicationLookUP alup ON alup.fieldID = sut.training_id 
                    	AND 
                        	fieldkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="smgUsersTraining">
				LEFT OUTER JOIN
                	smg_users officeUser ON officeUser.userID = sut.office_user_id                                       	
                WHERE
                    sut.user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                ORDER BY 
                    sut.date_created
		</cfquery>
		   
		<cfreturn qGetTraining>
	</cffunction>


	<cffunction name="insertTraining" access="public" returntype="void" output="false" hint="Inserts a training. UserID must be passed.">
        <cfargument name="userID" hint="userID is required">
        <cfargument name="companyID" default="#CLIENT.companyID#" hint="companyID is required">
        <cfargument name="officeUserID" default="0" hint="officeUserID is not required">
        <cfargument name="trainingID" hint="trainingID is required">
        <cfargument name="dateTrained" hint="dateTrained is required">
        <cfargument name="score" default="0.00" hint="score is not required">
        
        <cfscript>
			// DOS Certification - Score >= 27 to pass
			var hasPassed = 0;
			
			if ( ARGUMENTS.SCORE >= 90 ) {
				hasPassed = 1;
			}
            
            // Set a default value for ARGUMENTS.score
            if ( NOT LEN(ARGUMENTS.score) ) {
            	ARGUMENTS.score = '0.00';
            }	
		</cfscript>	
		
        <cfquery 
            name="qInsertTraining" 
            datasource="#APPLICATION.dsn#">
                INSERT INTO 
                    smg_users_training
                (
                    user_id,
                    company_id,
                    office_user_id,
                    training_id,
                    date_trained,
                    score,
                    has_passed,
                    date_created,
                    date_updated
                )
                SELECT 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.officeUserID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.trainingID#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(ARGUMENTS.dateTrained)#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.score#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#hasPassed#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">
                FROM 
                    dual
                <!--- DO NOT INSERT IF ITS ALREADY EXISTS --->
                WHERE 
                	NOT EXISTS 
                        (	
                            SELECT
                                ID
                            FROM	
                                smg_users_training
                            WHERE
                                user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                            AND
                                training_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.trainingID#">
                            AND
                                date_trained = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.dateTrained)#">
                            AND
                                score = <cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.score#">
                        )   
        </cfquery>
		
	</cffunction>


	<cffunction name="reportTrainingByRegion" access="public" returntype="query" output="false" hint="Gets a list of training records by region">
    	<cfargument name="regionID" default="" hint="List of region IDs">
        <cfargument name="trainingID" default="0" hint="Training ID is not required">
        <cfargument name="userID" default="" hint="userID is not required">
        <cfargument name="userType" default="" hint="userType is not required">
        <cfargument name="programID" default="" hint="programID is not required">
        
        <cfquery 
			name="qReportTrainingByRegion" 
			datasource="#APPLICATION.dsn#">
                SELECT DISTINCT
					u.userID,
                    u.firstName,
                    u.lastName,
                    r.regionID,
                    r.regionName,
                    sut.date_trained,
                    sut.score,
                    sut.has_passed,
                    alup.name as trainingName
                FROM 
                    smg_users u
                INNER JOIN 
                    user_access_rights uar ON uar.userID = u.userID 
                        AND
                        	uar.userType IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,6,7" list="yes"> ) 
						
						<cfif VAL(ARGUMENTS.regionID)>
                            AND 
                                uar.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#" list="yes"> )
						</cfif>
                        
                        <!--- Advisor --->
                        <cfif ARGUMENTS.userType EQ 6 AND VAL(ARGUMENTS.userID)>
                            AND 
                                uar.advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
						</cfif>
                INNER JOIN
                	smg_regions r ON r.regionID = uar.regionID   
                
                <!--- Get Users that placed or are supervising a student --->
                <cfif LEN(ARGUMENTS.programID)>
                	INNER JOIN
                    	smg_students s ON 
                        		s.areaRepID = u.userID AND s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#" list="yes"> ) 
							OR 
                            	s.placeRepID = u.userID AND s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#" list="yes"> ) 
                </cfif>
                
                LEFT OUTER JOIN
                	smg_users_training sut ON sut.user_ID = u.userID
				LEFT OUTER JOIN
                	applicationLookUP alup ON alup.fieldID = sut.training_id 
                    	AND 
                        	fieldkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="smgUsersTraining">
                WHERE	
                	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">                				

				<!--- Get Users that have this trainingID --->
				<cfif VAL(ARGUMENTS.trainingID)>
                    AND
                        sut.training_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.trainingID#">              
                </cfif>   
                
                <!--- Get Users that are missing the training --->
                <cfif VAL(ARGUMENTS.trainingID)>
                    UNION
    
                    SELECT 
                        u.userID,
                        u.firstName,
                        u.lastName,
                        r.regionID,
                        r.regionName,
                        sut.date_trained,
                        sut.score,
                        sut.has_passed,
                        alup.name as trainingName
                    FROM 
                        smg_users u
                    INNER JOIN 
                        user_access_rights uar ON uar.userID = u.userID 
                        AND
                        	uar.userType IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,6,7" list="yes"> ) 
                        
                        <cfif VAL(ARGUMENTS.regionID)>
                            AND 
                                uar.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#" list="yes"> )
						</cfif>
                        
                        <!--- Advisor --->
                        <cfif ARGUMENTS.userType EQ 6 AND VAL(ARGUMENTS.userID)>
                            AND 
                                uar.advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
						</cfif>
                    INNER JOIN
                        smg_regions r ON r.regionID = uar.regionID   
                        
					<!--- Get Users that placed or are supervising a student --->
                    <cfif LEN(ARGUMENTS.programID)>
                        INNER JOIN
                            smg_students s ON 
                                    s.areaRepID = u.userID AND s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#" list="yes"> ) 
                                OR 
                                    s.placeRepID = u.userID AND s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#" list="yes"> ) 
                    </cfif>
                        
                    LEFT OUTER JOIN
                        smg_users_training sut ON sut.user_ID = u.userID
                            AND	
                            	training_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.trainingID#">
                    LEFT OUTER JOIN
                        applicationLookUP alup ON alup.fieldID = sut.training_id 
                            AND 
                                fieldkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="smgUsersTraining">
                    WHERE	
                        u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">                				
                </cfif>
                
                ORDER BY 
                    regionName,
                    lastName,
                    userID,
                    date_trained DESC
		</cfquery>
		   
		<cfreturn qReportTrainingByRegion>
	</cffunction>
    
    
	<cffunction name="reportTrainingNonCompliance" access="public" returntype="query" output="false" hint="Gets a list of missing/expired training records by region">
    	<cfargument name="regionID" default="" hint="List of region IDs">
        <cfargument name="trainingID" default="0" hint="Training ID is not required">
        <cfargument name="userID" default="" hint="userID is not required">
        <cfargument name="userType" default="" hint="userType is not required">

        <cfquery 
			name="qReportTrainingNonCompliance" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                    u.userID,
                    u.firstName,
                    u.lastName,
                    u.email,
                    u.dateCreated,
                    DATE_ADD(u.dateCreated, INTERVAL 30 DAY) AS trainingDeadline,
                    r.regionID,
                    r.regionName,
                    sut.date_trained,
                    sut.score,
                    sut.has_passed,
                    alup.name as trainingName
                FROM 
                    smg_users u
                INNER JOIN 
                    user_access_rights uar ON uar.userID = u.userID 
                        AND
                        	uar.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,6,7" list="yes"> )
                    
                        <cfif VAL(ARGUMENTS.regionID)>
                            AND 
                                uar.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#" list="yes"> )
						</cfif>
                        
                        <!--- Advisor --->
                        <cfif ARGUMENTS.userType EQ 6 AND VAL(ARGUMENTS.userID)>
                            AND 
                                uar.advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
						</cfif>
                INNER JOIN
                    smg_regions r ON r.regionID = uar.regionID   
                LEFT OUTER JOIN
                    smg_users_training sut ON sut.user_ID = u.userID
                        AND	
                            training_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.trainingID#">
                LEFT OUTER JOIN
                    applicationLookUP alup ON alup.fieldID = sut.training_id 
                        AND 
                            fieldkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="smgUsersTraining">
                WHERE	
                    u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">                				
            	AND
                	u.userID NOT IN (
                    	SELECT
                        	user_ID
                        FROM
                        	smg_users_training
                    	WHERE
                        	training_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.trainingID#">
                    )
                <!--- Training ID 2 = DOS Certification Expires after a Year / Minimum Score --->
                <cfif ARGUMENTS.trainingID EQ 2>
                    OR
                    	(
							u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">                				
						AND
                            u.userID IN (
                                SELECT
                                    sut1.user_id            
                                FROM
                                    smg_users_training sut1
                                WHERE
                                    date_trained = (
										<!--- Get Latest Record --->
                                        SELECT
                                            MAX(date_trained)
                                        FROM
                                            smg_users_training sut2
                                        WHERE
                                            sut1.user_id = sut2.user_id                              
                                        AND                         
                                            sut2.training_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.trainingID#">
                                        AND
                                        	(
                                            	DATE_ADD(sut2.date_trained, INTERVAL 1 Year) <= NOW()
                                        	OR
                                            	sut2.has_passed = <cfqueryparam cfsqltype="cf_sql_bit" value="0">   
                                   			) 
                                    )        
							)                                       
                        )
				</cfif>
                                
                ORDER BY 
                    regionName,
                    lastName,
                    userID,
                    date_trained DESC
		</cfquery>
		   
		<cfreturn qReportTrainingNonCompliance>
	</cffunction>
    

	<cffunction name="exportDOSUserList" access="public" returntype="query" output="false" hint="Gets a list of users that needs to be registered for the DOS">
    	<cfargument name="regionID" default="" hint="List of region IDs">
        <cfargument name="exportOption" default="" hint="hired | inactivated | lastLoggedIn Users">
        <cfargument name="dateCreatedFrom" default="" hint="dateCreatedFrom is not required">
        <cfargument name="dateCreatedTo" default="" hint="dateCreatedTo is not required">
             
        <cfquery 
			name="qExportDOSUserList" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                    u.userID,
                    u.firstName,
                    u.lastName,
                    u.email,
                    u.dateCreated,
                    u.dateAccountVerified,
                    u.lastLogin,
                    u.dateCancelled,
                    r.regionID,
                    r.regionName
                FROM 
                    smg_users u
                INNER JOIN 
                    user_access_rights uar ON uar.userID = u.userID 
                    AND
                        uar.userType IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,6,7" list="yes"> ) 
                    AND 
                        uar.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#" list="yes"> )
                INNER JOIN
                    smg_regions r ON r.regionID = uar.regionID
                    	AND
                        	r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">               
                WHERE	
                    1 = 1
                              				
				<cfif FORM.exportOption EQ 'hired' AND IsDate(ARGUMENTS.dateCreatedFrom) AND IsDate(ARGUMENTS.dateCreatedTo)>
                
                	AND	
	                    u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">      
                	AND
                    	u.dateAccountVerified 
                   	BETWEEN 
                    	<cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateCreatedFrom#">
                    AND 
                    	<cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateCreatedTo#">
				
				<cfelseif FORM.exportOption EQ 'inactivated' AND IsDate(ARGUMENTS.dateCreatedFrom) AND IsDate(ARGUMENTS.dateCreatedTo)>
                
                	AND	
	                    u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">      
                	AND
                    	u.dateCancelled 
                   	BETWEEN 
                    	<cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateCreatedFrom#">
                    AND 
                    	<cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateCreatedTo#">
                
				<cfelseif FORM.exportOption EQ 'lastLoggedIn' AND IsDate(ARGUMENTS.dateCreatedFrom) AND IsDate(ARGUMENTS.dateCreatedTo)>
                
                	AND	
	                    u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">      
                	AND
                    	u.lastLogin 
                   	BETWEEN 
                    	<cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateCreatedFrom#">
                    AND 
                    	<cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateCreatedTo#">
                        
				</cfif>
                
                ORDER BY 
                    r.regionName,
                    u.lastName,
                    u.userID
		</cfquery>
		   
		<cfreturn qExportDOSUserList>
	</cffunction>    
    

	<cffunction name="importDOSExcelFile" access="public" returntype="void" output="true" hint="Reads Excel file received from the DOS and stores the data into the training table">
    	<cfargument name="excelFile" hint="excelFile is required">
        
        <!--- Read Excel --->
        <cfspreadsheet action="read" src="#ARGUMENTS.excelFile#" query="qUserListData" headerRow="1">          
        	
		<cfscript>
            // COLUMNS: COURSE,LAST NAME,FIRST NAME,MIDDLE NAME,SCORE,COMPLETION DATE,PROGRAM SPONSOR,PERSON ID,COMMENTS
			
			// Loop thru query
            for (i=1;i LTE qUserListData.recordCount; i=i+1) {
            
                // Check if we hava a valid ID
                if ( VAL(qUserListData['PERSON ID'][i]) ) {
                    
                    // Insert Training
                    insertTraining(
                        userID=qUserListData['PERSON ID'][i],
                        trainingID=2,
                        dateTrained=qUserListData['COMPLETION DATE'][i],
                        score=ReplaceNoCase(qUserListData['SCORE'][i], '%', '')
                    );
                    
                }

            }			
        </cfscript>
        
	</cffunction> 
    

	<cffunction name="generateTraincasterLoginLink" access="public" returntype="string" output="No" hint="Generates a traincaster login link">
    	<cfargument name="userID" type="numeric" hint="User ID is required">
		
		<cfscript>
			/***************************************************************************************************
			http://doslocalcoordinatortraining.traincaster.com/app/clients/doslocalcoordinatortraining/Login.pm
			---------------------------------------------------------------
			Accepts seven parameters (all required; order doesn't matter) 
			---------------------------------------------------------------
			person_id (up to 36 chars) 
			first_name (up to 50 chars) 
			last_name (up to 50 chars) 
			program_sponsor (up to 100 chars) 
			timestamp (integer) 
			email (up to 50 characters)
			digest (hex hash key)
			---------------------------------------------------------------
			The process for creating the digest would look similar to this: 
			hash = sha1(<person_id> + 'password' + <timestamp>) 
			---------------------------------------------------------------
			timestamp must be ± 60 seconds of our calculation of time.  
			---------------------------------------------------------------
			Entering above url for the first time creates the account and logs the user in to TrainCaster.  
			Subsequent accesses to the URL causes the user account information to be updated and then logs the user into TrainCaster.			
			***************************************************************************************************/		
		
			// Get User Information
            qGetUserInfo = getUserByID(userID=ARGUMENTS.userID);
            
            var vTrainCasterURL = "http://doslocalcoordinatortraining.traincaster.com/app/clients/doslocalcoordinatortraining/Login.pm";
			var vProgramSponsor = "";
            
			// ISE
			if ( ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID) ) {
				vProgramSponsor = "International Student Exchange";	
				vTrainCasterPassword = "ZG2qK3vJgTHkhbSxQ6nxH273NKVS5T7Dwztm5k4B";
			// CASE
			} else {
				vProgramSponsor = "CULTURAL ACADEMIC STUDENT EXCHANGE, INC.";
				vTrainCasterPassword = "45RdPmWVrZtG6TCkSxVBbmkxPnqq2cr6Q3zJtSMp";
			}
			
            vUnixTimeStamp = int(now().getTime()/1000);
            
            vSetDigest = lCase(Hash(qGetUserInfo.userID & vTrainCasterPassword & vUnixTimeStamp, "SHA-1"));
            
			// Store date account was created
			
			// Build Login URL
            return "#vTraincasterURL#?timestamp=#vUnixTimeStamp#&person_id=#qGetUserInfo.userID#&first_name=#qGetUserInfo.firstName#&last_name=#qGetUserInfo.lastName#&email=#qGetUserInfo.email#&program_sponsor=#vProgramSponsor#&digest=#vSetDigest#";
        </cfscript>
        
	</cffunction>
    

	<cffunction name="importTraincasterTestResults" access="public" returntype="string" output="No" hint="Download results from traincaster and inserts them into the database">
        <cfargument name="date" default="#DateFormat(now(), 'yyyy-mm-dd')#" hint="Date is NOT required yyyy-mm-dd">
		<cfargument name="companyID" default="#CLIENT.companyID#" hint="company ID is required">
        
		<cfscript>
			/***************************************************************************************************
			The URL and parameters for extracting training completion records from TrainCaster:
			---------------------------------------------------------------
			https://doslocalcoordinatortraining.traincaster.com/app/clients/doslocalcoordinatortraining/Training_Recs.pm
			---------------------------------------------------------------
			Accepts three parameters (all required; order doesn't matter)
			---------------------------------------------------------------
			date in yyyy-mm-dd format (passing a date of 2011-1-1 will return all records from the beginning of the year)
			program_sponsor 
			token (the token is <provided upon request>)
			---------------------------------------------------------------
			Accessing this will return one tab delimited string per training completion record generated on or after date that will have the following five fields in this order:
			course name
			person_id
			date completed
			passed or failed
			score
			***************************************************************************************************/	
			
			var vTrainCasterURL = "https://doslocalcoordinatortraining.traincaster.com/app/clients/doslocalcoordinatortraining/Training_Recs.pm";
			var vProgramSponsor = "";
			var vTrainCasterToken = "";
			
			// Make sure we have a valid date
			if ( NOT isDate(ARGUMENTS.date) ) {
				ARGUMENTS.date = DateFormat(now(), 'yyyy-dd-mm');	
			}
			
			// Make sure we have a valid Company
			if ( NOT VAL(ARGUMENTS.companyID) ) {
				ARGUMENTS.companyID = CLIENT.companyID;			 
			}

			// ISE
			if ( ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID) ) {
				vProgramSponsor = "International Student Exchange";	
				vTrainCasterToken = "VtGxtRJTV33nVK2qZk8H";
			// CASE
			} else if ( ARGUMENTS.companyID EQ 10 ) {
				vProgramSponsor = "CULTURAL ACADEMIC STUDENT EXCHANGE, INC.";
				vTrainCasterToken = "Q8FKFmpFvzPZJX7jVSnn";
			}

			/* create new http service */ 
		    vHTTPService = new http(); 			

			/* set attributes using implicit setters */ 
			vHTTPService.setMethod("post"); 
			vHTTPService.setCharset("utf-8"); 
			vHTTPService.setUrl(vTrainCasterURL); 
			
			/* add httpparams using addParam() */ 
			vHTTPService.addParam(type="formfield",name="token",value=vTrainCasterToken); 
			vHTTPService.addParam(type="formfield",name="program_sponsor",value=vProgramSponsor); 
			vHTTPService.addParam(type="formfield",name="date",value=ARGUMENTS.date); 
			
			/* make the http call to the URL using send() */ 
			vResult = vHTTPService.send().getPrefix(); 
			
			/* process the filecontent returned */  //Transform list result to array | Chr(10) --> line break
			vArray = listToArray(vResult.filecontent,chr(10)); 

			// Loop Through Rows | Chr(9) --> tab
            for (row = 1; row <= arrayLen(vArray); row++) {
                
				// Default Values
                vCourseName = '';
                vPersonID = '';
                vDateCompleted = '';
                vPassedOrFailed = '';
                vScore = '';
                
                // Loop Through Columns - chr(9) Tab Delimited List
                for (col = 1; col <= listLen(vArray[row], Chr(9)); col++) { 
				
                    switch (col) {
                        
                        case 1:
                            vCourseName = listGetAt(vArray[row], col, chr(9));
                        break;
    
                        case 2:
                            vPersonID = listGetAt(vArray[row], col, chr(9));
                        break;
    
                        case 3:
                            vDateCompleted = listGetAt(vArray[row], col, chr(9));
                        break;
    
                        case 4:
                            vPassedOrFailed = listGetAt(vArray[row], col, chr(9));
                        break;
    
                        case 5:
                            vScore = listGetAt(vArray[row], col, chr(9));
                        break;
                        
                    }
                    
                }
                
                if ( VAL(vPersonID) AND isDate(vDateCompleted) AND isNumeric(vScore) ) {
                
                    // Insert Training
                    insertTraining(
                        userID=vPersonID,
						companyID=ARGUMENTS.companyID,
                        trainingID=2,
                        dateTrained=vDateCompleted,
                        score=vScore
                    );
                
                }
                
            }
			
			// ISE
			if ( ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID) ) {
				return "<p>ISE - Traincaster Test Results - Total of #arrayLen(vArray)# records</p>";
			// CASE
			} else if ( ARGUMENTS.companyID EQ 10 ) {
				return "<p>CASE - Traincaster Test Results - Total of #arrayLen(vArray)# records</p>";
			} else {
				return "<p>No Company - Traincaster Test Results - Total of #arrayLen(vArray)# records</p>";
			}
        </cfscript>
        
	</cffunction>
	<!--- ------------------------------------------------------------------------- ----
		
		End of User Training
	
	----- ------------------------------------------------------------------------- --->
    

	<!--- ------------------------------------------------------------------------- ----
		
		Start of Student Services Project
	
	----- ------------------------------------------------------------------------- --->
    
	<cffunction name="getStudentServices" access="public" returntype="query" output="false" hint="Gets a list of problem records for a studentID">
    	<cfargument name="studentID" default="0" hint="studentID is not required">
              
        <cfquery 
			name="qGetInitialProblem" 
			datasource="#APPLICATION.dsn#">
                SELECT
					sp.idServicesProject,
                    sp.studentID,
                    sp.problemID,
                    sp.info,
                    sp.file,
                    sp.userID,
                    sp.date,
                    sp.summary,
                    sp.fk_idServicesProjectType,
                    st.firstname,
                    st.familylastname,
                    u.firstname as userFirst,
                    u.lastname as userLast                    
                FROM 
                    services_project sp
                LEFT JOIN smg_users u on u.userid = sp.userid
                LEFT JOIN smg_students st on st.studentid = sp.studentid
                WHERE
                    sp.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
                
		</cfquery>
		   
		<cfreturn qGetInitialProblem>
	</cffunction>

	<!--- ------------------------------------------------------------------------- ----
		
		End of Student Services Project
	
	----- ------------------------------------------------------------------------- --->

    
	<!--- ------------------------------------------------------------------------- ----
		
		Start of Remote Functions
	
	----- ------------------------------------------------------------------------- --->

    <cffunction name="getUsersAssignedToRegion" access="remote" returntype="query" output="false" hint="Gets a list of users assigned to a region">
    	<cfargument name="regionID" hint="regionID required">
    	
        <cfscript>
			// This is the query that is returned
			qResultQuery = QueryNew("userID, userInformation");
			
			if ( NOT VAL(ARGUMENTS.regionID) ) { 
			
				// Not a valid region ID
				QueryAddRow(qResultQuery);
				QuerySetCell(qResultQuery, "userID", 0);
				QuerySetCell(qResultQuery, "userInformation", 'Please Select a Region');	
				return qResultQuery;
				
			}		
		</cfscript>
        
        <cfquery 
			name="qGetUsersAssignedToRegion" 
			datasource="#APPLICATION.dsn#">
                SELECT DISTINCT
                    u.userID,
                    CONCAT(u.firstName, ' ', u.lastName, ' [', ut.shortUserType, ']' ) AS userInformation
                FROM 
                    smg_users u
				INNER JOIN                    
                    user_access_rights uar ON uar.userID = u.userID 
                    	AND 
                        	uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#"> 
						AND
                        	uar.userType IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7" list="yes"> )                            
                INNER JOIN 
                    smg_userType ut ON ut.userTypeID = uar.userType
                WHERE 
                    u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">                        
                ORDER BY 
                    uar.userType,
                    u.lastName,
                    u.firstName
		</cfquery>
		 
        <cfscript>
			// Check if query returned data
			if ( qGetUsersAssignedToRegion.recordCount ) {
				
				// Insert blank first row
				QueryAddRow(qResultQuery);
				QuerySetCell(qResultQuery, "userID", 0);
				QuerySetCell(qResultQuery, "userInformation", 'Select an Area Rep.');
			
				For ( i=1; i LTE qGetUsersAssignedToRegion.recordCount; i=i+1 ) {
					QueryAddRow(qResultQuery);
					QuerySetCell(qResultQuery, "userID", qGetUsersAssignedToRegion.userID[i]);
					QuerySetCell(qResultQuery, "userInformation", qGetUsersAssignedToRegion.userInformation[i]);
				}
				
			} else {
			
				// Query did not return data - Set up proper response
				QueryAddRow(qResultQuery);
				QuerySetCell(qResultQuery, "userID", 0);
				QuerySetCell(qResultQuery, "userInformation", 'No Users Found');
			
			}
			
			// Return Query
			return qResultQuery;	
		</cfscript>
	</cffunction>

	<!--- ------------------------------------------------------------------------- ----
		
		End of Remote Functions
	
	----- ------------------------------------------------------------------------- --->
    
</cfcomponent>