<!--- ------------------------------------------------------------------------- ----
	
	File:		_app_components.cfm
	Author:		Marcus Melo
	Date:		June, 14 2010
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

	// Store the initialized Document Library object in the Application scope
	AppCFC.Document = CreateCFC("document").Init();

	// Store the initialized Email Library object in the Application scope
	AppCFC.Email = CreateCFC("email").Init();

	// Store the initialized OnlineApp Library object in the Application scope
	AppCFC.lookUpTables = CreateCFC("lookUpTables").Init();

	// Store the initialized OnlineApp Library object in the Application scope
	AppCFC.onlineApp = CreateCFC("onlineApp").Init();

	// Store the initialized session Library object in the Application scope
	AppCFC.SESSION = CreateCFC("session").Init();

	// Store the initialized Student Library object in the Application scope
	AppCFC.student = CreateCFC("student").Init();
</cfscript>
