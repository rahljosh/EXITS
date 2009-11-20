<cflock timeout=20 scope="Session" type="Exclusive">
	<cfset session.nuerror = structNew()>
	<cfset session.nuerror.errors = 'No'>
	
	<Cfset session.nuerror.usertype.display =  'style="display:none;"'>
	<cfset session.nuerror.usertype.value = ''>
	<cfset session.nuerror.usertype.class = 'normal'>
	
	<Cfset session.nuerror.firstname.display =  'style="display:none;"'>
	<cfset session.nuerror.firstname.value = ''>
	<cfset session.nuerror.firstname.class = 'normal'>
	<Cfset session.nuerror.lastname.display =  'style="display:none;"'>
	<cfset session.nuerror.lastname.value = ''>
	<cfset session.nuerror.lastname.class = 'normal'>
	<Cfset session.nuerror.email.display =  'style="display:none;"'>
	<cfset session.nuerror.email.value = ''>
	<cfset session.nuerror.email.class = 'normal'>
	<cfset session.nuerror.email.reason = 'valid'>
	
	<Cfset session.nuerror.businessname.display =  'style="display:none;"'>
	<cfset session.nuerror.businessname.value = ''>
	<cfset session.nuerror.businessname.class = 'normal'>

	<Cfset session.nuerror.address.display =  'style="display:none;"'>
	<cfset session.nuerror.address.value = ''>
	<cfset session.nuerror.address.class = 'normal'>
	<Cfset session.nuerror.city.display =  'style="display:none;"'>
	<cfset session.nuerror.city.value = ''>
	<cfset session.nuerror.city.class = 'normal'>
	<Cfset session.nuerror.state.display =  'style="display:none;"'>
	<cfset session.nuerror.state.value = ''>
	<cfset session.nuerror.state.class = 'normal'>
	<Cfset session.nuerror.zip.display =  'style="display:none;"'>
	<cfset session.nuerror.zip.value = ''>
	<cfset session.nuerror.zip.class = 'normal'>
	
	<Cfset session.nuerror.username.display =  'style="display:none;"'>
	<cfset session.nuerror.username.value = ''>
	<cfset session.nuerror.username.class = 'normal'>
	<cfset session.nuerror.username.reason = ''>
	
	<Cfset session.nuerror.password.display =  'style="display:none;"'>
	<cfset session.nuerror.password3.value = ''>
	<cfset session.nuerror.password.class = 'normal'>
	<cfset session.nuerror.password.reason = ''>
	
	<Cfset session.nuerror.password2.display =  'style="display:none;"'>
	<cfset session.nuerror.password2.value = ''>
	<cfset session.nuerror.password2.class = 'normal'>
</cflock>