<link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />

<cfif isdefined("url.s")>
	<cflocation url="verify.cfm?s=#url.s#" addtoken="no">
</cfif>

<CFIF not isdefined("url.curdoc")>
	<CFSET url.curdoc = "initial_welcome">
</cfif>

<!--- OPENING FROM PHP - AXIS --->
<cfif IsDefined('url.user')>
	<cfset client.usertype = '#url.user#'>
</cfif>
 
<cfinclude template="header.cfm">
<html>
<body background="pics/development.jpg">
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
	<tr>
		<td>
		<Cfif #right(url.curdoc,4)# is '.cfr'>
			<cfinclude template="#url.curdoc#">
		<cfelse>
			<cfinclude template="#url.curdoc#.cfm">	
		</Cfif>
		</td>
	</tr>
</table>
</body>
</html>
<cfinclude template="footer.cfm">