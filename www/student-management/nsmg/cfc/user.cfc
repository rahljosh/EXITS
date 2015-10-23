<cfcomponent>
	<Cfset client.loginError=''> 
    <cfparam name="CLIENT.companyID" default="1">
    
	<!--- Login.  called by: flash/login.cfm --->
	<cffunction name="login" access="public" returntype="string">
		<cfargument name="username" type="string" required="yes">
		<cfargument name="password" type="string" required="yes">
		
        <cfscript>
			var student_login = '';
			var authenticate = '';
			var get_access = '';
			var get_default_access = '';
			var get_companies = '';
		</cfscript>

		<!--- Check if we are on Local Server --->
        <cfif APPLICATION.IsServerLocal>
        
            <cfquery name="qGetCompany" datasource="#application.dsn#">
                SELECT 
                    companyid, 
                    companyname
                FROM 
                    smg_companies 
                WHERE
                    url_ref LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ise.exitsapplication.com"> 
            </cfquery>

        <!--- Production Server --->    
        <cfelse>
        
            <cfquery name="qGetCompany" datasource="#application.dsn#">
                SELECT 
                    companyid, 
                    companyname,
                    website
                FROM 
                    smg_companies 
                WHERE
                    url_ref LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#cgi.server_name#"> 
            </cfquery>
       
        </cfif>        
		
        <cfscript>
			if ( NOT VAL(CLIENT.companyID) AND VAL(qGetCompany.recordcount) ) {
				
				CLIENT.companyid = qGetCompany.companyid;
				CLIENT.companyname = qGetCompany.companyname;
				
			} else if ( NOT VAL(CLIENT.companyID) ) {
				
				CLIENT.companyid = 0;
				CLIENT.companyname = 'EXIT Group';
				
			}		
		</cfscript>
        
        <!----If error code SI-102, company information is wrong---->
        <cfquery name="submitting_info" datasource="#APPLICATION.dsn#">
            SELECT 
            	website, 
                url_ref, 
                company_color
            FROM
            	smg_companies
            WHERE 
            	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyid)#">
        </cfquery>

        <cfif NOT VAL(submitting_info.recordcount)>
            
            <cfoutput>
            	<p>Error during login. Please try again shortly.</p>                
            	#CGI.server_name#
			</cfoutput>
            <cfabort>
        </cfif>
       
		<cfscript>
			CLIENT.company_submitting = submitting_info.website;
			CLIENT.app_menu_comp = CLIENT.companyid;
			CLIENT.color = submitting_info.company_color;
			
			if ( APPLICATION.isServerLocal ) {
				CLIENT.exits_url = "http://" & submitting_info.url_ref;
			} else if ( CGI.HTTP_HOST EQ '204.12.118.245' ) { // go daddy remedy
				CLIENT.exits_url = "https://204.12.118.245";
			} else {
				CLIENT.exits_url = "http://" & submitting_info.url_ref;	
			}
			
			APPLICATION.company_short = submitting_info.website;
		</cfscript>
        
		<!--- student login --->
        <cfquery name="qAuhenticateStudent" datasource="#APPLICATION.dsn#">
            SELECT 
            	studentID, 
                firstname, 
                familylastname
            FROM 
            	smg_students
            WHERE 
            	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(username)#">
            AND 
            	password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(password)#">
            AND 
            	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        </cfquery>
        
        <cfif VAL(qAuhenticateStudent.recordcount)>
            <cfset CLIENT.studentID = qAuhenticateStudent.studentID>
            <cfset CLIENT.usertype = 10>
            <cfset CLIENT.userID = 0>
            <cfset CLIENT.name = "#qAuhenticateStudent.firstname# #qAuhenticateStudent.familylastname#">
			<cfquery name="applicationStatus" datasource="#APPLICATION.dsn#">
            select cancelreason
            from smg_students
            where studentid = #CLIENT.studentID#
            </cfquery>
            
            
			<!--- Check if server is local, if it is do not redirect to SSL --->
            <cfif APPLICATION.IsServerLocal>
				
                <cflocation url="/nsmg/student_app/index.cfm" addtoken="no">
            
            <!--- Production / Force SSL --->    
            <cfelse>
            	<Cfif applicationStatus.cancelreason eq 'NEXITS'>
                	<cflocation url="nsmg/student_app/nexits.cfm" addtoken="no">
                <cfelse>
                	<cflocation url="nsmg/student_app/index.cfm" addtoken="no">
            	</Cfif>
            </cfif>
		
        	<cfabort>
        
        </cfif>

        <cfquery name="qAuthenticateUser" datasource="#APPLICATION.dsn#">
            SELECT 
            	*
            FROM 
            	smg_users
            WHERE 
            	smg_users.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(username)#">
            AND 
            	smg_users.password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(password)#">
			AND
            	smg_users.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        </cfquery>
        
        <cfif qAuthenticateUser.recordcount EQ 0>
        	<cfreturn 'Username & Password combination is not valid.'>            
        </cfif>
       
		<!--- get all of the user's access records in the SMG companies. --->
        <cfquery name="get_access" datasource="#APPLICATION.dsn#">
            SELECT 
            	user_access_rights.*
            FROM 
            	user_access_rights
            INNER JOIN 
            	smg_companies ON user_access_rights.companyid = smg_companies.companyid
            WHERE 
            	smg_companies.website =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#CLIENT.company_submitting#">
            AND 
            	user_access_rights.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qAuthenticateUser.userID)#">
            ORDER 
            	BY user_access_rights.usertype
        </cfquery>
		
        <cfif get_access.recordcount EQ 0>
        	<cfreturn 'You have no Company & Regional Access record assigned.  One must be assigned first before you can login.  Contact your facilitator.'>            
        </cfif>

		<!--- get the user's default access record. --->
        <cfquery name="get_default_access" dbtype="query">
            SELECT 
            	*
            FROM 
            	get_access
            WHERE 
            	default_access = 1
        </cfquery>

		<!--- no default, so just use the first record. --->
        <cfif get_default_access.recordcount EQ 0>
            <cfquery name="get_default_access" dbtype="query" maxrows="1">
                SELECT 
                	*
                FROM 
                	get_access
            </cfquery>
        </cfif>
        
		<!----Check if they have all paperwork and account is not expired or disabled---->
		<cfscript>
            /*** NEW PAPERWORK SECTION ***/
			// Set USER SESSION Variables
			APPLICATION.CFC.USER.setUserSession(userID=qAuthenticateUser.userID);
		
			// Set USER SESSION Roles
			APPLICATION.CFC.USER.setUserSessionRoles(userID=qAuthenticateUser.userID);	
			
			// Set USER SESSION Paperwork
			APPLICATION.CFC.USER.setUserSessionPaperwork(userID=qAuthenticateUser.userID);
        </cfscript>
            	
        <Cfif not val(qAuthenticateUser.accountCreationVerified)>
        
        	<cfquery name="disabledReasonid" datasource="#application.dsn#">
            select max(id) as maxid 
            from smg_accountdisabledhistory
            where fk_userDisabled = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qAuthenticateUser.userID)#">
            </cfquery>
           
            <cfif val(disabledReasonid.maxid)>
                <cfquery name="disabledReason" datasource="#application.dsn#">
                select date, reason
                from smg_accountdisabledhistory
                where id = <cfqueryparam value="#VAL(disabledReasonid.maxid)#" cfsqltype="CF_SQL_INTEGER" >
                </cfquery>
                
                <cfreturn 'This account was disabled on #dateformat(disabledReason.date, "mm/dd/yyyy")#.  Please contact your regional manager.'>
        	</cfif>
        </Cfif>
      
      <Cfif len(client.loginError)>
      	<cflocation url="http://#cgi.server_name#">
      </Cfif>
      
		<cfset CLIENT.userID = qAuthenticateUser.userID>
        <cfset CLIENT.uniqueID = qAuthenticateUser.uniqueID>
		<cfset CLIENT.name = qAuthenticateUser.firstname & ' ' & qAuthenticateUser.lastname>
        <cfset CLIENT.email = qAuthenticateUser.email>
        
        <!--- these are currently used only in the header & menu. --->
		<cfset CLIENT.levels = get_access.recordcount>  <!--- the number of access records the user has. --->
        
        <!--- these are set from the default access record.  These are also set in forms/change_access_level.cfm. --->
        <cfset CLIENT.companyid = get_default_access.companyid>
        <cfset CLIENT.usertype = get_default_access.usertype>
        <cfset CLIENT.regions = get_default_access.regionid>  <!--- these are both the same, but phase out CLIENT.regions --->
        <cfset CLIENT.regionid = get_default_access.regionid>
    	<!----Check is SSN is missing---->
        
        <!----<cfif client.usertype gt 4>
            <h1>Scheduled Maintnance</h1>
            EXITS is currently undergoing maintnanace and is not avaialble.<br>
            We expect to have all systems back on line by  Sept 21, 2014 at 12:01am EST<br>
            <cfabort>	
        </cfif>---->
        
        <cfif NOT LEN(qAuthenticateUser.ssn) AND listfind('1,2,3,4,5,6,7', CLIENT.usertype)>
        	<cfset CLIENT.needsSSN = 1>
        </cfif>
        <!--- companyname, programmanager and accesslevelname are used in header.cfm.  These are also set in forms/change_access_level.cfm. --->
        <cfquery name="qGetCompany" datasource="#APPLICATION.dsn#">
            SELECT companyname, team_id, pm_email, support_email, url, companyshort_nocolor, projectManager, financeEmail,website
            FROM smg_companies
            WHERE companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyid)#">
        </cfquery>
        
        <cfset CLIENT.companyname = qGetCompany.companyname>
        <cfset CLIENT.companyshort = qGetCompany.companyshort_nocolor>
	    <cfset CLIENT.programmanager = qGetCompany.team_id>
        <cfset CLIENT.programmanager_email = qGetCompany.pm_email>
        <cfset CLIENT.projectmanager_email = #qGetCompany.projectManager#>
        <cfset CLIENT.finance_email = qGetCompany.financeEmail>
		<cfset CLIENT.support_email = qGetCompany.support_email> 
        <cfset CLIENT.site_url = qGetCompany.url>
        
        <cfquery name="get_usertype" datasource="#APPLICATION.dsn#">
            SELECT 
            	usertype
            FROM 
            	smg_usertype
            WHERE 
            	usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.usertype)#">
        </cfquery>
        
        <cfset CLIENT.accesslevelname = get_usertype.usertype>
        
		<cfif CLIENT.regionid NEQ ''>
            <cfquery name="get_region" datasource="#APPLICATION.dsn#">
                SELECT 
                	regionname
                FROM 
                	smg_regions
                WHERE 
                	regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.regionid)#">
            </cfquery>
            <cfset CLIENT.accesslevelname = "#CLIENT.accesslevelname# in #get_region.regionname#">
        </cfif>

        <cfquery name="get_companies" dbtype="query">
            SELECT DISTINCT 
            	companyid
            FROM 
            	get_access
        </cfquery>
		<cfset CLIENT.companies = valueList(get_companies.companyid)>

		<cfif CLIENT.usertype EQ 8>
            <cfset CLIENT.parentcompany = qAuthenticateUser.userID>
        <cfelseif CLIENT.usertype GTE 9>
            <cfset CLIENT.parentcompany = qAuthenticateUser.intrepid>
        </cfif>
        
        <cfset CLIENT.lastlogin = qAuthenticateUser.lastlogin>

		<!---- Update Last Login ---->
        <cfquery datasource="#APPLICATION.dsn#">
        	UPDATE 
            	smg_users
            SET 
            	lastlogin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        	WHERE 
            	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qAuthenticateUser.userID)#">
        </cfquery>

		<cfscript>
			// Set DOS Form Name to I-20
        	if ( CLIENT.companyID EQ 14 ) {
				CLIENT.DSFormName = "I-20";
			}
		</cfscript>
        
        <!--- this is used only in APPLICATION.cfm to logout after 24 hours. --->
        <cfset CLIENT.thislogin = dateFormat(now(), 'mm/dd/yyyy')>

		<!--- this usertype doesn't need to verify information. --->
        <cfif CLIENT.usertype NEQ 11>
        	<!--- Verify user info. New user will have null, or it's been 90 days. --->
			<cfif qAuthenticateUser.last_verification EQ '' OR dateDiff("d", qAuthenticateUser.last_verification, now()) GTE 90>
            	<!--- this is checked in APPLICATION.cfm and redirected if set. --->
      	  		<cfset CLIENT.verify_info = 1>
            </cfif>
		</cfif>
       
        <!--- change password --->
        <cfif qAuthenticateUser.changepass EQ 1>
			<!--- this is checked in APPLICATION.cfm and redirected if set. --->
            <cfset CLIENT.change_password = 1>      
		</cfif>
        
        <cfscript>
			// Host Family Leads Pop Up
			if ( ListFind("5,6,7", CLIENT.userType) ) {
				// Check if there are leads assigned to an Area Representative
				qGetHostLeads = APPLICATION.CFC.HOST.getPendingHostLeads(
					userType=CLIENT.userType,
					areaRepID=CLIENT.userID, 
					regionID=CLIENT.regionID,
					lastLogin=CLIENT.lastlogin,
					setClientVariable=1
				);
			}
		</cfscript>
        <!----
         <cfscript>
			// Host Family Leads Pop Up
				// Check if there are leads assigned to an Area Representative
				qGetNotifications = APPLICATION.CFC.USER.getNotifications(
					userType=CLIENT.userType,
					userID=CLIENT.userID, 
					regionID=CLIENT.regionID,
					lastLogin=CLIENT.lastlogin,
					setClientVariable=1
				);
			
		</cfscript>
        ---->
        <!--- Check if server is local, if it is do not redirect to SSL --->
		<cfif APPLICATION.IsServerLocal>
			
				<cflocation url="/nsmg/index.cfm?curdoc=initial_welcome" addtoken="no">
			
        <!--- Production / Force SSL if not Case --->
        <cfelse>
        <cfparam name="url.ref" default="">
       		<Cfif url.ref is 'studentApp'>
            	
            	<cflocation url="/nsmg/student_app/print_application.cfm?uniqid=#url.uniqid#" addtoken="no"> 
            <cfelse>
          	
            <cflocation url="#CLIENT.exits_url#/nsmg/index.cfm?curdoc=initial_welcome" addtoken="no">
			</Cfif>
        </cfif>
         
	</cffunction>


	<!--- This gets the access level of the user viewed, based on the company of the logged in user viewing that user.
	This returns one of the following for the userID passed in:
	a. 0 if the user has no access records in the SMG companies.
	b. the usertype of the access record with the company of the user logged in viewing this user.
	c. null if there are none in b. with that company
	called by: forms/user_form.cfm, user_info.cfm --->
	<cffunction name="get_access_level" access="public" returntype="string">
		<cfargument name="userID" type="string" required="yes">
		
        <cfscript>
			var get_usertypes = '';
			var get_company_usertypes = '';
			var usertype_list = '';
		</cfscript>

        <cfquery name="get_usertypes" datasource="#APPLICATION.dsn#">
            SELECT 
            	uar.companyid, 
                uar.usertype
            FROM 
            	user_access_rights uar
            WHERE 
                uar.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(userID)#">
                
			<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                AND          
                    uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
            <cfelse>
                AND          
                    uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#"> 
            </cfif>

            ORDER BY 
            	uar.usertype
        </cfquery>
       
        <!--- user has no access records. --->
        <cfif get_usertypes.recordCount EQ 0>
        
            <cfreturn 0>
            
        <cfelse>
        
        	<!--- get the usertypes of the company of the user logged in viewing this user. --->
            <cfquery name="get_company_usertypes" dbtype="query">
                SELECT usertype
                FROM get_usertypes
                WHERE (companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyid)#"> OR usertype = 8)
            </cfquery>
            
            <cfset usertype_list = valueList(get_company_usertypes.usertype)>
            
            <!--- if any are international, set to that. --->
            <cfif listFind(usertype_list, 8)>
            
                <cfreturn 8>
                
            <cfelse>
            
                <!--- If a user viewed has multiple levels used the highest.  If none, then returns null. --->
                <cfreturn listFirst(usertype_list)>
                
            </cfif>
            
        </cfif>

	</cffunction>

</cfcomponent>