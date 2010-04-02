<!--- IF SESSIONS ARE NOT DEFINED REDIRECT THEM TO THE LOGIN PAGE --->

<cfif NOT VAL(CLIENT.companyID)>
	<cflocation url="loginform.cfm" addtoken="no">

<cfelseif NOT VAL(CLIENT.userID)>
	<cflocation url="loginform.cfm" addtoken="no">

<cfelseif NOT VAL (CLIENT.userType)>
	<cflocation url="loginform.cfm" addtoken="no">
    
</cfif>