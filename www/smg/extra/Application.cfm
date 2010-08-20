<cfapplication 
	name="extra" 
    clientmanagement="yes" 
    sessionmanagement="yes" 
    sessiontimeout="#CreateTimeSpan(0,3,0,0)#">
    
    <CFQUERY name="selectdb" datasource="MySQL" >
        USE smg
    </CFQUERY>
    
	<!--- Param URL variables --->
	<cfparam name="URL.init" default="0">
	<cfparam name="URL.link" default="">
	
    <!--- Param CLIENT variables --->
	<cfparam name="CLIENT.companyID" default="0">
    
	<cfscript>
        // Check if we need to initialize Application scope
		if ( VAL(URL.init) ) {
			// Clear the Application structure	
			StructClear(APPLICATION.CFC);	
		}
		
		// Create a function that let us create CFCs from any location
		function CreateCFC(strCFCName){
            return(CreateObject("component", ("extensions.components." & ARGUMENTS.strCFCName)));
        }


		// Store User Defined Functions
		APPLICATION.UDF = StructNew();
		APPLICATION.UDF.CreateCFC = CreateCFC;
	
	
		// Set up DSN information
		APPLICATION.DSN = StructNew();
		APPLICATION.DSN.Source = "mySql";
		APPLICATION.DSN.Username = "";
		APPLICATION.DSN.Password = "";

		
		/***** Create APPLICATION.CFC structure *****/
		APPLICATION.CFC = StructNew();
		
		// Store the initialized UDF Library object in the Application scope
		APPLICATION.CFC.UDF = CreateCFC("udf").Init();
		
		// Store Application.IsServerLocal - This needs be declare before the other CFC components
		APPLICATION.IsServerLocal = APPLICATION.CFC.UDF.IsServerLocal();
		
		// Store the initialized candidate Library object in the Application scope
		APPLICATION.CFC.CANDIDATE = CreateCFC("candidate").Init();

		// Store the initialized lookUpTables Library object in the Application scope
		APPLICATION.CFC.LOOKUPTABLES = CreateCFC("lookUpTables").Init();

		// Store the initialized User Library object in the Application scope
		APPLICATION.CFC.USER = CreateCFC("user").Init();
		
		
		
		/***** Create APPLICATION.PATH structure *****/
		APPLICATION.PATH = StructNew();		
		// Set a short name for the APPLICATION.PATH
		AppPath = APPLICATION.PATH;
		
		/* jQuery Latest Version 
		http://code.jquery.com/jquery-latest.min.js  /  http://code.jquery.com/jquery.js */		
		AppPath.jQuery = 'https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js';	
	</cfscript>
