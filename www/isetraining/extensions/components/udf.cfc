<cfcomponent>

		<!---
			Determines if the site is local or if the site is live. This is
			determined by checking the server name. 
		--->
		<cffunction name="IsServerLocal" access="public" returntype="boolean" output="No" hint="Determines if the current server is local">
			<cfscript>
				// Check for local servers
				if (	
					FindNoCase("dev.student-management.com", CGI.http_host) OR 
					FindNoCase("developer", server.ColdFusion.ProductLevel) OR
					FindNoCase("119cooper", CGI.http_host) OR
					FindNoCase("111cooper", CGI.http_host)
				){
					return(true);
				} else {
					return(false);
				}
			</cfscript>
		</cffunction>
        
</cfcomponent>