<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>DMD - Private High School Student Form</title>
<link rel="shortcut icon" href="favicon.ico" />
<style type="text/css">
<!--
.table {
	width: 700px;
}
-->
</style>
<link href="css/phpusa.css" rel="stylesheet" type="text/css" />
</head>
<form action="submit_request.cfm" method="post" onSubmit="return validateForm ()" name="form">
<body class="oneColFixCtrHdr">
<div id="container">
  <cfinclude template="header.cfm">
  <div class="spacer"></div>
  
  <div id="mainContent">
  <div id="mainContentPad">
  <div class="spacerlg"></div>
<div class="photobox"><img src="images/why/pic1.gif" width="300" height="201" /></div>
  
     <span class="headline">Agent Form</span><br /><br />
     	<!----Query to get states and id's---->

<cfquery name="states" datasource="caseusa">
select id, state
from smg_states
</cfquery>
     <cfoutput>
         <cfform id="form1" name="form1" method="post" action="submit_request.cfm">
         <input type="hidden" name="new_account" />
           Name
        <br />
            <cfinput type="text" name="lastname" message="Please enter your last name." required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true" /><br />
            Address
            <br />
            <cfinput type="text" name="address" message="Please enter your street address." required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true"  /><br />
       
            City<br />
            <cfinput type="text" name="city" id="Name" size=22  /><br />
    State<br />
    		   <select name="state">
		      <option value="0"></option>
		      <cfloop query="states">
		        <option value=#id#>#state#</option>
		        </cfloop>
		      </select>
           <br />
    
          Zipcode - 5 digits only
          <br />
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
            <cfselect enabled="No" name="hear" required="yes" multiple="no" message="Please tell us how you heard about ISE."> 			<option value=""></option>
            <option value="google">Google Search</option>
            <option value="print add">Printed Material</option>
            <option value="person">Friend / Acquaintance</option>
            <option value="rep">DMD/PHP Representative</option>
            <option value="church">Church Group</option>
            <option value="other">Other</option>
            </cfselect>
            <br />
        <br />
        </p>
        <input type="image" src="images/buttons/submit.png" /><br />
        </cfform>
        </cfoutput>
   <!-- end mainContentPad --></div>
   <div class="bottomGradient"></div>
  <!-- end mainContent --></div>
  <div class="spacersm"></div>
<cfinclude template="footer.cfm">
  <div class="spacersm"></div>
<!-- end container --></div>
</body>
</html>
