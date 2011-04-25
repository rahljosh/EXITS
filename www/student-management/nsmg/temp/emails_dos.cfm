<cfquery name="user_emails" datasource="mysql">
select email
from smg_hosts
where email <> ''
and active = 1
</cfquery>

<cfquery name="reps" datasource="mysql">
select email 
from smg_users
where email <> ''
and active = 1
</cfquery>

<cfdump var="#user_emails#">

<cfdump var="#reps#">