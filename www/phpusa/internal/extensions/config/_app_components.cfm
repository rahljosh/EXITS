<!--- ------------------------------------------------------------------------- ----
	
	File:		_app_components.cfm
	Author:		Marcus Melo
	Date:		March, 31 2010
	Desc:		This sets up components that are used accross page calls 
				global to the entire system. They are stored in the APPLICATION
				scope and are global to all users.
				
----- ------------------------------------------------------------------------- --->

<cfscript>
	/***** Create APPLICATION.CFC structure *****/
	APPLICATION.CFC = StructNew();

	// Set a short name for the CFCs
	AppCFC = APPLICATION.CFC;

	// Store the initialized UDF Library object in the Application scope
	AppCFC.UDF = CreateCFC("udf").Init();
	
	// Store Application.IsServerLocal - This needs be declare before the other CFC components
	APPLICATION.IsServerLocal = AppCFC.UDF.IsServerLocal();
	
	// Store the initialized company object in the Application scope
	AppCFC.company = CreateCFC("company").Init();

	// Store the initialized flightInformation object in the Application scope
	AppCFC.flightInformation = CreateCFC("flightInformation").Init();

	// Store the initialized Insurance object in the Application scope
	AppCFC.Insurance = CreateCFC("insurance").Init();
</cfscript>
