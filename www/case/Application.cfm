<cfapplication name="caseusa_external" clientmanagement="yes" sessionmanagement="yes" setclientcookies="yes" setdomaincookies="yes" sessiontimeout="#CreateTimeSpan(0,10,40,1)#">
<cfquery name="selectdb" datasource="caseusa">
	USE caseusa
</cfquery>
