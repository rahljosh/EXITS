<!----Submit email---->
<Cfif isDefined('form.process')>
     <cfif url.type is 'Student'>
    <cfset desc = 'A student submitted the following info.'>
    <cfelseif url.type is 'Agent'>
    <cfset desc = 'An agent submitted the following info.'>
    <cfelse>
    <cfset desc = 'A host submitted the following info.'>
    </cfif>
 
    <cfparam name="form.fname" default="">
    <cfparam name="form.company" default="">
    <cfparam name="form.address" default="">
    <cfparam name="form.city" default="">
    <!--<cfparam name="country" default="Not filled in the request form">-->
    <cfparam name="form.phone" default="">
    <cfparam name="form.fax" default="">
    <cfparam name="form.email" default="">
    <cfparam name="form.info" default="">

    <cfmail to='stacy@exchange-service.org' cc='jeimi@exitgroup.org' from='support@exchange-service.org' subject='Request for Info'>
    From the Exchange Service International web site on #dateformat(Now(), 'mm/dd/yyyy')#.
    #desc#:
    
    Name: #form.fname#
   <cfif url.type eq 'Agent'>
   Company: #form.company#
   </cfif>
    Address: #form.address#
    City: #form.city#
    State: #form.state#
    Country: #form.country#
    Zip: #form.zip#
    Phone: #form.phone#
    Fax: #form.fax#
    E-Mail Address: #form.email#
   
   
    <!---Comments: #form.info#--->
    
    </cfmail>
</cfif>



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

</head>

<body>
<div id="wrapper">
<cfinclude template="includes/topHeader.cfm">
<div id="mainBody">
  <cfinclude template="includes/menu.cfm">
<div id="mainText">
  <div class="headerPic">
     <cfif url.type is 'Student'>
    	<img src="images/StFormheader.jpg"/>
    <cfelseif url.type is 'Agent'>
    	<img src="images/headers/AgentForm.jpg"/>
    <cfelse>
    	<img src="images/headers/hostfamilyform.jpg"/>
    </cfif>
  
  </div>

<div class="innerText"><br />
<div class="blueBoxR">
     <cfif url.type is 'Student'>
    	<p>We are pleased to present to you our latest program, "The F-1 Public School Program." We are so excited to bring this program to your attention as it gives our students so many benefits and advantages. ESI accepts qualified students ages 15-18 to attend public high schools in the United States and experience the American way of life for either an academic year or one semester.  Students are carefully screened and selected to be sure they possess academic achievement, exemplary character, adaptability and sufficient command of the English language.  Students are placed with American host families who provide students with room, board and a willingness to make the student a part of their family.  The number one advantage for our students is that he/she is able to choose the city and school district where they will study during their stay.</p>  
    <cfelseif url.type is 'Agent'>
    	<p>We are pleased to present to you our latest program, "The F-1 Public School Program." We are so excited to bring this program to your attention as it gives your students so many benefits and advantages. ESI accepts qualified students ages 15-18 to attend public high schools in the United States and experience the American way of life for either an academic year or one semester.  International partners carefully screen and select students to be sure they possess academic achievement, exemplary character, adaptability and sufficient command of the English language.  Students are placed with American host families who are paid and provide students with room, board and a willingness to make the student a part of their family.  The number one advantage for your students is that he/she is able to choose the city and school district where they will study during their stay.</p>
    <cfelse>
    	We are pleased to present to you our latest program, "The F-1 Public School Program." We are so excited to bring this program to your attention as it gives our host families the ability to bring foreign culture into their home and share American culture with a student. Host families provide room, board and a willingness to make the student a part of their family. Host families receive a stipend for hosting, but more importantly they are making a difference in the life of a teenager and encouraging cultural understanding and international harmony." 
    </cfif>
</div>
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
            <cfif url.type is 'Agent'>
            <span class="formText">Company</span><br />
            <cfinput type="text" name="company" message="Please enter a company name." required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true" /><br />
            </cfif>
           <span class="formText">Address </span><br />
            <cfinput type="text" name="address" message="Please enter your street address." required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true"  /><br />
       
           <span class="formText">City</span><br />
            <cfinput type="text" name="city" id="Name" size=22  /><br />
         
           <span class="formText">State</span><br />
    	   <select name="state">
		      <option value="0"></option>
		      <cfloop query="states">
		        <option value=#state#>#state#</option>
	         </cfloop>
	       </select>
           <br />
           
           <span class="formText">Country</span><br />
            <cfinput type="text" name="country" message="Please enter a country" required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true" /><br />
    
           <span class="formText">Postal Code</span><br />
            <cfinput type="text" name="zip" message="Please enter a valid zip code." required="yes" id="Name" size=5 typeahead="no" showautosuggestloadingicon="true"  /><br />
             
            
           <span class="formText">Phone Number</span><br />
            <cfinput type="text" name="phone" message="Please enter a valid phone number"  validateat="onSubmit"  required="yes" id="Name2" size=22 typeahead="no" showautosuggestloadingicon="true" />
            <br />
           <span class="formText">Fax</span><br />
            <cfinput type="text" name="fax" required="no" id="Name2" size=22 typeahead="no"  />
            <br />
           <span class="formText">Email</span><br />
            <cfinput type="text" name="email" message="Please enter a valid email address." validateat="onSubmit" validate="email" required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true" /><br />
     
           <span class="formText">How did you hear about us?</span><br />
            <cfselect enabled="No" name="hear" required="yes" multiple="no" message="Please tell us how you heard about ISE."> 			<option value=""></option>
            <option value="google">Google Search</option>
            <option value="print add">Printed Material</option>
            <option value="person">Friend / Acquaintance</option>
            <option value="rep">ESI Representative</option>
            <option value="church">Church Group</option>
            <option value="other">Other</option>
            </cfselect>
            <br />
        <br />
        </p>
        <input type="image" src="images/buttons/submit_19.png" /><a href="contact.cfm"><img src="images/buttons/BACK_21.png" width="86" height="25" alt="BACK" border="0"/></a><br />
        </cfform>
      </cfoutput>
</cfif>
<div class="clearfix"></div>


<!-- end textArea --></div>
  
  <!-- end mainBody --></div>
<cfinclude template="includes/footer.cfm">
<!-- end wrapper --></div>
</body>
</html>























