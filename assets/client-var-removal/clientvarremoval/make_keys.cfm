<cfsetting enablecfoutputonly="no">
<p>Submit a number of keys to generate in the ColdFusion Registry store. If no value is submitted, this script will create 200 keys. <span class="red">WARNING:</span> This can greatly increase your Registry size!</p>
<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
Number of keys to make: <input type="text" name="keysToMake" size="2"><br>
<input type="submit" name="Submit" value="Submit"> | <input type="reset" name="Reset">
</cfform><cfsetting enablecfoutputonly="yes">
<cfparam name="variables.keysToMake" default="200" type="numeric">
<cfif isDefined('Form.Submit')>
	<cfif val(Form.keysToMake)>
		<cfset variables.keysToMake = Form.keysToMake>
	</cfif>
	<cflock name="SetRegistryKeys" type="exclusive" timeout="3000">
		<cfloop from="1" to="#variables.keysToMake#" index="y">
		<cfset x = "xx-ccffees#y#">
			<cfregistry action="Set"
				branch="HKEY_LOCAL_MACHINE\SOFTWARE\#REQUEST.keyPath#\ColdFusion\CurrentVersion\Clients"
				entry="#x#"
				type="key">
			<cfregistry action="Set"
				branch="HKEY_LOCAL_MACHINE\SOFTWARE\#REQUEST.keyPath#\ColdFusion\CurrentVersion\Clients\#x#"
				entry="LASTVISIT"
				type="string" 
				value="{ts '2001-02-19 00:11:17'}">
			<cfregistry action="Set"
				branch="HKEY_LOCAL_MACHINE\SOFTWARE\#REQUEST.keyPath#\ColdFusion\CurrentVersion\Clients\#x#"
				entry="TIMECREATED"
				type="string" 
				value="#now()#">
			<cfregistry action="Set"
				branch="HKEY_LOCAL_MACHINE\SOFTWARE\#REQUEST.keyPath#\ColdFusion\CurrentVersion\Clients\#x#"
				entry="HITCOUNT"
				type="string" 
				value="9">
		</cfloop>
	</cflock>
<cfinclude template="get_keys.cfm">
<cfoutput>#keys_to_delete.recordCount# Key<cfif keys_to_delete.recordCount GT 1>s</cfif> Made!</cfoutput> 
</cfif>