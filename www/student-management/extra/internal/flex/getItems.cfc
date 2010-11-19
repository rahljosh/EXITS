<cfcomponent>
	<cffunction name="Select" access="remote" returntype="any">
		<cfquery name="getItems" datasource="MySQL">
			SELECT hostcompanyid, name, address, city, state, zip, phone, email
			FROM extra_hostcompany
			
		</cfquery>
	<cfreturn getItems>
	</cffunction>
</cfcomponent>
