<cfquery name="trim_states" datasource="mysql">
select statename, id
from states
</cfquery>
<cfloop query ="trim_states">
<cfset name1 = #RTrim(statename)#>
<cfset name2= #LTrim(name1)#>
<cfquery name="update_states" datasource="mysql">
update states
	set statename = '#name2#'
where id = #id#
</cfquery>
</cfloop>