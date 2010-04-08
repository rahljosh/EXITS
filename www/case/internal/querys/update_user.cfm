<cfif isdefined('form.delete')>
	<span class="application_section_header">Delete User</span> 
	<div align="center"><br>
	<br>
	<Cfoutput>
	<cfset client.deleteuser = #form.userid#>
	Are you sure you want to delete the account for #form.firstname# #form.lastname#?<br><br>
	THIS CAN NOT BE UNDONE.<br>
	</div>
	<font size=-1>If this account has / had students assigned to it, make sure all students have been reassigned before deletion to avoide problems.  Failing to do so my cause serious problems with students.
	Tools are available to help in moving students from one rep to another, please use them. 
	<br><br>
	<font size=-1>If you want to retain the account information, but not have the user show up as available, click No here, uncheck 'Delete', change Active from 'Yes' to 'No', and click on next.</font><br>
	<br>
	<div align="center">
	<br><a href="querys/delete_account.cfm">Yes, delete this account.</a> </Cfoutput>| <a href="#" onclick="history.back()">No, do not delete this account.</a>
	</div>
<cfelse>

<input name="userid" type="hidden" value=#form.userid#>
<cfif isDefined('form.username')>

<cfset form.username = #Replace(form.username, '"', "", "all")#>
<cfset form.password = #Replace(form.password, '"', "", "all")#>
<cfset form.username = #Replace(form.username, "'", "", "all")#>
<cfset form.password = #Replace(form.password, "'", "", "all")#>
</cfif>
<cftransaction action="begin" isolation="SERIALIZABLE">
<cfif isDefined('form.ssn')>
	<cfif form.ssn is ''>
	You must specify a Social Security Number for this user. Please use your browswers back button and fill 
	our the Social Field.
	<cfabort>
	</cfif>
	<cfset key='BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR'>
	<cfset encryptedssn = encrypt("#form.ssn#", key, "desede", "hex")>
</cfif>
	
	<cfquery name="update_user" datasource="caseusa">
	UPDATE smg_users
		<cfif isDefined('form.username')>
			<cfif form.username is '' and form.email is ''>
			set username = '#form.lastname##form.firstname#',
			<Cfelseif form.username is ''>
			set username = '#form.email#',
			<Cfelse>
			set username = '#form.username#',
			</cfif>
		<cfelse>
		set
		</cfif>
		<cfif isDefined('form.password')>
			<cfif form.password is ''>
			password = '#form.temp_password#',
			<Cfelse>
			password = '#form.password#',
			</cfif>
		</cfif>
		firstname = '#form.firstname#',
		middlename = '#form.middlename#',
		lastname = '#form.lastname#',
		address = '#form.address#',
		address2 = '#form.address2#',
		drivers_license = '#form.drivers_license#',
		city = '#form.city#',
		<cfif form.usertype EQ 8>
			country = '#form.country#',
		<cfelse>
			state = '#form.state#',
		</cfif>
		zip = '#form.zip#',
		phone = '#form.phone#',
		work_phone = '#form.work_phone#',
		cell_phone = '#form.cell_phone#',
		email = '#form.email#',
		<cfif IsDefined('form.businessname')>
			businessname = '#form.businessname#',
		</cfif>
		<!--- BILLING FOR INTL. REPS --->
		<cfif isDefined('form.billing_company')>
			billing_company = '#form.billing_company#',
			billing_address = '#form.billing_address#',
			billing_address2 = '#form.billing_address2#',
			billing_city = '#form.billing_city#',
			billing_country = '#form.billing_country#',
			billing_zip = '#form.billing_zip#',
			billing_phone = '#form.billing_phone#',
			billing_fax = '#form.billing_fax#',
			billing_contact = '#form.billing_contact#',
			billing_email = '#form.billing_email#',
		</cfif>
		<cfif isDefined('form.usebilling')>
			usebilling = '1',
		<cfelse>
			usebilling = '0',
		</cfif>
	
		<!--- SSN FOR FIELD --->
		<cfif isDefined('form.ssn')>
			ssn = '#encryptedssn#',
		</cfif>
		
		<cfif IsDefined('form.occupation')>
			occupation = '#form.occupation#',		
		</cfif>
		
		<cfif IsDefined('form.businessphone')>
			businessphone = '#form.businessphone#',
		</cfif>
		
		fax = '#form.fax#',
		
		<cfif client.usertype lt 5>
			<cfif isDefined('form.invoiceaccess')>
			invoice_access = '1', 
			<cfelse>
			invoice_access = '0',
			</cfif>
			comments = '#Trim(form.comments)#',
		</cfif>
		<Cfif isDefined('form.active')>
			<cfif form.active is 0>
				active = '0',
				datecancelled = #now()#,
			<cfelse>
				active = '1',
				<!----datecancelled = 'null',---->
			</cfif>
		</cfif>
	
		<cfif IsDefined('form.defaultcompany')>
			defaultcompany = '#form.defaultcompany#',
		</cfif>
	
		<cfif isDefined('form.changepass')>
			changepass = '1',
		</cfif>
		
		<Cfif isDefined('form.newusertype')>
			usertype = '#form.newusertype#',
		</Cfif>
		
		<cfif form.dob is ''>
			dob = null,
		<cfelse>
			dob = #CreateODBCDate(form.dob)#,
		</cfif>	
		email2 = '#form.email2#'
	WHERE userid = '#form.userid#'
	LIMIT 1
</cfquery>
</cftransaction>

<cfif isDefined ('client.firstlogin')>
	<cfquery name="confirmed_address" datasource="caseusa">
		update smg_users
		set firstlogin = 1
		where userid = #client.userid#
	</cfquery>
		<cflocation url="index.cfm?curdoc=initial_welcome">
<cfelse>
	<cfoutput><Cflocation url="index.cfm?curdoc=user_info&userid=#form.userid#" addtoken="no"></cfoutput>
</cfif>

</cfif>