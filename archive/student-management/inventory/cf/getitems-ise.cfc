<cfcomponent>
	<cffunction name="Select" access="remote" returntype="any">
		<cfquery name="getItems" datasource="MySQL">
			SELECT *
			FROM inventory_items
			WHERE companyid = '1'
		</cfquery>
	<cfreturn getItems>
	</cffunction>
</cfcomponent>
