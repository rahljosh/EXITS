<br><Br><div align="Center"><br><br><br />Logging you out of the system.<br>
<img src="pics/ticky_ticky.gif"></div>

<cfloop list="#GetClientVariablesList()#" index="ThisVarName">
	<cfset DeleteClientVariable(ThisVarName)>
</cfloop>

<cflocation url="../index.cfm" addtoken="no">