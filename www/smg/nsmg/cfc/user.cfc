
<cfcomponent>
	
    <cfparam name="CLIENT.companyID" default="0">
    <!----This should be removed when SMG uses the global login page---->
	
        <cfquery name="get_company" datasource="mysql">
        select companyid, companyname
        from smg_companies where url_ref = '#cgi.server_name#' 
        </cfquery>
        
        <cfif get_company.recordcount neq 0>
            <cfset client.companyid = #get_company.companyid#>
            <cfset client.companyname = '#get_company.companyname#'>
        <cfelse>
            <cfset client.companyid = 0>
            <cfset client.companyname = 'EXIT Group'>
        </cfif>
    
    <!----If error code SI-102, company information is wrong---->
    <cfquery name="submitting_info" datasource="#application.dsn#">
    select website from
    smg_companies
    where companyid = #client.companyid#
    </cfquery>
    
	<cfif submitting_info.recordcount eq 0>
        Error durring login.  Please try again shortly.
        <cfoutput>
        #cgi.server_name#
        </cfoutput>
        <cfabort>
    </cfif>
    
        <cfset client.company_submitting = "#submitting_info.website#">
        <cfset application.company_short = "#submitting_info.website#">
        <cfset client.app_menu_comp = #client.companyid#>
 
    
	<!--- Login.  called by: flash/login.cfm --->
	<cffunction name="login" access="public" returntype="string">
		<cfargument name="username" type="string" required="yes">
		<cfargument name="password" type="string" required="yes">

		<cfset var student_login = ''>
		<cfset var authenticate = ''>
		<cfset var get_access = ''>
		<cfset var get_default_access = ''>
		<cfset var get_companies = ''>

		<!--- student login --->
        <cfquery name="student_login" datasource="#application.dsn#">
            SELECT studentid, firstname, familylastname
            FROM smg_students
            WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(username)#">
            and password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(password)#">
            and active = 1
        </cfquery>
        
        <cfif student_login.recordcount gt 0>
            <cfset client.studentid = student_login.studentid>
            <cfset client.usertype = 10>
            <cfset client.userid = student_login.studentid>
            <cfset client.name = '#student_login.firstname# #student_login.familylastname#'>
            <cflocation url="/nsmg/student_app/login.cfm" addtoken="no">
        </cfif>

        <cfquery name="authenticate" datasource="#application.dsn#">
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
        <cfquery name="get_access" datasource="#application.dsn#">
            SELECT user_access_rights.*
            FROM user_access_rights
            INNER JOIN smg_companies ON user_access_rights.companyid = smg_companies.companyid
            WHERE smg_companies.website = '#client.company_submitting#'
            AND user_access_rights.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#authenticate.userid#">
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

		<cfset client.userid = authenticate.userid>
		<cfset client.name = '#authenticate.firstname# #authenticate.lastname#'>
        <cfset client.email = authenticate.email>
        
        <!--- these are currently used only in the header & menu. --->
		<cfset client.levels = get_access.recordcount>  <!--- the number of access records the user has. --->
		<cfset client.compliance = authenticate.compliance>
		<cfset client.invoice_access = authenticate.invoice_access>
        
        <!--- these are set from the default access record.  These are also set in forms/change_access_level.cfm. --->
        <cfset client.companyid = get_default_access.companyid>
        <cfset client.usertype = get_default_access.usertype>
        <cfset client.regions = get_default_access.regionid>  <!--- these are both the same, but phase out client.regions --->
        <cfset client.regionid = get_default_access.regionid>
        
        <!--- companyname, programmanager and accesslevelname are used in header.cfm.  These are also set in forms/change_access_level.cfm. --->
        <cfquery name="get_company" datasource="#application.dsn#">
            SELECT companyname, team_id, support_email, url, companyshort_nocolor
            FROM smg_companies
            WHERE companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        </cfquery>
        <cfset client.companyname = get_company.companyname>
        <cfset client.companyshort = get_company.companyshort_nocolor>
	    <cfset client.programmanager = get_company.team_id>
        <cfset client.support_email = get_company.support_email> 
        <cfset client.site_url = get_company.url>
        
        <cfquery name="get_usertype" datasource="#application.dsn#">
            SELECT usertype
            FROM smg_usertype
            WHERE usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.usertype#">
        </cfquery>
        <cfset client.accesslevelname = get_usertype.usertype>
        <cfif client.regionid NEQ ''>
            <cfquery name="get_region" datasource="#application.dsn#">
                SELECT regionname
                FROM smg_regions
                WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
            </cfquery>
            <cfset client.accesslevelname = "#client.accesslevelname# in #get_region.regionname#">
        </cfif>

        <cfquery name="get_companies" dbtype="query">
            SELECT DISTINCT companyid
            FROM get_access
        </cfquery>
		<cfset client.companies = valueList(get_companies.companyid)>

		<cfif client.usertype EQ 8>
            <cfset client.parentcompany = authenticate.userid>
        <cfelseif client.usertype GTE 9>
            <cfset client.parentcompany = authenticate.intrepid>
        </cfif>
        
        <cfset client.lastlogin = authenticate.lastlogin>

		<!---- Update Last Login ---->
        <cfquery datasource="#application.dsn#">
        	UPDATE smg_users
            SET lastlogin = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
        	WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#authenticate.userid#">
        </cfquery>
        
        <!--- this is used only in application.cfm to logout after 24 hours. --->
        <cfset client.thislogin = dateFormat(now(), 'mm/dd/yyyy')>

		<!--- this usertype doesn't need to verify information. --->
        <cfif client.usertype NEQ 11>
        	<!--- Verify user info. New user will have null, or it's been 90 days. --->
			<cfif authenticate.last_verification EQ '' OR dateDiff("d", authenticate.last_verification, now()) GTE 90>
            	<!--- this is checked in application.cfm and redirected if set. --->
      	  		<cfset client.verify_info = 1>
            </cfif>
		</cfif>

        <!--- change password --->
        <cfif authenticate.changepass EQ 1>
			<!--- this is checked in application.cfm and redirected if set. --->
            <cfset client.change_password = 1>      
		</cfif>

		<cflocation url="/nsmg/index.cfm?curdoc=initial_welcome" addtoken="no">

	</cffunction>


	<!--- This gets the access level of the user viewed, based on the company of the logged in user viewing that user.
	This returns one of the following for the userid passed in:
	a. 0 if the user has no access records in the SMG companies.
	b. the usertype of the access record with the company of the user logged in viewing this user.
	c. null if there are none in b. with that company
	called by: forms/user_form.cfm, user_info.cfm --->
	<cffunction name="get_access_level" access="public" returntype="string">
		<cfargument name="userid" type="string" required="yes">

		<cfset var get_usertypes = ''>
        <cfset var get_company_usertypes = ''>
        <cfset var usertype_list = ''>

        <cfquery name="get_usertypes" datasource="#application.dsn#">
            SELECT user_access_rights.companyid, user_access_rights.usertype
            FROM user_access_rights
            INNER JOIN smg_companies ON user_access_rights.companyid = smg_companies.companyid
            WHERE smg_companies.website = '#client.company_submitting#'
            AND user_access_rights.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#userid#">
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
                WHERE (companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#"> OR usertype = 8)
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