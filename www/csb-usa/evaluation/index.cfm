
<Cfsilent>

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
    <!----Initialize variables---->
    <Cfparam name="url.request" default=''>
    <cfparam name="FORM.candidateID" default="0">
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.sevis" default="">       
    <cfparam name="FORM.LastName" default="">
    <cfparam name="FORM.FirstName" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="FORM.Q5" default="">
    <cfparam name="FORM.Q5_explain" default="">
    <cfparam name="FORM.Q6" default="">
    <cfparam name="FORM.Q6_explain" default="">
    <cfparam name="FORM.Q6file" default="">
    <cfparam name="FORM.Q7" default="">
    <cfparam name="FORM.Q7_explain" default="">
    <cfparam name="FORM.Q7file" default="">
    <cfparam name="FORM.Q8" default="">
    <cfparam name="FORM.Q8_explain" default="">
    <cfparam name="FORM.Q9_explain" default="">
    <cfparam name="FORM.q6filename" default="">
    <cfparam name="FORM.q7filename" default="">
	<cfparam name="FORM.evaluation" default="">
    <cfparam name="FORM.pic1file" default="">
    <cfparam name="FORM.pic2file" default="">
    <cfparam name="FORM.pic3file" default="">
    
    <cfparam name="URL.uniqueID" default="">
    <cfparam name="URL.evaluation" default="">
    
    <cfif LEN(URL.uniqueID)>
        
        <cfquery name="qGetCandidateInfo" datasource="MySql">
            SELECT
            	candidateID,
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
			FORM.candidateID = qGetCandidateInfo.candidateID;
        </cfscript>
        
    </cfif>

</Cfsilent>

