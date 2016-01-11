<!--- ------------------------------------------------------------------------- ----
	
	File:		home.cfm
	Author:		Marcus Melo
	Date:		September 26, 2011
	Desc:		MPD Tours
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<cfoutput>
    
	<!--- Include Trip Header --->
    <cfinclude template="_breadCrumb.cfm">


 <cfif now() gt '2015-09-17'>     
 <div style="background-color: ##fefe99; width: 580px; padding: 5px 30px 10px 30px; margin-left: auto; margin-right: auto; margin-bottom:20px;">
<h2>Instructions before applying for a trip!</h2>
<p>
1.  Get verbal permission (ask) your host family, area representative, regional manager, school (if missing days), if you have approval to go on a trip/s.</p>
<p>
2.  Book a tour/s and pay. (Please make sure your credit card is approved for the amount of the trip/s you are paying for and sufficient funds are available at your bank or credit card company so that you won't have a declined (not working) credit card payment on day of your purchase of a trip/s.</p> 

<p>3.  Contact our travel agent to get a price quote to see what an airplane ticket will cost approximately and then pay for your airline ticket separately than the trip payment (airfare is not included in tour package (trip).</p>

</div>
</cfif>
    <table width="600" height="333" border="0" align="center">
        
        <cfif 0  eq 1 >           
            <tr>
                <td colspan="4"> 
             <p>  The MPD TourAmerica website is currently under construction. We are hard at work updating our website content  to reflect available trips for the 2015-2016 season. Please check back on September 17, 2015 for information on all of our new trip offerings. Enrollment for these new trips will begin on September 17, 2015.</p>
 
<p>Thank you for your patience.  We are excited for a new year of great trips!</p>

<p> 
Sincerely,<br />
MPD TourAmerica</p>
                </td>
            </tr>
        <cfelse>
        <tr>
          <td colspan="4"> 
                <div style="font-weight:bold; color:##be1e2d; text-align:center; font-size:1.2em;">For our partner exchange organization students ONLY!</div>
		  </td>
        </tr> 
        
        <tr>
        <cfloop query="qGetTourList">
            <td width="285" height="270" class="bBackground" scope="row">
                <form action="#CGI.SCRIPT_NAME#?action=tripDetails" method="post">
                    <input type="hidden" name="action" value="tripDetails" />
                    <input type="hidden" name="tourID" value="#qGetTourList.tour_id#" />
                    <cfif APPLICATION.isServerLocal>
                    	<input type="image" name="submit" src="https://smg.local/nsmg/uploadedfiles/student-tours/#qGetTourList.tour_img1#.jpg" alt="#qGetTourList.tour_name# Details" /> <br />
                   	<cfelse>
                    	<input type="image" name="submit" src="https://ise.exitsapplication.com/nsmg/uploadedfiles/student-tours/#qGetTourList.tour_img1#.jpg" alt="#qGetTourList.tour_name# Details" /> <br />
                    </cfif>
                    
                    <p style="font-weight:bold; margin:3px;">#qGetTourList.tour_name#</p>
                    
                    <p style="margin:3px;">#qGetTourList.tour_date#</p>
                    
                    <p style="margin:3px;">
                   		Status: 
                        <strong>
							<cfif qGetTourList.tour_status EQ 'Cancelled'>
                            	Cancelled
                            <cfelseif qGetTourList.totalRegistrations LT qGetTourList.spotLimit>
                                Seats Available
							<cfelseif qGetTourList.totalRegistrations GTE qGetTourList.totalSpots>
								Full - No more seats available
                            <cfelseif qGetTourList.totalRegistrations GTE qGetTourList.spotLimit AND ( VAL(qGetTourList.extraMaleSpot) OR VAL(qGetTourList.extraFemaleSpot) )>
                            	Limited Seats Available
							<cfelseif qGetTourList.totalRegistrations GTE qGetTourList.spotLimit AND NOT VAL(qGetTourList.extraMaleSpot) AND NOT VAL(qGetTourList.extraFemaleSpot)>
								Full - No more seats available
                            <cfelse>
                            	Full - No more seats available             
							</cfif>
                        </strong>    
                    </p>
                </form>
            </td>
            <cfif currentrow MOD 2 EQ 0> 
                </tr>
                <tr>
                </tr>
            </cfif>
        </cfloop>    
      </cfif>
    </table>
            

    
</cfoutput>