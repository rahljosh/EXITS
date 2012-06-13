<Cfquery name="placeRep" datasource="mysql">
select distinct fk_student
from progress_reports

</cfquery>
<Cfoutput>
	<Cfloop query="placeRep">
        <Cfquery name="repID" datasource="mysql">
        select placeRepID
        from smg_students
        where studentid = #placeRep.fk_student#
        </Cfquery>
	
    <Cfquery name="updateReport" datasource="mysql">
    update progress_reports
    	set fk_pr_user = #repID.placerepID#
    where fk_student = #placeRep.fk_student#
    </Cfquery>
    #fk_student# #repID.placeRepID# <Br>
    </Cfloop>
</Cfoutput>
