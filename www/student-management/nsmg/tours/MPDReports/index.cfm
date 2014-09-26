<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		James Griffiths
	Date:		June 26, 2012
	Desc:		Tours reports index
				
				#CGI.SCRIPT_NAME#?curdoc=tours/MPDReports/index			
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <cfscript>
		// Param Variables
		param name="action" default="menu";
		
		// Get all tours
		qGetToursList = APPLICATION.CFC.TOUR.getAllActiveTours();
	</cfscript>
	
</cfsilent>
	
<!--- Check to see which action we are taking. --->

<cfswitch expression="#action#">
	
    <!--- Email addresses per trip report --->
    <cfcase value="emailAddressesPerTrip">
        <cfinclude template="emailAddressesPerTrip.cfm" />
    </cfcase>
    
    <!--- Missing permission forms per tour report --->
    <cfcase value="permissionFormPerTour">
        <cfinclude template="permissionFormPerTour.cfm" />
    </cfcase>
    
    <!--- Missing flight information per tour report --->
    <cfcase value="flightInformationPerTour">
        <cfinclude template="flightInformationPerTour.cfm" />
    </cfcase>
    
      <!--- Missing payment information per tour report --->
    <cfcase value="paymentHistory">
        <cfinclude template="paymentHistory.cfm" />
    </cfcase>
    
    <!--- Menu Options --->
    <cfdefaultcase>
        <cfinclude template="menu.cfm" />
    </cfdefaultcase>

</cfswitch>