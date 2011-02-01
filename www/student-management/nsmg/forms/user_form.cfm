<cfparam name="url.userid" default="">
<cfif url.userid EQ "">
	<cfset new = true>
<cfelse>
	<cfif not isNumeric(url.userid)>
        a numeric userid is required.
        <cfabort>
	</cfif>
	<cfset new = false>
	<!--- CHECK RIGHTS --->
	<cfinclude template="../check_rights.cfm">
</cfif>

<cfset field_list = 'firstname,middlename,lastname,occupation,businessname,address,address2,city,state,zip,country,drivers_license,dob,ssn,sex,phone,phone_ext,work_phone,work_ext,cell_phone,fax,email,email2,skype_id,username,changepass,invoice_access,bypass_checklist,date_contract_received,active,datecancelled,datecreated,usebilling,billing_company,billing_contact,billing_address,billing_address2,billing_city,billing_country,billing_zip,billing_phone,billing_fax,billing_email,comments'>

<!--- the key for encrypting and decrypting the ssn. --->
<cfset ssn_key = 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR'>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>
	<!----Send email if address has changed---->
  
		<cfif (form.address neq form.prev_address or form.address2 neq form.prev_address2 or 
                form.city neq form.prev_city or form.state neq form.prev_state or form.zip neq form.prev_zip) and isDefined('url.new')>
            
             <cfoutput>
              <cfquery name="regional_Advisor_emails" datasource="#application.dsn#">
              	select uar.regionid
                from user_access_rights uar
                where userid = #url.userid#
              </cfquery>
               <cfset advisor_emails = ''>
               <cfloop query="regional_advisor_emails">
               <cfquery name="get_email" datasource="#application.dsn#">
               		select smg_users.email
                    from smg_users
                    left join user_access_rights on user_access_rights.userid = smg_users.userid
                    where user_Access_rights.regionid = #regionid# and user_access_rights.usertype = 5
               </cfquery>
               <cfset advisor_emails = #ListAppend(advisor_emails, '#get_email.email#')#>
               </cfloop>
               
                
                
              
             </cfoutput>
           <cfsavecontent variable="email_message">
           <cfoutput>
           NOTICE OF ADDRESS CHANGE<Br />
           <strong>#form.firstname# #form.lastname# (#url.userid#)</strong> has made a change to there address.<Br />
           <br />
           NEW ADDRESSS<br />
           #form.address#<br />
          <cfif form.address2 is not ''>#form.address2#<br /></cfif>
           #form.city# #form.state# #form.zip#<br /><br />
           
           PREVIOUS ADDRESS<br />
           #form.prev_address#<br />
          <cfif form.prev_address2 is not ''> #form.prev_address2#<br /></cfif>
           #form.prev_city# #form.state# #form.prev_zip#<br /><br />
           This is the only notification of this change that you will recieve.  Please update any records that do NOT pull information from EXITS.  
                </cfoutput>
           </cfsavecontent>
			
			<!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
          <Cfif client.companyid eq 10>
          		<cfinvokeargument name="email_to" value="stacy@case-usa.org">
          <Cfelse>
                <cfinvokeargument name="email_to" value="thea@iseusa.com,#client.programmanager_email#, #advisor_emails#">
		  </Cfif>				
					<!----
                <cfinvokeargument name="email_to" value="josh@pokytrails.com">
				---->
                <cfinvokeargument name="email_subject" value="Notice of Address Change">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_from" value="#client.support_email#">
            </cfinvoke>
            
       
        </cfif>


	<!--- checkboxes, radio buttons aren't defined if not checked. --->
    <cfparam name="form.sex" default="">
    <cfparam name="form.changepass" default="0">
    <cfparam name="form.bypass_checklist" default="0">
    <cfparam name="form.invoice_access" default="0">
    <cfparam name="form.active" default="0">
    <cfparam name="form.usebilling" default="0">
    

	<cfif isDefined("form.username")>
        <cfquery name="check_username" datasource="#application.dsn#">
            SELECT userid
            FROM smg_users 
            WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.username)#">
            <cfif not new>
                AND userid <> <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
            </cfif>
        </cfquery>
    </cfif>
    
	<cfif form.lookup_success NEQ "1">
		<cfset errorMsg = 'Please lookup the address.'>
	<cfelseif trim(form.firstname) EQ ''>
		<cfset errorMsg = "Please enter the First Name.">
	<cfelseif trim(form.lastname) EQ ''>
		<cfset errorMsg = "Please enter the Last Name.">
	<cfelseif form.usertype EQ 8 and trim(form.address) EQ ''>
		<cfset errorMsg = "Please enter the Address.">
	<cfelseif form.usertype EQ 8 and trim(form.city) EQ ''>
		<cfset errorMsg = "Please enter the City.">
	<cfelseif form.usertype EQ 8 and trim(form.country) EQ ''>
		<cfset errorMsg = "Please select the Country.">
	<cfelseif form.usertype NEQ 8 and application.address_lookup NEQ 2 and trim(form.address) EQ ''>
		<cfset errorMsg = "Please enter the Address.">
	<cfelseif form.usertype NEQ 8 and application.address_lookup NEQ 2 and trim(form.city) EQ ''>
		<cfset errorMsg = "Please enter the City.">
	<cfelseif form.usertype NEQ 8 and application.address_lookup NEQ 2 and trim(form.state) EQ ''>
		<cfset errorMsg = "Please select the State.">
	<cfelseif form.usertype NEQ 8 and application.address_lookup NEQ 2 and not isValid("zipcode", trim(form.zip))>
		<cfset errorMsg = "Please enter a valid Zip.">
	<cfelseif trim(form.dob) NEQ '' and not isValid("date", trim(form.dob))>
		<cfset errorMsg = "Please enter a valid Birthdate.">
	<cfelseif isDefined("form.ssn") and trim(form.ssn) NEQ '' and not isValid("social_security_number", trim(form.ssn))>
		<cfset errorMsg = "Please enter a valid SSN.">
	<cfelseif trim(form.phone) EQ '' and trim(form.work_phone) EQ '' and trim(form.cell_phone) EQ ''>
		<cfset errorMsg = "Please enter one of the Phone fields.">
    <!---    
	<cfelseif form.usertype NEQ 8 and trim(form.phone) NEQ '' and not isValid("telephone", trim(form.phone))> 
		<cfset errorMsg = "Please enter a valid Home Phone.">
	<cfelseif form.usertype NEQ 8 and trim(form.work_phone) NEQ '' and not isValid("telephone", trim(form.work_phone))> 
		<cfset errorMsg = "Please enter a valid Work Phone.">
	<cfelseif form.usertype NEQ 8 and trim(form.cell_phone) NEQ '' and not isValid("telephone", trim(form.cell_phone))> 
		<cfset errorMsg = "Please enter a valid Cell Phone.">
	<cfelseif form.usertype NEQ 8 and trim(form.fax) NEQ '' and not isValid("telephone", trim(form.faX)) >
		<cfset errorMsg = "Please enter a valid Fax.">
	--->		
	<cfelseif not isValid("email", trim(form.email))>
		<cfset errorMsg = "Please enter a valid Email.">
	<cfelseif trim(form.email2) NEQ '' and not isValid("email", trim(form.email2))>
		<cfset errorMsg = "Please enter a valid Alt. Email.">
	<cfelseif isDefined("form.username") and trim(form.username) EQ ''>
		<cfset errorMsg = "Please enter the Username.">
	<cfelseif isDefined("form.username") and check_username.recordcount NEQ 0>
		<cfset errorMsg = "Sorry, this Username has already been entered in the database.">
	<cfelseif new and trim(form.password) EQ ''>
		<cfset errorMsg = "Please enter the Password.">
	<cfelseif new and trim(form.confirm_password) EQ ''>
		<cfset errorMsg = "Please confirm the Password.">
	<cfelseif new and trim(form.password) NEQ trim(form.confirm_password)>
		<cfset errorMsg = "Password and Confirm Password do not match.">
	<cfelseif trim(form.date_contract_received) NEQ '' and not isValid("date", trim(form.date_contract_received))>
		<cfset errorMsg = "Please enter a valid Contract Received.">
	<cfelseif trim(form.datecancelled) NEQ '' and not isValid("date", trim(form.datecancelled))>
		<cfset errorMsg = "Please enter a valid Date Cancelled.">
	<cfelseif isDefined("form.billing_email") and trim(form.billing_email) NEQ '' and not isValid("email", trim(form.billing_email))>
		<cfset errorMsg = "Please enter a valid Billing Info Email.">
	<cfelse>
    	<!--- encrypt the SSN. --->
		<cfif isDefined("form.ssn") and trim(form.ssn) NEQ ''>
            <cfset form.ssn = encrypt("#trim(form.ssn)#", "#ssn_key#", "desede", "hex")>
        </cfif>
		<cfif new>
        	
			<!--- these fields aren't always displayed. --->
            <cfparam name="form.comments" default="">
            <!--- default to USA for non-international users. --->
            <cfparam name="form.country" default="USA">
            
        	<cflock timeout="30">
                <cfquery datasource="#application.dsn#">
                    INSERT INTO smg_users (uniqueid, datecreated, firstname, middlename, lastname, occupation, businessname,
                    	address, address2, city, state, zip, country,
                    	drivers_license, dob, sex, ssn, phone, phone_ext, work_phone, work_ext, cell_phone, fax, email, email2, skype_id,
                        username, password, changepass, bypass_checklist, invoice_access, date_contract_received, active, datecancelled,
						<cfif form.usertype EQ 8>
							usertype, 
                            usebilling, 
                            billing_company, 
                            billing_contact, 
                            billing_address, 
                            billing_address2, 
                            billing_city, 
                            billing_country, 
                            billing_zip, 
                            billing_phone, 
                            billing_fax, 
                            billing_email,
                        </cfif>
                        comments, whocreated, accountCreationVerified, dateAccountVerified)
                    VALUES (
                    <cfqueryparam cfsqltype="cf_sql_idstamp" value="#createuuid()#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.firstname#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.middlename#" null="#yesNoFormat(trim(form.middlename) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.lastname#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.occupation#" null="#yesNoFormat(trim(form.occupation) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.businessname#" null="#yesNoFormat(trim(form.businessname) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address#" null="#yesNoFormat(trim(form.address) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address2#" null="#yesNoFormat(trim(form.address2) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.city#" null="#yesNoFormat(trim(form.city) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.state#" null="#yesNoFormat(trim(form.state) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.zip#" null="#yesNoFormat(trim(form.zip) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.country#" null="#yesNoFormat(trim(form.country) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.drivers_license#" null="#yesNoFormat(trim(form.drivers_license) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#form.dob#" null="#yesNoFormat(trim(form.dob) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sex#" null="#yesNoFormat(trim(form.sex) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ssn#" null="#yesNoFormat(trim(form.ssn) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#" null="#yesNoFormat(trim(form.phone) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone_ext#" null="#yesNoFormat(trim(form.phone_ext) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.work_phone#" null="#yesNoFormat(trim(form.work_phone) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.work_ext#" null="#yesNoFormat(trim(form.work_ext) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cell_phone#" null="#yesNoFormat(trim(form.cell_phone) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#" null="#yesNoFormat(trim(form.fax) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email2#" null="#yesNoFormat(trim(form.email2) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.skype_id#" null="#yesNoFormat(trim(form.skype_id) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.username#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.password#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#form.changepass#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#form.bypass_checklist#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#form.invoice_access#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#form.date_contract_received#" null="#yesNoFormat(trim(form.date_contract_received) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#form.active#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#form.datecancelled#" null="#yesNoFormat(trim(form.datecancelled) EQ '')#">,
                    <cfif form.usertype EQ 8>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.usertype#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#form.usebilling#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_company#" null="#yesNoFormat(trim(form.billing_company) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_contact#" null="#yesNoFormat(trim(form.billing_contact) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_address#" null="#yesNoFormat(trim(form.billing_address) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_address2#" null="#yesNoFormat(trim(form.billing_address2) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_city#" null="#yesNoFormat(trim(form.billing_city) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_country#" null="#yesNoFormat(trim(form.billing_country) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_zip#" null="#yesNoFormat(trim(form.billing_zip) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_phone#" null="#yesNoFormat(trim(form.billing_phone) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_fax#" null="#yesNoFormat(trim(form.billing_fax) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_email#" null="#yesNoFormat(trim(form.billing_email) EQ '')#">,
                    </cfif>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.comments#" null="#yesNoFormat(trim(form.comments) EQ '')#">
                   , #client.userid#,
                   <cfif client.usertype lte 4>#client.userid#<cfelse>0</cfif>,
                    <cfif client.usertype lte 4>#now()#<cfelse>null</cfif>
                   
                    )  
                </cfquery>
                <cfquery name="get_id" datasource="#application.dsn#">
                    SELECT MAX(userid) AS userid
                    FROM smg_users 
                </cfquery>
            </cflock>
            <cfif form.usertype eq 8>
            <cfoutput>
            <cfsavecontent variable="email_message">
            This email is to notify you that a new agent profile has been created by #client.name#. This email is a reminder for the following:<br /><br />
            <strong>Ellen</strong> - Please send out a contract to that Agent<br />
            <strong>Marcel</strong> - Please make sure you have a price, insurance, and SEVIS option.<br />
            <strong>Brian</strong> - Make sure this agent has been issued an allocation<br /><br />
            Agent Info: <a href="#exits_url#/nsmg/index.cfm?curdoc=user_info&userid=">#form.businessname#</a>
            </cfsavecontent>
			</cfoutput>
			<!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="ellen@iseusa.com,marcel@iseusa.com,bhause@iseusa.com">
                <cfinvokeargument name="email_subject" value="New Agent Profile">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_from" value="#client.emailfrom#">
            </cfinvoke>
            </cfif>
            <!--- add company & regional access record only for usertype 8. --->
            <cfif form.usertype EQ 8>
                <cfquery datasource="#application.dsn#">
                    INSERT INTO user_access_rights (userid, companyid, usertype, default_access)
                    VALUES (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#get_id.userid#">,
                    5, 8, 1
                    )  
                </cfquery>
            </cfif>
            
			<!--- send email --->
            <cfif (form.usertype NEQ 8 AND client.usertype neq 5) >
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="#form.email#">
					<cfinvokeargument name="email_replyto" value="#client.email#">
                    <cfinvokeargument name="email_subject" value="New Account Created / Login Information">
                    <cfinvokeargument name="include_content" value="send_login">
                    <cfinvokeargument name="userid" value="#get_id.userid#">
                </cfinvoke>
            </cfif>

            <!--- company & regional access record was added above for usertype 8, so go to user info page. --->
            <cfif form.usertype EQ 8>
            	<cflocation url="index.cfm?curdoc=user_info&userid=#get_id.userid#" addtoken="No">
            <!--- go to company & regional access page.
			usertype is passed because that was selected on add_user.cfm, so we need to disable it on the access rights form. --->
            <cfelse>
            	<cflocation url="index.cfm?curdoc=forms/access_rights_form&userid=#get_id.userid#&usertype=#form.usertype#&new_user=1" addtoken="No">
            </cfif>
            
		<!--- edit --->
		<cfelse>
        
			<cfquery datasource="#application.dsn#">
				UPDATE smg_users SET
                lastchange = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.firstname#">,
                middlename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.middlename#" null="#yesNoFormat(trim(form.middlename) EQ '')#">,
                lastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.lastname#">,
                occupation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.occupation#" null="#yesNoFormat(trim(form.occupation) EQ '')#">,
                businessname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.businessname#" null="#yesNoFormat(trim(form.businessname) EQ '')#">,
                address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address#" null="#yesNoFormat(trim(form.address) EQ '')#">,
                address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address2#" null="#yesNoFormat(trim(form.address2) EQ '')#">,
                city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.city#" null="#yesNoFormat(trim(form.city) EQ '')#">,
                state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.state#" null="#yesNoFormat(trim(form.state) EQ '')#">,
                zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.zip#" null="#yesNoFormat(trim(form.zip) EQ '')#">,
                drivers_license = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.drivers_license#" null="#yesNoFormat(trim(form.drivers_license) EQ '')#">,
                dob = <cfqueryparam cfsqltype="cf_sql_date" value="#form.dob#" null="#yesNoFormat(trim(form.dob) EQ '')#">,
                sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sex#" null="#yesNoFormat(trim(form.sex) EQ '')#">,
                <cfif isDefined("form.ssn")>
                	ssn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ssn#" null="#yesNoFormat(trim(form.ssn) EQ '')#">,
                </cfif>
                phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#" null="#yesNoFormat(trim(form.phone) EQ '')#">,
                phone_ext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone_ext#" null="#yesNoFormat(trim(form.phone_ext) EQ '')#">,
                work_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.work_phone#" null="#yesNoFormat(trim(form.work_phone) EQ '')#">,
                work_ext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.work_ext#" null="#yesNoFormat(trim(form.work_ext) EQ '')#">,
                cell_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cell_phone#" null="#yesNoFormat(trim(form.cell_phone) EQ '')#">,
                fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#" null="#yesNoFormat(trim(form.fax) EQ '')#">,
                email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,
                email2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email2#" null="#yesNoFormat(trim(form.email2) EQ '')#">,
                <cfif isDefined("form.username")>
                	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.username#">,
                </cfif>
				<cfif client.usertype LTE 4>
					changepass = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.changepass#">,
					bypass_checklist = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.bypass_checklist#">,
                </cfif>
				<cfif client.usertype EQ 1>
					invoice_access = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.invoice_access#">,
                </cfif>
				<cfif client.usertype LTE 4>
					date_contract_received = <cfqueryparam cfsqltype="cf_sql_date" value="#form.date_contract_received#" null="#yesNoFormat(trim(form.date_contract_received) EQ '')#">,
					active = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.active#">,
                    datecancelled = <cfqueryparam cfsqltype="cf_sql_date" value="#form.datecancelled#" null="#yesNoFormat(trim(form.datecancelled) EQ '')#">,
                </cfif>
				<cfif form.usertype EQ 8>
                    country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.country#" null="#yesNoFormat(trim(form.country) EQ '')#">,
					usebilling = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.usebilling#">,
	                billing_company = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_company#" null="#yesNoFormat(trim(form.billing_company) EQ '')#">,
	                billing_contact = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_contact#" null="#yesNoFormat(trim(form.billing_contact) EQ '')#">,
	                billing_address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_address#" null="#yesNoFormat(trim(form.billing_address) EQ '')#">,
	                billing_address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_address2#" null="#yesNoFormat(trim(form.billing_address2) EQ '')#">,
	                billing_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_city#" null="#yesNoFormat(trim(form.billing_city) EQ '')#">,
	                billing_country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_country#" null="#yesNoFormat(trim(form.billing_country) EQ '')#">,
	                billing_zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_zip#" null="#yesNoFormat(trim(form.billing_zip) EQ '')#">,
	                billing_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_phone#" null="#yesNoFormat(trim(form.billing_phone) EQ '')#">,
	                billing_fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_fax#" null="#yesNoFormat(trim(form.billing_fax) EQ '')#">,
	                billing_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.billing_email#" null="#yesNoFormat(trim(form.billing_email) EQ '')#">,
                </cfif>
                <cfif isDefined("form.comments")>
                    comments = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.comments#" null="#yesNoFormat(trim(form.comments) EQ '')#">,
                </cfif>
                skype_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.skype_id#" null="#yesNoFormat(trim(form.skype_id) EQ '')#">
				WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
			</cfquery>
            <cflocation url="index.cfm?curdoc=user_info&userid=#url.userid#" addtoken="No">
            
		</cfif>
	</cfif>

