<link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />
<cfif not isDefined ('client.usertype')>
	<cfset client.usertype = 0>
</cfif>
<cfif not isdefined("url.curdoc")>

	<CFSET url.curdoc = "initial_welcome">
	
</cfif>



<cfinclude template="header.cfm">
<!----
<cftry>
---->
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0> 
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

<!----
<cfcatch type="any">
	<cfinclude template="error_message.cfm">
</cfcatch>
</cftry>
---->
<cfinclude template="footer.cfm">

