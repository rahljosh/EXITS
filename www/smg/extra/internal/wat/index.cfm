<link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />

<CFIF not isdefined("url.curdoc")>
	<CFSET url.curdoc = "initial_welcome">
</cfif>
<cfinclude template="header.cfm">

<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 bgcolor="#ffffff"> 
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
<cfinclude template="footer.cfm">