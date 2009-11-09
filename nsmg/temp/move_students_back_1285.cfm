<cfquery name="get_user_id_in1285" datasource="mysql">
select userid 
from user_access_rights
where regionid = 1285
</cfquery>

<cfloop query="get_user_id_in1285">
	<cfquery name="update_students" datasource="mysql">
    update smg_hosts
    set regionid = 1285
    where arearepid = #userid#
    </cfquery>
    host record updated.<br />
</cfloop>