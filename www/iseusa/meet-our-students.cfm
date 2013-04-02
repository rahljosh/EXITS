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


    
    <cfif FORM.type EQ 'newAccount'>
  
	<cfquery name="checkEmail" datasource="MySQL">
    select *
    from smg_host_lead
    where email = "#form.email#"
    </cfquery>

    <cfif checkEmail.recordcount gt 0>
   		<cfcookie name="iseLead" expires="never" domain=".iseusa.com" value="#FORM.email#">
        <cflocation url="https://www.iseusa.com/viewStudents.cfm" addtoken="no">
    </cfif>
    
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
    			
                <!--- Generate New Password --->
                <cfset setPassword = generatePassword()>
                
                <cfquery result="newRecord" datasource="#APPLICATION.DSN.Source#">
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
             
                <cfscript>
					//Create Host Object
					//h = createObject("component","extensions.components.host");
					
					// Insert Hash ID and Initial Comment
					APPLICATION.CFC.HOST.setHostLeadDataIntegrity(ID=newRecord.GENERATED_KEY);
				</cfscript>
   
             <cfcookie name="iseLead" expires="never" domain=".iseusa.com" value="#FORM.email#">
             
             <cfsavecontent variable="vEmailMessage">
	                <cfoutput>
                        #FORM.firstname#-
                        
                        <p>Thank you for you interest in ISE.</p>
                        
                    <p> We appreciate your interest in providing an international student with a life-changing experience. A representative of International Student exchange will be contacting you shortly to provide you with additional information about hosting.</p>
                        
                        <p>Please visit <a href="#APPLICATION.siteURL#meet-our-students.cfm">#APPLICATION.siteURL#meet-our-students.cfm</a> to view profiles of students whoe are coming to the United States this next season. </p>
    
                        Best Regards-<br />
                        International Student Exchange
					</cfoutput>
                </cfsavecontent>
                
                <!--- send email --->
                <cfinvoke component="cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="#FORM.email#">
                    <cfinvokeargument name="email_subject" value="Host Family Interest">
                    <cfinvokeargument name="email_message" value="#vEmailMessage#">
                    <cfinvokeargument name="email_from" value="International Student Exchange <#AppEmail.support#>">
                </cfinvoke>
       
             <cfscript>
             	location("viewStudents.cfm", "no");
              </cfscript>
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
<Cfif isdefined('cookie.iseLead')>
	<cflocation url="viewStudents.cfm">
</Cfif>
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

					
    
                        <!--- Login --->
                        
                           
                          
                            <h2 style="margin-top:0px;">Host Family Application? </h2>
                    
                            <p>
                            	<em>
                                    Have you received an email from ISE regarding your Host Family <br />Application?  If so, you can access your application through <br /> the login portal located at <a href="http://www.iseusa.com/hostApp"><font color="white"><strong>http://www.iseusa.com/hostApp</strong></font></a> <br /><br /> 
                                    This email would be from a local representative with ISE <br />and contain instructions and login information to start <br />a Host Family Application.
                            	</em>
                            </p>

                            

                            
                                 

                            
                          
                       
    
                     
                            
                          
                          
                        
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
