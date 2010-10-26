<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>(ISE) International Student Exchange - Foreign Exchange</title>
<style type="text/css">
<!--
-->
</style>

<link href="../css/ISEstyle.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
#footer3 {
	clear: both;
	height: 40%;
	margin: 0;
	background-color: #000;
	padding-top: 0;
	padding-right: 0;
	padding-bottom: 0;
	padding-left: 0;
	bottom: -8px;
	display: block;
}
.tripsTours {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	width: 675px;
	margin-left: 35px;
	margin-top: 10px;
	padding: 0px;
	text-align: left;
}
a:link {
	color: #000;
	text-decoration: none;
}
a:visited {
	color: #000;
	text-decoration: none;
}
a:hover {
	color: #0B954E;
	text-decoration: none;
}
a {
	font-weight: bold;
}
a:active {
	text-decoration: none;
}
.Boxx {
	border: 2px dashed #000066;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
	color: #000066;
}
.Titles {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #000066;
	font-weight: bold;
	font-size: 14px;
}
.TitlesLG {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #000066;
	font-weight: bold;
	font-size: 20px;
}
.SubTitle {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #2E4F7A;
	font-weight: bold;
	font-size: 12px;
}
.SubTitleLG {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #2E4F7A;
	font-weight: bold;
	font-size: 16px;
}
.BottonText {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 9px;
	font-style: normal;
	line-height: normal;
	font-weight: lighter;
	font-variant: normal;
	color: #6B8098;
	background-image: url(file:///JW%20BACKUP/SMG/ISE/site/trips/images/botton.gif);
	background-repeat: no-repeat;
	background-position: center center;
	text-align: center;
	vertical-align: middle;
}
.RegularText {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	color:#000000;
	font-style: normal;
	font-weight: normal;
}
.style1 {color: #FFFFFF}
.style2 {font-size: 12px}
.style4 {font-size: 12}
.style5 {color: #FFFFFF; font-weight: bold; }
.style6 {
	color: #FFFFFF;
	font-weight: bold;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	}
.image-right {
border:solid 1px;
margin-right: 0px;
margin-left: 15px;
}
.image-left {
border:solid 1px;
margin-right: 15px;
margin-left: 0px;
}
.whtMiddletours2{
	background-image: url(../images/whtBoxMiddle.png);
	background-repeat: repeat-y;
	margin: 0px;
	text-align: justify;
	padding-top: 20px;
	padding-right: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
}
.bBackground {
	background-color: #C5DCEA;
	border: thin solid #000;
	text-align: center;
}
.border{border:solid 1px;}
h3{text-indent:10px;}	
-->
</style>
</head>

<cfparam name="url.tour_id" default="1">
<cfparam name="form.select_trip" default="#url.tour_id#">
<cfparam name="form.select_trip" default="#url.tour_id#">
<cfset form.select_trip = '#form.select_trip#'>
<!----Student Info---->
<cfparam name="form.studentLName" default="">
<cfparam name="form.studentFName" default="">
<cfparam name="form.studentID" default="">
<cfparam name="form.Email" default="">
<cfparam name="stuInfo.familylastname" default="">
<cfparam name="stuInfo.firstname" default="">
<cfparam name="stuInfo.studentID" default="">
<cfparam name="stuInfo.Email" default="">
<cfparam name="stuInfo.dob" default="">
<cfparam name="form.dob" default="">
<cfparam name="stuInfo.sex" default="">
<cfparam name="form.sex" default="">
<!----Host Info---->
<cfparam name="hostInfo.familylastname" default="">
<cfparam name="hostInfo.fatherlastname" default="">
<cfparam name="hostInfo.fatherfirstname" default="">
<cfparam name="hostInfo.motherlastname" default="">
<cfparam name="hostInfo.motherfirstname" default="">
<cfparam name="hostInfo.address" default="">
<cfparam name="hostInfo.address2" default="">
<cfparam name="hostInfo.city" default="">
<cfparam name="hostInfo.state" default="">
<cfparam name="hostInfo.zip" default="">
<cfparam name="hostInfo.phone" default="">
<cfparam name="hostInfo.local_air_code" default="">
<cfparam name="hostInfo.major_air_code" default="">
<cfparam name="hostInfo.mother_cell" default="">
<cfparam name="hostInfo.father_cell" default="">

<!----Query for State Drop Down---->
<cfquery name="qstates" datasource="#APPLICATION.DSN.Source#">
select state, statename
from smg_states
</cfquery>
<!----Query for Country Drop down---->
<cfquery name="qCountryList" datasource="MySQL">
	SELECT countryid, countryname, countrycode
	FROM smg_countrylist
	ORDER BY Countryname
</cfquery>

<cfoutput>

<cfif isDefined('form.process')>

<cfsavecontent variable="email_message">
<head>

<cfif form.acctVerified eq 1>
This account was found in EXITS.  Trip information has been recorded but not verified. 
<!----Loop through selected trips and record in db---->
<Cfloop list="#form.select_trip#" index=x>
<cfif form.studentid is ''><cfset form.studentid = 0></cfif>
<Cfif form.ret_studentid is ''><cfset form.ret_studentid = 0></Cfif>
<cfquery datasource="#APPLICATION.DSN.Source#">
insert into student_tours (studentid, tripid, cc, cc_year, nationality, stunationality, person1, person2, person3, med, billingAddress, billingCity, billingState, billingZip, billingcountry, cc_month, date, ip)
			values (#form.ret_studentid#, #x#, '#form.cc#', #form.cc_year#, '#form.nationality#', '#form.stunationality#', '#form.person1#', '#form.person2#', '#form.person3#', '#form.med#',  '#form.billingAddress#', '#form.billingCity#', '#form.billingState#', '#form.billingZip#', '#form.billingcountry#', #form.cc_month#, now(), '#cgi.REMOTE_ADDR#')
</cfquery>
</Cfloop>
<cfelse>
No account was found in EXITS. Manual verification and trip update is required.
</cfif>
<Br /><br />
Registration information has been submitted:<Br />
<Br />
<h2>Student Information</h2>
  <Table width=100% cellspacing=0 cellpadding=2 class="border">
     		<Tr>
            	<td></td><th>Student Entered</th><Th>System Information</Th><th>Match?</th>
          	<Tr>
            	<td><h3>Student ID</h3> </td>
                <td>#form.studentid#</td>
                <Td>#form.ret_studentid#</td>
                <td><cfif form.studentid eq form.ret_studentid>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td>
            </Tr>
            <tr bgcolor="##deeaf3">
           		 <Td><h3>Email Address</h3></Td>
                 <td>#form.email#</td>
                 <Td>#form.ret_email#</td>
                <td><cfif form.email eq form.ret_email>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                
                </td>
            </tr>
            <tr>
           		 <Td><h3>Last Name</h3> </Td>
                 <td>#form.studentLName#</td>
                 <Td>#form.ret_studentLName#</td>
                <td><cfif form.studentLName eq form.ret_studentLName>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td>
            </tr>
            <tr  bgcolor="##deeaf3">
           		 <Td><h3>First Name</h3> </Td>
                 <td>#form.studentFName#</td>
                 <Td>#form.ret_studentFName#</td>
                <td><cfif form.studentFName eq form.ret_studentFName>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td>
            </tr>
			
            <Tr>
				<Td><h3>Birthday</h3></Td>
                <td>#DateFormat(form.dob, 'mm/dd/yyyy')#</td>
                <Td>#DateFormat(form.ret_dob, 'mm/dd/yyyy')# </td>
                <td><cfif '#DateFormat(form.dob, 'mm/dd/yyyy')#' eq '#DateFormat(form.ret_dob, 'mm/dd/yyyy')#'>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td>
            </Tr>      
            <Tr  bgcolor="##deeaf3">
				<Td><h3>Sex</h3></Td>
                <td>#form.sex#</td>
                <Td>#form.ret_sex#</td>
                <td><cfif form.sex eq form.ret_sex>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td>
            </Tr>  
            </Table>    
            <br />
            <hr width=60% align="center" />
            <br />
   			<h2>Host Information</h2>
            <Table width=100% cellspacing=0 cellpadding=2 class="border">
     
          	<Tr>
            	<td><h3>Family Last Name</h3></td>
                <td>#form.familylastname#</td>
                <td>#form.ret_hostLName#</td>
                <td><cfif form.familylastname eq form.ret_hostLName>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td>
           	</Tr>
            <Tr bgcolor="##deeaf3">
            	<td><h3>Mother's Last Name</h3></td>
                <td>#form.motherlastname#</td>
                <td>#form.ret_motherlastname#</td>
                <td><cfif form.motherlastname eq form.ret_motherlastname>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td>
           	</Tr>
            <Tr>
            	<td><h3>Mother's First Name</h3></td>
                <td>#form.motherfirstname# </td>
                <td>#form.ret_motherfirstname#</td>
                <td><cfif form.motherfirstname eq form.ret_motherfirstname>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td>
           	</Tr>
   			 <Tr bgcolor="##deeaf3">
            	<td><h3>Father's Last Name</h3></td>
                <td>#form.fatherlastname# </td>
                <td>#form.ret_fatherlastname#</td>
                <td><cfif form.fatherlastname eq form.ret_fatherlastname>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td>
           	</Tr>
            <Tr>
            	<td><h3>Father's First Name</h3></td>
                <td>#form.fatherfirstname# </td>
                <td>#form.ret_fatherfirstname#</td>
                <td><cfif form.fatherfirstname eq form.ret_fatherfirstname>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td>
           	</Tr>
   			 <Tr bgcolor="##deeaf3">
            	<td><h3>Address</h3></td>
                <td>#form.address# </td>
                <td>#form.ret_address#</td>
                <td><cfif form.address eq form.ret_address>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td>
           	</Tr>
            <Tr bgcolor="##deeaf3">
            	<td><h3></h3></td>
                <td>#form.address2# </td>
                <td>#form.ret_address2#</td>
                <td><cfif form.address2 eq form.ret_address2>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td>
           	</Tr >
   			 <Tr>
            	<td><h3>City</h3></td>
                <td>#form.city# </td>
                <td>#form.ret_city#</td>
                <td><cfif form.city eq form.ret_city>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td>
           	</Tr>
            <Tr  bgcolor="##deeaf3">
            	<td><h3>State</h3></td>
                <td>#form.state# </td>
                <td>#form.ret_state#</td>
                <td><cfif form.state eq form.ret_state>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td>
           	</Tr>
             <Tr>
            	<td><h3>Zip</h3></td>
                <td>#form.zip#</td>
                <td>#form.ret_zip#</td>
                <td><cfif form.zip eq form.ret_zip>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td>
           	</Tr>
            <Tr  bgcolor="##deeaf3">
            	<td><h3>Phone</h3></td>
                <td>#form.phone# </td>
                <td>#form.ret_phone#</td>
                <td><cfif form.phone eq form.ret_phone>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td> 
           	</Tr>
            <Tr>
            	<td><h3>Host Father Cell</h3></td>
                <td>#form.father_cell# </td>
                <td>#form.ret_father_Cell#</td>
                <td><cfif form.father_cell eq form.ret_father_cell>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td> 
           	</Tr>
            <Tr  bgcolor="##deeaf3">
            	<td><h3>Host Mother Cell</h3></td>
                <td>#form.mother_cell# </td>
                <td>#form.ret_mother_cell#</td>
                <td><cfif form.mother_cell eq form.ret_mother_cell>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td> 
           	</Tr>
             <Tr>
            	<td><h3>Major Airport (Airport Code)</h3></td>
                <td>#form.major_Air_Code# </td>
                <td>#form.ret_major_Air_Code#</td>
                <td><cfif form.major_Air_Code eq form.ret_major_Air_Code>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td> 
           	</Tr>
            <Tr  bgcolor="##deeaf3">
            	<td><h3>Local Airport (Airport Code)</h3></td>
                <td>#form.local_Air_Code# </td>
                <td>#form.ret_local_Air_Code#</td>
                <td><cfif form.local_Air_Code eq form.ret_local_Air_Code>
                		<img src="http://www.iseusa.com/images/green_checksm.png" height=25 width=25 alt="Match"/>
                    <cfelse>
                    	<img src="http://www.iseusa.com/images/redcircleSM.png" height=25 width=25 alt="No Match"/>
                    </cfif>
                </td> 
           	</Tr>
           	</Table>
          <br />
          <hr width=60% align="center" />
          <br />
      <h2>Selected Trips</h2>
				
          <Table width=100% cellspacing=0 cellpadding=2 class="border">
     
            <Tr>
                <td>
                  <table  width=100% cellspacing=0 cellpadding=2>
                    <tr>
                        <td width="22" class="boxB"></td><Td width="181" class="boxB"><h3><u>Tour</Td>
                        <td width="169" class="boxB"><h3><u>Dates</td>
                        <td width="84" class="boxB"><h3><u>Price</td>
                        <td width="73" class="boxB"><h3><u>Status</td>
                    </Tr>
                    <Cfset row = 0>
                    <cfloop list="#form.select_trip#" index="i">
                    	<cfset row = #row# + 1>
                        <cfquery name="tripInfo" datasource="#APPLICATION.DSN.Source#">
                        select *
                        from smg_tours
                        where tour_id = #i#
                        </cfquery>
                        
                        
                    
                    <tr <cfif row mod 2>bgcolor="##deeaf3"</cfif></tr>
                        <td></td>
                        <Td align="left" valign="middle" class="infoBold"><h3>#tripInfo.tour_name#</Td>
                        <Td align="left" valign="middle"><h3>#tripInfo.tour_date#</Td>
                        <td align="center" valign="middle" class="infoBold"><h3>#LSCurrencyFormat(tripInfo.tour_price,'local')#</td>
                        <td align="center" valign="middle"><h3>#tripInfo.tour_status#</td>
                     </Tr>
                  
                    </cfloop>
                                           
                </table>
                </td>
            </Tr>
         </Table>
<br />
          <hr width=60% align="center" />
          <br />
          <h2>Payment Info</h2>
<Table width=100% cellspacing=0 cellpadding=2 class="border">
     
          	<Tr>
            	<td><h3>Amount to Charge Now </h3></td><Td>#form.amount#</Td>
            </Tr>
            <Tr bgcolor="##deeaf3">
                            	<Td><h3>Name on Card</h3></Td><td>#form.nameoncard#</td></Tr>
            <Tr>
            	<td><h3>Credit Card*</h3></td><td>************#Right(form.cc, 4)#</td>
            </Tr>
               
                       
                          </Table>   


</cfsavecontent>
			
			<!--- send email --->
            <cfinvoke component="cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="brendan@iseusa.com">
                <cfinvokeargument name="email_subject" value="Trip Registration">
                <cfinvokeargument name="email_message" value="#email_message#">
                
                <cfinvokeargument name="email_from" value="josh@iseusa.com">
            </cfinvoke>
    <!----End of Email---->

</cfif>
</cfoutput>
<!----Check if Info is available---->
<cfif isDefined('form.lookup')>
    <Cfquery name="stuInfo" datasource="#APPLICATION.DSN.Source#">
    SELECT s.studentid, s.dob, s.sex, s.arearepid, s.hostid, s.studentid, s.email, s.familylastname, s.firstname, s.med_allergies, s.other_allergies
    FROM smg_students s
    WHERE email = '#form.email#'
    </Cfquery>

    <cfset acctVerified = 1>
	<cfif stuInfo.recordcount eq 1 and stuInfo.hostid gt 0>
        <cfquery name="hostInfo" datasource="#APPLICATION.DSN.Source#">
        select h.familylastname, h.fatherlastname, h.fatherfirstname, h.motherlastname, h.motherfirstname,
        h.address, h.address2, h.city, h.state, h.zip, h.email, h.phone, h.local_air_code, h.major_air_code, h.father_cell, h.mother_cell
        from smg_hosts h
        where h.hostid = #stuInfo.hostid# 
        </cfquery>
        
        <Cfquery name="kids" datasource="#APPLICATION.DSN.Source#">
        select name, sex, birthdate, childid
        from smg_host_children
        where hostid = #stuInfo.hostid#
        </Cfquery>
    </cfif>
   
</cfif>
<body class="oneColFixCtr">
<div id="topBar">
<cfinclude template="../topBarLinks.cfm">
<div id="logoBox"><a href="/"><img src="../images/ISElogo.png" width="214" height="165" alt="ISE logo" border="0" /></a></div>
<!-- end topBar --></div>
<div id="container">
<div class="spacer2"></div>
<div class="title"><cfinclude template="titleTrips.cfm"><!-- end title --></div>
<div class="tabsBar">
  <cfinclude template="../tabsBar.cfm">
  <!-- end tabsBar --></div>
<div id="mainContent">
<div id="subPages">
      <div class="whtTop"></div>
  <div class="whtMiddletours2">
        <div class="tripsTours">
        <cfif isDefined('form.process')>
        	
            <cfoutput>
            <h2>You are set!</h2> 
            <h2>Please be sure to keep an eye on your email.  Once your information has been verified, you will recieve an email at <strong>#form.email#</strong> with additional information and  forms that MUST be signed and returned to MPD Tours.</cfoutput>  </h2>
        <cfelse>   
        
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
        <h2 align="Center">Sweet! Let's get you registered.</h2>
        
         <h2>Student Information</h2>
          <cfform method="post" action="register.cfm?tour_id=#url.tour_id#">
          <input type="hidden" name="select_trip" value="#form.select_trip#">
          <Table width=100% cellspacing=0 cellpadding=2 class="border">
     
          	<Tr>
            	<td><h3>Student ID</h3> </td>
                <td>
                
                <cfinput type="text" name="studentid" size=10 value="#form.studentid#"> <br /><em>Don't know your ID? No problem, just leave it blank.</em>
                <input type=hidden name="ret_studentid" value="#stuInfo.studentid#" />
                </td>
            </Tr>
            <tr bgcolor="##deeaf3">
           		 <Td><h3>Email Address</h3> </Td>
                 <td>
           
                 <cfinput type="text" name="email" message="Please enter a valid email address." validate="email" required="yes" value="#form.email#" size=20>
                 <input type=hidden name="ret_email" value="#stuInfo.email#" />
                 </td>
            </tr>
            <tr>
           		 <Td><h3>Last Name</h3> </Td>
                 <td>
                
                 <cfinput type="text" name="studentLName" message="Please enter your last name." validate="noblanks" required="yes" size=20 value="#form.studentLName#">
                 <input type=hidden name="ret_studentLName" value="#stuInfo.familylastname#" />
                 </td>
            </tr>
            <tr  bgcolor="##deeaf3">
           		 <Td><h3>First Name</h3> </Td>
                 <td>
                
                 <cfinput type="text" name="studentFName" message="Please enter your first name." validate="noblanks" required="yes" size=20 value="#form.studentFName#" >
                 <input type=hidden name="ret_studentFName" value="#stuInfo.firstname#" />
                 </td>
            </tr>
			<Cfif  isDefined('form.lookup')>
            <Tr>
				<Td><h3>Birthday</h3></Td><td><cfinput type="datefield" name="dob" value="#stuInfo.dob#" /><input type=hidden name="ret_dob" value="#stuINfo.dob#" /></td>
            </Tr>      
            <Tr  bgcolor="##deeaf3">
				<Td><h3>Sex</h3></Td>
                <td>
                <input name="sex" type="radio" value='female' <cfif stuInfo.sex eq 'female'>checked</cfif> />Female  
                <input type="radio" name="sex" value='male' <cfif stuInfo.sex eq 'male'>checked</cfif>>Male</td>
                <input type="hidden" name="ret_sex" value="#stuInfo.sex#" />
            </Tr>  
            </Table>    
            <cfelse>
            </Table>
            </Cfif>
          
       
          <br />
            <cfif not isDefined('form.lookup')>
              <input type="hidden" name="lookup" />
 			<div align="Center"><input type="image" src="../images/buttons/next.png" width="89" height="33" /></div>
           
            <Cfelse>
           <h2>Host Family Information</h2>
	<input type=hidden name="acctVerified" value="#acctVerified#" />
          <Table width=100% cellspacing=0 cellpadding=2 class="border">
     
          	<Tr>
            	<td><h3>Family Last Name</h3></td>
                <td><cfinput type="text"  name="familylastname" value="#hostInfo.familylastname#"> <input type="hidden" name="ret_hostLName" value="#hostInfo.familylastname#" /></td>
           	</Tr>
            <Tr bgcolor="##deeaf3">
            	<td><h3>Mother's Last Name</h3></td>
                <td><cfinput type="text"  name="motherlastname" value="#hostInfo.motherlastname#"> <input type="hidden" name="ret_motherlastname" value="#hostInfo.motherlastname#" /></td>
           	</Tr>
            <Tr>
            	<td><h3>Mother's First Name</h3></td>
                <td><cfinput type="text"  name="motherfirstname" value="#hostInfo.motherfirstname#"> <input type="hidden" name="ret_motherfirstname" value="#hostInfo.motherfirstname#" /></td>
           	</Tr>
   			 <Tr bgcolor="##deeaf3">
            	<td><h3>Father's Last Name</h3></td>
                <td><cfinput type="text"  name="fatherlastname" value="#hostInfo.fatherlastname#"> <input type="hidden" name="ret_fatherlastname" value="#hostInfo.fatherlastname#" /></td>
           	</Tr>
            <Tr>
            	<td><h3>Father's First Name</h3></td>
                <td><cfinput type="text"  name="fatherfirstname" value="#hostInfo.fatherfirstname#"> <input type="hidden" name="ret_fatherfirstname" value="#hostInfo.fatherfirstname#" /></td>
           	</Tr>
   			 <Tr bgcolor="##deeaf3">
            	<td><h3>Address</h3></td>
                <td><cfinput type="text"  name="address" value="#hostInfo.address#"> <input type="hidden" name="ret_address" value="#hostInfo.address#" /></td>
           	</Tr>
            <Tr bgcolor="##deeaf3">
            	<td><h3></h3></td>
                <td><cfinput type="text"  name="address2" value="#hostInfo.address2#"> <input type="hidden" name="ret_address2" value="#hostInfo.address2#" /></td>
           	</Tr >
   			 <Tr>
            	<td><h3>City</h3></td>
                <td><cfinput type="text"  name="city" value="#hostInfo.city#"> <input type="hidden" name="ret_city" value="#hostInfo.city#" /></td>
           	</Tr>
           
            <Tr  bgcolor="##deeaf3">
            	<td><h3>State</h3></td>
                <td>
                <select name="state">
                <option value=""></option>
                <cfloop query="qstates">
                <option value="#state#" <cfif hostInfo.state eq state>selected</cfif>>#state# - #statename#</option>
                </cfloop>
                </select>
                <input type="hidden" name="ret_state" value="#hostInfo.state#"/>
                </td>
           	</Tr>
             <Tr>
            	<td><h3>Zip</h3></td>
                <td><cfinput type="text"  name="zip" value="#hostInfo.zip#"> <input type="hidden" name="ret_zip" value="#hostInfo.zip#" /></td>
           	</Tr>
            <Tr  bgcolor="##deeaf3">
            	<td><h3>Phone</h3></td>
                <td><cfinput type="text"  name="phone" value="#hostInfo.phone#"> <input type="hidden" name="ret_phone" value="#hostInfo.phone#" /></td>
           	</Tr>
             <Tr>
            	<td><h3>Host Father Cell</h3></td>
                <td><cfinput type="text"  name="father_cell" value="#hostInfo.father_cell#"> <input type="hidden" name="ret_father_cell" value="#hostInfo.father_Cell#" /></td>
           	</Tr>
            <Tr  bgcolor="##deeaf3">
            	<td><h3>Host Mother Cell</h3></td>
                <td><cfinput type="text"  name="mother_cell" value="#hostInfo.mother_cell#"> <input type="hidden" name="ret_mother_cell" value="#hostInfo.mother_cell#" /></td>
           	</Tr>
             <Tr>
            	<td><h3>Major Airport (Airport Code)</h3></td>
                <td><cfinput type="text"  name="major_Air_Code" value="#hostInfo.major_Air_Code#"> <input type="hidden" name="ret_major_Air_Code" value="#hostInfo.major_Air_Code#" /></td>
           	</Tr>
            <Tr  bgcolor="##deeaf3">
            	<td><h3>Local Airport (Airport Code)</h3></td>
                <td><cfinput type="text"  name="local_Air_Code" value="#hostInfo.local_Air_Code#"> <input type="hidden" name="ret_local_Air_Code" value="#hostInfo.local_Air_Code#" /></td>
           	</Tr>
           	</Table>
			
			<cfif stuInfo.recordcount eq 1 and stuInfo.hostid gt 0>            
				<cfif kids.recordcount gt 0>
                <h2>Host Siblings</h2>
                <em>Do any of your host siblings want to join you?</em>
                <Table width=100% cellspacing=0 cellpadding=2 class="border">
                    <Cfloop query="kids">
                    <tr <CFif kids.currentrow mod 2>bgcolor="##deeaf3"</cfif>>
                    <cfset oktogo = 0>
                    <Cfset kidsage = #DateDiff('yyyy', kids.birthdate, now())#>
                        <Cfif ListFind('15,16,17,18', '#kidsage#')> <cfset oktogo = 1></Cfif>
                        
                        <td><cfif oktogo neq 0><input type="checkbox" value="#childid#" name="host_siblings" ><cfelse>N/A</cfif></td><td><h3>#name#</h3></td><Td><h3>#DateDiff('yyyy', kids.birthdate, now())# years old</h3>  </Td><Td><h3>#kids.sex#</h3></Td><td><Cfif oktogo eq 0><h3> Must be between 15 and 18 to participate.</h3></Cfif></td>
                    </tr>
                    </Cfloop>
                </table>     
                </cfif>
			</cfif>
                
           <h2>Personal Information</h2>
				<em>Couple of things to help make your tour better</em>
          <Table width=100% cellspacing=0 cellpadding=2 class="border">
          	<tr>
            	<td colspan=2><h3>Would you prefer roommates <br /> &nbsp;&nbsp;&nbsp;of the same nationality as yourself?</h3></td>
    		
            	<td> <h3><cfinput type=radio name="nationality" message="Please answer the question: Would you prefer roommates of the same nationality as yourself?" validateat="onSubmit" required="yes" value='Same' /> Same <cfinput type=radio name="nationality" value='Different' /> Different <cfinput type=radio name="nationality" value='No Preference' /> No Preference</h3></td>
                
            </tr>
             <Tr bgcolor="##deeaf3">
          	 <td colspan=3><h3>What is your nationality? &nbsp;&nbsp;<cfinput type="text" name="stunationality" validateat="onSubmit" message="Please answer the question: What is your nationality?  This will help us in assigning roommates." required="yes" size=30/></h3></td>
             </Tr>
        	 <T>
          	 <td colspan=3><h3>Anyone in particular?
             &nbsp;&nbsp; ##1<input type="Text" name="person1" size=17 /> ##2<input type="text" name="person2" size=17/> ##3<input type="text" name="person3" size=17/></h3></td>
             </Tr>
             <Tr r bgcolor="##deeaf3">
          	 <td colspan=3><h3>Medical Information: <font size=-2>List allergies, medical conditions or limitations (vegitarian, etc), and any prescription medications.<br />
             &nbsp;&nbsp;&nbsp; If you are currently being treated for a medical condition, include your physicians name and phone number.  <em><strong>Please remember you &nbsp;&nbsp;&nbsp;must cary your card while on tour.</strong><em></h3>
             <textarea cols=80 rows=5 name="med"><Cfif stuINfo.med_allergies is not ''>Medical Allergies: #stuInfo.med_allergies#;</Cfif><cfif stuInfo.other_Allergies is not ''>Other Allergies: #stuInfo.other_allergies#</cfif></textarea></td>
             </Tr>
          
          
          </Table>
              <h2>Trip Information</h2>
				<em>You are registering for the following tour.</em>
                <Table width=100% cellspacing=0 cellpadding=2 class="border">
     
            <Tr>
                <td>
                  <table  width=100% cellspacing=0 cellpadding=2>
                    <tr>
                        <td width="22" class="boxB"></td><Td width="181" class="boxB"><h3><u>Tour</Td>
                        <td width="169" class="boxB"><h3><u>Dates</td>
                        <td width="84" class="boxB"><h3><u>Price</td>
                        <td width="73" class="boxB"><h3><u>Status</td>
                    </Tr>
                    <cfset amount_due = 0>
                    <cfloop list="#SELECT_TRIP#" index=t>
                    <Cfquery name="strips" datasource="#APPLICATION.DSN.Source#">
                    select *
                    from smg_tours 
                    where tour_id = #t#
                    </Cfquery>
                    <tr id=#tour_id# <CFif t mod 2>bgcolor="##deeaf3"</cfif>>
                    
                        <td></td>
                        <Td align="left" valign="middle" class="infoBold"><h3>#strips.tour_name#</Td>
                        <Td align="left" valign="middle"><h3>#strips.tour_date#</Td>
                        <td align="center" valign="middle" class="infoBold"><h3>#LSCurrencyFormat(strips.tour_price,'local')#</td>
                        <td align="center" valign="middle"><h3>#strips.tour_status#</td>
                     </Tr>
                  	<cfset amount_due = #amount_due# + #strips.tour_price#>
                    </cfloop>
                                           
                </table>
                </td>
            </Tr>
         </Table>
        

       
            <h2>#form.studentFName# #form.studentLName# Payment Information</h2>
			<em>*Bank or ATM cards will not work. Must be a valid credit card, or debit card with Visa or Mastercard logo, that can be processed as a credit card.</em>
          <Table width=100% cellspacing=0 cellpadding=2 class="border">
     
          	<Tr>
            	<td><h3>Total Amount Due</h3></td><Td><strong>#LSCurrencyFormat(amount_due, 'local')#</strong><input type="hidden" name="amount" value="#amount_due#"/></Td>
            </Tr>
            <Tr bgcolor="##deeaf3">
                            	<Td><h3>Name on Card</h3></Td><td><cfinput type="text" name="nameoncard" validateat="onSubmit" message="Please enter the name shown on credit card." validate="noblanks" required="yes" size=20></td></Tr>
            <Tr >
            	<td><h3>Credit Card*</h3></td><td><cfinput type="text" name="cc" validateat="onSubmit" message="Please enter a valid credit card number."  validate="creditcard" required="yes"><br />
                <em><font size=-1>This will be a 15 or 16 digit number on the front of the card.</font></em></td>
                </Tr>
                
            <tr bgcolor="##deeaf3">
            	<td><h3>Expiration</h3></td><td> <cfinput type="text" name="cc_month" size=2 message="Please indicate the month your credit card expires.  Make sure you use a number to indicate them month. Jan =1, Feb=2, etc." validate="integer" required="yes" id = "ccmonth"> <strong>/</strong>
                								
                                         
                                                <cfinput type="text" name="cc_year" message="Please select the year your credit card expires" validate="integer" required="yes" id = "ccyear" size=4>
                                               
                                                
                                                
                                                </td>
                            </tr>
                         <tr>
            	<td><h3>Billing Address</h3></td><td><cfinput type="text" name="billingAddress" validateat="onSubmit" message="Please enter the Credit Card billing address" required="yes"/>                                          
                                                
                                                </td>
                            </tr>
                    <Tr bgcolor="##deeaf3">
                            	<Td><h3>Billing City</h3></Td>
                                <td><cfinput type="text" name="billingcity" validateat="onSubmit" message="Please enter the billing city." validate="noblanks" required="yes" size=20></td></Tr>
					<Tr>
                            	<Td><h3>Billing State</h3></Td>
                                <td>
                                <cfselect name="billingstate" validateat="onSubmit" message="Please enter the billing state." validate="noblanks" required="yes">
                                <option value=""></option>
                                <cfloop query="qstates">
                                <option value="#state#">#state# - #statename#</option>
                                </cfloop>
                                </cfselect>
                                
                                </td></Tr>
					<Tr bgcolor="##deeaf3">
                            	<Td><h3>Billing Zip</h3></Td>
                                <td><cfinput type="text" name="billingzip" validateat="onSubmit" message="Please enter the billing state." validate="noblanks" required="yes" size=20></td></Tr>
      <Tr>
                                	<td><h3>Billing Country</h3></td>
                                    <Td><cfselect name="billingcountry" validateat="onSubmit" message="Please enter the billing country." validate="noblanks" required="yes">
                                        <option value=""></option>
                                        <cfloop query="qCountryList">
                                        <option value="#countrycode# - #countryname#">#countrycode# - #countryname#</option>
                                        </cfloop>
										</cfselect>
									</Td>
                    </Tr>                                
                          </Table>         
                          
                            <h2>Host Sibling Payment Information</h2>
			<em>*Bank or ATM cards will not work. Must be a valid credit card, or debit card with Visa or Mastercard logo, that can be processed as a credit card.</em>
          <Table width=100% cellspacing=0 cellpadding=2 class="border">
     
          	<Tr>
            	<td><h3>Total Amount Due</h3></td><Td><strong>#LSCurrencyFormat(amount_due, 'local')# - <strong>PER SIBLING SELECTED</strong><input type="hidden" name="amount" value="#amount_due#"/></Td>
            </Tr>
            <Tr bgcolor="##deeaf3">
                            	<Td><h3>Name on Card</h3></Td><td><cfinput type="text" name="nameoncard" validateat="onSubmit" message="Please enter the name shown on credit card." validate="noblanks" required="yes" size=20></td></Tr>
            <Tr >
            	<td><h3>Credit Card*</h3></td><td><cfinput type="text" name="cc" validateat="onSubmit" message="Please enter a valid credit card number."  validate="creditcard" required="yes"><br />
                <em><font size=-1>This will be a 15 or 16 digit number on the front of the card.</font></em></td>
                </Tr>
                
            <tr bgcolor="##deeaf3">
            	<td><h3>Expiration</h3></td><td> <cfinput type="text" name="cc_month" size=2 message="Please indicate the month your credit card expires.  Make sure you use a number to indicate them month. Jan =1, Feb=2, etc." validate="integer" required="yes" id = "ccmonth"> <strong>/</strong>
                								
                                         
                                                <cfinput type="text" name="cc_year" message="Please select the year your credit card expires" validate="integer" required="yes" id = "ccyear" size=4>
                                               
                                                
                                                
                                                </td>
                            </tr>
                         <tr>
            	<td><h3>Billing Address</h3></td><td><cfinput type="text" name="billingAddress" validateat="onSubmit" message="Please enter the Credit Card billing address" required="yes"/>                                          
                                                
                                                </td>
                            </tr>
                    <Tr bgcolor="##deeaf3">
                            	<Td><h3>Billing City</h3></Td>
                                <td><cfinput type="text" name="billingcity" validateat="onSubmit" message="Please enter the billing city." validate="noblanks" required="yes" size=20></td></Tr>
					<Tr>
                            	<Td><h3>Billing State</h3></Td>
                                <td>
                                <cfselect name="billingstate" validateat="onSubmit" message="Please enter the billing state." validate="noblanks" required="yes">
                                <option value=""></option>
                                <cfloop query="qstates">
                                <option value="#state#">#state# - #statename#</option>
                                </cfloop>
                                </cfselect>
                                
                                </td></Tr>
					<Tr bgcolor="##deeaf3">
                            	<Td><h3>Billing Zip</h3></Td>
                                <td><cfinput type="text" name="billingzip" validateat="onSubmit" message="Please enter the billing state." validate="noblanks" required="yes" size=20></td></Tr>
      <Tr>
                                	<td><h3>Billing Country</h3></td>
                                    <Td><cfselect name="billingcountry" validateat="onSubmit" message="Please enter the billing country." validate="noblanks" required="yes">
                                        <option value=""></option>
                                        <cfloop query="qCountryList">
                                        <option value="#countrycode# - #countryname#">#countrycode# - #countryname#</option>
                                        </cfloop>
										</cfselect>
									</Td>
                    </Tr>                                
                          </Table>                     
         <div align="center"><input type="image" src="../images/buttons/Next.png" /></div>
         <input type="hidden" name="process" />
           </cfif>
           
         </cfform>
		<script type="text/javascript">
			document.getElementById('cc_month').selectedIndex = -1;
		</script>
        		<script type="text/javascript">
			document.getElementById('cc_year').selectedIndex = -1;
		</script>
        
          </cfoutput>
          </cfif>
        <div id="main" class="clearfix"></div>
      <!-- endtripTours --></div>
      <div id="main" class="clearfix"></div>
      <!-- end whtMiddle --></div>
      <div class="whtBottom"></div>
      <!-- end subpages --></div>
    <!-- end mainContent --></div>
<!-- end container --></div>
<div id="main" class="clearfix"></div>
<div id="footer">
  <div class="clear"></div>
<cfinclude template="../bottomLinks.cfm">
<!-- end footer --></div>
</body>
</html>
