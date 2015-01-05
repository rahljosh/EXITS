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
	try {	
		
		if ( NOT IsStruct(APPLICATION.CFC) ) {
			APPLICATION.CFC = StructNew();
		}
		
	} catch (Any e) {
		
		APPLICATION.CFC = StructNew();
	
	}
	
	// Set a short name for the CFCs
	AppCFC = APPLICATION.CFC;

	// Store the initialized UDF Library object in the Application scope
	APPLICATION.CFC.UDF = CreateCFC("udf").Init();
	
	// Store Application.IsServerLocal - This needs be declare before the other CFC components
	APPLICATION.IsServerLocal = APPLICATION.CFC.UDF.IsServerLocal();

	// Store the initialized CBC object in the Application scope
	APPLICATION.CFC.CBC = CreateCFC("cbc").Init();

	// Store the initialized Company object in the Application scope
	APPLICATION.CFC.Company = CreateCFC("company").Init();

	// Store the initialized document object in the Application scope
	APPLICATION.CFC.document = CreateCFC("document").Init();

	// Store the initialized Host object in the Application scope
	APPLICATION.CFC.Host = CreateCFC("host").Init();

	// Store the initialized Insurance object in the Application scope
	APPLICATION.CFC.Insurance = CreateCFC("insurance").Init();
	
	// Store the initialized invoice object in the Application scope
	APPLICATION.CFC.Invoice = CreateCFC("invoice").Init();

	// Store the initialized LookUpTables object in the Application scope
	APPLICATION.CFC.LookUpTables = CreateCFC("lookUpTables").Init();

	// Store the initialized onlineApplication object in the Application scope
	APPLICATION.CFC.onlineApplication = CreateCFC("onlineApplication").Init();

	// Store the initialized pdfDoc object in the Application scope
	APPLICATION.CFC.pdfDoc = CreateCFC("pdfDoc").Init();

	// Store the initialized Program object in the Application scope
	APPLICATION.CFC.Program = CreateCFC("program").Init();
	
	// Store the initialized Tour object in the Application scope
	APPLICATION.CFC.Tour = CreateCFC("tour").Init();

	// Store the initialized Progress Report object in the Application scope
	APPLICATION.CFC.ProgressReport = CreateCFC("progressReport").Init();
	
	// Store the initialized Region object in the Application scope
	APPLICATION.CFC.Region = CreateCFC("region").Init();

	// Store the initialized School object in the Application scope
	APPLICATION.CFC.School = CreateCFC("school").Init();

	// Store the initialized Student object in the Application scope
	APPLICATION.CFC.Student = CreateCFC("student").Init();

	// Store the initialized User object in the Application scope
	APPLICATION.CFC.User = CreateCFC("user").Init();
	
	// Store the initialized CaseMgmt object in the Application scope
	APPLICATION.CFC.caseMgmt = CreateCFC("caseMgmt").Init();
</cfscript>
