
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
    <cfparam name="form.Q6file" default="">
    <cfparam name="form.Q7" default="">
    <cfparam name="form.Q7_explain" default="">
    <cfparam name="form.Q7file" default="">
    <cfparam name="form.Q8" default="">
    <cfparam name="form.Q8_explain" default="">
    <cfparam name="form.Q9_explain" default="">
    <cfparam name="form.sendFile" default=0>
    <cfparam name="q6filename" default="">
    <cfparam name="q7filename" default="">
    
    <cfparam name="URL.uniqueID" default="">
    <cfparam name="URL.evaluation" default="">
    <cfparam name="FORM.evaluation" default="">
    
    <cfif URL.uniqueID NEQ "">
        
        <cfquery name="qGetCandidateInfo" datasource="MySql">
            SELECT
                lastName,
                firstName,
                email,
                ds2019
            FROM
                extra_candidates
            WHERE
                uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(URL.uniqueID)#">
        </cfquery>
        
        <cfscript>
            FORM.lastName = qGetCandidateInfo.lastName;
            FORM.firstName = qGetCandidateInfo.firstName;
            FORM.email = qGetCandidateInfo.email;
            FORM.sevis = TRIM(qGetCandidateInfo.ds2019);
			FORM.evaluation = URL.evaluation;
        </cfscript>
        
    </cfif>

</Cfsilent>

