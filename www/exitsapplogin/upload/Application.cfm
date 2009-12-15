
<cfapplication name="exits" sessionmanagement="yes">
<cfparam name="application.dsn" default="exitsapp">

<!--- if "resume login" is used login is not run.  Automatically logout if not the same day, so change password and verify info can be checked when they login again.
use isDefined because students don't have thislogin.  this is on application.cfm and nsmg/application.cfm --->
<cfif isDefined("session.thislogin") and session.thislogin NEQ dateFormat(now(), 'mm/dd/yyyy')>
	
	<cfinclude template="logout.cfm">
</cfif>