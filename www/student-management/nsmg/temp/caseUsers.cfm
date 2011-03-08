<cfquery name="CaseUsers" datasource="MySql">
select distinct uar.Userid, smg_users.email, smg_users.firstname, smg_users.lastname
from user_access_rights uar
left join smg_users on smg_users.userid = uar.userid 
where uar.companyid = 10 and smg_users.active = 1 and uar.usertype <= 7
order by lastname
</cfquery>

<cfoutput>
<cfloop query="CaseUsers">
#email#<br>
</cfloop>
</cfoutput>