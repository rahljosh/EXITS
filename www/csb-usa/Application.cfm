<cfapplication
	name="CSB-USA" 
    clientmanagement="yes" 
    sessionmanagement="yes" 
    sessiontimeout="#CreateTimeSpan(0,0,20,0)#">
    
	<cfscript>
        // Check if we need to initialize Application scope

		// Create a function that let us create CFCs from any location
		function CreateCFC(strCFCName){
            return(CreateObject("component", ("extensions.components." & ARGUMENTS.strCFCName)));
        }
		
	   // Page Messages
	   SESSION.PageMessages = CreateCFC("pageMessages").Init();
	
	   // Form Errors
	   SESSION.formErrors = CreateCFC("formErrors").Init();
	</cfscript>