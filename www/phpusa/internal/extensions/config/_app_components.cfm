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
	APPLICATION.CFC.UDF = CreateCFC("udf").Init();
	
	// Store Application.IsServerLocal - This needs be declare before the other CFC components
	APPLICATION.IsServerLocal = AppCFC.UDF.IsServerLocal();
	
	// Store the initialized company object in the Application scope
	APPLICATION.CFC.company = CreateCFC("company").Init();

	// Store the initialized flightInformation object in the Application scope
	APPLICATION.CFC.flightInformation = CreateCFC("flightInformation").Init();

	// Store the initialized host object in the Application scope
	APPLICATION.CFC.host = CreateCFC("host").Init();

	// Store the initialized insurance object in the Application scope
	APPLICATION.CFC.insurance = CreateCFC("insurance").Init();

	// Store the initialized lookUpTables object in the Application scope
	APPLICATION.CFC.lookUpTables = CreateCFC("lookUpTables").Init();

	// Store the initialized program object in the Application scope
	APPLICATION.CFC.program = CreateCFC("program").Init();

	// Store the initialized school object in the Application scope
	APPLICATION.CFC.school = CreateCFC("school").Init();

	// Store the initialized student object in the Application scope
	APPLICATION.CFC.student = CreateCFC("student").Init();

	// Store the initialized student object in the Application scope
	APPLICATION.CFC.user = CreateCFC("user").Init();
</cfscript>
