<cfcomponent>
	<cffunction name="Select" returntype="query" access="remote">
	<cfargument name="itemid" />
			<cfquery dbtype="query" name="result" datasource="mysql">
				SELECT *
				FROM inventory_items_history
				WHERE itemid = '#arguments.itemid#'
			</cfquery>
		<cfreturn result />
	</cffunction>
</cfcomponent>