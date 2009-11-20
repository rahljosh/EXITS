<!----Verify that email address is valid---->
<cfinclude template="../../../exitgroup/email_verify/emailLib.cfm">

<cfset session.nuerror = structNew()>
<cfset session.nuerror.errors = 'No'>

<!----check for duplicate email--->
<cfquery name="check_email" datasource="mysql">
	select email 
	from smg_users
	where email = '#form.email#' 
	and userid != '#form.userid#'
</cfquery>

<cfquery name="check_user" datasource="mysql">
	select username
	from smg_users
	where username = '#form.username#'
	and  userid != '#form.userid#'
</cfquery>

<cfif form.firstname is ''>
	<cfset session.nuerror.errors = 'Yes'>
	<Cfset session.nuerror.firstname.display =  'style="display:inline;"'>
	<cfset session.nuerror.firstname.value = '#form.firstname#'>
	<cfset session.nuerror.firstname.class = 'error'>
<cfelse>
	<Cfset session.nuerror.firstname.display =  'style="display:none;"'>
	<cfset session.nuerror.firstname.value = '#form.firstname#'>
	<cfset session.nuerror.firstname.class = 'normal'>
</cfif>

<cfif form.lastname is ''>
	<cfset session.nuerror.errors = 'Yes'>
	<Cfset session.nuerror.lastname.display =  'style="display:inline;"'>
	<cfset session.nuerror.lastname.value = '#form.lastname#'>
	<cfset session.nuerror.lastname.class = 'error'>
<cfelse>
	<Cfset session.nuerror.lastname.display =  'style="display:none;"'>
	<cfset session.nuerror.lastname.value = '#form.lastname#'>
	<cfset session.nuerror.lastname.class = 'normal'>
</cfif>

<cfif form.email EQ ''>
	<cfset session.nuerror.errors = 'Yes'>
	<Cfset session.nuerror.email.display =  'style="display:inline;"'>
	<cfset session.nuerror.email.value = '#form.email#'>
	<cfset session.nuerror.email.class = 'error'>
	<cfset session.nuerror.email.reason = 'blank'>
<cfelseif check_email.recordcount gt 0>
	<cfset session.nuerror.errors = 'yes'>
	<Cfset session.nuerror.email.display =  'style="display:inline;"'>
	<cfset session.nuerror.email.value = '#form.email#'>
	<cfset session.nuerror.email.class = 'error'>
	<cfset session.nuerror.email.reason = 'duplicate'>
<cfelse>
	<Cfset session.nuerror.email.display =  'style="display:none;"'>
	<cfset session.nuerror.email.value = '#form.email#'>
	<cfset session.nuerror.email.class = 'normal'>
	<cfset session.nuerror.email.reason = 'valid'>	
</cfif>

<!--- EMAIL <cfelse>
	<cfif #validateEmailSyntax(form.email)# is 'YES' and 
		#validateTopLevelDomain(form.email)# is 'YES' and
		#validateMXRecord(form.email)# is 'YES' >
		<Cfset session.nuerror.email.display =  'style="display:none;"'>
		<cfset session.nuerror.email.value = '#form.email#'>
		<cfset session.nuerror.email.class = 'normal'>
		<cfset session.nuerror.email.reason = 'valid'>
	<cfelse>
		<cfset session.nuerror.errors = 'yes'>
		<Cfset session.nuerror.email.display =  'style="display:inline;"'>
		<cfset session.nuerror.email.value = '#form.email#'>
		<cfset session.nuerror.email.class = 'error'>
		<cfset session.nuerror.email.reason = 'invalid'>
	</cfif>
</cfif> --->

<cfif form.address is ''>
	<cfset session.nuerror.errors = 'Yes'>
	<Cfset session.nuerror.address.display =  'style="display:inline;"'>
	<cfset session.nuerror.address.value = '#form.address#'>
	<cfset session.nuerror.address.class = 'error'>
<cfelse>
	<Cfset session.nuerror.address.display =  'style="display:none;"'>
	<cfset session.nuerror.address.value = '#form.address#'>
	<cfset session.nuerror.address.class = 'normal'>
</cfif>

<cfif form.city is ''>
	<cfset session.nuerror.errors = 'Yes'>
	<Cfset session.nuerror.city.display =  'style="display:inline;"'>
	<cfset session.nuerror.city.value = '#form.city#'>
	<cfset session.nuerror.city.class = 'error'>
<cfelse>
	<Cfset session.nuerror.city.display =  'style="display:none;"'>
	<cfset session.nuerror.city.value = '#form.city#'>
	<cfset session.nuerror.city.class = 'normal'>
</cfif>

