<cfloop list="#GetClientVariablesList()#" index="ThisVarName">
	<cfset temp = DeleteClientVariable(ThisVarName)>
</cfloop>
<cflocation url="../contactUs.cfm" addtoken="no">