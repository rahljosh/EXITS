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
    <cfparam name="FORM.isListSubscriber" default="0">
	<!--- Login --->
	<cfparam name="FORM.loginEmail" default="">
    <cfparam name="FORM.loginPassword" default="0">

	<cfscript>
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);
	</cfscript>


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
    

	<!--- List of States --->
    <cfquery name="qStateList" datasource="#application.dsn#">
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
                ArrayAppend(Errors.Messages, "Enter a valid email address.");			
            }

            // Password
            if ( NOT LEN(FORM.loginPassword) ) {
                ArrayAppend(Errors.Messages, "Enter a password.");			
            }
		</cfscript>

       <!--- There are no errors --->
       <cfif NOT VAL(ArrayLen(Errors.Messages))>
            
            <cfquery name="qCheckLogin" datasource="#application.dsn#">
                SELECT 
                    ID, 
                    lastName, 
                    email
                FROM 
                    smg_host_lead
                WHERE 
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(loginEmail)#">
                AND
                    password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(loginPassword)#">
            </cfquery>
    
            <cfscript>			
                // Set CLIENT Variables 
                if ( qCheckLogin.recordcount ) {
                    CLIENT.hostID = qCheckLogin.ID;
                    CLIENT.name = qCheckLogin.lastName;
                    CLIENT.email = qCheckLogin.email;
                }
            </cfscript>
        
            <!--- Valid Login - Redirect to View Students --->
            <cflocation url="viewStudents.cfm" addtoken="no">
    	
    	</cfif>
    
    <cfelseif FORM.type EQ 'newAccount'>

    	<!--- FORM Validation --->
		<cfscript>
            // Data Validation
            
            // Family Last Name
            if ( NOT LEN(FORM.lastName) ) {
                ArrayAppend(Errors.Messages, "Enter a family last name.");			
            }

            // First Name
            if ( NOT LEN(FORM.firstName) ) {
                ArrayAppend(Errors.Messages, "Enter a first name.");			
            }
			
            // Address
            if ( NOT LEN(FORM.address) ) {
                ArrayAppend(Errors.Messages, "Enter an address.");			
            }
			
            // City
            if ( NOT LEN(FORM.city) ) {
                ArrayAppend(Errors.Messages, "Enter a city.");			
            }

            // State
            if ( NOT VAL(FORM.stateID) ) {
                ArrayAppend(Errors.Messages, "Select a state.");			
            }

            // Zip Code
            if ( NOT LEN(FORM.zipCode) ) {
                ArrayAppend(Errors.Messages, "Enter a zip code.");			
            }

            // Phone Number
            if ( NOT LEN(FORM.phone) ) {
                ArrayAppend(Errors.Messages, "Enter a phone number.");			
            }
			
            // EMAIL
            if ( NOT LEN(FORM.email) OR NOT IsValid("email", FORM.email) ) {
                ArrayAppend(Errors.Messages, "Enter a valid email address.");			
            }
			
            // Heard About Us
            if ( NOT LEN(FORM.hearAboutUs) ) {
                ArrayAppend(Errors.Messages, "Select how did you hear about us.");			
            }
        </cfscript>

       <!--- There are no errors --->
       <cfif NOT VAL(ArrayLen(Errors.Messages))>
            
            <cfquery name="qCheckAccount" datasource="#application.dsn#">
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
                
                <cfoutput>
                <cfsavecontent variable="email_message">
                    #FORM.firstname#-
                    <br /><br />
                    Based on your email address entered at <a href="http://www.iseusa.com">http://www.iseusa.com</a>, it appears you already have an account. 
                    If you have ever hosted or applied to host with ISE*, or have already filled out the form, you have an account with us. <br /><Br />
                    Your login information is below should you decide to log back in to view students or complete the host family application. 
                    <br /><br />
                    User: #qCheckAccount.email#<br />
                    Password: #qCheckAccount.password#<br /><br />
                    <!---
                    *If you have any questions regarding this email or why you already have an account, please visit this page for more information and contact information. 
                    <a href="#APPLICATION.siteURL#account_info">#APPLICATION.siteURL#account_info</a>.				
                    <br /><br />
                    --->
                    Best Regards-<br />
                    International Student Exchange
                </cfsavecontent>
                </cfoutput>
                
                <!--- send email --->
                <cfinvoke component="cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="#FORM.email#">
                    <cfinvokeargument name="email_subject" value="Host Family Account Information">
                    <cfinvokeargument name="email_message" value="#email_message#">
                    <cfinvokeargument name="email_from" value="International Student Exchange <support@iseusa.com>">
                </cfinvoke>
                 
                <cfset message = 'It appears we already have an account with that email address assigned to it. This account information has been re-emailed to you.'>
            
            <!--- Account Does Not Exists --->   
            <cfelse>
    			
                <!--- Generate New Password --->
                <cfset setPassword = generatePassword()>
                
                <cfquery datasource="#application.dsn#">
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
                        isListSubscriber,
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
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.isListSubscriber#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    )		
                </cfquery>
                
                <cfoutput>
                <cfsavecontent variable="email_message">
                    #FORM.firstname#-
                    <br /><br />
                    Thank you for registering with ISE.  Should you need to log back in to see profiles or to fill out the host family application you can use the information below.  
                    <br /><br />
                    User: #FORM.email#<br />
                    Password: #setPassword#<br />
                    <!---
                    *If you have any questions regarding this email or why you already have an account, please visit this page for more information and contact information. 
                    <a href="#APPLICATION.siteURL#account_info">#APPLICATION.siteURL#account_info</a>.				
                    <br /><br />
                    --->
                    Best Regards-<br />
                    International Student Exchange
                </cfsavecontent>
                </cfoutput>
                
                <!--- send email --->
                <cfinvoke component="cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="#FORM.email#">
                    <cfinvokeargument name="email_subject" value="Host Family Account Information">
                    <cfinvokeargument name="email_message" value="#email_message#">
                    <cfinvokeargument name="email_from" value="International Student Exchange <support@iseusa.com>">
                </cfinvoke>
            
               <cfset message = "Your account has been created and login information has been sent to you for future access.">
            
            </cfif>
            
            <!--- Look Up Host Family --->
            <cfquery name="qGetHostInfo" datasource="#application.dsn#">
                SELECT
					hl.id,
                    st.state
                FROM 
                    smg_host_lead hl
                LEFT OUTER JOIN
                	smg_states st ON st.id = hl.stateID
                WHERE
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">
            </cfquery>
    
            <cfscript>			
                // Set CLIENT Variables 
                CLIENT.hostID = qGetHostInfo.ID;
                CLIENT.name = FORM.lastName;
                CLIENT.email = FORM.email;
            </cfscript>
            
            <!--- send email to Bob --->
            <cfoutput>
            <cfsavecontent variable="email_message">
    
                <cfif qCheckAccount.recordcount>
                    <strong>THIS IS A RETURNING HOST FAMILY</strong><Br />
                </cfif>         
                     
                The #FORM.lastname# family from #FORM.city# has submitted there information to view students.<br />
                
                Please see the details below: <br /><br />
                
                Family Last Name: #FORM.lastName# <br />
                First Name: #FORM.firstName# <br />
                Address: #FORM.address# <br />
                Address2: #FORM.address2# <br />
                City: #FORM.city# <br />
                State: #qGetHostInfo.state# <br />
                Zip Code: #FORM.zipCode# <br />
                Phone Number: #FORM.phone# <br />
                Email: #FORM.email# <br />
                How did you hear about us: #FORM.hearAboutUs# <br /> 
                Would you like to join our mailing list? <cfif FORM.isListSubscriber> Yes <cfelse> No </cfif> <br /> <br />

                <!--- View their information here: <a href="https://www.student-management.com/nsmg/index.cfm?curdoc=leads/hostInfo&ID=#qGetHostInfo.ID#">www.student-management.com/nsmg/index.cfm?curdoc=leads/hostInfo&ID=#qGetHostInfo.ID# </a> 
                <br /><br />
                Once they choose to host, have them login at <a href="http://www.iseusa.com">www.iseusa.com</a> to fill out the host family application using their account login information.
                <br /><br />
				 --->
            
                Regards,<Br />
                International Student Exchange
            </cfsavecontent>
            </cfoutput>
                            
            <!--- send email --->
            <cfinvoke component="cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#AppEmail.hostLead#">
                <cfinvokeargument name="email_subject" value="Host Family Viewing Students Section">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_from" value="International Student Exchange <support@iseusa.com>">
            </cfinvoke>
            
            <!--- Valid Login - Redirect to View Students --->
            <cflocation url="viewStudents.cfm" addtoken="no">
        
    	</cfif>
    
    </cfif>

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>(ISE) International Student Exchange - Foreign Exchange Students</title>
<link href="css/ISEstyle.css" rel="stylesheet" type="text/css" />
</head>

