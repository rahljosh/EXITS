<cfif (ListFind("5,6,7,9", CLIENT.userType) AND ListFind(APPLICATION.SETTINGS.COMPANYLIST.publicHS, CLIENT.companyid)) >
                     <cfset tripcount = 7 - placed_students.Count>
                     <cfinclude template="slideshow/index.cfm">
         <table border=0>
        	<Tr>
             <cfif placed_students.Count LT 7>
            	<Td class="sticky" align="center">
             
                #tripcount#
                </Td>
                <td>
                 placements away from a trip to <A href="uploadedFiles/Incentive_trip/incentiveTrip_#client.companyid#.pdf" target="_blank">#incentive_trip.trip_place#!</A>
               
                <cfelse>
                 <td colspan=2>   You've earned a trip to <A href="uploadedFiles/Incentive_trip/incentiveTrip_#client.companyid#.pdf" target="_blank">#incentive_trip.trip_place#!!!</A> 
                </td></cfif>
           
                        
             </Tr>
         </table>
    </cfif>