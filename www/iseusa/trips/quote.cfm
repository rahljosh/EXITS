<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>(ISE) International Student Exchange - Foreign Exchange S</title>
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
<cfparam name="form.acctVerified" default="0">
<!----Student Info---->
<cfparam name="form.studentLName" default="">
<cfparam name="form.studentFName" default="">
<cfparam name="form.studentID" default="">
<cfparam name="form.Email" default="">
<cfparam name="stuInfo.familylastname" default="">
<cfparam name="stuInfo.firstname" default="">
<cfparam name="stuInfo.studentID" default="">
<cfparam name="stuInfo.Email" default="">
<cfparam name="form.local_air_code" default="">
<cfparam name="form.major_air_code" default="">

<cfparam name="hostInfo.local_air_code" default="">
<cfparam name="hostInfo.major_air_code" default="">


<cfoutput>
<cfif isDefined('form.process')>

<cfsavecontent variable="email_message">
<head>

<cfif form.acctVerified eq 1>

<!----Loop through selected trips and record in db---->
<Cfloop list="#form.select_trip#" index=x>
<cfif form.studentid is ''><cfset form.studentid = 0></cfif>

</Cfloop>
<cfelse>

</cfif>
<Br /><br />
<strong>STUDENT HAS NOT BEEN CONFIRMED, QUOTE ONLY</strong><br />
A flight quote has been requested by this student:<Br />
<Br />
<h2>Student Information</h2>
  <Table width=100% cellspacing=0 cellpadding=2 class="border">
     		<Tr>
            	<td></td><th>Student Entered</th><Th>EXITS Information</Th><th>Match?</th>
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

                          </Table>   


</cfsavecontent>
			
			<!--- send email --->
            <cfinvoke component="cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="dees626@verizon.net ">
                <cfinvokeargument name="email_cc" value="brendan@iseusa.com">
                <cfinvokeargument name="email_subject" value="Trip Quote">
                <cfinvokeargument name="email_message" value="#email_message#">
                
                <cfinvokeargument name="email_from" value="#form.email#">
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
    <cfset acctVerified = #stuInfo.recordcount#>
	<cfif stuInfo.recordcount eq 1 and stuInfo.hostid gt 0>
        <cfquery name="hostInfo" datasource="#APPLICATION.DSN.Source#">
        select h.familylastname, h.fatherlastname, h.fatherfirstname, h.motherlastname, h.motherfirstname,
        h.address, h.address2, h.city, h.state, h.zip, h.email, h.phone, h.local_air_code, h.major_air_code, h.father_cell, h.mother_cell
        from smg_hosts h
        where h.hostid = #stuInfo.hostid# 
        </cfquery>
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
            <h2>That was easy!</h2> 
            <h2>Please be sure to keep an eye on your email. You'll receive your requsted quote shortly.</cfoutput>  </h2>
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
        <h2 align="Center">Just let us know who you are..</h2>
        
         <h2>Student Information</h2>
          <cfform method="post" action="quote.cfm?tour_id=#url.tour_id#">
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
            	<td><h3>Major Airport (Airport Code)</h3></td>
                <td><cfinput type="text"  name="major_Air_Code" value="#hostInfo.major_Air_Code#"> <input type="hidden" name="ret_major_Air_Code" value="#hostInfo.major_Air_Code#" /></td>
           	</Tr>
            <Tr  bgcolor="##deeaf3">
            	<td><h3>Local Airport (Airport Code)</h3></td>
                <td><cfinput type="text"  name="local_Air_Code" value="#hostInfo.local_Air_Code#"> <input type="hidden" name="ret_local_Air_Code" value="#hostInfo.local_Air_Code#" /></td>
           	</Tr>
			</table>
            <cfelse>
            </Table>
            </Cfif>
          
       
          
         <div align="center"><input type="image" src="../images/buttons/Next.png" />
         </div>
         <Cfif isDefined('lookup')>
        		<input type="hidden" name="process" />
         <cfelse>
              <input type="hidden" name="lookup" />
         </Cfif>
        </cfform>
		
        
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
