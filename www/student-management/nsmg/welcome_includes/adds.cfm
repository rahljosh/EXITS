<cfif (ListFind("5,6,7,9,15", CLIENT.userType) AND ListFind(APPLICATION.SETTINGS.COMPANYLIST.publicHS, CLIENT.companyid)) >

	<cfscript>
		tripcount = 7 - placed_students.Count;
		vDeadline = CreateDate(Year(NOW()),9,1);
		vAdd = 0;
		vDay = DayOfWeek(vDeadline);
		if (vDay EQ 1) {
			vAdd = 8;	
		} else if (vDay EQ 2) {
			vAdd = 7;	
		} else {
			vAdd = 14 - (vDay - 2);	
		}
		vDeadline = DateAdd('d',vAdd,vDeadline);
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
                            <cfif placed_students.Count LT 7>
                                <td class="sticky" align="center">
                                    #tripcount#
                                </td>
                                <td>
                                    placements away from a trip to 
                                    <a href="../uploadedFiles/Incentive_trip/incentiveTrip_#client.companyid#.pdf" target="_blank">
                                        #incentive_trip.trip_place#!
                                    </a>
                                </td>
                            <cfelse>
                                <td colspan=2 style="font-size:16px; color:##C55;">
                                    <img src="pics/warning.png" width="25px" />  You've earned a trip to 
                                    <b><a href="../uploadedFiles/Incentive_trip/incentiveTrip_#client.companyid#.pdf" target="_blank" style="color:##C55;">#incentive_trip.trip_place#!!!</a></b> 
                                    <!---
                                    Please enter your and any guest's information by #DateFormat(vDeadline,'mm/dd/yyyy')# <b><a href="?curdoc=incentiveTripDetails" style="color:##C55;">HERE</a></b>.
									--->
                                </td>
                            </cfif>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </cfoutput>
            
</cfif>