<cfapplication name="smg" clientmanagement="yes" sessionmanagement="yes" setdomaincookies="yes" sessiontimeout="#CreateTimeSpan(0,10,40,1)#">
<CFQUERY name="selectdb" datasource="MySQL">
	USE smg
</CFQUERY>