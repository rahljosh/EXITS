<cfif (ListFind("5,6,7,9,15", CLIENT.userType) AND ListFind(APPLICATION.SETTINGS.COMPANYLIST.publicHS, CLIENT.companyid)) >
                     <cfset tripcount = 7 - placed_students.Count>
              <table>
              	<Tr>
                	<Td>
                     <cfinclude template="../slideshow/index.cfm">
                  	</Td>
                </Tr>
                <tr>
                	<td>
         <table border=0>
        	<Tr>
             <cfif placed_students.Count LT 7>
            	<Td class="sticky" align="center">
             <cfoutput>
                #tripcount#
             </cfoutput>
                </Td>
                <td>
                 placements away from a trip to <A href="../uploadedFiles/Incentive_trip/incentiveTrip_#client.companyid#.pdf" target="_blank"><cfoutput>#incentive_trip.trip_place#</cfoutput>!</A>
               
                <cfelse>
                 <td colspan=2>   You've earned a trip to <A href="../uploadedFiles/Incentive_trip/incentiveTrip_#client.companyid#.pdf" target="_blank"><cfoutput>#incentive_trip.trip_place#</cfoutput>!!!</A> 
                </td></cfif>
           
                        
             </Tr>
         </table>
         	</td>
            </tr>
            </table>
            
    </cfif>