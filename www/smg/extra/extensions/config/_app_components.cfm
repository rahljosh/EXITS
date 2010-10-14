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
	AppCFC.UDF = CreateCFC("udf").Init();
	
	// Store Application.IsServerLocal - This needs be declare before the other CFC components
	APPLICATION.IsServerLocal = APPLICATION.CFC.UDF.IsServerLocal();
	
	// Store the initialized candidate Library object in the Application scope
	AppCFC.candidate = CreateCFC("candidate").Init();
	
	// Store the initialized content Library object in the Application scope
	AppCFC.content = CreateCFC("content").Init();
	
	// Store the initialized document Library object in the Application scope
	AppCFC.document = CreateCFC("document").Init();
	
	// Store the initialized email Library object in the Application scope
	AppCFC.email = CreateCFC("email").Init();
	
	// Store the initialized lookUpTables Library object in the Application scope
	AppCFC.lookUpTables = CreateCFC("lookUpTables").Init();
	
	// Store the initialized onlineApp Library object in the Application scope
	AppCFC.onlineApp = CreateCFC("onlineApp").Init();
	
	// Store the initialized User Library object in the Application scope
	AppCFC.user = CreateCFC("user").Init();
</cfscript>
