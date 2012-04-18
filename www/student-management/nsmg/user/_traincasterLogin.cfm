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
		vGenerateLogin = APPLICATION.CFC.UDF.generateTraincasterLoginLink(userID=VAL(URL.userID));
		
		// Login
		location(vGenerateLogin, "no");
    </cfscript> 
       
</cfsilent>