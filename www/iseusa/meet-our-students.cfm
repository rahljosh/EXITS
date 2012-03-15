<!--- ------------------------------------------------------------------------- ----
	
	File:		meet-our-students.cfm
	Author:		Marcus Melo
	Date:		April 30, 2010
	Desc:		Meet our students page
	
	Updates:	04/01/2011 - Removing direct access, host family must check their 
				email address to get the login information.
				Emaling Bob/Budge after first login

	Notes:		Changes to this page must be copied to meet-our-students-ad.cfm

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <!--- Param FORM Variables --->
    <cfparam name="FORM.type" default="">
	<!--- New Account --->
    <cfparam name="FORM.lastName" default="">
	<cfparam name="FORM.firstName" default="">
	<cfparam name="FORM.address" default="">
	<cfparam name="FORM.address2" default="">
	<cfparam name="FORM.city" default="">
	<cfparam name="FORM.stateID" default="0">
	<cfparam name="FORM.zipCode" default="">
	<cfparam name="FORM.phone" default="">
	<cfparam name="FORM.email" default="">
	<cfparam name="FORM.hearAboutUs" default="">
	<cfparam name="FORM.hearAboutUsDetail" default="">
    <cfparam name="FORM.isListSubscriber" default="0">
    <cfparam name="FORM.remoteCountry" default="">
    <cfparam name="FORM.captcha" default="">
    <cfparam name="FORM.strCaptcha" default="#makeRandomString()#">
    <cfparam name="FORM.captchaHash" default="">    
	<!--- Login --->
	<cfparam name="FORM.loginEmail" default="">
    <cfparam name="FORM.loginPassword" default="0">
	<!--- Forgot Password --->
	<cfparam name="FORM.forgotEmail" default="">

	<!--- Allow Access for US Users --->
	<cfparam name="allowAccess" default="1">

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


	<cffunction name="generatePassword" access="public" returntype="string" hint="Generates a random password">
    	<cfargument name="PasswordLength" default="6">
    
    	<cfscript>
			var setPassword = '';

			// User - Update Date - Loop over CBC not submitted
			for (i=1; i LTE VAL(ARGUMENTS.PasswordLength); i=i+1) {
				
				// let passChar be random number between 48 and 122. Thus this will include everything from 0 to 9, Capital A to Z and small case a to z.
				passChar = randrange(48,122);
				
				/*
				Since all characters between 57 and 65 and those between 90 and 97 are charachters like "[,],+,=,..,$,#" and so on, we don't need them. Unless ofcourse yours is a password with special characters. 
				That explains the condition below. If our randrange givers a number like 92, we don't need it and I chose to subtitue it with an "E".
				*/
				if ( (passChar GT 57 AND passChar LT 65) OR (passChar GT 90 AND passChar LT 97) ) {
					// Add Char to Password
					setPassword = setPassword & "E";
				} else {
					// Add Char to Password
					setPassword = setPassword & chr(passChar);
				}
				
			}	// end of for

			return setPassword;
		</cfscript>
	</cffunction>        


	<cfscript>
		pageMsg = StructNew();
		// Create Array to store error messages
		pageMsg.Errors = ArrayNew(1);
		// Create Array to store page messages
		pageMsg.Messages = ArrayNew(1);
		
		// Set which form needs to be displayed
		if (FORM.type EQ "forgotPassword" ) {
			loginFormClass = 'hiddenDiv';
			forgotPassClass = '';
		} else {
			loginFormClass = '';
			forgotPassClass = 'hiddenDiv';
		}
		
		if ( NOT LEN(FORM.type) ) {
			// Set Captcha String
			FORM.strCaptcha = makeRandomString();
			// Encrypt String
			FORM.captchaHash = Hash(FORM.strCaptcha);
		}
		
		if ( LEN(CGI.HTTP_X_Forwarded_For) ) {
			getIPAddress = CGI.HTTP_X_Forwarded_For;
		} else {
			getIPAddress = CGI.remote_addr;
		}
		// getIPAddress = '96.56.128.58';		
	</cfscript>

    <!--- Get User Location - If not US, do not allow access --->
    <cftry>
		
		<!---
			http://api.ipinfodb.com/v2/ip_query.php?key=0fc7fb53672eaf186d2c41db1c9b63224ef8f31e0270d8c351d2097794352bfb&ip=96.56.128.58&timezone=false
			http://api.ipinfodb.com/v3/ip-country/?key=0fc7fb53672eaf186d2c41db1c9b63224ef8f31e0270d8c351d2097794352bfb&ip=96.56.128.58
		--->

        <cfhttp url="http://api.ipinfodb.com/v3/ip-country/?key=#APPLICATION.SETTINGS.IPInfoDBKey#&ip=#getIPAddress#" method="get" throwonerror="yes"></cfhttp>
        
        <cfscript>
			// Parse XML we received back to a variable
            responseXML = XmlParse(cfhttp.fileContent);		
			XMLHead = responseXML.Response;

            if ( responseXML.response.CountryCode.XmlText NEQ 'US' AND getIPAddress NEQ '127.0.0.1') {
				allowAccess = 0;		
            }
			
			// Set remoteCountry
			FORM.remoteCountry = responseXML.response.CountryCode.XmlText;
        </cfscript>
        <cfcatch type="any">
            <!--- Error - Allow Access --->
        </cfcatch>
    </cftry>
    
	<!--- List of States --->
    <cfquery name="qStateList" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	state, 
            id, 
            statename
        FROM 
        	smg_states
    </cfquery>

	<!--- FORM Submitted --->
	<cfif FORM.type EQ 'login'>
    
    	<!--- FORM Validation --->
		<cfscript>
            // Data Validation
            
            // Email
            if ( NOT LEN(FORM.loginEmail) OR NOT IsValid("email", FORM.loginEmail) ) {
                ArrayAppend(pageMsg.Errors, "Enter a valid email address.");			
            }

            // Password
            if ( NOT LEN(FORM.loginPassword) ) {
                ArrayAppend(pageMsg.Errors, "Enter a password.");			
            }
		</cfscript>

       <!--- There are no errors --->
       <cfif NOT VAL(ArrayLen(pageMsg.Errors))>
            
            <cfquery name="qCheckLogin" datasource="#APPLICATION.DSN.Source#">
                SELECT
                    hl.ID,
                    hl.firstName,
                    hl.lastName,
                    hl.address,
                    hl.address2, 
                    hl.city,
                    hl.stateID,
                    hl.zipCode,
                    hl.phone,
                    hl.email,
                    hl.password,
                    hl.hearAboutUs,
                    hl.hearAboutUsDetail,
                    hl.isListSubscriber,
                    hl.isAdWords,
                    hl.httpReferer,
                    hl.remoteAddress,
                    hl.remoteCountry,
                    hl.dateLastLoggedIn,
                    hl.dateCreated,
                    st.state
                FROM 
                    smg_host_lead hl
                LEFT OUTER JOIN
                	smg_states st ON st.id = hl.stateID
                WHERE 
                    hl.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.loginEmail)#">
                AND
                    hl.password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.loginPassword)#">
				AND	
                	hl.isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
				<!--- 3 = Not Interested | 10 = Not Qualified --->
                AND	
                	hl.statusID NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="3,10" list="yes"> )
            </cfquery>
        	
            <!--- Valid Login Host Family --->
        	<cfif qCheckLogin.recordcount>
            	
                <!--- Update Last Logged In Date --->
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    UPDATE 
                        smg_host_lead
                    SET
                    	dateLastLoggedIn = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    WHERE 
                        ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qCheckLogin.ID#">
                </cfquery>
                
                <!--- Email Bob/Budge if this is the first login --->
                <cfif NOT LEN(qCheckLogin.dateLastLoggedIn)>

                    <cfsavecontent variable="vEmailMessage">
                        <cfoutput>
                            <cfif VAL(CLIENT.isAdWords)>
                                <p><strong>Google AdWords Campaign</strong></p>
                            </cfif>     
                                 
                            <p>The #qCheckLogin.lastname# family from #qCheckLogin.city#, #qCheckLogin.state# has submitted their information to view students.</p>
                            
                            <p>Please see the details below:</p>
                            
                            Family Last Name: #qCheckLogin.lastName# <br />
                            First Name: #qCheckLogin.firstName# <br />
                            Address: #qCheckLogin.address# <br />
                            Address2: #qCheckLogin.address2# <br />
                            City: #qCheckLogin.city# <br />
                            State: #qCheckLogin.state# <br />
                            Zip Code: #qCheckLogin.zipCode# <br />
                            Phone Number: #qCheckLogin.phone# <br />
                            Email: #qCheckLogin.email# <br />
                            How did you hear about us: #qCheckLogin.hearAboutUs# <br /> 
                            
                            <cfif LEN(qCheckLogin.hearAboutUsDetail) AND qCheckLogin.hearAboutUs EQ 'ISE Representative'>
                                ISE Representative Name: #qCheckLogin.hearAboutUsDetail# <br /> 
                            <cfelseif LEN(qCheckLogin.hearAboutUsDetail) AND qCheckLogin.hearAboutUs EQ 'Other'>
                                Other Specify: #qCheckLogin.hearAboutUsDetail# <br /> 
                            </cfif>
                            
                            <!---
								Would you like to join our mailing list? <cfif qCheckLogin.isListSubscriber> Yes <cfelse> No </cfif> <br /> <br />
							--->
            				
                            Last Logged in #DateFormat(now(), 'mm/dd/yyyy')# #TimeFormat(now(), 'hh:mm tt')# EST <br /> <br />
                            
                            Regards, <br />
                            International Student Exchange
                        </cfoutput>
                    </cfsavecontent>
                                    
                    <!--- send email --->
                    <cfinvoke component="cfc.email" method="send_mail">
                        <cfinvokeargument name="email_to" value="#AppEmail.hostLead#">
                        <cfinvokeargument name="email_subject" value="Host Family Viewing Students Section">
                        <cfinvokeargument name="email_message" value="#vEmailMessage#">
                        <cfinvokeargument name="email_from" value="International Student Exchange <#AppEmail.support#>">
                    </cfinvoke>
                    
                </cfif>
                
                <cfscript>
					// Login Host Lead / Set CLIENT Variables 
                    CLIENT.hostID = qCheckLogin.ID;
                    CLIENT.name = qCheckLogin.lastName;
                    CLIENT.email = qCheckLogin.email;
					// Redirect to View Students
					location("viewStudents.cfm", "no");
				</cfscript>
    		
            <cfelse>
            	
                <cfscript>
					// Set Login Error Message
					ArrayAppend(pageMsg.Errors, "Invalid login. If you would like to retrieve your password, please click on forgot password below.");
				</cfscript>				
            
            </cfif>
            	
    	</cfif>
    
    <!--- Forgot Password --->
    <cfelseif FORM.type EQ 'forgotPassword'>
    
    	<!--- FORM Validation --->
		<cfscript>
            // Data Validation
            
            // Email
            if ( NOT LEN(FORM.forgotEmail) OR NOT IsValid("email", FORM.forgotEmail) ) {
                ArrayAppend(pageMsg.Errors, "Enter a valid email address.");			
            }
		</cfscript>

       <!--- There are no errors --->
       <cfif NOT VAL(ArrayLen(pageMsg.Errors))>

            <cfquery name="qCheckEmail" datasource="#APPLICATION.DSN.Source#">
                SELECT 
                    ID, 
                    firstName,
                    lastName, 
                    email,
                    password
                FROM 
                    smg_host_lead
                WHERE 
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.forgotEmail)#">
            </cfquery>
  			
            <!---  Email Already registered - Send Login Information --->
            <cfif qCheckEmail.recordCount>

                <cfsavecontent variable="vEmailMessage">
	                <cfoutput>
	                    Dear #qCheckEmail.firstName# #qCheckEmail.lastName#-
                        
                        <br /> <br />
                        Please see your login information below.
                        <br /> <br />
                        
                        User: #qCheckEmail.email#<br />
                        Password: #qCheckEmail.password#<br /> <br />
                        
                        Visit <a href="#APPLICATION.siteURL#meet-our-students.cfm">#APPLICATION.siteURL#meet-our-students.cfm</a> to meet our students. <br /> <br />
                        
                        PS: <strong>DO NOT</strong> click on "Log In" at the top right of the page. Use the form at the bottom of the meet our students page to login. <br /> <br />
                        
                        Best Regards-<br />
                        International Student Exchange
	                </cfoutput>
                </cfsavecontent>
                
                <!--- send email --->
                <cfinvoke component="cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="#qCheckEmail.email#">
                    <cfinvokeargument name="email_subject" value="ISE - Host Family Account Information">
                    <cfinvokeargument name="email_message" value="#vEmailMessage#">
                    <cfinvokeargument name="email_from" value="International Student Exchange <#AppEmail.support#>">
                </cfinvoke>
                
                <cfscript>				
					// Set Page Message
					ArrayAppend(pageMsg.Messages, "Login information has been sent to email addres provided.");
            	</cfscript>
            
            <!--- Email not registered --->
            <cfelse>
            	
                <cfscript>				
					// Set Page Message
					ArrayAppend(pageMsg.Messages, "Email address is not registered. Please create an account.");
            	</cfscript>
                
            </cfif>
            
        </cfif>  
    
    <cfelseif FORM.type EQ 'newAccount'>

    	<!--- FORM Validation --->
		<cfscript>
            // Data Validation
            
            // Family Last Name
            if ( NOT LEN(FORM.lastName) ) {
                ArrayAppend(pageMsg.Errors, "Enter a family last name.");			
            }

            // Family Last Name
            if ( LEN(FORM.lastName) LT 2 ) {
                ArrayAppend(pageMsg.Errors, "Enter a family last name.");			
            }

            // First Name
            if ( NOT LEN(FORM.firstName) ) {
                ArrayAppend(pageMsg.Errors, "Enter a first name.");			
            }

            // First Name
            if ( LEN(FORM.firstName) LT 2 ) {
                ArrayAppend(pageMsg.Errors, "Enter a first name.");			
            }

            // Address
            if ( NOT LEN(FORM.address) ) {
                ArrayAppend(pageMsg.Errors, "Enter an address.");			
            }
			
            // Address
            if ( LEN(FORM.address) LT 5 ) {
                ArrayAppend(pageMsg.Errors, "Enter an address.");			
            }

            // City
            if ( NOT LEN(FORM.city) ) {
                ArrayAppend(pageMsg.Errors, "Enter a city.");			
            }

            // City
            if ( LEN(FORM.city) LT 3 ) {
                ArrayAppend(pageMsg.Errors, "Enter a city.");			
            }

            // State
            if ( NOT VAL(FORM.stateID) ) {
                ArrayAppend(pageMsg.Errors, "Select a state.");			
            }

            // Zip Code
            if ( NOT LEN(FORM.zipCode) ) {
                ArrayAppend(pageMsg.Errors, "Enter a zip code.");			
            }

            // Zip Code
            if ( LEN(FORM.zipCode) LT 5 ) {
                ArrayAppend(pageMsg.Errors, "Enter a 5 digits zip code.");			
            }

            // Phone Number
            if ( NOT LEN(FORM.phone) ) {
                ArrayAppend(pageMsg.Errors, "Enter a phone number.");			
            }

			// Phone Number
            if ( LEN(FORM.phone) LT 7 ) {
                ArrayAppend(pageMsg.Errors, "Enter a phone number.");			
            }

            // EMAIL
            if ( NOT LEN(FORM.email) OR NOT IsValid("email", FORM.email) ) {
                ArrayAppend(pageMsg.Errors, "Enter a valid email address.");			
            }
			
            // Heard About Us
            if ( NOT LEN(FORM.hearAboutUs) ) {
                ArrayAppend(pageMsg.Errors, "Select how did you hear about us.");			
            }
			
			// Heard About Us
			if ( FORM.hearAboutUs EQ "ISE Representative" AND NOT LEN(FORM.hearAboutUsDetail) ) {
                ArrayAppend(pageMsg.Errors, "Enter the ISE representative name");			
			}
			
			// Heard About Us
			if ( FORM.hearAboutUs EQ "Other" AND NOT LEN(FORM.hearAboutUsDetail) ) {
                ArrayAppend(pageMsg.Errors, "Specify how did you hear about us");			
			}
			
			// Captcha
			if ( Hash(UCase(FORM.captcha)) NEQ FORM.captchaHash ) {
                ArrayAppend(pageMsg.Errors, "Enter text as displayed in the image");			
			}	
			
			// Terms and Conditions
			if ( NOT VAL(FORM.isListSubscriber) ) {
                ArrayAppend(pageMsg.Errors, "You must read and agree to the Terms and Conditions");			
			}
        </cfscript>

       <!--- There are no errors --->
       <cfif NOT VAL(ArrayLen(pageMsg.Errors))>
            
            <cfquery name="qCheckAccount" datasource="#APPLICATION.DSN.Source#">
                SELECT
                    ID, 
                    email,
                    password
                FROM
                    smg_host_lead
                WHERE	
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">                                
            </cfquery>
                
            <!--- Account Exists - Email Information --->             
            <cfif qCheckAccount.recordcount>
                
                <cfsavecontent variable="vEmailMessage">
	                <cfoutput>
                        #FORM.firstname#-
                        
                        <p>
                            Based on your email address entered at <a href="http://www.iseusa.com">http://www.iseusa.com</a>, it appears you already have an account. 
                            If you have ever hosted or applied to host with ISE*, or have already filled out the form, you have an account with us. <br /> <br />
                            Your login information is below should you decide to log back in to view students or complete the host family application. 
                        </p>
                        
                        Email Address: #qCheckAccount.email# <br />
                        Password: #qCheckAccount.password# <br /> <br />

                        Best Regards-<br />
                        International Student Exchange
					</cfoutput>
                </cfsavecontent>
                
                <!--- send email --->
                <cfinvoke component="cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="#FORM.email#">
                    <cfinvokeargument name="email_subject" value="Host Family Account Information">
                    <cfinvokeargument name="email_message" value="#vEmailMessage#">
                    <cfinvokeargument name="email_from" value="International Student Exchange <#AppEmail.support#>">
                </cfinvoke>
                 
            <!--- Account Does Not Exists --->   
            <cfelse>
    			
                <!--- Generate New Password --->
                <cfset setPassword = generatePassword()>
                
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    INSERT INTO
                        smg_host_lead 
                    (
                        firstName,
                        lastName,
                        address,
                        address2, 
                        city,
                        stateID,
                        zipCode,
                        phone,
                        email,
                        password,
                        hearAboutUs,
                        hearAboutUsDetail,
                        isListSubscriber,
                        isAdWords,
                        httpReferer,
                        remoteAddress,
                        remoteCountry,
                        dateCreated
                    )
                    VALUES                                
                    (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.firstName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.lastName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.stateID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zipCode#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#setPassword#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hearAboutUs#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hearAboutUsDetail#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.isListSubscriber#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.isAdWords)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.http_referer#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#getIPAddress#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.remoteCountry#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    )		
                </cfquery>
                
                <cfsavecontent variable="vEmailMessage">
	                <cfoutput>
                        #FORM.firstname#-
                        
                        <p>Thank you for registering with ISE.</p>
                        
                        <p>Please use the information below to log in to see profiles or to fill out the host family application. </p>
                        
                        Email Address: #FORM.email# <br />
                        Password: #setPassword# <br /> <br />
                        
                        Visit <a href="#APPLICATION.siteURL#meet-our-students.cfm">#APPLICATION.siteURL#meet-our-students.cfm</a> to meet our students. <br /> <br />
                        
                        PS: Use the login box in the <a href="#APPLICATION.siteURL#meet-our-students.cfm">#APPLICATION.siteURL#meet-our-students.cfm</a> page. <br /><br />
                        
                        PS: <strong>DO NOT</strong> click on "Log In" at the top right of the page. Use the form at the bottom of the meet our students page to login. <br /> <br />
    
                        Best Regards-<br />
                        International Student Exchange
					</cfoutput>
                </cfsavecontent>
                
                <!--- send email --->
                <cfinvoke component="cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="#FORM.email#">
                    <cfinvokeargument name="email_subject" value="Host Family Account Information">
                    <cfinvokeargument name="email_message" value="#vEmailMessage#">
                    <cfinvokeargument name="email_from" value="International Student Exchange <#AppEmail.support#>">
                </cfinvoke>
            
            </cfif>
            
    	</cfif>
    
    </cfif>

</cfsilent>

<cfinclude template="extensions/includes/_pageHeader.cfm"> <!--- Include Page Header --->

<script language="javascript">
	// When page is ready run the displayExtraField function
	$(document).ready(function() {
		displayExtraField();
		// displayForgotPass();
	});

	// Display Extra Field if option selected is ISE Rep or Other
	var displayExtraField = function() { 
		
		selectedOption = $("#hearAboutUs").val();
		
		// ISE Representative Option
		if( selectedOption == 'ISE Representative' ) {
			$("#labelHearAboutUs").html("ISE representative name <span class='requiredField'>*</span>");
			$("#spanHearAboutUs").html("If you do not remember, please enter unknown");
			$("#divExtraField").fadeIn("slow");
			$("#hearAboutUsDetail").focus();
		// Other Option			
		} else if (selectedOption == 'Other') {

			$("#labelHearAboutUs").html("Please specify <span class='requiredField'>*</span>");
			$("#spanHearAboutUs").html("");
			$("#divExtraField").fadeIn("slow");
			$("#hearAboutUsDetail").focus();
		} else {
			$("#divExtraField").fadeOut("slow");
		}
	
	}

	// Slide down form field div
	var displayForgotPass = function() { 
		
		if ($("#forgotPassForm").css("display") == "none") {
			$("#loginForm").slideToggle(1000);
			$("#forgotPassForm").slideToggle(1000);	
		} else {
			$("#forgotPassForm").slideToggle(1000);	
			$("#loginForm").slideToggle(1000);
		}
		
	}
	
	// Fomat Phone Number
	jQuery(function($){
	   $("#phone").mask("(999) 999-9999");
	});		
</script>
</head>

<body class="oneColFixCtr">

<cfoutput>

<div id="topBar">
	<cfinclude template="topBarLinks.cfm">
	<div id="logoBox"><a href="/"><img src="images/ISElogo.png" width="214" height="165" alt="ISE logo" border="0" /></a></div>
</div> <!-- end topBar -->

<div id="container">

	<div class="spacer2"></div>
	<div class="title"><cfinclude template="title.cfm"><!-- end title --></div>
	<div class="tabsBar"><cfinclude template="tabsBar.cfm"><!-- end tabsBar --></div>

    <div id="mainContent">
        
        <div id="subPages">
            
            <div class="whtTop"></div>
            
            <div class="whtMiddle">
            
                <div class="HformSideR">
                    <img src="images/hostFamily/HFformPic_03.png" width="392" height="398" />
                
                    <div class="loginTop"></div>
                    
                    <div class="loginMid">

						<!--- Display Errors --->
                        <cfif FORM.type EQ 'login' AND VAL(ArrayLen(pageMsg.Errors))>
                            <p class="errorMessage">
                                
                                <span>Please review the following item(s):</span>
                            
                                <cfloop from="1" to="#ArrayLen(pageMsg.Errors)#" index="i">
                                   &nbsp; &bull; #pageMsg.Errors[i]# <br />        	
                                </cfloop>
                            
                            </p>
                        </cfif>	
    
                        <!--- Login --->
                        <cfform name="loginForm" id="loginForm" method="post" action="http://#cgi.SERVER_NAME##cgi.SCRIPT_NAME#" class="#loginFormClass#">
                            <input type="hidden" name="type" value="login" />
                          
                            <h2 style="margin-top:0px;">LOGIN</h2>
                    
                            <p>
                            	<em>
                                    If you have already submited your contact information,<br />
                                    please use the login information you received to login and <br />
                                    and view incoming students.
                            	</em>
                            </p>

                            <div class="HFormpicR" style="float:right; width:100px;">
                                <a href="javascript:displayForgotPass();" class="HFform_wtext"> Forgot Password? </a>
                            </div>


                            
                            <label for="loginEmail" class="HFform_wtext">Email Address <span class="requiredField">*</span> </label> 
                            <cfinput type="text" name="loginEmail" id="loginEmail" value="#FORM.loginEmail#" maxlength="50" class="largeInput" required="yes" message="Please enter an email address." />          							
    
                            <label for="loginPassword" class="HFform_wtext">Password <span class="requiredField">*</span> </label>                                   
                            <cfinput type="password" name="loginPassword" id="loginPassword" maxlength="50" class="largeInput" required="yes" message="Please enter a password." />                                    

                            
                            <span class="requiredFieldNote">* Required Fields</span>
                            
                            <input type="image" src="images/hostFamily/HFform_login.png" />
                                
                        </cfform>
    
    
                        <!--- Forgot Password Form --->
                        <cfform name="forgotPassForm" id="forgotPassForm" method="post" action="http://#cgi.SERVER_NAME##cgi.SCRIPT_NAME#" class="#forgotPassClass#">
                        	<input type="hidden" name="type" value="forgotPassword" />
                            
                            <h3> Retrieve Password </h3>
    
                            <p> <em>Please enter your email address to have your password<br />emailed to you.</em></p>
    
                            <!--- Display Messages/Errors --->
                            <cfif FORM.type EQ 'forgotPassword' AND VAL(ArrayLen(pageMsg.Messages))>
                                <p class="pageMessage">
                                
                                    <cfloop from="1" to="#ArrayLen(pageMsg.Messages)#" index="i">
                                       &nbsp; &bull; #pageMsg.Messages[i]# <br />        	
                                    </cfloop>                                
                                
                                </p>
                            <cfelseif FORM.type EQ 'forgotPassword' AND VAL(ArrayLen(pageMsg.Errors))>
                                <p class="errorMessage">
                                    
                                    <span>Please review the following item(s):</span>
                                
                                    <cfloop from="1" to="#ArrayLen(pageMsg.Errors)#" index="i">
                                       &nbsp; &bull; #pageMsg.Errors[i]# <br />        	
                                    </cfloop>
                                
                                </p>
                            </cfif>	
                            
                            <label for="forgotEmail" class="HFform_wtext">Email Address <span class="requiredField">*</span> </label> 
                            <cfinput type="text" name="forgotEmail" id="forgotEmail" value="#FORM.forgotEmail#" maxlength="100" class="largeInput" required="yes" message="Please enter an email address." />          							
                            
                            <span class="requiredFieldNote">* Required Field</span>
                            
                            <input type="image" src="images/hostFamily/HFform_submit.png" /><br /><br />
                            
                            <a href="javascript:displayForgotPass();" class="HFform_wtext"> Back to Login </a>
                            
                        </cfform>
                        
                    </div><!--end loginMid-->
        
                <div class="loginBot"></div>
        
                </div><!--end HformSideR-->
    
                <div class="HformSideL">
        
                    <!--- Check if user is allowed to register --->
                    <cfif allowAccess>
                        
                        <cfif FORM.type EQ 'newAccount' AND NOT VAL(ArrayLen(pageMsg.Errors))>
            
                            <!--- Thank You For Registering --->
                            <div style="width:290px;">
                            
                                <p class="pageMessage">
                                    Thank you for registering with ISE. <br /><br />
                                    Your login information has been sent to the email address provided. <br /><br />
                                    Please follow the instructions on the email to meet our students. <br /><br />
                                    Please click on "Forgot Password" and enter your email address to have your login information re-sent to you. <br /><br />
                                    
                                    If you have any questions, please contact us at <a href="mailto:support@iseusa.com">support@iseusa.com</a> <br /><br />
                                    
                                    International Student Exchange
                                </p>
            
                            </div>
                        
                            <!-- Google Code for Meet Our Students Conversion Page -->
                            <script type="text/javascript">
                            /* <![CDATA[ */
                            var google_conversion_id = 1068621920;
                            var google_conversion_language = "en";
                            var google_conversion_format = "3";
                            var google_conversion_color = "ffffff";
                            var google_conversion_label = "epVpCNS10AEQ4MDH_QM";
                            var google_conversion_value = 0;
                            /* ]]> */
                            </script>
                            <script type="text/javascript" src="http://www.googleadservices.com/pagead/conversion.js">
                            </script>
                            <noscript>
                            <div style="display:inline;">
                            <img height="1" width="1" style="border-style:none;" alt="" src="http://www.googleadservices.com/pagead/conversion/1068621920/?label=epVpCNS10AEQ4MDH_QM&amp;guid=ON&amp;script=0"/>
                            </div>
                            </noscript>
                        
                        <cfelse>
                        <!--- Registration Form --->	
                        
                            <br /><img src="images/hostFamily/BeaHost.png" /><br />
                            <h4>Fill out this form to learn more about being a host family through ISE!</h4>
                            <p>Our students are great ambassadors of their home countries and are excited to bring their cultures to communities in the United States.</p>
                            <p> In order to protect the privacy of our students, we do ask that you provide your name and address in order to ensure the utmost security of our students.</p>
                            <p><strong>Once you register, you will be permitted to view select student profiles.</strong></p>
                            <br /> 
                            
                            <!--- Display Errors --->
                            <cfif FORM.type EQ 'newAccount' AND VAL(ArrayLen(pageMsg.Errors))>
                                <p class="errorMessage">
                                    Please review the following item(s):
                                    <cfloop from="1" to="#ArrayLen(pageMsg.Errors)#" index="i">
                                        &nbsp; &bull; #pageMsg.Errors[i]# <br />        	
                                    </cfloop>
                                </p>
                            </cfif>	
                                        
                            <cfform name="newAccount" id="newAccount" method="post" action="#cgi.SCRIPT_NAME#">
                                <input type="hidden" name="type" value="newAccount" />
                                <input type="hidden" name="strCaptcha" value="#FORM.strCaptcha#">
                                <input type="hidden" name="captchaHash" value="#FORM.captchaHash#">
                                            
                                <label for="lastName" class="HFform_text">Family Last Name <span class="requiredField">*</span></label>
                                <cfinput type="text" name="lastName" id="lastName" value="#FORM.lastName#" maxlength="100" class="largeInput" required="yes" message="Please enter a family last name."/> 
                                        
                                <label for="firstName" class="HFform_text">Your First Name <span class="requiredField">*</span></label>
                                <cfinput type="text" name="firstName" id="firstName" value="#FORM.firstName#" maxlength="100"  class="largeInput" required="yes" message="Please enter a first name." /> 
                               
                                <label for="address" class="HFform_text">Address <span class="requiredField">*</span></label>
                                <cfinput type="text" name="address" id="address" value="#FORM.address#" maxlength="100" class="largeInput" required="yes" message="Please enter an address." />
                                
                                <label for="address2" class="HFform_text">Additional Address Info</label>
                                <cfinput type="text" name="address2" id="address2" value="#FORM.address2#" maxlength="100" class="largeInput" /> 
                                
                                <label for="city" class="HFform_text">City <span class="requiredField">*</span></label>
                                <cfinput type="text" name="city" id="city" value="#FORM.city#" maxlength="100" class="largeInput" required="yes" message="Please enter a city." />
                                
                                <label for="stateID" class="HFform_text">State <span class="requiredField">*</span></label>
                                <cfselect name="stateID" id="stateID" class="largeInput" required="yes" message="Please select a state.">
                                    <option value="0"></option>
                                    <cfloop query="qStateList">
                                            <option value="#qStateList.id#" <cfif FORM.stateID EQ qStateList.id> selected="selected" </cfif> >#qStateList.state# - #qStateList.statename#</option>
                                    </cfloop>
                                </cfselect>
                                        
                                <label for="zipCode" class="HFform_text">Zipcode - 5 digits only <span class="requiredField">*</span></label>
                                <cfinput type="text" name="zipCode" id="zipCode" value="#FORM.zipCode#" maxlength="5" class="largeInput" required="yes" message="Please enter a valid zip code." validateat="onSubmit" validate="zipcode" />
                                
                                <label for="phone" class="HFform_text">Phone Number <span class="requiredField">*</span></label>
                                <cfinput type="text" name="phone" id="phone" value="#FORM.phone#" maxlength="20" class="largeInput" required="yes"  message="Please enter a phone number xxx xxx-xxxx." pattern="(999) 999-9999" validateat="onSubmit" validate="telephone"/>
                                
                                <label for="email" class="HFform_text">Email <span class="requiredField">*</span></label>
                                <cfinput type="text" name="email" id="email" value="#FORM.email#" maxlength="100" class="largeInput" required="yes" message="Please enter a valid email address." validateat="onSubmit" validate="email" />
                                
                                <label for="hearAboutUs" class="HFform_text">How did you hear about us <span class="requiredField">*</span></label>
                                <cfselect name="hearAboutUs" id="hearAboutUs" class="largeInput" required="yes" message="Please tell us how you hear about ISE." onChange="displayExtraField(this.value);"> 			
                                    <option value=""></option>
                                    <cfloop index="i" from="1" to="#ArrayLen(CONSTANTS.hearAboutUs)#" step="1">
                                        <option value="#CONSTANTS.hearAboutUs[i]#" <cfif CONSTANTS.hearAboutUs[i] EQ FORM.hearAboutUs> selected="selected" </cfif> >#CONSTANTS.hearAboutUs[i]#</option>
                                    </cfloop>
                                </cfselect>
                                        
                                <div id="divExtraField" class="hiddenDiv">
                                    <label for="hearAboutUsDetail" id="labelHearAboutUs" class="inputLabel"></label>
                                    <span id="spanHearAboutUs" class="HFform_text"></span>
                                    <cfinput type="text" name="hearAboutUsDetail" id="hearAboutUsDetail" value="#FORM.hearAboutUsDetail#" maxlength="100" class="largeInput" />
                                </div>
                                                    
                                <div style="clear:both;">&nbsp;</div>
                                
                                <!--- Captcha --->
                                <cfimage action="captcha" width="215" height="75" text="#FORM.strCaptcha#" difficulty="low" fontsize="28">
                                
                                <div style="clear:both;">&nbsp;</div>
                                
                                <label for="captcha" class="HFform_text">Please enter text in image above <span class="requiredField">*</span></label>
                                <cfinput type="text" name="captcha" id="captcha" class="largeInput" required="yes" message="Please enter text as displayed in the image above">
                                
                                <div style="clear:both;">&nbsp;</div>
                                
                                <a href="/terms-and-conditions.cfm" target="_blank" class="HFform_italic">Click to view the Terms and Conditions</a>
            
                                <div style="clear:both;">&nbsp;</div>
                                
                                <cfinput type="checkbox" name="isListSubscriber" id="isListSubscriber" value="1">
                                <label for="isListSubscriber" class="HFform_italic">I have read and agree to the Terms and Conditions and Privacy Policy.</label> 
                                <!--- 
                                    <cfinput type="checkbox" name="isListSubscriber" id="isListSubscriber" value="1" checked="yes">
                                    <label for="isListSubscriber" class="inputCheckbox">Would you like to join our mailing list?</label>							
                                --->
                                
                                <span class="requiredFieldNote">* Required Fields</span>
                                
                                <input type="image" src="images/hostFamily/HFform_submit.png" />
                                
                            </cfform>
                                    
                        </cfif> <!--- FORM.type EQ 'newAccount' AND  NOT VAL(ArrayLen(pageMsg.Errors)) --->
                                
                    <!--- Not US user --->
                    <cfelse>
                    
                        <div style="width:280px;">
                            <p>&nbsp; &nbsp; We are sorry but only United States based users are allowed to register to meet our upcoming students.</p>
                        </div>  
                                      
                    </cfif>
          
                </div><!--end HformSideL--><br />
    
                <div class="clearfix">&nbsp;</div>
                
                <div class="HFtopPic"><img src="images/hostFamily/HF_bar.jpg" width="700" height="13" /></div>
                
                <div class="clearfix">&nbsp;</div>
                
			</div><!-- end whtMiddle --> 
                
        	<div class="whtBottom"></div>
          
		</div> <!-- end subPages -->
          
    </div> <!-- end mainContent -->
    
</div> <!-- end container -->

</cfoutput>

<!--- Include Page Footer --->
<cfinclude template="extensions/includes/_pageFooter.cfm">
