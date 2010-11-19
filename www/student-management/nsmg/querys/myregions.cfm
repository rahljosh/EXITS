<!----tackels multiple region issue---->

<cfquery name="myregions" datasource="MySQL">
select regionid, usertype
from user_access_rights
where userid = #client.userid#
</cfquery>

<!----
use this in the area you want to loop through the regions
<cfoutput>
<cfloop query="myregions">
	#myregions.regionid#
</cfloop>
</cfoutput>
---->