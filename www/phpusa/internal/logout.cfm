<cfloop list="#GetClientVariablesList()#" index="ThisVarName">
	<cfset temp = DeleteClientVariable(ThisVarName)>
</cfloop>
<cflocation url="../axis.cfm" addtoken="no">