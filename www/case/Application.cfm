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
		APPLICATION.DSN.Source = "mySql";
		APPLICATION.DSN.Username = "";
		APPLICATION.DSN.Password = "";
</cfscript>

<cfquery name="selectdb" datasource="caseusa">

	USE caseusa

</cfquery>