<!--- <cfif form.state is ''>
	<cfset session.nuerror.errors = 'Yes'>
	<Cfset session.nuerror.state.display =  'style="display:inline;"'>
	<cfset session.nuerror.state.value = '#form.state#'>
	<cfset session.nuerror.state.class = 'error'>
<cfelse>
	<Cfset session.nuerror.state.display =  'style="display:none;"'>
	<cfset session.nuerror.state.value = '#form.state#'>
	<cfset session.nuerror.state.class = 'normal'>
</cfif> --->

<!--- ZIP CODE - NOT REQUIRED --->
<Cfset session.nuerror.zip.display =  'style="display:none;"'>
<cfset session.nuerror.zip.value = '#form.zip#'>
<cfset session.nuerror.zip.class = 'normal'>

<cfif form.username is ''>
	<cfset session.nuerror.errors = 'Yes'>
	<Cfset session.nuerror.username.display =  'style="display:inline;"'>
	<cfset session.nuerror.username.value = '#form.username#'>
	<cfset session.nuerror.username.class = 'error'>
	<cfset session.nuerror.username.reason = ''>
<cfelseif check_user.recordcount gt 0>
	<Cfset session.nuerror.username.display =  'style="display:inline;"'>
	<cfset session.nuerror.username.value = '#form.username#'>
	<cfset session.nuerror.username.class = 'error'>
	<cfset session.nuerror.username.reason = 'duplicate'>
<cfelse>
	<Cfset session.nuerror.username.display =  'style="display:none;"'>
	<cfset session.nuerror.username.value = '#form.username#'>
	<cfset session.nuerror.username.class = 'normal'>
	<cfset session.nuerror.username.reason = ''>
</cfif>

<!--- <cfif form.passok is 'no' or #Len(form.password3)# lte 5>
	<cfset session.nuerror.errors = 'Yes'>
	<Cfset session.nuerror.password.display =  'style="display:inline;"'>
	<cfset session.nuerror.password3.value = ''>
	<cfset session.nuerror.password.class = 'normal'>
	<cfset session.nuerror.password.class = 'error'>
	<cfset session.nuerror.password.reason = 'notsecure'>
<cfelseif form.password3 is not form.password2>
	<cfset session.nuerror.errors = 'Yes'>
	<Cfset session.nuerror.password.display =  'style="display:inline;"'>
	<cfset session.nuerror.password3.value = ''>
	<cfset session.nuerror.password2.value = ''>
	<cfset session.nuerror.password.class = 'error'>
	<cfset session.nuerror.password.reason = 'nomatch'>
<cfelse>
	<Cfset session.nuerror.password.display =  'style="display:none;"'>
	<cfset session.nuerror.password3.value = ''>
	<cfset session.nuerror.password.class = 'normal'>
	<cfset session.nuerror.password.reason = ''>
</cfif> --->

<cfoutput>
	<cfif session.nuerror.errors is 'Yes'>
	
	<cflocation url="../index.cfm?curdoc=forms/edit_user_info&id=#url.id#" addtoken="no">
<cfelse>

	<cfquery name="update_users" datasource="MySql">
		update smg_users
		set
			firstname = '#form.firstname#',
			lastname = '#form.lastname#',
			address = '#form.address#',
			address2 = '#form.address2#',
			city = '#form.city#',
			<cfif IsDefined('form.country')>
			country = '#form.country#',
			</cfif>
			<cfif IsDefined('form.state')>
			state = '#form.state#',
			</cfif>
			zip = '#form.zip#',
			dob = <cfif form.dob EQ ''>NULL<cfelse>#CreateODBCDate(dob)#</cfif>,
			
			businessname = '#form.businessname#',

			<cfif IsDefined('form.php_contact_name')>
			php_contact_name = '#form.php_contact_name#',
			php_contact_phone = '#form.php_contact_phone#',
			php_contact_email = '#form.php_contact_email#',			
			</cfif>
			
			<cfif isDefined('form.billing_company')>
			billing_company = '#form.billing_company#',
			billing_address = '#form.billing_address#',
			billing_address2 = '#form.billing_address2#',
			billing_city = '#form.billing_city#',
			billing_country = #form.billing_country#,
			billing_zip = '#form.billing_zip#',
			billing_phone = '#form.billing_phone#',
			billing_fax = '#form.billing_fax#',
			billing_contact = '#form.billing_contact#',
			billing_email = '#form.billing_email#',
			</cfif>
			
			<cfif IsDefined('form.password') AND form.password NEQ ''>
			password = '#form.password#',
			</cfif>
			email = '#form.email#',
			phone = '#form.phone#',
			fax = '#form.fax#'
		where userid = #form.userid#
		LIMIT 1
	</cfquery>

<cflocation url="../index.cfm?curdoc=forms/user_info&id=#form.userid#">
</cfif>
</cfoutput>