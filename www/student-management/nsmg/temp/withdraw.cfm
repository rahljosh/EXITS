<cfquery name="students" datasource="mysql">
select smg_students.studentid, smg_students.firstname, smg_students.familylastname, smg_students.cancelreason, smg_students.canceldate, smg_students.regionassigned, 
smg_programs.programname
from smg_students
left join smg_programs on smg_programs.programid = smg_students.programid
where (smg_students.programid = 291 or smg_students.programid = 309 or smg_students.programid = 315 or smg_students.programid = 311)
and canceldate <> '' and cancelreason like '%withdraw%'
</cfquery>
<cfoutput>
<table>
	<Tr>
    	<td>ID</td><Td>First</Td><td>Last</td><Td>Cancel Date</Td><Td>Cancel Reason</Td><td>Program</td><td>Facilitator</td>
    </Tr>

<cfloop query ="students">
	<cfquery name="facilitator" datasource="mysql">
    select smg_regions.regionfacilitator, smg_users.firstname, smg_users.lastname
    from smg_regions
    left join smg_users on smg_users.userid = smg_regions.regionfacilitator
    where regionid = #regionassigned#
    </cfquery>
	<tr>
    	<Td>#studentid#</td><Td>#firstname#</td><Td>#familylastname#</td><Td>#DateFormat(canceldate,'mm/dd/yyyy')#</td><Td>#cancelreason#</td><Td>#programname#</td><Td>#facilitator.firstname# #facilitator.lastname#</Td>
    </tr>

</cfloop>
</table>
</cfoutput>