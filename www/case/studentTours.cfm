<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Tour FAQs</title>
<link href="css/maincss.css" rel="stylesheet" type="text/css" />
<script src="SpryAssets/SpryTabbedPanels.js" type="text/javascript"></script>
<link href="SpryAssets/SpryTabbedPanels.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
a:link {
	color: #003;
	text-decoration: none;
}
a:visited {
	color: #003;
	text-decoration: none;
}
a:hover {
	color: #003;
	text-decoration: none;
}
a:active {
	color: #003;
	text-decoration: none;
}
a {
	font-weight: bold;
}
.lightGreen {
	color: #000;
	
	background-repeat: repeat;
	text-align: center;
	background-color: #a5aac7;
}
-->
</style></head>

<body>

<div id="wrapper">
<cfinclude template="includes/header.cfm">
<div id="mainbody">
<cfinclude template="includes/leftsidebar.cfm">
<div id="trip">
    <div id="TabbedPanels1" class="TabbedPanels">
      <ul class="TabbedPanelsTabGroup">
        <li class="TabbedPanelsTab" tabindex="0">Student Tours</li>
        <li class="TabbedPanelsTab" tabindex="0">Contact Info</li>
        <li class="TabbedPanelsTab" tabindex="0">Rules & Policies</li>
        
        <li class="TabbedPanelsTab" tabindex="0">FAQs</li>
        <li class="TabbedPanelsTab" tabindex="0"><a href="index.cfm">CASE Home</a></li>
      </ul>
      <div class="TabbedPanelsContentGroup">
        <div class="TabbedPanelsContent">
         <cfquery name="tours" datasource="mysql">
			SELECT * FROM smg_tours where tour_status <> 'inactive'
		</cfquery>
          <cfoutput>
          <table width="573" height="333" border="0" align="Center">
              	<tr>
                	<td>
                    We are currently re-working our tours process.  Please check back shorlty to book a tour. 
                <!----
            	<cfloop query="tours">
              
              <td width="285" height="178" class="lightGreen" scope="row" align="center"><a href="tours.cfm?tour_id=#tour_id#" >
             
              <img src="images/trips_#tour_id#.png" width="239" height="165" alt="#tour_name#" border="0" /></a><br />
              #tour_name#<br />
              #tour_date#<br />
              Status: <cfif tour_status eq 'Active'>Seats Available<cfelse>#tour_status#</cfif></td>
					<cfif currentrow mod 2 eq 0> 
                    </tr>
                    <tr>
                </cfif>
                </cfloop>   
				---->
                </tr>
                </table> 
           </cfoutput>
          <p>&nbsp;</p>
        </div>
        <div class="TabbedPanelsContent">
          <p>MPD TOUR AMERICA, INC.</p>
          <p>9101 SHORE ROAD, # 203<br />
            BROOKLYN, NY   11209<br />
            TOLL FREE: 1-800-983-7780<br />
            TELEPHONE: 1-718-439-8480<br />
            FAX: 1-718-439-8565<br />
            E-MAIL: info@mpdtoursamerica.com</p>
        </div>
        <div class="TabbedPanelsContent">
          
          <span class="normtext">
   <h3 align="Center">Rules and Policies</h3>
                
                	<ul>
                  	<li>**All Flights must be booked through our Travel Agent</li>
                  	<li>**All paperwork must be submitted before we are able to book your flight</li>
                  </ul>
          
           <h3 align="Center">Instructions:</h3>
                  			 <ol>
                                       <li>Visit case-usa.org to book and pay for your trip.
                                        <li>Once your payment has been processed (up to 72 hours), you will receive an email with:
                                        <ul><li>payment confirmation
                                        	<li>required permission form
                                        </ul>
                                        <li>Submit permission form with all signatures to MPD Tours.
                                        	<ul><li>info@mpdtoursamerica.com
                                        		<li>mail:  9101 Shore Road, #203 - Brooklyn, NY 11209
                                        	</ul>
                                        <li>When permission form is processed (up to 72 hours), you will receive an email with:
                                        	<ul><li>confirmation that permission for was received
                                        		<li>travel packet with specific information for your tour
                                        	</li></ul>
                                        <li>You will be contacted shortly after you permission form is processed by our authorized Travel Agent regarding your travel arrangements. You do not need to contact the agent yourself.
                                        <li>Once you select a flight itinerary, you will need to purchase this itinerary THROUGH OUR TRAVEL AGENT.
                                <li> Enjoy Your Trip!!!
                               </ol>	
                               <div align="Center">DO NOT BOOK YOUR OWN AIRFARE. You will be contated regarding airfare.</div>
                               </span>
          <p>Terms and Conditions</p>
          <span class="normtext">
           
                  <li class="paragraphRules">The tour member and guardians agree to abide by all of CASE &amp; MPD Tour America, Inc. policies and rules in order to ensure each participant's safety, health, welfare and our smooth management of tours.<br />
                    <br />
                </span><li class="paragraphRules">Participants and guardians acknowledge that CASE or MPD Tour America may terminate any participant's tour at its sole discretion. Tour termination may be caused by rule violations that CASE or MPD Tour America, Inc. deems to endanger anyone or impedes the success of the tour. In such a case the participant will be sent home at his or her own expense and there will be no refund whatsoever.<br />
                  <br />
                <li class="paragraphRules"> All program participants are required to have medical coverage at the time of travel. CASE &amp; MPD Tour America, Inc. do not assume any medical costs.<br />
                  <br />

                <li class="paragraphRules">CASE &amp; MPD Tour America, Inc. reserve the right to cancel any program with insufficient participation, limit enrollment in any tour and make substitutions or alterations to the itinerary as necessary.<br />
                  <br />
                <li class="paragraphRules">CASE &amp; MPD Tour America, Inc. may use photographs, videotapes or testimonials of participants for marketing purpose. Such use will be without remuneration.<br />
                  <br />
                <li class="paragraphRules">MPD Tour America, Inc. acts as an agent only &amp; accepts no responsibility for loss, damage or injury resulting from delay or negligence of any company or vendor in the service of MPD Tour America, Inc.<br />
                  <br />
                <li  class="paragraphRules">Responsibility Clause: MPD Tour America, Inc. its officers, directors, employees, shareholders, affiliates, subsidiaries and agents do not own or operate any entity which provides goods or services for your trip including, for example. lodging, transportation, meals, etc. As a result, MPD Tour America, Inc. is not liable for any third party not under its control. Without limiting the foregoing in any risks or resulting injury, delay, inconvenience, damages or death resulting from criminal activity, weather or other acts of God, accidents, illness, physical activities, strikes, political unrest, acts of terrorism, or other events beyond its control. Participants and guardians assume these risks.<br />
                  <br />
                <li class="paragraphRules">Participation in these tours constitutes specific consent for the tour member to take part in all tour activities, amusement park rides, as well as biking, rollerblading, surfing, canoeing, boating, sailing or other similar activities and to travel in public transportation and private leased or hired vehicles.<br />
                  <br />
                <li class="paragraphRules">Any dispute concerning this contract, the brochure, or any tour will be resolved exclusively though arbitration in the state of New York pursuant to the current rules of the American Arbitration Association.<br />
          </span></div>
       
        <div class="TabbedPanelsContent">
          <p><a name="gQuestions" id="gQuestions"></a>General Questions</p>
          <span class="normtext">
            <ul>
              <li><a href= #BookTour>How to book a tour?</a></li>
              <li><a href= #TourCost>What’s included in the tour cost?</a></li>
              <li><a href= #notIncluded>What will I have to pay for that is NOT included in my tour package?</a></li>
              <li><a href= #hotelRooms>How are hotel rooms assigned? Can I bring a friend, host brother or host sister?</a></li>
              <li><a href= #deposit>Who do I send my deposit form, payments and permission form to?</a></li>
              <li><a href= #contact>Who do I contact to ask questions about tour, payments, etc.?</a></li>
              <li><a href= #tourAcceptance>How do I know I am accepted on a tour?</a></li>
              <li><a href= #bookFlight>How do I book a flight?  (We do not book flights, only assist).</a></li>
              <li><a href= #ticketRefund>Is my airplane ticket refundable?</a></li>
              <li><a href= #tours>Can I go on more than one tour?</a></li>
              <li><a href= #permission>Do I need permission to go on tours?</a></li>
              <li><a href= #refuse>Can my exchange program refuse me permission to travel?</a></li>
              <li><a href= #emergency>Will I have an emergency phone number awhile on tour for myself and my parents?</a></li>
            </ul>
          </span>
          <p>Chaperone Questions</p>
          <span class="normtext">
            <ul>
              <li>Are these tours chaperoned?</li>
              <li>Are there areas and times that  students are not supervised?</li>
              <li>How many adults are in charge on every trip?</li>
            </ul>
          </span>
          <p>Payment Questions</p>
          <span class="normtext">
            <ul>
              <li>How do I pay for a trip?</li>
              <li>I paid you online and you didn’t respond?</li>
              <li>Will I be confirmed of payment or confirmation number given?</li>
              <li>Can I make several payments?</li>
              <li>What happens if I change my mind about a tour selection or want to cancel a trip?</li>
            </ul>
          </span>
          <p><a name="BookTour" id="BookTour"></a>How to book a tour?</p>
          <span class="normtext">
           <ol>
                                       <li>Visit case-usa.org to book and pay for your trip.
                                        <li>Once your payment has been processed (up to 72 hours), you will receive an email with:
                                        <ul><li>payment confirmation
                                        	<li>required permission form
                                        </ul>
                                        <li>Submit permission form with all signatures to MPD Tours.
                                        	<ul><li>info@mpdtoursamerica.com
                                        		<li>mail:  9101 Shore Road, #203 - Brooklyn, NY 11209
                                        	</ul>
                                        <li>When permission form is processed (up to 72 hours), you will receive an email with:
                                        	<ul><li>confirmation that permission for was received
                                        		<li>travel packet with specific information for your tour
                                        	</li></ul>
                                        <li>You will be contacted shortly after you permission form is processed by our authorized Travel Agent regarding your travel arrangements. You do not need to contact the agent yourself.
                                        <li>Once you select a flight itinerary, you will need to purchase this itinerary THROUGH OUR TRAVEL AGENT.
                                <li> Enjoy Your Trip!!!
                               </ol>	
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
          <p><a name="TourCost" id="TourCost"></a>What's included in the tour cost?</p>
          <span class="normtext">
            <p>Breakfast, dinner, entrance fees to all listed attractions, airport transfers, transportation while on tour, hotel accommodations, professional tour staff, chaperones, taxes and tips.</p>
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
          <p><a name="notIncluded" id="notIncluded"></a>What will I have to pay for that is NOT included in my tour package?</p>
          <span class="normtext">
            <p>Airfare, transportation costs to the airport and returning transportation to host family, spending money for lunches, shopping, snacks,  and personal expenses.  Approximately $8.00 per day for lunches and snacks.  Shopping for clothes, etc is up to your budget.</p>
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
          <p><a name="hotelRooms" id="hotelRooms"></a>How are hotel rooms assigned? Can I bring a friend, host brother or host sister?</p>
          <span class="normtext">
            <p>Hotel rooms are (Quad) 4 students assigned to a room – all same gender.  If you request a friend, host brother or host sister (of high school age 15-19 of same gender) you can be assigned together if you request early enough when signing up for a tour.  Just complete this request on your permission form online and mail out completed form to MPD Tour America, Inc.  Also, a lot of students do not know anyone before tour begins, but everyone makes a lot of new friends.</p>
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
          <p><a name="deposit" id="deposit"></a>Who do I send mypermission form to?</p>
          <span class="normtext">
            <p>Not to CASE!</p>
          </span><span class="normtext">
              <p>Please send your completed permission forms to:</p>
              <p>MPD Tour America, Inc.<br />
                9101 Shore Road, Suite 203<br />
                Brooklyn, New York   11209</p>
              </span><span class="backToTop"><a href= #gQuestions>
                <p>Back to top</p>
                </a></span>
          <p><a name="contact" id="contact"></a>Who do I contact to ask questions about tour, payments, etc.?</p>
          <span class="normtext">
            <p>Contact: MPD Tour America, Inc., it’s best to write an e-mail (info@mpdtoursamerica.com) or you can leave a detailed message on our voice messaging if the phones are busy and we will gladly return your call.</p>
          </span><span class="normtext">
              <p>Please do not hang up without giving us your first and last name and area code and telephone number.  Please speak slowly and clearly!</p>
              </span><span class="backToTop"><a href= #gQuestions>
                <p>Back to top</p>
                </a></span>
          <p><a name="tourAcceptance" id="tourAcceptance"></a>How do I know I am accepted on a tour?</p>
          <span class="normtext">
            <p>Once your payment has been processed, we will notify you by e-mail or telephone and confirm you on a tour. You will be contacted by our travel agent regarding your airfares once MPD Tours has received your permission form.</p>
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
          <p><a name="bookFlight" id="bookFlight"></a>How do I book a flight?  (We do not book flights, only assist).</p>
          <span class="normtext">
            <p>You will be contacted by our travel agent regarding flights once you have sent in your permission form.</p>
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
          <p><a name="ticketRefund" id="ticketRefund"></a>Is my airplane ticket refundable?</p>
          <span class="normtext">
            <p>Most airline tickets are non-refundable, which means that you will not get a refund for the ticket if you do not travel.  Most airlines will allow you to use the value of ticket to purchase another ticket later but they will charge a fee to change the ticket, which is usually is approximately $100.00 fee.  If you want to purchase a refundable ticket, make sure you indicate this choice when our travel agent contacts you.</p>
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
                  <p><a name="tours" id="tours"></a>Can I go on more than one tour?</p>
          <span class="normtext">
            <p>Yes, you can go on as many tours as you are permitted by your school, exchange program and host family.  You will need to register for each trip seperately. </p>
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
          <p><a name="permission" id="permission"></a>Do I need permission to go on tours?</p>
          <span class="normtext">
            <p>Yes, you need to complete a permission form which needs to be signed by your host family, area representative and school.  If you are not an exchange student you just need a note from your family giving you permission and need to be 15-19 of high school age.</p>
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
          <p><a name="refuse" id="refuse"></a>Can my exchange program refuse me permission to travel?</p>
          <span class="normtext">
            <p>Yes, you need to complete a permission form which needs to be signed by your host family, area representative and school.  If you are not an exchange student you just need a note from your family giving you permission and need to be 15-19 of high school age.</p>
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
          <p><a name="emergency" id="emergency"></a>Will I have an emergency phone number awhile on tour for myself and my parents?</p>
          <span class="normtext">
            <p>Yes, we will provide you with emergency telephone numbers for yourself and your parents awhile you are on tour (this will be in the student packet sent to you along with your confirmation of payment). Also, hotel telephone numbers, itinerary with all tour details.  There will be a 24 hour contact telephone number
              provided for real emergencies only!</p>
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
          <p>Are these tours chaperoned?</p>
          <span class="normtext">
            <p>Our programs are chaperoned and supervised by our professional tour staff as well as chaperones from our partner exchange programs.</p>
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
          <p>Are there areas and times that  students are not supervised?</p>
          <span class="normtext">
            <p>Yes, at lunch, shopping, and amusement parks students are in groups or 3 or more.  (Chaperones and Tour Staff are nearby and students have cell phone #’s and students have emergency numbers for chaperones and staff).</p>
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
          <p>How many adults are in charge on every trip?</p>
          <span class="normtext">
            <p>It depends on the trip, but there are generally 3-4 adults on one bus.</p>
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
          <p>How do I pay for a trip?</p>
          <span class="normtext">
            <p>You can pay by Visa, MasterCard, American Express, Discover credit cards.  We do not accept cash or ATM Debit Cards. You can register online or call us with credit card information over telephone. Send permission forms to MPD Tour America, Inc. not to CASE.</p>
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
          <p>I paid you online and you didn’t respond?</p>
          <span class="normtext">
            <p>Sometimes it takes a few weeks until we process all the students.  It does not mean that we automatically take payments immediately as soon as you submit it online.  Your deposit form gets processed through credit card companies, banks, etc., and this takes time to complete all the students applying for trips.</p>
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
          <p>Will I be confirmed of payment or confirmation number given?</p>
          <span class="normtext">
            <p>Yes once we process your payment and it is accepted from the credit card. you will be notified by e-mail or by telephone with confirmation number.  If you do not hear either way from us within 2 weeks please call or write us so you can be sure you sent the information and we received it.  Sometimes students move to another home and we cannot contact them.</p>
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
          <p>Can I make several payments?</p>
          <span class="normtext">
            <p>No.  Trips must be paid in full when you register.</p>
          </span><span class="backToTop"><a href= #gQuestions>
              <p>Back to top</p>
              </a></span>
          <p>What happens if I change my mind about a tour selection or want to cancel a trip?</p>
          <span class="normtext">
          <p>If you cancel more than 60 days before the tour date, you will receive a full refund, less a $25.00 processing fee.  If you cancel between 45-60 days before the tour, there will be a $100.00 cancellation fee.  If you cancel less than 45 days before the tour date, there will absolutely be no refunds under any circumstances.<br />
            Refunds on your airline tickets are your responsibility, and you will need to notify the airline directly. Most airline tickets are non-refundable</p>
          <span class="backToTop"><a href= #gQuestions>
            <p>Back to top</p>
          </a></span></div>
      <!-- TabbedPanelsContentGroup --></div>
    <!-- trips --></div>
    <!-- mainbody --> </div>
<!-- wrapper --></div>
<div class="clearfix"></div>
<cfinclude template="includes/footer.cfm">
</div>
<script type="text/javascript">
<!--
var TabbedPanels1 = new Spry.Widget.TabbedPanels("TabbedPanels1");
//-->
</script>
</body>
</html>
