
<cfquery name="untrans_reps" datasource="MySQL">
select arearepid
from smg_students
</cfquery>

<cfoutput query="untrans_Reps">
<Cfif untrans_reps.arearepid is 0>
<cfelse>
<cfquery name="find_Reps" datasource="MySQL">
select firstname, lastname, olduserid, userid
from smg_users
where userid = #untrans_Reps.arearepid# 
</cfquery>

#olduserid# #firstname# #lastname#<br>
</cfif>
</cfoutput>
