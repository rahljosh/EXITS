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
	width: 40em;
	margin-top: 0px;
	margin-right: auto;
	margin-bottom: 50px;
	margin-left: auto;
	font-family: Arial, Helvetica, sans-serif;
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
<cfif isDefined('form.updatestudent')>
	<cfquery datasource="#application.dsn#">
    update student_tours
    set studentid = '#form.studentid#',
    	tripid = '#form.trip#'
   where id = #form.updatestudent#     
    </cfquery>
</cfif>
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
 </cfif>
 <Cfif isDefined('form.sib_updatecc')>
	<cfquery datasource="#application.dsn#">
    update student_tours_siblings
    set cc = '#form.sib_cc#',
    	cc_year = '#form.sib_cc_year#',
        cc_month = '#form.sib_cc_month#',
        billingAddress = '#form.sib_billingAddress#',
        billingState = '#form.sib_billingstate#',
        billingCity = '#form.sib_billingcity#',
        billingzip = '#form.sib_billingzip#'
   where mastertripid = #form.sib_updatecc#     
    </cfquery>
</Cfif>
<cfif isDefined('form.sib_paid')>

        <cfquery datasource="#application.dsn#">
           update student_tours_siblings
            set paid = #now()#,
                refCode = "#form.refCode#"
            where mastertripid = #url.id#
        </cfquery>
 </cfif>
<Cfif isDefined('form.paid') or isDefined('form.resendpacket')>        
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
   
      <cfquery name="details" datasource="#application.dsn#">
        select st.studentid, st.tripid, st.cc, st.cc_year, st.cc_month, st.date, st.ip, st.verified, st.paid, 
        st.flightinfo, st.nationality, st.med, st.person1,st.person2, st.person3, st.stunationality, st.refCode, st.permissionForm, st.billingAddress, st.billingCity, st.billingState, st.billingzip, stu.familylastname, stu.firstname, smg_tours.tour_name, stu.email
        from student_tours st
        left join smg_students stu on stu.studentid = st.studentid
        left join smg_tours on smg_tours.tour_id = st.tripid
        where id = #url.id#
        </cfquery>

        <cfsavecontent variable="email_message">
        <cfoutput>				
        <h3>Thank you!</h3>
        <p><strong>Please be sure to read all information included in this email, including the attachments! Respond to this email so that we are certain you know you have been confirmed on this tour.</strong></p>
        <p>You are confirmed on the following trip and will be contacted via email by our authorized travel agent to book your flight. If you have signed up for multiple tours, you will receive an email for each tour.</p>
        <p><u>Tour Details</u><br />
        #tourInfo.tour_name#<br />
        #tourInfo.tour_date#<BR />
        Amount: #LSCurrencyFormat(tourInfo.tour_price, 'local')#<Br />
        Paid: #DateFormat(tourInfo.paid, 'mmm. d, yyyy')#<br />
        Ref Code: #tourInfo.refCode#
        </p>
         <p><strong>REMEMBER: DO NOT BOOK YOUR OWN FLIGHT.  YOU WILL BE CONTACTED CONCERNING FLIGHTS.</strong></p>
        <cfif check_permission.permissionForm is ''><strong><p>We have not received your permission form yet.  You must submit your completed permission form in order for us to proceed in booking your flight.  You can send this form to us via email (info@mpdtoursamerica.com) or by fax (718) 439-8565.  Please send this in as soon as possible.</p></strong></cfif>
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
        	<cfinvokeargument name="email_to" value="#details.email#">
            <cfinvokeargument name="email_cc" value="brendan@iseusa.com">
            <cfinvokeargument name="email_replyto" value="#details.email#">
            <cfinvokeargument name="email_subject" value="Payment Processed">
            <cfinvokeargument name="email_message" value="#email_message#">
          
            <cfinvokeargument name="email_file" value="#AppPath.tours##tourinfo.packetfile#">
      
        </cfinvoke>	
    
    

</cfif>



<cfquery name="details" datasource="#application.dsn#">
select st.studentid, st.tripid, st.cc, st.cc_year, st.cc_month, st.date, st.ip, st.verified, st.paid, 
st.flightinfo, st.nationality, st.med, st.person1,st.person2, st.person3, st.stunationality, st.refCode, st.permissionForm, st.billingAddress, st.billingCity, st.billingState, st.billingzip, st.billingcountry, stu.familylastname, stu.firstname, stu.hostid, smg_tours.tour_name, stu.email
from student_tours st
left join smg_students stu on stu.studentid = st.studentid
left join smg_tours on smg_tours.tour_id = st.tripid
where id = #url.id#
</cfquery>

