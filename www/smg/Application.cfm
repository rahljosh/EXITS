<cfapplication 
	name="smg" 
    clientmanagement="yes">
    
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

	<cfscript>
        // Check if we need to initialize Application scope
		if ( VAL(URL.init) ) {
			// Clear the Application structure	
			StructClear(APPLICATION.CFC);	
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
		
		// Check if this is Dev or Live 
		if ( APPLICATION.isServerLocal ) {
			// Development Server Settings	
			
			// Set Site URL
			APPLICATION.site_url = 'http://dev.student-management.com';
			
		} else {
			// Live Server Settings
			
			// Set Site URL
			APPLICATION.site_url = 'http://www.student-management.com';
			
		}		
	</cfscript>
