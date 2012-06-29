<!--- ------------------------------------------------------------------------- ----
	
	File:		_traincasterLogin.cfm
	Author:		Marcus Melo
	Date:		April 17, 2012
	Desc:		Traincaster Login	
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<cfscript>
        // Generate URL Login
		vGenerateLogin = APPLICATION.CFC.USER.generateTraincasterLoginLink(uniqueID=URL.uniqueID);
		
		// Login
		location(vGenerateLogin, "no");
    </cfscript> 
       
</cfsilent>