<!----error checking on a submit---->
<!----First check to see if its being submitted---->
<Cfif val(FORM.submitted)>

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

		if ( LEN(TRIM(FORM.email)) AND NOT isValid("email", TRIM(FORM.email)) ) {
			// Get all the missing items in a list
			SESSION.formErrors.Add("Your email address does not appear to be valid.");
		}	
		
		// Q5
		if ( NOT LEN(TRIM(FORM.q5)) ) {
			// Get all the missing items in a list
			SESSION.formErrors.Add("Please answer the Yes/No question: Housing address - Have you changed your housing address since your last report to CSB?");
		}
		
		// Q5 Expalin if Yes
		if ( FORM.q5 EQ 'yes' AND NOT LEN(TRIM(FORM.q5_explain) ) ) {
			// Get all the missing items in a list
			SESSION.formErrors.Add("You answered Yes to: Housing address - Have you changed your housing address since your last report to CSB?, but did not provide your new address.");
		}
		
		// Q6
		if ( NOT LEN(TRIM(FORM.q6)) ) {
			// Get all the missing items in a list
			SESSION.formErrors.Add("Please answer the Yes/No question: Main employer - Have you changed your main employer since your last report to CSB?");
		}
		
		// Q6 Expalin if Yes
		if ( FORM.q6 EQ 'yes' and NOT LEN(TRIM(FORM.q6_explain) ) ) {
			// Get all the missing items in a list
			SESSION.formErrors.Add("You answered Yes to: Have you changed your main employer since your last report to CSB?, but you did not provide your new employer's information.");
		}
		
		// Q7
		if ( NOT LEN(TRIM(FORM.q7)) ) {
			// Get all the missing items in a list
			SESSION.formErrors.Add("Please answer the Yes/No question: Second job - Do you currently have a second job?");
		}
		
		// Q7 Expalin if Yes
		if ( FORM.q7 EQ 'yes' and NOT LEN(TRIM(FORM.q7_explain) ) ) {
			// Get all the missing items in a list
			SESSION.formErrors.Add("You  answered Yes to: Second job - Do you currently have a second job? but did not provide any details.  Please let us know your concerns.");
		}
		
		// Q8
		if ( NOT LEN(TRIM(FORM.q8)) ) {
			// Get all the missing items in a list
			SESSION.formErrors.Add("Please answer the Yes/No question: Do you have any current problems or concerns?");
		}
		
		// Q8 Explain if Yes
		if ( FORM.q8 EQ 'yes' and NOT LEN(TRIM(FORM.q8_explain) ) ) {
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
		
		<!-----Upload Files so we can attach them---->
        <cfif LEN(FORM.Q6file)>
            <cffile action="upload" destination="#APPLICATION.EXTRAUPLOAD#" filefield="Q6file" nameconflict="overwrite" />
            <cfset FORM.q6filename = '#FORM.candidateID#_#FORM.evaluation#_Question6.#file.ClientFileExt#'>
            <cffile action="rename" source="#APPLICATION.EXTRAUPLOAD##file.ServerFile#" destination="#APPLICATION.EXTRAUPLOAD##FORM.q6filename#" attributes="normal">
        </cfif>
        
        <cfif LEN(FORM.Q7file)>
            <cffile action="upload" destination="#APPLICATION.EXTRAUPLOAD#" filefield="Q7file" nameconflict="overwrite"/>
            <cfset FORM.q7filename = '#FORM.candidateID#_#FORM.evaluation#_Question7.#file.ClientFileExt#'>
            <cffile action="rename" source="#APPLICATION.EXTRAUPLOAD##file.ServerFile#" destination="#APPLICATION.EXTRAUPLOAD##FORM.q7filename#"attributes="normal">
        </cfif>
        
        <cfif LEN(FORM.pic1file)>
            <cffile action="upload" destination="#APPLICATION.EXTRAUPLOAD#" filefield="pic1file" nameconflict="overwrite"/>
            <cfset FORM.pic1file = '#FORM.candidateID#_#FORM.evaluation#_pic1.#file.ClientFileExt#'>
            <cffile action="rename" source="#APPLICATION.EXTRAUPLOAD##file.ServerFile#" destination="#APPLICATION.EXTRAUPLOAD##FORM.pic1file#"attributes="normal">
        </cfif>
        
        <cfif LEN(FORM.pic2file)>
            <cffile action="upload" destination="#APPLICATION.EXTRAUPLOAD#" filefield="pic2file" nameconflict="overwrite"/>
            <cfset FORM.pic2file = '#FORM.candidateID#_#FORM.evaluation#_pic2.#file.ClientFileExt#'>
            <cffile action="rename" source="#APPLICATION.EXTRAUPLOAD##file.ServerFile#" destination="#APPLICATION.EXTRAUPLOAD##FORM.pic2file#"attributes="normal">
        </cfif>
        
        <cfif LEN(FORM.pic3file)>
            <cffile action="upload" destination="#APPLICATION.EXTRAUPLOAD#" filefield="pic3file" nameconflict="overwrite"/>
            <cfset FORM.pic3file = '#FORM.candidateID#_#FORM.evaluation#_pic3.#file.ClientFileExt#'>
            <cffile action="rename" source="#APPLICATION.EXTRAUPLOAD##file.ServerFile#" destination="#APPLICATION.EXTRAUPLOAD##FORM.pic3file#"attributes="normal">
        </cfif>

        <cfscript>
            vEmailContent = "<h3> CSB - Mandatory Evaluation #FORM.evaluation# - #dateformat(Now(),'mm/dd/yyyy')#.</h3>
                <p style='font-size: 11px; font-family:Arial, Helvetica, sans-serif;'> 
                1. SEVIS Number:<strong> #FORM.Sevis#</strong> <br /> 
                2. Last name:<strong> #FORM.LastName#</strong><br /> 
                3. First name:<strong> #FORM.FirstName#</strong><br /> 
                4. Email:<strong> #FORM.email#</strong><br /> <br /> 
                5. Have you changed your housing address since your last report to CSB?<strong> #FORM.Q5#</strong><br />
                &nbsp;&nbsp;
				<i>
					If Yes and you did not previously inform CSB, please provide your new housing address (street and number, city, state, zip code).<br />
					<strong><u>Remember:</u></strong> 
					you must report any change related to the housing address within 10 (ten) business days.
				</i>
				<strong> #FORM.Q5_explain#</strong><br /><br />
                6. Main employer - Have you changed your main employer since your last report to CSB?<strong> #FORM.Q6#</strong><br /> 
                &nbsp;&nbsp;
				<i>
					If Yes and you did not previously inform CSB, please provide your new employer information (name of company, address, phone number, supervisor)
					and attach the signed job offer. If you don't have the job offer form, please contact CSB.<br />
					<strong><u>Remember:</u></strong> 
					CSB must confirm/approve the new job before you start work. If you start work in an unverified job, your program will be terminated.
				</i>
				<strong> #FORM.Q6_explain# </strong>
                <br />#FORM.q6filename#<br /> <br /> 
                
                7. Second job - Do you currently have a second job?<strong> #FORM.Q7#</strong><br />#FORM.q7filename#<br /> 
                &nbsp;&nbsp;
				<i>
					If Yes and you did not previously inform CSB, please provide your second employer information (name of company, address, phone number, supervisor) 
					and attach the job offer. If you don't have the job offer form, please contact CSB.<br />
					<strong><u>Remember:</u></strong> 
					CSB must confirm/approve the second job before you start work. If you starting work in an unverified job, your program will be terminated.
				</i>
				<strong> #FORM.Q7_explain# </strong><br /><br /> 
                 8. Do you have any current problems or concerns?<strong> #FORM.Q8#</strong><br /> 
                &nbsp;&nbsp;<i>If Yes, please provide full details (where, when, what, who, why):</i><strong> #FORM.Q8_explain# </strong><br /><br />
                9. Cultural activities <strong> #FORM.Q9_explain# </strong><br /><br /></p>
                --";
            
            email=CreateObject("component","extensions.components.email");
        
			// Set up the upload files (will send an empty string if there is no file).
			file6 = '';
			file7 = '';
			pic1 = '';
			pic2 = '';
			pic3 = '';
			if (LEN(FORM.Q6file))
				file6 = APPLICATION.EXTRAUPLOAD & FORM.q6filename;
			if (LEN(FORM.Q7file))
				file7 = APPLICATION.EXTRAUPLOAD & FORM.q7filename;
			if (LEN(FORM.pic1file))
				pic1 = APPLICATION.EXTRAUPLOAD & FORM.pic1file;
			if (LEN(FORM.pic2file))
				pic2 = APPLICATION.EXTRAUPLOAD & FORM.pic2file;
			if (LEN(FORM.pic3file))
				pic3 = APPLICATION.EXTRAUPLOAD & FORM.pic3file;
			
			// Send the email
			email.send_mail(
				email_from='CSB Summer Work Travel<support@csb-usa.com>',
				email_to='support@csb-usa.com',
				email_subject=FORM.LastName & ', ' & FORM.FirstName & ' - CSB Monthly Evaluation ' & FORM.evaluation,
				email_cc=FORM.email,
				email_file=file6,
				email_file2=file7,
				email_file3=pic1,
				email_file4=pic2,
				email_file5=pic3,
				email_message=vEmailContent
			);
			
			q5Bit = 0;
			q6Bit = 0;
			q7Bit = 0;
			q8Bit = 0;
			if (FORM.Q5 EQ "YES") {q5Bit = 1;}
			if (FORM.Q6 EQ "YES") {q6Bit = 1;}
			if (FORM.Q7 EQ "YES") {q7Bit = 1;}
			if (FORM.Q8 EQ "YES") {q8Bit = 1;}
			
			
			vSaveContent = "FROM: CSB Summer Work Travel<support@csb-usa.com><br/><br/>TO: support@csb-usa.com<br/><br/>CC: " & FORM.email & "<br/><br/>" & vEmailContent;
			
        </cfscript>
        
        <cfquery datasource="mysql">
        	INSERT INTO extra_evaluation (
            	candidateID
                ,monthEvaluation
                ,evaluationMemo
               	,hasHousingChanged
                ,housingChangedDetails
                ,hasCompanyChanged
               	,companyChangedDetails
                <cfif LEN(FORM.Q6file)>
                	,companyChangedFile
              	</cfif>
                ,hasSecondJob
                ,secondJobDetails
                <cfif LEN(FORM.Q7file)>
                	,secondJobFile
              	</cfif>
                ,hasHostCompanyConcern
                ,hostCompanyConcernDetails
                ,culturalActivities
                <cfif LEN(FORM.pic1file)>
                	,culturalActivityFile1
              	</cfif>
                <cfif LEN(FORM.pic2file)>
                	,culturalActivityFile2
              	</cfif>
                <cfif LEN(FORM.pic3file)>
                	,culturalActivityFile3
              	</cfif> )
         	VALUES (
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.candidateID)#">
                ,<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.evaluation)#">
                ,<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#vSaveContent#">
                ,<cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(q5Bit)#">
                ,<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.Q5_explain#">
                ,<cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(q6Bit)#">
                ,<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.Q6_explain#">
                <cfif LEN(FORM.Q6file)>
                	,<cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.EXTRAUPLOAD##FORM.q6filename#">
              	</cfif>
                ,<cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(q7Bit)#">
                ,<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.Q7_explain#">
                <cfif LEN(FORM.Q7file)>
                	,<cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.EXTRAUPLOAD##FORM.q7filename#">
              	</cfif>
                ,<cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(q8Bit)#">
                ,<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.Q8_explain#">
                ,<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.Q9_explain#">
                <cfif LEN(FORM.pic1file)>
                	,<cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.EXTRAUPLOAD##FORM.pic1file#">
              	</cfif>
                <cfif LEN(FORM.pic2file)>
                	,<cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.EXTRAUPLOAD##FORM.pic2file#">
              	</cfif>
                <cfif LEN(FORM.pic3file)>
                	,<cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.EXTRAUPLOAD##FORM.pic3file#">
              	</cfif> )
        </cfquery> 
  
        <meta http-equiv="refresh" content="2;url=http://www.csb-usa.com/SWT/">
            <div class="yellow" style="background-color: #CCC; font-size: 11px; padding: 20px; font-family:Arial, Helvetica, sans-serif; width: 800px;">
                <h3>The following information has been successfully submitted to CSB Summer Work and Travel from the CSB - Mandatory Summer Work Travel Questionnaire.</h3>
                <cfoutput>
                    <table width=90% align="center">
                        <tr>
                            <td class="text">
                                <p style="font-size: 11px; font-family:Arial, Helvetica, sans-serif;">1. SEVIS Number:<strong> #FORM.Sevis#</strong> <br /> 
                                2. Last name:<strong> #FORM.LastName#</strong><br /> 
                                3. First name:<strong> #FORM.FirstName#</strong><br /> 
                                4. Email:<strong> #FORM.email#</strong><br /> <br /> 
                                5. Housing address - Have you changed your housing address since your last report to CSB?<strong> #FORM.Q5#</strong><br />
                                &nbsp;&nbsp;
                                <i>
                                	If Yes and you did not previously inform CSB, please provide your new housing address (street and number, city, state, zip code). <br />
                                	<strong><u>Remember:</u></strong> 
                                    you must report any change related to the housing address within 10 (ten) business days.
                              	</i>
                                <strong> #FORM.Q5_explain#</strong><br /><br /> 
                                6. Main employer - Have you changed your main employer since your last report to CSB?<strong> #FORM.Q6#</strong><br /> 
                                &nbsp;&nbsp;
                                <i>
                                	If Yes and you did not previously inform CSB, please provide your new employer information (name of company, address, phone number, supervisor)
                                    and attach the signed job offer. If you don't have the job offer form, please contact CSB.<br />
									<strong><u>Remember:</u></strong> 
                                    CSB must confirm/approve the new job before you start work. If you start work in an unverified job, your program will be terminated.
                            	</i>
                                <strong> #FORM.Q6_explain#</strong><br />#FORM.Q6file#<br /> <br /> 
                                7. Second job - Do you currently have a second job?<strong> #FORM.Q7#</strong><br />#FORM.Q7file#<br /> 
                                &nbsp;&nbsp;
                                <i>
                              		If Yes and you did not previously inform CSB, please provide your second employer information (name of company, address, phone number, supervisor) 
                                    and attach the job offer. If you don't have the job offer form, please contact CSB.<br />
									<strong><u>Remember:</u></strong> 
                                    CSB must confirm/approve the second job before you start work. If you starting work in an unverified job, your program will be terminated.
                             	</i>
                                <strong> #FORM.Q7_explain# </strong><br /><br />
                                8. Do you have any current problems or concerns?<strong> #FORM.Q8#</strong><br /> 
                                &nbsp;&nbsp;<i>If Yes, please provide full details (where, when, what, who, why):</i><strong> #FORM.Q8_explain# </strong><br /><br />
                                9. Cultural activities <strong> #FORM.Q9_explain# </strong><br /><br /></p>
                            </td>
                        </tr>
                    </table>
                </cfoutput>
            </div>
            <cfabort>
    
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
	<input type="hidden" name="submitted" value="1" />
    <input type="hidden" name="evaluation" id="evaluation" value="#FORM.evaluation#" />
    <input type="hidden" name="candidateID" value="#FORM.candidateID#" />
  <table width="665" border="0" cellspacing="0" cellpadding="5">
  <tr bgcolor="##EFEFEF" >
    <td width="132" bgcolor="##EFEFEF" class="Bold">1. SEVIS Number:</td>
    <td width="418">
      <label for="Sevis"></label>
      <input type="text" readonly="readonly" name="Sevis" id="Sevis" value="#FORM.Sevis#" />
    </td>
  </tr>
  <tr>
    <td class="Bold">2. Last Name:</td>
    <td><label for="Sevis"></label>
      <input type="text" readonly="readonly" name="LastName" id="LastName"  value="#FORM.LastName#"/></td>
  </tr>
  <tr bgcolor="##EFEFEF" >
    <td class="Bold">3. First Name:</td>
    <td><label for="Sevis"></label>
      <input type="text" readonly="readonly" name="FirstName" id="FirstName"  value="#FORM.FirstName#"/></td>
  </tr>
    <tr>
    <td class="Bold">4. E-mail:</td>
    <td><label for="Sevis"></label>
      <input type="text" readonly="readonly" name="email" id="email" value="#FORM.email#" /></td>
  </tr>
  <tr bgcolor="##EFEFEF" >
    <td colspan="2" bgcolor="##EFEFEF" class="Bold">
    5. Housing address - Have you changed your housing address since your last report to CSB?
    <table width="625" border="0" cellspacing="5"> 
  <tr valign="middle">
    <td width="90" align="left">
    	<input type="radio" name="Q5" id="Q5" value="No" <Cfif FORM.q5 is 'no'>checked</cfif>  />
        <label for="NO" class="Bold">NO</label></td>
    <td width="516"></td>
  </tr>
  <tr valign="top">
    <td align="left"><input type="radio" name="Q5" id="Q5" value="YES" <cfif FORM.q5 is 'yes'>checked</cfif> />
      	<label for="YES" class="Bold">YES</label></td>
    <td align="left">If Yes and you did not previously inform CSB, please provide your new housing address (street and number, city, state, zip code).<br />
      
      <strong><u>Remember:</u></strong> you must report any change related to the housing address within 10 (ten) business days.</td>
    </tr>
  <tr>
    <td valign="middle"> If YES, Explain</td>
    <td><label for="Q5_explain"></label>
      <textarea name="Q5_explain" id="Q5_explain" cols="45" rows="5" >#FORM.Q5_explain#</textarea></td>
  </tr>
