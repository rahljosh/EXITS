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

	// Store the initialized udf Library object in the Application scope
	AppCFC.UDF = CreateCFC("udf").Init();
	
	// Store Application.IsServerLocal - This needs be declare before the other CFC components
	APPLICATION.IsServerLocal = AppCFC.UDF.IsServerLocal();

	// Store the initialized adminTool Library object in the Application scope
	AppCFC.adminTool = CreateCFC("adminTool").Init();

	// Store the initialized content Library object in the Application scope
	AppCFC.Content = CreateCFC("content").Init();

	// Store the initialized document Library object in the Application scope
	AppCFC.Document = CreateCFC("document").Init();

	// Store the initialized email Library object in the Application scope
	AppCFC.Email = CreateCFC("email").Init();

	// Store the initialized lookUpTables Library object in the Application scope
	AppCFC.lookUpTables = CreateCFC("lookUpTables").Init();

	// Store the initialized OnlineApp Library object in the Application scope
	AppCFC.onlineApp = CreateCFC("onlineApp").Init();

	// Store the initialized paymentGateway Library object in the Application scope
	AppCFC.paymentGateway = CreateCFC("paymentGateway").Init();

	// Store the initialized session Library object in the Application scope
	AppCFC.SESSION = CreateCFC("session").Init();

	// Store the initialized student Library object in the Application scope
	AppCFC.student = CreateCFC("student").Init();
	
	// Store the initialized user Library object in the Application scope
	AppCFC.user = CreateCFC("user").Init();
</cfscript>
