<Cfquery name="get_students" datasource="backup">
select studentid, programid
from smg_students
where regionassigned = 9 or 
 regionassigned = 26 or
 regionassigned = 1308
 or regionassigned = 1093
 or regionassigned = 10
 or regionassigned = 8
 or regionassigned = 1099
 or regionassigned = 1373
 or regionassigned = 1068
 or regionassigned = 1188
 or regionassigned = 1285
 or regionassigned = 1359
 or regionassigned = 1332
 or regionassigned = 1391
 or regionassigned = 1206
 or regionassigned = 1010
 or regionassigned = 1387
 or regionassigned = 1327
 or regionassigned = 1157
</Cfquery>
<cfoutput>
	<cfloop query="get_students">
		update smg_students set programid = #programid# where studentid = #studentid#<br />
	</cfloop>
</cfoutput>