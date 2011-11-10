<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>CSB International: Summer Work Travel Program</title>
<style type="text/css">
<!--
.text {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	text-align: left;
	font-weight: bold;
}
.textU {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	text-align: center;
	font-style: italic;
}
.textCenter {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	text-align: center;
	font-weight: bold;
}
.oneColFixCtrHdr #container #mainContent ul ol{
	list-style-type: upper-roman;
	line-height: 13px;
	font-size: 10px;
}
.textItalic {
	font-family: Verdana, Geneva, sans-serif;
	font-size: 10px;
	line-height: normal;
	font-weight: normal;
	color: ##000;
	padding-top: 3px;
	padding-right: 10px;
	padding-bottom: 3px;
	padding-left: 10px;
}
.oneColFixCtrHdr #container #mainContent p{
	line-height: 13px;
	font-size: 10px;
}
.oneColFixCtrHdr #container #mainContent li{
	line-height: 13px;
	font-size: 10px;
}
-->
</style>

<link href="../css/csbusa.css" rel="stylesheet" type="text/css" />
 <link rel="stylesheet" media="all" type="text/css"href="../linked/css/baseStyle.css" />
<cfinclude template="includes/swtsuperfish_js.cfm">
<script src="../SpryAssets/SpryTooltip.js" type="text/javascript"></script>
<link href="../SpryAssets/SpryTooltip.css" rel="stylesheet" type="text/css" />
</head>

<Cfsilent>
<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

<!----Initialize variables---->
<Cfparam name=url.request default=''>
<cfparam name="form.sevis" default="">
<cfparam name="form.programID" default="">        
<cfparam name="form.lastname" default="">
<cfparam name="form.firstname" default="">
<cfparam name="form.middlename" default="">
<cfparam name="form.email" default="">
<cfparam name="form.address" default="">
<cfparam name="form.apt" default="">
<cfparam name="form.city" default="">
<cfparam name="form.state" default="">
<cfparam name="form.zip" default="">
<cfparam name="form.phone" default="">
<cfparam name="form.comment" default="">
<cfparam name="form.companyName" default="">
<cfparam name="form.companyAddress" default="">
<cfparam name="form.companyCity" default="">
<cfparam name="form.companyState" default="">
<cfparam name="form.companyZip" default="">
<cfparam name="form.companyPhone" default="">
<cfparam name="form.superName" default="">
<cfparam name="form.superEmail" default="">
<cfparam name="form.companyComment" default="">
<cfparam name="form.agreement" default="">
<cfparam name="form.send" default=0>
<cfparam name="form.process" default="">
</Cfsilent>

<cfquery name="states" datasource="mysql">
select statename, state
from smg_states
order by state
</cfquery>
<!----error checking on a submit---->
<!----First check to see if its being submitted---->


