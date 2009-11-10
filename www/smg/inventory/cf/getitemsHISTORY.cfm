<cfcomponent>
	<cffunction name="Select" access="remote" returntype="any">
		<cfquery name="getItems" datasource="MySQL">
			SELECT *
			FROM inventory_items_history
			WHERE itemid = '#form.itemid#'
		</cfquery>
	<cfreturn getItems>
	</cffunction>
</cfcomponent>
