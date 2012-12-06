<cfsetting enablecfoutputonly="yes">
<cfinclude template="get_keys.cfm">
<cflock name="KillRegistryKeys" type="exclusive" timeout="3000">
	<cfif keys_to_delete.recordCount>
		<cfoutput><p class="red">#keys_to_delete.recordCount# key<cfif keys_to_delete.recordCount GT 1>s</cfif> to delete!</p></cfoutput>
		<cfif Request.flushCtrl><cfflush></cfif>
		<cfloop query="keys_to_delete">
			<cfregistry action="Delete"
				branch="HKEY_LOCAL_MACHINE\SOFTWARE\#REQUEST.keyPath#\ColdFusion\CurrentVersion\Clients\#entry#">
			<cfoutput><span class="green">#currentrow#: #entry# deleted!</span><br /></cfoutput>
			<cfif Request.flushCtrl><cfflush></cfif>
		</cfloop> 
	<cfelse>
		<cfoutput><span class="green">No Keys To Delete!</span></cfoutput>
	</cfif>
</cflock>
<cfsetting enablecfoutputonly="no">