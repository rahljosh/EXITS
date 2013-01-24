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
    
	<!--- FORM Submitted --->
	<cfif VAL(FORM.submitted)>
    
		<!--- Check if we have a host account --->
        <cfquery name="qLoginHostFamily" datasource="#APPLICATION.DSN.Source#">
            SELECT  
                hostID, 
                hostAppStatus,
                initialHostAppType,
                familylastname,
                email
            FROM 
                smg_hosts
            WHERE 
            	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(SESSION.COMPANY.ID)#">
            AND            
                email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.username)#"> 
            AND 
                password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.password)#">
        </cfquery>
        
		<!--- Host Account found - Log them in --->
        <cfif qLoginHostFamily.recordcount>

			<!--- Set status from "Started" to "Host" ---> 
            <cfif qLoginHostFamily.hostAppStatus EQ 9>
            
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    UPDATE 
                        smg_hosts
                    SET 
                        hostAppStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
                    WHERE 
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qLoginHostFamily.hostID)#">
                </cfquery>
                
            </cfif>
        
            <cfscript>
				if ( qLoginHostFamily.hostAppStatus LTE 7 ) {
					vIsMenuBlocked = true;
				} else {
					vIsMenuBlocked = false;
				}
			
				// Login Host Family
				APPLICATION.CFC.SESSION.setHostSession(
					hostID=qLoginHostFamily.hostID,												
					applicationStatus=qLoginHostFamily.hostAppStatus,
					familyName=qLoginHostFamily.familylastname,
					email=qLoginHostFamily.email,
					isMenuBlocked=vIsMenuBlocked,
					isExitsLogin=false
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
                        hostAppStatus,
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
                        lead
                    )
                    SELECT
                    	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(SESSION.COMPANY.ID)#">,
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qLoginHostFamily.regionID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="8">, <!--- New Account | Set Status to "Host" --->
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
                        <cfqueryparam cfsqltype="cf_sql_bit" value="1">
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
                
				<cfscript>
					// Check if a record was inserted
					if ( newRecord.recordCount ) {
					
						// Login Host Family
						APPLICATION.CFC.SESSION.setHostSession(
							hostID=newRecord.GENERATED_KEY,												
							applicationStatus=8,
							familyName=qLoginHostFamily.lastName,
							email=qLoginHostFamily.email,
							isMenuBlocked=vIsMenuBlocked,
							isExitsLogin=false
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

<cfoutput> 

<form method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
    <input type="hidden" name="submitted" value="1" />
    
    <h1 align="center">Host Family Application</h1>
    
    <p align="center">Please login to access your host family application. <br /><br /></p>

	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
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
                <td colspan="2" align="right"><input type="image" name="login" value="Login" src="images/login.png" /></td>
            </tr>
        </table>
        
    </div>
    
</form>
  
</cfoutput>