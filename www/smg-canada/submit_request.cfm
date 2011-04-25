<!----Submit email---->
<Cfif isDefined('form.process')>
     <cfif url.type is 'Student'>
    <cfset desc = 'A student submitted the following info.'>
    <cfelseif url.type is 'Agent'>
    <cfset desc = 'An agent submitted the following info.'>
    <cfelse>
    <cfset desc = 'A host submitted the following info.'>
    </cfif>
 
    <cfparam name="fname" default="Not filled in the request form">
    <cfparam name="address" default="Not filled in the request form">
    <cfparam name="city" default="Not filled in the request form">
    <!--<cfparam name="country" default="Not filled in the request form">-->
    <cfparam name="phone" default="Not filled in the request form">
    <cfparam name="fax" default="Not filled in the request form">
    <cfparam name="email" default="">
    <cfparam name="info" default="Not filled in the request form">

    <cfmail to='contact@smg-canada.org' cc='jeimi@exitgroup.org, josh.rahl@exitgroup.org' from='contact@smg-canada.org' subject='SMG-Canada online contact us'>
    SMG-Canada web site on #dateformat(Now(), 'mm/dd/yyyy')#.
    
    Name: #form.fname#
    Address: #form.address#
    City: #form.city#
    Country: #form.country#
    Zip: #form.zip#
    State: #form.state#
    Phone: #form.phone#
    Fax: #form.fax#
    E-Mail Address: #form.email#
   
   The following was sent online through smg-canada.org
    #desc#
    <!---Comments: #form.info#--->
    
    </cfmail>
</cfif>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>SMG Canada: Contact Us</title>
<link rel="shortcut icon" href="favicon.ico" />
<style type="text/css">
<!--
.lightBox {
	background-color: #EBE6DD;
	padding: 20px;
	margin-top: 0px;
	margin-right: auto;
	margin-bottom: 25px;
	margin-left: auto;
}
-->
</style>
<link href="css/smgCanada.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" language="JavaScript">
<!--
function HideDIV(d) { document.getElementById(d).style.display = "none"; }
function DisplayDIV(d) { document.getElementById(d).style.display = "block"; }
//-->
</script>
</head>

<body>

<div class="container">
  <div class="brownBar"></div>
<div class="header">
<div class="clearfix"></div>
<div align="center"><table width="735" border="0">
  <tr>
    <td width="583" rowspan="2"><a href="index.cfm"><img src="images/logo.png" alt="Insert Logo Here" name="Insert_logo" width="583" height="81" id="Insert_logo" style=" display:block;" /></a></td>
    <td width="142" align="right">119 Cooper Street, <br />
      Babylon, NY 11702<br />
      Phone: 1-631-893-4549   <br />
      Toll-free: 1-877-669-0717</td>
  </tr>
  <tr>
    <td align="right"><img src="images/login_03.png" width="48" height="17" alt="login" /></td>
  </tr>
</table></div>

    <!-- end header --></div>
  <div class="brownBar"></div>
  <div class="clearfix"></div>
  <div class="blackBar"><cfinclude template="includes/menu.cfm"></div>
  <div class="IndexBanner">
    <div class="brownBox">

<div class="mainContent">
 <h1><strong>Contact Us</strong></h1>
 <hr /> <hr />
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
         <cfform id="form1" name="form1" method="post" action="submit_request.cfm?type=#url.type#">
         <span class="formText">
          <input type="hidden" name="process" />
          Name
        </span><br />
            <cfinput type="text" name="fname" message="Please enter your last name." required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true" /><br />
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
    
           Zipcode - 5 digits only<br />
            <cfinput type="text" name="zip" message="Please enter a valid zip code." validateat="onSubmit" validate="zipcode" required="yes" id="Name" size=5 typeahead="no" showautosuggestloadingicon="true" maxlength="5" /><br />
             
            
           Phone Number<br />
            <cfinput type="text" name="phone" message="Please enter a valid phone number" pattern="(999) 999-9999" validateat="onSubmit" validate="telephone" required="yes" id="Name2" size=22 typeahead="no" showautosuggestloadingicon="true" />
            <br />
           Fax<br />
            <cfinput type="text" name="fax" message="Please enter a valid phone number" pattern="(999) 999-9999" validateat="onSubmit" validate="telephone" required="yes" id="Name2" size=22 typeahead="no" showautosuggestloadingicon="true" />
            <br />
           Email<br />
            <cfinput type="text" name="email" message="Please enter a valid email address." validateat="onSubmit" validate="email" required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true" /><br />
     
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
<br /><br />
</div>

<div class="submenu">
	<cfinclude template="includes/provinces.cfm">
<!--end submenu --></div>

   
   <!-- end brownBox --> </div>
  <!-- end indexBanner --></div>
  
  
<div class="content">
 <div class="facebook"><img src="images/facebook.png" width="82" height="31" alt="facebook" /></div>
  
    <div class="clearfix"></div>
  <!-- end content --></div>
  <cfinclude template="includes/footer.cfm">
  <!-- end container --></div>
</body>
</html>
