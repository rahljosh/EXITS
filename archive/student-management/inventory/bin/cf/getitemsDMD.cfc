<cfcomponent>
	<cffunction name="Select" access="remote" returntype="any">
		<cfquery name="getItems" datasource="MySQL">
			SELECT *
			FROM inventory_items
			LEFT JOIN smg_companies ON smg_companies.companyid = inventory_items.companyid
			WHERE inventory_items.companyid = 4
		</cfquery>
	<cfreturn getItems>
	</cffunction>
</cfcomponent>
