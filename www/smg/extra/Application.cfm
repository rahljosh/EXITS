<cfapplication 
	name="extra" 
    clientmanagement="yes" 
    sessionmanagement="yes" 
    sessiontimeout="#CreateTimeSpan(0,10,40,1)#">
    
<CFQUERY name="selectdb" datasource="MySQL" >
	USE smg
</CFQUERY>

<link rel="SHORTCUT ICON" href="pics/favicon.ico">
