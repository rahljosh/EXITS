


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>CSB International: Summer Work Travel Program</title>
<style type="text/css">
<!--
.text {
	font-family: Verdana, Geneva, sans-serif;
	font-size: 9px;
	text-align: left;
	font-weight: bold;
}
.textU {
	font-family: Verdana, Geneva, sans-serif;
	font-size: 9px;
	text-align: center;
	font-style: italic;
}
.textCenter {
	font-family: Verdana, Geneva, sans-serif;
	font-size: 12px;
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
 td .redItalic {
	font-family: Verdana, Geneva, sans-serif;
	font-size: 9px;
	line-height: normal;
	font-weight: normal;
	color: ##F00;
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

tr, td {
	padding: 0px;
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
<cfparam name="form.BMonth" default="">
<cfparam name="form.BDay" default="">
<cfparam name="form.BYear" default="">
<cfparam name="form.middlename" default="">
<cfparam name="form.email" default="">
<cfparam name="form.arrive" default="">
<cfparam name="form.arriveEmployers" default="">
<cfparam name="form.arriveHost" default="">
<cfparam name="form.address" default="">
<cfparam name="form.apt" default="">
<cfparam name="form.city" default="">
<cfparam name="form.state" default="">
<cfparam name="form.zip" default="">
<cfparam name="form.phone" default="">
<cfparam name="form.phoneType" default="">
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
<cfparam name="form.agreement2" default="">
<cfparam name="form.agreement3" default="">
<cfparam name="form.agreement4" default="">
<cfparam name="form.agreement5" default="">
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
		
			//Bday Month
            if ( NOT LEN(TRIM(FORM.BMonth)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the Month you were born.");
            }
			// Bday Day
            if ( NOT LEN(TRIM(FORM.BDay)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the date you were born.");
            }

			// bday year
            if ( NOT LEN(TRIM(FORM.BYear)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the year you were born.");
            }

			// Email
            if ( NOT LEN(TRIM(FORM.email)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your email address.");
            }

		
			// Arrival
            if ( NOT LEN(TRIM(FORM.arrive)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the date for arrival in the United States.");
            }
			
			// Arrive at Employers
            if ( NOT LEN(TRIM(FORM.arriveEmployers)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter Yes or No if you have been to your employers.");
            }
			
			// Email
            if ( NOT LEN(TRIM(FORM.arriveHost)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the date at your employers.");
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
			// state
            if ( NOT LEN(TRIM(FORM.phoneType)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Type of phone number");
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
                SESSION.formErrors.Add("Please check YES");
            }
				// Company supervisor agreement
            if ( NOT LEN(TRIM(FORM.agreement2) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please check that you understand the following rules");
            }	
			// Company supervisor agreement
            if ( NOT LEN(TRIM(FORM.agreement3) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please check that you understand the following rules");
            }
				// Company supervisor agreement
            if ( NOT LEN(TRIM(FORM.agreement4) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please check that you understand the following rules");
            }
				// Company supervisor agreement
            if ( NOT LEN(TRIM(FORM.agreement5) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please check that you understand the following rules");
            }
		</cfscript>
        
        <!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
        	
			<cfoutput>
            
        		<cfsavecontent variable="vSaveContent">
                    <p style="font-family:Verdana, Geneva, sans-serif; font-size: 11px;">
                        <strong> The following information was submitted from the Check-in Form on the CSB site on #dateformat(Now(), 'mm/dd/yyyy')#.</strong><br />
                        Sevis##: #form.sevis#<br />
                        Program ID##: #form.programID#<br />
                        Last Name: #form.lastname#<br />
                        First Name: #form.firstname#<br />
                        Birth Date: #BMonth#/#BDay#/#BYear#<br />
                        Middle Name: #form.middlename#<br />
                        E-Mail Address: #form.email#<br />
                        Arrival date in the U.S.: #form.arrive#<br />
                        Have you arrived at your Host Employer: #form.arriveEmployers#, Arrival Date at Host Employer: #form.arriveHost#<br /><br />
                    </p>
    
                    <p style="font-family:Verdana, Geneva, sans-serif; font-size: 11px;">
                        <strong>Employer Information</strong><br />
                        Company Name: #form.companyName#<br />
                        Street Address: #form.companyAddress#<br />
                        City: #form.companyCity#<br />
                        State: #form.companyState#<br />
                        Zip Code: #form.companyZip#<br />
                        Supervisor Full Name: #form.superName#<br />
                        Supervisor Phone Number: #form.companyPhone#<br />
                        Supervisor Email: #form.superEmail#<br />
                        Comments: #form.companyComment#<br /><br />
                    </p>
    
                    <p style="font-family:Verdana, Geneva, sans-serif; font-size: 11px;">
                        <strong> Housing Information</strong><br />
                        Address: #form.address#<br />
                        Apt##: #form.apt#<br />
                        City: #form.city#<br />
                        State: #form.state#<br />
                        Zip Code: #form.zip#<br />
                        Phone in the U.S.: #form.phone# #form.phoneType#<br />
                        Comments: #form.comment#<br /><br />
                    </p>
       
                    <p style="font-family:Verdana, Geneva, sans-serif; font-size: 11px;">
                        (#form.agreement#): Yes, I am personally submitting the Check-in information. I am also confirming that the information 
                        I have provided in the form is accurate according to my best knowledge and that I am in fact working and living at the 
                        addresses I have provided above. I also confirm that I understand that by intentionally submitting false information I 
                        will be terminated from the program.<br /><br />
                        
                        (#form.agreement2#):I understand that during my program I must report any change in my housing address within 10 (ten) 
                        business days of the change.  Failure to report the changes on time will lead to a program termination.<br /><br />
    
                        (#form.agreement3#): I understand that during my program I must have permission (in writing) from CSB in order to change 
                        my primary host employer. CSB must investigate any claim before taking a decision. Failure to have permission will lead 
                        to a program termination.<br /><br />
    
                        (#form.agreement4#): I understand that during my program CSB must confirm any new, replacement and additional (second) 
                        job placements before I may start work. CSB will normally verify (vet) such jobs within 72 hours and will confirm the 
                        result in writing. Starting work at unverified and unapproved jobs will lead to a program termination.<br /><br />
    
                        (#form.agreement5#): I will maintain contact with CSB for the entire duration of the program. As required by the program 
                        regulations, I will receive a monthly evaluation request by email every 30 (thirty) days after the Check-in and I am required 
                        to respond to CSB within 10 (ten) business days.  Failure to reach back to CSB on time will lead to a program termination.
                    </p>
            	</cfsavecontent>
            
				<cfscript>
                    monthAsNumberString = "00";
                    if (FORM.BMonth EQ "January") {
                        monthAsNumberString = "01";
                    } else if (FORM.BMonth EQ "February") {
                        monthAsNumberString = "02";
                    } else if (FORM.BMonth EQ "March") {
                        monthAsNumberString = "03";
                    } else if (FORM.BMonth EQ "April") {
                        monthAsNumberString = "04";
                    } else if (FORM.BMonth EQ "May") {
                        monthAsNumberString = "05";
                    } else if (FORM.BMonth EQ "June") {
                        monthAsNumberString = "06";
                    } else if (FORM.BMonth EQ "July") {
                        monthAsNumberString = "07";
                    } else if (FORM.BMonth EQ "August") {
                        monthAsNumberString = "08";
                    } else if (FORM.BMonth EQ "September") {
                        monthAsNumberString = "09";
                    } else if (FORM.BMonth EQ "October") {
                        monthAsNumberString = "10";
                    } else if (FORM.BMonth EQ "November") {
                        monthAsNumberString = "11";
                    } else if (FORM.BMonth EQ "December") {
                        monthAsNumberString = "12";
                    }
                    fullDate = FORM.BYear & "-" & monthAsNumberString & "-" & FORM.BDay;
                </cfscript>
            
                <cfquery name="qGetCandidate" datasource="mysql">
                    SELECT c.candidateID 
                    FROM extra_candidates c
                    INNER JOIN smg_programs p ON p.programID = c.programID
                    WHERE c.lastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.lastname#">
                    AND c.dob = <cfqueryparam cfsqltype="cf_sql_date" value="#fullDate#">
                    AND YEAR(p.startDate) = YEAR(<cfqueryparam cfsqltype="cf_sql_date" value="#form.arrive#">)
                    LIMIT 1
                </cfquery>
                
                <cfquery datasource="mysql">
                    INSERT INTO extra_evaluation (
                        candidateID,
                        monthEvaluation,
                        checkInMemo )
                    VALUES (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.candidateID)#">,
                        0,
                        <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#vSaveContent#"> )
                </cfquery>
      
                <cfmail to="support@csb-usa.com" cc="#form.email#" from="info@csb-usa.com" subject="#form.lastname#, #form.firstname# - CSB Check-in / #form.companyName#" type="html">
                    <p style="font-family:Verdana, Geneva, sans-serif; font-size: 11px;">
                        Thank you for submitting the Check-in information. <strong>Please keep this electronic copy for your records.</strong> 
                        CSB will process the information within 48 hours (exclusive of Saturday, Sunday, and legal Holidays) and if additional 
                        information is needed, an email will be sent to the email address you have provided on your application.<br /><br />
                        
                        Summer Work Travel Program is a cultural exchange program. As a reminder, for a successful completion of the program, 
                        we encourage you to <strong>take the opportunity to familiarize yourself with important features of the American culture 
                        and/or history</strong> by engaging in your local community and travelling in your free time. <br /><br />
    
                        Please also remember to <strong>respect the rules of the program</strong> at all times. Failure to follow them will result 
                        in a program termination and you will be required to return home within 48 (forty-eight) hours.<br /><br />
    
                        If you should have any questions or you need assistance during your stay, please feel free to always <strong>contact us</strong> 
                        by emailing support@csb-usa.com or by calling our toll-free number 1-877-779-0717 (dial 0 for the operator).
                    </p>
                    
                    #vSaveContent#
                </cfmail>
    
			<!---Comments: anca--->
         		<meta http-equiv="refresh" content="4;url=http://www.csb-usa.com/SWT/">
				<table width=90% align="center" border="0" cellpadding="8">
             		<tr>
                		<td>
    <p style="font-family:Verdana, Geneva, sans-serif; font-size: 11px;"><strong> The following information was submitted from the Check-in Form on the CSB site on #dateformat(Now(), 'mm/dd/yyyy')#.</strong><br />
    Sevis##: #form.sevis#<br />
    Program ID##: #form.programID#<br />
    Last Name: #form.lastname#<br />
    First Name: #form.firstname#<br />
    Birth Date: #BMonth#/#BDay#/#BYear#<br />
    Middle Name: #form.middlename#<br />
    E-Mail Address: #form.email#<br />
    Arrival date in the U.S.: #form.arrive#<br />
    Have you arrived at your Host Employer:  #form.arriveEmployers#, 						    Arrival Date: #form.arriveHost#</p><br />

   <p style="font-family:Verdana, Geneva, sans-serif; font-size: 11px;"> <strong>Employer Information</strong><br />
    Company Name: #form.companyName#<br />
    Street Address: #form.companyAddress#<br />
    City: #form.companyCity#<br />
    State: #form.companyState#<br />
    Zip Code: #form.companyZip#<br />
    Supervisor Full Name: #form.superName#<br />
    Supervisor Phone Number: #form.companyPhone#<br />
    Supervisor Email: #form.superEmail#<br />
    Comments: #form.companyComment#</p><br />

  <p style="font-family:Verdana, Geneva, sans-serif; font-size: 11px;"><strong> Housing Information</strong><br />
    Address: #form.address#<br />
    Apt##: #form.apt#<br />
    City: #form.city#<br />
    State: #form.state#<br />
    Zip Code: #form.zip#<br />
    Phone in the U.S.: #form.phone# #form.phoneType#<br />
    Comments: #form.comment#<br /></p><br />
  
  <p style="font-family:Verdana, Geneva, sans-serif; font-size: 11px;">(#form.agreement#): Yes, I am personally submitting the Check-in information. I am also confirming that the information I have provided in the form is accurate according to my best knowledge and that I am in fact working and living at the addresses I have provided above. I also confirm that I understand that by intentionally submitting false information I will be terminated from the program.<br /><br />
(#form.agreement2#):I understand that during my program I must report any change in my housing address within 10 (ten) business days of the change.  Failure to report the changes on time will lead to a program termination.<br /><br />
(#form.agreement3#): I understand that during my program I must have permission (in writing) from CSB in order to change my primary host employer. CSB must investigate any claim before taking a decision. Failure to have permission will lead to a program termination.<br /><br />
(#form.agreement4#): I understand that during my program CSB must confirm any new, replacement and additional (second) job placements before I may start work. CSB will normally verify (vet) such jobs within 72 hours and will confirm the result in writing. Starting work at unverified and unapproved jobs will lead to a program termination.<br /><br />
(#form.agreement5#): I will maintain contact with CSB for the entire duration of the program. As required by the program regulations, I will receive a monthly evaluation request by email every 30 (thirty) days after the Check-in and I am required to respond to CSB within 10 (ten) business days.  Failure to reach back to CSB on time will lead to a program termination.</p>
   
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
<p>As a J-1 program participant, in order to work and travel legally in the United States, you must validate your program by Checking-in with CSB within 10 (ten) business days from arrival in the United States. This is an important step to ensure that your current U.S. address is accurately reflected in the Student Exchange Visitor Information System (SEVIS).  <span class="redText">Failure to Check-in on time will lead to a program termination.</span></p>
<p><strong>To be in a good standing, CSB recommends that you check-in the next day after arrival. </strong>Once you Check-in, the SEVIS system will show that your visa is current and that you are lawfully present in the United States and authorized to work. </p>
<p><strong>Please submit only accurate information. </strong>If you are not sure of the addresses, please ask and confirm the information before submitting it. Never provide information without being certain that you are in fact providing accurate and/or updated information.</p>
<ul>
    <li>Submitting inaccurate information may cause delays in updating the information in SEVIS and further, delays in the process of applying and obtaining the Social Security Number</li>
    <li>Intentionally submitting false information will lead to program termination and you will be asked to return home immediately. Such action may create legal difficulties that will affect future travel, study or work in the United States intentions  at any time in the future.</li>
</ul>

<p class="redText"><strong><u>Important: </u></strong>Please read carefully all the terms of the form before submitting it as they will also remind you of some of the crucial rules you must observe in order to be in a good standing in the program. Once submitted, your will also receive an<strong> </strong><strong>electronic copy of the form - please keep it for your records.</strong></p>
<H4> Check-in Form</H4>
<p class="text"> * Required<br>
              </p>

	<cfform action="checkin.cfm" method="post" name="form" id="form" >
     <cfoutput>
    <input name="process" type="hidden" value="1" />
     
      <table width="630" align="center">
  <tr>
    <td width="200"  class="text">SEVIS Number:</td>
    <td colspan="3" class="text">
      <input name="sevis" type="Text" class="text" id="sevis" size="40" maxlength="40" value="#form.sevis#" />
     <a href="javascript:MM_openBrWindow('images/ds-2019.jpg','ds2019','width=635,height=467')"><span id="sprytrigger2"><img src="../images/question.gif" width="15" height="15" border="0"> <span class="redText">What is this?</span></span></a></td>
  </tr>
   <tr>
    <td class="text">Program ID Number:</td>
    <td colspan="3" class="text">
      <input type="text" name="programID" value="#form.programid#" class="text" id="programID" size="40" maxlength="40" typeahead="no" showautosuggestloadingicon="true" /><span id="sprytrigger1">&nbsp;<img src="../images/question.gif" width="15" height="15" border="0"> <span class="redText">What is this?</span></span></a>    </td>
  </tr>
  <tr>
    <td class="text">Last Name: *</td>
    <td colspan="3" class="text">
      <input name="lastname" type="Text" class="text" id="lastname" size="50" maxlength="50" value="#form.lastname#" />    </td>
  </tr>
  <td colspan="2" class="redText"><span class="redItalic"><strong>Very important:</strong> Your last name must be entered <u><strong>exactly</strong></u> how it appears on your Form DS-2019 (Certificate of Eligibility for Exchange Visitor (J-1) Status).</span></td>
    </tr>
  <tr>
    <td class="text">First Name: *</td>
    <td colspan="3" class="text">
      <input name="firstname" type="Text" class="text" id="firstname" size="50" maxlength="50" value="#form.firstname#"/>    </td>
  </tr>
    
  <tr>
    <td class="text">Middle Name:&nbsp;
    </td>
    <td colspan="3" class="text">
        <input name="middlename" type="Text" class="text" id="middlename" size="50" maxlength="50" value="#form.middlename#"/></td></tr>
         <tr>
    <td class="text">Date of Birth: </td>
    <td class="text"><select name="BMonth">
<option value="">Month</option>
<option value = "January">January</option>
<option value = "February">February</option>
<option value = "March">March</option>
<option value = "April">April</option>
<option value = "May">May</option>
<option value = "June">June</option>
<option value = "July">July</option>
<option value = "August">August</option>
<option value = "September">September</option>
<option value = "October">October</option>
<option value = "November">November</option>
<option value = "December">December</option> 
</select> | <select name="BDay">
<option value="">Day</option>
<cfloop index="Day" from="1" to="31">
  <option value="#Day#">#Day#</option>
  </cfloop>
</select> | 
<select name="BYear">
<option value="">Year</option>
<cfloop index="Year" from="1980" to="#dateformat(now(),'YYYY')#">
  <option value="#Year#">#Year#</option>
  </cfloop>
</select>


</td>
</tr>
        
  <tr>
    <td class="text">Email Address: *</td>
    <td colspan="3" class="text"><input type="text" name="email" validateat="onSubmit" validate="email"class="text" id="email" size="50" maxlength="50" value="#form.email#"/></td>
  </tr>
  <tr>
    <td height="17" class="text">Arrival Date in the U.S.:  *</td>
    <td height="17" colspan="3" align="left" class="text"><cfinput type="datefield" name="arrive" size="10"></td>
  </tr>
  <tr>
    <td height="17" class="text">Have you arrived at your Host Employer:  *</td>
    <td width="418" height="17" align="left" class="text"><input type="radio" name="arriveEmployers" id="yes" value="yes" />
      <label for="YES">YES</label>&nbsp;
      <input type="radio" name="arriveEmployers" id="no" value="no" />
      <label for="NO">NO</label></td>
      </tr>
      <tr>
    <td width="200" align="left" class="text">Arrival Date at Host Employer:  *</td>
    <td width="418" align="left" class="text"><cfinput type="datefield" name="arriveHost" size="10"></td>
  </tr>
  <tr>
    <td height="17" colspan="4" class="textCenter">&nbsp;</td>
  </tr>
  
  <tr>
    <td height="17" colspan="4" bgcolor="##CCCCCC" class="textCenter">&nbsp;Employer Information:<br></td>
  </tr>
  <tr>
    <td colspan="4" align="center" class="textU">(please confirm the host company information where you work in the United States)</td>
    </tr>
    <tr>
    <td class="text">Company Name:&nbsp;*</td>
    <td colspan="3" class="text"><input name="companyName" type="Text" class="text" id="companyName" size="50" maxlength="50" value="#form.companyName#" /></td></tr>

  <tr>
    <td class="text">Street Address <em>(include street number)</em>:&nbsp;*</td>
    <td colspan="3" class="text"><input name="companyAddress" type="Text" class="text" id="companyAddress" size="50" maxlength="50" value="#form.companyAddress#"/>    </td>
  </tr>
  <tr>
    <td class="text">City :*</td>
    <td colspan="3" class="text">
      <input name="companyCity" type="Text" class="text" id="companyCity" size="50" maxlength="50" value="#form.companyCity#" />    </td>
  </tr>
  <tr>
    <td class="text">State: *</td>
    <td colspan="3" class="text">
               <select name="companyState" size="1" class="text">
              <option value="">
              <cfloop query="states">
                <option value="#state#" <Cfif form.companystate eq #state#>selected</cfif>> #statename#</option>
              </cfloop>
            </select>  </td>
  </tr>
  <tr>
    <td class="text">Zip Code: *</td>
    <td colspan="3" class="text">
      <input name="companyzip" type="Text" class="text" id="companyZip" size="50" maxlength="50" value="#form.companyZip#"/>    </td>
  </tr>

   <tr>
    <td class="text">Supervisor Full Name:&nbsp;*</td>
    <td colspan="3" class="text"><input name="superName" type="Text" class="text" id="superName" size="50" maxlength="50" value="#form.superName#"/></td></tr>
      <tr>
    <td class="text">Supervisor Phone Number:  *</td>
    <td colspan="3" class="text"><input name="companyPhone" type="Text" class="text" id="companyPhone" size="50" maxlength="50/" value="#form.companyPhone#" /></td>
  </tr>
    <tr>
    <td class="text">Supervisor Email:&nbsp;*</td>
    <td colspan="3" class="text"><input type="text" name="superEmail"  class="text" id="superEmail" size="50" maxlength="50" value="#form.superEmail#" /></td></tr>
  <tr>
    <td valign="top" class="text">Comments:</td>
    <td colspan="3" class="text">
      <textarea name="companyComment" cols="50" rows="5" wrap="VIRTUAL" class="text" value="#form.companyComment#"/></textarea>    </td>
  </tr>
  <tr>
    <td height="17" colspan="4" bgcolor="##fff" class="textCenter">&nbsp;</td>
  </tr>
  <tr>
    <td height="17" colspan="4" bgcolor="##CCCCCC" class="textCenter">&nbsp;Housing Information:<br></td>
  </tr>
  <tr>
    <td colspan="4" align="center" class="textU">(please provide the address where you currently live in the United States)</td>
    </tr>
  <tr>
    <td class="text">Street Address  <em>(include street number)</em>:&nbsp;*</td>
    <td colspan="3" class="text"><input name="address" type="Text" class="text" id="address" size="40" maxlength="40" value="#form.address#" /> 
    Apartment/ Room: ## 
      <input name="apt" type="Text" class="text" id="apt" size="10" maxlength="10" value="#form.apt#"/></td>
  </tr>
  <tr>
    <td height="25" class="text">City: *</td>
    <td colspan="3" class="text">
      <input name="city" type="Text" class="text" id="city" size="35" maxlength="50" value="#form.city#" />    </td>
  </tr>
  <tr>
    <td class="text">State: *</td>
    <td colspan="3" class="text">
    
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
    <td colspan="3" class="text">
      <input name="zip" type="Text" class="text" id="zip" size="20" maxlength="20" value="#form.zip#"/></td>
  </tr>
  <tr>
    <td class="text">Phone Number in the U.S.:</td>
    <td colspan="3" class="text"><input name="phone" type="Text" class="text" id="phone" size="25" maxlength="25" value="#form.phone#" />
      <label for="phoneType"></label>
      <label for="phoneType">Type:</label>
      <cfselect name="phoneType" class="text" id="phoneType">
      <option value="Mobile">Mobile</option>
      <option value="Employer">Employer</option>
      <option value="Friend">Friend</option>
      <option value="Other">Other</option>
      </cfselect></td>
  </tr>
  <tr>
    <td valign="top" class="text">Comments:</td>
    <td colspan="3" class="text">
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
    <td colspan="3" class="text"><p class="textItalic">Yes, I am personally submitting the Check-in information. I am also confirming that the information I have provided in the form is accurate according to my best knowledge and that I am in fact working and living at the addresses I have provided above. I also confirm that I understand that by intentionally submitting false information I will be terminated from the program. </p></td>
  </tr>
     <tr bgcolor="##EDEDED">
    <td align="right" valign="center" class="text">
    <table width="100%" border="0">
  <tr>
    <td width="77%">&nbsp;</td>
    <td width="23%"><input type="checkbox" name="agreement2" id="agreement2"/></td>
  </tr>
</table></td>
    <td colspan="3" class="text"><p class="textItalic">I understand that during my program I must report any change in my housing address within 10 (ten) business days of the change. &nbsp;Failure to report the changes on time will lead to a program termination.</p></td>
  </tr>
     <tr bgcolor="##EDEDED">
    <td align="right" valign="center" class="text">
    <table width="100%" border="0">
  <tr>
    <td width="77%">&nbsp;</td>
    <td width="23%"><input type="checkbox" name="agreement3" id="agreement3"/></td>
  </tr>
</table></td>
    <td colspan="3" class="text"><p class="textItalic">I understand that during my program I must have permission (in writing) from CSB in order to change my primary host employer. CSB must investigate any claim before taking a decision. Failure to have permission will lead to a program termination.</p></td>
  </tr>
     <tr bgcolor="##EDEDED">
    <td align="right" valign="center" class="text">
    <table width="100%" border="0">
  <tr>
    <td width="77%">&nbsp;</td>
    <td width="23%"><input type="checkbox" name="agreement4" id="agreement4"/></td>
  </tr>
</table></td>
    <td colspan="3" class="text"><p class="textItalic">I understand that during my program CSB must confirm any new, replacement and additional (second) job placements before I may start work. CSB will normally verify (vet) such jobs within 72 hours and will confirm the result in writing. Starting work at unverified and unapproved jobs will lead to a program termination. </p></td>
  </tr>
      <tr bgcolor="##EDEDED">
    <td align="right" valign="center" class="text">
    <table width="100%" border="0">
  <tr>
    <td width="77%">&nbsp;</td>
    <td width="23%"><input type="checkbox" name="agreement5" id="agreement5"/></td>
  </tr>
</table></td>
    <td colspan="3" class="text"><p class="textItalic">I will maintain contact with CSB for the entire duration of the program. As&nbsp;required by the program regulations,&nbsp;I will receive a monthly evaluation request by email every 30 (thirty) days after the Check-in and I am required to respond to CSB within 10 (ten) business days. &nbsp;Failure to reach back to CSB on time will lead to a program termination.</p></td>
  </tr>
  <tr>
    <td colspan="4" align="center" bgcolor="##CCCCCC" class="textCenter">
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
