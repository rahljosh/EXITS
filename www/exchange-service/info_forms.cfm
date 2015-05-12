<cfparam name="FORM.captcha" default="">
    <cfparam name="FORM.strCaptcha" default="#makeRandomString()#">
    <cfparam name="FORM.captchaHash" default="">    

<cffunction name="makeRandomString" returnType="string" output="false">
        
        <cfscript>
			var chars = "23456789ABCDEFGHJKMNPQR";
			var length = randRange(4,5);
			var result = "";
			var i = "";
			var char = "";
			
			for(i=1; i <= length; i++) {
				char = mid(chars, randRange(1, len(chars)),1);
				result&=char;
			}
        </cfscript>
            
        <cfreturn result>
    </cffunction>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Exchange Service International: Bringing the F-1 program to public schools</title>
<link href="css/ESI.css" rel="stylesheet" type="text/css" />
<link rel="shortcut icon" href="favicon.ico" />
</head>
 <!----Submit email---->
<Cfif isDefined('form.process')>
     <cfif url.type is 'Student'>
    <cfset desc = 'A student submitted the following information'>
    <cfelseif url.type is 'Agent'>
    <cfset desc = 'An agent submitted the following information'>
    <cfelse>
    <cfset desc = 'A host submitted the following information.'>
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

    <cfmail to='stacy@exchange-service.org' cc='jeimi@exitgroup.org' from='Exchange Service International <support@exchange-service.org>' subject='#url.type# Request for Information'>
    From the #url.type# form, on the Exchange Service International web site. request sent #dateformat(Now(), 'mm/dd/yyyy')#
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
<body>
<div class="container">
<!--- HEADER  --->
<cfinclude template="includes/header.cfm">

<!---LOGO AND SLIDESHOW SECTION--->
  <div class="INdisplay">
  	<div class="INleft"><table width="250" border="0" cellspacing="0" cellpadding="5" align="center">
  <tr>
    <td><a href="index.cfm"><img src="images/logo_ESI.jpg" width="250" height="88" alt="Exchange Student International logo" /></a></td>
  </tr>
  <tr>
    <td height="99"> Exchange Service International Program</td>
  </tr>
</table>
<!-- end display left --></div>
    <div class="INright">
    <img src="images/program_header.jpg" width="665" height="262" /></div>
<!-- end display --></div>

<!---DROP DOWN MENU--->
<div class="menu">
<cfinclude template="menu/ESI_Menu.cfm">
</div>

<!---LEFT SIDE BAR--->
<cfinclude template="includes/sidebar1.cfm">

<!---MAIN CONTENT--->
  <div class="content">
 <h1><cfif url.type is 'Student'>
    	Student Form
    <cfelseif url.type is 'Agent'>
    	Agent Form
    <cfelse>
    	Host Family Form
    </cfif></h1>
 <cfif url.type is 'Student'>
    	<p>We are pleased to present to you our latest program, "The F-1 Public School Program." We are so excited to bring this program to your attention as it gives our students so many benefits and advantages. ESI accepts qualified students ages 15-18 to attend public high schools in the United States and experience the American way of life for either an academic year or one semester.  Students are carefully screened and selected to be sure they possess academic achievement, exemplary character, adaptability and sufficient command of the English language.  Students are placed with American host families who provide students with room, board and a willingness to make the student a part of their family.  The number one advantage for our students is that he/she is able to choose the city and school district where they will study during their stay.</p>  
    <cfelseif url.type is 'Agent'>
    	<p>We are pleased to present to you our latest program, "The F-1 Public School Program." We are so excited to bring this program to your attention as it gives your students so many benefits and advantages. ESI accepts qualified students ages 15-18 to attend public high schools in the United States and experience the American way of life for either an academic year or one semester.  International partners carefully screen and select students to be sure they possess academic achievement, exemplary character, adaptability and sufficient command of the English language.  Students are placed with American host families who are paid and provide students with room, board and a willingness to make the student a part of their family.  The number one advantage for your students is that he/she is able to choose the city and school district where they will study during their stay.</p>
    <cfelse>
    <p>	We are pleased to present to you our latest program, "The F-1 Public School Program." We are so excited to bring this program to your attention as it gives our host families the ability to bring foreign culture into their home and share American culture with a student. Host families provide room, board and a willingness to make the student a part of their family. Host families receive a stipend for hosting, but more importantly they are making a difference in the life of a teenager and encouraging cultural understanding and international harmony."</p> <br />
    </cfif>

   <cfif isDefined('form.process')>
  <div class="callout"> 
  <p><strong> Your message was sent!</strong> An ESI representative will be contacting you. Thank you for your interest.</p></div>