<body class="oneColFixCtr">

<cfoutput>

<div id="topBar">
	<cfinclude template="topBarLinks.cfm">
	<div id="logoBox"><a href="index.cfm"><img src="images/ISElogo.png" width="214" height="165" alt="ISE logo" border="0" /></a></div>
</div> <!-- end topBar -->

<div id="container">

	<div class="spacer2"></div>
	<div class="title"><cfinclude template="title.cfm"><!-- end title --></div>
	<div class="tabsBar"><cfinclude template="tabsBar.cfm"><!-- end tabsBar --></div>

    <div id="mainContent">
        
        <div id="subPages">
            
            <div class="whtTop"></div>
            
            <div class="whtMiddle">
		        <p class="header1">Meet Our Students</p>
        	    
                <div class="subPic">
                	<img src="images/subMeetStudents.png" width="415" height="277" alt="Meet our Students" />
		            <br />
            
            		<div class="loginBox">

        		    	<p> &nbsp; &nbsp; If you have already submited your contact information, please use the login information you received to login and view incoming students.</p>

                        <cfform name="login" id="login" method="post" action="http://#cgi.SERVER_NAME##cgi.SCRIPT_NAME#">
                        <input type="hidden" name="type" value="login" />
			            <table class="loginTable">
							
							<!--- Display Errors --->
                            <cfif FORM.type EQ 'login' AND VAL(ArrayLen(Errors.Messages))>
                                <tr class="errorMessage">
                                    <td>
                                        Please review the following items: <br /><br />
                                    
                                        <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                                           &nbsp; &bull; #Errors.Messages[i]# <br />        	
                                        </cfloop>
                                    </td>
                                </tr>
                            </cfif>	
                            
                            <tr>
								<td scope="row">
	                                <label for="loginEmail" class="loginText">Email Address</label> <br />
                                    <cfinput type="text" name="loginEmail" id="loginEmail" value="#FORM.loginEmail#" maxlength="100" class="largeInput" required="yes" message="Please enter a valid email address."  />          							
                                </td>
					        </tr>
                            <tr>
                                <td scope="row">
                                    <label for="loginPassword" class="loginText">Password</label> <br />                                   
                                    <cfinput type="password" name="loginPassword" id="loginPassword" maxlength="10" class="largeInput" required="yes" message="Please enter a password." />                                    
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"><input type="image" src="images/submitRed.png" /></th>
                            </tr>
                        </table>
                        </cfform>
                        
					</div> <!-- end loginbox -->
                    
				</div><!-- end subPic -->
                
                <div class="form">
                    <p>&nbsp; &nbsp; Fill out this form to learn more about our students and hosting through ISE! Our students are great ambassadors of their home countries and are excited to bring their cultures to communities in the United States.</p>
                    <p>&nbsp; &nbsp; In order to protect the privacy of our students, we do ask that you provide your name and address in order to ensure the utmost security of our students. </p>
                    <p>&nbsp; &nbsp; Once you register, you will be permitted to view select student profiles. </p>
                
					<!--- Display Errors --->
                    <cfif FORM.type EQ 'newAccount' AND VAL(ArrayLen(Errors.Messages))>
                        <p class="errorMessage">
                            
                            Please review the following items: <br /><br />
                        
                            <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                               &nbsp; &bull; #Errors.Messages[i]# <br />        	
                            </cfloop>
                            
						</p>
                    </cfif>	
                
                    <cfform name="newAccount" id="newAccount" method="post" action="#cgi.SCRIPT_NAME#">
                    <input type="hidden" name="type" value="newAccount" />
                    
                    <label for="lastName">Family Last Name</label><br />
                    <cfinput type="text" name="lastName" id="lastName" value="#FORM.lastName#" maxlength="100" class="largeInput" required="yes" message="Please enter a family last name."/> <br />
                    
                    <label for="firstName">Your First Name</label><br />
                    <cfinput type="text" name="firstName" id="firstName" value="#FORM.firstName#" maxlength="100"  class="largeInput" required="yes" message="Please enter a first name." /> <br />
                   
                    <label for="address">Address</label><br />
                    <cfinput type="text" name="address" id="address" value="#FORM.address#" maxlength="100" class="largeInput" required="yes" message="Please enter an address." /> <br />
                    
                    <label for="address2">Additional Address Info</label><br />
                    <cfinput type="text" name="address2" id="address2" value="#FORM.address2#" maxlength="100" class="largeInput" /> <br />
                    
                    <label for="city">City</label><br />
                    <cfinput type="text" name="city" id="city" value="#FORM.city#" maxlength="100" class="largeInput" required="yes" message="Please enter a city." /> <br />
                    
                    <label for="stateID">State</label><br />
                    <cfselect name="stateID" id="stateID" class="largeInput" required="yes" message="Please select a state.">
                        <option value="0"></option>
                        <cfloop query="qStateList">
                        	<option value="#qStateList.id#" <cfif FORM.stateID EQ qStateList.id> selected="selected" </cfif> >#qStateList.state# - #qStateList.statename#</option>
                    	</cfloop>
                    </cfselect> <br />
                    
                    <label for="zipCode">Zipcode - 5 digits only</label><br />
                    <cfinput type="text" name="zipCode" id="zipCode" value="#FORM.zipCode#" maxlength="5" class="largeInput" required="yes" message="Please enter a valid zip code." validateat="onSubmit" validate="zipcode" /> <br />
                    
                    <label for="phone">Phone Number</label><br />
                    <cfinput type="text" name="phone" id="phone" value="#FORM.phone#" maxlength="20" class="largeInput" required="yes"  message="Please enter a phone number xxx xxx-xxxx." pattern="(999) 999-9999" validateat="onSubmit" validate="telephone"/> <br />
                    
                    <label for="email">Email</label><br />
                    <cfinput type="text" name="email" id="email" value="#FORM.email#" maxlength="100" class="largeInput" required="yes" message="Please enter a valid email address.." validateat="onSubmit" validate="email" /> <br />
                    
                    <label for="hearAboutUs">How did you hear about us</label><br />
                    <cfselect name="hearAboutUs" id="hearAboutUs" class="largeInput" required="yes" message="Please tell us how you hear about ISE."> 			
                        <option value=""></option>
                        <cfloop index="i" from="1" to="#ArrayLen(CONSTANTS.hearAboutUs)#" step="1">
                            <option value="#CONSTANTS.hearAboutUs[i]#" <cfif CONSTANTS.hearAboutUs[i] EQ FORM.hearAboutUs> selected="selected" </cfif> >#CONSTANTS.hearAboutUs[i]#</option>
                        </cfloop>
                    </cfselect> <br />

					<br />                   
                    <cfinput type="checkbox" name="isListSubscriber" id="isListSubscriber" value="1">
                    <label for="isListSubscriber">Would you like to join our mailing list?</label> 
                    
                    <br /><br />
                    
                    <input type="image" src="images/submitRed.png" /><br />
                    
                    </cfform>
	                <br />
                
                </div>
     		
            	<br />
       

			</div> <!-- end whtMiddle -->

      		<div class="whtBottom"></div>
      
		</div> <!-- end subPages -->
      
	</div> <!-- end mainContent -->
    
</div> <!-- end container -->

<div id="main" class="clearfix"></div>

<div id="footer">
	<div class="clear"></div>
	<cfinclude template="bottomLinks.cfm">
</div> <!-- end footer -->

</cfoutput>

</body>
</html>
