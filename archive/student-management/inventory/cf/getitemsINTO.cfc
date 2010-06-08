<cfcomponent>
	<cffunction name="Select" access="remote" returntype="any">
		<cfquery name="getItems" datasource="MySQL">
			SELECT *
			FROM inventory_items
			LEFT JOIN smg_companies ON smg_companies.companyid = inventory_items.companyid
			WHERE inventory_items.companyid = 2 OR inventory_items.companyid = 8 OR inventory_items.companyid = 9
		</cfquery>
	<cfreturn getItems>
	</cffunction>
</cfcomponent>
