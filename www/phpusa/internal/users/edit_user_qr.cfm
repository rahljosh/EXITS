<cfscript>
	qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(isActive=1,dateActive=1,companyID=6);
</cfscript>

<cfquery name="check_email" datasource="MySql">
	SELECT 
    	userid, 
        firstname, 
        lastname
	FROM 
    	smg_users
	WHERE 
    	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#"> 
	AND 
    	userid != <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userid#">		
</cfquery>

<cfquery name="check_username" datasource="MySql">
	SELECT 
    	userid,
        firstname,
        lastname
	FROM 
    	smg_users
	WHERE 
    	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.username#">
  	AND
		userid != <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userid#">
</cfquery>

<cfset total_errors = 0>
<cfloop from="1" to="4" index="i">
	<cfset form["error" & i] = ''>
</cfloop>

<cfoutput>

	<!--- BLANK USERNAME --->
	<cfif IsDefined('form.username') AND form.username EQ ''>  
		<cfset form.error1 = '<b>Username</b> is required. Please go back and fill it out.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	<!--- BLANK PASSWORD --->
	<cfif IsDefined('form.password') AND form.password EQ ''>  
		<cfset form.error2 = '<b>Password</b> is required. Please go back and fill it out.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	<!--- EMAIL IN USE --->
	<cfif check_email.recordcount>  
		<cfset form.error3 = 'Email <b>#form.email#</b> is current in use by account <b>#check_email.firstname# #check_email.lastname# ###check_email.userid#</b>. You must change it in order to continue.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	<!--- USERNAME IN USE --->
	<cfif IsDefined('form.username') AND check_username.recordcount>  
		<cfset form.error4 = 'Username <b>#form.username#</b> is current in use by account <b>#check_username.firstname# #check_username.lastname# ###check_username.userid#</b>. You must change it in order to continue.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	
	<cfif total_errors GT 0>
    
		<br />
		<table  bgcolor="FFFFFF" bordercolor="CCCCCC" border="1" height="100%" width="80%" align="center">
			<tr bordercolor="FFFFFF">
				<td>
					<table width=100% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
						<tr bgcolor="E4E4E4">
							<td class="title1">&nbsp; &nbsp; Edit User</td>
						</tr>
					</table>
                    <br>
					<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=90%>
						<tr>
                        	<th class="style1">PHP - Input Error</th>
                      	</tr>
						<tr>
                        	<td class="style1">Total of #total_errors# error(s) &nbsp; -  &nbsp; Please see list below.</td>
                      	</tr>
						<cfloop from="1" to="4" index="i">
							<cfif form["error" & i] NEQ ''>
								<tr>
                                	<td class="style1">#form["error" & i]#</td>
                              	</tr>
							</cfif>
						</cfloop>
						<tr>
                        	<td align="center" class="style1">
                            	<input type="image" value="back" src="pics/back.gif" onClick="javascript:history.back()">
                          	</td>
                      	</tr>		
					</table>
                    <br />
				</td>
			</tr>
		</table>
        <br />	
        	
		<cfabort>	
        
	</cfif>
    
</cfoutput>

<!--- Go through trainings, update if they exist otherwise insert --->
<cfloop query="qGetPrograms">
	<cfscript>
		qGetTrainingApproved = APPLICATION.CFC.User.getRepTraining(userID=#FORM.userID#,programID=#programID#);
	</cfscript>
    <cfif VAL(qGetTrainingApproved.recordCount)>
    	<cfquery datasource="#APPLICATION.DSN#">
        	UPDATE php_rep_season
            SET approvedTraining = <cfqueryparam cfsqltype="cf_sql_integer" value="#EVALUATE('FORM.training_#seasonID#')#">
            WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.userID)#">
            AND programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(programID)#">
        </cfquery>
    <cfelse>
    	<cfquery datasource="#APPLICATION.DSN#">
        	INSERT INTO php_rep_season (
            	userID,
                programID,
                approvedTraining )
           	VALUES (
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.userID)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(programID)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#EVALUATE('FORM.training_#programID#')#"> )
        </cfquery>
    </cfif>
</cfloop>

<cfquery name="update_users" datasource="MySql">
	UPDATE
    	smg_users
  	SET
    	firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.firstName#">,
        lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.lastName#">,
        address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
        address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
        city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
		<cfif IsDefined('FORM.country')>
        	country = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.country#">,
		</cfif>
		<cfif IsDefined('FORM.state')>
        	state = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.state#">,
		</cfif>
        zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
       	<cfif FORM.dob EQ ''>
        	dob = <cfqueryparam null="yes">,
      	<cfelse>
        	dob = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.dob)#">,
        </cfif>
        phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
        phone_ext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone_ext#">,
		work_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.work_phone#">,
		work_ext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.work_ext#">,
		cell_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cell_phone#">,
		fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fax#">,
        emergency_contact = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_contact#">,
        emergency_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_phone#">,
        businessname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.businessname#">,
        <cfif isDefined('FORM.php_payRep')>
            php_payRep = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.php_payRep#">,
            <cfif FORM.php_payRep EQ 1>
                php_repRate = <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(FORM.php_repRate,'9.99')#">,
            <cfelse>
                php_repRate = <cfqueryparam cfsqltype="cf_sql_float" value="0.00">,
            </cfif>
       	</cfif>
		<cfif IsDefined('form.php_contact_name')>
			php_contact_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.php_contact_name#">,
			php_contact_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.php_contact_phone#">,
			php_contact_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.php_contact_email#">,
            php_billing_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.php_billing_email#">,			
		</cfif>
		<cfif isDefined('form.billing_company')>
			billing_company = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_company#">,
			billing_address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_address#">,
			billing_address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_address2#">,
			billing_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_city#">,
			billing_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.billing_country#">,
			billing_zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_zip#">,
			billing_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_phone#">,
			billing_fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_fax#">,
			billing_contact = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_contact#">,
			billing_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_email#">,
		</cfif>
		<cfif IsDefined('form.password') AND form.password NEQ ''>
        	password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.password#">,
		</cfif>
		username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.username#">,
		email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">
	WHERE 
    	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userid#">
	LIMIT 1
</cfquery>

<cflocation url="?curdoc=users/user_info&id=#form.userid#" addtoken="no">