<cfelse>    		
			<!----Query to get states and id's---->
<cfquery name="states" datasource="mysql">
select id, state
from smg_states
</cfquery>
     <cfoutput>
         <cfform id="form1" name="form1" method="post" action="info_forms.cfm?type=#url.type#">
         <input type="hidden" name="process" />
           <cfoutput>
<input type="hidden" name="strCaptcha" value="#FORM.strCaptcha#">
<input type="hidden" name="captchaHash" value="#FORM.captchaHash#">
</cfoutput> 
         <table width="70%" border="0" cellspacing="0" cellpadding="5" class="formBox">
          <cfif url.type is 'Agent'>        
  <tr bgcolor="##EFEFEF">
    <td align="right">Company:</td>
    <td><cfinput type="text" name="company" message="Please enter a company name." required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true" /></td>
  </tr>
  </cfif>
  <tr >
    <td width="42%" align="right">Name:</td>
    <td width="58%"><cfinput type="text" name="fname" message="Please enter your last name." required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true" /></td>
  </tr>
  <tr  bgcolor="##EFEFEF">
    <td align="right">Address:</td>
    <td><cfinput type="text" name="address" message="Please enter your street address." required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true"  /></td>
  </tr>
  <tr>
    <td align="right">City:</td>
    <td><cfinput type="text" name="city" id="Name" size=22  /></td>
  </tr>
  <tr  bgcolor="##EFEFEF">
    <td align="right">State:</td>
    <td><select name="state">
		      <option value="0"></option>
		      <cfloop query="states">
		        <option value=#state#>#state#</option>
	         </cfloop>
	       </select></td>
  </tr>
  <tr>
    <td align="right">Country:</td>
    <td><cfinput type="text" name="country" message="Please enter a country" required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true" /></td>
  </tr>
  <tr  bgcolor="##EFEFEF">
    <td align="right">Postal Code:</td>
    <td><cfinput type="text" name="zip" message="Please enter a valid zip code." required="yes" id="Name" size=5 typeahead="no" showautosuggestloadingicon="true"  /></td>
  </tr>
  <tr>
    <td align="right">Phone:</td>
    <td><cfinput type="text" name="phone" message="Please enter a valid phone number"  validateat="onSubmit" validate="noblanks"  required="yes" id="Name2" size=22 typeahead="no" showautosuggestloadingicon="true" /></td>
  </tr>
    <tr  bgcolor="##EFEFEF">
    <td align="right">Fax:</td>
    <td><cfinput type="text" name="fax" required="no" id="Name2" size=22 typeahead="no"  /></td>
  </tr>
  <tr>
    <td align="right">Email:</td>
    <td><cfinput type="text" name="email" message="Please enter a valid email address." validateat="onSubmit" validate="email" required="yes" id="Name" size=22 typeahead="no" showautosuggestloadingicon="true" /></td>
  </tr>
  <tr  bgcolor="##EFEFEF">
    <td align="right">How did you hear about us?</td>
    <td><cfselect enabled="No" name="hear" required="yes" multiple="no" message="Please tell us how you heard about ESI."><option value=""></option>
            <option value="google">Google Search</option>
            <option value="print add">Printed Material</option>
            <option value="person">Friend / Acquaintance</option>
            <option value="rep">ESI Representative</option>
            <option value="church">Church Group</option>
            <option value="other">Other</option>
            </cfselect></td>
  </tr>
  <tr>
  	<td colspan=2 align="center">
  		 <!--- Captcha --->
         <cfimage action="captcha" width="215" height="75" text="#FORM.strCaptcha#" difficulty="high" fontsize="28">                 
     </td>   
   </tr>
   <tr>
   		<td align="right">Please enter text in the image above</td>
   		<td align="left"><cfinput type="text" name="captcha" id="captcha" class="largeInput" required="yes" message="Please enter the captcha text in the image."></td>
   </tr>
  <tr>
    <td><a href="contact_ESI.cfm"><img src="images/back.png" height="35px" alt="BACK" border="0"/></a></td>
    <td align="right"><input type="image" src="images/submit.png" height="35px" /></td>
  </tr>
</table>
        
        </cfform>
      </cfoutput>
</cfif>
    <!-- end .content --></div>
    
  <!---RIGHT SIDEBAR--->  
<cfinclude template="includes/sidebar2.cfm">

<!---FOOTER --->
  <div class="footer">
 
    <!-- end .footer --></div>
  <!-- end .container --></div>
</body>
</html>
