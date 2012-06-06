select u.* from smg_users u
left outer join user_access_rights uar ON uar.userid = u.userid
where u.usertype <= 7
and u.usertype > 4
and
uar.userid is null
and password like "%temp%"
and u.companyID <= 5
and defaultcompany <= 5
and php_contact_name = ''
and dateCancelled is null
and lastlogin is null