<!--- add --->
<cfelseif new>

	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = "">
	</cfloop>
    
	<cfset form.allow_ssn = 1>
    
    <!--- we're coming from add_user.cfm --->
    <cfset form.usertype = url.usertype>
    <cfset temp_password = "temp#RandRange(100000, 999999)#">
    
    <cfset form.password = temp_password>
    <cfset form.confirm_password = temp_password>
    <cfset form.changepass = 1>
    <cfset form.datecreated = now()>
    <!----If Regional Manager is creating account, set active to NO.  Once approved, account will be set to active.---->
	<cfif client.usertype eq 5>
    	<cfset form.active = 0>
    <cfelse>
		<cfset form.active = 1>
	</cfif>
    <!--- International users don't have the lookup. --->
    <cfif form.usertype EQ 8>
		<cfset form.lookup_success = 1>
	<cfelse>
		<!--- lookup_success must be 0 to require lookup on add. --->
		<cfset form.lookup_success = 0>
        <cfset form.lookup_address = ''>
    </cfif>
   
<!--- edit --->
<cfelseif not new>

	<cfquery name="get_record" datasource="#application.dsn#">
		SELECT *
		FROM smg_users
		WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
	</cfquery>
	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = evaluate("get_record.#counter#")>
	</cfloop>
    
    <cfquery name="user_compliance" datasource="#application.dsn#">
        SELECT compliance
        FROM smg_users
        WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    </cfquery>
	<cfset form.allow_ssn = 0>
	<!--- SSN: allow if null, or if not null and the user has access. --->
	<cfif get_record.ssn EQ '' or user_compliance.compliance EQ 1>
		<cfset form.allow_ssn = 1>
        <cfif get_record.ssn NEQ ''>
			<cfset form.ssn = decrypt(get_record.ssn, "#ssn_key#", "desede", "hex")>
        </cfif>
	</cfif>

	<!--- get the access level of the user viewed.
	If null, then user viewing won't have access to username, etc. --->
    <cfinvoke component="nsmg.cfc.user" method="get_access_level" returnvariable="form.usertype">
        <cfinvokeargument name="userid" value="#url.userid#">
    </cfinvoke>

    <!--- International users don't have the lookup. --->
    <cfif form.usertype EQ 8>
		<cfset form.lookup_success = 1>
	<cfelse>
		<!--- lookup_success may be set to 1 to not require lookup on edit. --->
		<cfset form.lookup_success = 0>
        <cfset form.lookup_address = '#get_record.address##chr(13)##chr(10)##get_record.city# #get_record.state# #get_record.zip#'>
    </cfif>
   