<Cfif val(form.process)>

		<Cfif not isValid("email", FORM.email)>
          <cfscript>
        	  if ( 1 eq 1 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Your email address does not appear to be valid.");
            }	
			</cfscript>
        </Cfif>
        
        <Cfif not isValid("email", FORM.superEmail)>
          <cfscript>
        	  if ( 1 eq 1 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Your supervisor's email address does not appear to be valid.");
            }	
			</cfscript>
        </Cfif>
        
        <cfscript>
            // Data Validation
			
			// SEVIS Number
            if ( NOT LEN(TRIM(FORM.Sevis)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your SEVIS number.");
            }
			// Program ID
            if ( NOT LEN(TRIM(FORM.programID)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your Program ID.");
            }			
        	
			// Last Name
            if ( NOT LEN(TRIM(FORM.lastname)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your Last Name.");
            }

			// First Name
            if ( NOT LEN(TRIM(FORM.firstname)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your First Name.");
            }

			// Email
            if ( NOT LEN(TRIM(FORM.email)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your email address.");
            }
			
			// Address
            if ( NOT LEN(TRIM(FORM.address)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your street address");
            }

			// City
            if ( NOT LEN(TRIM(FORM.city) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your city");
            }

			
			// state
            if ( NOT LEN(TRIM(FORM.state)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your state");
            }
			
			// zipcode
            if ( NOT LEN(TRIM(FORM.zip) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your zipcode");
            }

			
			// phone
            if ( NOT LEN(TRIM(FORM.phone)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your phone number");
            }
			
			// Company Name
            if ( NOT LEN(TRIM(FORM.companyName) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your Company's Name");
            }
			// Company Address
            if ( NOT LEN(TRIM(FORM.companyAddress) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your Company's address");
            }
			// Company city
            if ( NOT LEN(TRIM(FORM.companyCity) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your Company's city");
            }
			// Company state
            if ( NOT LEN(TRIM(FORM.companyState) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your Company's state");
            }
			// Company Zipcode
            if ( NOT LEN(TRIM(FORM.companyZip) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your Company's zipcode");
            }
			// Company Phone
            if ( NOT LEN(TRIM(FORM.companyPhone) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your Company's Phone");
            }
			// Company supervisor full name
            if ( NOT LEN(TRIM(FORM.superName) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your Supervisor's Name");
            }
			// Company supervisor email
            if ( NOT LEN(TRIM(FORM.superEmail) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your Supervisor's email");
            }
			// Company supervisor agreement
            if ( NOT LEN(TRIM(FORM.agreement) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please check YES, that you are personally submitting the Check-in information");
            }
			
		</cfscript>
        
        <!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
      
 <cfmail to="info@csb-usa.com" cc="#form.email#" from="info@csb-usa.com" subject="#form.lastname#, #form.firstname# - CSB Check-in / #form.companyName#" type="html">
    <p>Thank you for submitting the Check-in information. Please keep this electronic copy for your records.</p>
<p>CSB will process the information within 48 hours (exclusive of Saturday, Sunday, and legal Holidays) and if additional information is needed, an e-mail will be sent to the e-mail address you have provided on your application.</p>
<p>If you should have any questions or you need assistance during your stay in the United States, please feel free to contact us by e-mail <a href="mailto:info@csb-usa.com" class="black">info@csb-usa.com</a> or by calling us at our toll-free number 1-877-779-0717 (dial 0 for the operator).</p>
    
    <strong> The following Information was submitted from the check-in Form on the CSB site #dateformat(Now(), 'mm/dd/yyyy')#.</strong><br />
    Sevis##: #form.sevis#<br />
    Program ID##: #form.programID#<br />
    Last Name: #form.lastname#<br />
    First Name: #form.firstname#<br />
    Middle Name: #form.middlename#<br />
    E-Mail Address: #form.email#<br /><br />
    <br />
    <strong>Employer Information</strong><br />
    Company Name: #form.companyName#<br />
    Street Address: #form.companyAddress#<br />
    City: #form.companyCity#<br />
    State: #form.companyState#<br />
    Zip Code: #form.companyZip#<br />
    Supervisors Full Name: #form.superName#<br />
    Supervisor Phone Number: #form.companyPhone#<br />
    Supervisor Email: #form.superEmail#<br />
    Comments: #form.companyComment#<br />
    <br />
  <strong> Housing Information</strong><br />
    Address: #form.address#<br />
    Apt##: #form.apt#<br />
    City: #form.city#<br />
    State: #form.state#<br />
    Zip Code: #form.zip#<br />
    Phone in the U.S.: #form.phone#<br />
    Comments: #form.comment#<br /><br />

</cfmail>
    <!---Comments: anca--->
   		 <cfoutput>
                              <table width=90% align="center" border="1">
                      <tr>
                            <td >
    <strong> The following Information was submitted from the check-in Form on the CSB site #dateformat(Now(), 'mm/dd/yyyy')#.</strong><br />
    Sevis##: #form.sevis#<br />
    Program ID##: #form.programID#<br />
    Last Name: #form.lastname#<br />
    First Name: #form.firstname#<br />
    Middle Name: #form.middlename#<br />
    E-Mail Address: #form.email#<br /><br />
    <br />
    <strong>Employer Information</strong><br />
    Company Name: #form.companyName#<br />
    Street Address: #form.companyAddress#<br />
    City: #form.companyCity#<br />
    State: #form.companyState#<br />
    Zip Code: #form.companyZip#<br />
    Supervisors Full Name: #form.superName#<br />
    Supervisor Phone Number: #form.companyPhone#<br />
    Supervisor Email: #form.superEmail#<br />
    Comments: #form.companyComment#<br />
    <br />
  <strong> Housing Information</strong><br />
    Address: #form.address#<br />
    Apt##: #form.apt#<br />
    City: #form.city#<br />
    State: #form.state#<br />
    Zip Code: #form.zip#<br />
    Phone in the U.S.: #form.phone#<br />
    Comments: #form.comment#<br /><br />
   
  </td>
                        </tr>
                  </table></div>
                </cfoutput>
    
 
     <cfabort>
        </cfif>
	 
</Cfif>




<body class="oneColFixCtrHdr">

<cfinclude template="SWTheader.cfm">
<div class="clearfixB">Summer Work Travel Program</div>
<div id="container">
<div id="tabsDiv"><cfinclude template="../SWT/includes/swt_menu.cfm"></div>
<div class="clearfixFillB"></div>
<div id="mainContent">
<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
<h2>Check-In / Validation</h2>
<!---
<cfif NOT SESSION.formErrors.length()>
   <p>Thank you for submitting the Check-in information to CSB. An electronic copy of the form was sent to your e-mail address as well.</p>
<p><strong>CSB will process the information within 48 hours</strong> (<u>exclusive</u> of Saturday, Sunday, and legal Holidays) and if additional information is needed, an e-mail will be sent to the e-mail address you have provided on your application.</p>
<p>If you should have any questions or you need assistance during your stay in the United States, please feel free to contact us by e-mail (<a href="mailto:info@csb-usa.com" class="black">info@csb-usa.com</a>) or by calling us at our toll-free number 1-877-779-0717 (dial 0 for the operator).</p>
<cfelse>    		
---->
<p>As a program participant, in order to work and travel legally in the United States, you must validate your program within 10 (ten) business day from the start date of your Form DS-2019. To meet this deadline, you must <strong>Check-in* with CSB the <u>next day AFTER your date of arrival</u></strong> at your host site in the United States. <strong>This is an important step </strong>to ensure that your current U.S. address is accurately reflected in the Student Exchange Visitor Information System (SEVIS). The SEVIS system shows that your visa is current and that you are lawfully present in the United States and authorized to work.</p>
<h4> CHECK-IN Form</h4>
<p><strong>Please submit only accurate information.</strong> If you are not sure of the addresses, please ask and confirm the information before submitting it. Never copy the information from a piece of paper without being certain that you are in fact providing accurate and/or updated information.</p>
<ul><strong>Please note that:</strong>
  <li> Submitting inaccurate information may cause delays in updating the information in SEVIS and further, delays in the process of applying and obtaining the Social Security Number.<br />
</li><li>Intentionally submitting false information may lead to program termination and the participant will be asked to return home
  immediately. Such action may create legal difficulties that will affect my future travel, study or work in the U.S. at any time in the future.</li></ul>
<p class="redText"><strong><u>Important:</u></strong> If you move while in the United States to another housing location, you must contact CSB within 10 (ten) business days of the change so that your address can be updated in SEVIS. This is important as it ensures that you remain in valid status during your stay.</span></p>
<p class="text"> * Required<br>
              </p>

	<cfform action="checkin.cfm" method="post" name="form" id="form" >
     <cfoutput>
    <input name="process" type="hidden" value="1" />
     
      <table width="616" align="center">
  <tr>
    <td width="160"  class="text">SEVIS Number:</td>
    <td width="444" class="text">
      <input name="sevis" type="Text" class="text" id="sevis" size="40" maxlength="40" value="#form.sevis#" />
     <a href="javascript:MM_openBrWindow('images/ds-2019.jpg','ds2019','width=635,height=467')"><span id="sprytrigger2"><img src="../images/question.gif" width="15" height="15" border="0"> <span class="redText">What is this?</span></span></a></td>
  </tr>
   <tr>
    <td class="text">Program ID Number:</td>
    <td class="text">
      <input type="text" name="programID" value="#form.programid#" class="text" id="programID" size="40" maxlength="40" typeahead="no" showautosuggestloadingicon="true" /><span id="sprytrigger1">&nbsp;<img src="../images/question.gif" width="15" height="15" border="0"> <span class="redText">What is this?</span></span></a>    </td>
  </tr>
  <tr>
    <td class="text">Last Name: *</td>
    <td class="text">
      <input name="lastname" type="Text" class="text" id="lastname" size="50" maxlength="50" value="#form.lastname#" />    </td>
  </tr>
  
  <tr>
    <td class="text">First Name: *</td>
    <td class="text">
      <input name="firstname" type="Text" class="text" id="firstname" size="50" maxlength="50" value="#form.firstname#"/>    </td>
  </tr>
  <tr>
    <td class="text">Middle Name:&nbsp;
    </td>
    <td class="text">
        <input name="middlename" type="Text" class="text" id="middlename" size="50" maxlength="50" value="#form.middlename#"/>
        
  <tr>
    <td class="text">E-Mail Address: *</td>
    <td class="text"><input type="text" name="email" validateat="onSubmit" validate="email"class="text" id="email" size="50" maxlength="50" value="#form.email#"/></td>
  </tr>
  <tr>
    <td height="17" colspan="2" class="textCenter">&nbsp;</td>
  </tr>
  
  <tr>
    <td height="17" colspan="2" bgcolor="##CCCCCC" class="textCenter">&nbsp;Employer Information:<br></td>
  </tr>
  <tr>
    <td colspan="2" align="center" class="textU">(please confirm the host company information where you work in the United States)</td>
    </tr>
    <tr>
    <td class="text">Company Name:&nbsp;*</td>
    <td class="text"><input name="companyName" type="Text" class="text" id="companyName" size="50" maxlength="50" value="#form.companyName#" /></td></tr>

  <tr>
    <td class="text">Street Address:&nbsp;*</td>
    <td class="text"><input name="companyAddress" type="Text" class="text" id="companyAddress" size="50" maxlength="50" value="#form.companyAddress#"/>    </td>
  </tr>
  <tr>
    <td class="text">City :*</td>
    <td class="text">
      <input name="companyCity" type="Text" class="text" id="companyCity" size="50" maxlength="50" value="#form.companyCity#" />    </td>
  </tr>
  <tr>
    <td class="text">State: *</td>
    <td class="text">
               <select name="companyState" size="1" class="text">
              <option value="">
              <cfloop query="states">
                <option value="#state#" <Cfif form.companystate eq #state#>selected</cfif>> #statename#</option>
              </cfloop>
            </select>  </td>
  </tr>
  <tr>
    <td class="text">Zip Code: *</td>
    <td class="text">
      <input name="companyzip" type="Text" class="text" id="companyZip" size="50" maxlength="50" value="#form.companyZip#"/>    </td>
  </tr>

   <tr>
    <td class="text">Supervisor Full Name:&nbsp;*</td>
    <td class="text"><input name="superName" type="Text" class="text" id="superName" size="50" maxlength="50" value="#form.superName#"/></td></tr>
      <tr>
    <td class="text">Supervisor Phone Number:</td>
    <td class="text"><input name="companyPhone" type="Text" class="text" id="companyPhone" size="50" maxlength="50/" value="#form.companyPhone#" /></td>
  </tr>
    <tr>
    <td class="text">Supervisor Email:&nbsp;*</td>
    <td class="text"><input type="text" name="superEmail"  class="text" id="superEmail" size="50" maxlength="50" value="#form.superEmail#" /></td></tr>
  <tr>
    <td valign="top" class="text">Comments:</td>
    <td class="text">
      <textarea name="companyComment" cols="50" rows="5" wrap="VIRTUAL" class="text" value="#form.companyComment#"/></textarea>    </td>
  </tr>
  <tr>
    <td height="17" colspan="2" bgcolor="##fff" class="textCenter">&nbsp;</td>
  </tr>
  <tr>
    <td height="17" colspan="2" bgcolor="##CCCCCC" class="textCenter">&nbsp;Housing Information:<br></td>
  </tr>
  <tr>
    <td colspan="2" align="center" class="textU">(please provide the address where you currently live in the United States)</td>
    </tr>
  <tr>
    <td class="text">Street Address:&nbsp;*</td>
    <td class="text"><input name="address" type="Text" class="text" id="address" size="40" maxlength="40" value="#form.address#" /> 
    Apt ## 
      <input name="apt" type="Text" class="text" id="apt" size="15" maxlength="15" value="#form.apt#"/></td>
  </tr>
  <tr>
    <td height="25" class="text">City: *</td>
    <td class="text">
      <input name="city" type="Text" class="text" id="city" size="35" maxlength="50" value="#form.city#" />    </td>
  </tr>
  <tr>
    <td class="text">State: *</td>
    <td class="text">
    
            <select name="state" size="1" class="text">
              <option value="">
              <cfloop query="states">
                <option value="#state#" <Cfif form.state eq #state#>selected</cfif>> #statename#</option>
              </cfloop>
            </select>
      </td>
  </tr>
  <tr>
    <td class="text">Zip Code: *</td>
    <td class="text">
      <input name="zip" type="Text" class="text" id="zip" size="50" maxlength="50" value="#form.zip#"/></td>
  </tr>
  <tr>
    <td class="text">Phone Number in the U.S.:</td>
    <td class="text"><input name="phone" type="Text" class="text" id="phone" size="50" maxlength="50" value="#form.phone#" /></td>
  </tr>
  <tr>
    <td valign="top" class="text">Comments:</td>
    <td class="text">
      <textarea name="comment" cols="50" rows="5" wrap="VIRTUAL" class="text" value="#form.comment#" /></textarea>    </td>
  </tr>
   <tr bgcolor="##EDEDED">
    <td align="right" valign="center" class="text">
    <table width="100%" border="0">
  <tr>
    <td width="77%">&nbsp;</td>
    <td width="23%"><input type="checkbox" name="agreement" id="agreement"/></td>
  </tr>
</table></td>
    <td class="text"><p class="textItalic">Yes, I am personally submitting the Check-in information. I
am also confirming that the information I have provided in the form is accurate according to my best knowledge and that I am in fact working and living at the addresses I have provided above. I also confirm that I understand that by intentionally submitting false information I may be terminated from the program. Such action may create legal difficulties that will affect my future travel, study or work in the United States at any time in the future.</p></td>
  </tr>
  <tr>
    <td colspan="2" align="center" bgcolor="##CCCCCC" class="textCenter">
      <cfinput name="submit" type="Submit" class="text" value="Submit">    </td>
  </tr>
</table>

</Cfoutput>
    </cfform>
<!---
</cfif>
--->

                  <hr width="95%" color="##000099" align="center"> <br /> 
                  
<div class="tooltipContent" id="sprytooltip1"><strong>Program ID Number</strong><p><img src="images/ProgramIDNumber.jpg" width="300" alt="Program ID Number" /></p>

<script type="text/javascript">
var sprytooltip1 = new Spry.Widget.Tooltip("sprytooltip1", "#sprytrigger1", {hideDelay:1000, offsetX:0, offsetY:0});
</script>
</div> 

<div class="tooltipContent" id="sprytooltip2"><strong>SEVIS Number</strong>
  <p><img src="images/DS-2019.jpg" width="300" alt="Program ID Number" /></p>

<script type="text/javascript">
var sprytooltip2 = new Spry.Widget.Tooltip("sprytooltip2", "#sprytrigger2", {hideDelay:1000, offsetX:0, offsetY:0});
</script>
</div>               
                  
    
  <!-- end mainContent --></div>
  
  <div class="clearfix"></div>
<!-- end container --></div>
<div class="clearfixT"></div>
<cfinclude template="../footer.cfm">
<div class="bStrip"></div>
</body>
</html>
