<cfquery name="user_info" datasource="MySQL">
select firstname, lastname, address, address2, phone, phone_ext, work, work_ext,
email, fax
from smg_users
where uniqueid = '#url.user#'
</cfquery>