<Cfquery name="tours" datasource="#application.dsn#">
select *
from smg_tours
where tour_status <> 'inactive'
</Cfquery>
<cfif isDefined('form.resendpermision')>
   
    <cfdocument format="PDF" filename="#AppPath.temp#permissionForm_#url.student#.pdf" overwrite="yes">
			<style type="text/css">
            <!--
        	<cfinclude template="../smg.css">            
            -->
            </style>
			<!--- form.pr_id and form.report_mode are required for the progress report in print mode.
			form.pdf is used to not display the logo which isn't working on the PDF. --->
            <cfset form.report_mode = 'print'>
            <cfset form.pdf = 1>
            <cfinclude template="../forms/tripPermission.cfm">
        </cfdocument>
                
        <cfsavecontent variable="email_message">
        <cfoutput>				
            <p>Your account information has been verified. </p>
            <p>Attached is a permission form that needs to be signed by:<Br />
            <ul>
            <li>You</li>
            <li>Host Family</li>
            <li>Area Rep</li>
            <li>Regional Manager</li>
            <li>School</li>
            </ul>
        	You will receive another email with your flight details when they have been received.
            </p>
        </cfoutput>
        </cfsavecontent>
        
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#details.email#">
            <cfinvokeargument name="email_cc" value="brendan@iseusa.com">
            <cfinvokeargument name="email_replyto" value="#client.email#">
            <cfinvokeargument name="email_subject" value="Permission Forms">
            <cfinvokeargument name="email_message" value="#email_message#">
            <cfinvokeargument name="email_file" value="#AppPath.temp#permissionForm_#url.student#.pdf">
        </cfinvoke>	
        
</cfif>
<cfoutput>

<h3>Tour Details</h3>
<table width=98% cellpadding = 4 cellspacing = 0>
	<form method="post" action="details.cfm?id=#url.id#">
    <input type="hidden" name="updatestudent" value=#url.id#>
	<tr>
    	<Td>Student ID:</Td><td><input type="text" name=studentID value="#details.studentid#" size=10 /></td>
    </tr>
	<tr>
    	<Td>Student Name (First, Last):</Td><td>#details.firstname# #details.familylastname#</td>
    </tr>
    <Tr>
    	<td>Email:</td><td><a href="mailto:#details.email#">#details.email#</a></td>
    </Tr>
    
    <Tr>
    	<td>Tour:</td><td>
        
        <select name="trip">
        <cfloop query="tours">
        <option value=#tour_id# <Cfif details.tripid eq tour_id> selected</cfif>>#tours.tour_name#</option>
        </cfloop>
        </select>
        </td>
    </Tr>
    <tr>
    	<Td>Payment Status:</Td><td><cfif details.paid is ''>Unpaid <cfelse>Payment Applied - #DateFormat(details.paid,'mmm. d, yyyy')#</cfif> </td>
    </tr>
     <tr>
     	<td align="middle" colspan=2><input type="image" src="../pics/update.gif" /></td>
     </tr>
  </table>
  </form>
  <br />
      <img src="images/line_03.png" width="480" height="6" />
      <Br />
      <h3>Host Family Information</h3>
    <cfquery name="hostInfo" datasource="#application.dsn#">
    select familylastname, fatherfirstname, motherfirstname, address, address2, city, state, zip, phone, email
    from smg_hosts
    where hostid = #details.hostid#
    </cfquery>
      <table width=98% cellpadding = 4 cellspacing = 0>

	<tr>
    	<Td>Host Parents:</Td>
        <td><cfif hostInfo.fatherfirstname is not ''>#hostInfo.Fatherfirstname#</cfif>
         <cfif hostInfo.motherfirstname is not ''>#hostInfo.motherfirstname#</cfif> #hostInfo.familylastname#
        </td>
    </tr>
	<tr>
    	<Td valign="top">Address:</Td>
        <td>#hostInfo.address#<Br />
        <cfif hostInfo.address2 is not ''>#hostinfo.address2#<br /></cfif>
        #hostInfo.city# #hostInfo.state#, #hostInfo.zip#</td>
    </tr>
    <Tr>
    	<td>Email:</td><td><a href="mailto:#hostInfo.email#">#hostInfo.email#</a></td>
    </Tr>
    
    <Tr>
    	<td>Phone:</td><td>#hostInfo.phone#</td>
    </Tr>
    </table>
    <br />
    <img src="images/line_03.png" width="480" height="6" />
    <Br />
    <h3>Student Payment Details</h3>
   
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
    	<Td valign="top">Address:</Td><td><input type ="text" name="billingAddress" value="#details.billingAddress#" /></td>
    </Tr>
    <tr>    
        <td>	City:</td><Td> <input type ="text" name="billingcity" value="#details.billingcity#" /></Td>
    </tr>
    <Tr>        
         <td> State:</td><Td> <input  type="text" value="#details.billingstate#" name="billingstate"/></Td>
    </Tr>
    <tr>
    	<td>ZIP:</td><td><input size=5 type ="text" name="billingzip" value="#details.billingzip#" /></td>
     </Tr>
     <Tr>
     	<td>Country</td><td><input type="text" name="billingcountry" value="#details.billingcountry#" /></td>
     </Tr>
     <tr>
     	<td align="middle" colspan=2><input type="image" src="../pics/update.gif" /></td>
     </tr>
     </table>
            </form>
     <br />
      <img src="images/line_03.png" width="480" height="6" />
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
         <Td>Reference Code: <strong>#details.refCode#</strong></Td>
     </cfif>
      
   </Table>
 <br /><br />
      <img src="images/line_03.png" width="480" height="6" />
      <Br />
  <cfquery name="sibling_info" datasource="#application.dsn#">
  select *
  from student_tours_siblings
  where mastertripid = #url.id#
  </cfquery>
  <cfif sibling_info.recordcount gt 0>
  <cfquery name="sib_details" datasource="#application.dsn#">
