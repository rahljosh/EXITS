<Cfquery name="students_with_reps" datasource="caseusa">
select studentid, firstname, familylastname, old_stuid, arearepid
 from smg_Students
 where arearepid = 0  and (hostid <> 0) and companyid = #client.companyid#

</Cfquery>
<cfoutput>#students_with_reps.recordcount#</cfoutput><br>
<cfoutput query="students_with_reps">
#studentid# #old_stuid# #firstname# #familylastname# #arearepid#<Br>
</cfoutput>