<!----Submit email---->
<Cfif isDefined('form.process')>
 
 <cfparam name="fname" default="Not filled in the request form">
    <cfparam name="address" default="Not filled in the request form">
    <cfparam name="city" default="Not filled in the request form">
    <cfparam name="state" default="Not filled in the request form">
    <cfparam name="phone" default="Not filled in the request form">
    <cfparam name="fax" default="Not filled in the request form">
    <cfparam name="email" default="">
    <cfparam name="info" default="Not filled in the request form">

    <cfmail to='brendan@iseusa.com' cc='jeimi@exitgroup.org' from='support@iseusa.com' subject='Request for Info'>
     Information was submitted on the OUTBOUND web site on #dateformat(Now(), 'mm/dd/yyyy')#.
    
    Name: #form.fname#
    Address: #form.address#
    City: #form.city#
    Country: #form.country#
    Zip: #form.zip#
    State: #form.state#
    Phone: #form.phone#
    Fax: #form.fax#
    E-Mail Address: #form.email#
    What country are you interested in: #form.countryint#
    How did you hear about us: #form.hear#

    <!---Comments: #form.info#--->
    
    </cfmail>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>ISE OUTBOUND - TRAVEL & STUDY creating global understanding</title>
<link rel="shortcut icon" href="favicon.ico" />
<style type="text/css">
<!--
-->
</style>
<link href="css/outbound.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
a:link {
	color: #FFF;
	text-decoration: none;
}
a:visited {
	text-decoration: none;
	color: #FFF;
}
a:hover {
	text-decoration: none;
	color: #F19A38;
}
a:active {
	text-decoration: none;
}
li {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	vertical-align: middle;
	list-style-position: inside;
	list-style-type: square;
}
p {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
}
.form {
	width: 700px;
	margin-right: auto;
	margin-left: auto;
	padding-top: 15px;
	padding-right: 8px;
	padding-bottom: 8px;
	padding-left: 15px;
}
-->
</style>

<!----Script to Swap div area---->
<script type="text/javascript" language="JavaScript">
<!--
function HideDIV(d) { document.getElementById(d).style.display = "none"; }
function DisplayDIV(d) { document.getElementById(d).style.display = "block"; }
//-->
</script>

</head>
<form action="submit_request.cfm" method="post" onSubmit="return validateForm ()" name="form">
<body class="oneColFixCtrHdr">

<div id="container">
  <cfinclude template="header.cfm">
<div class="OtopBar"></div>
    <div class="logo"><a href="index.cfm"><img src="images/logo.png" width="215" height="191" border="0" /></a>
    <!-- end logo --></div>
<cfinclude template="spryMenu.cfm">
 <div id="mainContentPad">
   <div class="form">
   <div class="picWindow3"><img src="images/whyPic.png" width="350" height="250" /></div>
 <br />
  <cfif isDefined('form.process')>
   
   Your message was sent!
   <cfelse>    		
			<!----Query to get states and id's---->
<cfquery name="states" datasource="caseusa">
select id, state
from smg_states
</cfquery>
     <cfoutput>
         <cfform id="form1" name="form1" method="post" action="submit_request.cfm">
         <span class="formText">
          <input type="hidden" name="process" />
          First and Last Name
        </span><br />
            <cfinput type="text" name="fname" message="Please enter your last name." validate="noblanks" required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true" /><br />
           <span class="formText">Address </span><br />
            <cfinput type="text" name="address" message="Please enter your street address." required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true"  /><br />
       
           City<br />
            <cfinput type="text" name="city" id="Name" size=22  /><br />
         
           State<br />
    	   <select name="state">
		      <option value="0"></option>
		      <cfloop query="states">
		        <option value=#state#>#state#</option>
	         </cfloop>
	       </select>
           <br />
           
           Country<br />
            <cfinput type="text" name="country" message="Please enter a country" required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true" /><br />
    
           Zipcode<br />
            <cfinput type="text" name="zip" message="Please enter a valid zip code." validateat="onSubmit" validate="zipcode" required="yes" id="Name" size=5 typeahead="no" showautosuggestloadingicon="true" maxlength="5" /><br />
             
            
           Phone Number<br />
            <cfinput type="text" name="phone" message="Please enter a valid phone number" pattern="(999) 999-9999" id="Name2"  typeahead="no" showautosuggestloadingicon="true" />
            <br />
           Fax<br />
            <cfinput type="text" name="fax" message="Please enter a valid phone number" pattern="(999) 999-9999" validateat="onSubmit" validate="telephone" required="yes" id="Name2" size=22 typeahead="no" showautosuggestloadingicon="true" />
            <br />
           Email<br />
            <cfinput type="text" name="email" message="Please enter a valid email address." validateat="onSubmit" validate="email" required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true" /><br />
             What countries are you interested in studying in?<br />
            <cfinput type="text" name="countryint" id="countryint" size="45"/><br />
     
           How did you hear about us?<br />
            <cfselect enabled="No" name="hear" required="yes" multiple="no" message="Please tell us how you heard about SMG Canada."> 			<option value=""></option>
            <option value="google">Google Search</option>
            <option value="print add">Printed Material</option>
            <option value="person">Friend / Acquaintance</option>
            <option value="rep">SMG-Canada Representative</option>
            <option value="church">Church Group</option>
            <option value="other">Other</option>
            </cfselect>
            <br />
        <br />
        </p>
        <input type="image" src="images/submit.png" /><br />
        </cfform>
      </cfoutput>
</cfif>
</div>







<!-- end mainContent --></div>
<div class="bBar"></div>
<cfinclude template="footerBar.cfm">
<!-- end container --></div>
</body>
</html>
