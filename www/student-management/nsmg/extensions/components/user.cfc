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
    	<cfargument name="userID" default="" hint="userID is not required">
    	<cfargument name="usertype" default="0" hint="usertype is not required">
        <cfargument name="isActive" default="" hint="isActive is not required">
        <cfargument name="companyID" default="" hint="CompanyID is not required">
              
        <cfquery 
			name="qGetUsers" 
			datasource="#APPLICATION.DSN#">
                SELECT DISTINCT
					u.*
                FROM 
                    smg_users u
                INNER JOIN
                	user_access_rights uar ON uar.userID = u.userID
					<cfif VAL(ARGUMENTS.usertype)>
                        AND	
                            uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.usertype#">
                    </cfif>
    
                    <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID)>
                        AND          
                            uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                    <cfelseif VAL(ARGUMENTS.companyID)>
                        AND          
                            uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                    </cfif>
                WHERE
                	1 = 1

				<cfif LEN(ARGUMENTS.userID)>
                	AND	
                    	u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
                </cfif>
                    
                <cfif LEN(ARGUMENTS.isActive)>
                	AND
                    	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.isActive)#">
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
    	<cfargument name="userID" default="" hint="userID is required">
    	<cfargument name="uniqueID" default="" hint="uniqueID is required">

        <cfquery 
			name="qGetUserByID" 
			datasource="#APPLICATION.DSN#">
                SELECT
					*
                FROM 
                    smg_users
                WHERE	
					<cfif LEN(ARGUMENTS.userID)>                
	                    userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
    				<cfelseif LEN(ARGUMENTS.uniqueID)>
	                    uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.uniqueID#">
                    <cfelse>
                    	1 != 1
                    </cfif>                                                   
		</cfquery>
		   
		<cfreturn qGetUserByID>
	</cffunction>


	<cffunction name="isOfficeUser" access="public" returntype="boolean" output="No" hint="Returns true or false">
        <cfargument name="userType" type="numeric" default="#VAL(CLIENT.userType)#" required="no" hint="Usertype is not required" />
        
		<cfscript>
			// Check if current logged in User is office user
			if ( listFind("1,2,3,4", ARGUMENTS.userType) ) {
				// Office User
				return true;  
			} else {
				// Not an office user
				return false;	
			}
		</cfscript>
	</cffunction>
    

	<cffunction name="isRegionalManager" access="public" returntype="boolean" output="No" hint="Returns true or false">
        <cfargument name="userType" type="numeric" default="#VAL(CLIENT.userType)#" required="no" hint="Usertype is not required" />
        
		<cfscript>
			// Check if current logged in User is office user
			if ( ARGUMENTS.userType EQ 5 ) {
				// Regional Manager
				return true;  
			} else {
				// Not a Regional Manager
				return false;	
			}
		</cfscript>
	</cffunction>
    
    
	<cffunction name="isUserSecondVisitRepresentativeOnly" access="public" returntype="boolean" output="No" hint="Returns true or false if user has only second visit access">
        <cfargument name="userID" type="numeric" hint="userID is required" />
        <cfargument name="companyID" type="numeric" hint="companyID is required" />

        <cfquery 
			name="qGetUserAccess" 
			datasource="#APPLICATION.DSN#">
				SELECT
                    userType
                FROM	
                	user_access_rights
                WHERE
                	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID)>
                    AND          
                        companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelseif VAL(ARGUMENTS.companyID)>
                    AND          
                        companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                </cfif>
                GROUP BY
                	userType
        </cfquery>
        
		<cfscript>
			vIsSecondVisitRepOnly = true;
			
			// Loop Through Access Level
			for ( i=1; i LTE qGetUserAccess.recordCount; i=i+1 ) {
				
				// Check if user has a different access level
				if ( qGetUserAccess.userType[i] NEQ 15 ) {
					vIsSecondVisitRepOnly = false;
				}
				
			}
			
			return vIsSecondVisitRepOnly;
		</cfscript>
        
	</cffunction>
    


    <!--- ------------------------------------------------------------------------- ----
		START OF USER SESSION
	----- ------------------------------------------------------------------------- --->

	<cffunction name="setUserSession" access="public" returntype="void" output="false" hint="Set USER Session Variables">
		<cfargument name="userID" default="#CLIENT.userID#" hint="User ID">
        
        <cfscript>
			// Get Candidate Information
			qGetUserInfo = getUsers(userID=VAL(ARGUMENTS.userID));
		
			// New Struct
			SESSION.USER = StructNew();
			
			// User Information
			SESSION.USER.ID = qGetUserInfo.userID;
			SESSION.USER.firstName = qGetUserInfo.firstName;
			SESSION.USER.lastName = qGetUserInfo.lastName;
			SESSION.USER.fullName = qGetUserInfo.firstName & " " & qGetUserInfo.lastName;
			SESSION.USER.dateLastLoggedIn = qGetUserInfo.lastLogin;
			SESSION.USER.email = qGetUserInfo.email;
			
			SESSION.USER.paperworkSkipAllowed = false;
			
			// Path Information - set up upload files path
			SESSION.USER.myUploadFolder = APPLICATION.PATH.users & ARGUMENTS.userID & "/";
			
			// Make sure folder exists
			if ( VAL(SESSION.USER.ID) ) {			
				APPLICATION.CFC.UDF.createFolder(getUserSession().myUploadFolder);
			}
			
			// Relative Path
			SESSION.USER.myRelativeUploadFolder = "uploadedfiles/users/#ARGUMENTS.userID#/";
		</cfscript>
		
	</cffunction>


	<cffunction name="getUserSession" access="public" returntype="struct" hint="Get user SESSION variables" output="no">

        <cfscript>
			try {
				
				// Check if USER structure exits
				if ( StructIsEmpty(SESSION.USER) ) {
					// Set Session
					setUserSession();
				}
				
			} catch (Any e) {
				// Set Session
				setUserSession();
			}
			
			// Make Sure Structs are not empty
			return SESSION.USER;
		</cfscript>
        
	</cffunction>


	<cffunction name="setUserSessionRoles" access="public" returntype="void" output="false" hint="Set User SESSION roles">
        <cfargument name="userID" default="#CLIENT.userID#" hint="User ID">
             
        <cfquery 
			name="qGetUserRoles" 
			datasource="#APPLICATION.DSN#">
                SELECT
                	alup.fieldKey,
                    alup.fieldID,
                    alup.name,
                    alup.isActive,
                    surJN.userID
                FROM
                	applicationLookUp alup                
                LEFT OUTER JOIN
                	smg_users_role_JN surJN ON alup.fieldID = surJN.roleID
                    AND
                    	surJN.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
                WHERE
                	alup.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="userRole">	
                AND
                	alup.isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		</cfquery>
        
        <cfscript>
			// Set SESSION.ROLES
			SESSION.ROLES = StructNew();
			
			// Loop Through Roles
			for ( i=1; i LTE qGetUserRoles.recordCount; i=i+1 ) {
				
				// Check if user has roles
				if ( VAL(qGetUserRoles.userID[i]) ) {
					// Set Roles
					SESSION.ROLES[qGetUserRoles.name[i]] = true;
				} else {
					// Set Not Allowed
					SESSION.ROLES[qGetUserRoles.name[i]] = false;
				}
				
			}
		</cfscript>
		
	</cffunction>
    
    
    <!--- Rename to hasUserSessionRoleAccess --->
	<cffunction name="hasUserRoleAccess" access="public" returntype="boolean" output="false" hint="Returns 1/0 depeding on user access">
	    <cfargument name="userID" default="#CLIENT.userID#" hint="User ID">
    	<cfargument name="role" type="string" hint="role is required">
		
        <cfscript>
			var vRoleAccess = 0;
			
			try {
				// Check if roles do not exist
				if ( StructIsEmpty(SESSION.ROLES) ) {
					// Set Roles
					setUserSessionRoles();
				}
			} catch (Any e) {
				// Set Roles
				setUserSessionRoles();
			}
			
			try {
				// Get Role Access
				return SESSION.ROLES[ARGUMENTS.role];
			} catch (Any e) {
				// Error
				return false;	
			}
		</cfscript>
		
	</cffunction>
	

	<cffunction name="setUserSessionPaperwork" access="public" returntype="void" output="false" hint="Copies paperwork struct to SESSION">
		<cfargument name="userID" default="#CLIENT.userID#" hint="User ID">
        
        <cfscript>
			// New Struct
			SESSION.USER.PAPERWORK = StructNew();
			
			// Copy Paperwork to Session Scope
			SESSION.USER.PAPERWORK = getUserPaperwork(userID=VAL(ARGUMENTS.userID));
		</cfscript>
		
	</cffunction>
    
    
	<cffunction name="getUserSessionPaperwork" access="public" returntype="struct" hint="Get user SESSION paperwork variables" output="no">

        <cfscript>
			try {
				
				// Check if PAPERWORK structure exits
				if ( StructIsEmpty(SESSION.USER.PAPERWORK) ) {
					// Set Session
					setUserSessionPaperwork();
				}
				
			} catch (Any e) {
				// Set Session
				setUserSessionPaperwork();
			}
			
			// Make Sure Structs are not empty
			return SESSION.USER.PAPERWORK;
		</cfscript>
        
	</cffunction>
    

    <!--- ------------------------------------------------------------------------- ----
		END OF USER SESSION
	----- ------------------------------------------------------------------------- --->


	<cffunction name="getUserPaperwork" access="public" returntype="struct" output="false" hint="Returns a strcut with a complete paperwork information for a user">
        <cfargument name="userID" hint="User ID is Required">

        <cfscript>
			// New Struct
			var stUserPaperwork = StructNew();
			
			// Get User Information
			var qGetUser = getUsers(userID=ARGUMENTS.userID);
			
			// Get User CBC
			var qGetUserCBC = APPLICATION.CFC.CBC.getCBCUserByID(userID=ARGUMENTS.userID,cbcType='user');
			stUserPaperwork.cbcDateExpired = DateFormat(qGetUserCBC.date_expired, 'mm/dd/yyyy');

			// Get Current Season
			var qGetCurrentSeason = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason();

			// Get Paperwork Info (CBC, Agreement, Training)
			var qGetSeasonPaperwork = APPLICATION.CFC.USER.getSeasonPaperwork(userID=ARGUMENTS.userID, seasonID=qGetCurrentSeason.seasonID);

			// Get Reference - 4 Required / Not based on season
			var qGetReferences = APPLICATION.CFC.USER.getReferencesByID(userID=ARGUMENTS.userID);	

			// Get Employment History - 1 Required / Not based on season
			var qGetEmployment = APPLICATION.CFC.USER.getEmploymentByID(userID=ARGUMENTS.userID);		

			// Check if user is a second visit rep
			var vIsSecondVisitRepOnly = isUserSecondVisitRepresentativeOnly(userID=ARGUMENTS.userID,companyID=CLIENT.companyID);
			stUserPaperwork.isSecondVisitRepresentative = vIsSecondVisitRepOnly;

			// DOS Certification
			var stDOSCertification = APPLICATION.CFC.USER.isDOSCertificationValid(userID=ARGUMENTS.userID);
			stUserPaperwork.isDOSCertificationCompleted = stDOSCertification.isDOSCertificationValid;
			stUserPaperwork.dosDateExpired = stDOSCertification.dateExpired;

			// Set Current Season Information
			stUserPaperwork.seasonID = qGetCurrentSeason.seasonID;
			stUserPaperwork.paperworkStartDate = DateFormat(qGetCurrentSeason.paperworkStartDate, "mm/dd/yyyy");
			stUserPaperwork.paperworkRequiredDate = DateFormat(qGetCurrentSeason.paperworkRequiredDate, "mm/dd/yyyy");
			stUserPaperwork.paperworkEndDate = DateFormat(qGetCurrentSeason.paperworkEndDate, "mm/dd/yyyy");

			// Set if we'll force paperwork
			if ( now() GTE qGetCurrentSeason.paperworkRequiredDate ) {
				stUserPaperwork.isPaperworkRequired = true;
			} else {
				stUserPaperwork.isPaperworkRequired = false;
			}	
			
			// Signed Agreement
			if ( isDate(qGetSeasonPaperwork.ar_agreement) ) {
				stUserPaperwork.isAgreementCompleted = true;
			} else {
				stUserPaperwork.isAgreementCompleted = false;
			}

			// Signed CBC Authorization
			if ( isDate(qGetSeasonPaperwork.ar_cbc_auth_form) ) {
				stUserPaperwork.isCBCAuthorizationCompleted = true;
			} else {
				stUserPaperwork.isCBCAuthorizationCompleted = false;
			}
			
			// Check if CBC is valid
			if ( isDate(qGetUserCBC.date_expired) AND qGetUserCBC.date_expired GTE dateFormat(now(), 'yyyy/mm/dd') ) {
				stUserPaperwork.isCBCValid = true;
			} else {
				stUserPaperwork.isCBCValid = false;
			}
			
			// CBC Approved
			if ( stUserPaperwork.isCBCValid AND isDate(qGetUserCBC.date_approved) ) {
				stUserPaperwork.isCBCApproved = true;
			} else {
				stUserPaperwork.isCBCApproved = false;
			}

			// Employment History - Minimum of 1
			if ( qGetEmployment.recordCount GTE 1 AND ( NOT VAL(qGetUser.prevOrgAffiliation) OR ( qGetUser.prevOrgAffiliation EQ 1 AND LEN(qGetUser.prevAffiliationName) ) ) ) {
				stUserPaperwork.isEmploymentHistoryCompleted = true;
			} else {
				stUserPaperwork.isEmploymentHistoryCompleted = false;
			}

			// References - Minimum of 4
			if ( qGetReferences.recordCount GTE 4 ) {
				stUserPaperwork.isReferenceCompleted = true;
			} else {
				stUserPaperwork.isReferenceCompleted = false;
			}
			stUserPaperwork.missingReferences = 4 - qGetReferences.recordcount;
			
			// Training - New Area Rep or Area Rep Refresher
			if ( isDate(qGetSeasonPaperwork.ar_training) ) {
				stUserPaperwork.isTrainingCompleted = true;
			} else {
				stUserPaperwork.isTrainingCompleted = false;
			}
			
			
			/***** 
				webEX trainings are not ready to go live, set them as true until we are ready
				Marcus Melo 09/18/2012
			******/			
			stUserPaperwork.isTrainingCompleted = true;
			/***** 
				webEX trainings are not ready to go live, set them as true until we are ready
				Marcus Melo 09/18/2012
			******/			
			

			// Reference Questionnaire - Minimum of 2
			if ( isDate(qGetSeasonPaperwork.ar_ref_quest1) AND isDate(qGetSeasonPaperwork.ar_ref_quest2) ) { 
				stUserPaperwork.isReferenceQuestionnaireCompleted = true;
			} else { 
				stUserPaperwork.isReferenceQuestionnaireCompleted = false;
			}
			
			// 2nd Visit - Only Agreement and CBC - No References, employment history, trainings and DOS test
			if ( vIsSecondVisitRepOnly ) {
				stUserPaperwork.isReferenceCompleted = true;
				stUserPaperwork.isReferenceQuestionnaireCompleted = true;
				stUserPaperwork.isEmploymentHistoryCompleted = true;
				stUserPaperwork.isTrainingCompleted = true;
				stUserPaperwork.isDOSCertificationCompleted = true;
			}
			
			// ESI - Only Agreement and CBC - No References, employment history, trainings and DOS test
			if ( CLIENT.companyID EQ APPLICATION.SETTINGS.COMPANYLIST.ESI ) {
				stUserPaperwork.isReferenceCompleted = true;
				stUserPaperwork.isEmploymentHistoryCompleted = true;
				stUserPaperwork.isReferenceQuestionnaireCompleted = true;
				stUserPaperwork.isTrainingCompleted = true;
				stUserPaperwork.isDOSCertificationCompleted = true;
			}
			
			// Check if ALL Paperwork have been submitted by the user
			if ( 	
					stUserPaperwork.isAgreementCompleted 
				AND 
					stUserPaperwork.isCBCAuthorizationCompleted 
				AND	
					stUserPaperwork.isDOSCertificationCompleted 
				AND 
					stUserPaperwork.isEmploymentHistoryCompleted 
				AND 
					stUserPaperwork.isReferenceCompleted 
				AND 
					stUserPaperwork.isTrainingCompleted
				) {
					
					// User Has Submitted All Required Paperwork
					stUserPaperwork.isPaperworkCompleted = true;
					
					// Check if references and CBC have been approved by PM
					if ( stUserPaperwork.isReferenceQuestionnaireCompleted AND stUserPaperwork.isCBCApproved ) {
						// Paperwork compliant
						stUserPaperwork.isAccountCompliant = true;
						// Paperwork has been reviewed, set to false so notification is not sent out
						stUserPaperwork.isAccountReadyForReview = false;
					} else {
						// Paperwork not compliant
						stUserPaperwork.isAccountCompliant = false;
						// Paperwork has ready for review, set to true so email is sent out
						stUserPaperwork.isAccountReadyForReview = true;
					}
					
			} else {
				
				// User Has Not Submitted All Required Paperwork
				stUserPaperwork.isPaperworkCompleted = false;
				// Set Account as non compliant
				stUserPaperwork.isAccountCompliant = false;
				// set notification to false email is not sent out
				stUserPaperwork.isAccountReadyForReview = false;
				
			}
			
			return stUserPaperwork;
		</cfscript>
		
	</cffunction>


	<cffunction name="getUserRoleByID" access="public" returntype="query" output="false" hint="Gets a list of user roles by ID">
    	<cfargument name="userID" default="" hint="userID is required">
    	<cfargument name="uniqueID" default="" hint="uniqueID is required">

        <cfquery 
			name="qGetUserRoleByID" 
			datasource="#APPLICATION.DSN#">
                SELECT 
                    u.useriD,
                    u.firstName,
                    u.lastName,
                    alup.name
                FROM
                	smg_users_role_JN surJN
				INNER JOIN   
                    smg_users u ON surJN.userID = u.userID
                INNER JOIN
                	applicationLookup alup on alup.fieldID = surJN.roleID                
                	AND
                    	alup.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="userRole">
                WHERE	
					<cfif LEN(ARGUMENTS.userID)>                
	                    userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
    				<cfelseif LEN(ARGUMENTS.uniqueID)>
	                    uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.uniqueID#">
                    <cfelse>
                    	1 != 1
                    </cfif>                                                   
		</cfquery>
		   
		<cfreturn qGetUserByID>
	</cffunction>


    <!--- ------------------------------------------------------------------------- ----
		User Notifications
	----- ------------------------------------------------------------------------- --->
	
	<!--- Get Season Paperwork --->
	<cffunction name="getSeasonPaperwork" access="public" returntype="query" output="false" hint="Gets season paperwork by userID">
    	<cfargument name="userID" default="" hint="userID is not required">
        <cfargument name="seasonID" default="#APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID#" hint="seasonID is required">
		<cfargument name="getAllRecords" default="0" hint="Set to true to get all seasons">
        
        <cfquery 
			name="qGetSeasonPaperwork" 
			datasource="#APPLICATION.DSN#">
                SELECT
                	sup.paperworkID,
                    sup.userID,
                    sup.seasonID,
                    sup.fk_companyID,
                    sup.ar_info_sheet,
                    sup.ar_ref_quest1,
                    sup.ar_ref_quest2,
                    sup.ar_cbc_auth_form,
                    sup.ar_agreement,
                    sup.ar_training,
                    sup.secondVisit,
                    sup.agreeSig,
                    sup.cbcSig,
                    ss.years,
                    ss.paperworkStartDate,
                    ss.paperworkEndDate
                FROM 
                    smg_users_paperwork sup
                LEFT OUTER JOIN
                	smg_seasons ss ON ss.seasonID = sup.seasonID
                WHERE 
                    sup.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
                
				<cfif NOT VAL(ARGUMENTS.getAllRecords)>                
                    AND
                        sup.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">
                </cfif>
                
				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISE, CLIENT.companyID)>
                    AND          
                        sup.fk_companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
                <cfelse>
                    AND          
                        sup.fk_companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                </cfif>
                
                ORDER BY
                	sup.seasonID DESC
        </cfquery>
        
        <cfreturn qGetSeasonPaperwork>
	</cffunction>


	<cffunction name="updateSeasonPaperwork" access="public" returntype="void" output="false" hint="Update User Paperwork">
    	<cfargument name="userID" default="" hint="userID is not required">
        <cfargument name="seasonID" default="#APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID#" hint="seasonID is required">
        <cfargument name="fieldName" hint="fieldName is required">
        <cfargument name="fieldValue" hint="fieldValue is required">

        <cfscript>
			// Check if we have a season paperwork record
			qGetSeasonPaperwork = getSeasonPaperwork(userID=ARGUMENTS.userID,seasonID=ARGUMENTS.seasonID);
			
			// Check if we are updating a date or string field
			vDateFieldList = "ar_info_sheet,ar_ref_quest1,ar_ref_quest2,ar_cbc_auth_form,ar_agreement,ar_training";
			
			vStringFieldList = "agreeSig,cbcSig";
			
			vListofFields = vDateFieldList & "," & vStringFieldList;
		</cfscript>
        
		<!--- Check if we have a valid field to update --->
        <cfif ListFind(vListofFields, ARGUMENTS.fieldName) AND qGetSeasonPaperwork.recordCount>
            
            <!--- Update ---> 
            <cfquery 
                datasource="#APPLICATION.DSN#">
                    UPDATE
                        smg_users_paperwork
                    SET
						<!--- Date Field --->
                        <cfif ListFind(vListofFields, ARGUMENTS.fieldName)>
                            #ARGUMENTS.fieldName# = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.fieldValue#" null="#NOT IsDate(ARGUMENTS.fieldValue)#">
                        <!--- String Field --->
                        <cfelse>
                            #ARGUMENTS.fieldName# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.fieldValue#">
                        </cfif>
                    WHERE
                        paperworkID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetSeasonPaperwork.paperworkID#">
            </cfquery>

        <cfelseif ListFind(vListofFields, ARGUMENTS.fieldName)>
        
            <!--- Insert ---> 
            <cfquery 
                datasource="#APPLICATION.DSN#">
                    INSERT INTO
                        smg_users_paperwork
                    (
                        userID,
                        seasonID,
                        fk_companyID,
                        #ARGUMENTS.fieldName#
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">,
                        <!--- Date Field --->
                        <cfif ListFind(vListofFields, ARGUMENTS.fieldName)>
                            <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.fieldValue#" null="#NOT IsDate(ARGUMENTS.fieldValue)#">
                        <!--- String Field --->
                        <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.fieldValue#">
                        </cfif>
                    )
            </cfquery>
        
        </cfif>
        
	</cffunction>
    
    
	<!--- Get References --->
	<cffunction name="getReferencesByID" access="public" returntype="query" output="false" hint="Gets references by userID">
    	<cfargument name="userID" default="" hint="userID is not required">
        <cfargument name="refID" default="" hint="refID is not required">

        <cfquery 
			name="qGetReferencesByID" 
			datasource="#APPLICATION.DSN#">
                SELECT 
                   refID,
                   firstName,
                   lastName,
                   address,
                   address2,
                   city,
                   state,
                   zip,
                   phone,
                   email,
                   relationship,
                   howLong,
                   referenceFor,
                   season,
                   approved
                FROM 
                    smg_user_references
                WHERE
                	1 = 1
                    
                <cfif LEN(ARGUMENTS.userID)>                 
                    AND
                    	referenceFor = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
                </cfif>
                    
                <cfif LEN(ARGUMENTS.refID)>                 
                    AND
                    	refID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.refID)#">
                </cfif>
        </cfquery>

        <cfreturn qGetReferencesByID>
	</cffunction>
    
    
	<!--- Get Employment History --->
	<cffunction name="getEmploymentByID" access="public" returntype="query" output="false" hint="Gets references by ID">
    	<cfargument name="userID" default="" hint="userID is not required">
        <cfargument name="employmentID" default="" hint="userID is not required">

        <cfquery 
			name="qGetEmploymentByID" 
			datasource="#APPLICATION.DSN#">
                SELECT
                	employmentID,
                    fk_userID,
                    occupation,
                    employer,
                    address,
                    address2,
                    city,
                    state,
                    zip,
                    daysWorked,
                    hoursDay,
                    phone,
                    current,
                    datesEmployed
                FROM 
                    smg_users_employment_history
                WHERE 
                    1 = 1
 				
                <cfif LEN(ARGUMENTS.userID)>                 
                    AND
                    	fk_userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.employmentID)>                 
                    AND
                    	employmentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.employmentID)#">
                </cfif>
        </cfquery>

        <cfreturn qGetEmploymentByID>
	</cffunction>


	<cffunction name="paperworkReceivedNotification" access="public" returntype="void" output="false" hint="Sends out an email notification when users fill out paperwork">
        <cfargument name="userID" hint="User ID is Required">

		<cfscript>
			// Get User Details
			var qGetUser = getUsers(userID=ARGUMENTS.userID);
			
			var stGetPaperwork = getUserPaperwork(userID=ARGUMENTS.userID);
			
			var vEmailMessage = '';
			var vEmailSubject = "Paperwork Submitted for #qGetUser.firstName# #qGetUser.lastName# (###qGetUser.userID#)";
        </cfscript>
    
        <cfif VAL(stGetPaperwork.isAccountReadyForReview) AND isValid("email", CLIENT.programmanager_email)>
    
            <cfsavecontent variable="vEmailMessage">
            
                <cfoutput>				
                    The references and all other paperwork appear to be in order for #qGetUser.firstName# #qGetUser.lastName# (###qGetUser.userID#)).  
                    A manual review is now required to activate the account.  
                    Please review all paperwork and submit the CBC for processing. If everything looks good, approval of the CBC will activate this account.  
            
                    <br /><br />
            
                    <a href="#CLIENT.exits_url#/nsmg/index.cfm?curdoc=user_info&userID=#qGetUser.userID#">View #qGetUser.firstname#<cfif Right(qGetUser.firstname, 1) EQ 's'>'<cfelse>'s</cfif> account.</a>
                </cfoutput>
                
            </cfsavecontent>
    
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#CLIENT.programmanager_email#"> 
                <cfinvokeargument name="email_from" value="#CLIENT.emailfrom# (#CLIENT.companyshort# Support)">
                <cfinvokeargument name="email_subject" value="#vEmailSubject#">
                <cfinvokeargument name="email_message" value="#vEmailMessage#">
            </cfinvoke>
    
        </cfif>
	</cffunction>

    <!--- ------------------------------------------------------------------------- ----
		End of User Notifications
	----- ------------------------------------------------------------------------- --->


	<cffunction name="getFacilitators" access="public" returntype="query" output="false" hint="Gets a list of facilitators assigned to a region">
        <cfargument name="isActive" default="1" hint="isActive is not required">

        <cfquery 
			name="qGetFacilitators" 
			datasource="#APPLICATION.DSN#">
               	SELECT
					u.*
				FROM
                	smg_users u
                INNER JOIN
                	smg_regions r ON r.regionFacilitator = u.userID
						AND
                        	subOfRegion = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
					<cfif CLIENT.companyID EQ 5>
                        AND          
                            r.company IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
                    <cfelse>
                        AND          
                            r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                    </cfif>
                            
				<cfif LEN(ARGUMENTS.isActive)>
                	WHERE
                    	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.isActive#">
                </cfif>
               	
                GROUP BY 
                	u.userID
               	ORDER BY
                	u.firstName
			</cfquery>
		   
		<cfreturn qGetFacilitators>
	</cffunction>


	<cffunction name="getIntlRepresentatives" access="public" returntype="query" output="false" hint="Gets a list of intl. representatives assigned to active students">
        <cfargument name="isActive" default="1" hint="isActive is not required">

        <cfquery 
			name="qGetIntlRepresentatives" 
			datasource="#APPLICATION.DSN#">
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
                                s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
                        <cfelse>
                            AND          
                                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
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
			datasource="#APPLICATION.DSN#">
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
              
        <cfquery 
			name="qGetUserAccessRights" 
			datasource="#APPLICATION.DSN#">
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

				<cfif VAL(ARGUMENTS.userID)>
                	AND
                    	uar.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                </cfif>                  
                    
				<cfif VAL(ARGUMENTS.regionID)>
                	AND
                    	uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
                </cfif>   

				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    AND          
                        uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelseif VAL(CLIENT.companyID)>
                    AND          
                        uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
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

			// Get view user access				
			qViewUserAccess = getUserAccessRights(userID=ARGUMENTS.viewUserID, regionID=ARGUMENTS.currentRegionID);

			// Allow Access to office users, users seeing their own information, advisors seeing their own users and regional managers
			if ( listFind("1,2,3,4", ARGUMENTS.currentUserType) OR ARGUMENTS.currentUserID EQ ARGUMENTS.viewUserID OR ARGUMENTS.currentUserID EQ qViewUserAccess.advisorID OR ( ARGUMENTS.currentUserType EQ 5 AND ARGUMENTS.currentRegionID EQ qViewUserAccess.regionID ) ) {
				allowAccess = true;
			}
		</cfscript>
        
        <cfreturn allowAccess>
	</cffunction>


	<cffunction name="hasLoggedInUserComplianceAccess" access="public" returntype="numeric" output="false" hint="Returns 0 or 1">
              
        <cfquery 
			name="qHasLoggedInUserComplianceAccess" 
			datasource="#APPLICATION.DSN#">
                SELECT
					userID,
                    hasComplianceAccess
                FROM 
                    smg_users
                WHERE	
                    userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
		</cfquery>
		
        <cfscript>
			return VAL(qHasLoggedInUserComplianceAccess.hasComplianceAccess);
		</cfscript>
        
	</cffunction>


	<cffunction name="getRegionalManager" access="public" returntype="query" output="false" hint="Gets a regional manager for a given region">
        <cfargument name="regionID" type="numeric" default="0" hint="regionID is required">
              
        <cfquery 
			name="qGetRegionalManager" 
			datasource="#APPLICATION.DSN#">
                SELECT 
                	u.userID,
                    u.firstName,
                    u.middleName,
                    u.lastName,
                    u.email,
                    u.fax,
                    u.phone,
                    u.work_phone,
                    u.address,
                    u.address2,
                    u.city,
                    u.state,
                    u.zip,
                    r.regionName
                FROM 
                	smg_users u
                INNER JOIN 
                	user_access_rights uar ON u.userID = uar.userID
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
        <cfargument name="regionID" default="0" hint="regionID is not required">
        <cfargument name="regionIDList" default="" hint="List of Region IDs">
        <cfargument name="is2ndVisitIncluded" default="0" type="numeric" hint="is2ndVisitIncluded is not required">
        <cfargument name="includeUserIDs" default="" hint="area reps will be able to see themselves and current assigned users on the list">
        
        <!--- Office Users --->
        <cfif ListFind("1,2,3,4", ARGUMENTS.userType)>
            
            <!--- Get all users for a specific region --->
            <cfquery 
                name="qGetSupervisedUsers" 
                datasource="#APPLICATION.DSN#">
                    SELECT DISTINCT
                        u.*
                    FROM 
                    	smg_users u
                    INNER JOIN 
                    	user_access_rights uar ON uar.userID = u.userID
                    WHERE 
                    	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    AND 
                    	uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
           			
					<cfif VAL(ARGUMENTS.regionID)>
                        AND
                            uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
                	</cfif>
                    
					<cfif LEN(ARGUMENTS.regionIDList)>
                        AND
                           uar.regionid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionIDList#" list="yes"> )
                	</cfif>
                    
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
                    
                    GROUP BY
                    	u.userID                        

                    ORDER BY 
                    	u.lastname,
                        u.firstName
            </cfquery>

		<cfelse>
        
            <cfquery 
                name="qGetSupervisedUsers" 
                datasource="#APPLICATION.DSN#">
                    SELECT DISTINCT
                        u.*
                    FROM 
                    	smg_users u
                    INNER JOIN 
                    	user_access_rights uar ON uar.userID = u.userID
                    WHERE 
                    	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    AND
                    	u.accountCreationVerified != <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                                            
					<cfif VAL(ARGUMENTS.regionID)>
                        AND
                            uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
                	</cfif>
                    
					<cfif LEN(ARGUMENTS.regionIDList)>
                        AND
                           uar.regionid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionIDList#" list="yes"> )
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
					
                    <!--- Include Current Placing/Supervising representatives Assigned to student --->
                    <cfif LEN(ARGUMENTS.includeUserIDs)>
                    	OR
                            u.userID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.includeUserIDs#" list="yes"> )
                    </cfif>

                    GROUP BY
                    	u.userID
                    
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
			datasource="#APPLICATION.DSN#">
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
                datasource="#APPLICATION.DSN#">
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
                    rep.agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
                
				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID)>
                    AND          
                        rep.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelseif VAL(ARGUMENTS.companyID)>
                    AND          
                        rep.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
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
			datasource="#APPLICATION.DSN#">
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
                    smg_companies c ON c.companyID = rep.companyID
                WHERE 
                    rep.agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
				AND
                	s.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">  
                    
				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID)>
                    AND          
                        rep.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelseif VAL(ARGUMENTS.companyID)>
                    AND          
                        rep.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
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
			datasource="#APPLICATION.DSN#">
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
        <cfargument name="seasonID" default="" hint="seasonID is not required">
        <cfargument name="trainingID" default="" hint="trainingID is not required">
        <cfargument name="hasPassed" default="1" hint="hasPassed is not required">

        <cfquery 
			name="qGetTraining" 
			datasource="#APPLICATION.DSN#">
                SELECT DISTINCT
					sut.id,
                    sut.user_id,
                    sut.office_user_id,
                    sut.training_id,
                    sut.season_id,
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
                    sut.user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
                AND
                	has_passed = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.hasPassed)#">
                
				<cfif LEN(ARGUMENTS.seasonID)>
                    AND
                        season_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">
                </cfif>
                
				<cfif LEN(ARGUMENTS.trainingID)>
                    AND
                        training_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.trainingID)#">
                </cfif>
                
                ORDER BY 
                    sut.date_created
		</cfquery>
		   
		<cfreturn qGetTraining>
	</cffunction>


	<cffunction name="isDOSCertificationValid" access="public" returntype="struct" output="false" hint="Returns a structure">
    	<cfargument name="userID" hint="userID is required">
		
        <cfquery 
			name="qIsDOSCertificationValid" 
			datasource="#APPLICATION.DSN#">
                SELECT DISTINCT
					id,
                    date_trained,
                    DATE_ADD(date_trained, INTERVAL 11 MONTH) AS dateExpired
                FROM 
                    smg_users_training sut
                WHERE
                    user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISE, CLIENT.companyID)>
                    AND          
                        company_ID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
                <cfelse>
                    AND          
                        company_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                </cfif>
                AND
                	has_passed = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                AND
                    training_id = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                AND
                	DATE_ADD(date_trained, INTERVAL 11 MONTH) >= NOW()
                ORDER BY
                	dateExpired DESC
				LIMIT 1                                        
		</cfquery>
        
        <cfscript>
			vReturnStruct = StructNew();			
		
			if ( qIsDOSCertificationValid.recordCount )  {
				vReturnStruct.dateExpired = DateFormat(qIsDOSCertificationValid.dateExpired, 'mm/dd/yyyy');
				vReturnStruct.isDOSCertificationValid = true;
			} else {
				vReturnStruct.dateExpired = "";
				vReturnStruct.isDOSCertificationValid = false;
			}
			
			return vReturnStruct;
		</cfscript>
        
	</cffunction>


	<cffunction name="getExpiringTraining" access="public" returntype="query" output="false" hint="Gets a list of training expiring within 30 days">
    	<cfargument name="companyID" hint="companyID is required">
        <cfargument name="trainingID" default="2" hint="DOS Certification">

        <cfquery 
			name="qGetExpiringTraining" 
			datasource="#APPLICATION.DSN#">
                SELECT
                	userID,
                    userInformation,
                    email,
                    regionID,
                    dateExpired
				FROM
                (                    
                    SELECT DISTINCT
                        u.userID,
                        CONCAT(u.firstName, ' ', u.lastName) AS userInformation,
                        u.email,
                        uar.regionID,
                        <!--- Get Latest Training --->                
                        (
                            SELECT 
                                DATE_ADD(sut.date_trained, INTERVAL 11 MONTH)
                            FROM 
                                smg_users_training sut
                            WHERE 
                                u.userID = sut.user_ID 
                            AND	
                                sut.training_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.trainingID#">
                            AND
                                sut.has_passed = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                            ORDER BY 
                                date_trained DESC
                            LIMIT 1                            
                        ) AS dateExpired
                    FROM 
                        smg_users u                   				 
                    INNER JOIN	
                        user_access_rights uar ON uar.userID = u.userID
                        <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID)>
                            AND          
                                uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                        <cfelseif VAL(ARGUMENTS.companyID)>
                            AND          
                                uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                        </cfif>
                    INNER JOIN
                        smg_users_training su ON su.user_ID = u.userID
                            AND	
                                su.training_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.trainingID#">
                            AND
                                su.has_passed = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
					WHERE
                    	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">                                
				) AS t
                
                WHERE
                	CURRENT_DATE >= dateExpired                               
                ORDER BY 
                    userInformation
		</cfquery>
		   
		<cfreturn qGetExpiringTraining>
	</cffunction>


	<cffunction name="insertTraining" access="public" returntype="void" output="false" hint="Inserts a training. UserID must be passed.">
        <cfargument name="userID" hint="userID is required">
        <cfargument name="companyID" default="#CLIENT.companyID#" hint="companyID is required">
        <cfargument name="officeUserID" default="0" hint="officeUserID is not required">
        <cfargument name="trainingID" hint="trainingID is required">
        <cfargument name="dateTrained" hint="dateTrained is required">
        <cfargument name="score" default="0.00" hint="score is not required">
        
        <cfscript>
			// Set Default Value
			var hasPassed = 1;
			
            // Set a default value for ARGUMENTS.score
            if ( NOT LEN(ARGUMENTS.score) ) {
            	ARGUMENTS.score = '0.00';
            }	
			
			// DOS Certification - Score >= 27 to pass
			if ( ARGUMENTS.trainingID EQ 2 AND ARGUMENTS.SCORE < 90 ) {
				hasPassed = 0;
			}
			
			// Copy New Area Reps or Area Rep. Refresher trainings to current smg_users_paperwork
			if ( listFind("6,10", ARGUMENTS.trainingID) ) {
				updateSeasonPaperwork(userID=ARGUMENTS.userID,fieldName="ar_training",fieldValue=ARGUMENTS.dateTrained);
				
				//Check if we need to send out a notification to the program manager - Only accounts that needs review / depending on the order of people submitting things, we have to check
				paperworkReceivedNotification(userID=ARGUMENTS.userID);

			}
		</cfscript>	
		
        <cfquery 
            name="qInsertTraining" 
            datasource="#APPLICATION.DSN#">
                INSERT INTO 
                    smg_users_training
                (
                    user_id,
                    company_id,
                    office_user_id,
                    training_id,
                    season_id,
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
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID)#">,
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
		
        <cfscript>
			if ( ARGUMENTS.userID EQ CLIENT.userID ) {
				// Update User Session Paperwork
				APPLICATION.CFC.USER.setUserSessionPaperwork();
			}
		</cfscript>
        
	</cffunction>


	<cffunction name="reportTrainingByRegion" access="public" returntype="query" output="false" hint="Gets a list of training records by region">
    	<cfargument name="regionID" default="" hint="List of region IDs">
        <cfargument name="trainingID" default="0" hint="Training ID is not required">
        <cfargument name="userID" default="" hint="userID is not required">
        <cfargument name="userType" default="" hint="userType is not required">
        <cfargument name="programID" default="" hint="programID is not required">
        
        <cfquery 
			name="qReportTrainingByRegion" 
			datasource="#APPLICATION.DSN#">
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
			datasource="#APPLICATION.DSN#">
                SELECT 
                    u.userID,
                    u.firstName,
                    u.lastName,
                    u.email,
                    u.dateCreated,
                    uar.advisorID,
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
                            	(
                                	uar.advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                                OR
                                    u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                              	)
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
			datasource="#APPLICATION.DSN#">
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
                    	u.accountCreationVerified != <cfqueryparam cfsqltype="cf_sql_integer" value="0">     
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
    	<cfargument name="uniqueID" type="string" hint="uniqueID is required">
		
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
            qGetUserInfo = getUserByID(uniqueID=ARGUMENTS.uniqueID);
            
            var vTrainCasterURL = "http://doslocalcoordinatortraining.traincaster.com/app/clients/doslocalcoordinatortraining/Login.pm";
			var vProgramSponsor = "";
            var vTrainCasterPassword = "";
			
			// CASE
			if ( CLIENT.companyID EQ 10 ) {
				vProgramSponsor = "CULTURAL ACADEMIC STUDENT EXCHANGE, INC.";
				vTrainCasterPassword = "45RdPmWVrZtG6TCkSxVBbmkxPnqq2cr6Q3zJtSMp";
			// ISE
			} else if ( ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID) ) {
				vProgramSponsor = "International Student Exchange";	
				vTrainCasterPassword = "ZG2qK3vJgTHkhbSxQ6nxH273NKVS5T7Dwztm5k4B";
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
			datasource="#APPLICATION.DSN#">
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
                LEFT JOIN smg_users u on u.userID = sp.userID
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
			datasource="#APPLICATION.DSN#">
                SELECT DISTINCT
                	u.userID,
                    (
                        CASE                     
                            WHEN 
                                u.businessName != '' 
                            THEN 
                                CAST( CONCAT(u.lastName, ', ', u.firstName, ' (##', u.userID, ') - ', u.businessName ) AS CHAR) 
                            ELSE
                                CAST( CONCAT(u.lastName, ', ', u.firstName, ' (##', u.userID, ')' ) AS CHAR)                                    
                        END
                    ) AS displayName                      
                FROM 
                	smg_users u
                INNER JOIN
                	user_access_rights uar ON uar.userID = u.userID
					<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID)>
                        AND          
                            uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                    <cfelseif VAL(ARGUMENTS.companyID)>

                        AND          
                            uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                    </cfif>
                WHERE 
                   
					<cfif IsNumeric(ARGUMENTS.searchString)>
                    	u.userID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.searchString#%">
                    <cfelse>
                            u.lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.searchString#%">
                        OR
                            u.firstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.searchString#%">
                        OR
                            u.businessName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.searchString#%">
					</cfif>				
                    
                ORDER BY 
                    u.lastName,
                    u.firstName
				LIMIT 
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.maxRows#" />                 
        </cfquery>

		<cfscript>
			// Loop through query
            For ( i=1; i LTE qRemoteLookUpUser.recordCount; i=i+1 ) {

				vUserStruct = structNew();
				vUserStruct.userID = qRemoteLookUpUser.userID[i];
				vUserStruct.displayName = qRemoteLookUpUser.displayName[i];
				
				ArrayAppend(vReturnArray,vUserStruct);
            }
			
			return vReturnArray;
        </cfscript>

    </cffunction>

    
	<cffunction name="getIntlRepRemote" access="remote" returnFormat="json" output="false" hint="Gets a list of Intl. Reps. assigned to a candidate">
		<cfargument name="programID" default="" hint="Get Intl. Reps. Based on a list of program ids">
        
        <cfscript>
			// Check if it's an array (function is sending an array)
			if ( IsArray(ARGUMENTS.programID) ) {
				ARGUMENTS.programID = ArrayToList(ARGUMENTS.programID);
			} else if ( ARGUMENTS.programID EQ 'NULL' ) {
				ARGUMENTS.programID = '';	
			}
		</cfscript>
        
        <cfquery 
			name="qGetIntlRepRemote" 
			datasource="#APPLICATION.DSN#">
                SELECT
					u.userID,
                    u.businessName
                FROM 
                    smg_users u
                INNER JOIN
                	smg_students s ON s.intRep = u.userID
                WHERE
                    s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                AND
                	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                <cfif LEN(ARGUMENTS.programID)>
                	AND	
                    	s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#" list="yes"> )
                </cfif>
                GROUP BY
                	u.userID
                ORDER BY
                	u.businessName
		</cfquery>

        <cfscript>
			return SerializeJson(qGetIntlRepRemote,true);
		</cfscript>
	</cffunction>    


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
			datasource="#APPLICATION.DSN#">
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