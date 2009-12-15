<cfapplication name="smg" clientmanagement="yes">
<!---<CFQUERY name="selectdb" datasource="MySQL" >
	USE smg
</CFQUERY>--->

	<cfparam name="application.dsn" default="MySQL">

    <!--- Param URL variable --->
	<cfparam name="URL.init" default="0">
    <cfparam name="URL.init2" default="0">

	<!--- Param Client Variables --->
	<cfparam name="CLIENT.companyID" default="0">
	<cfparam name="CLIENT.userID" default="0">
    <cfparam name="CLIENT.studentID" default="0">  
    <cfparam name="CLIENT.regionID" default="0">  
	<cfparam name="CLIENT.name" default=""> 
    <cfparam name="CLIENT.userType" default="9">   
    <cfparam name="CLIENT.companyName" default="">  
    <cfparam name="CLIENT.parentCompany" default="">   
    <cfparam name="CLIENT.company_submitting" default="">  
    <cfparam name="CLIENT.lastLogin" default="">  
	<cfparam name="CLIENT.programManager" default="">


<!--- if "resume login" is used login is not run.  Automatically logout if not the same day, so change password and verify info can be checked when they login again.
use isDefined because students don't have thislogin.  this is on application.cfm and nsmg/application.cfm --->
<cfif isDefined("client.thislogin") and client.thislogin NEQ dateFormat(now(), 'mm/dd/yyyy')>
	<!--- don't do a cflocation because we'll get an infinite loop. --->
	<cfinclude template="/nsmg/logout.cfm">
</cfif>


