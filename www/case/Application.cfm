<cfapplication name="caseusa_external" clientmanagement="yes" sessionmanagement="yes" setclientcookies="yes" setdomaincookies="yes" sessiontimeout="#CreateTimeSpan(0,10,40,1)#">

<cfscript>
	// Create a function that let us create CFCs from any location
	function CreateCFC(strCFCName){
		return(CreateObject("component", ("extensions.components." & ARGUMENTS.strCFCName)));
	}

	// Page Messages
	SESSION.PageMessages = CreateCFC("pageMessages").Init();
	
	// Form Errors
	SESSION.formErrors = CreateCFC("formErrors").Init();
	
	// Set up DSN information
	APPLICATION.DSN = StructNew();
	APPLICATION.DSN.Source = "caseusa";
	APPLICATION.DSN.Username = "";
	APPLICATION.DSN.Password = "";
	
	// Trips URL
	APPLICATION.tripsURL = "https://trips.exitsapplication.com";
	
		/*******************************************
			Create APPLICATION.CFC structure 
		*******************************************/
		APPLICATION.CFC = StructNew();
	
		// Set a short name for the CFCs
		AppCFC = APPLICATION.CFC;

		// Store the initialized UDF Library object in the Application scope
		APPLICATION.CFC.UDF = CreateCFC("udf").Init();
		
		// Store Application.IsServerLocal - This needs be declare before the other CFC components
		APPLICATION.IsServerLocal = APPLICATION.CFC.UDF.IsServerLocal();

		// Store the initialized metadata Library object in the Application scope
		APPLICATION.CFC.metadata = CreateCFC("metadata").Init();

		// Store the initialized paymentGateway Library object in the Application scope
		APPLICATION.CFC.paymentGateway = CreateCFC("paymentGateway").Init();
	
		// Store the initialized session Library object in the Application scope
		APPLICATION.CFC.SESSION = CreateCFC("session").Init();
</cfscript>


<cfquery name="selectdb" datasource="#APPLICATION.DSN.Source#">
	USE caseusa
</cfquery>

