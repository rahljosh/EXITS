<br><Br><div align="Center"><br><br><br />Logging you out of the system.<br>
<img src="pics/ticky_ticky.gif"></div>

<!----<cflock timeout="30" name="#client.urltoken#" type="exclusive">
	<cfset structclear(client)>
</cflock>
<!----
<cfapplication name="smg" clientmanagement="yes" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(0,0,0,0)#">
---->
---->
<cfloop list="#GetClientVariablesList()#" index="ThisVarName">
	<cfset DeleteClientVariable(ThisVarName)>
	
</cfloop>


<meta http-equiv="Refresh" content="0;url=http://www.case-usa.org/">
