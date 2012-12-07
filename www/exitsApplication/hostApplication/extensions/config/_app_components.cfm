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

	// Store the initialized UDF Library object in the Application scope
	APPLICATION.CFC.UDF = CreateCFC("udf").Init();

	// Store Application.IsServerLocal - This needs be declare before the other CFC components
	APPLICATION.IsServerLocal = APPLICATION.CFC.UDF.IsServerLocal();

	// Store the initialized COMPANY Library object in the Application scope
	APPLICATION.CFC.COMPANY = CreateCFC("company").Init();

	// Store the initialized DOCUMENT Library object in the Application scope
	APPLICATION.CFC.DOCUMENT = CreateCFC("document").Init();

	// Store the initialized HOST Library object in the Application scope
	APPLICATION.CFC.HOST = CreateCFC("host").Init();

	// Store the initialized lookUpTables Library object in the Application scope
	APPLICATION.CFC.LOOKUPTABLES = CreateCFC("lookUpTables").Init();

	// Store the initialized session Library object in the Application scope
	APPLICATION.CFC.SESSION = CreateCFC("session").Init();
</cfscript>
