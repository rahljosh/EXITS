<cfif client.usertype LTE 4>
	<!--- Query for Office Users --->
	<cfquery name="get_regions" datasource="MySQL">
	select regionid, regionname, companyshort
	from smg_regions
	INNER JOIN smg_companies ON company = companyid
	WHERE subofregion = '0'
	<cfif #client.companyid# NEQ '5'>
		AND company = '#client.companyid#'
	</cfif>
	ORDER BY companyshort, regionname
	</cfquery> 
<cfelse>
	<!--- Query for the field / MANAGERS AND ADVISORS --->
	<cfquery name="get_regions" datasource="MySQL">
		SELECT user_access_rights.regionid, smg_regions.regionname, user_access_rights.usertype
		FROM user_access_rights
		INNER JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid
		WHERE userid = '#client.userid#' 
			AND user_access_rights.companyid = '#client.companyid#'
			AND (user_access_rights.usertype = '5' OR user_access_rights.usertype = '6')
		ORDER BY default_region DESC, regionname
	</cfquery>
</cfif>