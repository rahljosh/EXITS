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
<!----    <h1>Student Trips</h1>
    <div style="background-color: ##fefe99; width: 600px; padding: 20px; font-family:'Trebuchet MS', Arial, Helvetica, sans-serif; font-size: 14px; margin-left: auto; margin-right: auto; margin-bottom:20px;">
  <p>This website is currently undergoing maintenance.    <strong>Please check back in 1 hour. </strong>
  
  <!----This website is currently undergoing maintenance as we update information for 2013-2014 trips.    <strong>Please check back on Sept. 17, 2013 </strong>to sign up for upcoming  MPD tours and excursions.----></p>

</div>
---->
 <div style="background-color: ##fefe99; width: 580px; padding: 5px 30px 10px 30px; margin-left: auto; margin-right: auto; margin-bottom:20px;">
<h2>Instructions before applying for a trip!</h2>
<p>
1.  Get verbal permission (ask) your host family, area representative, regional manager, school (if missing days), if you have approval to go on a trip/s.</p>
<p>
2.  Book a tour/s and pay. (Please make sure your credit card is approved for the amount of the trip/s you are paying for and sufficient funds are available at your bank or credit card company so that you won't have a declined (not working) credit card payment on day of your purchase of a trip/s.</p> 

<p>3.  Contact our travel agent to get a price quote to see what an airplane ticket will cost approximately and then pay for your airline ticket separately than the trip payment (airfare is not included in tour package (trip).</p>

</div>
    <table width="600" height="333" border="0" align="center">
        <tr>
          <td colspan="4"> 
                <div style="font-weight:bold; color:##be1e2d; text-align:center; font-size:1.2em;">For our partner exchange organization students ONLY!</div>
            <!----    
            <p>
                    #APPLICATION.MPD.name# and our partner exchange organizations are proud to offer this year's Student Exchange Trips of exciting adventures across America.
                    #APPLICATION.MPD.name# will be organizing 8 trips, chaperoned and supervised exclusively by our representatives for the 2013-14 season.
              </p>
          <strong>NEW THIS SEASON: STUDENTS DO NOT PURCHASE THEIR OWN AIRFARE. Once you  are registered for a tour and receive a Confirmation of Payment, a  Blank Permission form and a Student Packet (travel packet) will be sent  via your e-mail <u>THEN YOU MAY</u> contact our travel agent at: <a href="mailto:dees626@verizon.net" target="_blank">dees626@verizon.net</a> or telephone number <u><a href="tel:626-376-1178" value="+16263761178" target="_blank">626-376-1178</a></u> for a flight but make sure you have verbal (ask for permission then get  form sent to us after all completed signatures are on form as soon as  possible). If you are on more than one tour then you need to get a form  for each individual trip!</strong><br /><br />
		  ---->
		  </td>
        </tr> 
        
        <cfif (#CGI.REMOTE_ADDR# is not '96.56.128.61' AND #CGI.REMOTE_ADDR# is not '198.228.201.148') >           
            <tr>
                <td colspan="4"> 
                    <h3><div align="center"><p>The MPD TourAmerica website is currently under construction. We are hard at work updating our website content  to reflect available trips for the 2014-2015 season. Please check back on September 15, 2014 for information on all of our new trip offerings. Enrollment for these new trips will begin on September 15, 2014.</p>
 
<p>Thank you for your patience.  We are excited for a new year of great trips!</p>
 
<p> 
Sincerely,<br />
MPD TourAmerica</p></div></h3>
                </td>
            </tr>
        <cfelse>
        
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