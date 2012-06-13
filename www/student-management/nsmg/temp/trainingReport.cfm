<cfquery name="repsWithTraining" datasource="mysql">
    select distinct s.arearepid, u.lastname, u.firstname, p.programname, sut.date_trained, sut.score, c.companyshort
    from smg_students s
    left join smg_users u on u.userid = s.arearepid
    left join smg_programs p on p.programid = s.programid
    left join smg_users_training sut on sut.user_id = s.arearepid
    left join smg_companies c on c.companyid = s.companyid
    where (s.programid = 318 or s.programid = 320 or s.programid = 330 or s.programid = 331)
    and (s.companyid < 6 or s.companyid = 12) and sut.training_id = 2
  
</cfquery> 

<cfquery name="repsWithOutTraining" datasource="MySQL">
 select  s.arearepid, u.lastname, u.firstname, p.programname, c.companyshort
    from smg_students s
    left join smg_users u on u.userid = s.arearepid
    left join smg_programs p on p.programid = s.programid
    left join smg_companies c on c.companyid = s.companyid
    where (s.programid = 318 or s.programid = 320 or s.programid = 330 or s.programid = 331)
    and arearepid > 0
    and (s.companyid < 6 or s.companyid = 12)
    AND NOT EXISTS (select  user_id
                    from smg_users_training sut
                    where sut.training_id = 2 and sut.user_id = s.arearepid)
</cfquery>

<Cfoutput>
<table>
	<Tr>
    	<th>Rep ID</th><th>First Name</th><th>Last Name</th><th>Program</th><Th>Training Date<th>Months Past 11</th>
    <tr>
<cfset dtTo = Now() />
<cfloop query="repsWithTraining">
<cfset dtFrom = ParseDateTime( "#date_trained#" ) />

<cfset dtDiff = (dtTo - dtFrom) />

<cfif #DateFormat( dtDiff, "m" )# gt 10>
	<tr>
    	<td>#arearepid#</td><td>#firstname#</td><td>#lastname#</td><td>#programname#</td><td>#DateFormat('#date_trained#', 'mm/dd/yyyy')#</td><Td>
#DateFormat( dtDiff, "m" )# Months,
#DateFormat( dtDiff, "d" )# Days</Td>
	</tr>
</cfif>
</cfloop>
<cfloop query="repsWithOutTraining">

	<tr>
    	<td>#arearepid#</td><td>#firstname#</td><td>#lastname#</td><td>#programname#</td><td>No Training on Record</td><Td>No Training on Record</Td>
	</tr>

</cfloop>
</cfoutput>