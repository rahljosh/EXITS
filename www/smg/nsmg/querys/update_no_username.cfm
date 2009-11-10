<Cfquery name="get_no_user" datasource="MySQL">
select firstname, lastname, userid, email, businessname
from smg_users 
where username = ''
</Cfquery>

<Cfoutput query="get_no_user">
<Cfquery name="update_no_user" datasource="MySQL">

update smg_users
<Cfif firstname is '' and lastname is ''>
	set username = '#businessname#'
<cfelseif email is ''>
	set username = '#lastname##firstname#'
<Cfelse>
	set username = '#email#'
</cfif>
where userid = #userid#
</Cfquery>
</Cfoutput>