<Cfdump var="#client#">
 <Cfscript>
		//Check if paperwork is complete for season
		qGetRegionalManager = APPLICATION.CFC.user.getRegionalManager(regionID=client.regionid);
 </cfscript>
 
 <Cfdump var="#qGetRegionalManager#">