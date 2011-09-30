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
	font-family: Arial, Helvetica, sans-serif;
	border-bottom-width: medium;
	border-bottom-style: double;
	border-bottom-color: #999;
}
-->
</style>

<Cfif isDefined('form.submitTrip')>
	<cfparam name="FORM.otherTravelers" default="0">
	<Cfset client.selectedtrip= #form.selectedTrip#>
	<cfset client.otherTravelers = '#form.otherTravelers#'>
    <cflocation url="step4.cfm">
</Cfif>
<Cfset verified = 0>
<cfsilent>
	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	<cfif isDefined('URL.verify') or isDefined('FORM.verificationCode')>
    
        <!----Set Default Properties---->
        <Cfquery name="getStudentInfo" datasource="mysql">
        select s.familylastname, s.firstname, s.email, s.uniqueid, s.randid, h.email as hostemail, s.studentid, s.hostid
        from smg_students s
        LEFT JOIN smg_hosts h on h.hostid = s.hostid
      
        <Cfif isDefined('URL.verify')>
        where s.uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.verify#"> 
        </Cfif>
        <Cfif isDefined('FORM.verificationCode')>
        where s.randid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.verificationCode#">
        and s.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">
        </Cfif>
        </cfquery>
        <cfif getStudentInfo.recordcount eq 1>
        	<Cfset verified = 1>
            <Cfset client.verifiedStudent = #getStudentInfo.studentid#>
            <cfset client.verifiedHost = #getStudentInfo.hostid#>
        <cfelse>
        	 <cfscript>
    		// Primary
            if (1 eq 1 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("No records found, please check your information and try again.");
            }			
			</cfscript>
        </cfif>
    </cfif>
    <cfparam name="FORM.email" default="" >
	<Cfparam name="client.selectedtrip" default="0">
    
</cfsilent>
<!----Get available trips---->
       <cfquery name="trips" datasource="mysql">
        select *
        from smg_tours
        <!----
        where tour_status = 'active'
        ---->
		</cfquery>
        
 <!----Get available kids---->
       <cfquery name="kids" datasource="mysql">
        select *
        from smg_host_children
        where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.verifiedHost#"> 
		</cfquery>
        

</head>

<body>

<div id="wrapper">
<cfinclude template="../includes/header.cfm">
<div id="mainbody">
<cfinclude template="../includes/leftsidebar.cfm">
<div id="trip">

  	<gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />


<Cfif verified eq 0>
	<Cfoutput>
        <form method="post" action="step3.cfm">
            <table align="center">
                <Tr>
                    <Td colspan=2>Please check your email and follow the link to verify your account OR enter the verifcaiton code below:</Td>
                </Tr>
                <Tr>
                    <td align="right">Verification Code from Email:</td><td> <input type="text" size=15 name="verificationCode"></td>
                </Tr>
                <Tr>
                    <td align="right">Email Address:</td><td> <input type="text" size=15 name="email"></td>
                </Tr>
                <tr>
                    <td colspan=2 align="Center"><input type="image" src="../images/buttons/Next.png" /></td>
                </tr>
            </table>
        </form>
    </Cfoutput>
<cfelse>
<cfform method="post" action="step3.cfm">
<input type="hidden" name="submitTrip" />
	<h2>Please confirm the trip you would like to reserve a spot on:<br /></h2>
    
    <table>
    	<Tr>
        	<Td><span class="greyText"><strong>Available Trips</strong></span></Td>
            <Td>  <cfselect enabled="No"
                  name="selectedTrip" 
                  id="selectedTrip" 
                  multiple="no" 
                  query="trips"
                  value="tour_id"
                  display="tour_name"
                  selected="#client.selectedtrip#"
                 />
             </Td>
         </Tr>
     </table>
     <cfoutput>
     <Cfif kids.recordcount gt 0>
         <h2>Will any of your host siblings be going along?<br /></h2>
          <table>
            <Tr>
                <Td><span class="greyText"><strong>Who will be going?</strong></span></Td>
                <Td><cfloop query="kids">
                <input type="checkbox" name="otherTravelers" value="#childid#" />#name# #lastname# &nbsp;&nbsp;&nbsp;
                </cfloop>
                 </Td>
             </Tr>
         </table>
     </Cfif>
    </cfoutput>
    <div align="center"><input type="image" src="../images/buttons/next.png" /></div>
   	</cfform>
</cfif>
    <!-- trips --></div>
    <!-- mainbody --> </div>
    <div class="clearfix"></div>
<cfinclude template="../includes/footer.cfm">
<!-- wrapper --></div>



</body>
</html>