</table>
</td>
  </tr>
 <tr>
 <td colspan="2" class="Bold">
    6. Main employer - Have you changed your main employer since your last report to CSB?
      <table width="625" border="0" cellspacing="5">
        <tr valign="middle">
    <td><input type="radio" name="Q6" id="Q6" value="No" <cfif FORM.Q6 is 'No'>checked</cfif> />
      <label for="NO" class="Bold">NO</label></td>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr valign="top">
    <td width="87"><input type="radio" name="Q6" id="Q6" value="Yes" <cfif FORM.Q6 is 'Yes'>checked</cfif> />
      <label for="YES" class="Bold">YES</label></td>
    <td colspan="2">If Yes and you did not previously inform CSB, please provide your new employer information (name of company, address, phone number, supervisor)and attach the signed job offer. If you don't have the job offer form, please contact CSB.<br />
<strong><u>Remember:</u></strong> CSB must confirm/approve the new job before you start work. If you start work in an unverified job, your program will be terminated.</td>
  </tr>
  <tr>
    <td valign="middle"> If YES, Explain</td>
    <td width="519"><label for="Q6_explain"></label>
      <textarea name="Q6_explain" id="Q6_explain" cols="45" rows="5">#FORM.Q6_explain#</textarea></td>
 
  </tr>
    <tr>
    <td valign="middle">&nbsp;</td>
    <td colspan="2"><input type="file" name="Q6file"></td>
    </tr>
