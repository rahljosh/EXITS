<br><Br><div align="Center"><br><br><br />Logging you out of the system.<br>
<img src="../pics/ticky_ticky.gif"></div>

<cfloop list="#GetClientVariablesList()#" index="ThisVarName">
	<cfset temp = DeleteClientVariable(ThisVarName)>
</cfloop>

<cfoutput>
	<cflocation url="http://#cgi.http_host#/" addtoken="no">
</cfoutput>