</cfif>

<cfif isDefined("errorMsg")>
	<script language="JavaScript">
        alert('<cfoutput>#errorMsg#</cfoutput>');
    </script>
</cfif>

<!--- address lookup turned on. --->
<cfif application.address_lookup>
	<cfinclude template="../includes/address_lookup_#application.address_lookup#.cfm">
<!--- address lookup turned off. --->
<cfelse>
	<!--- set to true so lookup is not required. --->
	<cfset form.lookup_success = 1>
</cfif>

<script type="text/javascript">
function checkForm() {
	<cfif form.usertype EQ 8>
		if (document.my_form.country.value.length == 0) {alert("Please select the Country."); return false; }
	</cfif>
	<cfif form.usertype NEQ 8 and application.address_lookup NEQ 2>
		if (document.my_form.state.value.length == 0) {alert("Please select the State."); return false; }
	</cfif>
	if (document.my_form.lookup_success.value != 1) {alert("Please lookup the address."); return false; }
	if (document.my_form.phone.value.length == 0 && document.my_form.work_phone.value.length == 0 && document.my_form.cell_phone.value.length == 0) {alert("Please enter one of the Phone fields."); return false; }
	<cfif new>
		if (document.my_form.password.value != document.my_form.confirm_password.value) {alert("Password and Confirm Password do not match."); return false; }
	</cfif>
	return true;
}
function CopyContact() {
	if (document.my_form.copycontact.checked) {
	document.my_form.billing_company.value = document.my_form.businessname.value;
	document.my_form.billing_contact.value = document.my_form.firstname.value+' '+document.my_form.lastname.value;
	document.my_form.billing_address.value = document.my_form.address.value;
	document.my_form.billing_address2.value = document.my_form.address2.value;
	document.my_form.billing_city.value = document.my_form.city.value;      
	document.my_form.billing_country.value = document.my_form.country.value;
	document.my_form.billing_zip.value =  document.my_form.zip.value;
	document.my_form.billing_phone.value =  document.my_form.phone.value;
	document.my_form.billing_fax.value = document.my_form.fax.value;
	document.my_form.billing_email.value = document.my_form.email.value;
	}
	else {
	document.my_form.billing_company.value = '';
	document.my_form.billing_contact.value = '';
	document.my_form.billing_address.value =  '';
	document.my_form.billing_address2.value = '';
	document.my_form.billing_city.value = '';      
	document.my_form.billing_country.value = '';
	document.my_form.billing_zip.value =  ''; 
	document.my_form.billing_phone.value =  '';
	document.my_form.billing_fax.value = '';
	document.my_form.billing_email.value = '';
   }
}
function CopyEmail() {
	document.my_form.username.value = document.my_form.email.value;
}
</script>

