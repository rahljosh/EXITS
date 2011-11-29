<cfapplication 
	name="smg" 
    clientmanagement="yes"
    sessionmanagement="yes"
    sessiontimeout="#CreateTimeSpan( 0, 12, 0, 0 )#">    
    
	<!---<CFQUERY name="selectdb" datasource="MySQL" >
        USE smg
    </CFQUERY>--->
    
    <cfparam name="APPLICATION.DSN" default="MySQL">
    
    <!--- if "resume login" is used login is not run.  Automatically logout if not the same day, so change password and verify info can be checked when they login again.
    use isDefined because students don't have thislogin.  this is on application.cfm and nsmg/application.cfm --->
    <cfif isDefined("client.thislogin") and client.thislogin NEQ dateFormat(now(), 'mm/dd/yyyy')>
        <!--- don't do a cflocation because we'll get an infinite loop. --->
        <cfinclude template="/nsmg/logout.cfm">
    </cfif>
    
	<!--- Param URL variable --->
	<cfparam name="URL.init" default="0">

	<!--- Param Client Variables --->
	<cfparam name="CLIENT.companyID" default="0">
	<cfparam name="CLIENT.userID" default="0">
    <cfparam name="CLIENT.studentID" default="0"> 
    <cfparam name="CLIENT.userType" default="0">
    
    <cfquery name="qCompanyInfo" datasource="mysql">
        SELECT
            companyID,
            support_email,
            url_ref
        FROM
            smg_companies
        WHERE
            companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    </cfquery>
	    
	<cfscript>
        // Check if we need to initialize Application scope
		if ( VAL(URL.init) ) {
			// Clear the Application structure	
			StructClear(APPLICATION);	
		}
		
		// Create a function that let us create CFCs from any location
		function CreateCFC(strCFCName){
            return(CreateObject("component", ("nsmg.extensions.components." & ARGUMENTS.strCFCName)));
        }
		
		/***** Create APPLICATION.CFC structure *****/
		APPLICATION.CFC = StructNew();
		
		// Store the initialized UDF Library object in the Application scope
		APPLICATION.CFC.UDF = CreateCFC("udf").Init();
		
		// Store Application.IsServerLocal - This needs be declare before the other CFC components
		APPLICATION.IsServerLocal = APPLICATION.CFC.UDF.IsServerLocal();
	</cfscript>

    <cfif APPLICATION.isServerLocal>
    	<cfparam name="CLIENT.exits_url" default="http://ise.exitsapplication.com">  
	<cfelse>
		<cfparam name="CLIENT.exits_url" default="https://ise.exitsapplication.com">      	
    </cfif>

	<!--- Include Application Config Files --->
	<cfinclude template="nsmg/extensions/config/_app_index.cfm" />    
