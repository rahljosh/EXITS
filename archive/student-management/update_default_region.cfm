<cfquery name="default_company" datasource="mysql">
select companyid, regionid, userid
from user_access_rights
where regionid = 22
</cfquery>

<Cfoutput>
	<cfloop query="default_company">
	<Cfquery name="update_it" datasource="mysql">
		update smg_users
		set defaultcompany = #companyid# where userid = #userid# 
	</Cfquery>
	updated #userid# to #companyid#<br />
	</cfloop>
</Cfoutput>