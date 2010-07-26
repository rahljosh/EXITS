<cfcomponent name="MangoFacade">
	<cfset variables.scope = "application" />

	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="scope" type="String" default="application" required="false" />

			<cfset variables.scope = arguments.scope />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="getMango" access="public" output="false" returntype="Mango">
		<cfif variables.scope EQ "application">
				<cfreturn application.blogManager />
			<cfelseif variables.scope EQ "session">
				<cfreturn session.blogManager />
			</cfif>
	</cffunction>

	<cffunction name="setMango" access="public" output="false" returntype="void">
		<cfargument name="mango" type="Mango" required="true" />		
			
			<cfif variables.scope EQ "application">
				<cfset application.blogManager = arguments.mango />
			<cfelseif variables.scope EQ "session">
				<cfset session.blogManager = arguments.mango />
			</cfif>
			
	</cffunction>
</cfcomponent>