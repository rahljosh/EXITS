<cfset programs = "167,181,200,210,172,187,190,166,189,204,231,175,192,208">

<cfloop list="#programs#" index="i">
<cfquery name="update_students" datasource="mysql">
update smg_students set active = 0 where programid = #i#
</cfquery>
</cfloop>