</table>
</td>
  </tr>
  <tr bgcolor="##EFEFEF" >
    <td colspan="2" class="Bold">
    7. Second job - Do you currently have a second job?
      <table width="625" border="0" cellspacing="5">
       <tr valign="middle">
    <td><input type="radio" name="Q7" id="Q7" value="No" <cfif FORM.Q7 is 'No'>checked</cfif>  />
      <label for="NO" class="Bold">NO</label></td>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr valign="top">
    <td width="87"><input type="radio" name="Q7" id="Q7" value="Yes" <cfif FORM.Q7 is 'Yes'>checked</cfif>  />
      <label for="YES" class="Bold">YES</label></td>
    <td colspan="2">If Yes and you did not previously inform CSB, please provide your second employer information (name of company, address, phone number, supervisor) and attach the job offer. If you don't have the job offer form, please contact CSB.<br />
<strong><u>Remember:</u></strong> CSB must confirm/approve the second job before you start work. If you starting work in an unverified job, your program will be terminated.</td>
  </tr>

  <tr>
    <td valign="middle"> If YES, Explain</td>
    <td width="519">
  
    <label for="Q7_explain"></label>
      <textarea name="Q7_explain" id="Q7_explain" cols="45" rows="5">#FORM.Q7_explain#</textarea></td>
  </tr>
    <tr>
    <td valign="middle">&nbsp;</td>
    <td colspan="2"><input type="file" name="Q7file"><br /></td>
    </tr>
