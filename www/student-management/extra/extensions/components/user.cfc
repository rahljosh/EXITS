<!--- ------------------------------------------------------------------------- ----
	
	File:		user.cfc
	Author:		Marcus Melo
	Date:		August 19, 2010
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
    	<cfargument name="usertype" default="0" hint="usertype is not required">
        <cfargument name="isActive" default="1" hint="isActive is not required">
        <cfargument name="getAll" default="1" hint="getAll is not required. Set to 0 to get only users that are assigned to candidates">
		       
        <cfquery 
			name="qGetUsers" 
			datasource="#APPLICATION.DSN.Source#">
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
                
                <cfif LEN(ARGUMENTS.isActive)>
                	AND
                    	active = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isActive#">
                </cfif>
                
                <cfif NOT VAL(ARGUMENTS.getAll)>
                	AND
                    	userID IN 	
                        ( 
                            SELECT
                                intRep
                            FROM
                                extra_candidates
                            WHERE
                                companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                            GROUP BY
                                intRep
                        )                                                
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

	
    <!--- Remote --->
	<cffunction name="getIntlRepRemote" access="remote" returntype="array" output="false" hint="Gets a list of Intl. Reps. assigned to a candidate">
		<cfargument name="programID" default="0" hint="Get Intl. Reps. Based on a list of program ids">
        
        <cfscript>
			// Define variables
        	var qGetIntlRepRemote='';
			var result=ArrayNew(2);
			var i=0;
        </cfscript>
               
        <cfquery 
			name="qGetIntlRepRemote" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					u.userID,
                    u.businessName
                FROM 
                    smg_users u
                INNER JOIN
                	extra_candidates c ON c.intRep = u.userID
                WHERE
                    c.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
                <cfif ARGUMENTS.programID NEQ 0>
                	AND	
                    	c.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#" list="yes"> )
                </cfif>
                GROUP BY
                	u.userID
                ORDER BY
                	u.businessName
		</cfquery>

        <cfscript>
			// Add default value
			result[1][1]=0;
			result[1][2]="---- All - Total of " & qGetIntlRepRemote.recordCount & " International Representatives ----" ;

			// Convert results to array
			For (i=1;i LTE qGetIntlRepRemote.Recordcount; i=i+1) {
				result[i+1][1]=qGetIntlRepRemote.userID[i];
				result[i+1][2]=qGetIntlRepRemote.businessName[i];
			}
			
			return result;
		</cfscript>
	</cffunction>


	<cffunction name="getVerificationDate" access="remote" returntype="query" output="false" hint="Gets a list of Intl. Reps. assigned to a candidate">
        <cfargument name="intRep" default="0">
        <cfargument name="programID" default="0" hint="Get Intl. Reps. Based on a list of program ids">

        <cfquery 
			name="qGetVerificationDate" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
                	DATE_FORMAT(verification_received, '%Y/%m/%e') as verificationReceived,                
                    DATE_FORMAT(verification_received, '%m/%e/%Y') as verificationReceivedDisplay
                FROM 
                    extra_candidates
                WHERE 
                    companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
                AND 
                    verification_received IS NOT NULL
                <cfif VAL(ARGUMENTS.intRep)>
                    AND
                        intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.intRep#">
                </cfif>
                <cfif ARGUMENTS.programID NEQ 0>
                	AND	
                    	programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#" list="yes"> )
                </cfif>
                GROUP BY 
                    verification_received
                ORDER BY 
                    verification_received DESC
		</cfquery>

        <cfscript>
			// Return message to user
			if ( NOT VAL(qGetVerificationDate.recordCount) ) {
				QueryAddRow(qGetVerificationDate, 1);
				QuerySetCell(qGetVerificationDate, "verificationReceived", 0, 1);
				QuerySetCell(qGetVerificationDate, "verificationReceivedDisplay", "---- No Verification Dates Found ----", 1);
			} 
			
			return qGetVerificationDate;
		</cfscript>
	</cffunction>
    <!--- End Of Remote --->


	<cffunction name="getUserByID" access="public" returntype="query" output="false" hint="Gets a user by ID">
    	<cfargument name="userID" type="numeric" hint="userID is required">
              
        <cfquery 
			name="qGetUserByID" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					*
                FROM 
                    smg_users
                WHERE	
                    userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
		</cfquery>
		   
		<cfreturn qGetUserByID>
	</cffunction>


	<cffunction name="getUserByUniqueID" access="public" returntype="query" output="false" hint="Gets a user by uniqueID">
    	<cfargument name="uniqueID" type="string" hint="uniqueID is required">
              
        <cfquery 
			name="qGetUserByUniqueID" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					*
                FROM 
                    smg_users
				<cfif LEN(ARGUMENTS.uniqueID)>                    
                    WHERE
                        uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.uniqueID#">
                <cfelse>
                    WHERE
                        1 != 1
                </cfif> 
		</cfquery>
		   
		<cfreturn qGetUserByUniqueID>
	</cffunction>


	<cffunction name="getUserAccessRights" access="public" returntype="query" output="false" hint="Gets user access rights for a user or region">
    	<cfargument name="userID" type="numeric" default="0" hint="userID is required">
        <cfargument name="companyID" type="numeric" default="0" hint="companyID is required">
              
        <cfquery 
			name="qGetUserAccessRights" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					uar.id,
                    uar.userID,
                    uar.companyID,
                    uar.regionID,
                    uar.userType,
                    uar.advisorID,
                    uar.default_region,
                    uar.default_access,
                    uar.changeDate
                FROM 
                    user_access_rights uar
                WHERE
                    uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">

				<cfif VAL(ARGUMENTS.userID)>
                	AND
                    	uar.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                </cfif>                  
                    
				ORDER BY
                	uar.default_access DESC                               
		</cfquery>
		   
		<cfreturn qGetUserAccessRights>
	</cffunction>


	<cffunction name="insertUserAccessRights" access="public" returntype="void" output="false" hint="Inserts User Access Rights">
    	<cfargument name="userID" type="numeric" default="0" hint="userID is required">
        <cfargument name="userType" type="numeric" default="8" hint="userType is required">
        
        <cfquery 
			datasource="#APPLICATION.DSN.Source#">
                INSERT INTO
                    user_access_rights
				(
                	userID,
                    companyID,
                    userType,
                    changeDate
                )
                VALUES 
                (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">,
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">,
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userType#">,
                	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )                    
		</cfquery>
		   
	</cffunction>

	
    <!--- Grant Access --->
	<cffunction name="grantAccess" access="public" returntype="void" output="false" hint="Check user credentials">
		<cfargument name="userID" required="yes" hint="Username is requireds" />
        <cfargument name="userType" required="yes" hint="userType is requireds" />
		        
        <cfscript>
			// Get User Information
			qUserInfo = getUserByID(userID=ARGUMENTS.userID);
			
			setUsername = qUserInfo.username;
			setPassword = qUserInfo.password;
			
			// Check if user has access to extra			
			qCheckAccess = getUserAccessRights(
				userID=ARGUMENTS.userID,
				companyID=CLIENT.companyID
			);
			
			if ( NOT qCheckAccess.recordCount ) {
				
				// Check if there is a username, if not, copy from email address
				if ( NOT LEN(qUserInfo.username) ) {
					
					setUsername = qUserInfo.email;
					
					// Update User Information
					updateUsername(
						userID=ARGUMENTS.userID, 
						username=setUsername
					);
					
				}
				
				// Check if there is a password, if not, generate a password
				if ( NOT LEN(qUserInfo.password) ) {
					
					setPassword = APPLICATION.CFC.ONLINEAPP.generatePassword();					
					
					// Update User Information
					updatePassword(
						userID=ARGUMENTS.userID, 
						password=setPassword
					);
					
				}
				
				// Grant Access
				insertUserAccessRights(
					userID=ARGUMENTS.userID,
					companyID=CLIENT.companyID,
					userType=ARGUMENTS.userType
									   
				);
			}
			
			// Send out Email Confirmation
			APPLICATION.CFC.EMAIL.sendEmail(
				emailTo=qUserInfo.email,
				emailTemplate='userGrantAccess',
				userID=ARGUMENTS.userID
			);
		</cfscript>
                
	</cffunction>


	<!--- Authenticate User --->
	<cffunction name="authenticateUser" access="public" returntype="query" output="false" hint="Check user credentials">
		<cfargument name="username" required="yes" hint="Username is requireds" />
		<cfargument name="password" required="yes" hint="Password is required">
        
		<cfquery 
			name="qAuthenticateUser" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT 
                    u.userID,
                    u.firstName,
                    u.lastName,
                    u.lastLogin,
                    u.userType,
                    u.email,
                    uar.companyID
                FROM 
                    smg_users u 
                INNER JOIN
                    user_access_rights uar ON uar.userID = u.userID
                INNER JOIN
                    smg_companies c ON c.companyID = uar.companyID
                WHERE 
                    u.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.username)#"> 
                AND 
                    u.password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.password)#">
                AND 
                    u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND   
                    c.system_id = <cfqueryparam cfsqltype="cf_sql_integer" value="4">
                ORDER BY 
                    uar.default_region DESC
		</cfquery>
		
		<cfreturn qAuthenticateUser /> 
	</cffunction>


	<!--- Check Email Address --->
	<cffunction name="checkEmail" access="public" returntype="query" output="false" hint="Check if email exists - Forgot password">
		<cfargument name="email" required="yes" hint="Email Address" />
		<cfargument name="userID" default="0" hint="Pass userID if you are updating account">
        
		<cfquery 
			name="qCheckEmail" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					userID, 
                    firstName,
                    lastName,                    
                    email,
                    password
				FROM
					smg_users
				WHERE
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.email)#">
				AND
					active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                <cfif VAL(ARGUMENTS.userID)>
                	AND
                    	userID != <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.userID)#">
                </cfif> 
		</cfquery>
		
		<cfreturn qCheckEmail /> 
	</cffunction>


	<!--- Login --->
	<cffunction name="doLogin" access="public" returntype="void" hint="Logs in a user / sets client variables">
		<cfargument name="qUser" type="query" default="0">
        <cfargument name="updateDateLastLoggedIn" type="numeric" default="1">
		
        <cfscript>
			// Set up Session Variables
			SESSION.auth = structNew();
			
			// Set Up Client Variables
			CLIENT.isLoggedIn = 1;
			CLIENT.loginType = 'user';
			CLIENT.userID = ARGUMENTS.qUser.userID;
			CLIENT.firstName = ARGUMENTS.qUser.firstName;
			CLIENT.lastname =  ARGUMENTS.qUser.lastname;
			CLIENT.lastLogin = ARGUMENTS.qUser.lastLogin;
			CLIENT.userType =  ARGUMENTS.qUser.userType;
			CLIENT.email = ARGUMENTS.qUser.email;
			CLIENT.companyID = ARGUMENTS.qUser.companyID;
			
			// Record last logged in date
			if ( VAL(ARGUMENTS.updateDateLastLoggedIn) ) {
				updateLoggedInDate(userID=ARGUMENTS.qUser.userID);
			}
		</cfscript>
        
	</cffunction>


	<!--- Last Logged In Date --->
	<cffunction name="updateLoggedInDate" access="public" returntype="void" hint="Update last logged in date" output="no">
		<cfargument name="userID" type="numeric" default="0">
        
		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
            UPDATE 
                smg_users 
            SET 
                lastLogin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            WHERE 
                userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
        </cfquery>
        
	</cffunction>


	<!--- Update User Username --->
	<cffunction name="updateUsername" access="private" returntype="void" output="false" hint="Update User Username">
		<cfargument name="userID" required="yes" hint="userID ID" />
		<cfargument name="username" required="yes" hint="Email Address / Username">

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
                	smg_users
                SET
                    username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.username))#">
				WHERE
	                userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
		</cfquery>
		
	</cffunction>
    
    
    <!--- Update User Password --->
	<cffunction name="updatePassword" access="private" returntype="void" output="false" hint="Update User Password">
		<cfargument name="userID" required="yes" hint="userID ID" />
        <cfargument name="password" required="yes" hint="Password">

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
                	smg_users
                SET
                    password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.password))#">
				WHERE
	                userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
		</cfquery>

	</cffunction>

</cfcomponent>