<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		March 05, 2010
	Desc:		WebEx Index 

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param Variables --->
	<cfparam name="FORM.submitted" default="0">
    
    
    <cfscript>		
		APPCFC.webEx.listUser();
		
		/*
		APPCFC.webEx.createUser (
			firstName='Marcus',											
			lastName='Melo',
			webExUser='marcusmelosmg',
			email='marcus@student-management.com',
			password='test123'
		);
		*/
	
		//APPCFC.webEx.authenticateUser();
	
		//APPCFC.webEx.getMeetings();
	</cfscript>
    
</cfsilent>    