<!--- this table is so the form is not 100% width. --->
<table align="center">
  <tr>
    <td>

<!----Header Format Table---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign="middle" height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
		<td background="pics/header_background.gif"><h2>User Information</td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="index.cfm?curdoc=forms/user_form&userid=#url.userid#" method="post" name="my_form" onSubmit="return checkForm();">
<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="allow_ssn" value="#form.allow_ssn#">
<cfinput type="hidden" name="usertype" value="#form.usertype#">
<!--- this gets set to 1 by the javascript lookup function on success. --->
<cfinput type="hidden" name="lookup_success" value="#form.lookup_success#">

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td>

<span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; + One phone field is required</span>
<table width="100%">
	<tr valign="top">
		<td>
        
			<table>
            <tr>
                <td colspan=2 bgcolor="CCCCCC"><u>Personal Information</u></td>
            </tr>
            <tr>
            	<td align="right">First Name: <span class="redtext">*</span></td>
                <td><cfinput type="text" name="firstname" value='#form.firstname#' size="20" maxlength="100" required="yes" validate="noblanks" message="Please enter the First Name."></td>
            </tr>
            <tr>
            	<td align="right">Middle Name:</td>
                <td><cfinput type="text" name="middlename" value="#form.middlename#" size="20" maxlength="50"></td>
            </tr>
            <tr>
            	<td align="right">Last Name: <span class="redtext">*</span></td>
                <td><cfinput type="text" name="lastname" value="#form.lastname#" size="20" maxlength="100" required="yes" validate="noblanks" message="Please enter the Last Name."></td>
            </tr>
            <tr>
                <td align="right">Occupation:</td>
                <td><cfinput type="text" name="occupation" value="#occupation#" size="40" maxlength="150"></td>
            </tr>
            <tr>
                <td align="right">Company Name:</td>
                <td><cfinput type="text" name="businessname" value="#form.businessname#" size="40" maxlength="150"></td>
            </tr>

		<!---- Int. Reps ---->
        <cfif form.usertype EQ 8>

            <cfquery name="country_list" datasource="#application.dsn#">
                select countryname, countryid
                from smg_countrylist
                ORDER BY countryname
            </cfquery>

            <tr>
            	<td align="right">Address: <span class="redtext">*</span></td>
                <td><cfinput type="text" name="address" value="#form.address#" size="40" maxlength="150" required="yes" validate="noblanks" message="Please enter the Address."> <input type="hidden"  name="prev_address" value="#form.address#" /></td>
            </tr>
            <tr>
            	<td align="right"></td>
                <td><cfinput type="text" name="address2" value="#form.address2#" size="40" maxlength="150"><input type="hidden"  name="prev_address2" value="#form.address2#" /></td>
            </tr>
            <tr>
            	<td align="right">City: <span class="redtext">*</span></td>
                <td><cfinput type="text" name="city" value="#form.city#" size="20" maxlength="150" required="yes" validate="noblanks" message="Please enter the City."><input type="hidden"  name="prev_city" value="#form.city#" /></td>
            </tr>
            <tr>
                <td align="right">State:</td>
                <td><cfinput type="text" name="state" value="#form.state#" size="20" maxlength="20"><input type="hidden"  name="prev_state" value="#form.state#" /></td>
            </tr>
            <tr>
            	<td align="right">Postal Code (Zip):</td>
                <td><cfinput type="text" name="zip" value="#form.zip#" size="10" maxlength="10"><input type="hidden"  name="prev_zip" value="#form.zip#" /></td>
            </tr>
            <tr>
                <td align="right">Country: <span class="redtext">*</span></td>
                <td>
                    <cfselect NAME="country" query="country_list" value="countryid" display="countryname" selected="#form.country#" queryPosition="below">
                        <option value=""></option>
                    </cfselect>
                </td>
            </tr>

		<cfelse>

			<!--- address lookup - auto version. --->
            <cfif application.address_lookup EQ 2>
                <tr>
                    <td align="right">Lookup Address: <span class="redtext">*</span></td>
                    <td>
                        Enter at least the street address and zip code and click "Lookup".<br />
                        Address, City, State, and Zip will be automatically filled in.<br />
                        Address line 2 should be manually entered if needed.<br />
                        <cftextarea name="lookup_address" rows="2" cols="30" value="#form.lookup_address#" /><br />
                        <input type="button" value="Lookup" onClick="showLocation();" />                
                    </td>
                </tr>
                <tr>
                    <td align="right">Address:</td>
                    <td><cfinput type="text" name="address" value="#form.address#" size="40" maxlength="150" readonly="readonly"></td>
                </tr>
                <tr>
                    <td align="right"></td>
                    <td><cfinput type="text" name="address2" value="#form.address2#" size="40" maxlength="150"></td>
                </tr>
                <tr>
                    <td align="right">City:</td>
                    <td><cfinput type="text" name="city" value="#form.city#" size="20" maxlength="150" readonly="readonly"></td>
                </tr>
                <tr>
                    <td align="right">State:</td>
                    <td><cfinput type="text" name="state" value="#form.state#" size="2" maxlength="2" readonly="readonly"></td>
                </tr>
                <tr>
                    <td align="right">Zip:</td>
                    <td><cfinput type="text" name="zip" value="#form.zip#" size="10" maxlength="10" readonly="readonly"></td>
                </tr>
            <cfelse>
                <tr>
                    <td align="right">Address: <span class="redtext">*</span></td>
                    <td>
                    	<cfinput type="text" name="address" value="#form.address#" size="40" maxlength="150" required="yes" validate="noblanks" message="Please enter the Address."><cfinput type="hidden"  name="prev_address" value="#form.address#" />
			            <font size="1">NO PO BOXES</font>
                    </td>
                </tr>
                <tr>
                    <td align="right"></td>
                    <td><cfinput type="text" name="address2" value="#form.address2#" size="40" maxlength="150"><cfinput type="hidden"  name="prev_address2" value="#form.address2#" /></td>
                </tr>
                <tr>
                    <td align="right">City: <span class="redtext">*</span></td>
                    <td><cfinput type="text" name="city" value="#form.city#" size="20" maxlength="150" required="yes" validate="noblanks" message="Please enter the City."><cfinput type="hidden"  name="prev_city" value="#form.city#" /></td>
                </tr>
                <tr>
                    <td align="right">State: <span class="redtext">*</span></td>
                    <td>
                        <cfquery name="get_states" datasource="#application.dsn#">
                            SELECT state, statename
                            FROM smg_states
                            ORDER BY id
                        </cfquery>
                        <cfselect NAME="state" query="get_states" value="state" display="statename" selected="#form.state#" queryPosition="below">
                            <option></option>
                        </cfselect>
                        <cfinput type="hidden"  name="prev_state" value="#form.state#" />
                    </td>
                </tr>
                <tr>
                    <td align="right">Zip: <span class="redtext">*</span></td>
                    <td><cfinput type="text" name="zip" value="#form.zip#" size="10" maxlength="10" required="yes" validate="zipcode" message="Please enter a valid Zip."><cfinput type="hidden"  name="prev_zip" value="#form.zip#" /></td>
                </tr>
				<!--- address lookup - simple version. --->
                <cfif application.address_lookup EQ 1>
                    <tr>
                        <td align="right">Lookup Address: <span class="redtext">*</span></td>
                        <td><font size="1">
                            Enter Address, City, State, and Zip and click "Lookup".<br />
                            Verify the address displayed below, and make any corrections on the form if necessary.<br />
                            Address line 2 will not be included below.<br />
                            If you have trouble submitting an address, <a href="mailto:<cfoutput>#application.support_email#</cfoutput>?subject=Address Lookup">send it to us</a>.<br />
                            <input type="button" value="Lookup" onClick="showLocation();" /><br />
                            <textarea name="lookup_address" readonly="readonly" rows="2" cols="30">Lookup address will be displayed here.</textarea>
                        </font></td>
                    </tr>
                </cfif>
            </cfif>

        </cfif>
                    
            <tr>
                <td align="right">Drivers License:</td>
                <td><cfinput type="text" name="drivers_license" value="#form.drivers_license#" size="20" maxlength="50"></td>
            </tr>
            <tr>
                <td align="right">Birthdate:</td>
                <td><cfinput type="text" name="dob" value="#DateFormat(form.dob,'mm/dd/yyyy')#" size="10" maxlength="10" mask="99/99/9999" validate="date" message="Please enter a valid Birthdate."> mm/dd/yyyy</td>
            </tr>
            <tr>
                <td align="right">Sex:</td>
                <td>
                	<cfinput type="radio" name="sex" value="Male" checked="#yesNoFormat(form.sex EQ 'Male')#">Male
                    <cfinput type="radio" name="sex" value="Female" checked="#yesNoFormat(form.sex EQ 'Female')#">Female
                </td>
            </tr>
			<cfif form.allow_ssn>
                <tr>
                	<td class="label">SSN:</td>
                    <td><cfinput type="text" name="ssn" value="#form.ssn#" size="11" maxlength="11" mask="999-99-9999" validate="social_security_number" message="Please enter a valid SSN."></td>
                </tr>	
            </cfif>
			</table>
            
		</td>
		<td>
       
			<table border="0" width="100%">
				<tr>
                	<td colspan=2 bgcolor="CCCCCC"><u>Contact Information</u></td>
                </tr>
				<cfif not new and form.usertype NEQ 8>
                    <tr>
                        <td colspan="2"><font size="1">
                            Masks were recently added to the Phone and Fax fields with (999) 999-9999 format.<br>
                            Existing values with 999-999-9999 format might be displayed incorrectly<br />
							and you will not be able to submit the form.<br>
                            Please verify the existing values displayed next to the form field and re-enter if necessary.
                        </font></td>
                    </tr>
                </cfif>
			  	<tr>
					<td align="right">Home Phone: <span class="redtext">+</span></td>
					<td>
						<!---- Int. Reps ---->
                        <cfif form.usertype EQ 8>
                    		<cfinput type="text" name="phone" value="#form.phone#" size="20" maxlength="25">
                    	<cfelse>
							<cfinput type="text" name="phone" value="#form.phone#" size="14" maxlength="14" mask="(999) 999-9999"> <!--- validate="telephone" message="Please enter a valid Home Phone." --->
							<cfoutput>#form.phone#</cfoutput>
                        </cfif>
                        &nbsp; Ext. <cfinput type="text" name="phone_ext" value="#form.phone_ext#" size="5" maxlength="11">
                    </td>
				</tr>
				  	<tr>
					<td align="right">Work Phone: <span class="redtext">+</span></td>
					<td>
						<!---- Int. Reps ---->
                        <cfif form.usertype EQ 8>
                            <cfinput type="text" name="work_phone" value="#form.work_phone#" size="20" maxlength="25">
                    	<cfelse>
							<cfinput type="text" name="work_phone" value="#form.work_phone#" size="14" maxlength="14" mask="(999) 999-9999"> <!--- validate="telephone" message="Please enter a valid Work Phone." --->
							<cfoutput>#form.work_phone#</cfoutput>
                        </cfif>
                    	&nbsp; Ext. <cfinput type="text" name="work_ext" value="#form.work_ext#" size="5" maxlength="11">
                    </td>
				</tr>
				  	<tr>
					<td align="right">Cell Phone: <span class="redtext">+</span></td>
					<td>
						<!---- Int. Reps ---->
                        <cfif form.usertype EQ 8>
                            <cfinput type="text" name="cell_phone" value="#form.cell_phone#" size="20" maxlength="25">
                    	<cfelse>
							<cfinput type="text" name="cell_phone" value="#form.cell_phone#" size="14" maxlength="14" mask="(999) 999-9999"> <!--- validate="telephone" message="Please enter a valid Cell Phone." --->
							<cfoutput>#form.cell_phone#</cfoutput>
                        </cfif>
                    </td>
				</tr>
				<tr>
					<td align="right">Fax:</td>
					<td>
						<!---- Int. Reps ---->
                        <cfif form.usertype EQ 8>
                            <cfinput type="text" name="fax" value="#form.fax#" size="20" maxlength="20">
                    	<cfelse>
							<cfinput type="text" name="fax" value="#form.fax#" size="14" maxlength="14" mask="(999) 999-9999"> <!--- validate="telephone" message="Please enter a valid Fax." ---> 
							<cfoutput>#form.fax#</cfoutput>
                        </cfif>
                    </td>
				</tr>
				<tr>
					<td align="right">Email: <span class="redtext">*</span></td>
					<td>
                    	<cfif new>
                        	Login information will be sent on creation of account.<br>
							Leave email address blank for no email address,<br />
							no email / error will be generated .<br />
                        	<cfinput type="text" name="email" value="#form.email#" size="30" maxlength="150" required="yes" validate="email" message="Please enter a valid Email." onchange="javascript:CopyEmail()">
                        <cfelse>
                        	<cfinput type="text" name="email" value="#form.email#" size="30" maxlength="150" required="yes" validate="email" message="Please enter a valid Email.">
                        </cfif>
                    </td>
				</tr>
				<tr>
					<td align="right">Alt. Email:</td>
					<td><cfinput type="text" name="email2" value="#form.email2#" size="30" maxlength="150" validate="email" message="Please enter a valid Alt. Email."></td>
				</tr>
				<tr>
					<td align="right">Skype ID:</td>
					<td><cfinput type="text" name="skype_id" value="#form.skype_id#" size="30" maxlength="100"></td>
				</tr>
				<tr>
                	<td colspan=2>&nbsp;</td>
                </tr>
				<tr>
                	<td colspan=2 bgcolor="CCCCCC"><u>Login Information</u></td>
                </tr>
                
				<cfif new or client.usertype LTE 4 or client.usertype lt form.usertype or client.userid eq url.userid>
                    <tr>
                        <td align="right">Username: <span class="redtext">*</span></td>
                        <td>
							<cfif new>
                                Username defaults to email address, change if desired.<br />
                            </cfif>
                            <cfinput type="text" name="username" value="#form.username#" size="30" maxlength="100" required="yes" validate="noblanks" message="Please enter the Username.">
                        </td>
                    </tr>
                </cfif>
                <!--- allow them to change password if needed on new user, or use default random password. --->
				<cfif new>
                    <tr>
                        <td align="right">Password: <span class="redtext">*</span></td>
                        <td><cfinput type="password" name="password" value="#form.password#" size="20" maxlength="15" required="yes" validate="noblanks" message="Please enter the Password."></td>
                    </tr>
                    <tr>
                        <td align="right">Confirm Password: <span class="redtext">*</span></td>
                        <td><cfinput type="password" name="confirm_password" value="#form.confirm_password#" size="20" maxlength="15" required="yes" validate="noblanks" message="Please confirm the Password."></td>
                    </tr>
                </cfif>
                    
				<cfif client.usertype LTE 4>
                    <tr><td colspan=2><cfinput type="checkbox" name="changepass" value="1" checked="#yesNoFormat(form.changepass EQ 1)#"> Force user to change password on next login.</td></tr>
                    <tr><td colspan=2><cfinput type="checkbox" name="bypass_checklist" value="1" checked="#yesNoFormat(form.bypass_checklist EQ 1)#"> This agents students apps do not need to pass the checklist when processed.</td></tr>
                </cfif>
				<cfif client.usertype EQ 1>
                    <tr><td colspan=2><cfinput type="checkbox" name="invoice_access" value="1" checked="#yesNoFormat(form.invoice_access EQ 1)#"> User has invoice access.</td></tr>
                </cfif>
				<tr>
                	<td colspan=2>&nbsp;</td>
                </tr>
				<tr>
                	<td colspan=2 bgcolor="CCCCCC"><u>Contract Information</u></td>
                </tr>
              <tr>
                <td align="right">User Entered:</td>
                <td>
					<cfoutput>#DateFormat(form.datecreated, 'mm/dd/yyyy')#</cfoutput>
                    <cfinput type="hidden" name="datecreated" value="#form.datecreated#">
                </td>
              </tr>
              <tr>
                <td align="right">Contract Received:</td>
                <td>
                    <cfif client.usertype LTE 4>
                        <cfinput type="text" name="date_contract_received" value="#dateFormat(form.date_contract_received,'mm/dd/yyyy')#" size="10" maxlength="10" mask="99/99/9999" validate="date" message="Please enter a valid Contract Received."> mm/dd/yyyy
                    <cfelse>
                        <cfoutput>#dateFormat(form.date_contract_received, 'mm/dd/yyyy')#</cfoutput>
	                    <cfinput type="hidden" name="date_contract_received" value="#form.date_contract_received#">
                    </cfif>
                </td>
              </tr>
              <tr>
                <td align="right">Active:</td>
                <td>
                    <cfif client.usertype LTE 4>
                        <cfinput type="checkbox" name="active" value="1" checked="#yesNoFormat(form.active EQ 1)#">
                    <cfelse>
                        <cfoutput>#yesNoFormat(form.active)#</cfoutput>
	                    <cfinput type="hidden" name="active" value="#form.active#">
                    </cfif>
                </td>
              </tr> 
              <tr>
                <td align="right">Date Cancelled:</td>
                <td>
                    <cfif client.usertype LTE 4>
                        <cfinput type="text" name="datecancelled" value="#dateFormat(form.datecancelled,'mm/dd/yyyy')#" size="10" maxlength="10" mask="99/99/9999" validate="date" message="Please enter a valid Date Cancelled."> mm/dd/yyyy
                    <cfelse>
						<cfoutput>#dateFormat(form.datecancelled, 'mm/dd/yyyy')#</cfoutput>
                        <cfinput type="hidden" name="datecancelled" value="#form.datecancelled#">
                    </cfif>
                </td>
              </tr>
			</table>
            
		</td>
	</tr>
