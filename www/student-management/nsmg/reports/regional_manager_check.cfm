<cfquery name="regions" datasource="MySQL">
select regionname, regionid, company
from smg_regions
order by company
</cfquery>

The following regions have multiple managers.  Click on the mangers name to reassign regions. If no names show, there are no double assignments.<br><br>

<cfoutput query = regions>
<cfquery name="check_managers" datasource="MySQL">
select user_access_rights.userid
from user_access_rights
where user_access_rights.usertype = 5
and regionid = #regionid#
</cfquery>


	

	<cfif check_managers.recordcount gt 1>
	<strong>#regions.company# #regions.regionname#</strong><br>
		<cfloop query="check_managers">
		<cfquery name="managers_name" datasource="mysql">
		select firstname, lastname
		from smg_users
		where userid = #check_managers.userid#
		</cfquery>
		&nbsp;&nbsp;&nbsp;<a href="?curdoc=user_info&userid=#check_managers.userid#">#managers_name.firstname# #managers_name.lastname#</a><br>
		
		</cfloop>
		<br>	</cfif>
	

</cfoutput>