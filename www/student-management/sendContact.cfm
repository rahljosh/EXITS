<cfparam name="url.sendForm" default="0" type="integer" />
<cfparam name="url.name" default="0" type="string" />
<cfparam name="url.email" default="0" type="string" />
<cfparam name="url.subject" default="0" type="string" />
<cfparam name="url.message" default="0" type="string" />

<cfif val(url.sendForm) >
	
    
	<cflocation url="index.cfm#contact?messageSent=1"
</cfif>