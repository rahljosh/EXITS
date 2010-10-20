<cfcomponent>
	
    <cfparam name="CLIENT.companyID" default="0">
    <!----This should be removed when SMG uses the global login page---->
	   
	<!--- Login.  called by: flash/login.cfm --->
	<cffunction name="login" access="public" returntype="string">
		<cfargument name="username" type="string" required="yes">
		<cfargument name="password" type="string" required="yes">

		<cfset var student_login = ''>
		<cfset var authenticate = ''>
		<cfset var get_access = ''>
		<cfset var get_default_access = ''>
		<cfset var get_companies = ''>

		<!--- Check if we are on Local Server --->
        <cfif APPLICATION.IsServerLocal>
        
            <cfquery name="qGetCompany" datasource="mysql">
                SELECT 
                    companyid, 
                    companyname
                FROM 
                    smg_companies 
                WHERE
                    url_ref LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%student-management.com"> 
            </cfquery>

        <!--- Production Server --->    
        <cfelse>
        
            <cfquery name="qGetCompany" datasource="mysql">
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

		<cfif NOT VAL(CLIENT.companyID) AND VAL(qGetCompany.recordcount)>
			<cfset CLIENT.companyid = qGetCompany.companyid>
            <cfset CLIENT.companyname = qGetCompany.companyname>
        <cfelseif NOT VAL(CLIENT.companyID)>
            <cfset CLIENT.companyid = 0>
            <cfset CLIENT.companyname = 'EXIT Group'>
        </cfif>
        
        <!----If error code SI-102, company information is wrong---->
        <cfquery name="submitting_info" datasource="#APPLICATION.dsn#">
            select website, url_ref, company_color
            from
            smg_companies
            where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        </cfquery>

        <cfif submitting_info.recordcount eq 0>
            Error during login.  Please try again shortly.
            <cfoutput>
            #cgi.server_name#
            </cfoutput>
            <cfabort>
        </cfif>
        
        <cfset CLIENT.company_submitting = "#submitting_info.website#">
        <cfset APPLICATION.company_short = "#submitting_info.website#">
        <cfset CLIENT.app_menu_comp = CLIENT.companyid>
        <cfset CLIENT.exits_url = "#submitting_info.url_ref#">
        <cfset CLIENT.color = "#submitting_info.company_color#">


		<!--- student login --->
        <cfquery name="student_login" datasource="#APPLICATION.dsn#">
            SELECT studentID, firstname, familylastname
            FROM smg_students
            WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(username)#">
            and password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(password)#">
            and active = 1
        </cfquery>
        
        <cfif student_login.recordcount gt 0>
            <cfset CLIENT.studentID = student_login.studentID>
            <cfset CLIENT.usertype = 10>
            <cfset CLIENT.userID = 0>
            <cfset CLIENT.name = '#student_login.firstname# #student_login.familylastname#'>

			<!--- Check if server is local, if it is do not redirect to SSL --->
            <cfif APPLICATION.IsServerLocal>
				
                <cflocation url="/nsmg/student_app/login.cfm" addtoken="no">
            
            <!--- Production / Force SSL --->    
            <cfelse>
            	
                <cflocation url="https://#CLIENT.exits_url#/nsmg/student_app/login.cfm" addtoken="no">
            
            </cfif>

        </cfif>

        <cfquery name="authenticate" datasource="#APPLICATION.dsn#">
            SELECT *
            FROM smg_users
            where username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(username)#">
            and password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(password)#">
            and active = 1
        </cfquery>
        
        <cfif authenticate.recordcount EQ 0>
        	<cfreturn 'Invalid Login'>            
        </cfif>
        
		<!--- get all of the user's access records in the SMG companies. --->
        <cfquery name="get_access" datasource="#APPLICATION.dsn#">
            SELECT user_access_rights.*
            FROM user_access_rights
            INNER JOIN smg_companies ON user_access_rights.companyid = smg_companies.companyid
            WHERE smg_companies.website = '#CLIENT.company_submitting#'
            AND user_access_rights.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#authenticate.userID#">
            ORDER BY user_access_rights.usertype
        </cfquery>

        <cfif get_access.recordcount EQ 0>
        	<cfreturn 'You have no Company & Regional Access record assigned.  One must be assigned first before you can login.  Contact your facilitator.'>            
        </cfif>

		<!--- get the user's default access record. --->
        <cfquery name="get_default_access" dbtype="query">
            SELECT *
            FROM get_access
            WHERE default_access = 1
        </cfquery>

		<!--- no default, so just use the first record. --->
        <cfif get_default_access.recordcount EQ 0>
            <cfquery name="get_default_access" dbtype="query" maxrows="1">
                SELECT *
                FROM get_access
            </cfquery>
        </cfif>

		<cfset CLIENT.userID = authenticate.userID>
		<cfset CLIENT.name = '#authenticate.firstname# #authenticate.lastname#'>
        <cfset CLIENT.email = authenticate.email>
        
        <!--- these are currently used only in the header & menu. --->
		<cfset CLIENT.levels = get_access.recordcount>  <!--- the number of access records the user has. --->
		<cfset CLIENT.compliance = authenticate.compliance>
		<cfset CLIENT.invoice_access = authenticate.invoice_access>
        
        <!--- these are set from the default access record.  These are also set in forms/change_access_level.cfm. --->
        <cfset CLIENT.companyid = get_default_access.companyid>
        <cfset CLIENT.usertype = get_default_access.usertype>
        <cfset CLIENT.regions = get_default_access.regionid>  <!--- these are both the same, but phase out CLIENT.regions --->
        <cfset CLIENT.regionid = get_default_access.regionid>
        
        <!--- companyname, programmanager and accesslevelname are used in header.cfm.  These are also set in forms/change_access_level.cfm. --->
        <cfquery name="qGetCompany" datasource="#APPLICATION.dsn#">
            SELECT companyname, team_id, pm_email, support_email, url, companyshort_nocolor, projectManager, financeEmail,website
            FROM smg_companies
            WHERE companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        </cfquery>
        
        <cfset CLIENT.companyname = qGetCompany.companyname>
        <cfset CLIENT.companyshort = qGetCompany.companyshort_nocolor>
	    <cfset CLIENT.programmanager = qGetCompany.team_id>
        <cfset CLIENT.programmanager_email = qGetCompany.pm_email>
        <cfset CLIENT.projectmanager_email = #qGetCompany.projectManager#>
        <cfset CLIENT.finance_email = qGetCompany.financeEmail>
		<cfset CLIENT.support_email = qGetCompany.support_email> 
        <cfset CLIENT.site_url = qGetCompany.url>
        <!----Get List of sub companies assigned to logged in company---->
        <cfquery name="company_list" datasource="#APPLICATION.dsn#">
        select companyid
        from smg_companies
        where website = '#qGetCompany.website#'
        </cfquery>
        <cfset compList = ''>
        <cfloop query="company_list">
        <cfset compList = #ListAppend(compList, companyid)#>
        </cfloop>
        <cfset CLIENT.globalCompanyList = '#compList#'>
        
        <cfquery name="get_usertype" datasource="#APPLICATION.dsn#">
            SELECT usertype
            FROM smg_usertype
            WHERE usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.usertype#">
        </cfquery>
        <cfset CLIENT.accesslevelname = get_usertype.usertype>
        <cfif CLIENT.regionid NEQ ''>
            <cfquery name="get_region" datasource="#APPLICATION.dsn#">
                SELECT regionname
                FROM smg_regions
                WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionid#">
            </cfquery>
            <cfset CLIENT.accesslevelname = "#CLIENT.accesslevelname# in #get_region.regionname#">
        </cfif>

        <cfquery name="get_companies" dbtype="query">
            SELECT DISTINCT companyid
            FROM get_access
        </cfquery>
		<cfset CLIENT.companies = valueList(get_companies.companyid)>

		<cfif CLIENT.usertype EQ 8>
            <cfset CLIENT.parentcompany = authenticate.userID>
        <cfelseif CLIENT.usertype GTE 9>
            <cfset CLIENT.parentcompany = authenticate.intrepid>
        </cfif>
        
        <cfset CLIENT.lastlogin = authenticate.lastlogin>

		<!---- Update Last Login ---->
        <cfquery datasource="#APPLICATION.dsn#">
        	UPDATE smg_users
            SET lastlogin = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
        	WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#authenticate.userID#">
        </cfquery>
        
        <!--- this is used only in APPLICATION.cfm to logout after 24 hours. --->
        <cfset CLIENT.thislogin = dateFormat(now(), 'mm/dd/yyyy')>

		<!--- this usertype doesn't need to verify information. --->
        <cfif CLIENT.usertype NEQ 11>
        	<!--- Verify user info. New user will have null, or it's been 90 days. --->
			<cfif authenticate.last_verification EQ '' OR dateDiff("d", authenticate.last_verification, now()) GTE 90>
            	<!--- this is checked in APPLICATION.cfm and redirected if set. --->
      	  		<cfset CLIENT.verify_info = 1>
            </cfif>
		</cfif>

        <!--- change password --->
        <cfif authenticate.changepass EQ 1>
			<!--- this is checked in APPLICATION.cfm and redirected if set. --->
            <cfset CLIENT.change_password = 1>      
		</cfif>
		
        <!----For Accounts Created after Sept 1, 2010---->
        
        <Cfif #authenticate.datecreated# gt '2010-09-01'>
       		<cfif #DateDiff('d',authenticate.datecreated, now())# gte 21>
				<!----Check if WebEX Training has been completed ---->
                <cfif listfind('5,6,7', client.usertype)>
                    <cfquery name="webexTraining" datasource="#application.dsn#">
                    select notes
                    from smg_users_training
                    where notes = 'New Area Reps'
                    and user_id = #client.userid#
                    </cfquery>
                   
                    <cfif webexTraining.recordcount eq 0 and client.regionid neq 16>
                        <cfset CLIENT.trainingNeeded = 1>
                        <cflocation url="/nsmg/trainingNeeded.cfm">
                    </cfif>
               </Cfif>
           </cfif>
        <cfelse>
        	<cfif isDefined('client.trainingNeeded')>
        		<cfset temp = StructDelete(client.trainingNeeded,1)>
    		</cfif>
        </Cfif>
        <!--- Check if server is local, if it is do not redirect to SSL --->
		<cfif APPLICATION.IsServerLocal>

			<cflocation url="/nsmg/index.cfm?initial_welcome" addtoken="no">
		
        <!--- Production / Force SSL if not Case --->
        <cfelse>
        
			<cfif client.companyid eq 10>
                <cflocation url="http://#CLIENT.exits_url#/nsmg/index.cfm?curdoc=initial_welcome" addtoken="no">
            <cfelse>
                <cflocation url="https://#CLIENT.exits_url#/nsmg/index.cfm?curdoc=initial_welcome" addtoken="no">
            </cfif>

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

		<cfset var get_usertypes = ''>
        <cfset var get_company_usertypes = ''>
        <cfset var usertype_list = ''>

        <cfquery name="get_usertypes" datasource="#APPLICATION.dsn#">
            SELECT user_access_rights.companyid, user_access_rights.usertype
            FROM user_access_rights
            INNER JOIN smg_companies ON user_access_rights.companyid = smg_companies.companyid
            WHERE smg_companies.website = '#CLIENT.company_submitting#'
            AND user_access_rights.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#userID#">
            ORDER BY user_access_rights.usertype
        </cfquery>
        <!--- user has no access records. --->
        <cfif get_usertypes.recordCount EQ 0>
            <cfreturn 0>
        <cfelse>
        	<!--- get the usertypes of the company of the user logged in viewing this user. --->
            <cfquery name="get_company_usertypes" dbtype="query">
                SELECT usertype
                FROM get_usertypes
                WHERE (companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#"> OR usertype = 8)
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