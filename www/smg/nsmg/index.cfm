<link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />

<cfif not isdefined("url.curdoc")>
	<CFSET url.curdoc = "initial_welcome">
</cfif>

<cfinclude template="header.cfm">

<table align="center" width=90% cellpadding=0 cellspacing=0  border=0> 
	<tr>
		<td>
		<cfif right(url.curdoc,4) is '.cfr'>
			<cfinclude template="#url.curdoc#">
		<cfelse>
			<cfinclude template="#url.curdoc#.cfm">
		</cfif>
		</td>
	</tr>
</table>

<cfinclude template="footer.cfm">