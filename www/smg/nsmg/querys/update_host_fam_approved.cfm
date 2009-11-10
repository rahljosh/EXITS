<cfquery name="update_host_approval" datasource="MySQL">
UPDATE smg_students 
SET host_fam_approved = '#client.usertype#',
	date_host_fam_approved = #CreateODBCDateTime(now())#
WHERE studentid = '#client.studentid#'
</cfquery>
<cflocation url = "../forms/place_menu.cfm">