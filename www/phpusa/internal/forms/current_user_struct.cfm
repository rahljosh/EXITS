<cfquery name="userinfo" datasource="mysql">
	SELECT users.firstname, users.lastname, users.username, users.phone, users.city, users.state, users.zip, users.country, users.dob,
		users.email, users.userid, users.usertype, users.address, users.address2, users.fax, users.password, smg_countrylist.countryname, smg_states.state as st,
	 	users.lastchange,users.datelastlogin, users.datecreated, users.occupation, users.businessname, users.cell_phone, users.work_phone, users.whocreated, users.billing_company, users.billing_contact, users.billing_address, 
		users.php_contact_name, users.php_contact_phone, users.php_contact_email,
		users.billing_address2, users.billing_city, users.active, users.billing_country, users.billing_zip, users.billing_phone, users.billing_fax, 
		users.billing_email
	FROM smg_users users
	LEFT JOIN smg_countrylist ON smg_countrylist.countryid = users.country  
	LEFT JOIN smg_states ON smg_states.id = users.state  
	WHERE userid = <cfif IsDefined('form.userid')>'#form.userid#'<cfelse>'#url.id#'</cfif>
</cfquery>

<cflock timeout=20 scope="Session" type="Exclusive">
	<cfset client.nuerror.errors = 'No'>
	<Cfset client.nuerror.firstname.display =  'style="display:none;"'>
	<cfset client.nuerror.firstname.value = '#userinfo.firstname#'>
	<cfset client.nuerror.firstname.class = 'normal'>
	<Cfset client.nuerror.lastname.display =  'style="display:none;"'>
	<cfset client.nuerror.lastname.value = '#userinfo.lastname#'>
	<cfset client.nuerror.lastname.class = 'normal'>
	<Cfset client.nuerror.email.display =  'style="display:none;"'>
	<cfset client.nuerror.email.value = '#userinfo.email#'>
	<cfset client.nuerror.email.class = 'normal'>
	<cfset client.nuerror.email.reason = 'valid'>
	<Cfset client.nuerror.address.display =  'style="display:none;"'>
	<cfset client.nuerror.address.value = '#userinfo.address#'>
	<cfset client.nuerror.address.class = 'normal'>
	<Cfset client.nuerror.city.display =  'style="display:none;"'>
	<cfset client.nuerror.city.value = '#userinfo.city#'>
	<cfset client.nuerror.city.class = 'normal'>
	<Cfset client.nuerror.state.display =  'style="display:none;"'>
	<cfset client.nuerror.state.value = '#userinfo.state#'>
	<cfset client.nuerror.state.class = 'normal'>
	<Cfset client.nuerror.zip.display =  'style="display:none;"'>
	<cfset client.nuerror.zip.value = '#userinfo.zip#'>
	<cfset client.nuerror.zip.class = 'normal'>
	<Cfset client.nuerror.username.display =  'style="display:none;"'>
	<cfset client.nuerror.username.value = '#userinfo.username#'>
	<cfset client.nuerror.username.class = 'normal'>
	<Cfset client.nuerror.password.display =  'style="display:none;"'>
	<cfset client.nuerror.password.value = '#userinfo.password#'>
	<cfset client.nuerror.password.class = 'normal'>
	<cfset client.nuerror.password.reason = ''>
	<Cfset client.nuerror.password2.display =  'style="display:none;"'>
	<cfset client.nuerror.password2.value = '#userinfo.password#'>
	<cfset client.nuerror.password2.class = 'normal'>
</cflock>