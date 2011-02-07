<!--- ------------------------------------------------------------------------- ----
	
	File:		flightInformationReport.cfm
	Author:		Marcus Melo
	Date:		January 19, 2011
	Desc:		Scheduled Task - Emails flight information entered/updated 
				in the last 24 hours.
				It should be scheduled to run daily.

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	
	
    <cfscript>
		// Get flights updated in the last 24 hours
		qGetArrivals = APPLICATION.CFC.FLIGHTINFORMATION.getDailyFlightReport(flightType='Arrival');	

		// Get flights updated in the last 24 hours
		qGetDepartures = APPLICATION.CFC.FLIGHTINFORMATION.getDailyFlightReport(flightType='Departure');	
	</cfscript>

</cfsilent>

<cfsavecontent variable="flightReport">

	<!--- Arrival Information --->
    <fieldset style="margin: 5px 0px 20px 0px; padding: 10px; border: ##DDD 1px solid;">
        
        <legend style="color: ##666; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">FLIGHT ARRIVALS</legend>

        <cfif qGetArrivals.recordCount>
            
            <cfoutput query="qGetArrivals" group="candidateID">
                
                <div style="color: ##666; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">
                    #qGetArrivals.firstName# #qGetArrivals.lastName# (###qGetArrivals.candidateID#) - #qGetArrivals.businessName#
                </div>
				
                <table cellspacing="1" style="width: 100%; border:1px solid ##0069aa; margin-bottom:15px; padding:0px;">	
                    <tr style="color: ##fff; font-weight: bold; text-align:center; background-color: ##0069aa;">
                        <td style="padding:4px 0px 4px 0px;">Date</td>
                        <td style="padding:4px 0px 4px 0px;">Depart <br /> City</td>
                        <td style="padding:4px 0px 4px 0px;">Depart <br /> Airport Code</td>
                        <td style="padding:4px 0px 4px 0px;">Arrive <br /> City</td>
                        <td style="padding:4px 0px 4px 0px;">Arrive <br /> Airport Code</td>
                        <td style="padding:4px 0px 4px 0px;">Flight <br /> Number</td>
                        <td style="padding:4px 0px 4px 0px;">Depart <br /> Time</td>
                        <td style="padding:4px 0px 4px 0px;">Arrive <br /> Time</td>
                        <td style="padding:4px 0px 4px 0px;">Overnight <br /> Flight</td>
                    </tr>                                

                    <cfoutput>
                        <tr style="text-align:center; <cfif qGetArrivals.currentRow MOD 2>background-color: ##EEEEEE;</cfif> ">
                            <td style="padding:4px 0px 4px 0px;">#qGetArrivals.departDate#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetArrivals.departCity#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetArrivals.departAirportCode#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetArrivals.arriveCity#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetArrivals.arriveAirportCode#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetArrivals.flightNumber#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetArrivals.departTime#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetArrivals.arriveTime#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetArrivals.isOvernightFlight#</td>
                        </tr>                         
                    </cfoutput>    						
                
                </table>
                
                <br />
                
            </cfoutput>
    
        <cfelse>
            
            <table cellspacing="0" style="width: 100%; border:1px solid ##0069aa; margin-bottom:15px; padding:0px;">	
                <tr style="color: ##fff; font-weight: bold; background-color: ##0069aa;">
                    <td style="padding:4px 0px 4px 0px;">No flight entered/updated in the last 24 hours</td>
                </tr>                                
            </table>
			
        </cfif>

	</fieldset>
    
    <br />
    
	<!--- Departure Information --->
    <fieldset style="margin: 5px 0px 20px 0px; padding: 10px; border: ##DDD 1px solid;">
        
        <legend style="color: ##666; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">FLIGHT DEPARTURES</legend>

        <cfif qGetDepartures.recordCount>
            
            <cfoutput query="qGetDepartures" group="candidateID">
                
                <div style="color: ##666; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">
                    #qGetDepartures.firstName# #qGetDepartures.lastName# (###qGetDepartures.candidateID#) - #qGetDepartures.businessName#
                </div>

                <table cellspacing="1" style="width: 100%; border:1px solid ##0069aa; margin-bottom:15px; padding:0px;">	
                    <tr style="color: ##fff; font-weight: bold; text-align:center; background-color: ##0069aa;">
                        <td style="padding:4px 0px 4px 0px;">Date</td>
                        <td style="padding:4px 0px 4px 0px;">Depart <br /> City</td>
                        <td style="padding:4px 0px 4px 0px;">Depart <br /> Airport Code</td>
                        <td style="padding:4px 0px 4px 0px;">Arrive <br /> City</td>
                        <td style="padding:4px 0px 4px 0px;">Arrive <br /> Airport Code</td>
                        <td style="padding:4px 0px 4px 0px;">Flight <br /> Number</td>
                        <td style="padding:4px 0px 4px 0px;">Depart <br /> Time</td>
                        <td style="padding:4px 0px 4px 0px;">Arrive <br /> Time</td>
                        <td style="padding:4px 0px 4px 0px;">Overnight <br /> Flight</td>
                    </tr>                                

                    <cfoutput>
                        <tr style="text-align:center; <cfif qGetDepartures.currentRow MOD 2>background-color: ##EEEEEE;</cfif> ">
                            <td style="padding:4px 0px 4px 0px;">#qGetDepartures.departDate#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetDepartures.departCity#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetDepartures.departAirportCode#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetDepartures.arriveCity#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetDepartures.arriveAirportCode#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetDepartures.flightNumber#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetDepartures.departTime#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetDepartures.arriveTime#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetDepartures.isOvernightFlight#</td>
                        </tr>                         
                    </cfoutput>    						
                
                </table>
                
                <br />
                
            </cfoutput>
    
        <cfelse>
            
            <table cellspacing="0" style="width: 100%; border:1px solid ##0069aa; margin-bottom:15px; padding:0px;">	
                <tr style="color: ##fff; font-weight: bold; background-color: ##0069aa;">
                    <td style="padding:4px 0px 4px 0px;">No flight entered/updated in the last 24 hours</td>
                </tr>                                
            </table>
			
        </cfif>

	</fieldset>

    <br />	
    
    <cfoutput>
        <div style="margin:5px 0px 10px 0px;">
			Flight Information Report Sent On #DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm:ss tt')# 
        </div>
	</cfoutput>
        
</cfsavecontent>

<cfscript>
	// Send Email
	if ( qGetArrivals.recordCount OR qGetDepartures.recordCount ) {
	
		APPLICATION.CFC.EMAIL.sendEmail(
			emailTo=APPLICATION.EMAIL.flightReport,
			emailSubject='EXTRA - WAT - Daily Flight Report',
			emailMessage=flightReport
		);
	
	}
	
	WriteOutput(flightReport);
</cfscript>