<!----error checking on a submit---->
<!----First check to see if its being submitted---->
<Cfif val(form.sendFile)>

	<cfif not isValid("email", FORM.email)>
		<cfscript>
			if ( 1 eq 1 ) {
			// Get all the missing items in a list
			SESSION.formErrors.Add("Your email address does not appear to be valid.");
			}	
		</cfscript>
	</cfif>
        
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
			SESSION.formErrors.Add("Please answer the Yes/No question: Housing address - Have you changed your housing address since your last report to CSB?");
		}
		// Q5 Expalin if Yes
		if ( q5 eq 'yes' and NOT LEN(TRIM(FORM.q5_explain) ) ) {
			// Get all the missing items in a list
			SESSION.formErrors.Add("You  answered Yes to: Housing address - Have you changed your housing address since your last report to CSB?, but did not provide your new address.");
		}
		// Q6
		if ( NOT LEN(TRIM(FORM.q6)) ) {
			// Get all the missing items in a list
			SESSION.formErrors.Add("Please answer the Yes/No question: Main employer - Have you changed your main employer since your last report to CSB?");
		}
		// Q6 Expalin if Yes
		if ( q6 eq 'yes' and NOT LEN(TRIM(FORM.q6_explain) ) ) {
			// Get all the missing items in a list
			SESSION.formErrors.Add("You answered Yes to: Have you changed your main employer since your last report to CSB?, but you did not provide your new employer's information.");
		}
		// Q7
		if ( NOT LEN(TRIM(FORM.q7)) ) {
			// Get all the missing items in a list
			SESSION.formErrors.Add("Please answer the Yes/No question: Second job - Do you currently have a second job?");
		}
		// Q7 Expalin if Yes
		if ( q7 eq 'yes' and NOT LEN(TRIM(FORM.q7_explain) ) ) {
			// Get all the missing items in a list
			SESSION.formErrors.Add("You  answered Yes to: Second job - Do you currently have a second job? but did not provide any details.  Please let us know your concerns.");
		}
		// Q8
		if ( NOT LEN(TRIM(FORM.q8)) ) {
			// Get all the missing items in a list
			SESSION.formErrors.Add("Please answer the Yes/No question: Do you have any current problems or concerns?");
		}
		// Q8 Explain if Yes
		if ( q8 eq 'yes' and NOT LEN(TRIM(FORM.q8_explain) ) ) {
			// Get all the missing items in a list
			SESSION.formErrors.Add("You answered Yes to: Do you have any current problems or concerns? but did not provide any details. Please let us know your concerns.");
		}
		// Q9 Explain if Yes
		 if ( NOT LEN(TRIM(FORM.q9_explain)) )  {
			// Get all the missing items in a list
			SESSION.formErrors.Add("Please list some of the cultural activities you have experienced while being in the U.S.");
		}
			
	</cfscript>

	<!--- Check if there are no errors --->
    <cfif NOT SESSION.formErrors.length()>
        
		<Cfif val(FORM.sendFile)>
		
			<!-----Upload Files so we can attach them---->
            <cfif Len(FORM.Q6file)>
                <cffile action="upload" destination="C:\websites\csb-usa\uploadedfiles\" filefield="Q6file" nameconflict="overwrite" />
                <cffile action="rename" source="C:\websites\csb-usa\uploadedfiles\#file.ServerFile#" destination="C:\websites\csb-usa\uploadedfiles\Question6.#file.ClientFileExt#"attributes="normal">
            	<Cfset q6filename = 'Question6.#file.ClientFileExt#'>
        	</cfif>
       		<cfif Len(FORM.Q7file)>
                <cffile action="upload" destination="C:\websites\csb-usa\uploadedfiles\" filefield="Q7file" nameconflict="overwrite"/>
                <cffile action="rename" source="C:\websites\csb-usa\uploadedfiles\#file.ServerFile#" destination="C:\websites\csb-usa\uploadedfiles\Question7.#file.ClientFileExt#"attributes="normal">
                <cfset q7filename = 'Question7.#file.ClientFileExt#'>
        	</cfif>
 
            <cfquery name="qGetStudent" datasource="MySql">
                SELECT
                    *
                FROM
                    extra_candidates
            </cfquery>
            
            <cfscript>
				
				vEmailContent = '<h3> CSB - Mandatory Evaluation #FORM.evaluation# - #dateformat(Now(),'mm/dd/yyyy')#.</h3>
					<p style="font-size: 11px; font-family:Arial, Helvetica, sans-serif;"> 
					1. SEVIS Number:<strong> #form.Sevis#</strong> <br /> 
					2. Last name:<strong> #form.LastName#</strong><br /> 
					3. First name:<strong> #form.FirstName#</strong><br /> 
					4. Email:<strong> #form.email#</strong><br /> <br /> 
					5. Have you changed your housing address since your last report to CSB?<strong> #form.Q5#</strong><br />
					&nbsp;&nbsp;<i>If Yes and you did not previously inform CSB, please provide your full new housing address:</i><strong> #form.Q5_explain#</strong><br /><br /> 
					
					6. Main employer - Have you changed your main employer since your last report to CSB?<strong> #form.Q6#</strong><br /> 
					&nbsp;&nbsp;<i>If Yes and you did not previously inform CSB, please provide your full new employer information (name, address and phone number) and a new signed job offer for verification:</i><strong> #form.Q6_explain# </strong>
					<br />#q6filename#<br /> <br /> 
					
					7. Second job - Do you currently have a second job?<strong> #form.Q7#</strong><br />#q7filename#<br /> 
					&nbsp;&nbsp;<i>If Yes, please list and provide full details (where/what/who/why):</i><strong> #form.Q7_explain# </strong><br /><br /> 
					 8. Do you have any current problems or concerns?<strong> #form.Q8#</strong><br /> 
					&nbsp;&nbsp;<i>If Yes, please provide full details (where, when, what, who, why):</i><strong> #form.Q8_explain# </strong><br /><br />
					9. Cultural activities <strong> #form.Q9_explain# </strong><br /><br /></p>
					--';
				
				email=CreateObject("component","cfc.email");
			
				email.send_mail(
					email_from='CSB Summer Work Travel<support@csb-usa.com>',
					email_to='support@iseusa.com',
					email_subject=FORM.LastName & ', ' & FORM.FirstName & ' - CSB Monthly Evaluation ' & FORM.evaluation,
					email_cc=FORM.email,
					email_message=vEmailContent
					);												
			
			</cfscript>
      
      		<meta http-equiv="refresh" content="2;url=http://www.csb-usa.com/SWT/">
          		<div class="yellow" style="background-color: #CCC; font-size: 11px; padding: 20px; font-family:Arial, Helvetica, sans-serif; width: 800px;">
      				<h3>The following information has been successfully submitted to CSB Summer Work and Travel from the CSB - Mandatory Summer Work Travel Questionnaire.</h3>
					<cfoutput>
               			<table width=90% align="center">
                      		<tr>
                            	<td class="text">
            						<p style="font-size: 11px; font-family:Arial, Helvetica, sans-serif;">1. SEVIS Number:<strong> #form.Sevis#</strong> <br /> 
                                    2. Last name:<strong> #form.LastName#</strong><br /> 
                                    3. First name:<strong> #form.FirstName#</strong><br /> 
                                    4. Email:<strong> #form.email#</strong><br /> <br /> 
                                    5. Housing address - Have you changed your housing address since your last report to CSB?<strong> #form.Q5#</strong><br />
                                    &nbsp;&nbsp;<i>If Yes and you did not previously inform CSB, please provide your full new housing address:</i><strong> #form.Q5_explain#</strong><br /><br /> 
                                    6. Main employer - Have you changed your main employer since your last report to CSB?<strong> #form.Q6#</strong><br /> 
                                    &nbsp;&nbsp;<i>If Yes and you did not previously inform CSB, please provide your full new employer information (name, address and phone number) and a new signed job offer for verification:</i><strong> #form.Q6_explain#</strong><br />#form.Q6file#<br /> <br /> 
                               		7. Second job - Do you currently have a second job?<strong> #form.Q7#</strong><br />#form.Q7file#<br /> 
                                    &nbsp;&nbsp;<i>If Yes, please list and provide full details (where/what/who/why):</i><strong> #form.Q7_explain# </strong><br /><br />
                              		8. Do you have any current problems or concerns?<strong> #form.Q8#</strong><br /> 
                                    &nbsp;&nbsp;<i>If Yes, please provide full details (where, when, what, who, why):</i><strong> #form.Q8_explain# </strong><br /><br />
                                    9. Cultural activities <strong> #form.Q9_explain# </strong><br /><br /></p>
                              	</td>
                        	</tr>
                  		</table>
                	</cfoutput>
              	</div>
      			<cfabort>
		
		</cfif>           
        
	</cfif>
		 
