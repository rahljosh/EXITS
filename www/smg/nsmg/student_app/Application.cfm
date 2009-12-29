<cfapplication name="smg" clientmanagement="yes">
<cfparam name="application.dsn" default="MySQL">
<cfparam name="application.support_email" default="support@student-management.com">
<cfparam name="application.site_url" default="http://www.student-management.com">

<!--- Added by Marcus Melo - 11/20/2009 --->
<cfscript>
	/***** Create APPLICATION.EMAIL structure *****/
	APPLICATION.EMAIL = StructNew();		
	APPLICATION.EMAIL.support = 'support@student-management.com';
	APPLICATION.EMAIL.finance = 'marcel@student-management.com';
	APPLICATION.EMAIL.errors = 'errors@student-management.com';
	// Set a short name for the CFCs
	AppEmail = APPLICATION.EMAIL;
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
use isDefined because students don't have thislogin.  this is on application.cfm and nsmg/application.cfm --->
<cfif isDefined("client.thislogin") and client.thislogin NEQ dateFormat(now(), 'mm/dd/yyyy')>
	<!--- don't do a cflocation because we'll get an infinite loop. --->
	<cfinclude template="../nsmg/logout.cfm">
</cfif>

