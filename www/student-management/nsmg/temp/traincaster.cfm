<cfscript>
	vGetLoginURL = APPLICATION.CFC.USER.generateTraincasterLoginLink(userID=510);
	
	vTraincasterMessage = APPLICATION.CFC.USER.importTraincasterTestResults(companyID=1,date="2012-03-01");

	// ISE
	if ( ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID) ) {
		
		vProgramSponsor = "International Student Exchange";	
		vTrainCasterToken = "VtGxtRJTV33nVK2qZk8H";
	
	// CASE
	} else {
		
		vProgramSponsor = "Cultural Academic Student Exchange";
		vTrainCasterToken = "";
		
	}
	
	vBuildURL = "https://doslocalcoordinatortraining.traincaster.com/app/clients/doslocalcoordinatortraining/Training_Recs.pm?token=#vTrainCasterToken#&program_sponsor=#vProgramSponsor#&date=2012-4-17";
</cfscript>

<cfoutput>

    <p><a href="#vGetLoginURL#" target="_blank">Login Here</a></p>
    
    <p>#vBuildURL#</p>
    
    <p><a href="#vBuildURL#" target="_blank">Report Here</a></p>
    
	#vTraincasterMessage#
	    
</cfoutput>