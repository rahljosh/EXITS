<cfcomponent>  
    <cffunction name="getResults" access="remote" returntype="any"> 
        <cfargument  name="term" default="">
        <cfquery name="getResults" datasource="#application.dsn#">
            	select  
				h.familylastname
				from smg_hosts h
       where (fatherlastname = <cfqueryparam value="#term#%" cfsqltype="cf_sql_varchar" /> )
       
         </cfquery>
        <cfset returnArray = arrayNew(1)>
        <cfloop query="getResults">
			<cfset resultStruct = StructNew() />
            <cfset resultStruct["hostID"] = hostID />
            <cfset resultStruct["familylastname"] = familylastname />
            <cfset ArrayAppend(returnArray,resultStruct) />
        </cfloop>
        <cfreturn returnArray>
    </cffunction>  
</cfcomponent>	