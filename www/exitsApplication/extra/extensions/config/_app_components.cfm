<!--- ------------------------------------------------------------------------- ----
	
	File:		_app_components.cfm
	Author:		Marcus Melo
	Date:		October, 14 2010
	Desc:		This sets up components that are used accross page calls 
				global to the entire system. They are stored in the APPLICATION
				scope and are global to all users.
				
----- ------------------------------------------------------------------------- --->

<cfscript>
	/***** Create APPLICATION.CFC structure *****/
	APPLICATION.CFC = StructNew();
	
	// Set a short name for the APPLICATION.CFC
	AppCFC = APPLICATION.CFC;
	
	// Store the initialized UDF Library object in the Application scope
	APPLICATION.CFC.UDF = CreateCFC("udf").Init();
	
	// Store Application.IsServerLocal - This needs be declare before the other CFC components
	APPLICATION.IsServerLocal = APPLICATION.CFC.UDF.IsServerLocal();
	
	// Store the initialized candidate Library object in the Application scope
	APPLICATION.CFC.candidate = CreateCFC("candidate").Init();
	
	// Store the initialized content Library object in the Application scope
	APPLICATION.CFC.content = CreateCFC("content").Init();
	
	// Store the initialized document Library object in the Application scope
	APPLICATION.CFC.document = CreateCFC("document").Init();
	
	// Store the initialized email Library object in the Application scope
	APPLICATION.CFC.email = CreateCFC("email").Init();

	// Store the initialized flight information Library object in the Application scope
	APPLICATION.CFC.flightInformation = CreateCFC("flightInformation").Init();

	// Store the initialized flight information Library object in the Application scope
	APPLICATION.CFC.hostCompany = CreateCFC("hostCompany").Init();

	// Store the initialized lookUpTables Library object in the Application scope
	APPLICATION.CFC.lookUpTables = CreateCFC("lookUpTables").Init();
	
	// Store the initialized onlineApp Library object in the Application scope
	APPLICATION.CFC.onlineApp = CreateCFC("onlineApp").Init();

	// Store the initialized program Library object in the Application scope
	APPLICATION.CFC.program = CreateCFC("program").Init();

	// Store the initialized User Library object in the Application scope
	APPLICATION.CFC.user = CreateCFC("user").Init();
	
	// Store the initialized User Library object in the Application scope
	APPLICATION.CFC.sevis = CreateCFC("sevis").Init();
	
	// Store the initialized User Library object in the Application scope
	APPLICATION.CFC.company = CreateCFC("company").Init();
</cfscript>
