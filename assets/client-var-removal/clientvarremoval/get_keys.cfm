<cfsilent>
<cflock name="GetRegistryKeys" type="exclusive" timeout="3000">
	<cfregistry action="GetAll"
		branch="HKEY_LOCAL_MACHINE\SOFTWARE\#REQUEST.keyPath#\ColdFusion\CurrentVersion\Clients"
		type="key"
		name="keys_to_delete">
</cflock>
</cfsilent>