</cfif>


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
	font-family: Arial, Helvetica, sans-serif;
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
	padding-top: 8px;
	padding-bottom: 5px;
	margin-bottom: 5px;
	padding-left: 5px;
}
body {
	margin: 0px;
	padding: 0px;
}
.wrapper {
	margin-right: auto;
	margin-left: auto;
	width: 700px;
	border: thin solid #999;
	padding: 5px;
}
.grey {
	background-color: #FFF;
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
	font-family: Arial, Helvetica, sans-serif;
	font-size: 18px;
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
	font-family: Arial, Helvetica, sans-serif;
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
	padding-top: 5px;
	padding-right: 10px;
	padding-bottom: 5px;
	padding-left: 10px;
}
.info p {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	padding: 0px;
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

<div class="header">CSB Summer Work Travel Program &#8211; <u>Mandatory</u> Monthly Evaluation Form</div>
<div class="info"><p>The monthly evaluation form for your program is below &#8211; there are 9 (nine) questions that require your answer. You must <strong><u>answer in full</u></strong> within 10
(ten) days of receiving the evaluation notification.<br /><br />
<strong>Note: <span class="red">Failure to respond in a timely manner may result in program termination. It is very important that you respond.</span></strong><span class="red"></span></p>
</div>

<div class="grey">
<Cfoutput>
<cfform action="index.cfm" method="post" name="form" id="form" enctype="multipart/form-data">
	<input type="hidden" name="sendFile" value="1" />
    <input type="hidden" name="evaluation" id="evaluation" value="#FORM.evaluation#" />
  <table width="665" border="0" cellspacing="0" cellpadding="5">
  <tr bgcolor="##EFEFEF" >
    <td width="132" bgcolor="##EFEFEF" class="Bold">1. SEVIS Number:</td>
    <td width="418">
      <label for="Sevis"></label>
      <input type="text" name="Sevis" id="Sevis" value="#form.Sevis#" />
    </td>
  </tr>
  <tr>
    <td class="Bold">2. Last Name:</td>
    <td><label for="Sevis"></label>
      <input type="text" name="LastName" id="LastName"  value="#form.LastName#"/></td>
  </tr>
  <tr bgcolor="##EFEFEF" >
    <td class="Bold">3. First Name:</td>
    <td><label for="Sevis"></label>
      <input type="text" name="FirstName" id="FirstName"  value="#form.FirstName#"/></td>
  </tr>
    <tr>
    <td class="Bold">4. E-mail:</td>
    <td><label for="Sevis"></label>
      <input type="text" name="email" id="email" value="#form.email#" /></td>
  </tr>
  <tr bgcolor="##EFEFEF" >
    <td colspan="2" bgcolor="##EFEFEF" class="Bold">
    5. Housing address - Have you changed your housing address since your last report to CSB?
    <table width="625" border="0" cellspacing="5"> 
  <tr valign="middle">
    <td width="90" align="left">
    	<input type="radio" name="Q5" id="Q5" value="No" <Cfif form.q5 is 'no'>checked</cfif>  />
        <label for="NO" class="Bold">NO</label></td>
    <td width="516"></td>
  </tr>
  <tr valign="top">
    <td align="left"><input type="radio" name="Q5" id="Q5" value="YES" <cfif form.q5 is 'yes'>checked</cfif> />
      	<label for="YES" class="Bold">YES</label></td>
    <td align="left">If Yes and you did not previously inform CSB, please provide your new housing address (street and number, city, state, zip code).<br />
      
      <strong><u>Remember:</u></strong> you must report any change related to the housing address within 10 (ten) business days.</td>
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
 <td colspan="2" class="Bold">
    6. Main employer - Have you changed your main employer since your last report to CSB?
      <table width="625" border="0" cellspacing="5">
        <tr valign="middle">
    <td><input type="radio" name="Q6" id="Q6" value="No" <cfif form.Q6 is 'No'>checked</cfif> />
      <label for="NO" class="Bold">NO</label></td>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr valign="top">
    <td width="87"><input type="radio" name="Q6" id="Q6" value="Yes" <cfif form.Q6 is 'Yes'>checked</cfif> />
      <label for="YES" class="Bold">YES</label></td>
    <td colspan="2">If Yes and you did not previously inform CSB, please provide your new employer information (name of company, address, phone number, supervisor)and attach the signed job offer. If you don't have the job offer form, please contact CSB.<br />
<strong><u>Remember:</u></strong> CSB must confirm/approve the new job before you start work. If you start work in an unverified job, your program will be terminated.</td>
  </tr>
  <tr>
    <td valign="middle"> If YES, Explain</td>
    <td width="519"><label for="Q6_explain"></label>
      <textarea name="Q6_explain" id="Q6_explain" cols="45" rows="5">#form.Q6_explain#</textarea></td>
 
  </tr>
    <tr>
    <td valign="middle">&nbsp;</td>
    <td colspan="2"><cfinput type="file" name="Q6file" size= "20"></td>
    </tr>
</table>
</td>
  </tr>
  <tr bgcolor="##EFEFEF" >
    <td colspan="2" class="Bold">
    7. Second job - Do you currently have a second job?
      <table width="625" border="0" cellspacing="5">
       <tr valign="middle">
    <td><input type="radio" name="Q7" id="Q7" value="No" <cfif form.Q7 is 'No'>checked</cfif>  />
      <label for="NO" class="Bold">NO</label></td>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr valign="top">
    <td width="87"><input type="radio" name="Q7" id="Q7" value="Yes" <cfif form.Q7 is 'Yes'>checked</cfif>  />
      <label for="YES" class="Bold">YES</label></td>
    <td colspan="2">If Yes and you did not previously inform CSB, please provide your second employer information (name of company, address, phone number, supervisor) and attach the job offer. If you don't have the job offer form, please contact CSB.<br />
<strong><u>Remember:</u></strong> CSB must confirm/approve the second job before you start work. If you starting work in an unverified job, your program will be terminated.</td>
  </tr>

  <tr>
    <td valign="middle"> If YES, Explain</td>
    <td width="519">
  
    <label for="Q7_explain"></label>
      <textarea name="Q7_explain" id="Q7_explain" cols="45" rows="5">#form.Q7_explain#</textarea></td>
  </tr>
    <tr>
    <td valign="middle">&nbsp;</td>
    <td colspan="2"><cfinput type="file" name="Q7file" size= "20"><br />
<!---<Cfif isDefined('FORM.sendFile')>
<cfoutput>
	<p>Success!<br />
     The file #form.file# was successfully sent.   If you need to send another file, just attach the new file below.</p>
</cfoutput>
<Cfelse>
	<p>Please attach the job offer Form.</p>
</Cfif>---></td>
    </tr>
</table>
</td>
  </tr>
  
     <tr>
    <td colspan="2" class="Bold">
    8. Do you have any current problems or concerns?
      <table width="625" border="0" cellspacing="5">
       <tr valign="middle">
    <td><input type="radio" name="Q8" id="Q8" value="No" <cfif form.Q8 is 'No'>checked</cfif>  />
      <label for="NO" class="Bold">NO</label></td>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr valign="top">
    <td width="88"><input type="radio" name="Q8" id="Q8" value="Yes" <cfif form.Q8 is 'Yes'>checked</cfif>  />
      <label for="YES" class="Bold">YES</label></td>
    <td colspan="2">If Yes, please provide full details (where, when, what, who, why).</td>
  </tr>

  <tr>
    <td valign="middle">&nbsp;</td>
    <td width="518"><label for="Q8_explain"></label>
      <textarea name="Q8_explain" id="Q8_explain" cols="45" rows="5">#form.Q8_explain#</textarea></td>
    
      
  </tr>
</table>

</td>
  </tr>
   <tr bgcolor="##EFEFEF" >
    <td colspan="2" class="Bold">
    9. Cultural activities -
      <table width="625" border="0" cellspacing="5">
      <td colspan="2"><p>As you know, the US Department of States has included the cultural activities as an <strong><u>obligatory</u></strong> part of your program. Please share the ways you are familiarizing with the American culture and/or history in your free time. This can include group trips (visit museums, historical sites), sporting events (attend American football, baseball games), entertainment shows (see concerts, theater), points of interest nearby your location (visit parks, museums, local attractions), sightseeing (visit major cities), local activities (attend fair/ farmer's market, holiday barbecue, 4th of July parade), etc.</p>

 

<p><strong>Please include brief details below</strong> (date, where, what type of event). If you did not have any cultural activity, please write so.</p>

<p><em>(Examples on how to respond: On May 21, I visited Washington, D.C. with my friends; on July 19, I attended a baseball game - Yankees vs. Red Sox, etc).</em></p></td>
  </tr>

  <tr>
    <td width="89" valign="middle">&nbsp;</td>
    <td width="517"><label for="Q9_explain"></label>
      <textarea name="Q9_explain" id="Q9_explain" cols="45" rows="5">#form.Q9_explain#</textarea></td>
    
      
  </tr>
</table>
</td>
  </tr>
  
  <tr align="center">
    <td colspan="2"><input type="submit" name="submit" id="submit" value="Submit" /></td>
    </tr>
</table>
</cfform>
</Cfoutput>

</div>
<div class="footer">
For more information please contact us at<br />
    1-877-669-0717&nbsp;&nbsp;|&nbsp;&nbsp;<a href="mailto:support@csb-usa.com" shape="rect" target="_blank">support@csb-usa.com</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a shape="rect" href="http://www.csb-usa.com" target="_blank">www.csb-usa.com</a>
</div>

</div>
</body>
</html>
