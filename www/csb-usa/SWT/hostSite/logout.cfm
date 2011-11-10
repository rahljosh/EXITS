<br><Br><div align="Center"><br><br><br /><h3>Logging you out of the system.</h3><br>
</div>
<h2> &nbsp;</h2>
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


<meta http-equiv="Refresh" content="0;url=http://www.csb-usa.com/SWT/hostsite.cfm">
