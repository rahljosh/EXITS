<cfif (ListFind("5,6,7,9,15", CLIENT.userType) AND ListFind(APPLICATION.SETTINGS.COMPANYLIST.publicHS, CLIENT.companyid)) >

	<cfscript>
		tripcount = 7 - vPlacedStudents;
		vDeadline = CreateDate(Year(NOW()),9,8);
	</cfscript>
    
	<cfoutput>
        <table>
            <tr>
                <td>
                    <cfinclude template="../slideshow/index.cfm">
                </td>
            </tr>
            <tr>
                <td>
                    <table border=0>
                        <tr>
                            <cfif vPlacedStudents LT 7>
                                <td class="sticky" align="center">
                                    #tripcount#
                                </td>
                                <td>
                                    placements away from a trip to 
                                    <a href="uploadedFiles/Incentive_trip/incentiveTrip_#client.companyid#.pdf" target="_blank">
                                        #incentive_trip.trip_place#!
                                    </a>
                                </td>
                            <cfelse>
                                <td colspan=2 style="font-size:16px; color:##C55;">
                                    <img src="pics/warning.png" width="25px" />  You've earned a trip to 
                                    <b><a href="uploadedFiles/Incentive_trip/incentiveTrip_#client.companyid#.pdf" target="_blank" style="color:##C55;">#incentive_trip.trip_place#!!!</a></b> 
                                    <!--- Only show within deadline --->
									<cfif DateCompare(vDeadline,NOW()) GTE 0>
                                    	Please enter your and any guest's information by #DateFormat(vDeadline,'mm/dd/yyyy')# <b><a href="?curdoc=incentiveTripDetails" style="color:##C55;">HERE</a></b>.
									</cfif>
                                </td>
                            </cfif>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </cfoutput>
            
</cfif>