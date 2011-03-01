<cfparam name="url.curdoc" default="initial_welcome">

<cfinclude template="header.cfm">

<table align="center" width="90%" cellpadding="0" cellspacing="0"  border="0" bgcolor="#ffffff"> 
	<tr>
		<td>
			<cfif Right(URL.curdoc,4) EQ '.cfr'>
                <cfinclude template="#url.curdoc#">
            <cfelseif Right(URL.curdoc,4) NEQ '.ico'>
                <cfinclude template="#url.curdoc#.cfm">
            </cfif>
		</td>
	</tr>
</table>

<cfinclude template="footer.cfm">