
<Cfsilent>
<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

<!----Initialize variables---->
<Cfparam name=url.request default=''>
<cfparam name="form.sevis" default="">       
<cfparam name="form.LastName" default="">
<cfparam name="form.FirstName" default="">
<cfparam name="form.email" default="">
<cfparam name="form.Q5" default="">
<cfparam name="form.Q5_explain" default="">
<cfparam name="form.Q6" default="">
<cfparam name="form.Q6_explain" default="">
<cfparam name="form.Q7" default="">
<cfparam name="form.Q7_explain" default="">
<cfparam name="form.send" default=0>
</Cfsilent>
<!----error checking on a submit---->
<!----First check to see if its being submitted---->
<Cfif val(form.send)>

		<Cfif not isValid("email", FORM.email)>
          <cfscript>
        	  if ( 1 eq 1 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Your email address does not appear to be valid.");
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
        	
			// Last Name
            if ( NOT LEN(TRIM(FORM.LastName)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your Last Name.");
            }

			// First Name
            if ( NOT LEN(TRIM(FORM.FirstName)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your First Name.");
            }

			// Email
            if ( NOT LEN(TRIM(FORM.email)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your email address.");
            }
			
			// Q5
            if ( NOT LEN(TRIM(FORM.q5)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please answer the Yes/No question: Have you changed your housing address since your last report to CSB?");
            }

			// Q5 Expalin if Yes
            if ( q5 eq 'yes' and NOT LEN(TRIM(FORM.q5_explain) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You  answered Yes to: Have you changed your housing address since your last report to CSB, but did not provide your new address.");
            }

			

			
			// Q6
            if ( NOT LEN(TRIM(FORM.q6)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please answer the Yes/No question: Have you changed your employer since your last report to CSB?");
            }
			
			// Q6 Expalin if Yes
            if ( q6 eq 'yes' and NOT LEN(TRIM(FORM.q6_explain) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You answered Yes to: Have you changed your employer since your last report to CSB, but did not provide your new employer information.");
            }

			
			// Q7
            if ( NOT LEN(TRIM(FORM.q7)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please answer the Yes/No question: Do you have any current problems or concerns??");
            }
			
			// Q7 Expalin if Yes
            if ( q7 eq 'yes' and NOT LEN(TRIM(FORM.q7_explain) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You  answered Yes to: Do you have any current problems or concerns? but did not provide any details.  Please let us know your concerns.");
            }
		</cfscript>
        
        <!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
        
        
      
                <cfmail to="jeimi@exitgroup.org,anca@csb-usa.com,josh@pokytrails.com" from="info@csb-usa.com" subject="CSB Mandatory Summer Work Travel Questionnaire" type="html">
            
               <h3> CSB - Mandatory Summer Work Travel Questionnaire  - #dateformat(Now())#.</h3>
                
                1. SEVIS Number:<strong> #form.Sevis#</strong> <br /> 
                2. Last name:<strong> #form.LastName#</strong><br /> 
                3. First name:<strong> #form.FirstName#</strong><br /> 
                4. Email:<strong> #form.email#</strong><br /> <br /> 
                5. Have you changed your housing address since your last report to CSB?<strong> #form.Q5#</strong><br />
                &nbsp;&nbsp;<i>If Yes and you did not previously inform CSB, please provide your full new housing address:</i><strong> #form.Q5_explain#</strong><br /><br /> 
                
                6. Have you changed your employer since your last report to CSB?<strong> #form.Q5#</strong><br /> 
                &nbsp;&nbsp;<i>If Yes and you did not previously inform CSB, please provide your full new employer information (name, address and phone number) and a new signed job offer for verification:</i><strong> #form.Q6_explain#</strong><br /> <br /> 
                
                7. Do you have any current problems or concerns?<strong> #form.Q7#</strong><br /> 
                &nbsp;&nbsp;<i>If Yes, please list and provide full details (where/what/who/why):</i><strong> #form.Q7_explain# </strong><br /><br /> 
            --
                </cfmail>
                <div class="yellow">
                 <h3>The following information has been succesfully submitted to CSB Summer Work and Travel from the CSB - Mandatory Summer Work Travel Questionnaire.</h3><cfoutput>
                              <table width=90% align="center">
                      <tr>
                            <td class="text">
            <p>1. SEVIS Number:<strong> #form.Sevis#</strong> <br /> 
                2. Last name:<strong> #form.LastName#</strong><br /> 
                3. First name:<strong> #form.FirstName#</strong><br /> 
                4. Email:<strong> #form.email#</strong><br /> <br /> 
                5. Have you changed your housing address since your last report to CSB?<strong> #form.Q5#</strong><br />
                &nbsp;&nbsp;<i>If Yes and you did not previously inform CSB, please provide your full new housing address:</i><strong> #form.Q5_explain#</strong><br /><br /> 
                
                6. Have you changed your employer since your last report to CSB?<strong> #form.Q5#</strong><br /> 
                &nbsp;&nbsp;<i>If Yes and you did not previously inform CSB, please provide your full new employer information (name, address and phone number) and a new signed job offer for verification:</i><strong> #form.Q6_explain#</strong><br /> <br /> 
                
                7. Do you have any current problems or concerns?<strong> #form.Q7#</strong><br /> 
                &nbsp;&nbsp;<i>If Yes, please list and provide full details (where/what/who/why):</i><strong> #form.Q7_explain# </strong><br /><br /> </p></td>
                        </tr>
                  </table></div>
                </cfoutput>
                <cfabort>
                 
        
        </cfif>
		 
</Cfif>


<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		  <tr>
		    <td width="5%">&nbsp;</td>
		    <td width="90%" class="text">

	
  
 
 


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>CSB - Mandatory Summer Work Travel Questionnaire</title>
<link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css">
<style type="text/css">
.wHeader {
	font-family: Georgia, "Times New Roman", Times, serif;
	font-size: 16px;
	font-weight: bold;
	color: #FFF;
	text-align: center;
	padding-top: 10px;
	padding-bottom: 10px;
}
body table  {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	color: #000;
}
.red {
	color: #C00;
}
.Bold {
	font-weight: bold;
	font-size: 13px;
}
.wrapper {
	margin-right: auto;
	margin-left: auto;
	width: 600px;
	border: thin solid #999;
	padding: 5px;
}
.grey {
	background-color: #f4f4f4;
	padding: 10px;
}
.yellow {
	background-color: #FF9;
	padding: 20px;
	width: 580px;
	margin-right: auto;
	margin-left: auto;
}
.header {
	background-color: #374c87;
	font-family: Georgia, "Times New Roman", Times, serif;
	font-size: 20px;
	font-weight: bold;
	color: #FFF;
	text-align: center;
	padding-top: 20px;
	padding-right: 10px;
	padding-bottom: 20px;
	padding-left: 10px;
}
.footer {
	background-color: #374c87;
	font-family: Georgia, "Times New Roman", Times, serif;
	font-size: 12px;
	font-weight: bold;
	color: #FFF;
	text-align: center;
	padding-top: 10px;
	padding-right: 5px;
	padding-bottom: 10px;
	padding-left: 5px;
}
.info {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	padding-top: 15px;
	padding-right: 10px;
	padding-bottom: 15px;
	padding-left: 10px;
}
a:link {
	color: #FF0;
	text-decoration: none;
}
a:visited {
	text-decoration: none;
	color: #FF0;
}
a:hover {
	text-decoration: none;
	color: #FFF;
}
a:active {
	text-decoration: none;
	color: #FF0;
}

</style>

</head>

<body>

<div class="wrapper">
	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />

<div class="header">CSB - Mandatory Summer Work Travel Questionnaire</div>
<div class="info"> <span class="red"><strong>The CSB  monthly questionnaire  is below</strong></span><strong> - there are 7 (seven) questions you must  answer. <span class="red">You must  respond in full within 10 (ten) business days</span> of  receiving this  questionnaire.</strong>
</div>
<div class="grey">
<Cfoutput>
<cfform action="index.cfm" method="post" name="form" id="form">
	<input type="hidden" name="send" value="1"/>
  <table width="560" border="0" cellspacing="0" cellpadding="5">
  <tr>
    <td width="132" class="Bold">1. SEVIS Number:</td>
    <td width="418">
      <label for="Sevis"></label>
      <input type="text" name="Sevis" id="Sevis" value="#form.Sevis#" />
    </td>
  </tr>
  <tr >
    <td class="Bold">2. Last Name:</td>
    <td><label for="Sevis"></label>
      <input type="text" name="LastName" id="LastName"  value="#form.LastName#"/></td>
  </tr>
  <tr>
    <td class="Bold">3. First Name:</td>
    <td><label for="Sevis"></label>
      <input type="text" name="FirstName" id="FirstName"  value="#form.FirstName#"/></td>
  </tr>
   <tr>
    <td class="Bold">4. E-mail:</td>
    <td><label for="Sevis"></label>
      <input type="text" name="email" id="email" value="#form.email#" /></td>
  </tr>
  <tr>
    <td colspan="2" class="Bold"><hr />
    5. Have you changed your housing address since your last report to CSB?
    <table width="560" border="0" cellspacing="0"> 
  <tr valign="top">
    <td width="75" align="left">
    	<input type="radio" name="Q5" id="Q5" value="YES" value="Yes" <Cfif form.q5 is 'yes'>checked</cfif> />
      	<label for="YES" class="Bold">YES</label></td>
    <td width="456">If Yes and you did not previously inform CSB, please provide your full new housing address.</td>
  </tr>
  <tr valign="middle">
    <td align="left">
    	<input type="radio" name="Q5" id="Q5" value="No" <Cfif form.q5 is 'no'>checked</cfif>  />
        <label for="NO" class="Bold">NO</label></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td valign="middle"> If YES, Explain</td>
    <td><label for="Q5_explain"></label>
      <textarea name="Q5_explain" id="Q5_explain" cols="45" rows="5" >#form.Q5_explain#</textarea></td>
  </tr>
</table>
</td>
  </tr>
  <tr>
     <td colspan="2" class="Bold"><hr />
    6. Have you changed your employer since your last report to CSB?
      <table width="560" border="0" cellspacing="0">
  <tr valign="top">
    <td width="75"><input type="radio" name="Q6" id="Q6" value="Yes" <cfif form.Q6 is 'Yes'>checked</cfif> />
      <label for="YES" class="Bold">YES</label></td>
    <td width="456">If Yes and you did not previously inform CSB, please provide your full new employer information (name, address and phone number) and a new signed job offer for verification.</td>
  </tr>
  <tr valign="middle">
    <td><input type="radio" name="Q6" id="Q6" value="No" <cfif form.Q6 is 'No'>checked</cfif> />
      <label for="NO" class="Bold">NO</label></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td valign="middle"> If YES, Explain</td>
    <td><label for="Q6_explain"></label>
      <textarea name="Q6_explain" id="Q6_explain" cols="45" rows="5">#form.Q6_explain#</textarea></td>
  </tr>
</table>
</td>
  </tr>
  <tr>
    <td colspan="2" class="Bold"><hr />
    7. Do you have any current problems or concerns?
      <table width="560" border="0" cellspacing="0">
  <tr valign="top">
    <td width="75"><input type="radio" name="Q7" id="Q7" value="Yes" <cfif form.Q7 is 'Yes'>checked</cfif>  />
      <label for="YES" class="Bold">YES</label></td>
    <td width="456">If Yes, please list and provide full details (where/what/who/why).</td>
  </tr>
  <tr valign="middle">
    <td><input type="radio" name="Q7" id="Q7" value="No" <cfif form.Q7 is 'No'>checked</cfif>  />
      <label for="NO" class="Bold">NO</label></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td valign="middle"> If YES, Explain</td>
    <td><label for="Q7_explain"></label>
      <textarea name="Q7_explain" id="Q7_explain" cols="45" rows="5">#form.Q7_explain#</textarea></td>
      
  </tr>
</table>
<hr />
</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td align="center" valign="middle"><input type="submit" name="submit" id="submit" value="Submit" /></td>
  </tr>
</table>
</cfform>
</Cfoutput>
</div>
<div class="info"> <span class="red"><strong>NOTE:<i> Failure to respond in a timely manner may result in program termination. It is very important that you respond.</i></strong></span></div>
<div class="footer">
For more information please contact us at<br />
    1-877-669-0717&nbsp;&nbsp;|&nbsp;&nbsp;<a href="mailto:info@csb-usa.com" shape="rect" target="_blank">info@csb-usa.com</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a shape="rect" href="http://www.csb-usa.com" target="_blank">www.csb-usa.com</a>
</div>

</div>
</body>
</html>
