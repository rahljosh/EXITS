<cfquery name="CaseUsers" datasource="MySql">
select distinct uar.Userid, smg_users.email, smg_users.firstname, smg_users.lastname,
smg_companies.companyshort
from user_access_rights uar
left join smg_users on smg_users.userid = uar.userid 
left join smg_companies on  smg_companies.companyid = uar.companyid
where smg_users.active = 1 and uar.usertype <= 7
order by companyshort, lastname
</cfquery>

<cfoutput>
<cfloop query="CaseUsers">
#companyshort#, #firstname#, #lastname#, #userid#, #email#<br>
</cfloop>
</cfoutput>