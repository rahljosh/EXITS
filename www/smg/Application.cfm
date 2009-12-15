<cfapplication name="smg" clientmanagement="yes">
<!---<CFQUERY name="selectdb" datasource="MySQL" >
	USE smg
</CFQUERY>--->
<cfparam name="application.dsn" default="MySQL">

<!--- if "resume login" is used login is not run.  Automatically logout if not the same day, so change password and verify info can be checked when they login again.
use isDefined because students don't have thislogin.  this is on application.cfm and nsmg/application.cfm --->
<cfif isDefined("client.thislogin") and client.thislogin NEQ dateFormat(now(), 'mm/dd/yyyy')>
	<!--- don't do a cflocation because we'll get an infinite loop. --->
	<cfinclude template="/nsmg/logout.cfm">
</cfif>