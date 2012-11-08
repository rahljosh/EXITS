<!--- ------------------------------------------------------------------------- ----
	
	File:		hello.cfm
	Author:		Marcus Melo
	Date:		November 6, 2012
	Desc:		Host App Login Page

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>
	
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.username" default="">
    <cfparam name="FORM.password" default="">
    
	<cfset appNotComplete = 1>    
    
	<!--- FORM Submitted --->
	<cfif VAL(FORM.submitted)>
    
		<!--- Check if we have a host account --->
        <cfquery name="qLoginHostFamily" datasource="MySQL">
            SELECT  
                hostID, 
                hostAppStatus,
                initialHostAppType
            FROM 
                smg_hosts
            WHERE 
                email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.username)#"> 
            AND 
                password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.password)#">
        </cfquery>
        
		<!--- Host Account found - Log them in --->
        <cfif qLoginHostFamily.recordcount EQ 1>
        	
            <cfscript>
				// Login Host Family
				CLIENT.hostID = qLoginHostFamily.hostID;
				CLIENT.hostAppStatus = qLoginHostFamily.hostAppStatus;
				// Reload Page to display left menu
				Location(CGI.SCRIPT_NAME & "?" & CGI.QUERY_STRING);
			</cfscript>
            
        <cfelse>
        	
            <!--- Check if we have a host lead account --->
            <cfquery name="qLoginHostFamily" datasource="MySQL">
                SELECT 
                    hl.id,
                    hl.regionID,
                    hl.firstname, 
                    hl.lastname, 
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
            </cfquery>
        	            
            <!--- Host Lead Account Found - Convert to Host Family and log them in --->
            <cfif qLoginHostFamily.recordcount EQ 1>
			
				<!--- Copy Host Family Account only if it does not already exists --->
                <cfquery datasource="MySQL" result="newRecord">
                    INSERT INTO
                        smg_hosts 
                    (
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
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qLoginHostFamily.regionID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="8">, <!--- New Account | Set Status to "Host" --->
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qLoginHostFamily.lastname#">,
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
                    // Login Host Family
                    CLIENT.hostID = newRecord.GENERATED_KEY;
					CLIENT.hostAppStatus = 8;
                    // Reload Page to display left menu
                    Location(CGI.SCRIPT_NAME & "?" & CGI.QUERY_STRING);
                </cfscript>
                
            </cfif>
        
        </cfif>
	
	</cfif> <!--- FORM Submitted --->

	<!--- Logged In --->
    <cfif VAL(CLIENT.hostID)>		
        
        <!--- Get Host Family Information --->
        <cfquery name="qGetHostFamilyInfo" datasource="MySQL">
            SELECT 
            	h.initialHostAppType,
                h.hostAppStatus,
                h.familylastname, 
                h.applicationStarted, 
                h.applicationapproved, 
                h.applicationDenied, 
                h.email, 
                h.regionID, 
                h.arearepid, 
                h.reasonAppDenied, 
                h.lead, 
                h.hostAppStatus,
                r.regionname, 
                u.firstname as repFirst,
                u.lastname as repLast
            FROM 
                smg_hosts h
            LEFT JOIN 
                smg_regions r on r.regionID = h.regionID
            LEFT JOIN 
                smg_users u on u.userid = h.arearepid
            WHERE 
                h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.hostID#">
        </cfquery>

        <cfset CLIENT.hostfam = qGetHostFamilyInfo.familylastname>
        <cfset CLIENT.hostemail = qGetHostFamilyInfo.email>            
        
        <!--- Regional Manager --->
        <cfquery name="qGetRegionalManager" datasource="MySQL">
            SELECT 
                u.firstname, 
                u.lastname
            FROM 
                smg_users u
            LEFT OUTER JOIN 
                user_access_rights uar on uar.userid = u.userid
            WHERE 
                uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostFamilyInfo.regionID)#">
            AND
                uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
        </cfquery>
        
        <!--- Set status from "Started" to "Host" ---> 
        <cfif qGetHostFamilyInfo.hostAppStatus EQ 9>
        
            <cfquery datasource="MySQL">
                UPDATE 
                    smg_hosts
                SET 
                    hostAppStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
                WHERE 
                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.hostID#">
            </cfquery>
            
        </cfif>

    </cfif>

