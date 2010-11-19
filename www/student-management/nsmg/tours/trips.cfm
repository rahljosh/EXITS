<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Trips</title>

<style type="text/css">
<!--
h1, h2, h3, h4 {
	font-family: Arial, Helvetica, sans-serif;
}
.paragraph {
	font-family: Arial, Helvetica, sans-serif;
	color: #000;
}
.paragraphSm {
	font-family: Arial, Helvetica, sans-serif;
	color: #000;
	font-size: 13px;
	text-align: center;
}
.grey {
	background-color: #CCC;
}
.wrapper {
}
.box {
	width: auto;
	margin-top: 5px;
	margin-right: auto;
	margin-bottom: 50px;
	margin-left: auto;
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
	margin-right: 0em;
	margin-bottom: 0;
	margin-left: 2em;
	padding-top: 3em;
	padding-right: 5em;
	padding-bottom: 3em;
	padding-left: .50em;
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
.center {
	text-align: center;
}
-->
</style>
</head>

<body>

<Cfif isDefined('form.regTrip')>
	<cfquery datasource="#application.dsn#">
    insert into student_tours (studentid, tripid, date)
    			values(#client.studentid#, #form.regTrip#, #now()#) 
    </cfquery>
</Cfif>

<cfif isDefined('url.verified')>
	<cfquery name="verify" datasource="#application.dsn#">
    update student_tours
    set verified = #now()#
    where id = #url.id#
    </cfquery>
	<cfquery name="stuEmail" datasource="#application.dsn#">
    select email 
    from smg_students
    where studentid = #client.studentid#
    </cfquery>
    
    <cfdocument format="PDF" filename="#AppPath.temp#permissionForm_#client.studentid#.pdf" overwrite="yes">
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
            <cfinvokeargument name="email_to" value="#stuEmail.email#">
             <cfinvokeargument name="email_cc" value="brendan@iseusa.com">
            <cfinvokeargument name="email_replyto" value="#stuEmail.email#">
            <cfinvokeargument name="email_subject" value="Permission Forms">
            <cfinvokeargument name="email_message" value="#email_message#">
            <cfinvokeargument name="email_file" value="#AppPath.temp#permissionForm_#client.studentid#.pdf">
        </cfinvoke>	
        <cflocation url="trips.cfm">
</cfif>

<cfif isDefined('url.flights')>
	<cfquery name="verify" datasource="#application.dsn#">
    update student_tours
    set flightinfo = #now()#
    where id = #url.id#
    </cfquery>
   <cflocation url="trips.cfm?id=#url.id#">
</cfif>
<Cfquery name="tours" datasource="#application.dsn#">
select *, smg_tours.tour_name
from student_tours
left join smg_tours on smg_tours.tour_id = student_tours.tripid
where student_tours.studentid = #client.studentid#
</Cfquery>
<Cfquery name="allTrips" datasource="#application.dsn#">
select * 
from smg_tours
where tour_status = 'Active'
order by tour_name
</Cfquery>
<div class="box">
  <div class="topleft">
  <div class="topright">
    <div>
<h2 class="center">Student Trips</h2>

  <cfoutput>
  
<h4>Registered Trips</h4>
<table width=100% cellpadding=4 cellspacing=4>
	<tr>
    	<Td bgcolor="##999999" align="center"><span class="paragraph">Tour</span></Td>
    	<Td bgcolor="##999999" align="center"><span class="paragraph">Registered</span></Td>
    	<td bgcolor="##999999" align="center"><span class="paragraph">Verified</span></td>
    	<td bgcolor="##999999" align="center"><span class="paragraph">Paid</span></td>
    	<td bgcolor="##999999" align="center"><span class="paragraph">Flights</span></td>
    </tr>

  
    <cfif tours.recordcount eq 0>
        <tr>
            <Td colspan=5 align="Center"><span class="paragraph">Student has not signed up for any trips.</span></Td>
        </tr>
    <cfelse>
        <cfloop query="tours">
        <tr<cfif tours.currentrow mod 2> bgcolor="##CCCCCC" </cfif>>
            <Td><span class="paragraphSm">#tour_name#</span></Td>
            <Td><span class="paragraphSm">#DateFormat(date,'mm/dd/yyyy')#</span></Td>
            <td><cfif verified is ''>
              <a href="trips.cfm?id=#tours.id#&student=#client.studentid#&amp;verified"><img src="../pics/confirm_03.png" width="61" height="16" border="0"/></a>
              <cfelse><span class="paragraphSm">#DateFormat(verified,'mm/dd/yyyy')#</span>
            </cfif></td>
            <td><cfif paid is ''>
              <span class="paragraphSm">----
              <cfelse><span class="paragraphSm">#DateFormat(paid,'mm/dd/yyyy')#</span>
            </cfif></td>
            <td><cfif flightinfo is ''>
              <span class="paragraphSm"><a href="trips.cfm?id=#tours.id#&student=#client.studentid#&amp;flights"><img src="../pics/confirm_03.png" border=0/></a>
              <cfelse><span class="paragraphSm">#DateFormat(flightinfo,'mm/dd/yyyy')#</span>
            </cfif></td>
        </tr>  
        </cfloop>
    </cfif>

 </table>
<br />
<hr width=100% />
<br />
<h4>Register for a Trip</h4>
<form method="post" action="trips.cfm">
<Table>
	<Tr class="paragraph">
    	<Td>Register for: </Td>
        <td><select name="regTrip">
    		<option value=0></option>
                <cfloop query="allTrips">
                    <option value="#tour_id#">#tour_name# - #tour_date#</option>
                </cfloop>
            </select> </td> 
           </Tr>
           <Tr>
           	<td><input type="image" src="../pics/submit.gif" /></td>
          </Table>
</form>
    </cfoutput>
     </div>
  </div>
  </div>

  <div class="bottomleft">
  <div class="bottomright">
  </div>
  </div>
</div>


<cfif isDefined('url.verified')>
	<cfquery name="verify" datasource="#application.dsn#">
    update student_tours
    set verified = #now()#
    where id = #url.id#
    </cfquery>

    
    <cfdocument format="PDF" filename="#AppPath.temp#permissionForm_#client.studentid#.pdf" overwrite="yes">
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
        	Once you have submitted your signed permission form to MPD Tours. You will then be contacted by our Authorized Travel Agent to book your flight.
            </p>
        </cfoutput>
        </cfsavecontent>
        
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#student_info.email#">
            <cfinvokeargument name="email_replyto" value="#client.email#">
            <cfinvokeargument name="email_subject" value="Permission Forms">
            <cfinvokeargument name="email_message" value="#email_message#">
            <cfinvokeargument name="email_file" value="#AppPath.temp#permissionForm_#client.studentid#.pdf">
        </cfinvoke>	
        <cflocation url="trips.cfm">
</cfif>


</body>
</html>