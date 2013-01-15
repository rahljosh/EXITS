<cfif form.docShow is 'placement'>
	<cfinclude template="document_tracking.cfm">
<cfelseif form.docShow is 'compliance'>
	<cfinclude template="compliance_tracking.cfm">
</cfif>
    