</cfsilent>

<style type="text/css">
.green {
	background-color: #E6F2D5;
	padding-left: 20px;
}
.gradientBack {
		background-image:url(images/faintGradient.png);
}
</style>

<cfoutput> 

<cfif NOT VAL(CLIENT.hostID)>

    <form method="post" action="index.cfm?page=hello">
    	<input type="hidden" name="submitted" value="1" />
		
        <h1 align="center">Host Family Application</h1>
        
        <p align="center">Please login to access your host family application. <br /></p>

		<cfif VAL(FORM.submitted)>
            <div align="center">
                <font color="##CC0000"><strong>The email and password you submitted do not match an account on file.<br />  Please check your information and try again.</strong></font>
            </div> <br />
        </cfif>
        
        <div style="display: block; padding: 10px; background-color: ##efefef; width: 400px; margin-left: auto; margin-right: auto; height: 300px;">
        	
            <div style="display: block; with: 200px; float: left;">
            	<img src="images/LoginIcon_2.png" width="196" height="140" />
            </div>
        
            <div style="padding-top: 30px;"> 
                <table align="center">
                    <tr>
                        <td>Email:</td>
                        <td><input type="text" name="username" size="30" /></td>
                    </tr>
                    <tr>
                        <td>Password:</td>
                        <td><input type="password" name="password" size="30" /></p></td>
                    </tr>
                    <tr>
                        <td colspan="2" align="right"><input name="login" type="submit" value="Login"  /></td>
                    </tr>
                </table>
            </div>
            
        </div>
        
    </form>

