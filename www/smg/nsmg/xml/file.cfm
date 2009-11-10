<cfquery name="deh" datasource="mysql">
select studentid 
from smg_students 
where soid LIKE CONVERT( _utf8 '%deh%'
USING latin1 )

</cfquery>