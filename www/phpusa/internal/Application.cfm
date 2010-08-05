<cfapplication name="phpusa" clientmanagement="yes">

    <cfparam name="APPLICATION.DSN" default="MySQL">
    <cfparam name="APPLICATION.site_url" default="http://www.phpusa.com">

    <!--- Param URL variable --->
	<cfparam name="URL.init" default="0">
    <cfparam name="URL.init2" default="0">

	<cfscript>
        // Create a function that let us create CFCs from any location
        function CreateCFC(strCFCName){
            return(CreateObject("component", ("extensions.components." & ARGUMENTS.strCFCName)));
        }

		// Check if we need to initialize Application scope
		if ( VAL(URL.init) ) {
			// Clear the Application structure	
			StructClear(APPLICATION.CFC);	
		}
	</cfscript>

    
    <!--- Include Config Files --->
    <cfinclude template="extensions/config/_index.cfm" />    


