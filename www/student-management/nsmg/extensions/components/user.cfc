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

setUserSessionPaperwork
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
        <cfargument name="regionID" default="0" hint="regionID is not required">
              
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
                            uar.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.usertype#" list="yes"> )
                    </cfif>
                    <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID)>
                        AND          
                            uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                    <cfelseif VAL(ARGUMENTS.companyID)>
                        AND          
                            uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                    </cfif>
                    <cfif VAL(ARGUMENTS.regionID)>
                    	AND
                        	uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
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
			name="qGetUserInfoByID" 
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
		   
		<cfreturn qGetUserInfoByID>
	</cffunction>


	<cffunction name="getUserOneLevelUpInfo" access="public" returntype="struct" output="false" hint="Returns the next level up user, eg. RA next level is RM">
    	<cfargument name="currentUserType" type="string" default="">
    	<cfargument name="regionalAdvisorID" type="string" default="">
        
        <cfscript>
			// new structure
			var stFieldSet = StructNew();
			
            // Set Field Names
            switch ( ARGUMENTS.currentUserType ) {
                
                // Area Representative
                case 7: 
					
					// Next Level Regional Advisor
					if ( VAL(ARGUMENTS.regionalAdvisorID) ) {
						stFieldSet.userType = 6;
						stFieldSet.description = "Regional Advisor";
					// Next Level Regional Manager
					} else  {
						stFieldSet.userType = 5;
						stFieldSet.description = "Regional Manager";
					}

				break;
				
				// Regional Advisor
				case 6:
					// Next Level Regional Manager
					stFieldSet.userType = 5;
					stFieldSet.description = "Regional Manager";
				break;

				// Regional Manager
				case 5:
				case 4:
				case 3:
				case 2:
				case 1:
					// Next Level Regional Manager
					stFieldSet.userType = 4;
					stFieldSet.description = "Headquarters";
				break;

                // User Not Found - Default to lowest level
                default: 
					// Default Values - Lowest user type
					stFieldSet.userType = 7;
					stFieldSet.description = "Area Representative";
				break;
	
			}
			
			return stFieldSet;
		</cfscript>
		
	</cffunction>

	<cffunction name="isAdminUser" access="public" returntype="boolean" output="No" hint="Returns true or false">
        <cfargument name="userType" type="numeric" default="#VAL(CLIENT.userType)#" required="no" hint="Usertype is not required" />
        
		<cfscript>
			// Check if current logged in User is office user
			if ( listFind("1,2", ARGUMENTS.userType) ) {
				// Office User
				return true;  
			} else {
				// Not an office user
				return false;	
			}
		</cfscript>
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
			name="qGetUserInfoAccess" 
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
			for ( i=1; i LTE qGetUserInfoAccess.recordCount; i=i+1 ) {
				
				// Check if user has a different access level
				if ( qGetUserInfoAccess.userType[i] NEQ 15 ) {
					vIsSecondVisitRepOnly = false;
				}
				
			}
			
			return vIsSecondVisitRepOnly;
		</cfscript>
        
	</cffunction>
    
    
    <cffunction name="setClientInformation" access="public" returntype="void" output="no">
    	<cfargument name="userID" required="yes">
        
        <cfquery name="submitting_info" datasource="#APPLICATION.DSN#">
            SELECT 
            	website, 
                url_ref, 
                company_color
            FROM smg_companies
            WHERE companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyid)#">
        </cfquery>
        <cfscript>
			CLIENT.company_submitting = submitting_info.website;
			CLIENT.app_menu_comp = CLIENT.companyid;
			CLIENT.color = submitting_info.company_color;
			
			if ( APPLICATION.isServerLocal ) {
				CLIENT.exits_url = "http://" & submitting_info.url_ref;
			} else if ( CGI.HTTP_HOST EQ '204.12.118.245' ) { // go daddy remedy
				CLIENT.exits_url = "https://204.12.118.245";
			} else {
				CLIENT.exits_url = "https://" & submitting_info.url_ref;	
			}
			
			APPLICATION.company_short = submitting_info.website;
		</cfscript>
        <cfquery name="qGetUser" datasource="#APPLICATION.DSN#">
        	SELECT *
            FROM smg_users
            WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
        </cfquery>
        <cfquery name="qGetAccess" datasource="#APPLICATION.dsn#">
            SELECT uar.*
            FROM user_access_rights uar
            INNER JOIN smg_companies c ON c.companyid = uar.companyid
            WHERE c.website =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#CLIENT.company_submitting#">
            AND uar.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetUser.userID)#">
            ORDER BY uar.usertype
        </cfquery>
        <cfquery name="qGetDefaultAccess" dbtype="query">
            SELECT *
            FROM qGetAccess
            WHERE default_access = 1
        </cfquery>
		<cfif qGetDefaultAccess.recordcount EQ 0>
            <cfquery name="qGetDefaultAccess" dbtype="query" maxrows="1">
                SELECT *
                FROM qGetAccess
            </cfquery>
        </cfif>
        <cfquery name="qGetCompany" datasource="#APPLICATION.dsn#">
            SELECT companyname, team_id, pm_email, support_email, url, companyshort_nocolor, projectManager, financeEmail,website
            FROM smg_companies
            WHERE companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetDefaultAccess.companyid)#">
        </cfquery>        
    	<cfquery name="qGetUserType" datasource="#APPLICATION.dsn#">
            SELECT usertype
            FROM smg_usertype
            WHERE usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetDefaultAccess.usertype)#">
        </cfquery>
        <cfquery name="qGetCompanies" dbtype="query">
            SELECT DISTINCT companyid
            FROM qGetAccess
        </cfquery>
        
        <cfscript>
			CLIENT.thislogin = dateFormat(now(), 'mm/dd/yyyy');
		
			CLIENT.userID = qGetUser.userID;
			CLIENT.uniqueID = qGetUser.uniqueID;
			CLIENT.name = qGetUser.firstname & ' ' & qGetUser.lastname;
        	CLIENT.email = qGetUser.email;
			CLIENT.lastlogin = qGetUser.lastlogin;
			
			CLIENT.levels = qGetAccess.recordcount;
			CLIENT.companyid = qGetDefaultAccess.companyid;
			CLIENT.usertype = qGetDefaultAccess.usertype;
			CLIENT.regionid = qGetDefaultAccess.regionid;
			
			CLIENT.companies = valueList(qGetCompanies.companyid);
			
			if (CLIENT.usertype EQ 8) {
				CLIENT.parentcompany = qGetUser.userID;
			} else if (CLIENT.usertype EQ 9) {
				CLIENT.parentcompany = qGetUser.intrepid;
			}
			
			if ( CLIENT.companyID EQ 14 ) {
				CLIENT.DSFormName = "I-20";
			}
			
			if (NOT LEN(qGetUser.ssn) AND listfind('1,2,3,4,5,6,7', CLIENT.usertype)) {
				CLIENT.needsSSN = 1;
			}
			
			CLIENT.companyname = qGetCompany.companyname;
			CLIENT.companyshort = qGetCompany.companyshort_nocolor;
			CLIENT.programmanager = qGetCompany.team_id;
			CLIENT.programmanager_email = qGetCompany.pm_email;
			CLIENT.projectmanager_email = qGetCompany.projectManager;
			CLIENT.finance_email = qGetCompany.financeEmail;
			CLIENT.support_email = qGetCompany.support_email; 
			CLIENT.site_url = qGetCompany.url;
			
			CLIENT.accesslevelname = qGetUserType.usertype;
			
			if (CLIENT.usertype NEQ 11 AND (qGetUser.last_verification EQ '' OR dateDiff("d", qGetUser.last_verification, now()) GTE 90)) {
				CLIENT.verify_info = 1;
			}
			
			if (qGetUser.changepass EQ 1) {
				CLIENT.change_password = 1;
			}
		</cfscript>
        
		<cfif CLIENT.regionid NEQ ''>
            <cfquery name="qGetRegion" datasource="#APPLICATION.dsn#">
                SELECT regionname
                FROM smg_regions
                WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.regionid)#">
            </cfquery>
            <cfset CLIENT.accesslevelname = "#CLIENT.accesslevelname# in #qGetRegion.regionname#">
        </cfif>
        
    </cffunction>
    


    <!--- ------------------------------------------------------------------------- ----
		START OF USER SESSION
	----- ------------------------------------------------------------------------- --->

	<cffunction name="setUserSession" access="public" returntype="void" output="false" hint="Set USER Session Variables">
		<cfargument name="userID" default="0" hint="User ID">
        
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
			
			// Company Based Variables
			if ( APPLICATION.isServerlocal ) {
				
				// Local Environment
				SESSION.USER.companyURL = "http://smg.local/";
				SESSION.USER.hostApplicationURL = 'http://host.local/';
				SESSION.USER.emailSupport = 'support@student-management.com';
				SESSION.USER.emailCompliance = 'support@iseusa.org';
				
			} else { 
			
				// Production Environment
				SESSION.USER.companyURL = "https://#CGI.SERVER_NAME#/";
				if ( FindNoCase("case.exitsapplication.com", CGI.SERVER_NAME) ) {
					SESSION.USER.hostApplicationURL = 'http://www.case-usa.org/hostApplication/';
					SESSION.USER.emailSupport = 'support@case-usa.org';
					SESSION.USER.emailCompliance = 'jana@case-usa.org';
				} else {
					SESSION.USER.hostApplicationURL = 'https://www.iseusa.com/hostApplication/';
					SESSION.USER.emailSupport = 'support@iseusa.org';
					SESSION.USER.emailCompliance = 'complianceteam@iseusa.org';
				}
				
			}
			//SESSION.USER.defaultRegion = "";
			//SESSION.USER.userType = "";
			
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
					setUserSession(userID=VAL(CLIENT.userID));
				}
				
				// Param Session Variables so we don't get any errors with new ones
				param name="SESSION.USER.ID" default="";
				param name="SESSION.USER.firstName" default="";
				param name="SESSION.USER.lastName" default="";
				param name="SESSION.USER.fullName" default="";
				param name="SESSION.USER.dateLastLoggedIn" default="";
				param name="SESSION.USER.email" default="";
				param name="SESSION.USER.companyURL" default="";
				param name="SESSION.USER.hostApplicationURL" default="";
				param name="SESSION.USER.emailSupport" default="";
				param name="SESSION.USER.emailCompliance" default="";
				param name="SESSION.USER.paperworkSkipAllowed" default="false";
				param name="SESSION.USER.myUploadFolder" default="";

			} catch (Any e) {
				// Set Session
				setUserSession(userID=VAL(CLIENT.userID));
			}

			// Make Sure Structs are not empty
			return SESSION.USER;
		</cfscript>
        
	</cffunction>


	<cffunction name="setUserSessionRoles" access="public" returntype="void" output="false" hint="Set User SESSION roles">
        <cfargument name="userID" default="#CLIENT.userID#" hint="User ID">
             
        <cfquery 
			name="qGetUserInfoRoles" 
			datasource="#APPLICATION.DSN#">
                SELECT
                	alup.fieldKey,
                    alup.fieldID,
                    alup.name,
                    alup.isActive,
                    surJN.userID
                FROM
                	applicationlookup alup                
                LEFT OUTER JOIN
                	smg_users_role_jn surJN ON alup.fieldID = surJN.roleID
                    AND
                    	surJN.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
                WHERE
                	alup.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="userRole">	
                AND
                	alup.isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		</cfquery>
        
        <cfscript>
			// Set SESSION.USER.ROLES
			SESSION.USER.ROLES = StructNew();
			
			// Loop Through Roles
			for ( i=1; i LTE qGetUserInfoRoles.recordCount; i=i+1 ) {
				
				// Check if user has roles
				if ( VAL(qGetUserInfoRoles.userID[i]) ) {
					// Set Roles
					SESSION.USER.ROLES[qGetUserInfoRoles.name[i]] = true;
				} else {
					// Set Not Allowed
					SESSION.USER.ROLES[qGetUserInfoRoles.name[i]] = false;
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
				if ( StructIsEmpty(SESSION.USER.ROLES) ) {
					// Set Roles
					setUserSessionRoles();
				}
			} catch (Any e) {
				// Set Roles
				setUserSessionRoles();
			}
			
			try {
				// Get Role Access
				return SESSION.USER.ROLES[ARGUMENTS.role];
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
			
			/*****
				Reset Paperwork - REMOVE THIS LATER - 11/01/2012
			*****/
			setUserSessionPaperwork();
			
			// Make Sure Structs are not empty
			return SESSION.USER.PAPERWORK;
		</cfscript>
        
	</cffunction>
    

    <!--- ------------------------------------------------------------------------- ----
		END OF USER SESSION
	----- ------------------------------------------------------------------------- --->


	<cffunction name="getUserPaperwork" access="public" returntype="struct" output="false" hint="Returns a struct with a complete paperwork information for a user">
        <cfargument name="userID" hint="User ID is Required">

        <cfscript>			
			// Get User Information
			var qGetUserInfo = getUsers(userID=ARGUMENTS.userID);
			
			var vTodayDate = dateFormat(now(), 'mm/dd/yyyy');
			
			// New Struct
			var stUserPaperwork = StructNew();
			
			// Store User Information as well
			stUserPaperwork.user = StructNew();
			
			// Store User Information in Structure
			stUserPaperwork.user.ID = qGetUserInfo.userID;
			stUserPaperwork.user.displayName = qGetUserInfo.firstName & " " & qGetUserInfo.lastName & " (##" & qGetUserInfo.userID & ")";
			stUserPaperwork.user.email = qGetUserInfo.email;			
			stUserPaperwork.user.userType = "";
			/**** Set Default Values ****/
				
			// Set Paperwork as not Completed
			stUserPaperwork.isUserPaperworkCompleted = false;
			// Set Account as non compliant
			stUserPaperwork.isAccountCompliant = false;
			// Set which users need to be notified for account review
			stUserPaperwork.accountReviewStatus = "";

			// Get User CBC
			var qGetUserInfoCBC = APPLICATION.CFC.CBC.getCBCUserByID(userID=ARGUMENTS.userID,cbcType='user');
			stUserPaperwork.dateCBCExpired = DateFormat(qGetUserInfoCBC.date_expired, 'mm/dd/yyyy');

			// Get Current Season
			var qGetCurrentSeason = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason();
			
			// Get Paperwork Info (CBC, Agreement, Training)
			var qGetSeasonPaperwork = getSeasonPaperwork(userID=ARGUMENTS.userID, seasonID=qGetCurrentSeason.seasonID);

			// Get Reference - 4 Required / Not based on season
			var qGetReferences = getReferencesByID(userID=ARGUMENTS.userID);	

			// Get Employment History - 1 Required / Not based on season
			var qGetEmployment = getEmploymentByID(userID=ARGUMENTS.userID);		

			// Check if user is a second visit rep
			var vIsSecondVisitRepOnly = isUserSecondVisitRepresentativeOnly(userID=ARGUMENTS.userID,companyID=CLIENT.companyID);
			stUserPaperwork.user.isSecondVisitRepresentative = vIsSecondVisitRepOnly;
			
			// Set Current Season Information
			stUserPaperwork.season = structNew();
			stUserPaperwork.season.ID = qGetCurrentSeason.seasonID;
			stUserPaperwork.season.datePaperworkStarted = DateFormat(qGetCurrentSeason.datePaperworkStarted, "mm/dd/yyyy");
			stUserPaperwork.season.datePaperworkRequired = DateFormat(qGetCurrentSeason.datePaperworkRequired, "mm/dd/yyyy");
			stUserPaperwork.season.datePaperworkEnded = DateFormat(qGetCurrentSeason.datePaperworkEnded, "mm/dd/yyyy");
			stUserPaperwork.season.dateExtraPaperworkRequired = '';

			// Store Date Values
			stUserPaperwork.dateRMReviewNotified = DateFormat(qGetSeasonPaperwork.dateRMReviewNotified, "mm/dd/yyyy");
			stUserPaperwork.dateOfficeReviewNotified = DateFormat(qGetSeasonPaperwork.dateOfficeReviewNotified, "mm/dd/yyyy");
			stUserPaperwork.dateAccessGranted = DateFormat(qGetSeasonPaperwork.dateAccessGranted, "mm/dd/yyyy");


			// Training - New Area Rep or Area Rep Refresher
			var stUserTraining = isRequiredTrainingComplete(userID=ARGUMENTS.userID, seasonID=qGetCurrentSeason.seasonID);
			stUserPaperwork.isTrainingCompleted = stUserTraining.isTrainingCompleted;
			stUserPaperwork.dateTrained = stUserTraining.dateTrained;
			
			
			// DOS Certification
			var stDOSCertification = isDOSCertificationValid(userID=ARGUMENTS.userID);
			stUserPaperwork.isDOSCertificationCompleted = stDOSCertification.isDOSCertificationValid;
			stUserPaperwork.dateDOSTestExpired = stDOSCertification.dateExpired;
			

			// Set to true to force paperwork, to false to give an option to skip it
			if ( now() GTE qGetCurrentSeason.datePaperworkRequired ) {
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
			if ( isDate(qGetUserInfoCBC.date_expired) AND qGetUserInfoCBC.date_expired GTE dateFormat(now(), 'yyyy/mm/dd') ) {
				stUserPaperwork.isCBCValid = true;
			} else {
				stUserPaperwork.isCBCValid = false;
			}
			
			
			// CBC Approved
			if ( stUserPaperwork.isCBCValid AND isDate(qGetUserInfoCBC.date_approved) ) {
				stUserPaperwork.isCBCApproved = true;
			} else {
				stUserPaperwork.isCBCApproved = false;
			}


			// Employment History - Minimum of 1
			if ( qGetEmployment.recordCount GTE 1 AND ( NOT VAL(qGetUserInfo.prevOrgAffiliation) OR ( qGetUserInfo.prevOrgAffiliation EQ 1 AND LEN(qGetUserInfo.prevAffiliationName) ) ) ) {
				stUserPaperwork.isEmploymentHistoryCompleted = true;
			} else {
				stUserPaperwork.isEmploymentHistoryCompleted = false;
			}


			// References - Minimum of 4
			if ( qGetReferences.recordCount GTE 4 ) {
				stUserPaperwork.isReferenceCompleted = true;
				stUserPaperwork.missingReferences = 0;
			} else {
				stUserPaperwork.isReferenceCompleted = false;
				stUserPaperwork.missingReferences = 4 - qGetReferences.recordcount;
			}
			

			// Reference Questionnaire - Minimum of 2 - Phase out these two fields and use the reference table instead
			if ( isDate(qGetSeasonPaperwork.ar_ref_quest1) AND isDate(qGetSeasonPaperwork.ar_ref_quest2) ) { 
				stUserPaperwork.isReferenceQuestionnaireCompleted = true;
			} else { 
				stUserPaperwork.isReferenceQuestionnaireCompleted = false;
			}
			
			
			// Check if is a new or returning user based on number of paperwork seasons			
			qGetAllSeasonPaperwork = getSeasonPaperwork(userID=ARGUMENTS.userID, getAllRecords=1);

			// Set if user is returning or not
			if ( qGetAllSeasonPaperwork.recordCount GTE 2 ) {
				stUserPaperwork.isReturningUser = true;
			} else {
				stUserPaperwork.isReturningUser = false;
			}
			
			// Returning User 
			if ( stUserPaperwork.isReturningUser AND isDate(stUserPaperwork.season.datePaperworkRequired) ) {
				
				// Extra Period is 21 days from datePaperworkRequired
				// stUserPaperwork.season.dateExtraPaperworkRequired = DateFormat(DateAdd("d", 21, stUserPaperwork.season.datePaperworkRequired), 'mm/dd/yyyy');				

				/**** TEMPORARY SOLUTION ****/
				/* Return users - Set Reference Questionnaire to complete for now until we sort this out. |  New users need to have reference questionnaire */
				stUserPaperwork.season.dateExtraPaperworkRequired = "11/30/2012";
				stUserPaperwork.isReferenceQuestionnaireCompleted = true;
				/**** TEMPORARY SOLUTION ****/
				
			// New User
			} else if ( isDate(qGetUserInfo.dateCreated) ) {
				
				// Extra Period is 21 days from dateCreated
				stUserPaperwork.season.dateExtraPaperworkRequired = DateFormat(DateAdd("d", 21, qGetUserInfo.dateCreated), 'mm/dd/yyyy');	
				
			}
			

			// 2nd Visit - Only Agreement and CBC - No References, employment history, trainings and DOS Certification
			if ( vIsSecondVisitRepOnly ) {
				stUserPaperwork.isReferenceCompleted = true;
				stUserPaperwork.isReferenceQuestionnaireCompleted = true;
				stUserPaperwork.isEmploymentHistoryCompleted = true;
				stUserPaperwork.isTrainingCompleted = true;
				stUserPaperwork.isDOSCertificationCompleted = true;
			}
			
			
			// ESI - Only Agreement and CBC - No References, employment history, trainings and DOS Certification
			if ( CLIENT.companyID EQ APPLICATION.SETTINGS.COMPANYLIST.ESI ) {
				stUserPaperwork.isReferenceCompleted = true;
				stUserPaperwork.isEmploymentHistoryCompleted = true;
				stUserPaperwork.isReferenceQuestionnaireCompleted = true;
				stUserPaperwork.isTrainingCompleted = true;
				stUserPaperwork.isDOSCertificationCompleted = true;
			}
			// DASH - Only Agreement and CBC - No References, employment history, trainings and DOS Certification
			if ( CLIENT.companyID EQ APPLICATION.SETTINGS.COMPANYLIST.DASH ) {
				
				stUserPaperwork.isDOSCertificationCompleted = true;
				stUserPaperwork.isTrainingCompleted = true;
			}
			
			// Check if initial paperwork have been submitted by the user (Agreement, CBC Authorization, Employment History, References)
			if ( 	
					stUserPaperwork.isAgreementCompleted 
				AND 
					stUserPaperwork.isCBCAuthorizationCompleted 
				AND 
					stUserPaperwork.isEmploymentHistoryCompleted 
				AND 
					stUserPaperwork.isReferenceCompleted 
				) {
					
					// Allow Skip Paperwork if we are in the 21 extra days window and DOS Certification and/or Trainings are missing and we are in the 21 days window
					if ( vTodayDate LTE stUserPaperwork.season.dateExtraPaperworkRequired AND ( NOT stUserPaperwork.isDOSCertificationCompleted OR NOT stUserPaperwork.isTrainingCompleted ) ) {
						stUserPaperwork.isPaperworkRequired = false;
					}
					
					// Check if paperwork is complete ( DOS Certification and Training are also required )
					if ( stUserPaperwork.isDOSCertificationCompleted AND stUserPaperwork.isTrainingCompleted ) {
						// User Has Submitted All Required Paperwork
						stUserPaperwork.isUserPaperworkCompleted = true;
					}

					// Check if Reference Questionnaire and CBC have been approved - Account is Compliant
					if ( stUserPaperwork.isUserPaperworkCompleted AND stUserPaperwork.isReferenceQuestionnaireCompleted AND stUserPaperwork.isCBCApproved ) {
						
						// Paperwork compliant
						stUserPaperwork.isAccountCompliant = true;
					
					//  Check if Reference Questionnaire has been completed - Account Needs Office Review (CBC Approval)
					} else if ( NOT stUserPaperwork.isCBCApproved AND stUserPaperwork.isReferenceQuestionnaireCompleted ) {

						// Notify Office - Program Manager
						stUserPaperwork.accountReviewStatus = 'officeReview';
					
					// Check if Reference Questionnaire is missing, if so notify Regional Manager 
					} else if ( NOT stUserPaperwork.isReferenceQuestionnaireCompleted ) {
						
						// Notify Regional Manager
						stUserPaperwork.accountReviewStatus = 'rmReview';
										
					// Missing DOS Certification and training
					} else {
						
						// Missing DOS Certification and/or AR Training
						stUserPaperwork.accountReviewStatus = 'missingTraining';
						
					}
			
			}
			
			// SMG Canada does not require this paperwork, so make them compliant if this is on canada's site.
			if (CLIENT.companyID EQ 13) {
				stUserPaperwork.isUserPaperworkCompleted = true;
				stUserPaperwork.isAccountCompliant = true;
			}
			//bypass requierment right now. 
				//stUserPaperwork.isUserPaperworkCompleted = true;
				//stUserPaperwork.isAccountCompliant = true;
			return stUserPaperwork;
		</cfscript>
		
	</cffunction>


	<cffunction name="getUserRoleByID" access="public" returntype="query" output="false" hint="Gets a list of user roles by ID">
    	<cfargument name="userID" default="" hint="userID is required">
    	<cfargument name="uniqueID" default="" hint="uniqueID is required">

        <cfquery 
			name="qGetUserInfoRoleByID" 
			datasource="#APPLICATION.DSN#">
                SELECT 
                    u.useriD,
                    u.firstName,
                    u.lastName,
                    alup.name
                FROM
                	smg_users_role_jn surJN
				INNER JOIN   
                    smg_users u ON surJN.userID = u.userID
                INNER JOIN
                	applicationlookup alup on alup.fieldID = surJN.roleID                
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
		   
		<cfreturn qGetUserInfoByID>
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
                    sup.ar_ref_quest1,
                    sup.ar_ref_quest2,
                    sup.ar_cbc_auth_form,
                    sup.ar_agreement,
                    sup.agreeSig,
                    sup.cbcSig,
                    sup.dateRMReviewNotified,
                    sup.dateOfficeReviewNotified,
                    sup.accessGrantedBy,
                    sup.dateAccessGranted,
                    ss.years,
                    ss.datePaperworkStarted,
                    ss.datePaperworkEnded
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
                
				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    AND          
                        sup.fk_companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
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
			vDateFieldList = "ar_ref_quest1,ar_ref_quest2,ar_cbc_auth_form,ar_agreement,dateRMReviewNotified,dateOfficeReviewNotified";
			
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
                        #ARGUMENTS.fieldName#,
                        dateCreated
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">,
                        <!--- Date Field --->
                        <cfif ListFind(vListofFields, ARGUMENTS.fieldName)>
                            <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.fieldValue#" null="#NOT IsDate(ARGUMENTS.fieldValue)#">,
                        <!--- String Field --->
                        <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.fieldValue#">,
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    )
            </cfquery>
        
        </cfif>
        
	</cffunction>
    
    
	<cffunction name="setSeasonPaperworkAsVerified" access="public" returntype="void" output="false" hint="Update User Paperwork">
    	<cfargument name="userID" default="" hint="userID is not required">
        <cfargument name="seasonID" default="#APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID#" hint="seasonID is required">
        <cfargument name="accessGrantedBy" default="#CLIENT.userID#" hint="accessGrantedBy is not required">

        <cfquery 
            datasource="#APPLICATION.DSN#">
                UPDATE
                    smg_users_paperwork
                SET
                    dateAccessGranted = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    accessGrantedBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(ARGUMENTS.accessGrantedBy)#">
                WHERE
                    userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
                AND
                	seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">
                AND
                	dateAccessGranted IS NULL
                AND
                	accessGrantedBy = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
        </cfquery>

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


	<cffunction name="paperworkSubmittedRMNotification" access="public" returntype="void" output="false" hint="Sends out a notification to regional managers when users fill out paperwork">
        <cfargument name="userID" hint="User ID is Required">   
        <cfargument name="structUserPaperwork" type="struct" default="#StructNew()#">     

		<cfscript>
			if ( StructIsEmpty(ARGUMENTS.structUserPaperwork) ) {
				// Get Paperwork Struct
				var stUserPaperwork = getUserPaperwork(userID=ARGUMENTS.userID);
			} else {
				// Set Paperwork Struct
				var stUserPaperwork = ARGUMENTS.structUserPaperwork;
			}

			// Check if we need to send out a notification to the program manager
			papeworkSubmittedOfficeNotification(userID=ARGUMENTS.userID,structUserPaperwork=stUserPaperwork);
			
			// Get Region ID
			var vDefaultUserRegionID = getUserAccessRights(userID=ARGUMENTS.userID).regionID;
			
			// Email Variables
			var vEmailTo = getRegionalAdvisor(regionID=vDefaultUserRegionID).email;
			var vEmailCC = getRegionalManager(regionID=vDefaultUserRegionID).email;
			var vEmailSubject = "#stUserPaperwork.user.displayName# has submitted paperwork";
			var vEmailMessage = '';	
        </cfscript>
    
        <cfif NOT isDate(stUserPaperwork.dateRMReviewNotified) AND stUserPaperwork.accountReviewStatus EQ 'rmReview' AND isValid("email", vEmailTo)>
    		
            <cfsavecontent variable="vEmailMessage">
            
                <cfoutput>				
                    <p>#stUserPaperwork.user.displayName# has submitted initial paperwork required (Agreement, CBC Authorization, Employment History and References).</p>
                    
                    <p>Please submit at least 2 reference questionnaires.</p>
            
                    <a href="#CLIENT.exits_url#/nsmg/index.cfm?curdoc=user_info&userID=#stUserPaperwork.user.ID#">View user's account.</a>
                </cfoutput>
                
            </cfsavecontent>
    
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#vEmailTo#">
                <cfinvokeargument name="email_cc" value="#vEmailCC#">
                <cfinvokeargument name="email_from" value="#CLIENT.emailfrom# (#CLIENT.companyshort# Support)">
                <cfinvokeargument name="email_subject" value="#vEmailSubject#">
                <cfinvokeargument name="email_message" value="#vEmailMessage#">
            </cfinvoke>
            
            <cfscript>
				// Store date notification sent to avoid sending multiple notifications
				updateSeasonPaperwork(userID=ARGUMENTS.userID,fieldName="dateRMReviewNotified",fieldValue=dateFormat(now(), 'mm/dd/yyyy'));
			</cfscript>
    
        </cfif>
	</cffunction>
    
    
	<cffunction name="papeworkSubmittedOfficeNotification" access="public" returntype="void" output="false" hint="Sends out a notification to office when RMs fill out references">
        <cfargument name="userID" hint="User ID is Required">
        <cfargument name="structUserPaperwork" type="struct" default="#StructNew()#">

		<cfscript>
			if ( StructIsEmpty(ARGUMENTS.structUserPaperwork) ) {
				// Get Paperwork Struct
				var stUserPaperwork = getUserPaperwork(userID=ARGUMENTS.userID);
			} else {
				// Set Paperwork Struct
				var stUserPaperwork = ARGUMENTS.structUserPaperwork;
			}

			// Check if account is compliant, if so notify user he is granted full access to EXITS
			accountFullyEnabledNotification(userID=ARGUMENTS.userID, structUserPaperwork=stUserPaperwork);
			
			// Email Variables
			var vEmailTo = CLIENT.programmanager_email;
			var vEmailSubject = "Paperwork has been submitted for #stUserPaperwork.user.displayName#";
			var vEmailMessage = '';
		</cfscript>
    
        <cfif NOT isDate(stUserPaperwork.dateOfficeReviewNotified) AND stUserPaperwork.accountReviewStatus EQ 'officeReview' AND isValid("email", vEmailTo)>
    
            <cfsavecontent variable="vEmailMessage">
            
                <cfoutput>
                	<!--- 2nd Visit Reps don't have references --->
                    <cfif stUserPaperwork.user.isSecondVisitRepresentative>
                		<p>2<sup>nd</sup> Representative #stUserPaperwork.user.displayName# has submitted all required paperwork.</p>
                    <cfelse>
                    	<p>The references for #stUserPaperwork.user.displayName# have been submitted by the regional manager.</p>
                    </cfif>
                    
                    <p>Please review paperwork and submit the CBC for processing. If everything looks good, approval of the CBC will activate this account.</p>		
                            
                    <a href="#CLIENT.exits_url#/nsmg/index.cfm?curdoc=user_info&userID=#stUserPaperwork.user.ID#">View user's account.</a>
                </cfoutput>
                
            </cfsavecontent>
    
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#vEmailTo#"> 
                <cfinvokeargument name="email_from" value="#CLIENT.emailfrom# (#CLIENT.companyshort# Support)">
                <cfinvokeargument name="email_subject" value="#vEmailSubject#">
                <cfinvokeargument name="email_message" value="#vEmailMessage#">
            </cfinvoke>
            
            <cfscript>
				// Store date notification sent to avoid sending multiple notifications
				updateSeasonPaperwork(userID=ARGUMENTS.userID,fieldName="dateOfficeReviewNotified",fieldValue=dateFormat(now(), 'mm/dd/yyyy'));
			</cfscript>
    
        </cfif>
	</cffunction>
    

	<cffunction name="accountFullyEnabledNotification" access="public" returntype="void" output="false" hint="Sends out a notification to user when account has been granted full access">
        <cfargument name="userID" hint="User ID is Required">
        <cfargument name="structUserPaperwork" type="struct" default="#StructNew()#">

		<cfscript>
			if ( StructIsEmpty(ARGUMENTS.structUserPaperwork) ) {
				// Get Paperwork Struct
				var stUserPaperwork = getUserPaperwork(userID=ARGUMENTS.userID);
			} else {
				// Set Paperwork Struct
				var stUserPaperwork = ARGUMENTS.structUserPaperwork;
			}
			
			// Email Variables
			var vEmailTo = stUserPaperwork.user.email & ",lstrahs@iseusa.org";
			var vEmailSubject = "EXITS - Account Fully Enabled";
			var vEmailMessage = '';
		</cfscript>
    
        <cfif NOT isDate(stUserPaperwork.dateAccessGranted) AND stUserPaperwork.isAccountCompliant AND isValid("email", vEmailTo)>
    
            <cfsavecontent variable="vEmailMessage">
            
                <cfoutput>
                	<p>Dear #stUserPaperwork.user.displayName#,</p>
                    <p>Just a quick note to let you know you have been granted full access to EXITS.</p>
                    <p>Please click on this link to log in <a href="#CLIENT.exits_url#/">#CLIENT.exits_url#</a></p>
                </cfoutput>
                
            </cfsavecontent>
    
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#vEmailTo#"> 
                <cfinvokeargument name="email_from" value="#CLIENT.emailfrom# (#CLIENT.companyshort# Support)">
                <cfinvokeargument name="email_subject" value="#vEmailSubject#">
                <cfinvokeargument name="email_message" value="#vEmailMessage#">
            </cfinvoke>
            
            <cfscript>
				// Set account verified Date and verified By
				setSeasonPaperworkAsVerified(userID=ARGUMENTS.userID);
			</cfscript>
    
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
                            r.company IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
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
    
    
	<cffunction name="getRegionFacilitator" access="public" returntype="query" output="false" hint="Gets a list of facilitators assigned to a region">
        <cfargument name="regionID" type="numeric" hint="regionID is required">

        <cfquery 
			name="qGetRegionFacilitator" 
			datasource="#APPLICATION.DSN#">
                SELECT 
                    r.regionfacilitator, 
                    u.email, 
                    u.firstName,
                    u.lastName,
                    u.userID,
                    CAST(CONCAT(u.firstName, ' ', u.lastName,  ' ##', u.userID) AS CHAR) AS regionFacilitator 
                FROM 
                    smg_regions r
                LEFT OUTER JOIN 
                    smg_users u ON u.userID = r.regionfacilitator
                WHERE 
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
			</cfquery>
		   
		<cfreturn qGetRegionFacilitator>
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
						<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                            AND          
                                s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
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
			name="qGetUserInfoAccessRights" 
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
		   
		<cfreturn qGetUserInfoAccessRights>
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
    

	<cffunction name="getRegionalAdvisor" access="public" returntype="query" output="false" hint="Gets a regional advisor for a given region">
        <cfargument name="regionID" type="numeric" default="0" hint="regionID is required">
        <cfargument name="userID" type="numeric" default="0" hint="userID is required">
              
        <cfquery 
			name="qGetRegionalAdvisor" 
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
                	user_access_rights uar ON u.userID = uar.advisorID
                    AND 
                        uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
				INNER JOIN
                	smg_regions r ON r.regionID = uar.regionID                    
                WHERE 
                	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				AND
                	uar.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
		</cfquery>
		   
		<cfreturn qGetRegionalAdvisor>
	</cffunction>    


	<cffunction name="getSupervisedUsers" access="public" returntype="query" output="false" hint="Gets a list of supervised users">
        <cfargument name="usertype" type="numeric" hint="usertype is required">
        <cfargument name="userID" type="numeric" hint="userID is required">
        <cfargument name="regionID" default="0" hint="regionID is not required">
        <cfargument name="regionIDList" default="" hint="List of Region IDs">
        <cfargument name="is2ndVisitIncluded" default="0" type="numeric" hint="is2ndVisitIncluded is not required">
        <cfargument name="includeUserIDs" default="" hint="area reps will be able to see themselves and current assigned users on the list">
        <cfargument name="excludeUserIDs" default="" hint="area reps that will NOT be showen in the drop down, not required">
        
        
        <cfscript>
			// Get Current Paperwork Season ID
			vCurrentSeasonID = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID;
			//vCurrentSeasonID = 10;
        </cfscript>
        
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
                    <!--- Get Commpliant Users Only --->    
                    LEFT OUTER JOIN
                    	smg_users_paperwork sup ON sup.userID = u.userID
                    WHERE 
                    	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
           			
					<cfif VAL(ARGUMENTS.regionID)>
                        AND
                            uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
                	</cfif>
                    
					<cfif LEN(ARGUMENTS.regionIDList)>
                        AND
                           uar.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionIDList#" list="yes"> )
                	</cfif>
                    
                    <cfif VAL(is2ndVisitIncluded)>
                        AND 
                            uar.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7,15" list="yes"> )
                    <cfelse>
                        AND 
                            uar.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7" list="yes"> )
                    </cfif>
                    
                    <!--- Get Only Current Season Compliant Users, Canada does not require this. --->
                    <cfif CLIENT.companyID NEQ 13>
                        AND
                            sup.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(vCurrentSeasonID)#">
                 	</cfif>
                    <!---
                    AND
                        sup.dateAccessGranted IS NOT NULL
					--->						

                    <!--- Include Current Assigned User--->
                    <cfif LEN(ARGUMENTS.includeUserIDs)>
                    	OR
                            u.userID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.includeUserIDs#" list="yes"> )
                    </cfif>
                     
                    <cfif LEN(ARGUMENTS.excludeUserIDs)>
                        AND
                        	u.userID != <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.excludeUserIDs#">
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
                    LEFT OUTER JOIN
                    	smg_users_paperwork sup ON sup.userID = u.userID
                    WHERE 
                    	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">

					<cfif VAL(ARGUMENTS.regionID)>
                        AND
                            uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
                	</cfif>
                    
					<cfif LEN(ARGUMENTS.regionIDList)>
                        AND
                           uar.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionIDList#" list="yes"> )
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
					
                    <!--- Get Only Current Season Compliant Users --->
                    AND
                        sup.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(vCurrentSeasonID)#">
                    <!---
                    AND
                        sup.dateAccessGranted IS NOT NULL
					--->						
					
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
			name="qGetUserInfoMemberByID" 
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
		   
		<cfreturn qGetUserInfoMemberByID>
	</cffunction>


	<!--- ------------------------------------------------------------------------- ----
		Start of Payment Section
	----- ------------------------------------------------------------------------- --->
    
	<cffunction name="getRepTotalPayments" access="public" returntype="query" output="false" hint="Gets reps total payment by program">
    	<cfargument name="userID" hint="UserID is required">
        <cfargument name="companyID" hint="companyID is required">
        <cfargument name="groupBySeason" default="1">
              
            <cfquery 
                name="qGetRepTotalPayments" 
                datasource="#APPLICATION.DSN#">
                SELECT                     
                    s.seasonID,
                    SUM(rep.amount) as totalPerProgram,
                    s.season          
                FROM 
                    smg_users_payments rep
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
                    <cfif VAL(ARGUMENTS.groupBySeason)>
                    	s.seasonID 
                    <cfelse>
                    	rep.agentID
                   	</cfif>    
                ORDER BY 
                    s.seasonID DESC
            </cfquery>
		   
		<cfreturn qGetRepTotalPayments>
	</cffunction>
    
    <cffunction name="getRepPayments" access="public" returntype="query" output="false">
    	<cfargument name="companyID" hint="companyID is required">
        <cfargument name="userID" default="0">
        <cfargument name="studentID" default="0">
        <cfargument name="paymentID" default="0">
        <cfargument name="creditStatus" default="" hint="Set to a credit status to only get that type">
        <cfargument name="onlyPayments" default="0">
        <cfargument name="orderFor" default="paymentReport">
        <cfargument name="limit" default="0">
        <cfargument name="offset" default="0">
        
        <cfquery name="qGetPayments" datasource="#APPLICATION.DSN#">
        	SELECT 
                rep.*,
                CASE
                	WHEN (isPaid = 0 OR isPaid IS NULL) AND creditStatus != 3 THEN NULL
                    ELSE rep.date
                    END AS paidDate,
              	CASE 
                    WHEN s.middleName != "" THEN CONCAT(s.firstName, " ", s.middleName, " ", s.familyLastName)
                    ELSE CONCAT(s.firstName, " ", s.familyLastName)
                    END AS studentName,
                CASE
                    WHEN u.middleName != "" THEN CONCAT(u.firstName, " ", u.middleName, " ", u.lastName)
                    ELSE CONCAT(u.firstName, " ", u.lastName)
                    END AS agentName,
                s.studentid,
                s.firstname, 
                s.familylastname,
                host.hostID,
                host.fatherFirstName,
                host.motherFirstName,
                host.familyLastName AS hostFamilyLastName,             
                c.team_id,
                type.type,
                p.programName
            FROM smg_users_payments rep
            LEFT JOIN smg_students s ON s.studentid = rep.studentid
            LEFT JOIN smg_hosts host ON host.hostID = rep.hostID
            LEFT JOIN smg_programs p ON p.programID = rep.programID
            LEFT JOIN smg_users_payments_type type ON type.id = rep.paymenttype
            LEFT JOIN smg_companies c ON c.companyID = rep.companyID
            LEFT JOIN smg_users u ON u.userID = rep.agentID
            WHERE rep.isDeleted = 0
            <cfif VAL(ARGUMENTS.onlyPayments)>
            	AND rep.paymentType = 37 AND rep.transtype = "Payment" AND rep.creditStatus = 3
            </cfif>
            <cfif LEN(ARGUMENTS.creditStatus)>
            	AND rep.creditStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.creditStatus)#">
            </cfif>
            <cfif VAL(ARGUMENTS.userID)>
                AND rep.agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
            </cfif>
            <cfif VAL(ARGUMENTS.studentID)>
                AND rep.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
            </cfif>
            <cfif VAL(ARGUMENTS.paymentID)>
                AND rep.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.paymentID#">
            </cfif>
            <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID)>
                AND rep.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
            <cfelseif VAL(ARGUMENTS.companyID)>
                AND rep.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
            </cfif>
            <cfif ARGUMENTS.orderFor EQ "paymentReport">
            	ORDER BY paidDate IS NOT NULL, paidDate DESC, dateCreated DESC, rep.transtype
          	<cfelseif ARGUMENTS.orderFor EQ "credits">
            	ORDER BY paidDate DESC, dateCreated DESC, rep.transtype, type.type
            </cfif>
            <cfif VAL(ARGUMENTS.limit)>
            	LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.limit)#">
            </cfif>
            <cfif VAL(ARGUMENTS.offset)>
            	OFFSET <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.offset)#">
            </cfif>
        </cfquery>
        
        <cfreturn qGetPayments>
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
					host.hostID,
					host.fatherFirstName,
					host.motherFirstName,
					host.familyLastName AS hostFamilyLastName,             
                    c.team_id,
                    type.type,
                    p.programName
                FROM 
                    smg_users_payments rep
                LEFT JOIN 
                    smg_students stu ON stu.studentid = rep.studentid
				LEFT JOIN
					smg_hosts host ON host.hostID = rep.hostID
                INNER JOIN
                    smg_programs p ON p.programID = rep.programID
                INNER JOIN	
                	smg_seasons s ON s.seasonID = p.seasonID
                LEFT JOIN 
                    smg_users_payments_type type ON type.id = rep.paymenttype
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
                    smg_users_payments rep
                INNER JOIN
                	smg_users u ON u.userID = rep.agentID
                INNER JOIN
                    smg_users_payments_type type ON type.id = rep.paymenttype
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
                	applicationlookup alup ON alup.fieldID = sut.training_id 
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


	<cffunction name="isRequiredTrainingComplete" access="public" returntype="struct" output="false" hint="Returns a structure with the required AR Training Information">
    	<cfargument name="userID" hint="userID is required">
        <cfargument name="seasonID" hint="seasonID is required">
		
        <cfquery 
			name="qIsRequiredTrainingComplete" 
			datasource="#APPLICATION.DSN#">
                SELECT DISTINCT
					id,
                    date_trained
                FROM 
                    smg_users_training sut
                WHERE
                    user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    AND          
                        company_ID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelse>
                    AND          
                        company_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                </cfif>
                <!--- 6 = New Area Rep | 10 = Area Rep Refresher --->
                AND
                    training_id IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="6,10" list="yes"> )
                LIMIT 1
		</cfquery>
        
        <cfscript>
			vReturnStruct = StructNew();			
		
			if ( qIsRequiredTrainingComplete.recordCount )  {
				vReturnStruct.dateTrained = DateFormat(qIsRequiredTrainingComplete.date_trained, 'mm/dd/yyyy');
				vReturnStruct.isTrainingCompleted = true;
			} else {
				vReturnStruct.dateTrained = "";
				vReturnStruct.isTrainingCompleted = false;
			}
			
			return vReturnStruct;
		</cfscript>
        
	</cffunction>
    

	<cffunction name="isDOSCertificationValid" access="public" returntype="struct" output="false" hint="Returns a structure with the DOS Certification Information">
    	<cfargument name="userID" hint="userID is required">
		
        <cfquery 
			name="qIsDOSCertificationValid" 
			datasource="#APPLICATION.DSN#">
                SELECT DISTINCT
					id,
                    date_trained,
                    DATE_ADD(date_trained, INTERVAL 12 MONTH) AS dateExpired
                FROM 
                    smg_users_training sut
                WHERE
                    user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    AND          
                        company_ID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelse>
                    AND          
                        company_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                </cfif>
                AND
                	has_passed = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                AND
                    training_id = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                AND
                	DATE_ADD(date_trained, INTERVAL 12 MONTH) >= NOW()
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
				// Check if we need to send out a notification to the regional manager
				paperworkSubmittedRMNotification(userID=ARGUMENTS.userID);
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
                    DUAL
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
				setUserSessionPaperwork();
			}
		</cfscript>
        
        <!--- New Area Rep Training email --->
        <cfif ARGUMENTS.trainingID EQ 6>
        
            <cfquery name="qGetUserInfo" datasource="#APPLICATION.DSN#">
                SELECT 
                	vuh.`area rep ID` as `userID`, vuh.`Area Rep First Name` as `firstname`, vuh.`Area Rep Last Name` as `lastname`, ar.phone, ar.email, vuh.`Regional Advisor Email` as `raEmail`, 
                    vuh.`Regional Manager First Name` as `rmFirstName`, vuh.`Regional Manager Last Name` as `rmLastname`, vuh.`Regional Manager Email` as `rmEmail`
                FROM v_user_hierarchy vuh
                LEFT JOIN smg_users ar on vuh.`area rep ID` = ar.userid
                WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
            </cfquery>
            
            <cfsavecontent variable="vEmailMessage">
            	<cfoutput>
                    <p>Hello #qGetUserInfo.rmFirstName# #qGetUserInfo.rmLastName#,</p>
                    
                    <p>
                        This email is to confirm that #qGetUserInfo.firstName# #qGetUserInfo.lastName# (###qGetUserInfo.userID#) 
                        has completed the New Area Rep. Orientation webex on #DateFormat(ARGUMENTS.dateTrained,'mm/dd/yyyy')#.
                    </p>
                    
                    <p>
                        Please take a moment to reach out to #qGetUserInfo.firstName# to thank them for their participation 
                        and to provide them with the next steps in getting started!
                    </p>
                    
                    <p>
                        #qGetUserInfo.firstName# #qGetUserInfo.lastName# (###qGetUserInfo.userID#)<br/>
                        #qGetUserInfo.phone#<br/>
                        #qGetUserInfo.email#<br/>
                        <br/>
                        Thanks,<br/>
                        <br/>                
                        International Student Exchange<br/>
                        O: 631-893-4540<br/>
                        www.iseusa.org<br/>
                    </p>
              	</cfoutput>
            </cfsavecontent>
            
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#qGetUserInfo.rmEmail#; #qGetUserInfo.raEmail#">
                <cfinvokeargument name="email_from" value="#CLIENT.emailfrom# (#CLIENT.companyshort# Support)">
                <cfinvokeargument name="email_cc" value="lstrahs@iseusa.org">
                <cfinvokeargument name="email_subject" value="New Area Rep. Training Completed">
                <cfinvokeargument name="email_message" value="#vEmailMessage#">
            </cfinvoke>
            
       	</cfif>
        
        <!--- New DoS test email --->       
        <cfif ARGUMENTS.trainingID EQ 2>
        <cfquery name="qGetUserInfo" datasource="#APPLICATION.DSN#">
        	SELECT
            	vuh.`area rep ID` as `userID`, vuh.`Area Rep First Name` as `firstname`, vuh.`Area Rep Last Name` as `lastname`, ar.phone, ar.email, sut.training_id, MAX(sut.id), sut.score as `grade`
            FROM v_user_hierarchy vuh
            LEFT JOIN smg_users ar on vuh.`area rep ID` = ar.userid
            LEFT JOIN smg_users_training sut on vuh.`area rep ID` = sut.user_id
            WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
            	  and sut.training_id = 2
        </cfquery>
        
        <cfsavecontent variable="vEmailMessage">
        	<cfoutput>
            	<p>Hello Lisa,</p>
                
                <p>This email is to confirm that #qGetUserInfo.firstName# #qGetUserInfo.lastName# (###qGetUserInfo.userID#)
                	has completed their Department of State exam with a score of #qGetUserInfo.grade#.
                </p>
                <br/>
                Thanks!
            </cfoutput>
         </cfsavecontent>
         
         <cfinvoke component="nsmg.cfc.email" method="send mail">
         	<cfinvokeargument name="email_to" value="lstrahs@iseusa.org">
            <cfinvokeargument name="email_from" value="#CLIENT.emailfrom# (#CLIENT.companyshort# Support)">
            <cfinvokeargument name="email_cc" value="jon@iseusa.org">
            <cfinvokeargument name="email_subject" value = "Area Rep Derpartment of State Training Completed">
            <cfinvokeargument name="email_message" value="#vEmailMessage#">
         </cfinvoke>   
        
        </cfif>
        
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
                	applicationlookup alup ON alup.fieldID = sut.training_id 
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
                        applicationlookup alup ON alup.fieldID = sut.training_id 
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
                    applicationlookup alup ON alup.fieldID = sut.training_id 
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
		Start of Incentive Trip Guests
	----- ------------------------------------------------------------------------- --->
    
    <cffunction name="getIncentiveTripGuests" access="public" returntype="query" output="no" hint="Gets all of the non-deleted guests for a given user and season">
    	<cfargument name="userID" default="0" required="no">
        <cfargument name="seasonID" default="0" required="no">
    
    	<cfquery name="qGetIncentiveTripGuests" datasource="#APPLICATION.DSN#">
        	SELECT *
            FROM smg_incentive_trip_guests
            WHERE isDeleted = 0
            <cfif VAL(ARGUMENTS.userID)>
            	AND userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
          	</cfif>
            <cfif VAL(ARGUMENTS.seasonID)>
            	AND seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">
         	</cfif>
        </cfquery>
        
        <cfreturn qGetIncentiveTripGuests>
    
    </cffunction>
    
    <cffunction name="addIncentiveTripGuests" access="public" returntype="boolean" output="no" hint="Adds a new guest, returns true if successfull">
    	<cfargument name="userID" required="yes">
        <cfargument name="seasonID" required="yes">
        <cfargument name="name" required="no">
        <cfargument name="userType" default="0" required="no">
        <cfargument name="dob" default="" required="no">
        <cfargument name="departureAirport" default="" required="no">
        <cfargument name="comments" default="" required="no">
        
        <cftry>
        	
            <cfquery datasource="#APPLICATION.DSN#">
            	INSERT INTO smg_incentive_trip_guests (
                	userID,
                    seasonID,
                    name,
                    userType,
                    dob,
                    departureAirport,
                    comments,
                    dateCreated,
                    createdBy,
                    updatedBy )
              	VALUES (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.name#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userType)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dob#" null="#NOT LEN(ARGUMENTS.dob) OR NOT ISDATE(ARGUMENTS.dob)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.departureAirport#">,
                    <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.comments#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#"> )
            </cfquery>
            
            <cfcatch type="any">
                <cfreturn false>
            </cfcatch>
        </cftry>
        
        <cfreturn true>
        
    </cffunction>
    
    <cffunction name="updateIncentiveTripGuests" access="public" returntype="boolean" output="no" hint="Updates a guest, returns true if successfull">
    	<cfargument name="ID" required="yes">
        <cfargument name="name" required="no">
        <cfargument name="userType" default="" required="no">
        <cfargument name="dob" default="" required="no">
        <cfargument name="departureAirport" default="" required="no">
        <cfargument name="comments" default="" required="no">
        
        <cftry>
        	
            <cfquery datasource="#APPLICATION.DSN#">
            	UPDATE smg_incentive_trip_guests
                SET
                	<cfif LEN(ARGUMENTS.name)>
                    	name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.name#">,
                    </cfif>
                	<cfif LEN(ARGUMENTS.userType)>
                    	userType = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userType)#">,
                  	</cfif>
                    <cfif LEN(ARGUMENTS.dob)>
                    	dob = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dob#" null="#NOT LEN(ARGUMENTS.dob) OR NOT ISDATE(ARGUMENTS.dob)#">,
                  	</cfif>
                    <cfif LEN(ARGUMENTS.departureAirport)>
                    	departureAirport = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.departureAirport#">,
                    </cfif>
                    comments = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.comments#">,
                    updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
              	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">
            </cfquery>
            
            <cfcatch type="any">
                <cfreturn false>
            </cfcatch>
        </cftry>
        
        <cfreturn true>
        
    </cffunction>
    
    <cffunction name="removeIncentiveTripGuests" access="public" returntype="boolean" output="no" hint="Removes a guest, returns true if successfull">
    	<cfargument name="ID" required="yes">
        
        <cftry>
        	
            <cfquery datasource="#APPLICATION.DSN#">
            	UPDATE smg_incentive_trip_guests
                SET isDeleted = 1
                WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
            </cfquery>
            
            <cfcatch type="any">
                <cfreturn false>
            </cfcatch>
        </cftry>
        
        <cfreturn true>
        
    </cffunction>
    
    <cffunction name="getPlacementsAndPointsCount" access="public" returntype="numeric" output="no" hint="Gets the total number of placements and points for this rep in this season">
    	<cfargument name="userID" required="yes">
        <cfargument name="seasonID" required="yes">
        
        <cfquery name="qGetPlacedStudents" datasource="#APPLICATION.DSN#">
            SELECT COUNT(*) AS total
            FROM smg_students s
            INNER JOIN smg_programs p ON p.programid = s.programid
            INNER JOIN smg_incentive_trip t ON t.tripid = p.tripid
            WHERE s.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#"> 
            AND s.host_fam_approved < 5
            AND s.active = 1
            AND t.active = 1
            AND s.studentID IN (
    			SELECT studentID 
                FROM smg_hosthistory 
                WHERE compliance_review IS NOT NULL    
                AND placeRepID = s.placeRepID   
			)
        </cfquery>
        
        <cfquery name="qGetRepPoints" datasource="#APPLICATION.DSN#">
            SELECT SUM(points) AS total
            FROM smg_incentive_trip_points
            WHERE isDeleted = 0
            AND seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">
            AND userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
        </cfquery>
        
        <cfscript>
			return VAL(qGetPlacedStudents.total) + VAL(qGetRepPoints.total);
		</cfscript>
    
    </cffunction>
    
    <cffunction name="getTripsEarned" access="public" returntype="numeric" output="no" hint="Gets the number of trips earned based on the number of placements">
    	<cfargument name="numPlacements" required="yes">
        
        <cfscript>
			vPlacements = ARGUMENTS.numPlacements;
			vTotalTrips = 0;
			x = 0;
			for (i = 1; i LTE vPlacements; i = i + 1) {
				x = x + 1;
				if (vTotalTrips LT 2) {
					if (x MOD 7 EQ 0) {
						x = 0;
						vTotalTrips = vTotalTrips + 1;
					}
				} else {
					if (x MOD 6 EQ 0) {
						x = 0;
						vTotalTrips = vTotalTrips + 1;
					}
				}
			}
			return vTotalTrips;
		</cfscript>
        
    </cffunction>
    
    <cffunction name="getAdditionalTripCost" access="public" returntype="numeric" output="no" hint="Gets the cost of an additional trip based on how many placements and previous trips earned there are">
    	<cfargument name="numEarnedTrips" required="yes" hint="total number of completely earned trips">
        <cfargument name="numPlacements" required="yes" hint="total number of placements">
        
        <cfscript>
			vCost = 1800;
			vTotalTrips = ARGUMENTS.numEarnedTrips;
			vTotalPlacements = ARGUMENTS.numPlacements;
			
			// Number of placements towards this additional trip
			vRemainingPlacements = vTotalPlacements;
			for (i = 1; i LTE vTotalTrips; i = i + 1) {
				if (i LTE 2) {
					vRemainingPlacements = vRemainingPlacements - 7;
				} else {
					vRemainingPlacements = vRemainingPlacements - 6;
				}
			}
			
			// Cost of this additional trip - after 2 trips there are only 6 placements required per trip
			if (vTotalTrips LT 2) {
				for (j = 1; j LTE vRemainingPlacements; j = j + 1) {
					if (ListFind("1,3,4,5",j)) {
						vCost = vCost - 300;
					} else {
						vCost = vCost - 200;
					}
				}
			} else {
				for (j = 1; j LTE vRemainingPlacements; j = j + 1) {
					if (j EQ 1) {
						vCost = vCost - 500;
					} else if (ListFind("2,3,4",j)) {
						vCost = vCost - 300;
					} else {
						vCost = vCost - 200;
					}
				}
			}
			
			return vCost;
		</cfscript>
        
    </cffunction>
    
    <cffunction name="getTakingCheck" access="public" returntype="query" output="no" hint="Gets the smg_incentive_trip_payment table record.">
    	<cfargument name="userID" required="yes">
        <cfargument name="seasonID" required="yes">
        
        <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
        	SELECT *
            FROM smg_incentive_trip_payment
            WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
            AND seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.seasonID#">
        </cfquery>
        
        <cfreturn qGetResults>
    
    </cffunction>
    
    <cffunction name="updateTakingCheck" access="public" returntype="void" output="no" hint="Updates the smg_incentive_trip_payment table based on if the user is taking the payment or not.">
    	<cfargument name="userID" required="yes">
        <cfargument name="seasonID" required="yes">
        <cfargument name="takingCheck" required="yes">
        
        <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
        	SELECT *
            FROM smg_incentive_trip_payment
            WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
            AND seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.seasonID#">
        </cfquery>
        
        <cfif VAL(qGetResults.recordCount)>
        	<cfquery datasource="#APPLICATION.DSN#">
            	UPDATE smg_incentive_trip_payment
                SET 
                	takingCheck = <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.takingCheck#">,
                	updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
             	WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                AND seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.seasonID#">
            </cfquery>
        <cfelse>
        	<cfquery datasource="#APPLICATION.DSN#">
            	INSERT INTO smg_incentive_trip_payment (
                	userID,
                    seasonID,
                    takingCheck,
                    dateCreated,
                    createdBy,
                    updatedBy )
             	VALUES (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.seasonID#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.takingCheck#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#"> )
            </cfquery>
        </cfif>
    
    </cffunction>
    
    <!--- ------------------------------------------------------------------------- ----
		End of Incentive Trip Guests
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
                    smg_usertype ut ON ut.userTypeID = uar.userType
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