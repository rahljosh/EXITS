<cfinclude template="host_form_header.cfm">
<Cfif isDefined('url.curdoc')>
<cfelse>
	<cfset url.curdoc = 'forms/host_fam_form'>
</Cfif>
		<cfif right(url.curdoc,4) is '.cfr'>
			<cfinclude template="#url.curdoc#">
		<cfelse>
			<cfinclude template="#url.curdoc#.cfm">
		</cfif>