</table>
    
<!---- Int. Reps ---->
<cfif form.usertype EQ 8>

    <table border="0" width="100%">
        <tr bgcolor="CCCCCC">
            <td colspan="2"><u>Billing Info</u> <input type="checkbox" name="copycontact" OnClick="CopyContact();">Copy personal information:</td>
        </tr>
        <tr>
        	<td>&nbsp;</td>
            <td><cfinput type="checkbox" name="usebilling" value="1" checked="#yesNoFormat(form.usebilling EQ 1)#">Use billing address on invoice</td>
        </tr>
      <tr>
        <td align="right">Company Name:</td>
        <td><cfinput type="text" name="billing_company" value="#billing_company#" size="40" maxlength="50"></td>
      </tr>
        <tr>
        <td align="right">Contact:</td>
        <td><cfinput type="text" name="billing_contact" value="#billing_contact#" size="40" maxlength="100"></td>
      </tr>
      <tr>
        <td align="right">Address:</td>
        <td><cfinput type="text" name="billing_address" value="#billing_address#" size="40" maxlength="100"></td>
      </tr>
      <tr>
        <td align="right"></td>
        <td><cfinput type="text" name="billing_address2" value="#billing_address2#" size="40" maxlength="100"></td>
      </tr>
      <tr>
        <td align="right">City:</td>
        <td><cfinput type="text" name="billing_city" value="#billing_city#" size="20" maxlength="100"></td>
      </tr>
      <tr>				  
        <td align="right">Country:</td>
        <td>
            <cfselect NAME="billing_country" query="country_list" value="countryid" display="countryname" selected="#form.billing_country#" queryPosition="below">
                <option value=""></option>
            </cfselect>
        </td>
        </tr>
      <tr>
        <td align="right">Postal Code (Zip):</td>
        <td><cfinput type="text" name="billing_zip" value="#billing_zip#" size="10" maxlength="20"></td>
      </tr>
      <tr>
        <td align="right">Phone:</td>
        <td><cfinput type="text" name="billing_phone" value="#billing_phone#" size="20" maxlength="20"></td>
      </tr>
      <tr>
        <td align="right">Fax:</td>
        <td><cfinput type="text" name="billing_fax" value="#billing_fax#" size="20" maxlength="20"></td>
      </tr>
      <tr>
        <td align="right">Email:</td>
        <td><cfinput type="text" name="billing_email" value="#billing_email#" size="30" maxlength="100" validate="email" message="Please enter a valid Billing Info Email."></td>
      </tr>
    </table>

</cfif>

<cfif client.usertype LTE 4 or client.usertype lt form.usertype>

    <br>
    <table width=100%>
        <tr bgcolor="CCCCCC">
            <td><u>Notes / Misc Info</u></td>
        </tr>
        <tr align="center">
            <td><cftextarea cols="100" rows="7" name="comments" value="#form.comments#" /></td>
        </tr>
    </table>

</cfif>

	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
		<td align="right"><input name="Submit" type="image" src="pics/submit.gif" border=0></td>
	</tr>
</table>

</cfform>

<cfinclude template="../table_footer.cfm">

    </td>
  </tr>
</table>
<!--- this table is so the form is not 100% width. --->