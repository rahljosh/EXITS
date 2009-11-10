<cfquery name="get_users_in_region" datasource="mysql">
SELECT smg_users.userid, smg_users.firstname, smg_users.lastname
FROM smg_users
LEFT JOIN user_access_rights ON smg_users.userid = user_access_rights.userid
WHERE user_access_rights.regionid = 1308
ORDER BY smg_users.userid
</cfquery>

<cfoutput>

<cfloop query="get_users_in_region">
 <cfquery name="update_payments" datasource="mysql">
 update smg_rep_payments
	set companyid = 3
 where agentid = #userid# 
 </cfquery>
 User #userid# set to 3
 </cfloop>
 
 </cfoutput>