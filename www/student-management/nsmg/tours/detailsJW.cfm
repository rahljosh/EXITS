<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Ind. Details</title>
<style type="text/css">
<!--
.wrapper {
}
.box {
	width: 55em;
	margin: 50px auto;
}
.box div.topleft {
	display: block;
	background: url("images/box-bg.png") top left no-repeat white;
	padding: 2.0em 0em 0em 2.0em;
}

.box div.topright {
	display: block;
	background: url("images/box-bg.png") top right no-repeat white;
	margin-top: -2em;
	margin-right: 0;
	margin-bottom: 0;
	margin-left: 2em;
	padding-top: 2em;
	padding-right: 4em;
	padding-bottom: 3.5em;
	padding-left: 2em;
}

.box div.bottomleft {
	display: block;
	height: 55px;
	margin-top: -2em;
	background: url("images/box-bg.png") bottom left no-repeat white;
}

.box div.bottomright {
	display: block;
	background: url("images/box-bg.png") bottom right no-repeat white;
	height: 55px;
	margin-left: 3em;
}
.clearfix {
	display: block;
	clear: both;
	height: 20px;
}

-->
</style>
</head>

<body>

<div class="box">
  <div class="topleft">
  <div class="topright">
    <div>
<Cfif isDefined('form.updatecc')>
	<cfquery datasource="#application.dsn#">
    update student_tours
    set cc = '#form.cc#',
    	cc_year = '#form.cc_year#',
        cc_month = '#form.cc_month#',
        billingAddress = '#form.billingAddress#',
        billingState = '#form.billingstate#',
        billingCity = '#form.billingcity#',
        billingzip = '#form.billingzip#'
   where id = #form.updatecc#     
    </cfquery>
</Cfif>
<cfif isDefined('form.paid')>

        <cfquery datasource="#application.dsn#">
           update student_tours
            set paid = #now()#,
                refCode = "#form.refCode#"
            where id = #url.id#
        </cfquery>
        
        <Cfquery name="check_permission" datasource="#application.dsn#">
        select permissionForm
        from student_tours
        where id = #url.id#
        </Cfquery>

        <Cfquery name="tourInfo" datasource="#application.dsn#">
        select *, smg_tours.tour_name, smg_tours.tour_date, smg_tours.tour_price, smg_tours.packetFile
        from student_tours
        left join smg_tours on smg_tours.tour_id = student_tours.tripid
        where id = #url.id#
        </cfquery>
      
        <cfsavecontent variable="email_message">
        <cfoutput>				
        <h3>Thank you!</h3>
        <p><strong>Please be sure to read all information included in this email, including the attachments! Respond to this email so that we are certain you know you have been confirmed on this tour.</strong></p>
        <p>You are confirmed on the following trip and will be contacted via email by our authorized travel agent to book your flight. If you have signed up for multiple tours, you will receive on email for each tour.</p>
        <p><u>Tour Details</u><br />
        #tourInfo.tour_name#<br />
        #tourInfo.tour_date#<BR />
        Amount: #LSCurrencyFormat(tourInfo.tour_price, 'local')#<Br />
        Paid: #DateFormat(tourInfo.paid, 'mmm. d, yyyy')#<br />
        Ref Code: #tourInfo.refCode#
        </p>
         <p><strong>REMEMBER: DO NOT BOOK YOUR OWN FLIGHT.  YOU WILL BE CONTACTED CONCERNING FLIGHTS.</strong></p>
        <cfif check_permission.permissionForm is ''><strong>< <p>We have no received your permission form yet.  You must submit your completed permission form in order for us to proceed in booking your flight.  You can send this form to us via email (info@mpdtoursamerica.com) or by fax (718) 439-8565.  Please send this in as soon as possible.</p></strong></cfif>
        <p>Attached is a Student Packet with hotel, airport arrival instructions, emergency numbers, etc.  Please keep this handy for your trip and leave a copy with your host family while you are on the trip.</p>
        <p>Please visit ISE's website for additional questions. http://www.iseusa.com/trips/questions.cfm</p>
        <p>If you have any questions that are not answerd please don't hesitate to contact us at info@mpdtoursamerica.com. </p>
        <p>See you soon!</p>
        <p>MPD Tour America, Inc.<br />
        9101 Shore Road ##203- Brooklyn, NY 11209<Br />
        Email: Info@Mpdtoursamerica.com<br />
        TOLL FREE: 1-800-983-7780<br />
        Fax: 1-(718)-439-8565</p>
 
        </cfoutput>
        </cfsavecontent>
        
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="brendan@iseusa.com">
            <cfinvokeargument name="email_replyto" value="#client.email#">
            <cfinvokeargument name="email_subject" value="Payment Processed">
            <cfinvokeargument name="email_message" value="#email_message#">
            <cfinvokeargument name="email_file" value="#AppPath.tours##tourinfo.packetfile#">
            
        </cfinvoke>	
    
    

