<!--- ------------------------------------------------------------------------- ----
	
	File:		loginProcess.cfm
	Author:		Marcus Melo
	Date:		May 13, 2011
	Desc:		Process User/School Login

	Updated:  	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Authenticate User --->
    <cfquery name="qAuthenticateUser" datasource="#APPLICATION.dsn#">
        SELECT 
            u.userID,
            u.firstName,
            u.lastName,
            u.email,
            u.lastLogin,
            u.invoice_access,
            uar.usertype,
            c.companyID,
            c.companyName,
            c.companyShort,
            c.toll_free,
            c.phone,
            c.fax,
            c.company_color
        FROM 
            smg_users u
        INNER JOIN
            user_access_rights uar ON uar.userID = u.userID    
        INNER JOIN 
            smg_companies c ON uar.companyid = c.companyid
        WHERE 
            u.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(form.username)#">
        AND 
            u.password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(form.password)#">
        AND 	
            u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND
            c.website = <cfqueryparam cfsqltype="cf_sql_varchar" value="PHP">        
    </cfquery>
    
        
    <!--- Authenticate School --->
    <cfquery name="qAuthenticateSchool" datasource="#APPLICATION.dsn#">
        SELECT 
            schoolID,
            contact,
            email,
            lastLogin
        FROM 
            php_schools
        WHERE 
            email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.username)#"> 
        AND 
            password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.password)#">
        AND 
            active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfquery>

	<!--- Valid User Account --->
    <cfif VAL(qAuthenticateUser.recordcount)>
        
        <cfscript>
            // Set CLIENT Variables
            CLIENT.isLoggedIn = 1;
            CLIENT.userID = qAuthenticateUser.userID;
            CLIENT.usertype = qAuthenticateUser.usertype;
			CLIENT.firstname = qAuthenticateUser.firstname;
            CLIENT.lastname =  qAuthenticateUser.lastname;
            CLIENT.email = qAuthenticateUser.email;
            CLIENT.lastlogin = qAuthenticateUser.lastlogin;
            // this is currently used only in the menu
            CLIENT.invoice_access = qAuthenticateUser.invoice_access;
			// Company Information
            CLIENT.companyID = qAuthenticateUser.companyID;
            CLIENT.companyName = qAuthenticateUser.companyName;
            CLIENT.companyShort = qAuthenticateUser.companyShort;
			CLIENT.companyToll_free = qAuthenticateUser.toll_free;
			CLIENT.companyPhone = qAuthenticateUser.phone;
			CLIENT.companyFax = qAuthenticateUser.fax;
			CLIENT.companyColor = qAuthenticateUser.company_color;
        </cfscript>
        
        <!--- Update User Last Login --->
        <cfquery datasource="#APPLICATION.dsn#">
            UPDATE 
                smg_users
            SET 
                lastlogin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
            WHERE 
                userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
        </cfquery>
        
        <cfscript>
            // Go to Initial Welcome Page
            Location("internal/index.cfm?curdoc=initial_welcome", "no");
        </cfscript>
        
    <cfelseif VAL(qAuthenticateSchool.recordcount)>
    
        <cfquery name="qGetCompanyInfo" datasource="#APPLICATION.dsn#">
            SELECT 
                c.companyID,
                c.companyName,
                c.companyShort,
                c.toll_free,
                c.phone,
                c.fax,
                c.company_color
            FROM 
                smg_companies c
            WHERE 
                c.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="6">
        </cfquery>
    
        <cfscript>
            // Set CLIENT Variables
            CLIENT.isLoggedIn = 1;
            CLIENT.userID = qAuthenticateSchool.schoolID;
			CLIENT.usertype = 12;
            CLIENT.firstname = qAuthenticateSchool.contact;
            CLIENT.lastname =  '';
            CLIENT.email = qAuthenticateSchool.email;
            CLIENT.lastlogin = qAuthenticateSchool.lastlogin;
			// Company Information
            CLIENT.companyID = qGetCompanyInfo.companyID;
            CLIENT.companyName = qGetCompanyInfo.companyName;
            CLIENT.companyShort = qGetCompanyInfo.companyShort;
			CLIENT.companyToll_free = qGetCompanyInfo.toll_free;
			CLIENT.companyPhone = qGetCompanyInfo.phone;
			CLIENT.companyFax = qGetCompanyInfo.fax;
			CLIENT.companyColor = qGetCompanyInfo.company_color;
        </cfscript>
        
        <!--- Update School Last Login --->
        <cfquery datasource="#APPLICATION.dsn#">
            UPDATE 
                php_schools
            SET 
                lastlogin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
            WHERE 
                schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
        </cfquery>
        
        <cfscript>
            // Go to Initial Welcome Page
            Location("internal/index.cfm?curdoc=initial_welcome", "no");
        </cfscript>
        
    <cfelse>
    
        <cfscript>
            // NOT VALID LOGIN
            CLIENT.isLoggedIn = 0;
            Location("contactUs.cfm", "no");
        </cfscript>
    
    </cfif>

</cfsilent>