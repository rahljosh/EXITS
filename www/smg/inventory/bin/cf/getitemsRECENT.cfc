<cfcomponent>
	<cffunction name="Select" access="remote" returntype="any">
		<cfquery name="getItems" datasource="MySQL">
			SELECT *
			FROM inventory_items_history
			LEFT JOIN inventory_items ON inventory_items.itemid = inventory_items_history.itemid
			LEFT JOIN smg_companies ON smg_companies.companyid = inventory_items.companyid
			WHERE DATE_SUB(NOW(),INTERVAL 10 DAY) <= date
		</cfquery>
	<cfreturn getItems>
	</cffunction>
</cfcomponent>
