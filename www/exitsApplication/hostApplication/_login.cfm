<!--- ------------------------------------------------------------------------- ----
	
	File:		login.cfm
	Author:		Marcus Melo
	Date:		November 6, 2012
	Desc:		Login Page

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	    
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.username" default="">
    <cfparam name="FORM.password" default="">
    <cfparam name="FORM.forgot" default="0">
    
    <!--- Forgot login --->
    <cfif VAL(FORM.forgot)>
    	<cfif NOT isValid("email", TRIM(FORM.username))>
        	<cfscript>
				// Error - Could not resend login
				SESSION.formErrors.Add("Please enter a valid email to have your information sent to.");
			</cfscript>
        <cfelse>
        	<!--- Find user in database --->
        	<cfquery name="qCheckHost" datasource="#APPLICATION.DSN.Source#">
            	SELECT
                    s.ID,
                    s.applicationStatusID,
                    s.seasonID,       
                    h.hostID,       
                    h.familyLastName,       
                    h.email,       
                    h.regionID,       
                    h.companyID       
                FROM smg_host_app_season s
                INNER JOIN smg_hosts h ON h.hostID = s.hostID
                WHERE s.applicationStatusID != 0
                AND h.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.username)#">   
                ORDER BY s.seasonID DESC
                LIMIT 1 
            </cfquery>
            <cfif VAL(qCheckHost.recordCount)>
            	<cfset APPLICATION.selectedSeason = qCheckHost.seasonID>
            	<cfsavecontent variable="emailContent">
                	<cfoutput query="qCheckHost">
                    	<p>
                        	#qCheckHost.fatherfirstname# <cfif LEN(qCheckHost.fatherfirstname) AND LEN(qCheckHost.motherfirstname)>and </cfif>#qCheckHost.motherfirstname# #qCheckHost.familylastname#,
                            a login information retrieval request was made from the #SESSION.COMPANY.exitsURL#hostApplication website. <br /><br />
           		        	Your login information is: <br /><br />
                            Email: #qCheckHost.email#<br />
                            Password: #qCheckHost.password#
                        </p>
                        <p>To login please visit: <a href="#SESSION.COMPANY.exitsURL#hostApplication">#SESSION.COMPANY.exitsURL#hostApplication</a> </p>
                    </cfoutput>
                </cfsavecontent>
                <cfinvoke component="extensions.components.email" method="sendEmail">
                    <cfinvokeargument name="emailFrom" value="#SESSION.COMPANY.EMAIL.support#">
                    <cfinvokeargument name="emailTo" value="#FORM.username#">
                    <cfinvokeargument name="emailSubject" value="Login Information">
                    <cfinvokeargument name="emailMessage" value="#emailContent#">
                </cfinvoke>
                <cfscript>
					// Message - Login information sent
					SESSION.pageMessages.Add("Your login credentials have been sent to the email address provided.");
				</cfscript>
          	<cfelse>
            	<cfscript>
					// Error - Host Family Not Found
					SESSION.formErrors.Add("Your login credentials could not be found. Please verify your email address.");
				</cfscript>
            </cfif>
        </cfif>
    </cfif>   
    
	<!--- FORM Submitted --->
	<cfif VAL(FORM.submitted)>
    
		<!--- Check if we have a host account --->
        <cfquery name="qLoginHostFamily" datasource="#APPLICATION.DSN.Source#">
        	SELECT
            	s.ID,
                s.applicationStatusID,
                s.seasonID,       
                h.hostID,       
                h.familyLastName,       
                h.email,       
                h.regionID,       
                h.companyID       
            FROM smg_host_app_season s
            INNER JOIN smg_hosts h ON h.hostID = s.hostID
            WHERE s.applicationStatusID != 0
            AND
            	<cfif SESSION.COMPANY.ID EQ	1>
                    h.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,12" list="yes"> )
                <cfelse>
                    h.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(SESSION.COMPANY.ID)#">
                </cfif>
            AND h.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.username)#">
            AND h.password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.password)#">    
            ORDER BY s.seasonID DESC
            LIMIT 1           
        </cfquery>
        
		<!--- Host Account found - Log them in --->
        <cfif qLoginHostFamily.recordcount>

			<!--- Set status from "Started" to "Host" ---> 
            <cfif qLoginHostFamily.applicationStatusID EQ 9>
            
            	<cfset APPLICATION.selectedSeason = qLoginHostFamily.seasonID>
            
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    UPDATE 
                        smg_host_app_season
                    SET 
                        applicationStatusID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">,
                        dateStarted = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">
                    WHERE 
                        ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qLoginHostFamily.ID)#">
                </cfquery>
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    UPDATE 
                        smg_hosts
                    SET 
                        active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    WHERE 
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qLoginHostFamily.hostID)#">
                </cfquery>
                
           	<cfelse>
            	
                <!--- Ensure that the family is made active if they log in --->
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    UPDATE 
                        smg_hosts
                    SET 
                        active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    WHERE 
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qLoginHostFamily.hostID)#">
                </cfquery>
                
            </cfif>
        
            <cfscript>
				// Login Host Family
				APPLICATION.CFC.SESSION.setHostSession(
					hostID=qLoginHostFamily.hostID,												
					applicationStatus=qLoginHostFamily.applicationStatusID,
					familyName=qLoginHostFamily.familylastname,
					email=qLoginHostFamily.email,
					isExitsLogin=false,
					regionID=qLoginHostFamily.regionID
				);

				// Go to overview page
				Location(APPLICATION.CFC.UDF.setPageNavigation(), "no");
			</cfscript>
            
        <cfelse>
        	
            <!--- Check if we have a host lead account --->
            <cfquery name="qLoginHostFamily" datasource="#APPLICATION.DSN.Source#">
                SELECT 
                    hl.id,
                    hl.regionID,
                    hl.firstName, 
                    hl.lastName, 
                    hl.address, 
                    hl.address2, 
                    hl.city, 
                    hl.stateID, 
                    hl.zipCode, 
                    hl.email,
                    hl.phone, 
                    hl.password,
                    s.state
                FROM 
                    smg_host_lead hl
				LEFT OUTER JOIN
                	smg_states s ON s.ID = stateID                    
                WHERE 
                    hl.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.username)#">
                AND 
                    hl.password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.password)#">
                <!--- ********************************************************************************
					Remove the line below to allow host family leads to create a host family account
					on their own
				********************************************************************************* --->
                AND
                	1 != 1
            </cfquery>
        	            
            <!--- Host Lead Account Found - Convert to Host Family and log them in --->
            <cfif qLoginHostFamily.recordcount EQ 1>
			
				<!--- Copy Host Family Account only if it does not already exists --->
                <cfquery datasource="#APPLICATION.DSN.Source#" result="newRecord">
                    INSERT INTO
                        smg_hosts 
                    (
                        uniqueID,
                        companyID,
                        regionID,
                        familylastname, 
                        address, 
                        address2, 
                        city, 
                        state, 
                        zip, 
                        email,
                        phone, 
                        password,
                        applicationStarted, 
                        lead,
                        dateCreated
                    )
                    SELECT
                    	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(SESSION.COMPANY.ID)#">,
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qLoginHostFamily.regionID)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qLoginHostFamily.lastName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qLoginHostFamily.address#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qLoginHostFamily.address2#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qLoginHostFamily.city#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qLoginHostFamily.state#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qLoginHostFamily.zipCode#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qLoginHostFamily.email#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qLoginHostFamily.phone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qLoginHostFamily.password#">, 
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
                        <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
                    FROM 
                        DUAL
                    <!--- DO NOT INSERT IF ITS ALREADY EXISTS --->
                    WHERE 
                        NOT EXISTS 
                            (	
                                SELECT
                                    hostID
                                FROM	
                                    smg_hosts
                                WHERE
                                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qLoginHostFamily.email#">
                            )   
                </cfquery>
                
                <cfquery datasource="#APPLICATION.DSN#">
                	INSERT INTO smg_host_app_season (
                    	hostID,
                        seasonID,
                        applicationStatusID,
                        dateSent,
                        dateStarted,
                        dateCreated )
                  	VALUES (
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#newRecord.GENERATED_KEY#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.selectedSeason#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="8">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#"> )
                </cfquery>
                
				<cfscript>
					// Check if a record was inserted
					if ( newRecord.recordCount ) {
					
						// Login Host Family
						APPLICATION.CFC.SESSION.setHostSession(
							hostID=newRecord.GENERATED_KEY,												
							applicationStatus=8,
							familyName=qLoginHostFamily.lastName,
							email=qLoginHostFamily.email,
							isExitsLogin=false,
							regionID=qLoginHostFamily.regionID
						);
					
						// Go to overview page
						Location(APPLICATION.CFC.UDF.setPageNavigation(), "no");
					
					}					
                </cfscript>
                
            </cfif>
        
        </cfif>
		
        <cfscript>
			// Error - Could Not Login
			SESSION.formErrors.Add("The email and password you submitted do not match an account on file.<br />  Please check your information and try again.");
		</cfscript>
    	
	</cfif> <!--- FORM Submitted --->

</cfsilent>

<script type="text/javascript">
	function forgotLogin() {
		$("#submitted").val(0);
		$("#forgot").val(1);
		$("#loginForm").submit();
	}
</script>

<cfoutput> 

<form method="post" id="loginForm" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
    <input type="hidden" name="submitted" id="submitted" value="1" />
    <input type="hidden" name="forgot" id="forgot" value="0"/>
    
    <h1 align="center">Host Family Application</h1>
    
    <p align="center">Please login to access your host family application. <br /><br /></p>

	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="login"
        width="525px"
        />
        
  	<!--- Page Messages --->
    <gui:displayPageMessages
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="login"
        width="525px"
        />
    
    <div class="loginBox">
        
        <p align="center" style="margin:5px 5px 30px 5px;">
            <img src="images/LoginIcon_2.png" width="196" height="140" border="0" /> <br />
        </p>
    	
        <table align="center" cellpadding="4" cellspacing="0">
         	
		
            <tr>
                <td><label for="username">Email:</label></td>
                <td><input type="text" name="username" id="username" value="#FORM.userName#" size="35" /></td>
            </tr>
            <tr>
                <td><label for="password">Password:</label></td>
                <td><input type="password" name="password" id="password" size="35" /></p></td>
            </tr>
            <tr>
                <td><span style="color:green; cursor:pointer;" onclick="forgotLogin()">Forgot Login?</span></td>
                <td align="right"><input type="image" name="login" value="Login" src="images/login.png" /></td>
            </tr>
			
        </table>
        
    </div>
    
</form>
  
</cfoutput>