<cfelse>
    
    <!--- Application Overview --->
    <cfinclude template="appStatus.cfm">
    
    <h1 class="enter">Welcome #lcase(qGetHostFamilyInfo.familylastname)# Family!</h1>

    <table>
        <tr>
            <td><h3 align="Center">Application Overview</h3></td>
            <td></td>
            <td><h3 align="Center">Application Instructions / Announcements</h3></td>
        </tr>
        <tr>
            <td width=50% valign="top" class="green"> <br />

                <table width=95%>
                    <Tr>
                        <td>

                            <table   border=0 cellpadding=0 cellspacng=0 width=190 align="Center">
                                <tr class="gradientBack">
                                    <td  colspan=5 align="left" ><img src="images/gradient.png" alt="Percentage Complete" name="Percent Complete" width="#appNotComplete#" height=10 /></td>
                                </tr>
                                <tr>
                                    <td align="left" width=20%>0%</td>
                                    <td align="center" width=20%>25%</td>
                                    <td align="center" width=20%>50%</td>
                                    <td align="center" width=20%>75%</td>
                                    <td align="right" width=20%>100%</td>
                                </tr>
                            </table>
                            
                        </td>
                    </Tr>
                    <tr>
                        <td align="center">
                            <cfif qGetHostFamilyInfo.hostAppStatus LTE 7>
                                <strong><u>Submitted!</u></strong>
                            <cfelse>
                                <a href="index.cfm?page=checkList" style="text-align: left;">Review Check List</a>
                            </cfif>
                        </td>
                    </Tr>
                </table>
                
                <p>
                    <strong> Application Started -</strong> 
                    <cfif qGetHostFamilyInfo.applicationStarted is ''>
                        N/A
                    <cfelse>
                        #DateFormat(qGetHostFamilyInfo.applicationStarted, 'mmm d, yyyy')#
                    </cfif>
                </p>

                <p>
                    <strong>Application 
                    <cfif qGetHostFamilyInfo.applicationDenied is not ''>
                        Denied</strong> - #DateFormat(qGetHostFamilyInfo.applicationDenied, 'mmm d, yyyy')#<br />
                        For: 
                    <cfelse>
                        Approved</strong> -
                        <cfif qGetHostFamilyInfo.applicationApproved is ''>
                            Application in Progress
                        <cfelse>
                            #DateFormat(qGetHostFamilyInfo.applicationApproved, 'mmm d, yyyy')#
                        </cfif>
                    </cfif>
                </p>
                
                <hr align="center" width=80% />
                
                <p>
                    <strong>Region -</strong>
                    <cfif qGetHostFamilyInfo.regionID eq 0>
                        Not Assigned
                    <cfelse>
                        #qGetHostFamilyInfo.regionname#
                    </cfif>
                </p>
                
                <p>
                    <strong>Regional Manager -</strong> 
                    <cfif qGetHostFamilyInfo.regionID eq 0>
                        Not Assigned
                    <cfelse>
                        #qGetRegionalManager.firstname# #qGetRegionalManager.lastname#  
                    </cfif>
                </p>
                
                <p>
                    <strong>Area Representative -</strong> 
                    <cfif qGetHostFamilyInfo.regionID eq 0>
                        Not Assigned
                    <cfelse>
                        #qGetHostFamilyInfo.repFirst# #qGetHostFamilyInfo.repLast# 
                    </cfif>
                </p> 
                                       
            </td>
            <td>&nbsp;&nbsp;</td>
            <td>	
                <cfif qGetHostFamilyInfo.hostAppStatus LTE 7>
                    <h2 align="center">Thank you!</h2>
                    <p>Thats it!  Your application has been submitted for review.  You will hear from your local representative shortly.</p>
                <cfelse>
                    <p>Congratulations on the decission to host a student with ISE.  We are excited to be working with you.</p>
                    <div align="center">
                        <a href="index.cfm?page=startHostApp"><img src="images/buttons/contApp.png" alt="continue" border="0" /></a>
                    </div>
                    <p>
                        Your student's family will receive selected  information from this application. 
                        Student and their families will not receive any confidential infromation.  
                        Please be aware that the Department of State has specific requirements regarding the photos that are uploaded on the family album.  
                        We are mandated to have photos of specific areas of your home on file. 
                        <br /><br /> 
                        Before your applcation can be approved background checks will need to be run on all household members over the age of 18.
                        <br /><br />
                        If you have not already been in contact with a representative, you will be contacted shortly after your application is submitted.
                    </p>
                </cfif>
            </td>
        </tr>
    </table>
	
    <cfswitch expression="#qGetHostFamilyInfo.initialHostAppType#">
    
    	<cfcase value="1">
            <p style="background-color:##efefef;padding:10px">This account is not set up for the online applciation system.</p> <br />
        </cfcase>
        
    	<cfcase value="2">
            <p style="background-color:##efefef;padding:10px">
                The next 2 pages collect all the information that is needed to complete the background check. 
                A background check is required on anyone who is 17 years of age or older and living in the residence where the exchange student will be living.  
                Some or all of this information may be completed.  If it is, please review the information and then provide signatures on the approriate pages before submitting.  
            </p> <br />
            
            <div align="Center">
                <a href="index.cfm?page=startHostApp"><img src="../images/buttons/getStarted.png" alt="continue" border="0" /></a>
            </div> <br />
            
            <hr width=50% align="center"/> <br /><br />
            
            <h3><u>Department Of State Regulations</u></h3>
            <p>
                &dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(7)</a></strong><br />
                <em> 
                    Verify that each member of the host family household 18 years of age and older, as well as any new adult member added to the household, 
                    or any member of the host family household who will turn eighteen years of age during the exchange student's stay in that household, 
                    has undergone a criminal background check (which must include a search of the Department of Justice's National Sex Offender Public Registry);
                </em>               
            </p>
        </cfcase>
    
    </cfswitch>
        
</cfif>

</cfoutput>