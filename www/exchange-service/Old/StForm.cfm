<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Exchange Service International: Bringing the F-1 Program to Public Schools</title>
<link rel="shortcut icon" href="favicon.ico" />
<style type="text/css">
<!--

-->
</style>
<link href="css/ESIcss.css" rel="stylesheet" type="text/css" />
<form action="submit_request.cfm" method="post" onSubmit="return validateForm ()" name="form">
</head>

<body>
<div id="wrapper">
<cfinclude template="includes/topHeader.cfm">
<div id="mainBody">
  <cfinclude template="includes/menu.cfm">
<div id="mainText">
  <div class="headerPic"><img src="images/StFormheader.jpg"/></div>

<div class="innerText"><br />
<div class="blueBoxR">We are pleased to present to you our latest program, &quot;the F-1 Visa in the Public Schools.&quot;  We are so excited to bring this program to your attention since it gives our local public schools so many benefits and advantages.  The number one qualification for the school is that it must be able to issue an I-20 to each qualified student.  This enables the student to receive an F-1 visa for the semester or school year stay.</div>
       		
			<!----Query to get states and id's---->
<cfquery name="states" datasource="caseusa">
select id, state
from smg_states
</cfquery>
     <cfoutput>
         <cfform id="form1" name="form1" method="post" action="submit_request.cfm">
         <span class="formText">
          <input type="hidden" name="new_account" />
          Name
        </span><br />
            <cfinput type="text" name="fname" message="Please enter your last name." required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true" /><br />
           <span class="formText">Address </span><br />
            <cfinput type="text" name="address" message="Please enter your street address." required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true"  /><br />
       
           <span class="formText">City</span><br />
            <cfinput type="text" name="city" id="Name" size=22  /><br />
           <span class="formText">State</span><br />
    	   <select name="state">
		      <option value="0"></option>
		      <cfloop query="states">
		        <option value=#id#>#state#</option>
	         </cfloop>
	       </select>
           <br />
           
           <span class="formText">Country</span><br />
            <cfinput type="text" name="country" message="Please enter a country" required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true" /><br />
    
           <span class="formText">Zipcode - 5 digits only </span><br />
            <cfinput type="text" name="zip" message="Please enter a valid zip code." validateat="onSubmit" validate="zipcode" required="yes" id="Name" size=5 typeahead="no" showautosuggestloadingicon="true" maxlength="5" /><br />
             
            
           <span class="formText">Phone Number</span><br />
            <cfinput type="text" name="phone" message="Please enter a valid phone number" pattern="(999) 999-9999" validateat="onSubmit" validate="telephone" required="yes" id="Name2" size=22 typeahead="no" showautosuggestloadingicon="true" />
            <br />
           <span class="formText">Fax</span><br />
            <cfinput type="text" name="fax" message="Please enter a valid phone number" pattern="(999) 999-9999" validateat="onSubmit" validate="telephone" required="yes" id="Name2" size=22 typeahead="no" showautosuggestloadingicon="true" />
            <br />
           <span class="formText">Email</span><br />
            <cfinput type="text" name="email" message="Please enter a valid email address." validateat="onSubmit" validate="email" required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true" /><br />
     
           <span class="formText">How did you hear about us?</span><br />
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
        <input type="image" src="images/buttons/submit_19.png" /><a href="contact.cfm"><img src="images/buttons/BACK_21.png" width="86" height="25" alt="BACK" border="0"/></a><br />
        </cfform>
      </cfoutput>

<div class="clearfix"></div>


<!-- end textArea --></div>
  
  <!-- end mainBody --></div>
<cfinclude template="includes/footer.cfm">
<!-- end wrapper --></div>
</body>
</html>


