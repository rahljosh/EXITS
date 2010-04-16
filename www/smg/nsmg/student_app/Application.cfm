<cfapplication 
	name="smg" 
    clientmanagement="yes">

	<!--- Keep the same application name as ../Application.cfm so they can share the same APPLICATION variables --->
    
    <cfparam name="APPLICATION.DSN" default="MySQL">
    <cfparam name="APPLICATION.support_email" default="support@student-management.com">
    <cfparam name="APPLICATION.site_url" default="http://www.student-management.com">

	<!--- Param Client Variables --->
    <cfparam name="CLIENT.companyShort" default="SMG"> 
    <cfparam name="CLIENT.support_email" default="support@student-management.com"> 
		       

	<!--- Added by Marcus Melo - 11/20/2009 --->
    <cfscript>
		if ( StructKeyExists(APPLICATION, "CFC") ) {
			// Set a short name for the CFCs
			AppCFC = APPLICATION.CFC;
		}
	
		if ( StructKeyExists(APPLICATION, "Path") ) {
		   // Set a short name for the APPLICATION.PATH
			AppPath = APPLICATION.PATH;
		}

		if ( StructKeyExists(APPLICATION, "EMAIL") ) {
			// Set a short name for the APPLICATION.EMAIL
			AppEmail = APPLICATION.EMAIL;
		}
		
		if ( StructKeyExists(APPLICATION, "CONSTANTS") ) {
			// Set a short name for the CFCs
			CONSTANTS = APPLICATION.CONSTANTS;
		}
		
		// List of User IDs that are not allowed to submit Online Applications
		// Dream I - 03/23/2010
        APPLICATION.submitAppNotAllowed = "6559"; 
		
		// List of User IDs that are not allowed to view the Student and Host Family Profile
		// Current Intl. Rep: STB
		APPLICATION.displayProfileNotAllowed = "19";
    </cfscript>


	<!--- always allow logout. --->
    <cfif not findNoCase("../logout.cfm", getBaseTemplatePath())>
        <!--- force verify user information. --->
        <cfif isDefined("client.verify_info")>
            <!--- allow user only on user info and user form. --->
            <cfif NOT (isDefined("url.curdoc") AND listFindNoCase("user_info,forms/user_form", url.curdoc))>
                <cflocation url="../nsmg/index.cfm?curdoc=user_info&userid=#client.userid#" addtoken="no">
            </cfif>
        <!--- force change password. --->
        <cfelseif isDefined("client.change_password")>
            <!--- allow user only on change password page. --->
            <cfif NOT (isDefined("url.curdoc") AND url.curdoc EQ 'forms/change_password')>
                <cflocation url="../nsmg/index.cfm?curdoc=forms/change_password" addtoken="no"><br />
            </cfif>
        </cfif>
    </cfif>
    
    <!--- if "resume login" is used login is not run.  Automatically logout if not the same day, so change password and verify info can be checked when they login again.
    use isDefined because students don't have thislogin.  this is on APPLICATION.cfm and nsmg/APPLICATION.cfm --->
    <cfif isDefined("client.thislogin") and client.thislogin NEQ dateFormat(now(), 'mm/dd/yyyy')>
        <!--- don't do a cflocation because we'll get an infinite loop. --->
        <cfinclude template="../../nsmg/logout.cfm">
    </cfif>
