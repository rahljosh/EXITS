<cfapplication
	name="CSB-USA" 
    clientmanagement="yes" 
    sessionmanagement="yes" 
    sessiontimeout="#CreateTimeSpan(0,0,20,0)#">
    
    <cfparam name="CLIENT.userType" default="">
    
	<cfscript>
        // Check if we need to initialize Application scope

		// Create a function that let us create CFCs from any location
		function CreateCFC(strCFCName){
            return(CreateObject("component", ("extensions.components." & ARGUMENTS.strCFCName)));
        }
		
		// Store the initialized UDF Library object in the Application scope
		APPLICATION.CFC.UDF = CreateCFC("udf");
		
		// Store Application.IsServerLocal - This needs be declare before the other CFC components
		APPLICATION.IsServerLocal = APPLICATION.CFC.UDF.IsServerLocal();
		
		if (APPLICATION.IsServerLocal) {
			APPLICATION.UPLOAD = 'C:\websites\www\csb-usa\uploadedfiles\';
			APPLICATION.EXTRAUPLOAD = "C:\websites\www\exitsApplication\extra\internal\uploadedfiles\csbfiles\";
		} else {
			APPLICATION.UPLOAD = 'C:\websites\csb-usa\uploadedfiles\';
			APPLICATION.EXTRAUPLOAD = "C:\websites\exitsApplication\extra\internal\uploadedfiles\csbfiles\";
		}
		
		if (NOT DirectoryExists(APPLICATION.EXTRAUPLOAD)) {
			DirectoryCreate(APPLICATION.EXTRAUPLOAD);	
		}
		
	   // Page Messages
	   SESSION.PageMessages = CreateCFC("pageMessages").Init();
	
	   // Form Errors
	   SESSION.formErrors = CreateCFC("formErrors").Init();
	</cfscript>