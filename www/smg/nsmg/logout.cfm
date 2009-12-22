
<cfloop list="#GetClientVariablesList()#" index="ThisVarName">
	<cfset temp = DeleteClientVariable(ThisVarName)>
</cfloop>

<cfoutput>
	<cflocation url="http://#cgi.http_host#/" addtoken="no">
</cfoutput>