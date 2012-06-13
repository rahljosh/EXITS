<cfcomponent>
    <!--- called from: reports_new/acceptance_letters.cfm, missing_documents.cfm, missing_documents_print.cfm, regional_gender.cfm, sevis_batch.cfm --->
	<cffunction name="get_programs" access="public" returntype="query">
		<cfargument name="programid_list" type="string" required="false" default="">
		<cfset var get_programs = ''>
        <cfquery name="get_programs" datasource="#application.dsn#">
            SELECT smg_programs.programid, smg_programs.programname, smg_programs.startdate, smg_programs.enddate,
            	smg_companies.companyshort, smg_companies.team_id
            FROM smg_programs
            INNER JOIN smg_companies ON smg_programs.companyid = smg_companies.companyid
            WHERE smg_programs.active = 1
            <cfif programid_list NEQ ''>
            	AND 
                	smg_programs.programid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#programid_list#" list="yes"> )
            </cfif>
            
			<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                AND
                	smg_companies.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
            <cfelse>
                AND
                	smg_companies.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
            </cfif>
            
            ORDER BY smg_programs.companyid, smg_programs.startdate DESC, smg_programs.programname
        </cfquery>
		<cfreturn get_programs>
	</cffunction>
    <!--- called from: reports_new/missing_documents.cfm, acceptance_letters.cfm, sevis_batch.cfm --->
	<cffunction name="get_intl_rep" access="public" returntype="query">
		<cfset var get_intl_rep = ''>
        <cfquery name="get_intl_rep" datasource="#application.dsn#">
            SELECT DISTINCT smg_users.userid, smg_users.businessname
            FROM smg_users 
            INNER JOIN smg_students ON smg_users.userid = smg_students.intrep
            <cfif client.companyid NEQ 5>
                AND smg_students.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            </cfif>
            ORDER BY smg_users.businessname
        </cfquery>
		<cfreturn get_intl_rep>
	</cffunction>
    <!----Called from reports/cancelled_students---->
    <cffunction name="get_all_regions" access="public" returntype="query">
		<cfset var get_all_regions = ''>
          <cfquery name="list_regions" datasource="#application.dsn#">
                SELECT smg_regions.regionid, smg_regions.regionname, smg_companies.companyid, smg_companies.team_id
                FROM smg_regions
                INNER JOIN smg_companies ON smg_regions.company = smg_companies.companyid
                WHERE 
				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    smg_companies.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelse>
                    smg_companies.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                </cfif>
                AND 
                	smg_regions.subofregion = '0'
                ORDER BY 
                	smg_companies.companyid, 
                    smg_regions.regionname
            </cfquery>
		<cfreturn get_all_regions>
	</cffunction>
</cfcomponent>