</cfif>



<cfquery name="details" datasource="#application.dsn#">
select st.studentid, st.tripid, st.cc, st.cc_year, st.cc_month, st.date, st.ip, st.verified, st.paid, 
st.flightinfo, st.nationality, st.med, st.person1,st.person2, st.person3, st.stunationality, st.refCode, st.permissionForm, st.billingAddress, st.billingCity, st.billingState, st.billingzip, stu.familylastname, stu.firstname, smg_tours.tour_name, stu.email
from student_tours st
left join smg_students stu on stu.studentid = st.studentid
left join smg_tours on smg_tours.tour_id = st.tripid
where id = #url.id#
</cfquery>

<cfoutput>

<h3>Tour Details</h3>
<table width=98% cellpadding = 4 cellspacing = 0>
	<tr>
    	<Td>Student Name (First, Last):</Td><td>#details.firstname# #details.familylastname#</td>
    </tr>
    <Tr>
    	<td>Email:</td><td><a href="mailto:#details.email#">#details.email#</a></td>
    </Tr>
    <Tr>
    	<td>Tour:</td><td>#details.tour_name#</td>
    </Tr>
    <tr>
    	<Td>Payment Status:</Td><td><cfif details.paid is ''>Unpaid <cfelse>Payment Applied - #DateFormat(details.paid,'mmm. d, yyyy')#</cfif> </td>
    </tr>
  </table>
  <br />
      <img src="images/line_03.png" width="710" height="6" />
      <Br />
      
    <h3>Payment Details</h3>
   
    <table width=98% cellpadding = 4 cellspacing = 0>
    <cfif details.paid is ''>
    <form method="post" action="details.cfm?id=#url.id#">
    <input type="hidden" name="updatecc" value=#url.id#>
   	<tr>
    	<Td>CC Number:</Td><td><input type="text" value="#details.cc#" name="cc" /></td>
    </tr>
    <tr>
    	<Td>Expires:</Td><Td><input type="text" size=2 name="cc_month" value="<cfif len(details.cc_month) eq 1>0#details.cc_month#<cfelse>#details.cc_month#</cfif>"/> / <input type="text" size=4 name="cc_year" value="#DateFormat(details.cc_year, 'yyyy')#"/></Td>
    </tr>
    <Tr>
    	<Td valign="top">Address:</Td>
        <td><input type ="text" name="billingAddress" value="#details.billingAddress#" /><br />
        	City: <input type ="text" name="billingcity" value="#details.billingcity#" />  State: <input  type="text" value="#details.billingstate#" name="billingstate"/><br /> ZIP:<input size=5 type ="text" name="billingzip" value="#details.billingzip#" />
            </td>
     </Tr>
     <tr>
     	<td align="middle" colspan=2><input type="image" src="../pics/update.gif" /></td>
     </tr>
     </table>
            </form>
     <br />
      <img src="images/line_03.png" width="710" height="6" />
      <Br />
        <h3>Record the Payment</h3>
   
    <table cellpadding = 4 cellspacing = 0>
    <cfform method="post" action="details.cfm?id=#url.id#">
    <input type="hidden" name="paid" />
   	<tr> 
        	<td>Reference Code: <cfinput type="text" name="refCode" message="Please enter the reference code of the payment." required="yes" size=20/></td><td>  <input type="image" src="../pics/submit.gif" />   </td>
        </tr>
     </cfform>
     <cfelse>
     <tr>
         <Td>Approval Code: <strong>#details.refCode#</strong></Td>
     </cfif>
      
   </Table>
 <br /><br />
      <img src="images/line_03.png" width="710" height="6" />
      <Br />
    <h3>Other Information</h3>
    <table width=98% cellpadding = 4 cellspacing = 0>
    	<tr>
        	<Td>Permission Forms</Td><td>Resent</td>
        </tr>
        <Tr>
        	<Td>Tour Packet</Td><td>Resend</td>	
        </Tr>
     </table>
    
</cfoutput>
<div class="clearfix">Content for  class "clearfix" Goes Here</div>
    </div>
  </div>
  </div>

  <div class="bottomleft">
  <div class="bottomright">
  </div>
  </div>
</div>


</body>
</html>