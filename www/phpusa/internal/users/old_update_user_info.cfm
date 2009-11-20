<cfquery name="update_users" datasource=upi>
update smg_users
set
	firstname = '#form.firstname#',
	lastname = '#form.lastname#',
	
	address = '#form.address#',
	address2 = '#form.address2#',
	city = '#form.city#',
	<cfif form.usertype is 3>
	country = '#form.country#',
	<cfelse>
	state = '#form.state#',
	</cfif>
	zip = '#form.zip#',
	phone = '#form.phone#',
	email = '#form.email#',
		
	
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
		
	fax = '#form.fax#'
where userid = #url.id#
</cfquery>
<cfset session.nuerror = StructClear(session.nuerror)>

<cflocation url="../index.cfm?curdoc=forms/user_info&id=#url.id#">
