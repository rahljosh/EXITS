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

	// Store the initialized CBC object in the Application scope
	AppCFC.CBC = CreateCFC("cbc").Init();

	// Store the initialized Company object in the Application scope
	AppCFC.Company = CreateCFC("company").Init();

	// Store the initialized Host object in the Application scope
	AppCFC.Host = CreateCFC("host").Init();

	// Store the initialized Host object in the Application scope
	AppCFC.Insurance = CreateCFC("insurance").Init();

	// Store the initialized Other object in the Application scope
	AppCFC.LookUpTables = CreateCFC("lookUpTables").Init();

	// Store the initialized Program object in the Application scope
	AppCFC.pdfDoc = CreateCFC("pdfDoc").Init();

	// Store the initialized Program object in the Application scope
	AppCFC.Program = CreateCFC("program").Init();

	// Store the initialized Progress Report object in the Application scope
	AppCFC.ProgressReport = CreateCFC("progressReport").Init();
	
	// Store the initialized Region object in the Application scope
	AppCFC.Region = CreateCFC("region").Init();

	// Store the initialized School object in the Application scope
	AppCFC.School = CreateCFC("school").Init();

	// Store the initialized Student object in the Application scope
	AppCFC.Student = CreateCFC("student").Init();

	// Store the initialized User object in the Application scope
	AppCFC.User = CreateCFC("user").Init();

</cfscript>
