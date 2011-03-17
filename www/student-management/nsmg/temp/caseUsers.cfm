<cfquery name="CaseUsers" datasource="MySql">
select uar.Userid, smg_users.email, smg_users.firstname, smg_users.lastname, smg_users.datecreated, smg_users.dateAccountVerified, smg_users.datefirstlogin,
smg_companies.companyshort, smg_regions.regionname
from user_access_rights uar
left join smg_users on smg_users.userid = uar.userid 
left join smg_companies on  smg_companies.companyid = uar.companyid
left join smg_regions on smg_regions.regionid = uar.regionid
where smg_users.active = 1 and uar.usertype <= 7 and datecreated < '2011-01-01'
order by companyshort, regionname, lastname
</cfquery>

<cfoutput>
<cfloop query="CaseUsers">
#companyshort#, #regionname#, #firstname#, #lastname#, #userid#, #email#, #dateFormat(datecreated,'mm/dd/yyyy')# <br>
</cfloop>
</cfoutput>