</table>
</td>
  </tr>
  
     <tr>
    <td colspan="2" class="Bold">
    8. Do you have any current problems or concerns?
      <table width="625" border="0" cellspacing="5">
       <tr valign="middle">
    <td><input type="radio" name="Q8" id="Q8" value="No" <cfif FORM.Q8 is 'No'>checked</cfif>  />
      <label for="NO" class="Bold">NO</label></td>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr valign="top">
    <td width="88"><input type="radio" name="Q8" id="Q8" value="Yes" <cfif FORM.Q8 is 'Yes'>checked</cfif>  />
      <label for="YES" class="Bold">YES</label></td>
    <td colspan="2">If Yes, please provide full details (where, when, what, who, why).</td>
  </tr>

  <tr>
    <td valign="middle">&nbsp;</td>
    <td width="518"><label for="Q8_explain"></label>
      <textarea name="Q8_explain" id="Q8_explain" cols="45" rows="5">#FORM.Q8_explain#</textarea></td>
    
      
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
      <textarea name="Q9_explain" id="Q9_explain" cols="45" rows="5">#FORM.Q9_explain#</textarea></td>
    
      
  </tr>
   <tr>
    <td valign="middle">&nbsp;</td>
    <td colspan="2">
    	<input type="file" name="pic1file"><br />
        <input type="file" name="pic2file"><br />
        <input type="file" name="pic3file">
  	</td>
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
