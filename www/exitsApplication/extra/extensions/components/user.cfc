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
        <cfargument name="businessNameExists" default="0" hint="businessNameExists is not required">
        <cfargument name="companyID" default="0" hint="companyID is not required">
		       
        <cfquery 
			name="qGetUsers" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT *
                FROM smg_users
                <cfif VAL(ARGUMENTS.companyID)>
                	INNER JOIN extra_candidates ON extra_candidates.intRep = smg_users.userID
                    	AND extra_candidates.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                </cfif>
                WHERE 1 = 1
                    
				<cfif VAL(ARGUMENTS.usertype)>
                	AND usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.usertype#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.isActive)>
                	AND active = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.isActive)#">
                </cfif>
                
                <cfif VAL(ARGUMENTS.businessNameExists)>
                	AND businessname != ""
                </cfif>
                
                GROUP BY smg_users.userID
                
				<cfif VAL(ARGUMENTS.usertype)>
                    ORDER BY businessName                
                <cfelse>
                    ORDER BY lastName
                </cfif>
		</cfquery>
		   
		<cfreturn qGetUsers>
	</cffunction>

	<cffunction name="getIntlReps" access="public" returntype="query" output="no" hint="Gets a list of intl. reps">
    	<cfquery name="qGetIntlReps" datasource="#APPLICATION.DSN.Source#">
        	SELECT userID, businessName
        	FROM smg_users
        	WHERE userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        	AND businessName != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        	ORDER BY businessName
        </cfquery>
        <cfreturn qGetIntlReps>
    </cffunction>

	<cffunction name="getIntlRepAssignedToCandidate" access="public" returntype="query" output="false" hint="Gets a list of intl. reps that are assigned">

        <cfquery 
			name="qGetIntlRepAssignedToCandidate" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					u.*
                FROM 
                    smg_users u
                INNER JOIN
                	extra_candidates c ON c.intRep = u.userID
                WHERE
                    c.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
                AND	
                    c.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND
                	u.businessName != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                GROUP BY
                	u.userID
                ORDER BY
                	u.businessName
		</cfquery>

		<cfreturn qGetIntlRepAssignedToCandidate>
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

        <cfif NOT Val(#CLIENT.companyid#)>
        	<cfset companyId = 8 />
        <cfelse>
        	<cfset companyId = #CLIENT.companyid# />
        </cfif>

        <cfquery 
			name="qGetVerificationDate" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
                	DATE_FORMAT(verification_received, '%Y/%m/%e') as verificationReceived,                
                    DATE_FORMAT(verification_received, '%m/%e/%Y') as verificationReceivedDisplay
                FROM 
                    extra_candidates
                WHERE 
                    companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#companyId#">
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
                    u.email,
                    uar.userType,
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
    
    <!--- Auto Suggest --->
    <cffunction name="remoteLookUpUser" access="remote" returnFormat="json" output="false" hint="Remote function to get users, returns an array">
        <cfargument name="searchString" type="string" default="" hint="Search is not required">
        <cfargument name="maxRows" type="numeric" required="false" default="30" hint="Max Rows is not required" />
        <cfargument name="companyID" default="#CLIENT.companyID#" hint="CompanyID is not required">
        
        <cfscript>
			var vReturnArray = arrayNew(1);
		</cfscript>
        
        <!--- Do search --->
        <cfquery 
			name="qRemoteLookUpUser" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT DISTINCT
                	u.userID,
                    u.uniqueID,
                    (
                        CASE                     
                            WHEN 
                                u.businessName != '' 
                            THEN 
                                CAST( CONCAT(u.businessName, ' (##', u.userID, ') - ', u.lastName, ', ', u.firstName ) AS CHAR) 
                            ELSE
                                CAST( CONCAT(u.lastName, ', ', u.firstName, ' (##', u.userID, ')' ) AS CHAR)                                    
                        END
                    ) AS displayName                      
                FROM 
                	smg_users u
                INNER JOIN
                	user_access_rights uar ON uar.userID = u.userID
                WHERE 
                   	(u.usertype = 8 OR uar.usertype = 8)
					<cfif IsNumeric(ARGUMENTS.searchString)>
                    	AND u.userID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.searchString#%">
                    <cfelse>
                    	AND
                        (
                                u.lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.searchString#%">
                            OR
                                u.firstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.searchString#%">
                            OR
                                u.businessName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.searchString#%">
						)
					</cfif>				
                    
                ORDER BY 
                	u.businessname,
                    u.lastName,
                    u.firstName
				LIMIT 
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.maxRows#" />                 
        </cfquery>

		<cfscript>
			// Loop through query
            For ( i=1; i LTE qRemoteLookUpUser.recordCount; i=i+1 ) {

				vUserStruct = structNew();
				vUserStruct.uniqueID = qRemoteLookUpUser.uniqueID[i];
				vUserStruct.displayName = qRemoteLookUpUser.displayName[i];
				
				ArrayAppend(vReturnArray,vUserStruct);
            }
			
			return vReturnArray;
        </cfscript>

    </cffunction>


    <cffunction name="getMailTrackingIntReps" access="public" returntype="query" output="false" hint="Gets users with Mail Tracking">
    	<cfargument name="intRep" default="0">
        <cfargument name="programID" default="0" hint="Get Intl. Reps. Based on a list of program ids">
              
        <cfquery 
			name="qGetUsers" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT *
                FROM smg_users su
                INNER JOIN extra_mail_tracking emt ON (emt.user_id = su.userID)
                <cfif VAL(ARGUMENTS.intRep) AND VAL(ARGUMENTS.programID)>
                	WHERE userID = <cfqueryparam cfsqltype="cf_sql_int" value="#ARGUMENTS.intRep#">
                		AND emt.program_id = <cfqueryparam cfsqltype="cf_sql_int" value="#ARGUMENTS.programID#">
				<cfelseif VAL(ARGUMENTS.intRep)>                    
                    WHERE userID = <cfqueryparam cfsqltype="cf_sql_int" value="#ARGUMENTS.intRep#">
                <cfelseif VAL(ARGUMENTS.programID)>                    
                    WHERE emt.program_id = <cfqueryparam cfsqltype="cf_sql_int" value="#ARGUMENTS.programID#">
                </cfif> 
                GROUP BY userID
		</cfquery>
		   
		<cfreturn qGetUsers>
	</cffunction>

	<cffunction name="getMailTracking" access="public" returntype="query" output="false" hint="Gets a user with Mail Tracking">
    	<cfargument name="intRep" default="0">
    	<cfargument name="programID" default="0">
              
        <cfquery 
			name="qGetUser" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT *
                FROM smg_users su
                INNER JOIN extra_mail_tracking emt ON (emt.user_id = su.userID)
                WHERE userID = <cfqueryparam cfsqltype="cf_sql_int" value="#ARGUMENTS.intRep#">
                	<cfif VAL(programID)>
                		AND emt.program_id = <cfqueryparam cfsqltype="cf_sql_int" value="#ARGUMENTS.programID#">
                	</cfif>
		</cfquery>
		   
		<cfreturn qGetUser>
	</cffunction>

	<cffunction name="setMailTracking" access="remote" returntype="void" hint="Set new Mail Tracking">
    	<cfargument name="userID" default="0">
    	<cfargument name="programID" default="0">
    	<cfargument name="ds2019date" default="0">
    	<cfargument name="date" default="">
    	<cfargument name="tracking" default="">
    	<cfargument name="extra_cost" default="0.00">
              
        <cfquery 
			name="setNewMailTracking" 
			datasource="#APPLICATION.DSN.Source#"> 
                INSERT INTO
                    extra_mail_tracking
				(
                	user_id,
                	program_id,
                    date,
                    tracking,
                    extra_cost,
                    ds2019_date
                )
                VALUES 
                (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">,
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">,
                	<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(ARGUMENTS.date, 'yyyyy-mm-dd')#">,
                	<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.tracking#">,
                	<cfqueryparam cfsqltype="cf_sql_decimal" scale="2" value="#ARGUMENTS.extra_cost#">,
                	<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(ARGUMENTS.ds2019date, 'yyyyy-mm-dd')#">
                	
                )  
		</cfquery>


		<cfquery 
			name="qGetUser" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT email,
                		businessName
                FROM smg_users su
                WHERE userID = <cfqueryparam cfsqltype="cf_sql_int" value="#ARGUMENTS.userID#">
		</cfquery>

		<cfsavecontent variable="emailMessage" >
			<cfoutput>

			<p><strong>Dear #qGetUser.businessName#,</strong></p>

			<p>The visa documents for the participant(s) included on the <strong>DS verification Report</strong> batch <strong>#DateFormat(ARGUMENTS.ds2019date, 'mm/dd/yyyy')#</strong> have been successfully issued.</p>

			<p>The payment was received - thank you. The DHL tracking number for the package with the original documents is per below:</p>

			<p><a href="http://www.dhl.com">www.dhl.com</a><br />
			Tracking: #ARGUMENTS.tracking#</p>

			</cfoutput>
		</cfsavecontent>

		<cfscript>
			APPLICATION.CFC.EMAIL.sendEmail(
	            emailFrom="#APPLICATION.EMAIL.contactUs# (#CLIENT.firstName# #CLIENT.lastName# CSB-USA)",
	            emailTo='#qGetUser.email#',
				emailReplyTo=CLIENT.email,
	            emailSubject='SWT/CSB - New Mail Tracking',
				emailMessage=emailMessage,
	            companyID=CLIENT.companyID,
	            footerType='emailRegular',
				displayEmailLogoHeader=1
	        );	
        </cfscript>
		   
		
	</cffunction>


</cfcomponent>