select st.tripid, st.cc, st.cc_year, st.cc_month, st.paid, st.refCode,
st.billingAddress, st.billingCity, st.billingState, st.billingzip, st.billingcountry, shc.lastname, shc.name, smg_tours.tour_name
from student_tours_siblings st
left join smg_host_children shc on shc.childid = st.siblingid
left join smg_tours on smg_tours.tour_id = st.tripid
where mastertripid = #url.id#
</cfquery>
    <h3>Sibling Payment Details</h3>
   
    <table width=98% cellpadding = 4 cellspacing = 0>
    <cfif sib_details.paid is ''>
    <form method="post" action="details.cfm?id=#url.id#">
    <input type="hidden" name="sib_updatecc" value=#url.id#>
   	<tr>
    	<Td>CC Number:</Td><td><input type="text" value="#sib_details.cc#" name="sib_cc" /></td>
    </tr>
    <tr>
    	<Td>Expires:</Td><Td><input type="text" size=2 name="sib_cc_month" value="<cfif len(details.cc_month) eq 1>0#sib_details.cc_month#<cfelse>#sib_details.cc_month#</cfif>"/> / <input type="text" size=4 name="sib_cc_year" value="#DateFormat(sib_details.cc_year, 'yyyy')#"/></Td>
    </tr>
    <Tr>
    	<Td valign="top">Address:</Td><td><input type ="text" name="sib_billingAddress" value="#sib_details.billingAddress#" /></td>
    </Tr>
    <tr>    
        <td>	City:</td><Td> <input type ="text" name="sib_billingcity" value="#sib_details.billingcity#" /></Td>
    </tr>
    <Tr>        
         <td> State:</td><Td> <input  type="text" value="#sib_details.billingstate#" name="sib_billingstate"/></Td>
    </Tr>
    <tr>
    	<td>ZIP:</td><td><input size=5 type ="text" name="sib_billingzip" value="#sib_details.billingzip#" /></td>
     </Tr>
     <Tr>
     	<td>Country</td><td><input type="text" name="sib_billingcountry" value="#sib_details.billingcountry#" /></td>
     </Tr>
     <tr>
     	<td align="middle" colspan=2><input type="image" src="../pics/update.gif" /></td>
     </tr>
     </table>
            </form>
     <br />
      <img src="images/line_03.png" width="480" height="6" />
      <Br />
        <h3>Record the Payment</h3>
   
    <table cellpadding = 4 cellspacing = 0>
    <cfform method="post" action="details.cfm?id=#url.id#">
    <input type="hidden" name="sib_paid" />
   	<tr> 
        	<td>Reference Code: <cfinput type="text" name="refCode" message="Please enter the reference code of the payment." required="yes" size=20/></td><td>  <input type="image" src="../pics/submit.gif" />   </td>
        </tr>
     </cfform>
     <cfelse>
     <tr>
         <Td>Reference Code: <strong>#sib_details.refCode#</strong></Td>
     </cfif>
      
   </Table>  
       <br /><br />
      <img src="images/line_03.png" width="480" height="6" />
      <Br />      
  </cfif>

      
    <h3>Other Information</h3>
    <table width=98% cellpadding = 4 cellspacing = 0>
    	<tr>
        	<Td>Resend Permission Forms</Td><td><form method="post" action="details.cfm?student=#details.studentid#&id=#url.id#&message1=resent"><cfif details.verified is not ''><input name="" type="image" src="../pics/send-email.gif" /> <cfif isDefined('url.message1')>#url.message1#</cfif><input type="hidden" name="resendpermision" /><cfelse>Student not verified</cfif></form></td>
        </tr>
        <Tr>
        	<Td>Resend Tour Packet</Td><td><form method="post" action="details.cfm?id=#url.id#&message2=resent"><cfif details.permissionForm is not ''><input type="image" src="../pics/send-email.gif" /><input type="hidden" name="resendpacket" /> <cfif isDefined('url.message2')>#url.message2#</cfif><cfelse>Permission not received</cfif></form></td>	
        </Tr>
     </table>
    
</cfoutput>
<div class="clearfix"></div>
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