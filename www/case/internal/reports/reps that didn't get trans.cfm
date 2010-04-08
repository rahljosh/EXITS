
<cfquery name="untrans_reps" datasource="caseusa">
select arearepid
from smg_students
</cfquery>

<cfoutput query="untrans_Reps">
<Cfif untrans_reps.arearepid is 0>
<cfelse>
<cfquery name="find_Reps" datasource="caseusa">
select firstname, lastname, olduserid, userid
from smg_users
where userid = #untrans_Reps.arearepid# 
</cfquery>

#olduserid# #firstname# #lastname#<br>
</cfif>
</cfoutput>
