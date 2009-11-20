<Cfquery name="update_php_Students" datasource="mysql">
select placerepid,arearepid, studentid
from php_students_in_program

</Cfquery>

<cfdump var="#update_php_students#">

<cfloop query="update_php_students">

<cfquery name="update" datasource="mysql">
update php_students_in_program
set arearepid = #placerepid# 
where studentid = #studentid# 
</cfquery>

</cfloop>
<Cfquery name="update_php_Students2" datasource="mysql">
select placerepid,arearepid, studentid
from php_students_in_program

</Cfquery>

<cfdump var="#update_php_students2#">