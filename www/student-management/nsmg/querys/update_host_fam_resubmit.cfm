<cfquery name="update_host_approval" datasource="MySQL">
UPDATE smg_students
SET host_fam_approved = '7', date_host_fam_approved = #CreateODBCDateTime(now())#
WHERE studentid = '#client.studentid#'
LIMIT 1
</cfquery>
<cflocation url = "../forms/place_menu.cfm">