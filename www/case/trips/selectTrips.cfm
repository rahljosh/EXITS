<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Tour FAQs</title>
<link href="../css/maincss.css" rel="stylesheet" type="text/css" />

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
h1 {
	border-bottom-width: medium;
	border-bottom-style: double;
	border-bottom-color: #999;
}
#wrapper #mainbody #trip h2 {
	color: #98152E;
}
.accent {
	background-color: #F5E5E5;
}
-->
</style></head>
<cfparam name="form.rulesread" default="0">
<cfparam name="form.booktravel" default="0">
<cfset client.selectedtrip = #url.tour_id#>
<Cfif isDefined('form.verifyRules')>
	<cfif form.rulesread eq 1 and form.booktravel eq 1>
		<cflocation url="step1.cfm?tour_id=#url.tour_id#">
    </cfif>
</Cfif>
<body>

<div id="wrapper">
<cfinclude template="../includes/header.cfm">
<div id="mainbody">
<cfinclude template="../includes/leftsidebar.cfm">
<div id="trip">
           
        <cfquery name="trips" datasource="#APPLICATION.DSN.Source#">
        select *
        from smg_tours
        where tour_status = 'active'
        </cfquery>
       	<cfquery name="tripInfo" dbtype="query">
        select *
        from trips 
        where tour_id = #url.tour_id#
        </cfquery>
        <cfoutput>
        <h2 align="Center">Sweet! Let's get you registered<cfif tripInfo.recordcount neq 0> to go on the #tripInfo.tour_name# Tour</cfif>.</h2><br />
        
        
        <cfform method="post" action="selectTrips.cfm?tour_id=#url.tour_id#">


        <h1>Booking Process</h1>
        
                         <em>Before we get started, here is a quick overview of the Tours Reservation Process.  </em><br /><br />
                         <div class="error">
						 <cfif isDefined('form.verifyRules')>
                         	<table width=400 align="Center">
                            	<tr>
                                	<Td><img src="../images/shucks.png" width="80" height="80" /></Td><Td> <h4>Shucks, we can't go foward yet.</h4> Errors are highlighted below. make sure you've read the process and know that you should NOT book your own airfare.</Td>
                                </tr>
                             </table>
                             <Br />
                         </cfif>
                         </div>
   <table width=100% cellspacing=0 cellpadding=2 class="border">
                           <tr>
                              <th align="Center" class="accent"> <h3> Please carefully read the steps below explaining the enrollment process.</h3></th>
                           </tr>
                            <tr>
                              <td>
                             
                               <ol>
                                       <li>Visit iseusa.com to book and  your trip. <em>(Your almost done with this step!) </em></li>
                                       <ul><li><font size=-1>If you want to go on other tours, you will need to do this process for <em><strong>each</strong></em> tour you want to go on.</font></li></ul>
                                        
                                        <li>Submit permission form and payment forms with all signatures to MPD Tours.
                                        	<ul><li>info@mpdtoursamerica.com
                                        		<li>fax:   +1 718 439 8565  
                                        		<li>mail:  9101 Shore Road, ##203 - Brooklyn, NY 11209
                                       	  </ul>
                                
                                        <li> MPD will contact you once your payment and permission form have been received to book your flights. Do NOT book your own flights.  
                                        </ol>
                               
                               </td>
                           </tr>
                         </table>
                     
                         <br /> <div align="center">
                          
                           <p>
                           <table width=450 bgcolor="##EFEFEF" cellpadding=4 cellspacing=0>
                           <Tr>
                           	
                           	</Tr>
                           		<tr <cfif form.rulesread eq 0 and isDefined('form.verifyrules')>bgcolor="##FF9DA7"</cfif>>
                                	<Td valign="top" ><input type="checkbox" name="rulesread" value="1" <cfif form.rulesread eq 1>checked</cfif>/></Td><td>I've read and understand the process of registering for a tour.</td>
                          		</tr>
                                <Tr>
                                	<td colspan=2><hr width=100% /></td>
                                </Tr>
                                <tr <cfif form.booktravel eq 0 and isDefined('form.verifyrules')>bgcolor="##FF9DA7"</cfif>>
                                	<td valign="top"><input type="checkbox" name="booktravel" value="1" <cfif form.booktravel eq 1>checked</cfif> /></Td><td>I understand that I should not book travel and that MPD will contact me to book my airfare.  </td>
                           			
                                 </tr>
                          
                              </table>
                              <br />
                             <input type="image" src="../images/buttons/Next.png" />
                                    <input type="hidden" name="verifyRules" />
                           </p>
                         </div>
                         </cfform>
                        
                         </cfoutput>
    <!-- trips --></div>
    <!-- mainbody --> </div>
    <div class="clearfix"></div>
<cfinclude template="../includes/footer.cfm">
<!-- wrapper --></div>



</body>
</html>
