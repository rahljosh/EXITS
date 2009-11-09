<cfcomponent>
	<cffunction name="Select" access="remote" returntype="any">
		<cfquery name="getItems" datasource="MySQL">
			SELECT *
			FROM inventory_items_history
			ORDER BY date DESC
		</cfquery>
	<cfreturn getItems>
	</cffunction>
</cfcomponent>
